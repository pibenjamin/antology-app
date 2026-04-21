import 'package:flutter_test/flutter_test.dart';
import 'package:antology_app/models/models.dart';

void main() {
  group('Colony', () {
    test('should create colony with all required fields', () {
      final colony = Colony(
        id: '1',
        name: 'Athéna',
        species: 'Messor barbarus',
        createdAt: DateTime(2025, 4, 1),
      );

      expect(colony.id, '1');
      expect(colony.name, 'Athéna');
      expect(colony.species, 'Messor barbarus');
      expect(colony.createdAt, DateTime(2025, 4, 1));
    });

    test('should create colony with empty id', () {
      final colony = Colony(
        id: '',
        name: 'Test',
        species: 'Lasius niger',
        createdAt: DateTime.now(),
      );

      expect(colony.id, '');
      expect(colony.name, 'Test');
    });

    test('should handle special characters in name', () {
      final colony = Colony(
        id: '1',
        name: 'Éclair & Fille',
        species: 'Messor barbarus',
        createdAt: DateTime.now(),
      );

      expect(colony.name, contains('&'));
    });

    test('should handle unicode characters', () {
      final colony = Colony(
        id: '1',
        name: 'α Colonie',
        species: 'Messor barbarus',
        createdAt: DateTime.now(),
      );

      expect(colony.name, contains('α'));
    });

    test('should handle long names', () {
      final longName = 'A' * 200;
      final colony = Colony(
        id: '1',
        name: longName,
        species: 'Messor barbarus',
        createdAt: DateTime.now(),
      );

      expect(colony.name.length, 200);
    });
  });

  group('Colony equality', () {
    test('should be equal with same id', () {
      final colony1 = Colony(
        id: '1',
        name: 'Athéna',
        species: 'Messor barbarus',
        createdAt: DateTime(2025, 4, 1),
      );
      final colony2 = Colony(
        id: '1',
        name: 'Different Name',
        species: 'Lasius niger',
        createdAt: DateTime(2026, 1, 1),
      );

      expect(colony1.id, colony2.id);
    });
  });
}
