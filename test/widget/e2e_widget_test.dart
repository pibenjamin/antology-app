import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:antology_app/screens/home_screen.dart';
import 'package:antology_app/screens/colony_detail_screen.dart';
import 'package:antology_app/screens/add_colony_screen.dart';
import 'package:antology_app/services/storage_service.dart';
import 'package:antology_app/models/models.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('HomeScreen Widget Tests', () {
    late StorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = StorageService();
      await storage.init();
    });

    testWidgets('should show empty state when no colonies', (tester) async {
      storage.colonies.clear();
      await storage.saveColonies();

      await tester.pumpWidget(MaterialApp(home: HomeScreen(storage: storage)));
      await tester.pumpAndSettle();

      expect(find.textContaining('Aucune colonie'), findsOneWidget);
    });

    testWidgets('should show add colony button', (tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen(storage: storage)));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsWidgets);
    });

    testWidgets('should show settings tab', (tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen(storage: storage)));
      await tester.pumpAndSettle();

      final navBar = find.byType(NavigationBar);
      expect(navBar, findsOneWidget);

      final destinations = find.descendant(
        of: navBar,
        matching: find.byType(NavigationDestination),
      );
      expect(destinations, findsNWidgets(3));

      await tester.tap(destinations.at(2));
      await tester.pumpAndSettle();

      expect(find.text('Paramètres').last, findsOneWidget);
    });

    testWidgets('should show colonies list tab', (tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen(storage: storage)));
      await tester.pumpAndSettle();

      final navBar = find.byType(NavigationBar);
      final destinations = find.descendant(
        of: navBar,
        matching: find.byType(NavigationDestination),
      );

      await tester.tap(destinations.at(1));
      await tester.pumpAndSettle();

      expect(find.text('Colonies'), findsWidgets);
    });

    testWidgets('should display species for each colony', (tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen(storage: storage)));
      await tester.pumpAndSettle();

      expect(find.text('Messor barbarus'), findsWidgets);
    });

    testWidgets('should have chevron on colony list tiles', (tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen(storage: storage)));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_right), findsWidgets);
    });

    testWidgets('should show FAB on dashboard', (tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen(storage: storage)));
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should show colonies tab', (tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen(storage: storage)));
      await tester.pumpAndSettle();

      final navBar = find.byType(NavigationBar);
      final destinations = find.descendant(
        of: navBar,
        matching: find.byType(NavigationDestination),
      );

      await tester.tap(destinations.at(1));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsWidgets);
    });
  });

  group('ColonyDetailScreen Widget Tests', () {
    late StorageService storage;
    late Colony colony;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = StorageService();
      await storage.init();
      colony = storage.colonies.first;
    });

    testWidgets('should show colony name in app bar', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: colony.id, storage: storage),
      ));
      await tester.pumpAndSettle();

      expect(find.text(colony.name).first, findsOneWidget);
    });

    testWidgets('should show population', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: colony.id, storage: storage),
      ));
      await tester.pumpAndSettle();

      expect(find.text('${colony.population}'), findsOneWidget);
    });

    testWidgets('should show species', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: colony.id, storage: storage),
      ));
      await tester.pumpAndSettle();

      expect(find.text(colony.species), findsOneWidget);
    });

    testWidgets('should show created date', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: colony.id, storage: storage),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Créée le'), findsOneWidget);
    });

    testWidgets('should have edit button', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: colony.id, storage: storage),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit).first, findsOneWidget);
    });

    testWidgets('should have delete button', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: colony.id, storage: storage),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete).first, findsOneWidget);
    });

    testWidgets('should show feeding section', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: colony.id, storage: storage),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Nourrissage'), findsOneWidget);
    });

    testWidgets('should show preferences section', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: colony.id, storage: storage),
      ));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('Préférences'), findsOneWidget);
    });

    testWidgets('should show photos section', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: colony.id, storage: storage),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Photos'), findsOneWidget);
    });

    testWidgets('should show no photos message', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: colony.id, storage: storage),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Aucune photo'), findsOneWidget);
    });

    testWidgets('should show add photo button', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: colony.id, storage: storage),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add_a_photo), findsOneWidget);
    });

    testWidgets('should show categories for preferences', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: colony.id, storage: storage),
      ));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('Insectes'), findsOneWidget);
    });

    testWidgets('should show population card', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ColonyDetailScreen(colonyId: colony.id, storage: storage),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Population'), findsOneWidget);
    });
  });

  group('AddColonyScreen Widget Tests', () {
    late StorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = StorageService();
      await storage.init();
    });

    testWidgets('should show name field', (tester) async {
      await tester.pumpWidget(MaterialApp(home: AddColonyScreen(storage: storage)));
      await tester.pumpAndSettle();

      expect(find.text('Nom'), findsOneWidget);
    });

    testWidgets('should show species field', (tester) async {
      await tester.pumpWidget(MaterialApp(home: AddColonyScreen(storage: storage)));
      await tester.pumpAndSettle();

      expect(find.text('Espèce'), findsOneWidget);
    });

    testWidgets('should show add button', (tester) async {
      await tester.pumpWidget(MaterialApp(home: AddColonyScreen(storage: storage)));
      await tester.pumpAndSettle();

      expect(find.text('Ajouter'), findsOneWidget);
    });

    testWidgets('should add colony with valid input', (tester) async {
      await tester.pumpWidget(MaterialApp(home: AddColonyScreen(storage: storage)));
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextField, 'Nom'), 'NewColony');
      await tester.enterText(find.widgetWithText(TextField, 'Espèce'), 'Lasius niger');
      await tester.pump();

      await tester.tap(find.text('Ajouter'));
      await tester.pumpAndSettle();

      expect(storage.colonies.any((c) => c.name == 'NewColony'), isTrue);
    });

    testWidgets('should edit existing colony', (tester) async {
      final colony = storage.colonies.first;
      await tester.pumpWidget(MaterialApp(home: AddColonyScreen(storage: storage, colony: colony)));
      await tester.pumpAndSettle();

      expect(find.text('Modifier la colonie'), findsOneWidget);
    });
  });
}