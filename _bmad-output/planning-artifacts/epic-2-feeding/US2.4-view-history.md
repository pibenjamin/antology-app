---
title: 'US2.4 - Visualiser l historique des nourrissages'
type: 'feature'
created: '2026-04-21'
status: 'done'
---

## US2.4 : Visualiser l'historique des nourrissages

**En tant que** propriétaire de fourmis,  
**je veux** voir les derniers nourrissages avec leur date et rating,  
**afin de** suivre l'historique alimentaire.

```gherkin
Feature: Historique des nourrissages

  Scenario: Affichage des 10 derniers nourrissages
    Given une colonie a plus de 10 nourrissages
    When l'utilisateur consulte l'historique
    Then les 10 derniers nourrissages sont affichés
    And les plus récents apparaissent en premier

  Scenario: Affichage du rating avec icônes
    Given un nourrissage a un rating de 3
    When l'historique s'affiche
    Then 3 icônes restaurant sont affichées

  Scenario: Affichage sans rating
    Given un nourrissage n'a pas de rating
    When l'historique s'affiche
    Then aucune icône de rating n'est affichée

  Scenario: Boutons modifier et supprimer
    Given un nourrissage dans l'historique
    Then un bouton modifier est disponible
    And un bouton supprimer est disponible

  Scenario: Format de la date
    Given un nourrissage du 21/04/2026
    When l'historique s'affiche
    Then la date est affichée au format "21/4/2026"
```
