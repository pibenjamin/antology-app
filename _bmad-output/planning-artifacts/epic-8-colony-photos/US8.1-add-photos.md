---
title: 'US8.1 - Ajouter des photos à une colonie'
type: 'feature'
created: '2026-04-27'
status: 'done'
---

## US8.1 : Ajouter des photos à une colonie

**En tant que** propriétaire de fourmis,
**je veux** ajouter des photos à ma colonie,
**afin de** mieux identifier visuellement mes colonies.

**Critères d'Acceptation (CA) :**

- **Formats supportés :** L'application doit accepter les images aux formats JPEG et PNG.
- **Taille maximale :** Limiter la taille des images à 5 Mo pour optimiser le stockage local.
- **Compression :** Compresser automatiquement les images (qualité 80%) avant le stockage pour éviter une surcharge de `SharedPreferences`.
- **Interface :** Afficher un indicateur de chargement (spinner) pendant la compression et l'enregistrement.
- **Feedback :** Afficher un message de succès ou d'erreur après l'ajout.

**Notes Techniques :**

- **Package :** `image_picker` (version ^1.1.2)
- **Stockage :** Base64 dans `SharedPreferences` (clé `photos` du tableau `Colony`)
- **API Flutter :**
  - `ImagePicker().pickImage(source: ImageSource.gallery)`
  - `ImagePicker().pickImage(source: ImageSource.camera)`

```gherkin
Feature: Photos des colonies

  Scenario: Ajouter une photo depuis la galerie
    Given l'utilisateur est sur l'écran de détail d'une colonie
    When l'utilisateur clique sur "Ajouter une photo"
    And l'utilisateur choisit une image depuis la galerie
    Then la photo est ajoutée à la liste des photos

  Scenario: Ajouter une photo depuis l'appareil
    Given l'utilisateur est sur l'écran de détail d'une colonie
    When l'utilisateur clique sur "Prendre une photo"
    And l'utilisateur prend une photo
    Then la photo est ajoutée à la liste des photos

  Scenario: Voir la galerie de photos
    Given une colonie a des photos
    When l'utilisateur consulte la colonie
    Then toutes les photos sont affichées dans une grille
```
