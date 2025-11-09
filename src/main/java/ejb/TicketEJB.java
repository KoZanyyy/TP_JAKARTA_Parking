package ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jpa.Ticket;
import jpa.Paiement;
import java.util.List;

@Stateless
public class TicketEJB {

    @PersistenceContext(unitName = "ParkingPU")
    private EntityManager em;

    /**
     * Créer un nouveau ticket dans la base de données
     */
    public void creer(Ticket ticket) {
        em.persist(ticket);
    }

    /**
     * Trouver un ticket par son ID
     */
    public Ticket trouver(Long id) {
        return em.find(Ticket.class, id);
    }

    /**
     * Mettre à jour un ticket existant
     */
    public void modifier(Ticket ticket) {
        em.merge(ticket);
    }

    /**
     * Récupérer tous les paiements d'un ticket
     */
    public List<Paiement> trouverPaiements(Long ticketId) {
        TypedQuery<Paiement> query = em.createQuery(
                "SELECT p FROM Paiement p WHERE p.ticket.id = :ticketId ORDER BY p.datePaiement",
                Paiement.class
        );
        query.setParameter("ticketId", ticketId);
        return query.getResultList();
    }

    /**
     * Calculer le montant total payé pour un ticket
     */
    public Double calculerMontantTotal(Long ticketId) {
        TypedQuery<Double> query = em.createQuery(
                "SELECT SUM(p.montantPaye) FROM Paiement p WHERE p.ticket.id = :ticketId",
                Double.class
        );
        query.setParameter("ticketId", ticketId);
        Double total = query.getSingleResult();
        return total != null ? total : 0.0;
    }

    /**
     * Récupérer tous les tickets (pour administration)
     */
    public List<Ticket> trouverTous() {
        TypedQuery<Ticket> query = em.createQuery(
                "SELECT t FROM Ticket t ORDER BY t.dateEntree DESC",
                Ticket.class
        );
        return query.getResultList();
    }

    /**
     * Supprimer un ticket
     */
    public void supprimer(Long id) {
        Ticket ticket = trouver(id);
        if (ticket != null) {
            em.remove(ticket);
        }
    }
}
