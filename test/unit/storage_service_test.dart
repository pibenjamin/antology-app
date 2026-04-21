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

      expect(int.tryParse(id), isNotNull);
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
}
