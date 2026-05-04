import 'package:flutter_test/flutter_test.dart';
import 'package:antology_app/models/models.dart';
import 'package:antology_app/services/timeline_service.dart';

void main() {
  group('Timeline Service Tests', () {
    final colony = Colony(
      id: 'c1',
      name: 'Athéna',
      species: 'Messor barbarus',
      createdAt: DateTime(2025, 4, 14),
      population: 600,
      photos: [],
    );

    test('US4.1 - Frise commence à la fondation', () {
      final events = TimelineService.generateEvents(
        colony: colony,
        feedingEvents: [],
        growthRecords: [],
        growthThresholds: [],
      );

      expect(events.first.type, 'fondation');
      expect(events.first.date, DateTime(2025, 4, 14));
    });

    test('US4.1 - Frise contient un événement de fin (aujourd\'hui)', () {
      final events = TimelineService.generateEvents(
        colony: colony,
        feedingEvents: [],
        growthRecords: [],
        growthThresholds: [],
      );

      final now = DateTime.now();
      expect(events.last.date.isBefore(now) || events.last.date.isAtSameMomentAs(now), isTrue);
    });

    test('US4.2 - Nourrissages marqués sur la frise', () {
      final feedingEvents = [
        FeedingEvent(
          id: 'f1',
          colonyId: 'c1',
          foodType: 'Grillons',
          fedAt: DateTime(2025, 4, 15),
          rating: 4,
        ),
      ];

      final events = TimelineService.generateEvents(
        colony: colony,
        feedingEvents: feedingEvents,
        growthRecords: [],
        growthThresholds: [],
      );

      final feedingEventsInTimeline = events.where((e) => e.type == 'nourrissage').toList();
      expect(feedingEventsInTimeline.length, 1);
      expect(feedingEventsInTimeline.first.label, contains('Grillons'));
      expect(feedingEventsInTimeline.first.label, contains('4'));
    });

    test('US4.3 - Seuils de croissance marqués via historique', () {
      final growthRecords = [
        GrowthRecord(
          id: 'g1',
          colonyId: 'c1',
          populationEstimate: 500,
          recordedAt: DateTime(2025, 5, 1),
        ),
      ];

      final events = TimelineService.generateEvents(
        colony: colony,
        feedingEvents: [],
        growthRecords: growthRecords,
        growthThresholds: [100, 500, 1000],
      );

      final growthEvents = events.where((e) => e.type == 'croissance').toList();
      expect(growthEvents.length, greaterThan(0));
      expect(growthEvents.any((e) => e.label.contains('500')), isTrue);
    });

    test('Nouveau - Chaque changement de population est un événement', () {
      final growthRecords = [
        GrowthRecord(id: 'g1', colonyId: 'c1', populationEstimate: 150, recordedAt: DateTime(2025, 4, 20)),
        GrowthRecord(id: 'g2', colonyId: 'c1', populationEstimate: 450, recordedAt: DateTime(2025, 5, 10)),
      ];

      // Pas de seuils définis, on veut voir les changements bruts
      final events = TimelineService.generateEvents(
        colony: colony,
        feedingEvents: [],
        growthRecords: growthRecords,
        growthThresholds: [],
      );

      final growthEvents = events.where((e) => e.type == 'croissance').toList();
      // On attend 2 événements car il y a 2 enregistrements
      expect(growthEvents.length, 2); 
      expect(growthEvents.any((e) => e.label.contains('150')), isTrue);
      expect(growthEvents.any((e) => e.label.contains('450')), isTrue);
    });

    test('US4.4 - Photos marquées sur la frise', () {
      final colonyWithPhotos = Colony(
        id: colony.id,
        name: colony.name,
        species: colony.species,
        createdAt: colony.createdAt,
        population: colony.population,
        photos: ['data:image/jpeg;base64,abc123'],
        featuredPhoto: colony.featuredPhoto,
      );

      final events = TimelineService.generateEvents(
        colony: colonyWithPhotos,
        feedingEvents: [],
        growthRecords: [],
        growthThresholds: [],
      );

      final photoEvents = events.where((e) => e.type == 'photo').toList();
      expect(photoEvents.length, greaterThan(0));
    });

    test('Événements triés par date', () {
      final feedingEvents = [
        FeedingEvent(
          id: 'f1',
          colonyId: 'c1',
          foodType: 'Grillons',
          fedAt: DateTime(2025, 5, 1),
          rating: 4,
        ),
      ];

      final events = TimelineService.generateEvents(
        colony: colony,
        feedingEvents: feedingEvents,
        growthRecords: [],
        growthThresholds: [],
      );

      for (var i = 0; i < events.length - 1; i++) {
        expect(events[i].date.isBefore(events[i + 1].date) ||
               events[i].date.isAtSameMomentAs(events[i + 1].date), isTrue);
      }
    });
  });
}
