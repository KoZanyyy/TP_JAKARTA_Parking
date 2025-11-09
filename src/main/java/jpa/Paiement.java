package jpa;

import java.io.Serializable;
import java.util.Date;

import jakarta.persistence.*;

/**
 * Representation d'un paiement.
 *
 * Il s'agit d'un paiement de parking avec id, date de paiement, montant total paye et le type de paiement.
 *
 * @author Leny_Cagnon
 *
 */
@Entity
@Table(indexes = @Index(columnList = "paiement"))
public class Paiement implements Serializable {
    /**
     * Identifiant du paiement (unique).
     *
     * Il s'agit de la clef primaire associee a l'objet persistant.
     * S'il est nul, il sera genere lors de l'ajout de la mesure dans la base de donnees.
     */
    @Id @GeneratedValue
    private long id;

    @Temporal(TemporalType.TIMESTAMP)
    private Date datePaiement;

    private Double montantPaye;

    private String typePaiement;


    @ManyToOne
    @JoinColumn(name = "ticket_id", nullable = false)
    private Ticket ticket;

    /**
     * Constructeur sans parametre obligatoire.
     */
    public Paiement() {
    }

    /**
     * Contructeur permetant de creer une nouvelle mesure.
     *
     * @param datePaiement date de paiement
     * @param montantPaye montant total paye
     * @param typePaiement type de montant choisi
     */
    public Paiement(Date datePaiement, Double montantPaye, String typePaiement) {
        this.datePaiement = datePaiement;
        this.montantPaye = montantPaye;
        this.typePaiement = typePaiement;
    }
    public long getId() {
        return id;
    }
    public Date getDatePaiement() {
        return datePaiement;
    }
    public void setDatePaiement(Date datePaiement) {
        this.datePaiement = datePaiement;
    }
    public Double getMontantPaye() {
        return montantPaye;
    }
    public void setMontantPaye(Double montantPaye) {
        this.montantPaye = montantPaye;
    }
    public String getTypePaiement() {
        return typePaiement;
    }
    public void setTypePaiement(String typePaiement) {
        this.typePaiement = typePaiement;
    }

    public Ticket getTicket() {
        return ticket;
    }

    public void setTicket(Ticket ticket) {
        this.ticket = ticket;
    }

}

