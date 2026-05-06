---
title: 'US1.2 - Visualiser les détails d une colonie'
type: 'feature'
created: '2026-04-21'
status: 'done'
---

## US1.2 : Visualiser les détails d'une colonie

**En tant que** propriétaire de fourmis,  
**je veux** voir les détails d'une colonie (nom, espèce, date de fondation),  
**afin de** consulter les informations de ma colonie.

```gherkin
Feature: Visualisation des détails d'une colonie

  Scenario: Affichage dans un écran dédié
    Given l'utilisateur est sur la liste des colonies
    When l'utilisateur clique sur une colonie
    Then un écran dédié s'ouvre (pas une popin)
    And le nom de la colonie est affiché
    And l'espèce est affichée
    And la date de fondation est affichée
    And un bouton de suppression est présent
```
