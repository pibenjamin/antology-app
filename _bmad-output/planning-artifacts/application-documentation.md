# Documentation Application Antology

## Résumé du projet

**Antology** est une application Flutter de gestion de colonies de fourmis permettant aux utilisateurs de :
- Gérer leurs colonies (ajouter, visualiser, supprimer)
- Enregistrer les sessions de nourrissage avec rating
- Suivre les préférences alimentaires de chaque colonie
- Personnaliser les catégories et aliments

---

## Écrans

| Écran | Description |
|-------|-------------|
| **HomeScreen** | Tableau de bord principal avec navigation (Dashboard, Colonies, Paramètres) |
| **ColonyDetailScreen** | Détail d'une colonie (informations, nourrissage, préférences) |
| **AddColonyScreen** | Formulaire d'ajout d'une nouvelle colonie |

---

## Modèles de données

### Colony
- `id` : Identifiant unique
- `name` : Nom de la colonie
- `species` : Espèce de fourmis
- `createdAt` : Date de fondation

### FeedingEvent
- `id` : Identifiant unique
- `colonyId` : ID de la colonie
- `foodType` : Type d'aliment donné
- `quantity` : Quantité (optionnel)
- `fedAt` : Date du nourrissage
- `rating` : Note de 1 à 5 (optionnel)

### FoodPreference
- `colonyId` : ID de la colonie
- `foodType` : Aliment concerné
- `status` : accepted / rejected / unknown

### FoodCategory
- `name` : Nom de la catégorie
- `foods` : Liste des aliments

---

## Catégories alimentaires par défaut

| Catégorie | Aliments |
|-----------|----------|
| Insectes | Grillons, Criquets, Tenebrios, Mouches des fruits, Vers de cire, Blattes |
| Graines | Millet, Graines de canari, Graines de chia, Graines de lin, Graines de navette, Graines de pissenlit, Graines d'herbe, Graines de tournesol, Graines de niger, Avoine, Quinoa, Mix oiseaux |
| Glucides | Eau sucrée, Miel, Pomme, Banane, Raisins, Graines |
| Spécial | Gélatine protéinée, Oeuf cuit, Poulet |

---

## Fonctionnalités implémentées

### Gestion des colonies
- Ajout d'une colonie avec nom, espèce et date automatique
- Visualisation des détails d'une colonie
- Suppression d'une colonie

### Nourrissage
- Enregistrement d'un nourrissage avec :
  - Sélection d'un aliment (parmi toutes les catégories)
  - Quantité optionnelle
  - Date de nourrissage (par défaut : aujourd'hui)
  - Rating de 1 à 5 (icône restaurant 🍽️)
- Modification d'un nourrissage existant
- Suppression d'un nourrissage
- Historique des derniers nourrissages (10 max)

### Préférences alimentaires
- Visualisation des préférences par colonie
- Ajout de catégories personnalisées
- Ajout d'aliments personnalisés
- Marquer un aliment comme : Accepté / Refusé / Non testé

### Données par défaut
Au premier lancement, 3 colonies示例 sont créées :
- Athéna (Messor barbarus - 01/04/2025)
- Eclair (Messor barbarus - 01/04/2025)
- Mama (Lasius niger - 01/06/2025)

---

## Technologies

- **Framework** : Flutter
- **State Management** : setState + StatefulWidget
- **Stockage local** : SharedPreferences (JSON)
- **UI** : Material Design 3

---

## Architecture

```
lib/
├── main.dart                    # Point d'entrée
├── models/
│   ├── models.dart              # Modèles de données
│   └── food_data.dart           # Catégories alimentaires
├── screens/
│   ├── home_screen.dart         # Écran principal
│   ├── colony_detail_screen.dart # Détail d'une colonie
│   └── add_colony_screen.dart   # Ajout d'une colonie
└── services/
    └── storage_service.dart     # Persistance des données
```
