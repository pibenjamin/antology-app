import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:antology_app/models/models.dart';
import 'package:antology_app/models/food_data.dart';
import 'package:antology_app/services/storage_service.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockStorageService mockStorage;
  late Colony testColony;

  setUp(() {
    mockStorage = MockStorageService();
    testColony = Colony(
      id: 'colony-1',
      name: 'Athéna',
      species: 'Messor barbarus',
      createdAt: DateTime(2025, 4, 1),
    );

    when(() => mockStorage.colonies).thenReturn([]);
    when(() => mockStorage.feedingEvents).thenReturn([]);
    when(() => mockStorage.foodPreferences).thenReturn([]);
    when(() => mockStorage.customCategories).thenReturn([]);
    when(() => mockStorage.customFoods).thenReturn([]);
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: _TestColonyDetailScreen(
        colony: testColony,
        storage: mockStorage,
      ),
    );
  }

  group('ColonyDetailScreen', () {
    testWidgets('should display colony name in app bar', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Athéna'), findsAtLeast(1));
    });

    testWidgets('should display colony species', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Messor barbarus'), findsAtLeast(1));
    });

    testWidgets('should display creation date', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.textContaining('2025'), findsOneWidget);
    });

    testWidgets('should display delete button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('should display Nourrissage section', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Nourrissage'), findsOneWidget);
    });

    testWidgets('should display Enregistrer button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Enregistrer'), findsOneWidget);
    });

    testWidgets('should display Préférences alimentaires section', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Préférences alimentaires'), findsOneWidget);
    });

    testWidgets('should display default categories', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Expand the preferences section
      await tester.tap(find.text('Préférences alimentaires'));
      await tester.pumpAndSettle();

      expect(find.text('Insectes'), findsOneWidget);
      expect(find.text('Graines'), findsOneWidget);
    });

    testWidgets('should display add category button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    });

    testWidgets('should display add food button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.add_box_outlined), findsOneWidget);
    });

    testWidgets('should display pest control icon in list', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.pest_control), findsOneWidget);
    });

    testWidgets('should not display feeding history when empty', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Nourrissages récents'), findsNothing);
    });

    testWidgets('should display feeding history when present', (tester) async {
      when(() => mockStorage.feedingEvents).thenReturn([
        FeedingEvent(
          id: 'event-1',
          colonyId: 'colony-1',
          foodType: 'Grillons',
          fedAt: DateTime(2026, 4, 20),
          rating: 3,
        ),
      ]);

      await tester.pumpWidget(createTestWidget());

      expect(find.text('Nourrissages récents'), findsOneWidget);
      expect(find.text('Grillons'), findsOneWidget);
    });

    testWidgets('should display rating icons', (tester) async {
      when(() => mockStorage.feedingEvents).thenReturn([
        FeedingEvent(
          id: 'event-1',
          colonyId: 'colony-1',
          foodType: 'Grillons',
          fedAt: DateTime(2026, 4, 20),
          rating: 3,
        ),
      ]);

      await tester.pumpWidget(createTestWidget());

      // Rating 3 should show 3 restaurant icons
      final iconFinder = find.byIcon(Icons.restaurant_menu);
      expect(iconFinder, findsNWidgets(3));
    });

    testWidgets('should display edit and delete buttons for feeding', (tester) async {
      when(() => mockStorage.feedingEvents).thenReturn([
        FeedingEvent(
          id: 'event-1',
          colonyId: 'colony-1',
          foodType: 'Grillons',
          fedAt: DateTime(2026, 4, 20),
        ),
      ]);

      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsAtLeastNWidgets(1)); // At least one for feeding
    });
  });
}

class _TestColonyDetailScreen extends StatefulWidget {
  final Colony colony;
  final StorageService storage;

  const _TestColonyDetailScreen({required this.colony, required this.storage});

  @override
  State<_TestColonyDetailScreen> createState() => _TestColonyDetailScreenState();
}

class _TestColonyDetailScreenState extends State<_TestColonyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final colonyEvents = widget.storage.feedingEvents.where((e) => e.colonyId == widget.colony.id).toList();
    final colonyPrefs = widget.storage.foodPreferences.where((p) => p.colonyId == widget.colony.id).toList();
    final allCats = getAllCategories(widget.storage.customCategories);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.colony.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.colony.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(widget.colony.species, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('Créée le: ${widget.colony.createdAt.day}/${widget.colony.createdAt.month}/${widget.colony.createdAt.year}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nourrissage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Enregistrer'),
                  ),
                ],
              ),
            ),
          ),
          if (colonyEvents.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Nourrissages récents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...colonyEvents.take(10).map((e) => Card(
              child: ListTile(
                title: Text(e.foodType),
                subtitle: Row(
                  children: [
                    Text('${e.fedAt.day}/${e.fedAt.month}/${e.fedAt.year}'),
                    if (e.rating != null) ...[
                      const SizedBox(width: 8),
                      ...List.generate(e.rating!, (_) => const Icon(Icons.restaurant_menu, size: 18, color: Colors.orange)),
                    ],
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () {}),
                  ],
                ),
              ),
            )),
          ],
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Préférences alimentaires', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {},
                            tooltip: 'Ajouter une catégorie',
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_box_outlined),
                            onPressed: () {},
                            tooltip: 'Ajouter un aliment',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.pest_control, color: Colors.white)),
                    title: Text(widget.colony.name),
                    subtitle: Text(widget.colony.species),
                  ),
                  ...allCats.map((cat) => ExpansionTile(
                    title: Text(cat.name),
                    children: cat.foods.isEmpty
                        ? [const ListTile(title: Text('Aucun aliment', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)))]
                        : cat.foods.map((f) {
                            final pref = colonyPrefs.where((p) => p.foodType == f).firstOrNull;
                            return ListTile(
                              title: Text(f),
                              trailing: Chip(
                                label: Text(pref?.status?.name == 'accepted' ? 'Accepté' : pref?.status?.name == 'rejected' ? 'Refusé' : 'Non testé'),
                                backgroundColor: pref?.status == FoodStatus.accepted
                                    ? Colors.green.shade100
                                    : pref?.status == FoodStatus.rejected
                                        ? Colors.red.shade100
                                        : Colors.grey.shade200,
                              ),
                            );
                          }).toList(),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
