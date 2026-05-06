---
title: 'US-VDC-01 - Voir l en-tête de la colonie'
type: 'feature'
created: '2026-05-04'
status: 'done'
context: ['C:/dev/projects/antology_app/lib/screens/colony_detail_screen.dart']
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** L'utilisateur a besoin d'identifier rapidement sa colonie avec les informations clés.

**Approach:** Afficher l'en-tête avec le nom de la colonie, la date d'établissement et le statut de vitalité.

## Boundaries & Constraints

**Always:** 
- Nom en PT Serif 30px amber (#E4A84A)
- Date en DM Sans 12px sand (#B89A6A)
- Statut avec point vert moss (#6A9463)

**Ask First:** 
- Modification des polices ou tailles
- Ajout d'autres informations dans l'en-tête

**Never:** 
- Utiliser d'autres couleurs que la palette définie
- Masquer le nom de la colonie

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Affichage normal | Colonie "Athéna" | Nom affiché en PT Serif 30px amber | N/A |
| Statut Thriving | Colonie active | Point vert moss + "Thriving" | N/A |

</frozen-after-approval>

### US-VDC-01 : Voir l'en-tête de la colonie

**En tant que** propriétaire de fourmis,  
**je veux** voir l'en-tête avec le nom, l'espèce, la date d'établissement et le statut de la colonie,  
**afin de** identifier rapidement ma colonie.

```gherkin
Feature: En-tête de la colonie

  Scenario: Affichage de l'en-tête
    Given l'utilisateur est sur la page "Vie de la colonie"
    When la page se charge
    Then le nom de la colonie s'affiche en PT Serif 30px amber
    And la date d'établissement s'affiche en DM Sans 12px sand
    And le statut "Thriving" s'affiche avec un point vert moss
```

## Code Map

- `lib/screens/colony_detail_screen.dart` -- Widget d'en-tête (ColonyHeader)

## Tasks & Acceptance

**Execution:**
- [x] `lib/screens/colony_detail_screen.dart` -- Ajout du widget d'en-tête -- Affichage nom, date, statut

**Acceptance Criteria:**
- Given l'utilisateur est sur la page, when la page se charge, then le nom s'affiche en PT Serif 30px amber
- Given la colonie a un statut, when la page se charge, then le statut s'affiche avec point vert

## Spec Change Log

- 2026-05-04 : Création de la story US-VDC-01
- 2026-05-04 : Ajout du format User Story et critères Gherkin

## Design Notes

Utilisation de GoogleFonts pour PT Serif et DM Sans. Couleurs définies dans AntologyColors.

## Verification

**Commands:**
- `flutter run -d windows` -- expected: En-tête visible avec bonnes polices et couleurs
