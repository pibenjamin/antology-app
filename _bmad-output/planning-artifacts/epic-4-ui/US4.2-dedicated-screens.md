---
title: 'US4.2 - Remplacer les popins par des écrans'
type: 'feature'
created: '2026-04-21'
status: 'done'
---

## US4.2 : Remplacer les popins par des écrans

**En tant que** utilisateur,  
**je veux** naviguer vers des écrans dédiés au lieu des popins,  
**afin d'avoir une meilleure expérience utilisateur.

```gherkin
Feature: Écrans dédiés au lieu de popins

  Scenario: Écran détail colonie
    Given l'utilisateur clique sur une colonie
    Then un écran dédié s'ouvre
    And non une popin ou bottom sheet

  Scenario: Écran ajout colonie
    Given l'utilisateur clique sur "+"
    Then un écran dédié s'ouvre

  Scenario: Navigation arrière
    Given l'utilisateur est sur un écran dédié
    When l'utilisateur clique sur retour
    Then l'écran précédent s'affiche
```
