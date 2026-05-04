import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antology_app/screens/colony_detail_screen.dart';
import 'package:antology_app/models/models.dart';
import 'package:antology_app/services/storage_service.dart';

void main() {
  group('Timeline Integration Tests', () {
    late StorageService storage;

    setUp(() async {
      storage = StorageService();
      await storage.init();
    });

    testWidgets('US4.1 - Frise visible dans ColonyDetailScreen', (WidgetTester tester) async {
      // Créer une colonie
      final colony = Colony(
        id: 'test-c1',
        name: 'Test Colony',
        species: 'Test Species',
        createdAt: DateTime(2025, 4, 14),
        population: 500,
        photos: [],
      );
      await storage.addColony(colony);

      // Lancer l'écran directement
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: 'test-c1', storage: storage),
      ));
      await tester.pumpAndSettle();

      // Vérifier que la frise est affichée
      expect(find.text('Évolution'), findsOneWidget);
      expect(find.text('Fondation de Test Colony'), findsOneWidget);
    });

    testWidgets('US4.2 - Nourrissage affiché dans la frise', (WidgetTester tester) async {
      final colony = Colony(
        id: 'test-c2',
        name: 'Colony 2',
        species: 'Species 2',
        createdAt: DateTime(2025, 4, 10),
        population: 200,
        photos: [],
      );
      await storage.addColony(colony);

      await storage.addFeedingEvent(FeedingEvent(
        id: 'test-f2',
        colonyId: 'test-c2',
        foodType: 'Miel',
        fedAt: DateTime(2025, 4, 12),
        rating: 5,
      ));

      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: 'test-c2', storage: storage),
      ));
      await tester.pumpAndSettle();

      // Vérifier qu'au moins un widget contient 'Miel' (frise ou liste)
      expect(find.textContaining('Miel'), findsAtLeast(1));
    });
  });
}
