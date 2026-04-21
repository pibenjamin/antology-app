import 'package:flutter_test/flutter_test.dart';
import 'package:antology_app/models/food_data.dart';
import 'package:antology_app/models/models.dart';

void main() {
  group('FoodCategory', () {
    test('should create food category with name and foods', () {
      final category = FoodCategory('Insectes', ['Grillons', 'Criquets']);

      expect(category.name, 'Insectes');
      expect(category.foods.length, 2);
      expect(category.foods[0], 'Grillons');
    });

    test('should allow empty foods list', () {
      final category = FoodCategory('Nouvelle', []);

      expect(category.foods.isEmpty, true);
    });

    test('should modify foods list', () {
      final category = FoodCategory('Test', []);
      category.foods.add('Nouvel aliment');

      expect(category.foods.length, 1);
      expect(category.foods[0], 'Nouvel aliment');
    });
  });

  group('defaultFoodCategories', () {
    test('should have 4 categories by default', () {
      expect(defaultFoodCategories.length, 4);
    });

    test('should contain Insectes category', () {
      final insectsCat = defaultFoodCategories.firstWhere(
        (c) => c.name == 'Insectes',
        orElse: () => FoodCategory('', []),
      );

      expect(insectsCat.name, 'Insectes');
      expect(insectsCat.foods, contains('Grillons'));
      expect(insectsCat.foods, contains('Criquets'));
    });

    test('should contain Graines category', () {
      final seedsCat = defaultFoodCategories.firstWhere(
        (c) => c.name == 'Graines',
        orElse: () => FoodCategory('', []),
      );

      expect(seedsCat.name, 'Graines');
      expect(seedsCat.foods, contains('Millet'));
      expect(seedsCat.foods, contains('Graines de canari'));
    });

    test('should contain Glucides category', () {
      final glucidesCat = defaultFoodCategories.firstWhere(
        (c) => c.name == 'Glucides',
        orElse: () => FoodCategory('', []),
      );

      expect(glucidesCat.name, 'Glucides');
      expect(glucidesCat.foods, contains('Miel'));
    });

    test('should contain Spécial category', () {
      final specialCat = defaultFoodCategories.firstWhere(
        (c) => c.name == 'Spécial',
        orElse: () => FoodCategory('', []),
      );

      expect(specialCat.name, 'Spécial');
      expect(specialCat.foods, contains('Poulet'));
    });

    test('all categories should have foods', () {
      for (final category in defaultFoodCategories) {
        expect(category.foods.isNotEmpty, true,
            reason: '${category.name} should have foods');
      }
    });

    test('Graines should have specific seeds for Messor barbarus', () {
      final seedsCat = defaultFoodCategories.firstWhere((c) => c.name == 'Graines');
      final expectedSeeds = [
        'Millet',
        'Graines de canari',
        'Graines de chia',
        'Graines de lin',
        'Graines de navette',
        'Graines de pissenlit',
        'Graines d\'herbe',
        'Graines de tournesol',
        'Graines de niger',
        'Avoine',
        'Quinoa',
        'Mix oiseaux',
      ];

      for (final seed in expectedSeeds) {
        expect(seedsCat.foods, contains(seed),
            reason: 'Should contain $seed');
      }
    });
  });

  group('allFoods', () {
    test('should return all foods from all categories', () {
      final allFoodsList = allFoods;

      expect(allFoodsList, contains('Grillons'));
      expect(allFoodsList, contains('Millet'));
      expect(allFoodsList, contains('Miel'));
      expect(allFoodsList, contains('Poulet'));
    });

    test('should have no duplicates', () {
      final allFoodsList = allFoods;
      final uniqueFoods = allFoodsList.toSet();

      expect(allFoodsList.length, uniqueFoods.length);
    });

    test('should have minimum number of foods', () {
      final allFoodsList = allFoods;

      expect(allFoodsList.length, greaterThanOrEqualTo(20));
    });
  });

  group('getAllCategories', () {
    test('should combine default and custom categories', () {
      final customCats = [
        FoodCategory('Friandises', ['Chocolat']),
      ];
      final allCats = getAllCategories(customCats);

      expect(allCats.length, 5); // 4 default + 1 custom
      expect(allCats.last.name, 'Friandises');
    });

    test('should return only default when no custom', () {
      final allCats = getAllCategories([]);

      expect(allCats.length, 4);
    });

    test('should preserve order', () {
      final customCats = [
        FoodCategory('Z-Category', ['Z-Food']),
      ];
      final allCats = getAllCategories(customCats);

      expect(allCats[0].name, 'Insectes');
      expect(allCats.last.name, 'Z-Category');
    });
  });

  group('getAllFoods', () {
    test('should include default foods', () {
      final allFoodsList = getAllFoods([], []);

      expect(allFoodsList, contains('Grillons'));
    });

    test('should include custom foods', () {
      final customFoods = ['CustomFood1', 'CustomFood2'];
      final allFoodsList = getAllFoods([], customFoods);

      expect(allFoodsList, contains('CustomFood1'));
      expect(allFoodsList, contains('CustomFood2'));
    });
  });

  group('frequencies', () {
    test('should have 5 frequency options', () {
      expect(frequencies.length, 5);
    });

    test('should be in order', () {
      expect(frequencies[0].$1, Frequency.daily);
      expect(frequencies[1].$1, Frequency.every2days);
      expect(frequencies[2].$1, Frequency.weekly);
      expect(frequencies[3].$1, Frequency.biweekly);
      expect(frequencies[4].$1, Frequency.monthly);
    });

    test('frequencyLabel should return correct label', () {
      expect(frequencyLabel(Frequency.daily), 'Quotidien');
      expect(frequencyLabel(Frequency.weekly), 'Hebdomadaire');
      expect(frequencyLabel(Frequency.monthly), 'Mensuel');
    });

    test('all frequency values should have labels', () {
      for (final freq in Frequency.values) {
        expect(() => frequencyLabel(freq), returnsNormally);
      }
    });
  });
}