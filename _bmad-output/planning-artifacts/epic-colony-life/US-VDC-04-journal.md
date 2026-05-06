---
title: 'US-VDC-04 - Voir le journal avec timeline'
type: 'feature'
created: '2026-05-04'
status: 'done'
context: ['C:/dev/projects/antology_app/lib/screens/colony_detail_screen.dart']
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** L'utilisateur veut suivre l'historique de sa colonie via un journal chronologique.

**Approach:** Afficher le journal avec une timeline des événements groupés par date.

## Boundaries & Constraints

**Always:** 
- Titre "Journal" en PT Serif 20px foreground (#F0E6CC)
- Timeline avec entrées groupées par date
- Chaque entrée : icône, titre, description

**Ask First:** 
- Ajout de nouveaux types d'entrées
- Modification du format de grouping

**Never:** 
- Afficher les entrées sans ordre chronologique
- Masquer la timeline

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Journal avec entrées | Plusieurs événements | Timeline groupée par date | N/A |
| Journal vide | Aucune entrée | Message "Aucune entrée" | Afficher message vide |

</frozen-after-approval>

### US-VDC-04 : Voir le journal avec timeline

**En tant que** propriétaire de fourmis,  
**je veux** voir le journal avec la timeline des événements,  
**afin de** suivre l'historique de ma colonie.

```gherkin
Feature: Journal avec timeline

  Scenario: Affichage du journal
    Given l'utilisateur est sur la page "Vie de la colonie"
    When la page se charge
    Then le titre "Journal" s'affiche en PT Serif 20px foreground
    And la timeline affiche les entrées groupées par date
    And chaque entrée a une icône, un titre et une description
```

## Code Map

- `lib/screens/colony_detail_screen.dart` -- Widget JournalTimeline

## Tasks & Acceptance

**Execution:**
- [x] `lib/screens/colony_detail_screen.dart` -- Ajout du journal timeline -- Timeline avec entrées groupées

**Acceptance Criteria:**
- Given la page est chargée, when l'utilisateur fait défiler, then le titre "Journal" s'affiche en PT Serif 20px
- Given des entrées existent, when la page se charge, then elles sont groupées par date dans la timeline

## Spec Change Log

- 2026-05-04 : Création de la story US-VDC-04
- 2026-05-04 : Ajout du format User Story et critères Gherkin

## Design Notes

Utilisation de GoogleFonts pour PT Serif et DM Sans. Timeline avec icônes colorées.

## Verification

**Commands:**
- `flutter run -d windows` -- expected: Journal timeline visible avec entrées
