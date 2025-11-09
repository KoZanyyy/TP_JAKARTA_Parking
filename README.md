# 🅿️ Application de gestion de parking

**Auteur** : CAGNON Lény

**Technologies** : Jakarta EE 10, JPA, EJB, Servlets, JSP, Bootstrap 5

## 📋 Description

Application web de gestion de parking automatisé avec 3 bornes interactives :
- **Borne 1** : Création de tickets d'entrée
- **Borne 2** : Paiement et justificatifs
- **Borne 3** : Validation de sortie

## ⚙️ Technologies

- Jakarta EE 10 (JPA, EJB, Servlets, JSP)
- Bootstrap 5 pour l'interface
- Base de données H2/MySQL/PostgreSQL

## 📁 Structure

    src/main/
    ├── java/
    │   ├── ejb/
    │   │   ├── TicketEJB.java
    │   │   └── PaiementEJB.java
    │   ├── jpa/
    │   │   ├── Ticket.java
    │   │   └── Paiement.java
    │   └── servlet/
    │       ├── Borne1Servlet.java
    │       ├── Borne2Servlet.java
    │       ├── Borne3Servlet.java
    │       └── RetourParkingServlet.java
    ├── resources/
    │   └── META-INF/
    │       └── persistence.xml
    └── webapp/
        ├── index.jsp
        └── justificatif.jsp

## 🎯 Fonctionnalités

### Borne 1 - Entrée
✅ Création illimitée de tickets  
✅ Génération numéro unique  
✅ Enregistrement date/heure d'entrée

### Borne 2 - Paiement
✅ Recherche de ticket  
✅ Calcul automatique (0,90€ / 30 secondes)  
✅ Paiements multiples (CB, espèces, mobile)  
✅ Justificatifs imprimables  
✅ Blocage tickets déjà sortis

### Borne 3 - Sortie
✅ Validation paiement complet  
✅ Vérification délai (90 secondes)  
✅ Redirection auto si paiement incomplet  
✅ Enregistrement date/heure sortie

## 🚀 Installation

1. **Cloner le projet**


git clone URL_REPO

cd parking-management


2. **Compiler**

mvn clean package


3. **Déployer**
- Copier le `.war` dans le dossier `deployments/` du serveur Jakarta EE

4. **Accéder**

http://localhost:8080/parking/


## 🎮 Utilisation

**Scénario complet :**
1. **Entrée** → Créer ticket → Noter le N°
2. **Paiement** → Saisir N° → Rechercher → Payer
3. **Sortie** → Saisir N° → Valider sortie

## 🔧 Choix techniques

- **Tarification** : 0,90€ par tranche de 30 secondes
- **Temps accéléré** : x10 (15 min réelles = 90 secondes)
- **Paiements multiples** : Autorisés avec cumul
- **Prix figé** : Après sortie, plus d'augmentation

## 🧪 Tests effectués

| Scénario | Résultat |
|----------|----------|
| Créer 5 tickets | ✅ OK |
| Payer en 2 fois | ✅ OK |
| Sortir avec paiement complet | ✅ OK |
| Sortir sans payer | ✅ Redirection borne 2 |
| Délai dépassé | ✅ Retour paiement |
| Justificatif après sortie | ✅ OK |

## 📈 Améliorations possibles

- Dashboard admin
- Export CSV
- Tests unitaires
- API REST

---

**Contact** : [votre.email@example.com]  
*Projet académique JEE - 2025*
