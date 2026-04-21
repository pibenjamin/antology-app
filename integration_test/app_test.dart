import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:antology_app/main.dart';
import 'package:antology_app/services/storage_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Tests', () {
    testWidgets('complete colony lifecycle', (tester) async {
      // Set up mock shared preferences
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      
      final storage = StorageService();
      await storage.init();

      // Start the app
      await tester.pumpWidget(AntologyApp(storage: storage));
      await tester.pumpAndSettle();

      // Should see seed data (3 colonies)
      expect(find.text('Mes Colonies'), findsOneWidget);
      expect(find.text('Athéna'), findsOneWidget);

      // Navigate to colony detail
      await tester.tap(find.text('Athéna'));
      await tester.pumpAndSettle();

      // Should see colony details
      expect(find.text('Messor barbarus'), findsOneWidget);

      // Should see Nourrissage section
      expect(find.text('Nourrissage'), findsOneWidget);

      // Go back
      await tester.pageBack();
      await tester.pumpAndSettle();
    });

    testWidgets('add new colony flow', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      
      final storage = StorageService();
      await storage.init();

      // Clear seed data for this test by removing the 3 seed colonies
      storage.colonies.clear();
      await storage._saveColonies();

      await tester.pumpWidget(AntologyApp(storage: storage));
      await tester.pumpAndSettle();

      // Should see empty state
      expect(find.text('Aucune colonie\nAppuyez sur + pour ajouter votre première colonie'), findsOneWidget);

      // Tap FAB to add colony
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Should navigate to add colony screen
      expect(find.text('Ajouter une colonie'), findsOneWidget);

      // Enter colony details
      await tester.enterText(find.widgetWithText(TextField, 'Nom'), 'TestColony');
      await tester.pump();
      await tester.enterText(find.widgetWithText(TextField, 'Espèce'), 'Lasius niger');
      await tester.pump();

      // Tap add button
      await tester.tap(find.text('Ajouter'));
      await tester.pumpAndSettle();

      // Should see the new colony in list
      expect(find.text('TestColony'), findsOneWidget);
    });

    testWidgets('add feeding flow', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      
      final storage = StorageService();
      await storage.init();

      await tester.pumpWidget(AntologyApp(storage: storage));
      await tester.pumpAndSettle();

      // Navigate to colony detail
      await tester.tap(find.text('Athéna'));
      await tester.pumpAndSettle();

      // Tap Enregistrer button
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      // Should see the feeding dialog
      expect(find.text('Enregistrer nourrissage'), findsOneWidget);
      expect(find.text('Aliment'), findsOneWidget);

      // Close the dialog
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();
    });

    testWidgets('view food preferences', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      
      final storage = StorageService();
      await storage.init();

      await tester.pumpWidget(AntologyApp(storage: storage));
      await tester.pumpAndSettle();

      // Navigate to colony detail
      await tester.tap(find.text('Athéna'));
      await tester.pumpAndSettle();

      // Scroll down to preferences
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Should see Préférences alimentaires
      expect(find.text('Préférences alimentaires'), findsOneWidget);

      // Expand Insectes category
      await tester.tap(find.text('Insectes'));
      await tester.pumpAndSettle();

      // Should see insects
      expect(find.text('Grillons'), findsOneWidget);
    });

    testWidgets('navigation between tabs', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      
      final storage = StorageService();
      await storage.init();

      await tester.pumpWidget(AntologyApp(storage: storage));
      await tester.pumpAndSettle();

      // Default tab is Dashboard
      expect(find.text('Mes Fourmis'), findsOneWidget);

      // Navigate to Colonies tab
      await tester.tap(find.text('Colonies'));
      await tester.pumpAndSettle();

      expect(find.text('Colonies'), findsOneWidget);

      // Navigate to Settings tab
      await tester.tap(find.text('Paramètres'));
      await tester.pumpAndSettle();

      expect(find.text('Mode débogage'), findsOneWidget);
    });

    testWidgets('delete colony flow', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      
      final storage = StorageService();
      await storage.init();

      // Keep only one colony for this test
      storage.colonies.removeRange(1, storage.colonies.length);
      await storage._saveColonies();

      await tester.pumpWidget(AntologyApp(storage: storage));
      await tester.pumpAndSettle();

      // Navigate to colony detail
      await tester.tap(find.text('Athéna'));
      await tester.pumpAndSettle();

      // Tap delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Should see confirmation dialog
      expect(find.text('Supprimer ?'), findsOneWidget);

      // Cancel
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      // Colony should still exist
      expect(find.text('Athéna'), findsOneWidget);
    });
  });
}
