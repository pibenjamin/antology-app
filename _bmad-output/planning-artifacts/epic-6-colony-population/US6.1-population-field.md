---
title: 'US6.1 - Ajouter un champ population à une colonie'
type: 'feature'
created: '2026-04-27'
status: 'done'
---

## US6.1 : Ajouter un champ population à une colonie

**En tant que** propriétaire de fourmis,
**je veux** saisir la population de ma colonie,
**afin de** suivre l'évolution de ma colonie.

```gherkin
Feature: Population des colonies

  Scenario: Ajouter population lors de la création
    Given l'utilisateur crée une nouvelle colonie
    When l'utilisateur saisit 500 comme population
    Then la colonie est créée avec population = 500

  Scenario: Modifier la population
    Given une colonie existe avec population = 100
    When l'utilisateur modifie la population à 200
    Then la population est 200

  Scenario: Slider entre 0 et 5000
    Given l'utilisateur modifie la population
    When le slider est entre 0 et 5000
    Then la valeur affiche correctement
```
