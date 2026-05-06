---
title: 'US-VDC-06 - Ajouter une nouvelle entrée'
type: 'feature'
created: '2026-05-04'
status: 'done'
context: ['C:/dev/projects/antology_app/lib/screens/colony_detail_screen.dart']
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** L'utilisateur veut documenter un événement rapidement depuis la page de la colonie.

**Approach:** Ajouter un bouton FAB "New Entry" qui ouvre un formulaire d'ajout.

## Boundaries & Constraints

**Always:** 
- FAB avec icône + texte "New Entry"
- Ouverture d'un formulaire dédié (pas de popup)

**Ask First:** 
- Modification du design du FAB
- Ajout d'actions rapides dans le FAB

**Never:** 
- Utiliser une popup pour le formulaire
- Masquer le FAB

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Clic FAB | Utilisateur clique | Formulaire d'ajout s'ouvre | N/A |
| Soumission vide | Champs vides | Message d'erreur | Afficher "Veuillez saisir un titre" |

</frozen-after-approval>

### US-VDC-06 : Ajouter une nouvelle entrée

**En tant que** propriétaire de fourmis,  
**je veux** ajouter une nouvelle entrée via le bouton FAB,  
**afin de** documenter un événement.

```gherkin
Feature: Nouvelle entrée

  Scenario: Clic sur le FAB
    Given l'utilisateur est sur la page "Vie de la colonie"
    When l'utilisateur clique sur "New Entry"
    Then un formulaire d'ajout s'affiche
```

## Code Map

- `lib/screens/colony_detail_screen.dart` -- Widget FAB + formulaire NewEntryForm

## Tasks & Acceptance

**Execution:**
- [x] `lib/screens/colony_detail_screen.dart` -- Ajout du FAB et formulaire -- Navigation vers écran d'ajout

**Acceptance Criteria:**
- Given l'utilisateur est sur la page, when il clique sur "New Entry", then un formulaire d'ajout s'affiche
- Given le formulaire est ouvert, when l'utilisateur saisit les infos, then l'entrée est ajoutée au journal

## Spec Change Log

- 2026-05-04 : Création de la story US-VDC-06
- 2026-05-04 : Ajout du format User Story et critères Gherkin

## Design Notes

Utilisation du widget FloatingActionButton avec couleur amber.

## Verification

**Commands:**
- `flutter run -d windows` -- expected: FAB visible et formulaire fonctionnel
