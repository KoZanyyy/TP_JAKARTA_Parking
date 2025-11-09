package jpa;

import java.io.Serializable;
import java.util.Date;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

/**
 * Representation d'un ticket.
 *
 * Il s'agit d'un ticket de parking avec id, dateEntree et dateSortie.
 *
 * @author Leny_Cagnon
 *
 */
@Entity
@Table(indexes = @Index(columnList = "ticket"))
public class Ticket implements Serializable {
    /**
     * Identifiant du ticket (unique).
     *
     * Il s'agit de la clef primaire associee a l'objet persistant.
     * S'il est nul, il sera genere lors de l'ajout de la mesure dans la base de donnees.
     */
    @Id @GeneratedValue
    private long id;

    @Temporal(TemporalType.TIMESTAMP)
    private Date dateEntree;
    @Temporal(TemporalType.TIMESTAMP)
    private Date dateSortie;


    /**
     * Constructeur sans parametre obligatoire.
     */
    public Ticket() {
    }

    /**
     * Contructeur permetant de creer une nouvelle mesure.
     *
     * @param dateEntree date d'entree
     * @param dateSortie date de sortie
     */
    public Ticket( Date dateEntree, Date dateSortie) {
        this.dateEntree = dateEntree;
        this.dateSortie = dateSortie;
    }

    public long getId() {
        return id;
    }
    public Date getDateEntree() {
        return dateEntree;
    }
    public void setDateEntree(Date dateEntree) {
        this.dateEntree = dateEntree;
    }
    public Date getDateSortie() {
        return dateSortie;
    }
    public void setDateSortie(Date dateSortie) {
        this.dateSortie = dateSortie;
    }
}

