import '../models/models.dart';

class FoodCategory {
  String name;
  List<String> foods;
  FoodCategory(this.name, this.foods);
}

final List<FoodCategory> defaultFoodCategories = [
  FoodCategory('Insectes', ['Grillons', 'Criquets', 'Tenebrios', 'Mouches des fruits', 'Vers de cire', 'Blattes']),
  FoodCategory('Graines', ['Millet', 'Graines de canari', 'Graines de chia', 'Graines de lin', 'Graines de navette', 'Graines de pissenlit', 'Graines d\'herbe', 'Graines de tournesol', 'Graines de niger', 'Avoine', 'Quinoa', 'Mix oiseaux']),
  FoodCategory('Glucides', ['Eau sucrée', 'Miel', 'Pomme', 'Banane', 'Raisins', 'Graines']),
  FoodCategory('Spécial', ['Gélatine protéinée', 'Oeuf cuit', 'Poulet']),
];

List<FoodCategory> get foodCategories => defaultFoodCategories;

List<String> get allFoods => foodCategories.expand((c) => c.foods).toList();

List<FoodCategory> getAllCategories(List<FoodCategory> customCats) => [...defaultFoodCategories, ...customCats];

List<String> getAllFoods(List<FoodCategory> customCats, List<String> customFoods) => [...allFoods, ...customFoods];

final frequencies = [
  (Frequency.daily, 'Quotidien'),
  (Frequency.every2days, 'Tous les 2 jours'),
  (Frequency.weekly, 'Hebdomadaire'),
  (Frequency.biweekly, 'Bimensuel'),
  (Frequency.monthly, 'Mensuel'),
];

String frequencyLabel(Frequency f) => frequencies.firstWhere((e) => e.$1 == f).$2;