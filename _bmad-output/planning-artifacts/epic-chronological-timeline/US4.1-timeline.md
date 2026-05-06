---
title: 'US4.1 - Visualiser la frise chronologique de la colonie'
type: 'feature'
created: '2026-05-04'
status: 'done'
---

## US4.1 : Visualiser la frise chronologique de la colonie

**En tant que** propriétaire de fourmis,  
**je veux** consulter une frise chronologique de la date de fondation à aujourd'hui,  
**afin de** suivre l'évolution globale sur une seule vue.

```gherkin
Feature: Frise chronologique de colonie

  Scenario: Affichage de la frise sur l'écran de détails
    Given l'utilisateur est sur l'écran de détails d'une colonie créée le 2025-04-14
    When l'utilisateur fait défiler la section "Évolution"
    Then une frise s'affiche avec début à 2025-04-14 (fondation) et fin à la date du jour

  Scenario: Navigation sur la frise
    Given la frise est affichée
    When l'utilisateur fait glisser vers la gauche (passé)
    Then les événements antérieurs s'affichent
    When l'utilisateur fait glisser vers la droite (futur)
    Then la frise s'arrête à la date du jour (pas de dates futures)
```
