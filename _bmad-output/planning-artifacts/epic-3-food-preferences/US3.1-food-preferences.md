---
title: 'US3.1 - Gérer les préférences alimentaires'
type: 'feature'
created: '2026-04-21'
status: 'done'
---

## US3.1 : Gérer les préférences alimentaires

**En tant que** propriétaire de fourmis,  
**je veux** marquer si un aliment est accepté ou rejeté par ma colonie,  
**afin de** connaître les préférences de ma colonie.

```gherkin
Feature: Préférences alimentaires par colonie

  Scenario: Affichage des catégories et aliments
    Given l'utilisateur est sur l'écran de détail d'une colonie
    When les préférences alimentaires s'affichent
    Then les catégories par défaut sont visibles : Insectes, Graines, Glucides, Spécial
    And chaque catégorie est déployable via ExpansionTile

  Scenario: Affichage d'une catégorie vide
    Given une catégorie n'a aucun aliment
    When l'utilisateur déploie la catégorie
    Then le texte "Aucun aliment" est affiché

  Scenario: Marquage d'un aliment comme accepté
    Given un aliment a le statut "Non testé"
    When l'utilisateur tape sur le chip de l'aliment
    Then le statut passe à "Accepté"
    And le chip devient vert

  Scenario: Marquage d'un aliment comme rejeté
    Given un aliment a le statut "Accepté"
    When l'utilisateur tape sur le chip de l'aliment
    Then le statut passe à "Refusé"
    And le chip devient rouge

  Scenario: Retour au statut non testé
    Given un aliment a le statut "Refusé"
    When l'utilisateur tape sur le chip de l'aliment
    Then le statut passe à "Non testé"
    And le chip devient gris

  Scenario: Persistance des préférences
    Given l'utilisateur modifie le statut d'un aliment
    When l'application est redémarrée
    Then le statut modifié est toujours affiché

  Scenario: Préférences par colonie
    Given deux colonies différentes
    When l'utilisateur modifie une préférence sur la colonie A
    Then la colonie B conserve ses propres préférences

  Scenario: Affichage des catégories personnalisées
    Given l'utilisateur a ajouté une catégorie personnalisée
    When les préférences s'affichent
    Then les catégories personnalisées apparaissent à la fin de la liste
```
