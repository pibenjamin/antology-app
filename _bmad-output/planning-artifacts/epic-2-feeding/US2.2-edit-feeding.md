---
title: 'US2.2 - Modifier un nourrissage'
type: 'feature'
created: '2026-04-21'
status: 'done'
---

## US2.2 : Modifier un nourrissage

**En tant que** propriétaire de fourmis,  
**je veux** modifier un nourrissage existant,  
**afin de** corriger une erreur ou mettre à jour les informations.

```gherkin
Feature: Modification d'un nourrissage

  Scenario: Écran dédié
    Given l'utilisateur est sur l'historique des nourrissages
    When l'utilisateur clique sur l'icône modifier
    Then un écran dédié s'ouvre
    And non une popup

  Scenario: Modification de tous les champs
    Given un nourrissage existe dans l'historique
    When l'utilisateur clique sur l'icône modifier
    And l'utilisateur change l'aliment
    And l'utilisateur change la quantité
    And l'utilisateur change la date
    And l'utilisateur change le rating
    And l'utilisateur valide
    Then les modifications sont enregistrées

  Scenario: Annulation de la modification
    Given le formulaire de modification est ouvert
    When l'utilisateur clique sur "Annuler"
    Then les modifications ne sont pas appliquées

  Scenario: Conservation de l'ID après modification
    Given un nourrissage a un ID unique
    When l'utilisateur modifie le nourrissage
    Then l'ID reste le même
```
