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

## 4. Design Graphique

### 4.1 Spécifications de l'Export
- **Conteneur** : `375px` de largeur, `812px` de hauteur minimale
- **Typographie** : `font-family: var(--font-family-body)` (DM Sans par défaut)
- **Couleur de fond** : `var(--background)` → `#1a1208`

### 4.2 Polices (Google Fonts)
Importées via Google Fonts :
- **DM Sans** (100-900) - Police principale du corps de texte
- **PT Serif** (400, 700) - Titres et en-têtes
- **Geist** (100-900), **IBM Plex Sans** (100-700), **IBM Plex Mono** (100-700), **Inter** (100-900), **Nunito** (200-900), **Roboto** (100-900), **Roboto Slab** (100-900), **Shantell Sans** (300-800), **Space Grotesk** (300-700)

### 4.3 Palette de Couleurs (CSS Variables)
```css
:root {
  --color-background: #1a1208;        /* Fond principal sombre */
  --color-surface: #2d1f0a;            /* Surfaces (cards, modals) */
  --color-foreground: #f0e6cc;         /* Texte principal */
  --color-border: #4a3620;             /* Bordures */
  --color-primary-foreground: #1a1208; /* Texte sur couleur primaire */
  --color-amber: #e4a84a;              /* Accent principal (or) */
  --color-sand: #b89a6a;               /* Texte secondaire (sable) */
  --color-moss: #6a9463;               /* Succès, statut actif (mousse) */
  --color-slate: #7aabcc;              /* Info, température (ardoise) */
  --color-terracotta: #cc7a50;         /* Alertes (terre cuite) */
}
```

### 4.4 Arrondis (Radius)
- `--radius-sm: 4px` - Petits éléments
- `--radius-md: 8px` - Cards, inputs
- `--radius-lg: 12px` - Conteneurs larges
- `--radius-full: 9999px` - Badges, avatars, pills

### 4.5 Typographie (Variables CSS)
- `--font-body: DM Sans` - Corps de texte, labels
- `--font-headings: PT Serif` - Titres, en-têtes (italique)
- `--text-xs: 12px` - Métadonnées, dates
- `--text-sm: 14px` - Labels, descriptions
- `--text-lg: 18px` - Chiffres clés
- `--text-xl: 20px` - Sous-titres
- `--text-3xl: 30px` - Titres principaux (H1)

### 4.6 Texture de Fond
- Motif "Stardust" de Transparent Textures
- Opacité : `0.03` (très subtile)
- URL : `https://www.transparenttextures.com/patterns/stardust.png`

### 4.7 Classes Utilitaires (Tailwind CSS)
Le design utilise Tailwind CSS v4.2.4 avec les classes personnalisées pour :
- Espacement, flexbox, grilles
- Couleurs de fond, bordure, texte (ex: `bg-amber`, `text-moss`, `border-slate`)
- Typographie (`font-body`, `font-headings`)
- Ombres (`shadow-lg shadow-black/50`)

## 5. Wireframe Textuel
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
