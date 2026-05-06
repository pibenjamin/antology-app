---
title: 'US7.1 - Sélection de la population par paliers'
type: 'feature'
created: '2026-04-27'
status: 'done'
---

## US7.1 : Sélection de la population par paliers

**En tant que** propriétaire de fourmis,
**je veux** sélectionner la population avec des paliers prédéfinis,
**afin d'avoir une estimation plus réaliste de ma colonie.

Les paliers reflètent la biologie des fourmis (croissance exponentielle au début, puis stabilisation).

```gherkin
Feature: Paliers de population

  Scenario: Slider affiche les paliers
    Given l'utilisateur crée une colonie
    When le slider de population est affiché
    Then les valeurs possible sont: 0, 5, 10, 15, 20, 30, 50, 100, 200, 500, 1000, 2000, 5000

  Scenario: Sélection d'un palier
    Given le slider est à l'index 5
    When l'utilisateur déplace le slider
    Then la valeur affichée est 30

  Scenario: Modification avec palier existant
    Given une colonie a population = 20
    When l'utilisateur modifie la colonie
    Then le slider affiche 20 (index 4)

  Scenario: Labels du slider
    Given le slider est affiché
    Then les extrémités affichent "0" et "5000"
```
