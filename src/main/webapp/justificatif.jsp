<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Justificatif de Paiement - Parking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .justificatif-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            max-width: 800px;
            margin: 30px auto;
        }
        .justificatif-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 20px;
            text-align: center;
        }
        .justificatif-header h1 {
            margin: 0;
            font-size: 2rem;
            font-weight: bold;
        }
        .justificatif-body {
            padding: 40px;
        }
        .ticket-section {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        .ticket-section h3 {
            color: #667eea;
            margin-bottom: 15px;
            font-weight: 600;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            padding: 8px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        .info-label {
            font-weight: 600;
            color: #333;
        }
        .info-value {
            color: #666;
        }
        .montant-total {
            font-size: 1.5rem;
            font-weight: bold;
            color: #27ae60;
            padding: 20px;
            background: #e8f5e9;
            border-radius: 8px;
            text-align: center;
            margin: 20px 0;
        }
        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        table thead {
            background-color: #667eea;
            color: white;
        }
        table th, table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        table tbody tr:hover {
            background-color: #f5f5f5;
        }
        .actions {
            margin-top: 30px;
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn-action {
            padding: 12px 30px;
            font-weight: 600;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-print {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-print:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-return {
            background-color: #6c757d;
            color: white;
        }
        .btn-return:hover {
            background-color: #5a6268;
        }
        .status-paid {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 5px 10px;
            border-radius: 5px;
            font-weight: 600;
        }
        .status-exited {
            background: #e3f2fd;
            color: #1565c0;
            padding: 5px 10px;
            border-radius: 5px;
            font-weight: 600;
        }
        @media print {
            body {
                background: white;
            }
            .justificatif-container {
                box-shadow: none;
                margin: 0;
            }
            .actions {
                display: none;
            }
        }
        .error-message {
            background-color: #ffebee;
            border: 2px solid #e74c3c;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            color: #c0392b;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="justificatif-container">

    <!-- HEADER -->
    <div class="justificatif-header">
        <h1>📄 Justificatif de Paiement</h1>
        <p>Parking Management System</p>
    </div>

    <!-- BODY -->
    <div class="justificatif-body">

        <c:if test="${empty ticket}">
            <div class="error-message">
                <h3>❌ Erreur</h3>
                <p>Ticket introuvable. Veuillez vérifier le numéro et réessayer.</p>
            </div>
        </c:if>

        <c:if test="${not empty ticket}">

            <!-- SECTION : INFORMATIONS TICKET -->
            <div class="ticket-section">
                <h3>📋 Informations du Ticket</h3>
                <div class="info-row">
                    <span class="info-label">Numéro de ticket :</span>
                    <span class="info-value" style="font-weight: bold; color: #667eea; font-size: 1.2rem;">N° ${ticket.id}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Date d'entrée :</span>
                    <span class="info-value"><fmt:formatDate value="${ticket.dateEntree}" pattern="dd/MM/yyyy HH:mm:ss"/></span>
                </div>
                <c:if test="${not empty ticket.dateSortie}">
                    <div class="info-row">
                        <span class="info-label">Date de sortie :</span>
                        <span class="info-value"><fmt:formatDate value="${ticket.dateSortie}" pattern="dd/MM/yyyy HH:mm:ss"/></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Statut :</span>
                        <span class="status-exited">✓ Sorti du parking</span>
                    </div>
                </c:if>
            </div>

            <!-- SECTION : PAIEMENTS -->
            <div class="ticket-section">
                <h3>💳 Paiements Effectués</h3>

                <c:if test="${empty paiements}">
                    <p style="color: #999;">Aucun paiement enregistré pour ce ticket.</p>
                </c:if>

                <c:if test="${not empty paiements}">
                    <table>
                        <thead>
                        <tr>
                            <th>Date du paiement</th>
                            <th>Montant</th>
                            <th>Mode de paiement</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="paiement" items="${paiements}">
                            <tr>
                                <td><fmt:formatDate value="${paiement.datePaiement}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                <td style="font-weight: 600; color: #27ae60;">${paiement.montantPaye} €</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${paiement.typePaiement == 'CB'}">💳 Carte Bancaire</c:when>
                                        <c:when test="${paiement.typePaiement == 'Especes'}">💵 Espèces</c:when>
                                        <c:when test="${paiement.typePaiement == 'Mobile'}">📱 Paiement Mobile</c:when>
                                        <c:otherwise>${paiement.typePaiement}</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>

            <!-- SECTION : TOTAL PAYÉ -->
            <div class="montant-total">
                <div style="font-size: 0.9rem; color: #27ae60; margin-bottom: 5px;">Total payé</div>
                <div>${totalPaye} €</div>
                <span class="status-paid">✓ Paiement validé</span>
            </div>

            <!-- SECTION : DERNIER PAIEMENT -->
            <div class="ticket-section">
                <h3>🕐 Dernier Paiement</h3>
                <c:if test="${not empty paiements}">
                    <div class="info-row">
                        <span class="info-label">Date :</span>
                        <span class="info-value"><fmt:formatDate value="${paiements[paiements.size() - 1].datePaiement}" pattern="dd/MM/yyyy HH:mm:ss"/></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Montant :</span>
                        <span class="info-value" style="font-weight: 600; color: #27ae60;">${paiements[paiements.size() - 1].montantPaye} €</span>
                    </div>
                </c:if>
                <c:if test="${empty paiements}">
                    <p style="color: #999;">Aucun paiement pour ce ticket.</p>
                </c:if>
            </div>

        </c:if>

    </div>

    <!-- ACTIONS -->
    <div class="actions">
        <button onclick="window.print()" class="btn-action btn-print">
            🖨️ Imprimer
        </button>
        <button onclick="window.location.href='index.jsp'" class="btn-action btn-return">
            ← Retour au parking
        </button>
    </div>



</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
