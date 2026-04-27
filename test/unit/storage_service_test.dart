import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:antology_app/models/models.dart';
import 'package:antology_app/models/food_data.dart';
import 'package:antology_app/services/storage_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late StorageService storageService;
  late MockSharedPreferences mockPrefs;

  setUpAll(() {
    registerFallbackValue(FoodCategory('Test', []));
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    mockPrefs = MockSharedPreferences();
    storageService = StorageService();
  });

  group('StorageService - generateId', () {
    test('should generate numeric IDs', () async {
      await storageService.init();

      final id = storageService.generateId();

      expect(id, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')));
    });
  });

  group('StorageService - Debug Mode', () {
    test('should toggle debug mode', () async {
      await storageService.init();

      expect(AppConfig.debugMode, false);

      await storageService.setDebugMode(true);
      expect(AppConfig.debugMode, true);

      await storageService.setDebugMode(false);
      expect(AppConfig.debugMode, false);
    });
  });

  group('StorageService - addCustomCategory', () {
    test('should not add category that already exists in defaults', () async {
      await storageService.init();

      expect(storageService.customCategories.length, 0);

      await storageService.addCustomCategory('Insectes');

      expect(storageService.customCategories.length, 0);
    });

    test('should not add duplicate category (case insensitive)', () async {
      await storageService.init();

      await storageService.addCustomCategory('Nouvelle categorie');
      expect(storageService.customCategories.length, 1);

      await storageService.addCustomCategory('nouvelle categorie');
      expect(storageService.customCategories.length, 1);
    });
  });

  group('StorageService - addCustomFood', () {
    test('should add food to default category and show in getAllFoods', () async {
      await storageService.init();

      expect(getAllFoods(storageService.customCategories, storageService.customFoods).contains('Riz'), false);

      await storageService.addCustomFood('Riz', categoryName: 'Graines');

      expect(storageService.customFoods.contains('Riz'), true);
      expect(getAllFoods(storageService.customCategories, storageService.customFoods).contains('Riz'), true);
    });

    test('should show custom food in dropdown when selecting default category', () async {
      await storageService.init();

      await storageService.addCustomFood('Riz', categoryName: 'Graines');
      await storageService.addCustomFood('Pâtes', categoryName: 'Glucides');

      final allFoods = getAllFoods(storageService.customCategories, storageService.customFoods);

      expect(allFoods.contains('Riz'), true);
      expect(allFoods.contains('Pâtes'), true);
    });
  });
}
