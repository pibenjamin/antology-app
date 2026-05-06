---
title: 'US5.1 - Fermer un dialog en cliquant à l extérieur'
type: 'feature'
created: '2026-04-27'
status: 'done'
---

## US5.1 : Fermer un dialog en cliquant à l'extérieur

**En tant que** utilisateur,
**je veux** pouvoir fermer un dialog en cliquant à l'extérieur,
**afin de** naviguer plus facilement.

```gherkin
Feature: Fermeture des dialogs

  Scenario: Fermer en cliquant à l'extérieur
    Given un dialog est ouvert
    When l'utilisateur clique à l'extérieur du dialog
    Then le dialog se ferme
    And les modifications ne sont pas appliquées
```
