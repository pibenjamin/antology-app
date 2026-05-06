---
title: 'US1.1 - Créer une colonie'
type: 'feature'
created: '2026-04-21'
status: 'done'
---

## US1.1 : Créer une colonie

**En tant que** propriétaire de fourmis,  
**je veux** créer une nouvelle colonie avec son nom, son espèce et une date de fondation automatique,  
**afin de** suivre mes colonies de fourmis.

```gherkin
Feature: Création d'une colonie

  Scenario: Création avec tous les champs
    Given l'utilisateur est sur l'écran d'accueil
    When l'utilisateur clique sur le bouton "+"
    And l'utilisateur saisit "Athéna" comme nom
    And l'utilisateur saisit "Messor barbarus" comme espèce
    And l'utilisateur valide
    Then la colonie "Athéna" apparaît dans la liste

  Scenario: Création sans nom
    Given l'utilisateur est sur le formulaire d'ajout
    And le champ nom est vide
    When l'utilisateur clique sur "Ajouter"
    Then la colonie n'est pas créée

  Scenario: Date de fondation automatique
    Given l'utilisateur crée une nouvelle colonie
    When la colonie est créée
    Then la date de fondation est la date du jour
```
