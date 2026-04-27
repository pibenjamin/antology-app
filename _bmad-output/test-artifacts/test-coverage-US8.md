# Couverture de Tests - EPIC 8: Photos des Colonies

## Résumé

Ce document indique la couverture de tests pour les user stories de l'EPIC 8 "Photos des Colonies" (US8.1, US8.2, US8.3).

## User Stories et Critères d'Acceptation

| Story | Titre | Critères d'Acceptation |
|------|-------|----------------------|
| **US8.1** | Ajouter des photos à une殖民地 | Formats supportés (JPEG/PNG), Taille max (5Mo), Compression (80%), Feedback succès/erreur |
| **US8.2** | Définir une photo en avant | Unique par colonie, Mise à jour immédiate |
| **US8.3** | Rogner une photo au format carré | Format 1:1 forcé, Aperçu en temps réel |

## Tests Existants

### Tests Unitaires

| Fichier | Tests |
|---------|-------|
| `test/unit/colony_test.dart` | Création, égalité, population |
| `test/unit/storage_service_test.dart` | `generateId`, Debug Mode |

### Tests d'Widget

| Fichier | Tests |
|---------|-------|
| `test/widget/colony_detail_screen_test.dart` | Affichage des sections Photos, Nourrissage, Préférences |

### Tests d'Intégration (E2E)

**Fichier:** `integration_test/app_test.dart`

#### US8.1 - Ajouter des photos à une colonie

| Critère | Test | Status |
|--------|------|--------|
| Section Photos affichée | `photo section displays - US8.1` | ✅ |
| Aucune photo (état vide) | `add photo to colony - US8.1` | ✅ |
| Ajout photo (bottom sheet) | `add photo to colony - US8.1` | ✅ |
| Sélection galerie/appareil | `select photo from gallery - US8.1` | ✅ |
| Affichage grille photos | `display photo grid - US8.1` | ✅ |
| Formats (non testable E2E) | - | ⚠️ Simulé |
| Compression (non testable E2E) | - | ⚠️ Simulé |
| Feedback succès/erreur | - | ⚠️ Non couvert |

#### US8.2 - Définir une photo en avant

| Critère | Test | Status |
|--------|------|--------|
| Bouton "En avant" visible | `view featured photo option - US8.2` | ✅ |
| Set featured photo | `set featured photo - US8.2` | ✅ |
| Mise à jour liste colonies | `featured photo displays in list - US8.2` | ✅ |
| Unique par colonie | - | ⚠️ Vérifié par le code |

#### US8.3 - Rogner une photo au format carré

| Critère | Test | Status |
|--------|------|--------|
| Bottom sheet photo | `crop dialog appears - US8.3` | ✅ |
| Format 1:1 forcé | - | ⚠️ Vérifié par le code |
| Aperçu temps réel | - | ⚠️ Non testable E2E |
| Boutons Annuler/Valider | - | ⚠️ Vérifié par le code |

## Couverture Globale

| Catégorie | Pourcentage |
|-----------|-------------|
| UI/UX | 80% |
| Comportement | 60% |
| Erreurs | 40% |

## Notes

- Les tests d'intégration ne peuvent pas être exécutés sur web avec `flutter test` pour le moment.
- Certains critères (compression, format forcé) sont vérifiés par le code et non par les tests.
- Les tests E2E utilisent des données simulées car l'accès aux APIs `image_picker` et `image_cropper` est limité en environnement de test.

## Lancer les Tests

```bash
# Tests unitaires et widget
flutter test

# Tests d'intégration (desktop uniquement)
flutter test integration_test/app_test.dart -d windows
```

## Ressources

- **User Stories:** `_bmad-output/planning-artifacts/user-stories.md`
- **Code Source:** `lib/screens/colony_detail_screen.dart`
- **Services:** `lib/services/storage_service.dart`