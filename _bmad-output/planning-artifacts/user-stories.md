# User Stories & EPICs - Antology (Format Gherkin)

---

## EPIC 1 : Gestion des Colonies

### US1.1 : Créer une colonie

**En tant que** propriétaire de fourmis,  
**je veux** créer une nouvelle colonie avec son nom, son espèce et une date de fondation automatique,  
**afin de** suivre mes colonies de fourmis.

```gherkin
Feature: Création d'une colonie

  Scenario: Création avec tous les champs
    Given l'utilisateur est sur l'écran d'accueil
    When l'utilisateur clique sur le bouton "+"
    And l'utilisateur saisit "Athéna" comme nom
    And l'utilisateur saisit "Messor barbarus" comme espèce
    And l'utilisateur valide
    Then la colonie "Athéna" apparaît dans la liste

  Scenario: Création sans nom
    Given l'utilisateur est sur le formulaire d'ajout
    And le champ nom est vide
    When l'utilisateur clique sur "Ajouter"
    Then la colonie n'est pas créée

  Scenario: Date de fondation automatique
    Given l'utilisateur crée une nouvelle colonie
    When la colonie est créée
    Then la date de fondation est la date du jour
```

---

### US1.2 : Visualiser les détails d'une colonie

**En tant que** propriétaire de fourmis,  
**je veux** voir les détails d'une colonie (nom, espèce, date de fondation),  
**afin de** consulter les informations de ma colonie.

```gherkin
Feature: Visualisation des détails d'une colonie

  Scenario: Affichage dans un écran dédié
    Given l'utilisateur est sur la liste des colonies
    When l'utilisateur clique sur une colonie
    Then un écran dédié s'ouvre (pas une popin)
    And le nom de la colonie est affiché
    And l'espèce est affichée
    And la date de fondation est affichée
    And un bouton de suppression est présent
```

---

### US1.3 : Supprimer une colonie

**En tant que** propriétaire de fourmis,  
**je veux** supprimer une colonie,  
**afin de** gérer mes colonies inactive.

```gherkin
Feature: Suppression d'une colonie

  Scenario: Suppression avec confirmation
    Given l'utilisateur est sur les détails d'une colonie
    When l'utilisateur clique sur l'icône supprimer
    And une confirmation s'affiche
    And l'utilisateur confirme
    Then la colonie est supprimée de la liste
    And l'écran se ferme

  Scenario: Annulation de la suppression
    Given la fenêtre de confirmation est affichée
    When l'utilisateur clique sur "Annuler"
    Then la colonie reste dans la liste
    And la fenêtre se ferme

  Scenario: Suppression en cascade des nourrissages
    Given une colonie a des nourrissages enregistrés
    When la colonie est supprimée
    Then tous les nourrissages de cette colonie sont supprimés
```

---

## EPIC 2 : Nourrissage

### US2.1 : Enregistrer un nourrissage

**En tant que** propriétaire de fourmis,  
**je veux** enregistrer un nourrissage avec un aliment, une quantité optionnelle, une date et un rating,  
**afin de** suivre l'historique alimentaire de ma colonie.

```gherkin
Feature: Enregistrement d'un nourrissage

  Scenario: Enregistrement complet avec tous les champs
    Given l'utilisateur est sur l'écran de détail d'une colonie
    When l'utilisateur clique sur "Enregistrer" dans la section nourrissage
    And l'utilisateur sélectionne "Grillons" dans la liste des aliments
    And l'utilisateur saisit "5" comme quantité
    And l'utilisateur sélectionne une date
    And l'utilisateur sélectionne 3 étoiles de rating
    And l'utilisateur valide
    Then le nourrissage apparaît dans l'historique

  Scenario: Écran dédié
    Given l'utilisateur est sur l'écran de détail d'une colonie
    When l'utilisateur clique sur "Enregistrer" dans la section nourrissage
    Then un écran dédié s'ouvre
    And non une popup

  Scenario: Enregistrement sans quantité
    Given l'utilisateur est sur le formulaire de nourrissage
    And le champ quantité est vide
    When l'utilisateur valide
    Then le nourrissage est créé sans quantité

  Scenario: Erreur sans aliment sélectionné
    Given l'utilisateur est sur le formulaire de nourrissage
    And aucun aliment n'est sélectionné
    When l'utilisateur clique sur "Enregistrer"
    Then un message d'erreur affiche "Veuillez sélectionner un aliment"
    And le nourrissage n'est pas créé

  Scenario: Enregistrement sans rating
    Given l'utilisateur est sur le formulaire de nourrissage
    And aucun rating n'est sélectionné
    When l'utilisateur valide
    Then le nourrissage est créé sans rating

  Scenario: Date par défaut
    Given l'utilisateur ouvre le formulaire de nourrissage
    Then la date par défaut est aujourd'hui

  Scenario: Modification de la date
    Given le formulaire de nourrissage est ouvert
    When l'utilisateur clique sur le sélecteur de date
    And l'utilisateur choisit une date
    Then la date sélectionnée est affichée
```

---

### US2.2 : Modifier un nourrissage

**En tant que** propriétaire de fourmis,  
**je veux** modifier un nourrissage existant,  
**afin de** corriger une erreur ou mettre à jour les informations.

```gherkin
Feature: Modification d'un nourrissage

  Scenario: Écran dédié
    Given l'utilisateur est sur l'historique des nourrissages
    When l'utilisateur clique sur l'icône modifier
    Then un écran dédié s'ouvre
    And non une popup

  Scenario: Modification de tous les champs
    Given un nourrissage existe dans l'historique
    When l'utilisateur clique sur l'icône modifier
    And l'utilisateur change l'aliment
    And l'utilisateur change la quantité
    And l'utilisateur change la date
    And l'utilisateur change le rating
    And l'utilisateur valide
    Then les modifications sont enregistrées

  Scenario: Annulation de la modification
    Given le formulaire de modification est ouvert
    When l'utilisateur clique sur "Annuler"
    Then les modifications ne sont pas appliquées

  Scenario: Conservation de l'ID après modification
    Given un nourrissage a un ID unique
    When l'utilisateur modifie le nourrissage
    Then l'ID reste le même
```

---

### US2.3 : Supprimer un nourrissage

**En tant que** propriétaire de fourmis,  
**je veux** supprimer un nourrissage,  
**afin de** nettoyer l'historique.

```gherkin
Feature: Suppression d'un nourrissage

  Scenario: Suppression avec confirmation
    Given un nourrissage existe dans l'historique
    When l'utilisateur clique sur l'icône supprimer
    And une confirmation s'affiche
    And l'utilisateur confirme
    Then le nourrissage est supprimé de la liste
    And l'historique se met à jour

  Scenario: Annulation de la suppression
    Given la fenêtre de confirmation est affichée
    When l'utilisateur clique sur "Annuler"
    Then le nourrissage reste dans la liste
```

---

### US2.4 : Visualiser l'historique des nourrissages

**En tant que** propriétaire de fourmis,  
**je veux** voir les derniers nourrissages avec leur date et rating,  
**afin de** suivre l'historique alimentaire.

```gherkin
Feature: Historique des nourrissages

  Scenario: Affichage des 10 derniers nourrissages
    Given une colonie a plus de 10 nourrissages
    When l'utilisateur consulte l'historique
    Then les 10 derniers nourrissages sont affichés
    And les plus récents apparaissent en premier

  Scenario: Affichage du rating avec icônes
    Given un nourrissage a un rating de 3
    When l'historique s'affiche
    Then 3 icônes restaurant sont affichées

  Scenario: Affichage sans rating
    Given un nourrissage n'a pas de rating
    When l'historique s'affiche
    Then aucune icône de rating n'est affichée

  Scenario: Boutons modifier et supprimer
    Given un nourrissage dans l'historique
    Then un bouton modifier est disponible
    And un bouton supprimer est disponible

  Scenario: Format de la date
    Given un nourrissage du 21/04/2026
    When l'historique s'affiche
    Then la date est affichée au format "21/4/2026"
```

---

## EPIC 3 : Préférences Alimentaires

### US3.1 : Gérer les préférences alimentaires

**En tant que** propriétaire de fourmis,  
**je veux** marquer si un aliment est accepté ou rejeté par ma colonie,  
**afin de** connaître les préférences de ma colonie.

```gherkin
Feature: Préférences alimentaires par colonie

  Scenario: Affichage des catégories et aliments
    Given l'utilisateur est sur l'écran de détail d'une colonie
    When les préférences alimentaires s'affichent
    Then les catégories par défaut sont visibles : Insectes, Graines, Glucides, Spécial
    And chaque catégorie est déployable via ExpansionTile

  Scenario: Affichage d'une catégorie vide
    Given une catégorie n'a aucun aliment
    When l'utilisateur déploie la catégorie
    Then le texte "Aucun aliment" est affiché

  Scenario: Marquage d'un aliment comme accepté
    Given un aliment a le statut "Non testé"
    When l'utilisateur tape sur le chip de l'aliment
    Then le statut passe à "Accepté"
    And le chip devient vert

  Scenario: Marquage d'un aliment comme rejeté
    Given un aliment a le statut "Accepté"
    When l'utilisateur tape sur le chip de l'aliment
    Then le statut passe à "Refusé"
    And le chip devient rouge

  Scenario: Retour au statut non testé
    Given un aliment a le statut "Refusé"
    When l'utilisateur tape sur le chip de l'aliment
    Then le statut passe à "Non testé"
    And le chip devient gris

  Scenario: Persistance des préférences
    Given l'utilisateur modifie le statut d'un aliment
    When l'application est redémarrée
    Then le statut modifié est toujours affiché

  Scenario: Préférences par colonie
    Given deux colonies différentes
    When l'utilisateur modifie une préférence sur la colonie A
    Then la colonie B conserve ses propres préférences

  Scenario: Affichage des catégories personnalisées
    Given l'utilisateur a ajouté une catégorie personnalisée
    When les préférences s'affichent
    Then les catégories personnalisées apparaissent à la fin de la liste
```

---

### US3.2 : Ajouter une catégorie personnalisée

**En tant que** propriétaire de fourmis,  
**je veux** créer de nouvelles catégories d'aliments,  
**afin d'enrichir le régime alimentaire disponible.

```gherkin
Feature: Ajout d'une catégorie personnalisée

  Scenario: Ajout d'une nouvelle catégorie
    Given l'utilisateur est sur l'écran des préférences
    When l'utilisateur clique sur "+" pour ajouter une catégorie
    And l'utilisateur saisit "Friandises" comme nom
    And l'utilisateur valide
    Then la catégorie "Friandises" apparaît dans la liste

  Scenario: Catégorie sans nom
    Given le champ nom est vide
    When l'utilisateur clique sur "Ajouter"
    Then la catégorie n'est pas créée

  Scenario: Catégorie en double
    Given une catégorie "Graines" existe déjà
    When l'utilisateur tente de créer "Graines"
    Then un message d'erreur s'affiche
    And la catégorie n'est pas créée

  Scenario: Catégorie vide
    Given une nouvelle catégorie est créée
    When l'utilisateur la déploie
    Then le texte "Aucun aliment" est affiché
```

---

### US3.3 : Ajouter un aliment personnalisé

**En tant que** propriétaire de fourmis,  
**je veux** ajouter de nouveaux aliments,  
**afin d'enrichir les options de nourrissage.

```gherkin
Feature: Ajout d'un aliment personnalisé

  Scenario: Ajout avec catégorie existante
    Given la catégorie "Insectes" existe
    When l'utilisateur ajoute "Escargots" dans "Insectes"
    Then l'aliment "Escargots" apparaît dans "Insectes"

  Scenario: Ajout avec nouvelle catégorie
    Given l'utilisateur ajoute "Biscuits" dans "Friandises"
    And "Friandises" n'existe pas
    Then la catégorie "Friandises" est créée
    And "Biscuits" y est ajouté

  Scenario: Ajout sans catégorie
    Given l'utilisateur ajoute un aliment sans sélectionner de catégorie
    Then l'aliment est ajouté dans "Personnalisé"

  Scenario: Aliment existant dans les默认
    Given "Millet" existe dans les catégories par défaut
    When l'utilisateur tente d'ajouter "Millet"
    Then un message indique que l'aliment existe déjà

  Scenario: Aliment sans nom
    Given le champ nom est vide
    When l'utilisateur clique sur "Ajouter"
    Then l'aliment n'est pas créé
```

---

## EPIC 4 : Interface Utilisateur

### US4.1 : Application entièrement en français

**En tant que** utilisateur francophone,  
**je veux** que l'application soit en français,  
**afin de** faciliter mon utilisation.

```gherkin
Feature: Interface en français

  Scenario: Textes en français
    Given l'application est chargée
    Then tous les textes sont en français
    And tous les labels sont en français
    And tous les boutons sont en français

  Scenario: Navigation en français
    Given les onglets de navigation
    Then ils affichent "Tableau de bord", "Colonies", "Paramètres"

  Scenario: Messages en français
    Given un message d'erreur
    Then le message est en français
```

---

### US4.2 : Remplacer les popins par des écrans

**En tant que** utilisateur,  
**je veux** naviguer vers des écrans dédiés au lieu des popins,  
**afin d'avoir une meilleure expérience utilisateur.

```gherkin
Feature: Écrans dédiés au lieu de popins

  Scenario: Écran détail colonie
    Given l'utilisateur clique sur une colonie
    Then un écran dédié s'ouvre
    And non une popin ou bottom sheet

  Scenario: Écran ajout colonie
    Given l'utilisateur clique sur "+"
    Then un écran dédié s'ouvre

  Scenario: Navigation arrière
    Given l'utilisateur est sur un écran dédié
    When l'utilisateur clique sur retour
    Then l'écran précédent s'affiche
```

---

### US4.3 : Données par défaut

**En tant que** utilisateur,  
**je veux** voir des exemples de colonies au premier lancement,  
**afin de** découvrir l'application plus rapidement.

```gherkin
Feature: Colonies示例 au premier lancement

  Scenario: Création automatique des colonies示例
    Given l'application est lancée pour la première fois
    When les données sont chargées
    Then 3 colonies示例 sont créées

  Scenario: Colonies示例 visibles
    Given les colonies示例 existent
    When l'utilisateur ouvre l'application
    Then il voit "Athéna" (Messor barbarus)
    And il voit "Eclair" (Messor barbarus)
    And il voit "Mama" (Lasius niger)

  Scenario: Pas de création si données existantes
    Given des colonies existent déjà
    When l'application démarre
    Then aucune colonie示例 n'est créée
```

---

## Statut Global

| EPIC | Titre | Statut |
|------|-------|--------|
| EPIC 1 | Gestion des Colonies | ✅ Terminé |
| EPIC 2 | Nourrissage | ✅ Terminé |
| EPIC 3 | Préférences Alimentaires | ✅ Terminé |
| EPIC 4 | Interface Utilisateur | ✅ Terminé |

---

## Fonctionnalités Futures (Backlog)

### USF1.1 : Historique complet des nourritages
Pagination ou infinite scroll pour tous les nourritages

### USF1.2 : Statistiques de nourrissage
Graphiques d'évolution du nourrissage par période

### USF1.3 : Photos des colonies
Ajout de photos pour identifier visuellement les colonies

### USF1.4 : Rappels de nourrissage
Notifications pour rappeler le prochain nourrissage

### USF1.5 : Export des données
Export CSV/PDF de l'historique

### USF1.6 : Connexion backend
Synchronisation avec le backend `C:\dev\projects\fourmi-backend`
