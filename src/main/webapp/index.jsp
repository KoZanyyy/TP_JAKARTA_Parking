<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application de gestion de parking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container-main {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 20px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 2.5rem;
            font-weight: bold;
        }
        .header p {
            margin: 10px 0 0 0;
            font-size: 1.1rem;
            opacity: 0.9;
        }
        .nav-tabs {
            border-bottom: 2px solid #667eea;
            padding: 0 20px;
            background-color: #f8f9fa;
        }
        .nav-link {
            color: #667eea;
            font-weight: 600;
            border: none;
            padding: 15px 30px;
            transition: all 0.3s ease;
        }
        .nav-link:hover {
            color: #764ba2;
            background-color: #e9ecef;
        }
        .nav-link.active {
            color: white;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px 10px 0 0;
        }
        .tab-content {
            padding: 40px;
        }
        .borne-card {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 30px;
        }
        .borne-icon {
            font-size: 3rem;
            margin-bottom: 15px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 30px;
            font-weight: 600;
            transition: transform 0.2s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-secondary {
            background-color: #6c757d;
            border: none;
            padding: 12px 30px;
            font-weight: 600;
        }
        .alert {
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .ticket-info {
            background: #e8f5e9;
            border-left: 4px solid #4caf50;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .ticket-number {
            font-size: 2rem;
            font-weight: bold;
            color: #2e7d32;
            margin: 10px 0;
        }
        input[type="number"], select {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 10px;
            width: 100%;
        }
        input[type="number"]:focus, select:focus {
            border-color: #667eea;
            box-shadow: 0 0 5px rgba(102, 126, 234, 0.3);
        }
    </style>
</head>
<body>

<div class="container-main" style="max-width: 900px; margin: 30px auto;">

    <!-- HEADER -->
    <div class="header">
        <h1>🅿️ Application de gestion de parking</h1>
        <p>Gestion complète de votre stationnement</p>
    </div>

    <!-- NAVIGATION TABS -->
    <ul class="nav nav-tabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link ${not empty numeroTicket or (empty ticketTrouve and empty succesSortie and empty erreur and empty message and empty erreurSortie and empty redirectToBorne2) ? 'active' : ''}" id="borne1-tab" data-bs-toggle="tab" data-bs-target="#borne1" type="button" role="tab">
                🚗 Entrée
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link ${not empty ticketTrouve or not empty erreur or not empty message or not empty redirectToBorne2 ? 'active' : ''}" id="borne2-tab" data-bs-toggle="tab" data-bs-target="#borne2" type="button" role="tab">
                💳 Paiement
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link ${not empty succesSortie or (not empty erreurSortie and empty redirectToBorne2) ? 'active' : ''}" id="borne3-tab" data-bs-toggle="tab" data-bs-target="#borne3" type="button" role="tab">
                🚗 Sortie
            </button>
        </li>

    </ul>



    <!-- TAB CONTENT -->
    <div class="tab-content">

        <!-- ===== BORNE 1 : ENTRÉE ===== -->
        <div class="tab-pane fade ${not empty numeroTicket or (empty ticketTrouve and empty succesSortie and empty erreur and empty message and empty erreurSortie and empty redirectToBorne2) ? 'show active' : ''}" id="borne1" role="tabpanel">
            <div class="borne-card">
                <div class="borne-icon">🎫</div>
                <h2>Borne d'Entrée</h2>
                <p>Créez un nouveau ticket pour entrer dans le parking</p>

                <!-- Formulaire toujours visible -->
                <form method="post" action="borne1">
                    <button type="submit" class="btn btn-primary btn-lg w-100">
                        Créer un Ticket
                    </button>
                </form>

                <!-- Afficher le dernier ticket créé -->
                <c:if test="${not empty numeroTicket}">
                    <div class="ticket-info">
                        <h3>✓ Ticket créé avec succès</h3>
                        <div class="ticket-number">N° ${numeroTicket}</div>
                        <p><strong>Conservez ce numéro</strong> pour le paiement et la sortie</p>
                    </div>
                </c:if>
            </div>
        </div>



        <!-- ===== BORNE 2 : PAIEMENT ===== -->
        <div class="tab-pane fade ${not empty ticketTrouve or not empty erreur or not empty message or not empty redirectToBorne2 ? 'show active' : ''}" id="borne2" role="tabpanel">
            <div class="borne-card">
                <div class="borne-icon">💳</div>
                <h2>Borne de Paiement</h2>
                <p>Consultez votre ticket et effectuez le paiement</p>

                <!-- Message d'erreur provenant de la borne 3 (paiement incomplet) -->
                <c:if test="${not empty redirectToBorne2 && not empty erreurSortie}">
                    <div class="alert alert-warning mt-3" style="background-color: #fff3e0; border-left: 4px solid #ff9800; color: #e65100;">
                        <strong>⚠️ Paiement incomplet</strong><br>
                            ${erreurSortie}<br>
                        <strong>Montant restant à payer : ${montantRestant} €</strong>
                    </div>
                </c:if>

                <form method="post" action="borne2" id="form-borne2">
                    <input type="hidden" name="action" value="rechercher">

                    <div class="form-group">
                        <label for="ticketId">Numéro de ticket :</label>
                        <!-- Pré-remplir si venant de Borne 3 -->
                        <input type="number" id="ticketId" name="ticketId" required
                               value="${not empty ticketId ? ticketId : ''}">
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg w-100">
                        Rechercher
                    </button>
                </form>

                <!-- Affichage des erreurs (autres) -->
                <c:if test="${not empty erreur && empty redirectToBorne2}">
                    <div class="alert alert-danger mt-3">${erreur}</div>
                </c:if>


                <!-- Affichage ticket actif -->
                <c:if test="${not empty ticketTrouve && empty ticketSorti && not empty montantAPayer}">
                    <div class="ticket-info" style="background: #fff3e0; border-left-color: #ff9800;">
                        <h3>✓ Ticket N° ${ticketTrouve.id}</h3>
                        <p><strong>Date d'entrée :</strong> <fmt:formatDate value="${ticketTrouve.dateEntree}" pattern="dd/MM/yyyy HH:mm:ss"/></p>
                        <p><strong>Durée :</strong> ${secondes} secondes</p>
                        <p style="font-size: 1.3rem; color: #e65100;">
                            <strong>Prix à payer : ${montantAPayer} €</strong>
                        </p>

                        <!-- Formulaire de paiement -->
                        <form method="post" action="borne2" style="margin-top: 20px;">
                            <input type="hidden" name="action" value="payer">
                            <input type="hidden" name="ticketId" value="${ticketTrouve.id}">
                            <input type="hidden" name="montant" value="${montantAPayer}">

                            <div class="form-group">
                                <label for="typePaiement">Mode de paiement :</label>
                                <select id="typePaiement" name="typePaiement" required>
                                    <option value="">-- Choisir --</option>
                                    <option value="CB">💳 Carte Bancaire</option>
                                    <option value="Especes">💵 Espèces</option>
                                    <option value="Mobile">📱 Paiement Mobile</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-primary btn-lg w-100">
                                Payer
                            </button>
                        </form>
                    </div>
                </c:if>

                <!-- Affichage après paiement -->
                <c:if test="${not empty message && empty ticketSorti}">
                    <div class="alert alert-success mt-3">
                        <strong>${message}</strong>
                    </div>
                    <c:if test="${not empty ticketTrouve}">
                        <form method="post" action="borne2">
                            <input type="hidden" name="action" value="justificatif">
                            <input type="hidden" name="ticketId" value="${ticketTrouve.id}">
                            <button type="submit" class="btn btn-secondary btn-lg w-100">
                                📄 Imprimer Justificatif
                            </button>
                        </form>
                    </c:if>
                </c:if>

                <!-- Affichage ticket sorti -->
                <c:if test="${not empty ticketTrouve && not empty ticketSorti}">
                    <div class="ticket-info" style="background: #e8f5e9; border-left-color: #4caf50;">
                        <h3>✓ Ticket N° ${ticketTrouve.id}</h3>
                        <p><strong>Date d'entrée :</strong> <fmt:formatDate value="${ticketTrouve.dateEntree}" pattern="dd/MM/yyyy HH:mm:ss"/></p>
                        <p><strong>Date de sortie :</strong> <fmt:formatDate value="${ticketTrouve.dateSortie}" pattern="dd/MM/yyyy HH:mm:ss"/></p>
                        <p style="color: #2e7d32;"><em>✓ Véhicule sorti du parking</em></p>

                        <form method="post" action="borne2" style="margin-top: 20px;">
                            <input type="hidden" name="action" value="justificatif">
                            <input type="hidden" name="ticketId" value="${ticketTrouve.id}">
                            <button type="submit" class="btn btn-secondary btn-lg w-100">
                                📄 Imprimer Justificatif
                            </button>
                        </form>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- ===== BORNE 3 : SORTIE ===== -->
        <div class="tab-pane fade ${not empty succesSortie or (not empty erreurSortie and empty redirectToBorne2) ? 'show active' : ''}" id="borne3" role="tabpanel">
            <div class="borne-card">
                <div class="borne-icon">🚗</div>
                <h2>Borne de Sortie</h2>
                <p>Validez votre sortie du parking</p>

                <!-- Affichage des erreurs (sauf celles de paiement incomplet) -->
                <c:if test="${not empty erreurSortie && empty redirectToBorne2}">
                    <div class="alert alert-danger mt-3">${erreurSortie}</div>
                </c:if>

                <!-- Formulaire de sortie (visible sauf si paiement incomplet) -->
                <c:if test="${empty succesSortie && empty redirectToBorne2}">
                    <form method="post" action="borne3">
                        <div class="form-group">
                            <label for="ticketIdSortie">Numéro de ticket :</label>
                            <input type="number" id="ticketIdSortie" name="ticketId" required>
                        </div>

                        <button type="submit" class="btn btn-primary btn-lg w-100">
                            Valider la Sortie
                        </button>
                    </form>
                </c:if>

                <!-- Affichage succès sortie -->
                <c:if test="${not empty succesSortie}">
                    <div class="ticket-info" style="background: #e8f5e9; border-left-color: #4caf50;">
                        <h3>✓ Sortie autorisée</h3>
                        <p><strong>Ticket N° ${ticketSortie.id}</strong></p>
                        <p><strong>Sortie enregistrée :</strong> <fmt:formatDate value="${ticketSortie.dateSortie}" pattern="dd/MM/yyyy HH:mm:ss"/></p>
                        <p style="font-size: 1.5rem; color: #2e7d32; margin-top: 20px;">
                            🚘 Merci de votre visite !
                        </p>

                        <!-- Bouton imprimer justificatif -->
                        <form method="post" action="borne2" style="margin-top: 20px;">
                            <input type="hidden" name="action" value="justificatif">
                            <input type="hidden" name="ticketId" value="${ticketSortie.id}">
                            <button type="submit" class="btn btn-secondary btn-lg w-100">
                                📄 Imprimer Justificatif
                            </button>
                        </form>
                    </div>
                </c:if>
            </div>
        </div>


    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Sauvegarde les données de Borne 2 et 3 dans sessionStorage
    document.addEventListener('DOMContentLoaded', function() {

        // Si on revient à l'onglet borne2 ou borne3, restaurer les données
        const borne2Data = sessionStorage.getItem('borne2Data');
        if (borne2Data) {
            const data = JSON.parse(borne2Data);
            // Restaurer les attributs (géré via JSP, les variables restent en mémoire serveur)
        }

        // Écouter les changements d'onglet
        const borne2Tab = document.getElementById('borne2-tab');
        const borne3Tab = document.getElementById('borne3-tab');

        if (borne2Tab) {
            borne2Tab.addEventListener('shown.bs.tab', function() {
                // Optionnel : ajouter un message quand on revient à Borne 2
                console.log('Onglet Borne 2 activé');
            });
        }

        if (borne3Tab) {
            borne3Tab.addEventListener('shown.bs.tab', function() {
                console.log('Onglet Borne 3 activé');
            });
        }
    });
</script>

</body>
</html>
