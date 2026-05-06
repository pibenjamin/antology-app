---
title: 'US-VDC-02 - Voir les statistiques'
type: 'feature'
created: '2026-05-04'
status: 'done'
context: ['C:/dev/projects/antology_app/lib/screens/colony_detail_screen.dart']
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** L'utilisateur veut suivre l'état de sa colonie via des statistiques clés.

**Approach:** Afficher les statistiques (Reine, Ouvrières, Couvain, Température) avec icônes et couleurs appropriées. La température et la population sont dynamiques, basées sur les dernières valeurs saisies dans la timeline.

## Boundaries & Constraints

**Always:** 
- Reine : icône + valeur en amber
- Ouvrières : icône + valeur en sand
- Couvain : icône + valeur en sand
- Température : icône + dernière valeur saisie en slate (dynamique depuis timeline)
- Population : icône + dernière valeur saisie en sand (dynamique depuis timeline)

**Ask First:** 
- Ajout d'autres statistiques
- Modification du calcul des valeurs dynamiques

**Never:** 
- Masquer une statistique essentielle
- Utiliser d'autres couleurs

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Stats affichées | Données disponibles | 4 stats avec icônes et valeurs | N/A |
| Valeur manquante | Donnée non définie | Afficher "--" | N/A |
| Température dynamique | Dernière entrée timeline à 24.5°C | "24.5°C" s'affiche | N/A |

</frozen-after-approval>

### US-VDC-02 : Voir les statistiques.

**En tant que** propriétaire de fourmis,  
**je veux** voir les statistiques (Reine, Ouvrières, Couvain, Température),  
**afin de** suivre l'état de ma colonie.

```gherkin
Feature: Statistiques de la colonie

  Scenario: Affichage des stats
    Given l'utilisateur est sur la page "Vie de la colonie"
    When la page se charge
    Then une icône Reine avec "1" s'affiche en amber
    And une icône Ouvrières avec "~450" s'affiche en sand
    And une icône Couvain avec "High" s'affiche en sand
    And une icône Température avec la dernière valeur saisie en slate

  Scenario: Température dynamique depuis timeline
    Given la dernière entrée timeline a une température de 24.5°C
    When l'utilisateur regarde les stats
    Then "24.5°C" s'affiche en slate

  Scenario: Population dynamique depuis timeline
    Given le dernier comptage dans la timeline est de 480 ouvrières
    When l'utilisateur regarde les stats
    Then "~480" s'affiche en sand
```

## Code Map

- `lib/screens/colony_detail_screen.dart` -- Widget StatisticsPanel

## Tasks & Acceptance

**Execution:**
- [x] `lib/screens/colony_detail_screen.dart` -- Ajout du panneau de statistiques -- 4 stats avec icônes
- [ ] `lib/screens/colony_detail_screen.dart` -- Rendre température/population dynamiques -- Lire dernières valeurs timeline

**Acceptance Criteria:**
- Given la page est chargée, when l'utilisateur regarde les stats, then la température affichée est la dernière saisie
- Given une nouvelle entrée température est ajoutée, when la page se charge, then la nouvelle valeur s'affiche

## Spec Change Log

- 2026-05-04 : Création de la story US-VDC-02
- 2026-05-04 : Ajout du format User Story et critères Gherkin
- 2026-05-04 : Mise à jour pour valeurs dynamiques (température/population depuis timeline)

## Design Notes

Utilisation de GoogleFonts pour DM Sans. Couleurs définies dans AntologyColors.

## Verification

**Commands:**
- `flutter run -d windows` -- expected: Statistiques visibles avec température/population dynamiques
