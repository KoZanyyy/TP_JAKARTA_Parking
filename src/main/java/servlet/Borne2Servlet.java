package servlet;

import ejb.PaiementEJB;
import ejb.TicketEJB;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jpa.Paiement;
import jpa.Ticket;
import java.io.IOException;
import java.util.Date;
import java.util.List;

/**
 * Servlet pour la Borne 2 - Affichage ticket et paiement
 */
@WebServlet("/borne2")
public class Borne2Servlet extends HttpServlet {

    @Inject
    private TicketEJB ticketEJB;

    @Inject
    private PaiementEJB paiementEJB;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // RÉCUPÉRER L'ACTION
        String action = request.getParameter("action");

        try {
            // === ACTION 1 : RECHERCHER ===
            if ("rechercher".equals(action) || action == null) {
                rechercherTicket(request, response);

                // === ACTION 2 : PAYER ===
            } else if ("payer".equals(action)) {
                payerTicket(request, response);

                // === ACTION 3 : JUSTIFICATIF ===
            } else if ("justificatif".equals(action)) {
                genererJustificatif(request, response);
                return; // Sort de la méthode car forward vers autre JSP
            }

        } catch (Exception e) {
            request.setAttribute("erreur", "Erreur: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    // === MÉTHODE 1 : RECHERCHER ET CALCULER ===
    private void rechercherTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ticketIdStr = request.getParameter("ticketId");

        if (ticketIdStr == null || ticketIdStr.isEmpty()) {
            request.setAttribute("erreur", "Veuillez saisir un numéro de ticket");
            return;
        }

        Long ticketId = Long.parseLong(ticketIdStr);
        Ticket ticketTrouve = ticketEJB.trouver(ticketId);

        if (ticketTrouve == null) {
            request.setAttribute("erreur", "Ticket n°" + ticketId + " introuvable");
            return;
        }

        // Vérifier si le ticket est déjà sorti
        if (ticketTrouve.getDateSortie() != null) {
            request.setAttribute("ticketTrouve", ticketTrouve);
            request.setAttribute("ticketSorti", true);
            request.setAttribute("message", "Ce ticket a été utilisé pour sortir du parking. Vous pouvez demander un justificatif.");
            return;
        }

        // Calculer le temps écoulé depuis l'entrée
        Date maintenant = new Date();
        long diff = maintenant.getTime() - ticketTrouve.getDateEntree().getTime();
        long secondes = diff / 1000;

        // Calcul : 0,90€ toutes les 30 secondes
        long tranches30sec = secondes / 30;
        double prixTotal = tranches30sec * 0.90;

        // Soustraire ce qui a déjà été payé
        Double dejaPaye = paiementEJB.calculerTotal(ticketId);
        if (dejaPaye == null) dejaPaye = 0.0;

        double aReste = prixTotal - dejaPaye;

        // Le montant à payer maintenant
        double montantAPayer = Math.max(0, aReste);

        request.setAttribute("ticketTrouve", ticketTrouve);
        request.setAttribute("secondes", secondes);
        request.setAttribute("montantAPayer", String.format("%.2f", montantAPayer));
        request.setAttribute("message", "Ticket trouvé avec succès");
    }

    // === MÉTHODE 2 : ENREGISTRER LE PAIEMENT ===
    private void payerTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String ticketIdStr = request.getParameter("ticketId");
            String montantStr = request.getParameter("montant");
            String typePaiement = request.getParameter("typePaiement");

            // Vérifications basiques
            if (ticketIdStr == null || ticketIdStr.isEmpty() ||
                    montantStr == null || montantStr.isEmpty() ||
                    typePaiement == null || typePaiement.isEmpty()) {
                request.setAttribute("erreur", "Paramètres manquants pour le paiement");
                return;
            }

            // Gérer locale : remplacer virgule par point dans montant
            montantStr = montantStr.replace(',', '.');

            Long ticketId = Long.parseLong(ticketIdStr);
            Double montant = Double.parseDouble(montantStr);

            Ticket ticket = ticketEJB.trouver(ticketId);
            if (ticket == null) {
                request.setAttribute("erreur", "Ticket introuvable");
                return;
            }

            // Vérifier si le ticket est déjà sorti
            if (ticket.getDateSortie() != null) {
                request.setAttribute("erreur", "Ce ticket a déjà été utilisé pour sortir du parking. Aucun paiement supplémentaire n'est possible.");
                return;
            }

            // Créer le paiement
            Paiement paiement = new Paiement();
            paiement.setDatePaiement(new Date());
            paiement.setMontantPaye(montant);
            paiement.setTypePaiement(typePaiement);
            paiement.setTicket(ticket);

            paiementEJB.creer(paiement);

            System.out.println("Paiement enregistré : " + montant + "€ en " + typePaiement);

            // Recalculer le montant restant après paiement
            Date maintenant = new Date();
            long diff = maintenant.getTime() - ticket.getDateEntree().getTime();
            long secondes = diff / 1000;

            long tranches30sec = secondes / 30;
            double prixTotal = tranches30sec * 0.90;

            Double dejaPaye = paiementEJB.calculerTotal(ticketId);
            if (dejaPaye == null) dejaPaye = 0.0;

            double montantAPayer = Math.max(0, prixTotal - dejaPaye);

            // Passer les infos à la JSP
            request.setAttribute("ticketTrouve", ticket);
            request.setAttribute("secondes", secondes);
            request.setAttribute("montantAPayer", String.format("%.2f", montantAPayer));
            request.setAttribute("message", "✓ Paiement de " + montant + "€ enregistré avec succès !");

        } catch (NumberFormatException e) {
            request.setAttribute("erreur", "Format numérique invalide pour le ticket ou le montant");
            e.printStackTrace();
        }
    }

    // === MÉTHODE 3 : GÉNÉRER LE JUSTIFICATIF ===
    private void genererJustificatif(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long ticketId = Long.parseLong(request.getParameter("ticketId"));

        Ticket ticket = ticketEJB.trouver(ticketId);

        if (ticket == null) {
            request.setAttribute("erreur", "Ticket introuvable");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        List<Paiement> paiements = paiementEJB.trouverParTicket(ticketId);
        Double total = paiementEJB.calculerTotal(ticketId);

        request.setAttribute("ticket", ticket);
        request.setAttribute("paiements", paiements);
        request.setAttribute("totalPaye", total);

        // Forward vers justificatif.jsp
        request.getRequestDispatcher("/justificatif.jsp").forward(request, response);
    }

}
