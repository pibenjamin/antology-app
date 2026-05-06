---
title: 'US2.1 - Enregistrer un nourrissage'
type: 'feature'
created: '2026-04-21'
status: 'done'
---

## US2.1 : Enregistrer un nourrissage

**En tant que** propriétaire de fourmis,  
**je veux** enregistrer un nourrissage avec un aliment, une quantité optionnelle, une date et un rating,  
**afin de** suivre l'historique alimentaire de ma colonie.

```gherkin
Feature: Enregistrement d'un nourrissage

  Scenario: Enregistrement complet avec tous les champs
    Given l'utilisateur est sur l'écran de détail d'une colonie
    When l'utilisateur clique sur "Enregistrer" dans la section nourrissage
    And l'utilisateur sélectionne "Grillons" dans la liste des aliments
    And l'utilisateur saisit "5" comme quantité
    And l'utilisateur sélectionne une date
    And l'utilisateur sélectionne 3 étoiles de rating
    And l'utilisateur valide
    Then le nourrissage apparaît dans l'historique

  Scenario: Écran dédié
    Given l'utilisateur est sur l'écran de détail d'une colonie
    When l'utilisateur clique sur "Enregistrer" dans la section nourrissage
    Then un écran dédié s'ouvre
    And non une popup

  Scenario: Enregistrement sans quantité
    Given l'utilisateur est sur le formulaire de nourrissage
    And le champ quantité est vide
    When l'utilisateur valide
    Then le nourrissage est créé sans quantité

  Scenario: Erreur sans aliment sélectionné
    Given l'utilisateur est sur le formulaire de nourrissage
    And aucun aliment n'est sélectionné
    When l'utilisateur clique sur "Enregistrer"
    Then un message d'erreur affiche "Veuillez sélectionner un aliment"
    And le nourrissage n'est pas créé

  Scenario: Enregistrement sans rating
    Given l'utilisateur est sur le formulaire de nourrissage
    And aucun rating n'est sélectionné
    When l'utilisateur valide
    Then le nourrissage est créé sans rating

  Scenario: Date par défaut
    Given l'utilisateur ouvre le formulaire de nourrissage
    Then la date par défaut est aujourd'hui

  Scenario: Modification de la date
    Given le formulaire de nourrissage est ouvert
    When l'utilisateur clique sur le sélecteur de date
    And l'utilisateur choisit une date
    Then la date sélectionnée est affichée
```
