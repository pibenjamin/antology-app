---
title: 'US8.2 - Définir une photo en avant'
type: 'feature'
created: '2026-04-27'
status: 'done'
---

## US8.2 : Définir une photo en avant

**En tant que** propriétaire de fourmis,
**je veux** choisir une photo en avant,
**afin qu'elle** s'affiche dans la liste des colonies.

**Critères d'Acceptation (CA) :**

- **Unique :** Une seule photo en avant par colonie à la fois.
- **Mise à jour immédiate :** La photo en avant doit s'afficher instantanément dans la liste des colonies (HomeScreen) après la sélection.
- **Interface :** Bouton "En avant" (étoile) clairement visible dans la visionneuse de photos.

**Notes Techniques :**

- **Champ :** `featuredPhoto` dans le modèle `Colony`
- **Mise à jour :** Appel à `StorageService.setFeaturedPhoto(colonyId, photoPath)` qui met à jour le champ `featuredPhoto`.

```gherkin
Feature: Photo en avant

  Scenario: Définir une photo en avant
    Given une colonie a plusieurs photos
    When l'utilisateur clique sur une photo
    And l'utilisateur clique sur "Définir en avant"
    Then cette photo devient la photo en avant
    And elle s'affiche dans la liste des colonies

  Scenario: Retirer la photo en avant
    Given une colonie a une photo en avant
    When l'utilisateur clique sur "Retirer"
    Then aucune photo en avant n'est définie
```
