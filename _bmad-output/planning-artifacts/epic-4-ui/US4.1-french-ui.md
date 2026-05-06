---
title: 'US4.1 - Application entièrement en français'
type: 'feature'
created: '2026-04-21'
status: 'done'
---

## US4.1 : Application entièrement en français

**En tant que** utilisateur francophone,  
**je veux** que l'application soit en français,  
**afin de** faciliter mon utilisation.

```gherkin
Feature: Interface en français

  Scenario: Textes en français
    Given l'application est chargée
    Then tous les textes sont en français
    And tous les labels sont en français
    And tous les boutons sont en français

  Scenario: Navigation en français
    Given les onglets de navigation
    Then ils affichent "Tableau de bord", "Colonies", "Paramètres"

  Scenario: Messages en français
    Given un message d'erreur
    Then le message est en français
```
