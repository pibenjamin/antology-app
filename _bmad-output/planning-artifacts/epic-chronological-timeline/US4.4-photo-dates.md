---
title: 'US4.4 - Afficher les dates d ajout de photos sur la frise'
type: 'feature'
created: '2026-05-04'
status: 'done'
---

## US4.4 : Afficher les dates d'ajout de photos sur la frise

**En tant que** propriétaire de fourmis,  
**je veux** voir les dates d'ajout de photos marquées sur la frise,  
**afin de** suivre l'évolution physique visuelle.

```gherkin
Feature: Dates d'ajout de photos sur la frise

  Scenario: Marquage d'une photo ajoutée
    Given la colonie a une photo ajoutée le 2025-04-20
    And la frise est affichée
    When l'utilisateur navigue jusqu'au 2025-04-20
    Then un marqueur "Photo" s'affiche à cette date
    And le marqueur affiche une miniature de la photo

  Scenario: Ouverture d'une photo depuis la frise
    Given un marqueur de photo est affiché
    When l'utilisateur clique sur le marqueur
    Then la photo s'ouvre en plein écran dans un visualiseur dédié
```
