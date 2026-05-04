# UX Mockups - EPIC 4 : Suivi de l'évolution temporelle des colonies

## Lié à
- EPIC 4 : Suivi de l'évolution temporelle des colonies
- US4.1 : Visualiser la frise chronologique de la colonie
- US4.2 : Afficher les nourrissages sur la frise
- US4.3 : Marquer les seuils de croissance sur la frise
- US4.4 : Afficher les dates d'ajout de photos sur la frise

## 1. Concept Global
Une ligne de temps horizontale fluide, utilisant les couleurs d'Antology (Forest Green, accents clairs). Un fil ténu relie le passé au présent, évoquant une piste de fourmis.

## 2. Structure de l'Écran (ColonyDetailScreen)
- **Section "Évolution"** : Frise chronologique scrollable horizontalement.
- **Barre de temps** : Début = date fondation (icône 🏠), Fin = aujourd'hui (icône 📅).
- **Marqueurs colorés** :
  - 🟢 **Nourrissage** : Point vert avec icône 🍽️, tooltip flottant (aliment + note).
  - 🔵 **Croissance** : Point bleu avec icône 📈, label "Seuil X atteint".
  - 🟡 **Photo** : Point jaune avec miniature circulaire (clic = plein écran).

## 3. Interactions Clés
- **Glissement** : Swipe gauche/droite pour naviguer dans le temps (physique réaliste).
- **Tap sur marqueur** : Carte contextuelle élégante s'élève (Material Design elevation) avec détails complets.
- **Zoom temporel** : Pinch-to-zoom pour passer de vue mois à vue jour (optionnel futur).

## 4. Wireframe Textuel
```
[Colony Detail: Athéna]
...
┌─────────────────────────────────────────────────┐
│ ÉVOLUTION                                      │
│ ┌─────────────────────────────────────────┐    │
│ │ 🏠  ──●───●────●──────●─────📅        │    │
│ │ 2025-04-14  N    C    P     2025-05-01 │    │
│ │ (fondation)  (Grillons) (Photo)         │    │
│ └─────────────────────────────────────────┘    │
│ N = Nourrissage (vert) | C = Croissance (bleu)│
│ P = Photo (jaune)                             │
└─────────────────────────────────────────────────┘
```
