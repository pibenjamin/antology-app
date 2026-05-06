---
title: 'US-VDC-03 - Voir la barre de vitalité'
type: 'feature'
created: '2026-05-04'
status: 'done'
context: ['C:/dev/projects/antology_app/lib/screens/colony_detail_screen.dart']
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** L'utilisateur veut évaluer rapidement la santé de sa colonie.

**Approach:** Afficher une barre de vitalité avec pourcentage et statut textuel.

## Boundaries & Constraints

**Always:** 
- Barre à 78% en moss (#6A9463)
- Texte "Colony Vitality" en sand
- Sous-texte "Post-diapause · Active recovery" en moss

**Ask First:** 
- Modification du calcul de vitalité
- Changement de couleur selon le pourcentage

**Never:** 
- Masquer la barre de vitalité
- Afficher un pourcentage erroné

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Vitalité 78% | Colonie saine | Barre moss 78% + texte | N/A |
| Vitalité inconnue | Donnée manquante | Barre grise + "--" | Afficher N/A |

</frozen-after-approval>

### US-VDC-03 : Voir la barre de vitalité

**En tant que** propriétaire de fourmis,  
**je veux** voir la barre de vitalité avec le pourcentage et le statut,  
**afin de** évaluer la santé de ma colonie.

```gherkin
Feature: Barre de vitalité

  Scenario: Affichage de la vitalité
    Given l'utilisateur est sur la page "Vie de la colonie"
    When la page se charge
    Then la barre de vitalité s'affiche à 78% en moss
    And le texte "Colony Vitality" s'affiche en sand
    And le texte "Post-diapause · Active recovery" s'affiche en moss
```

## Code Map

- `lib/screens/colony_detail_screen.dart` -- Widget VitalityBar

## Tasks & Acceptance

**Execution:**
- [x] `lib/screens/colony_detail_screen.dart` -- Ajout de la barre de vitalité -- Barre avec pourcentage et statut

**Acceptance Criteria:**
- Given la page est chargée, when l'utilisateur regarde la vitalité, then barre 78% moss est visible
- Given le statut est défini, when la page se charge, then "Post-diapause · Active recovery" s'affiche en moss

## Spec Change Log

- 2026-05-04 : Création de la story US-VDC-03
- 2026-05-04 : Ajout du format User Story et critères Gherkin

## Design Notes

Utilisation de Container avec BoxDecoration pour la barre. Couleurs définies dans AntologyColors.

## Verification

**Commands:**
- `flutter run -d windows` -- expected: Barre de vitalité visible et correcte
