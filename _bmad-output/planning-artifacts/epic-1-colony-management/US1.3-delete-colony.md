---
title: 'US1.3 - Supprimer une colonie'
type: 'feature'
created: '2026-04-21'
status: 'done'
---

## US1.3 : Supprimer une colonie

**En tant que** propriétaire de fourmis,  
**je veux** supprimer une colonie,  
**afin de** gérer mes colonies inactive.

```gherkin
Feature: Suppression d'une colonie

  Scenario: Suppression avec confirmation
    Given l'utilisateur est sur les détails d'une colonie
    When l'utilisateur clique sur l'icône supprimer
    And une confirmation s'affiche
    And l'utilisateur confirme
    Then la colonie est supprimée de la liste
    And l'écran se ferme

  Scenario: Annulation de la suppression
    Given la fenêtre de confirmation est affichée
    When l'utilisateur clique sur "Annuler"
    Then la colonie reste dans la liste
    And la fenêtre se ferme

  Scenario: Suppression en cascade des nourrissages
    Given une colonie a des nourrissages enregistrés
    When la colonie est supprimée
    Then tous les nourrissages de cette colonie sont supprimés
```
