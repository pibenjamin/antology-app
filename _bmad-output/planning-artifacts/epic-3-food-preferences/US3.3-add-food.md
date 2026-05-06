---
title: 'US3.3 - Ajouter un aliment personnalisé'
type: 'feature'
created: '2026-04-21'
status: 'done'
---

## US3.3 : Ajouter un aliment personnalisé

**En tant que** propriétaire de fourmis,  
**je veux** ajouter de nouveaux aliments,  
**afin d'enrichir les options de nourrissage.

```gherkin
Feature: Ajout d'un aliment personnalisé

  Scenario: Ajout avec catégorie existante
    Given la catégorie "Insectes" existe
    When l'utilisateur ajoute "Escargots" dans "Insectes"
    Then l'aliment "Escargots" apparaît dans "Insectes"

  Scenario: Ajout avec nouvelle catégorie
    Given l'utilisateur ajoute "Biscuits" dans "Friandises"
    And "Friandises" n'existe pas
    Then la catégorie "Friandises" est créée
    And "Biscuits" y est ajouté

  Scenario: Ajout sans catégorie
    Given l'utilisateur ajoute un aliment sans sélectionner de catégorie
    Then l'aliment est ajouté dans "Personnalisé"

  Scenario: Aliment existant dans les默认
    Given "Millet" existe dans les catégories par défaut
    When l'utilisateur tente d'ajouter "Millet"
    Then un message indique que l'aliment existe déjà

  Scenario: Aliment sans nom
    Given le champ nom est vide
    When l'utilisateur clique sur "Ajouter"
    Then l'aliment n'est pas créé
```
