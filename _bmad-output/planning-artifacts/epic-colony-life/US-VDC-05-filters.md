---
title: 'US-VDC-05 - Filtrer les entrées du journal'
type: 'feature'
created: '2026-05-04'
status: 'done'
context: ['C:/dev/projects/antology_app/lib/screens/colony_detail_screen.dart']
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** L'utilisateur veut trouver rapidement un type d'événement dans le journal.

**Approach:** Ajouter des filtres (All/Feeding/Observations/Notes/Alerts) avec surbrillance active.

## Boundaries & Constraints

**Always:** 
- Filtres : All, Feeding, Observations, Notes, Alerts
- Filtre actif : amber (#E4A84A) avec texte primary-foreground
- Filtres inactifs : transparent avec texte sand (#B89A6A)

**Ask First:** 
- Ajout de nouveaux types de filtres
- Modification du comportement de filtrage

**Never:** 
- Afficher plusieurs filtres actifs simultanément
- Masquer les filtres

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Clic Feeding | Filtre devient actif | Filtre amber + texte clair | N/A |
| Filtre sans résultat | Aucune entrée du type | Message "Aucun résultat" | Afficher message vide |

</frozen-after-approval>

### US-VDC-05 : Filtrer les entrées du journal

**En tant que** propriétaire de fourmis,  
**je veux** filtrer les entrées par type (All/Feeding/Observations/Notes/Alerts),  
**afin de** trouver rapidement l'information cherchée.

```gherkin
Feature: Filtrage du journal

  Scenario: Sélection d'un filtre
    Given l'utilisateur est sur la page "Vie de la colonie"
    When l'utilisateur clique sur le filtre "Feeding"
    Then le filtre devient amber avec texte primary-foreground
    And les autres filtres restent transparents avec texte sand
```

## Code Map

- `lib/screens/colony_detail_screen.dart` -- Widget FilterChips

## Tasks & Acceptance

**Execution:**
- [x] `lib/screens/colony_detail_screen.dart` -- Ajout des filtres de journal -- Chips avec état actif/inactif

**Acceptance Criteria:**
- Given l'utilisateur clique sur "Feeding", when le filtre est appliqué, then le filtre devient amber avec texte clair
- Given un filtre est actif, when l'utilisateur clique sur "All", then tous les filtres redeviennent inactifs sauf All

## Spec Change Log

- 2026-05-04 : Création de la story US-VDC-05
- 2026-05-04 : Ajout du format User Story et critères Gherkin

## Design Notes

Utilisation du widget FilterChip de Flutter avec les couleurs du thème Antology.

## Verification

**Commands:**
- `flutter run -d windows` -- expected: Filtres fonctionnels avec bonne apparence
