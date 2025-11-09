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
import jpa.Paiement;

/**
 * Servlet pour la Borne 3 - Validation de sortie
 */
@WebServlet("/borne3")
public class Borne3Servlet extends HttpServlet {

    @Inject
    private TicketEJB ticketEJB;

    @Inject
    private PaiementEJB paiementEJB;

    // Délai autorisé après paiement (en secondes) - 15 minutes = 900 secondes, accéléré x10 = 90 secondes
    private static final long DELAI_SORTIE_SECONDES = 90;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String ticketIdStr = request.getParameter("ticketId");

            if (ticketIdStr == null || ticketIdStr.isEmpty()) {
                request.setAttribute("erreurSortie", "Veuillez saisir un numéro de ticket");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            Long ticketId = Long.parseLong(ticketIdStr);
            Ticket ticket = ticketEJB.trouver(ticketId);

            if (ticket == null) {
                request.setAttribute("erreurSortie", "Ticket n°" + ticketId + " introuvable");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            // Vérifier si le ticket est déjà sorti
            if (ticket.getDateSortie() != null) {
                request.setAttribute("erreurSortie", "Ce ticket a déjà été utilisé pour sortir");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }

            // Calculer le temps écoulé et le prix total
            Date maintenant = new Date();
            long diff = maintenant.getTime() - ticket.getDateEntree().getTime();
            long secondes = diff / 1000;
            long tranches30sec = secondes / 30;
            double prixTotal = tranches30sec * 0.90;

            // Vérifier le montant payé
            Double dejaPaye = paiementEJB.calculerTotal(ticketId);
            if (dejaPaye == null) dejaPaye = 0.0;

            double montantRestant = prixTotal - dejaPaye;

            // Si le montant n'est pas payé entièrement
            if (montantRestant > 0.01) {
                request.setAttribute("erreurSortie", "Paiement incomplet. Montant restant : " + String.format("%.2f", montantRestant) + " €");
                request.setAttribute("ticketId", ticketId);  // Pré-remplir le numéro
                request.setAttribute("montantRestant", String.format("%.2f", montantRestant));
                request.setAttribute("redirectToBorne2", true);  // Flag pour activer onglet Paiement
                request.getRequestDispatcher("/index.jsp").forward(request, response);
                return;
            }


            // Vérifier le délai depuis le dernier paiement
            Paiement dernierPaiement = paiementEJB.trouverDernierPaiement(ticketId);

            if (dernierPaiement != null) {
                long diffPaiement = maintenant.getTime() - dernierPaiement.getDatePaiement().getTime();
                long secondesDepuisPaiement = diffPaiement / 1000;

                if (secondesDepuisPaiement > DELAI_SORTIE_SECONDES) {
                    request.setAttribute("erreurSortie", "Délai de sortie dépassé (" + DELAI_SORTIE_SECONDES + " secondes). Veuillez repasser à la borne de paiement.");
                    request.setAttribute("ticketId", ticketId);
                    request.getRequestDispatcher("/index.jsp").forward(request, response);
                    return;
                }
            }

            // Tout est OK : enregistrer la sortie
            ticket.setDateSortie(maintenant);
            ticketEJB.modifier(ticket);

            // *** NOUVEAU : Récupérer les paiements et total pour les passer à la page ***
            List<Paiement> paiements = paiementEJB.trouverParTicket(ticketId);
            Double total = paiementEJB.calculerTotal(ticketId);

            request.setAttribute("succesSortie", true);
            request.setAttribute("ticketSortie", ticket);
            request.setAttribute("paiements", paiements);
            request.setAttribute("totalPaye", total);

        } catch (NumberFormatException e) {
            request.setAttribute("erreurSortie", "Format de numéro de ticket invalide");
            e.printStackTrace();
        } catch (Exception e) {
            request.setAttribute("erreurSortie", "Erreur : " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

}
