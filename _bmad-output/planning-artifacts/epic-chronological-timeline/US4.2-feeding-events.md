---
title: 'US4.2 - Afficher les nourrissages sur la frise'
type: 'feature'
created: '2026-05-04'
status: 'done'
---

## US4.2 : Afficher les nourrissages sur la frise

**En tant que** propriétaire de fourmis,  
**je veux** voir les sessions de nourrissage marquées sur la frise,  
**afin de** corréler alimentation et croissance.

```gherkin
Feature: Événements de nourrissage sur la frise

  Scenario: Marquage d'un nourrissage
    Given la colonie a un nourrissage le 2025-04-15 (Grillons, note 4/5)
    And la frise est affichée
    When l'utilisateur navigue jusqu'au 2025-04-15
    Then un marqueur "Nourrissage" s'affiche à cette date
    And le marqueur indique l'aliment (Grillons) et la note (4/5)

  Scenario: Détail d'un nourrissage depuis la frise
    Given un marqueur de nourrissage est affiché
    When l'utilisateur clique sur le marqueur
    Then les détails complets s'affichent (quantité, notes, date)
```
