---
title: 'US3.2 - Ajouter une catégorie personnalisée'
type: 'feature'
created: '2026-04-21'
status: 'done'
---

## US3.2 : Ajouter une catégorie personnalisée

**En tant que** propriétaire de fourmis,  
**je veux** créer de nouvelles catégories d'aliments,  
**afin d'enrichir le régime alimentaire disponible.

```gherkin
Feature: Ajout d'une catégorie personnalisée

  Scenario: Ajout d'une nouvelle catégorie
    Given l'utilisateur est sur l'écran des préférences
    When l'utilisateur clique sur "+" pour ajouter une catégorie
    And l'utilisateur saisit "Friandises" comme nom
    And l'utilisateur valide
    Then la catégorie "Friandises" apparaît dans la liste

  Scenario: Catégorie sans nom
    Given le champ nom est vide
    When l'utilisateur clique sur "Ajouter"
    Then la catégorie n'est pas créée

  Scenario: Catégorie en double
    Given une catégorie "Graines" existe déjà
    When l'utilisateur tente de créer "Graines"
    Then un message d'erreur s'affiche
    And la catégorie n'est pas créée

  Scenario: Catégorie vide
    Given une nouvelle catégorie est créée
    When l'utilisateur la déploie
    Then le texte "Aucun aliment" est affiché
```
