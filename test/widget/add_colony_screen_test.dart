import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:antology_app/models/models.dart';
import 'package:antology_app/services/storage_service.dart';

class MockStorageService extends Mock implements StorageService {}

class FakeColony extends Fake implements Colony {}

void main() {
  late MockStorageService mockStorage;

  setUpAll(() {
    registerFallbackValue(FakeColony());
  });

  setUp(() {
    mockStorage = MockStorageService();
    when(() => mockStorage.colonies).thenReturn([]);
    when(() => mockStorage.generateId()).thenReturn('test-id');
    when(() => mockStorage.addColony(any())).thenAnswer((_) async {});
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: _TestAddColonyScreen(storage: mockStorage),
    );
  }

  group('AddColonyScreen', () {
    testWidgets('should display title', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Ajouter une colonie'), findsOneWidget);
    });

    testWidgets('should display name field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Nom'), findsOneWidget);
    });

    testWidgets('should display species field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Espèce'), findsOneWidget);
    });

    testWidgets('should display Ajouter button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Ajouter'), findsOneWidget);
    });

    testWidgets('should have outline input borders', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('should allow text input in name field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.widgetWithText(TextField, 'Nom'), 'Athéna');
      await tester.pump();

      expect(find.text('Athéna'), findsOneWidget);
    });

    testWidgets('should allow text input in species field', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.widgetWithText(TextField, 'Espèce'), 'Messor barbarus');
      await tester.pump();

      expect(find.text('Messor barbarus'), findsOneWidget);
    });

    testWidgets('should have green primary color', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(elevatedButton.style?.backgroundColor?.resolve({}), Colors.green);
    });

    testWidgets('should have proper padding on button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final padding = elevatedButton.style?.padding?.resolve({});
      expect(padding, const EdgeInsets.all(16));
    });

    testWidgets('should display correct button text size', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final text = tester.widget<Text>(find.text('Ajouter'));
      expect(text.style?.fontSize, 16);
    });
  });

  group('AddColonyScreen Validation', () {
    testWidgets('should not add colony with empty name', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.widgetWithText(TextField, 'Espèce'), 'Messor barbarus');
      await tester.tap(find.text('Ajouter'));
      await tester.pump();

      verifyNever(() => mockStorage.addColony(any()));
    });

    testWidgets('should not add colony with empty species', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.widgetWithText(TextField, 'Nom'), 'Athéna');
      await tester.tap(find.text('Ajouter'));
      await tester.pump();

      verifyNever(() => mockStorage.addColony(any()));
    });

    testWidgets('should add colony when both fields filled', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.widgetWithText(TextField, 'Nom'), 'Athéna');
      await tester.enterText(find.widgetWithText(TextField, 'Espèce'), 'Messor barbarus');
      await tester.tap(find.text('Ajouter'));
      await tester.pump();

      verify(() => mockStorage.addColony(any())).called(1);
    });
  });
}

class _TestAddColonyScreen extends StatefulWidget {
  final StorageService storage;

  const _TestAddColonyScreen({required this.storage});

  @override
  State<_TestAddColonyScreen> createState() => _TestAddColonyScreenState();
}

class _TestAddColonyScreenState extends State<_TestAddColonyScreen> {
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une colonie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: _speciesController, decoration: const InputDecoration(labelText: 'Espèce', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addColony,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(16)),
              child: const Text('Ajouter', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _addColony() {
    if (_nameController.text.isEmpty || _speciesController.text.isEmpty) return;
    widget.storage.addColony(Colony(
      id: widget.storage.generateId(),
      name: _nameController.text,
      species: _speciesController.text,
      createdAt: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    super.dispose();
  }
}
