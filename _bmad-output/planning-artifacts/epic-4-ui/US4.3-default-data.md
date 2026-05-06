---
title: 'US4.3 - Données par défaut'
type: 'feature'
created: '2026-04-21'
status: 'done'
---

## US4.3 : Données par défaut

**En tant que** utilisateur,  
**je veux** voir des exemples de colonies au premier lancement,  
**afin de** découvrir l'application plus rapidement.

```gherkin
Feature: Colonies示例 au premier lancement

  Scenario: Création automatique des colonies示例
    Given l'application est lancée pour la première fois
    When les données sont chargées
    Then 3 colonies示例 sont créées

  Scenario: Colonies示例 visibles
    Given les colonies示例 existent
    When l'utilisateur ouvre l'application
    Then il voit "Athéna" (Messor barbarus)
    And il voit "Eclair" (Messor barbarus)
    And il voit "Mama" (Lasius niger)

  Scenario: Pas de création si données existantes
    Given des colonies existent déjà
    When l'application démarre
    Then aucune colonie示例 n'est créée
```
