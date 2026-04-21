import 'package:flutter_test/flutter_test.dart';
import 'package:antology_app/models/models.dart';

void main() {
  group('FeedingEvent', () {
    test('should create feeding event with all required fields', () {
      final event = FeedingEvent(
        id: '1',
        colonyId: 'colony-1',
        foodType: 'Grillons',
        fedAt: DateTime(2026, 4, 21),
      );

      expect(event.id, '1');
      expect(event.colonyId, 'colony-1');
      expect(event.foodType, 'Grillons');
      expect(event.fedAt, DateTime(2026, 4, 21));
      expect(event.quantity, isNull);
      expect(event.notes, isNull);
      expect(event.rating, isNull);
    });

    test('should create feeding event with optional fields', () {
      final event = FeedingEvent(
        id: '1',
        colonyId: 'colony-1',
        foodType: 'Grillons',
        quantity: '5',
        fedAt: DateTime(2026, 4, 21),
        notes: 'Bien mangé',
        rating: 4,
      );

      expect(event.quantity, '5');
      expect(event.notes, 'Bien mangé');
      expect(event.rating, 4);
    });

    test('should allow null rating', () {
      final event = FeedingEvent(
        id: '1',
        colonyId: 'colony-1',
        foodType: 'Graines de canari',
        fedAt: DateTime.now(),
        rating: null,
      );

      expect(event.rating, isNull);
    });

    test('should accept valid rating values 1-5', () {
      for (int rating = 1; rating <= 5; rating++) {
        final event = FeedingEvent(
          id: '1',
          colonyId: 'colony-1',
          foodType: 'Grillons',
          fedAt: DateTime.now(),
          rating: rating,
        );
        expect(event.rating, rating);
      }
    });

    test('should handle empty string quantity', () {
      final event = FeedingEvent(
        id: '1',
        colonyId: 'colony-1',
        foodType: 'Grillons',
        quantity: '',
        fedAt: DateTime.now(),
      );

      expect(event.quantity, '');
    });

    test('should handle special characters in food type', () {
      final event = FeedingEvent(
        id: '1',
        colonyId: 'colony-1',
        foodType: 'Graines d\'échalotte',
        fedAt: DateTime.now(),
      );

      expect(event.foodType, contains("'"));
    });
  });

  group('FeedingEvent comparison', () {
    test('should sort by fedAt descending', () {
      final events = [
        FeedingEvent(id: '1', colonyId: '1', foodType: 'A', fedAt: DateTime(2026, 1, 1)),
        FeedingEvent(id: '2', colonyId: '1', foodType: 'B', fedAt: DateTime(2026, 4, 1)),
        FeedingEvent(id: '3', colonyId: '1', foodType: 'C', fedAt: DateTime(2026, 2, 1)),
      ];

      events.sort((a, b) => b.fedAt.compareTo(a.fedAt));

      expect(events[0].foodType, 'B');
      expect(events[1].foodType, 'C');
      expect(events[2].foodType, 'A');
    });
  });
}
