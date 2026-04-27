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

## Implémentation du Rognage d'Image (US8.3)

### Objectif

Permettre aux utilisateurs de rogner les photos au format carré avant de les ajouter à une colonie pour une présentation uniforme.

### Solution Implémentée

La fonctionnalité de rognage a été intégrée dans la méthode `_addPhoto` de `lib/screens/colony_detail_screen.dart` en utilisant le package `image_cropper` avec une logique conditionnelle en fonction de la plateforme.

1.  **Configuration Web :**
    *   Pour la plateforme Web (`kIsWeb`), `WebUiSettings` est utilisé avec une configuration de rognage de style `dialog` et un `viewPort` carré.
    *   Les balises `<link>` et `<script>` de `cropperjs` ont été ajoutées dans le `<head>` de `web/index.html` pour activer la bibliothèque JavaScript sous-jacente.

2.  **Configuration Mobile (Android/iOS) :**
    *   Pour les plateformes Android et iOS (`Platform.isAndroid || Platform.isIOS`), `AndroidUiSettings` et `IOSUiSettings` sont utilisés respectivement pour configurer l'interface de rognage native.
    *   Le rognage est verrouillé au format carré (`lockAspectRatio: true` et `aspectRatioLockEnabled: true`).
    *   La barre de titre de l'outil de rognage est définie sur "Rogner en carré".

3.  **Gestion des Plateformes Non Supportées (Desktop) :**
    *   Pour les plateformes non mobiles et non web (comme Windows, macOS, Linux), la fonction `_addPhoto` ajoute directement l'image sélectionnée sans passer par l'outil de rognage. Cela est dû à l'absence d'implémentation native de `image_cropper` pour ces plateformes.

### Vérification et Validation

1.  **Tests sur Web :**
    *   Le rognage a été vérifié sur Chrome (`flutter run -d chrome`), confirmant que l'interface de rognage apparaît et fonctionne correctement après l'ajout des dépendances `cropperjs` dans `web/index.html`.

2.  **Tests sur Android :**
    *   L'application a été lancée sur un émulateur Android (`flutter run -d emulator-5554`). Le rognage a été testé avec succès, l'interface native s'affichant et permettant le rognage carré des images.

3.  **Limitations connues :**
    *   Le rognage d'image n'est pas disponible nativement sur les plateformes desktop (Windows, macOS, Linux) avec le package `image_cropper`. Les images sont ajoutées sans rognage sur ces plateformes.
