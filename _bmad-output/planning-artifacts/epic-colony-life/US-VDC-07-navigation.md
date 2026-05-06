---
title: 'US-VDC-07 - Naviguer via la barre du bas'
type: 'feature'
created: '2026-05-04'
status: 'done'
context: ['C:/dev/projects/antology_app/lib/screens/colony_detail_screen.dart', 'C:/dev/projects/antology_app/lib/main.dart']
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** L'utilisateur veut naviguer facilement vers le dashboard depuis la page de la colonie.

**Approach:** Ajouter une barre du bas avec bouton "Home" pour retourner au dashboard.

## Boundaries & Constraints

**Always:** 
- Barre du bas avec icône Home + texte "Home"
- Navigation vers "/home" (dashboard)

**Ask First:** 
- Ajout d'autres boutons dans la barre
- Modification de la route de navigation

**Never:** 
- Masquer la barre du bas
- Utiliser une autre route que "/home"

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Clic Home | Utilisateur clique | Redirection vers /home | N/A |
| Navigation arrière | Bouton retour | Retour à l'écran précédent | N/A |

</frozen-after-approval>

### US-VDC-07 : Naviguer via la barre du bas

**En tant que** propriétaire de fourmis,  
**je veux** naviguer vers le dashboard en cliquant sur "Home",  
**afin de** retourner à la liste des colonies.

```gherkin
Feature: Navigation barre du bas

  Scenario: Retour au dashboard
    Given l'utilisateur est sur la page "Vie de la colonie"
    When l'utilisateur clique sur "Home" dans la barre du bas
    Then l'utilisateur est redirigé vers "/home"
    And le dashboard s'affiche
```

## Code Map

- `lib/screens/colony_detail_screen.dart` -- Widget BottomNavBar
- `lib/main.dart` -- Routing vers /home

## Tasks & Acceptance

**Execution:**
- [x] `lib/screens/colony_detail_screen.dart` -- Ajout de la barre du bas -- Navigation Home vers dashboard
- [x] `lib/main.dart` -- Configuration route /home -- Support de la navigation

**Acceptance Criteria:**
- Given l'utilisateur est sur la page, when il clique sur "Home", then redirection vers le dashboard
- Given la barre est affichée, when l'utilisateur clique sur Home, then le dashboard s'affiche

## Spec Change Log

- 2026-05-04 : Création de la story US-VDC-07
- 2026-05-04 : Ajout du format User Story et critères Gherkin

## Design Notes

Utilisation de Container avec Border pour la barre du bas. Navigation via go_router.

## Verification

**Commands:**
- `flutter run -d windows` -- expected: Navigation fonctionnelle vers le dashboard
