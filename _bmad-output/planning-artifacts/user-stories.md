# User Stories - Antology

---

## US1 : Ajouter des catégories alimentaires

**En tant que** propriétaire de fourmis,  
**je veux** créer de nouvelles catégories d'aliments (actuellement appelées "préférences alimentaires"),  
**afin d'enrichir et diversifier le régime alimentaire de mes fourmis.**

**Critères d'acceptation :**
1. L'utilisateur peut accéder à un formulaire de création de catégorie
2. Le nom de la catégorie est obligatoire et unique
3. La catégorie est persistée et visible dans la liste des catégories
4. L'utilisateur reçoit une confirmation après la création
5. Un message d'erreur s'affiche si le nom est vide ou déjà existant

**Définition of Done :**
- [ ] Formulaire de création accessible depuis l'écran des catégories
- [ ] Validation des champs implémentée
- [ ] Persistance en base de données fonctionnelle
- [ ] Feedback utilisateur visible (succès/erreur)
- [ ] Tests unitaires passent

---

## US2 : Ajouter des aliments dans les catégories

**En tant que** propriétaire de fourmis,  
**je veux** ajouter de nouveaux aliments dans une catégorie existante,  
**afin d'enrichir les informations nutritionnelles disponibles.**

**Critères d'acceptation :**
1. L'utilisateur peut sélectionner une catégorie existante
2. Le nom de l'aliment est obligatoire
3. Les détails de l'aliment (description, nutriments) sont optionnels
4. L'aliment est associé à la catégorie sélectionnée
5. La liste des aliments s'actualise après l'ajout

**Définition of Done :**
- [ ] Écran d'ajout d'aliment accessible
- [ ] Sélection de catégorie fonctionnelle
- [ ] Persistance en base de données opérationnelle
- [ ] Liste des aliments mise à jour automatiquement
- [ ] Tests unitaires passent

---

## US3 : Remplacer "Alimentation" par "Nourrissage"

**En tant que** propriétaire de fourmis,  
**je veux** que le terme "Alimentation" soit remplacé par "Nourrissage" dans l'interface,  
**afin d'utiliser une terminologie plus appropriée pour les sessions de nourrissage.**

**Critères d'acceptation :**
1. Le libellé "Alimentation" est remplacé par "Nourrissage" dans le menu de navigation
2. Le libellé "Alimentation" est remplacé par "Nourrissage" dans les écrans
3. Les labels et messages utilisent le terme "Nourrissage"
4. Les sessions sont appelées "Sessions de nourrissage"
5. Aucun résidu de "Alimentation" dans l'interface utilisateur

**Définition of Done :**
- [ ] Navigation mise à jour
- [ ] Tous les labels/textes modifiés
- [ ] Tests de non-régression passent
- [ ] Vérification visuelle de l'interface

---

## Statut

| US | Titre | Statut |
|----|-------|--------|
| US1 | Ajouter des catégories alimentaires | Terminé |
| US2 | Ajouter des aliments dans les catégories | Terminé |
| US3 | Remplacer "Alimentation" par "Nourrissage" | Terminé |
