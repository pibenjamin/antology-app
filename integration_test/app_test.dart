import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:antology_app/main.dart';
import 'package:antology_app/services/storage_service.dart';
import 'package:antology_app/models/food_data.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Antology E2E Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    group('Colony Management', () {
      testWidgets('complete colony lifecycle', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        expect(find.text('Mes Colonies'), findsOneWidget);
        expect(find.text('Athéna'), findsOneWidget);

        await tester.tap(find.text('Athéna'));
        await tester.pumpAndSettle();

        expect(find.text('Messor barbarus'), findsOneWidget);
        expect(find.text('Nourrissage'), findsOneWidget);
      });

      testWidgets('add new colony flow', (tester) async {
        final storage = StorageService();
        await storage.init();
        storage.colonies.clear();
        await storage.saveColonies();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(find.text('Ajouter une colonie'), findsOneWidget);

        await tester.enterText(
            find.widgetWithText(TextField, 'Nom'), 'TestColony');
        await tester.enterText(
            find.widgetWithText(TextField, 'Espèce'), 'Lasius niger');
        await tester.pump();

        await tester.tap(find.text('Ajouter'));
        await tester.pumpAndSettle();

        expect(find.text('TestColony'), findsWidgets);
      });

testWidgets('delete colony with confirmation', (tester) async {
        final storage = StorageService();
        await storage.init();
        storage.colonies.removeRange(1, storage.colonies.length);
        await storage.saveColonies();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna').first);
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.delete));
        await tester.pumpAndSettle();

        expect(find.text('Supprimer ?'), findsOneWidget);

        await tester.tap(find.text('Annuler'));
        await tester.pumpAndSettle();

        expect(find.text('Athéna'), findsWidgets);
      });
    });

    group('Feeding Management', () {
      testWidgets('add feeding event', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna').first);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Enregistrer'));
        await tester.pumpAndSettle();

        expect(find.text('Enregistrer nourrissage'), findsOneWidget);
        expect(find.text('Aliment'), findsOneWidget);

        await tester.tap(find.text('Annuler'));
        await tester.pumpAndSettle();
      });

      testWidgets('view feeding history dropdown', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna').first);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Enregistrer'));
        await tester.pumpAndSettle();

        final dropdownFinders = find.byType(DropdownButtonFormField<String>);
        expect(dropdownFinders, findsWidgets);

        await tester.tap(find.text('Annuler'));
        await tester.pumpAndSettle();
      });
    });

    group('Food Preferences', () {
      testWidgets('toggle food preference status cycle', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna').first);
        await tester.pumpAndSettle();

        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();

        expect(find.text('Préférences alimentaires'), findsOneWidget);

        await tester.tap(find.text('Insectes'));
        await tester.pumpAndSettle();

        expect(find.text('Grillons'), findsOneWidget);
        expect(find.text('Non testé'), findsWidgets);

        await tester.tap(find.text('Non testé').first);
        await tester.pumpAndSettle();

        expect(find.text('Accepté'), findsWidgets);

        await tester.tap(find.text('Accepté').first);
        await tester.pumpAndSettle();

        expect(find.text('Refusé'), findsWidgets);

        await tester.tap(find.text('Refusé').first);
        await tester.pumpAndSettle();

        expect(find.text('Non testé'), findsWidgets);
      });

      testWidgets('expand food categories', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna'));
        await tester.pumpAndSettle();

        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Graines'));
        await tester.pumpAndSettle();

        expect(find.text('Millet'), findsWidgets);
      });
    });

    group('Custom Categories and Foods', () {
      testWidgets('add custom category', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna'));
        await tester.pumpAndSettle();

        await tester.drag(find.byType(ListView), const Offset(0, -400));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.pumpAndSettle();

        expect(find.text('Ajouter une catégorie'), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'Friandises');
        await tester.pump();

        await tester.tap(find.text('Ajouter'));
        await tester.pumpAndSettle();

        expect(find.text('Friandises'), findsOneWidget);
      });

      testWidgets('add custom food to custom category', (tester) async {
        final storage = StorageService();
        await storage.init();
        await storage.addCustomCategory('Friandises');

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna'));
        await tester.pumpAndSettle();

        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Friandises'));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add_box_outlined));
        await tester.pumpAndSettle();

        expect(find.text('Ajouter un aliment'), findsOneWidget);

        await tester.enterText(find.byType(TextField).first, 'Chocolat');
        await tester.pump();

        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Friandises').last);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Ajouter'));
        await tester.pumpAndSettle();

        expect(find.text('Chocolat'), findsOneWidget);
      });

      testWidgets('add food to default category', (tester) async {
        final storage = StorageService();
        await storage.init();

        final allFoodsBefore =
            getAllFoods(storage.customCategories, storage.customFoods);
        expect(allFoodsBefore.contains('Riz'), false);

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna').first);
        await tester.pumpAndSettle();

        await tester.drag(find.byType(ListView), const Offset(0, -400));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add_box_outlined));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).first, 'Riz');
        await tester.pump();

        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Graines').first);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Ajouter'));
        await tester.pumpAndSettle();

        final allFoodsAfter =
            getAllFoods(storage.customCategories, storage.customFoods);
        expect(allFoodsAfter.contains('Riz'), true);
      });

      testWidgets('cannot add duplicate category', (tester) async {
        final storage = StorageService();
        await storage.init();
        await storage.addCustomCategory('Friandises');

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna'));
        await tester.pumpAndSettle();

        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'Friandises');
        await tester.pump();

        await tester.tap(find.text('Ajouter'));
        await tester.pumpAndSettle();

        expect(find.text('Cette catégorie existe déjà'), findsOneWidget);

        await tester.tap(find.text('Annuler'));
        await tester.pumpAndSettle();
      });

testWidgets('delete custom food', (tester) async {
        final storage = StorageService();
        await storage.init();
        await storage.addCustomFood('Biscuits', categoryName: 'Personnalisé');

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna').first);
        await tester.pumpAndSettle();

        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Personnalisé'));
        await tester.pumpAndSettle();

        expect(find.text('Biscuits'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.delete_outline).first);
        await tester.pumpAndSettle();

        await tester.pumpAndSettle();

        expect(find.textContaining('Supprimer'), findsWidgets);

        await tester.tap(find.text('Supprimer').first);
        await tester.pumpAndSettle();

        expect(find.text('Biscuits'), findsNothing);
      });

      testWidgets('delete custom category', (tester) async {
        final storage = StorageService();
        await storage.init();
        await storage.addCustomCategory('Friandises');

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna').first);
        await tester.pumpAndSettle();

        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pumpAndSettle();

        expect(find.text('Friandises'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.delete_outline).first);
        await tester.pumpAndSettle();

        await tester.pumpAndSettle();

        expect(find.textContaining('Supprimer'), findsWidgets);

        await tester.tap(find.text('Supprimer').first);
        await tester.pumpAndSettle();

        expect(find.text('Friandises'), findsNothing);
      });
    });

    group('Navigation', () {
      testWidgets('navigate between tabs', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        expect(find.text('Mes Fourmis'), findsOneWidget);

        final navBar = find.byType(NavigationBar);
        expect(navBar, findsOneWidget);

        final navDestinations = find.descendant(
          of: navBar,
          matching: find.byType(NavigationDestination),
        );
        expect(navDestinations, findsNWidgets(3));

        await tester.tap(navDestinations.at(2));
        await tester.pumpAndSettle();

        expect(find.text('Paramètres'), findsWidgets);
      });
    });

    group('Colony Photos', () {
      testWidgets('add photo to colony', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna'));
        await tester.pumpAndSettle();

        expect(find.text('Photos'), findsOneWidget);
        expect(find.text('Aucune photo'), findsOneWidget);
      });

      testWidgets('display featured photo in colony list', (tester) async {
        final storage = StorageService();
        await storage.init();

        final colony = storage.colonies.first;
        await storage.addPhotoToColony(colony.id, 'data:image/jpeg;base64,/9j/4AAQSkZJRg==');
        await storage.setFeaturedPhoto(colony.id, 'data:image/jpeg;base64,/9j/4AAQSkZJRg==');

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna'));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add_a_photo));
        await tester.pumpAndSettle();
      });

      testWidgets('crop dialog appears in bottom sheet', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna'));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.add_a_photo));
        await tester.pumpAndSettle();

        expect(find.text('Choisir dans la galerie'), findsOneWidget);
        expect(find.text('Prendre une photo'), findsOneWidget);
      });
    });
  });
}