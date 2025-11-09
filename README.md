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


git clone https://github.com/KoZanyyy/TP_JAKARTA_Parking

cd TP_JAKARTA_Parking



2. **Compiler**

mvn clean package

3. **Déployer**
    - Utiliser l'IDE (IntelliJ/Eclipse) : Run → Deploy
    - Ou copier le fichier `.war` (dans `target/`) vers le serveur



4. **Accéder**

http://localhost:8080/parking-bornes/


## 🎮 Utilisation

**Scénario complet :**
1. **Entrée** → Créer ticket → Noter le N°
2. **Paiement** → Saisir N° → Rechercher → Payer
3. **Sortie** → Saisir N° → Valider sortie

## 🔧 Choix techniques

### Interface utilisateur - One-Page Application
**Choix :** Utilisation d'une interface à onglets (one-page) au lieu de 3 pages séparées  
**Justification :**
- Meilleure expérience utilisateur sans rechargement de page
- Simule mieux le comportement de bornes physiques interactives
- Navigation plus fluide entre les différentes bornes
- Design moderne avec Bootstrap 5 (dégradés, responsive)

### Base de données
**Choix :** H2 en mode embedded avec configuration `drop-and-create`  
**Justification :**
- Facilite le développement et les tests (pas besoin d'installer MySQL)
- Base réinitialisée à chaque démarrage pour des tests propres
- Portable et autonome (aucune configuration externe nécessaire)
- Facile à remplacer par MySQL/PostgreSQL en production

### Tarification
**Choix :** 0,90€ par tranche de 30 secondes 
**Justification :**
- Calcul par tranches plus réaliste pour un parking réel
- Évite les calculs au centime près
- Facilite les tests avec des montants significatifs

### Paiements multiples
**Choix :** Autoriser plusieurs paiements partiels avec cumul automatique  
**Justification :**
- Plus flexible pour l'utilisateur (peut payer en plusieurs fois)
- Relation `@OneToMany` entre Ticket et Paiements
- Correspond aux besoins réels d'un parking

### Gestion des erreurs
**Choix :** Redirection automatique avec pré-remplissage du formulaire  
**Justification :**
- Si sortie impossible (paiement incomplet/délai dépassé) → redirection vers borne de paiement
- Numéro de ticket pré-rempli pour faciliter l'usage
- Améliore l'expérience utilisateur

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

- Base de données permanente (qui ne se réinitialise pas au relancement de l'app)
- Amélioration de la gestion d'erreur.

---

**GitHub** : KoZanyyy
**Discord** : kozany667
*Projet académique JEE - 2025*
