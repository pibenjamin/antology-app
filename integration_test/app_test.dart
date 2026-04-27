import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:antology_app/main.dart';
import 'package:antology_app/services/storage_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Antology E2E Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    group('Colony Navigation', () {
      testWidgets('tapping Eclair shows population 25', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        final eclairFinder = find.text('Eclair');
        expect(eclairFinder, findsOneWidget);
        
        await tester.ensureVisible(eclairFinder);
        await tester.pumpAndSettle();
        await tester.tap(eclairFinder, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(find.text('Messor barbarus'), findsOneWidget);
        expect(find.text('25'), findsOneWidget);
      });

      testWidgets('tapping Mama shows population 6', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        final mamaFinder = find.text('Mama');
        expect(mamaFinder, findsOneWidget);
        
        await tester.ensureVisible(mamaFinder);
        await tester.pumpAndSettle();
        await tester.tap(mamaFinder, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(find.text('Lasius niger'), findsOneWidget);
        expect(find.text('6'), findsOneWidget);
      });

      testWidgets('tapping Athena shows population 50', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        final athenaFinder = find.text('Athéna');
        expect(athenaFinder, findsOneWidget);
        
        await tester.ensureVisible(athenaFinder);
        await tester.pumpAndSettle();
        await tester.tap(athenaFinder, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(find.text('Messor barbarus'), findsOneWidget);
        expect(find.text('50'), findsOneWidget);
      });
    });

    group('Colony Detail', () {
      testWidgets('colony detail shows species', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna'));
        await tester.pumpAndSettle();

        expect(find.text('Messor barbarus'), findsOneWidget);
        expect(find.text('Population'), findsOneWidget);
      });

      testWidgets('colony detail shows feeding section', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna'));
        await tester.pumpAndSettle();

        expect(find.text('Nourrissage'), findsOneWidget);
      });

      testWidgets('colony detail shows photos section', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Athéna'));
        await tester.pumpAndSettle();

        expect(find.text('Photos'), findsOneWidget);
        expect(find.text('Aucune photo'), findsOneWidget);
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

    group('Home Screen', () {
      testWidgets('dashboard shows colonies list', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        expect(find.text('Mes Colonies'), findsOneWidget);
        expect(find.text('Athéna'), findsOneWidget);
        expect(find.text('Eclair'), findsOneWidget);
        expect(find.text('Mama'), findsOneWidget);
      });

      testWidgets('FAB is visible', (tester) async {
        final storage = StorageService();
        await storage.init();

        await tester.pumpWidget(AntologyApp(storage: storage));
        await tester.pumpAndSettle();

        expect(find.byType(FloatingActionButton), findsOneWidget);
      });
    });
  });
}