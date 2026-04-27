# Commandes de Tests - Antology App

## Résumé des tests

| Type | Emplacement | Tests | Couverture |
|------|------------|-------|-----------|
| Unit Tests | `test/unit/` | ~50 | Logique métier |
| Widget Tests | `test/widget/` | ~70 | UI/Composants |
| E2E Widget Tests | `test/widget/e2e_widget_test.dart` | 26 | Navigation/E2E |
| Integration Tests | `integration_test/` | 26 | App complète |
| **Total** | | **~172** | **33.5%** |

---

## Commandes de Base

### Lancer tous les tests
```bash
flutter test
```

### Lancer avec coverage
```bash
flutter test --coverage
```

### Voir les devices disponibles
```bash
flutter devices
```

---

## Tests Unitaires (test/unit/)

```bash
# Tous les tests unitaires
flutter test test/unit/

# Tests spécifiques
flutter test test/unit/colony_test.dart
flutter test test/unit/storage_service_test.dart
flutter test test/unit/food_data_test.dart
flutter test test/unit/feeding_event_test.dart
flutter test test/unit/food_preference_test.dart
```

---

## Tests Widget (test/widget/)

```bash
# Tous les tests widget
flutter test test/widget/

# Tests spécifiques
flutter test test/widget/home_screen_test.dart
flutter test test/widget/colony_detail_screen_test.dart
flutter test test/widget/add_colony_screen_test.dart
flutter test test/widget/category_food_selector_test.dart
flutter test test/widget/dialog_close_test.dart
flutter test test/widget/e2e_widget_test.dart
```

### Sur Windows
```bash
flutter test test/widget/ -d windows
flutter test test/widget/e2e_widget_test.dart -d windows
```

### Sur Chrome
```bash
flutter test test/widget/ -d chrome
```

---

## Tests E2E (test/widget/e2e_widget_test.dart)

```bash
# Lancer les 26 tests E2E
flutter test test/widget/e2e_widget_test.dart

# Sur Windows (recommandé)
flutter test test/widget/e2e_widget_test.dart -d windows
```

### Tests inclus
- HomeScreen (8 tests)
- ColonyDetailScreen (12 tests)
- AddColonyScreen (5 tests)

---

## Tests d'Intégration (integration_test/)

```bash
# Tous les tests d'intégration
flutter test integration_test/

# Sur Windows uniquement
flutter test integration_test/ -d windows
```

### Tests inclus
- Colony Navigation (4 tests)
- Colony Management (3 tests)
- Feeding Management (2 tests)
- Food Preferences (2 tests)
- Custom Categories and Foods (8 tests)
- Navigation (1 test)
- Colony Photos (9 tests)

**Note:** Ces tests nécessitent l'application complète et peuvent échouer si l'UI change.

---

## Couverture de Code

### Générer le rapport de coverage
```bash
flutter test --coverage
```

### Analyser le coverage (script personnalisé)
```bash
dart run coverage/analyze.dart
```

### Voir le rapport HTML
```bash
# Le rapport est dans coverage/coverage-report.html
start coverage/coverage-report.html
```

---

## CI/CD - GitHub Actions

Exemple de workflow pour GitHub Actions :

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info

  test-windows:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test -d windows
```

---

## Dépannage

### "No device connected"
```bash
# Vérifier les devices
flutter devices

# Lancer sans device specified
flutter test
```

### "Integration test plugin not detected"
C'est normal. Les tests fonctionnent quand même avec `flutter test`.

### Tests qui échouent
```bash
# Lancer un test spécifique pour le debug
flutter test test/widget/home_screen_test.dart -d windows

# Mode verbose
flutter test -v

#with debugger
flutter test --start-paused
```

---

## Fichiers de Rapport

| Fichier | Description |
|---------|-------------|
| `coverage/lcov.info` | Données brutes de coverage |
| `coverage/coverage-report.html` | Rapport HTML visuel |
| `coverage/analyze.dart` | Script d'analyse |
| `_bmad-output/test-artifacts/test-coverage-US8.md` | Couverture EPIC 8 |

---

## Pourcentage de Couverture Actuel

- **Global:** 33.5%
- **AddColonyScreen:** 163%
- **CategoryFoodSelector:** 133%
- **ColonyDetailScreen:** 13%
- **StorageService:** 6.2%
- **FoodData:** 25%

Pourcentage > 100% signifie que certaines lignes ont été comptées multiple fois.