---
title: 'US-VDC-08 - Sous-navigation du journal'
type: 'feature'
created: '2026-05-04'
status: 'done'
context: ['C:/dev/projects/antology_app/lib/screens/colony_detail_screen.dart']
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** L'utilisateur veut filtrer rapidement les entrées du journal par type via une sous-navigation claire.

**Approach:** Ajouter une barre de filtres avec les options Tous, Alimentation, Observations, Notes, Alertes qui filtrent dynamiquement les entrées du journal quand on clique dessus.

## Boundaries & Constraints

**Always:** 
- Filtres : Tous, Alimentation, Observations, Notes, Alertes
- Filtre actif : amber (#E4A84A) avec texte primary-foreground
- Filtres inactifs : transparent avec texte sand (#B89A6A)
- Mise à jour instantanée de la timeline après clic

**Ask First:** 
- Ajout de nouveaux types de filtres
- Modification du style des filtres

**Never:** 
- Afficher plusieurs filtres actifs en même temps
- Masquer la barre de sous-navigation

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Clic Alimentation | Filtre actif | Seules les entrées Alimentation s'affichent | N/A |
| Filtre sans résultat | Aucune entrée du type | Message "Aucun résultat" | Afficher message vide |

</frozen-after-approval>

### US-VDC-08 : Sous-navigation du journal

**En tant que** propriétaire de fourmis,  
**je veux** filtrer les entrées du journal par type via une sous-navigation (Tous, Alimentation, Observations, Notes, Alertes),  
**afin de** trouver rapidement les informations recherchées.

```gherkin
Feature: Sous-navigation du journal

  Scenario: Filtrage par Alimentation
    Given l'utilisateur est sur la page "Vie de la colonie"
    When l'utilisateur clique sur "Alimentation" dans la sous-navigation
    Then le filtre devient amber avec texte clair
    And seules les entrées de type Alimentation s'affichent dans la timeline

  Scenario: Filtrage par Observations
    Given l'utilisateur est sur la page "Vie de la colonie"
    When l'utilisateur clique sur "Observations"
    Then le filtre "Observations" devient actif
    And seules les observations s'affichent

  Scenario: Retour à Tous
    Given un filtre spécifique est actif
    When l'utilisateur clique sur "Tous"
    Then tous les filtres redeviennent inactifs sauf "Tous"
    And toutes les entrées du journal s'affichent

  Scenario: Filtre sans résultat
    Given aucune entrée de type "Alertes" n'existe
    When l'utilisateur clique sur "Alertes"
    Then un message "Aucun résultat" s'affiche
```

## Code Map

- `lib/screens/colony_detail_screen.dart` -- Widget FilterChips (sous-navigation)

## Tasks & Acceptance

**Execution:**
- [x] `lib/screens/colony_detail_screen.dart` -- Implémentation de la sous-navigation -- Filtres avec état actif/inactif

**Acceptance Criteria:**
- Given l'utilisateur clique sur "Alimentation", when le filtre est appliqué, then seules les entrées de type Alimentation sont visibles
- Given le filtre "Tous" est actif, when l'utilisateur clique sur "Notes", then le filtre Notes devient actif et les entrées Notes s'affichent

## Spec Change Log

- 2026-05-04 : Création de la story US-VDC-08
- 2026-05-04 : Ajout du format User Story et critères Gherkin

## Design Notes

Utilisation du widget FilterChip de Flutter avec les couleurs du thème Antology.

## Verification

**Commands:**
- `flutter run -d windows` -- expected: Sous-navigation fonctionnelle avec filtrage correct
