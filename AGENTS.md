# AGENTS.md

## Projet

- Application Flutter liée au backend : `C:\dev\projects\fourmi-backend`

## Commandes

```bash
flutter run    # Lancer l'application
```

## Architecture

- `lib/main.dart` - Point d'entrée, routing principal
- `lib/screens/` - Écrans (HomeScreen, LoginScreen)
- `lib/models/` - Modèles de données et configuration
- `lib/services/` - Services (StorageService)

## Directives

- Toutes les demandes doivent être documentées dans `AGENT.md`
- Utiliser le format User Story / EPIC avec statut
- Fournir `flutter run` à la fin des sessions de modifications
- Conception graphique basée sur Material Design : https://docs.flutter.dev/ui/design/material
- **TDD par défaut** : Écrire les tests avant le code (test unitaire → code → test widget → refactor)
- Quand l'utilisateur commence par "Demande :", traduire la demande en US/EPIC dans `_bmad-output/planning-artifacts/user-stories.md`, écrire les tests unitaires et d'intégration, puis implémenter

## User Stories

Les user stories détaillées sont dans `_bmad-output/planning-artifacts/user-stories.md`