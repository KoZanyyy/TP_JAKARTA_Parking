package servlet;

import ejb.TicketEJB;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jpa.Ticket;
import java.io.IOException;
import java.util.Date;

/**
 * Servlet pour la Borne 1 - Création de ticket d'entrée
 */
@WebServlet("/borne1")
public class Borne1Servlet extends HttpServlet {

    @Inject
    private TicketEJB ticketEJB;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Créer un nouveau ticket
        Ticket ticket = new Ticket();
        ticket.setDateEntree(new Date());

        // Persister en base de données via l'EJB
        ticketEJB.creer(ticket);

        // Passer le numéro du ticket à la JSP
        request.setAttribute("numeroTicket", ticket.getId());

        // Forward vers index.jsp
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
