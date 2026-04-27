# Choix Architecturaux et Techniques

## Correction du Problème de Routage des Colonies (ID Dupliqués)

### Problème Identifié

Lors de la navigation vers les détails d'une colonie, l'application affichait systématiquement les informations de la colonie "Athéna", quelle que soit la colonie sélectionnée.

### Cause Profonde

La fonction `generateId()` dans `lib/services/storage_service.dart` utilisait `DateTime.now().millisecondsSinceEpoch.toString()` pour générer les identifiants de colonie. Cette méthode est insuffisante pour garantir l'unicité des IDs, surtout lorsque plusieurs objets `Colony` sont créés consécutivement (comme lors de l'initialisation des données de démonstration). Cela entraînait la création de colonies avec des IDs dupliqués, faisant en sorte que la recherche par ID renvoyait toujours la première correspondance trouvée (dans ce cas, "Athéna").

### Solution Implémentée

1.  **Ajout de la dépendance `uuid` :**
    *   La bibliothèque `uuid: ^4.0.0` a été ajoutée au fichier `pubspec.yaml`.
    *   `flutter pub get` a été exécuté pour installer la dépendance.

2.  **Mise à jour de la génération d'ID :**
    *   L'importation de `package:uuid/uuid.dart` a été ajoutée dans `lib/services/storage_service.dart`.
    *   Une instance de `Uuid` (`final _uuid = const Uuid();`) a été ajoutée à la classe `StorageService`.
    *   La méthode `generateId()` a été modifiée pour utiliser `_uuid.v4()`, assurant la génération d'UUIDs uniques.

3.  **Effacement des données existantes (sur confirmation de l'utilisateur) :**
    *   Dans la méthode `init()` de `StorageService`, des instructions ont été ajoutées pour effacer les clés `colonies`, `feedingEvents` et `foodPreferences` de `SharedPreferences`. Cette étape a été cruciale pour nettoyer les données potentiellement corrompues avec des IDs dupliqués et permettre aux nouvelles données de démonstration d'être générées avec des IDs uniques.

### Vérification et Validation

1.  **Mise à jour des tests unitaires :**
    *   Le test `StorageService - generateId should generate numeric IDs` dans `test/unit/storage_service_test.dart` a été mis à jour pour valider le format UUID v4 via une expression régulière, remplaçant l'ancienne vérification numérique.
2.  **Exécution des tests :**
    *   Toutes les suites de tests ont été exécutées avec succès après les modifications, confirmant la validité des nouvelles générations d'IDs et la non-introduction de régressions.
3.  **Vérification visuelle :**
    *   L'application a été lancée via `flutter run -d chrome`. La navigation vers les détails de différentes colonies affiche désormais les informations correctes pour chaque colonie, confirmant la résolution du problème de routage.
