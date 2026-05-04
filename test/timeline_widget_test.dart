import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antology_app/models/models.dart';
import 'package:antology_app/services/timeline_service.dart';
import 'package:antology_app/widgets/timeline_widget.dart';

void main() {
  group('Timeline Widget Tests', () {
    final colony = Colony(
      id: 'c1',
      name: 'Athéna',
      species: 'Messor barbarus',
      createdAt: DateTime(2025, 4, 14),
      population: 600,
      photos: [],
    );

    final feedingEvents = [
      FeedingEvent(
        id: 'f1',
        colonyId: 'c1',
        foodType: 'Grillons',
        fedAt: DateTime(2025, 4, 15),
        rating: 4,
      ),
    ];

    final growthRecords = [
      GrowthRecord(
        id: 'g1',
        colonyId: 'c1',
        populationEstimate: 500,
        recordedAt: DateTime(2025, 5, 1),
      ),
    ];

    testWidgets('US4.1 - Affichage de la frise chronologique', (WidgetTester tester) async {
      final events = TimelineService.generateEvents(
        colony: colony,
        feedingEvents: feedingEvents,
        growthRecords: growthRecords,
        growthThresholds: [100, 500, 1000],
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TimelineWidget(events: events),
        ),
      ));

      expect(find.byType(TimelineWidget), findsOneWidget);
      expect(find.text('Fondation de Athéna'), findsOneWidget);
    });

    testWidgets('US4.1 - Frise contient un marqueur pour nourrissage', (WidgetTester tester) async {
      final events = TimelineService.generateEvents(
        colony: colony,
        feedingEvents: feedingEvents,
        growthRecords: growthRecords,
        growthThresholds: [100, 500, 1000],
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TimelineWidget(events: events),
        ),
      ));

      expect(find.textContaining('Grillons'), findsOneWidget);
    });

    testWidgets('US4.3 - Frise contient marqueur croissance', (WidgetTester tester) async {
      final events = TimelineService.generateEvents(
        colony: colony,
        feedingEvents: feedingEvents,
        growthRecords: growthRecords,
        growthThresholds: [100, 500, 1000],
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TimelineWidget(events: events),
        ),
      ));

      expect(find.textContaining('500'), findsOneWidget);
    });
  });
}
