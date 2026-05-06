---
title: 'US2.3 - Supprimer un nourrissage'
type: 'feature'
created: '2026-04-21'
status: 'done'
---

## US2.3 : Supprimer un nourrissage

**En tant que** propriétaire de fourmis,  
**je veux** supprimer un nourrissage,  
**afin de** nettoyer l'historique.

```gherkin
Feature: Suppression d'un nourrissage

  Scenario: Suppression avec confirmation
    Given un nourrissage existe dans l'historique
    When l'utilisateur clique sur l'icône supprimer
    And une confirmation s'affiche
    And l'utilisateur confirme
    Then le nourrissage est supprimé de la liste
    And l'historique se met à jour

  Scenario: Annulation de la suppression
    Given la fenêtre de confirmation est affichée
    When l'utilisateur clique sur "Annuler"
    Then le nourrissage reste dans la liste
```
