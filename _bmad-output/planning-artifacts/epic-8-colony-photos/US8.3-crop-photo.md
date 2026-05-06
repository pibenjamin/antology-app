---
title: 'US8.3 - Rogner une photo au format carré'
type: 'feature'
created: '2026-04-27'
status: 'done'
---

## US8.3 : Rogner une photo au format carré

**En tant que** propriétaire de fourmis,
**je veux** rogner mes photos au format carré,
**afin d'avoir** une affiche uniforme.

**Critères d'Acceptation (CA) :**

- **Format forcé :** Le rognage doit être verrouillé au format carré (1:1).
- **Aperçu :** L'utilisateur doit voir un aperçu en temps réel avant de valider le rognage.
- **Confirmation :** Boutons "Annuler" et "Valider" clairement identifiés.
- **UX :** `toolbarTitle="Rogner en carré"` dans la toolbar.

**Notes Techniques :**

- **Package :** `image_cropper` (version ^8.0.2)
- **Configuration (Android/iOS/Web) :**
  - `uiSettings`: `AndroidUiSettings(lockAspectRatio: true)`, `IOSUiSettings(aspectRatioLockEnabled: true)`, `WebUiSettings(context: context, ...)`
  - `aspectRatio`: `CropAspectRatio(ratioX: 1, ratioY: 1)`
- **Limitation (Desktop)**: Pour les plateformes Desktop (Windows, macOS, Linux), l'image est ajoutée directement sans rognage car `image_cropper` ne fournit pas d'implémentation native pour ces plateformes.

```gherkin
Feature: Rogner les photos

  Scenario: Rogner une photo au format carré
    Given l'utilisateur ajoute une photo
    When l'outil de rognage s'ouvre
    And l'utilisateur ajuste le cadre carré
    And l'utilisateur valide
    Then la photo est rognée au format carré
    And la photo est ajoutée à la colonie
```
