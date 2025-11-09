package ejb;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jpa.Paiement;
import jpa.Ticket;
import java.util.Date;
import java.util.List;

@Stateless
public class PaiementEJB {

    @PersistenceContext(unitName = "ParkingPU")
    private EntityManager em;

    /**
     * Créer un nouveau paiement
     */
    public void creer(Paiement paiement) {
        em.persist(paiement);
    }

    /**
     * Trouver un paiement par son ID
     */
    public Paiement trouver(Long id) {
        return em.find(Paiement.class, id);
    }

    /**
     * Trouver le dernier paiement d'un ticket
     */
    public Paiement trouverDernierPaiement(Long ticketId) {
        TypedQuery<Paiement> query = em.createQuery(
                "SELECT p FROM Paiement p WHERE p.ticket.id = :ticketId ORDER BY p.datePaiement DESC",
                Paiement.class
        );
        query.setParameter("ticketId", ticketId);
        query.setMaxResults(1);

        List<Paiement> resultats = query.getResultList();
        return resultats.isEmpty() ? null : resultats.get(0);
    }

    /**
     * Trouver tous les paiements d'un ticket
     */
    public List<Paiement> trouverParTicket(Long ticketId) {
        TypedQuery<Paiement> query = em.createQuery(
                "SELECT p FROM Paiement p WHERE p.ticket.id = :ticketId ORDER BY p.datePaiement",
                Paiement.class
        );
        query.setParameter("ticketId", ticketId);
        return query.getResultList();
    }

    /**
     * Calculer le total des paiements pour un ticket
     */
    public Double calculerTotal(Long ticketId) {
        TypedQuery<Double> query = em.createQuery(
                "SELECT SUM(p.montantPaye) FROM Paiement p WHERE p.ticket.id = :ticketId",
                Double.class
        );
        query.setParameter("ticketId", ticketId);
        Double total = query.getSingleResult();
        return total != null ? total : 0.0;
    }

    /**
     * Trouver les paiements par type
     */
    public List<Paiement> trouverParType(String typePaiement) {
        TypedQuery<Paiement> query = em.createQuery(
                "SELECT p FROM Paiement p WHERE p.typePaiement = :type ORDER BY p.datePaiement DESC",
                Paiement.class
        );
        query.setParameter("type", typePaiement);
        return query.getResultList();
    }

    /**
     * Trouver les paiements entre deux dates
     */
    public List<Paiement> trouverParPeriode(Date debut, Date fin) {
        TypedQuery<Paiement> query = em.createQuery(
                "SELECT p FROM Paiement p WHERE p.datePaiement BETWEEN :debut AND :fin ORDER BY p.datePaiement",
                Paiement.class
        );
        query.setParameter("debut", debut);
        query.setParameter("fin", fin);
        return query.getResultList();
    }
}
