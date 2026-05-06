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
- Quand l'utilisateur commence par "Demande :", traduire la demande en US/EPIC dans `_bmad-output/planning-artifacts/user-stories.md`, écrire les tests unitaires, widget et d'intégration, puis implémenter

## User Stories

Les user stories détaillées sont dans `_bmad-output/planning-artifacts/user-stories.md`

## Session 2026-05-04

### Nouveau design "Vie de la colonie" (Design v2)

**Demande :** Nouveau design basé sur `vie-de-la-colonie.html` avec :
- Couleurs sombres : background #1A1208, surface #2D1F0A, foreground #F0E6CC
- Palette : amber #E4A84A, sand #B89A6A, moss #6A9463, slate #7AABCC, terracotta #CC7A50
- Polices : DM Sans (body), PT Serif (headings, italic)
- Google Fonts : DM Sans, PT Serif, Geist, IBM Plex, Inter, Nunito, Roboto, Shantell Sans, Space Grotesk
- Radius : sm 4px, md 8px, lg 12px, full 9999px
- Typographie : xs 12px, sm 14px, lg 18px, xl 20px, 3xl 30px

**Modifications :**
1. `pubspec.yaml` : Ajout `google_fonts: ^6.2.1`
2. `docs/antology_theme.dart` : Nouvelles couleurs + polices (fichier de référence)
3. `lib/antology_theme.dart` : Mise à jour avec nouvelles couleurs + `AntologyRadius` + `darkTheme`
4. `lib/screens/colony_detail_screen.dart` : Réécriture avec nouveau design (header, stats, vitality bar, journal timeline, FAB, bottom nav)
5. `lib/main.dart` : Utilisation de `AntologyTheme.darkTheme`

**Test :** `flutter run -d windows` ✅ (Build réussi, app lancée)

**Problème rencontré :** Pixel 6 non détecté par adb (debogage USB à activer)
## EPIC & User Stories créés dans cette session :
- _bmad-output/planning-artifacts/epic-colony-life.md : EPIC 'Vie de la Colonie'
- _bmad-output/planning-artifacts/user-stories.md : US-VDC-01 à US-VDC-07 ajoutées
