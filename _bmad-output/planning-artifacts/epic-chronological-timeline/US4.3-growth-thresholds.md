---
title: 'US4.3 - Marquer les seuils de croissance sur la frise'
type: 'feature'
created: '2026-05-04'
status: 'done'
---

## US4.3 : Marquer les seuils de croissance sur la frise

**En tant que** propriétaire de fourmis,  
**je veux** voir les seuils de population (ex: 100, 500, 1000 individus) marqués sur la frise,  
**afin de** visualiser les étapes clés de développement.

```gherkin
Feature: Seuils de croissance sur la frise

  Scenario: Marquage d'un seuil atteint
    Given la colonie a atteint 500 individus le 2025-05-01
    And des seuils configurés : 100, 500, 1000
    And la frise est affichée
    When l'utilisateur navigue jusqu'au 2025-05-01
    Then un marqueur "Croissance" s'affiche
    And le marqueur indique "Seuil 500 individus atteint"

  Scenario: Seuil non atteint
    Given la colonie a une population de 600 individus
    And le seuil 1000 est configuré
    When l'utilisateur navigue sur la frise
    Then aucun marqueur pour 1000 n'est affiché
```
