import 'package:flutter_test/flutter_test.dart';
import 'package:antology_app/models/models.dart';

void main() {
  group('FoodPreference', () {
    test('should create food preference with accepted status', () {
      final pref = FoodPreference(
        colonyId: 'colony-1',
        foodType: 'Grillons',
        status: FoodStatus.accepted,
      );

      expect(pref.colonyId, 'colony-1');
      expect(pref.foodType, 'Grillons');
      expect(pref.status, FoodStatus.accepted);
    });

    test('should create food preference with rejected status', () {
      final pref = FoodPreference(
        colonyId: 'colony-1',
        foodType: 'Graines de chia',
        status: FoodStatus.rejected,
      );

      expect(pref.status, FoodStatus.rejected);
    });

    test('should create food preference with unknown status', () {
      final pref = FoodPreference(
        colonyId: 'colony-1',
        foodType: 'Criquets',
        status: FoodStatus.unknown,
      );

      expect(pref.status, FoodStatus.unknown);
    });
  });

  group('FoodStatus enum', () {
    test('should have all expected values', () {
      expect(FoodStatus.values.length, 3);
      expect(FoodStatus.values, contains(FoodStatus.accepted));
      expect(FoodStatus.values, contains(FoodStatus.rejected));
      expect(FoodStatus.values, contains(FoodStatus.unknown));
    });

    test('should convert to/from string', () {
      expect(FoodStatus.accepted.name, 'accepted');
      expect(FoodStatus.rejected.name, 'rejected');
      expect(FoodStatus.unknown.name, 'unknown');

      expect(FoodStatus.values.firstWhere((e) => e.name == 'accepted'), FoodStatus.accepted);
      expect(FoodStatus.values.firstWhere((e) => e.name == 'rejected'), FoodStatus.rejected);
      expect(FoodStatus.values.firstWhere((e) => e.name == 'unknown'), FoodStatus.unknown);
    });
  });

  group('FoodPreference isolation by colony', () {
    test('same food different colonies should be independent', () {
      final prefColonyA = FoodPreference(
        colonyId: 'colony-a',
        foodType: 'Grillons',
        status: FoodStatus.accepted,
      );
      final prefColonyB = FoodPreference(
        colonyId: 'colony-b',
        foodType: 'Grillons',
        status: FoodStatus.rejected,
      );

      expect(prefColonyA.status, isNot(prefColonyB.status));
      expect(prefColonyA.colonyId, isNot(prefColonyB.colonyId));
    });
  });
}
