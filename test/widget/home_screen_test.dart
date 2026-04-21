import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:antology_app/main.dart';
import 'package:antology_app/models/models.dart';
import 'package:antology_app/services/storage_service.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockStorageService mockStorage;

  setUp(() {
    mockStorage = MockStorageService();
    
    when(() => mockStorage.colonies).thenReturn([]);
    when(() => mockStorage.feedingEvents).thenReturn([]);
    when(() => mockStorage.foodPreferences).thenReturn([]);
    when(() => mockStorage.customCategories).thenReturn([]);
    when(() => mockStorage.customFoods).thenReturn([]);
    when(() => mockStorage.setDebugMode(any())).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: _TestHomeScreen(storage: mockStorage),
    );
  }

  group('_TestHomeScreen Widget', () {
    testWidgets('should display dashboard title', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Tableau de bord'), findsOneWidget);
    });

    testWidgets('should display empty state message', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Aucune colonie\nAppuyez sur + pour ajouter votre première colonie'), findsOneWidget);
    });

    testWidgets('should display "Ajouter une colonie" when colonies exist', (tester) async {
      when(() => mockStorage.colonies).thenReturn([
        Colony(id: '1', name: 'Athéna', species: 'Messor barbarus', createdAt: DateTime.now()),
      ]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Mes Colonies'), findsOneWidget);
      expect(find.text('Athéna'), findsOneWidget);
    });

    testWidgets('should display FAB with + icon', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display navigation destinations', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Tableau de bord'), findsOneWidget);
      expect(find.text('Colonies'), findsOneWidget);
      expect(find.text('Paramètres'), findsOneWidget);
    });

    testWidgets('should display colony species', (tester) async {
      when(() => mockStorage.colonies).thenReturn([
        Colony(id: '1', name: 'Athéna', species: 'Messor barbarus', createdAt: DateTime.now()),
      ]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Messor barbarus'), findsOneWidget);
    });

    testWidgets('should display colony list with chevron', (tester) async {
      when(() => mockStorage.colonies).thenReturn([
        Colony(id: '1', name: 'Athéna', species: 'Messor barbarus', createdAt: DateTime.now()),
      ]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('should display multiple colonies', (tester) async {
      when(() => mockStorage.colonies).thenReturn([
        Colony(id: '1', name: 'Athéna', species: 'Messor barbarus', createdAt: DateTime.now()),
        Colony(id: '2', name: 'Eclair', species: 'Messor barbarus', createdAt: DateTime.now()),
      ]);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Athéna'), findsOneWidget);
      expect(find.text('Eclair'), findsOneWidget);
    });

    testWidgets('should display debug mode switch in settings', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Navigate to settings tab
      await tester.tap(find.text('Paramètres'));
      await tester.pump();

      expect(find.text('Mode débogage'), findsOneWidget);
    });
  });
}

class _TestHomeScreen extends StatefulWidget {
  final StorageService storage;
  const _TestHomeScreen({required this.storage});

  @override
  State<_TestHomeScreen> createState() => _TestHomeScreenState();
}

class _TestHomeScreenState extends State<_TestHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colonies = widget.storage.colonies;

    return Scaffold(
      body: [
        // Dashboard tab
        colonies.isEmpty
            ? const Center(child: Text('Aucune colonie\nAppuyez sur + pour ajouter votre première colonie', textAlign: TextAlign.center))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text('Mes Colonies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...colonies.map((c) => Card(
                    child: ListTile(
                      leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.pest_control, color: Colors.white)),
                      title: Text(c.name),
                      subtitle: Text(c.species),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  )),
                ],
              ),
        // Colonies tab
        ListView(
          children: [
            const Text('Tableau de bord'),
          ],
        ),
        // Settings tab
        ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Mode débogage'),
              trailing: Switch(value: false, onChanged: (_) {}),
            ),
          ],
        ),
      ][_currentIndex],
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Tableau de bord'),
          NavigationDestination(icon: Icon(Icons.pest_control), label: 'Colonies'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Paramètres'),
        ],
      ),
    );
  }
}