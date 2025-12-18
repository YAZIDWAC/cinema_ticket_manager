🎬 Cinema Ticket Manager

Application mobile de gestion et réservation de tickets de cinéma développée avec Flutter et Firebase.

📱 Fonctionnalités principales
👤 Authentification

Connexion / inscription avec Firebase Authentication

Gestion des rôles :

Client

Admin

🎥 Côté Client

Consulter la liste des films

Voir les séances disponibles

Réserver des tickets

Génération d’un QR Code pour chaque réservation

Consultation du profil

Déconnexion sécurisée

🛠️ Côté Admin

Gestion des films (CRUD)

Gestion des salles

Gestion des séances

Consultation des réservations

Déconnexion

🧱 Architecture du projet

Flutter

BLoC Pattern (flutter_bloc)

Firebase

Authentication

Cloud Firestore

Architecture en couches :

presentation

domain

data

lib/
│
├── presentation/
│   ├── pages/
│   ├── blocs/
│
├── domain/
│   └── models/
│
├── data/
│   └── repositories/
│
└── main.dart

🚀 Démarrage du projet
✅ Prérequis

Flutter SDK installé

Compte Firebase

Android Studio / VS Code

📦 Installation

Cloner le projet :

git clone https://github.com/TON_USERNAME/cinema_ticket_manager.git


Aller dans le dossier :

cd cinema_ticket_manager


Installer les dépendances :

flutter pub get


Lancer l’application :

flutter run

🔥 Configuration Firebase

Créer un projet Firebase

Activer :

Authentication (Email / Password)

Cloud Firestore

Ajouter les fichiers :

google-services.json

firebase_options.dart (via FlutterFire CLI)

🔐 Gestion des rôles

Dans Firestore :

users (collection)
 └── userId
     ├── email: "ismail@gmail.com"
     └── role: "admin" 
     ├── email: "yazid@gmail.com"
     └── role: "client" 

🧠 Gestion des états

AuthBloc → Authentification

MovieBloc → Films

SalleBloc → Salles

SessionBloc → Séances

ReservationBloc → Réservations

🧪 Problèmes connus / améliorations futures

Améliorer la gestion concurrentielle des places

Ajouter paiement réel

Notifications push

Historique des réservations

Tableau de bord admin avancé

👨‍💻 Auteur

Projet réalisé par HAIROUT Ismail et ALAOUI Elyazid
Dans le cadre d’un projet Flutter + Firebase 🎓

📄 Licence

Ce projet est à but pédagogique.