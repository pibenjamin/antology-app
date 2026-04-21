import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antology_app/models/food_data.dart';

void main() {
  group('CategoryFoodSelector', () {
    testWidgets('should display category dropdown then food dropdown', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CategoryFoodSelector(
            categories: getAllCategories([]),
            onSelected: (category, food) {},
          ),
        ),
      ));

      expect(find.text('Catégorie'), findsOneWidget);
      expect(find.text('Aliment'), findsOneWidget);
    });

    testWidgets('should have food dropdown disabled by default', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CategoryFoodSelector(
            categories: getAllCategories([]),
            onSelected: (category, food) {},
          ),
        ),
      ));

      final foodDropdown = tester.widget<DropdownButtonFormField<String>>(
        find.ancestor(of: find.text('Aliment'), matching: find.byType(DropdownButtonFormField<String>)),
      );
      expect(foodDropdown.onChanged, isNull);
    });

    testWidgets('should show categories when tapping category dropdown', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CategoryFoodSelector(
            categories: getAllCategories([]),
            onSelected: (category, food) {},
          ),
        ),
      ));

      await tester.tap(find.text('Catégorie'));
      await tester.pumpAndSettle();

      expect(find.byType(DropdownMenuItem<String>), findsWidgets);
    });
  });
}

class CategoryFoodSelector extends StatefulWidget {
  final List<FoodCategory> categories;
  final List<String> customFoods;
  final void Function(String category, String food) onSelected;

  const CategoryFoodSelector({
    super.key,
    required this.categories,
    this.customFoods = const [],
    required this.onSelected,
  });

  @override
  State<CategoryFoodSelector> createState() => _CategoryFoodSelectorState();
}

class _CategoryFoodSelectorState extends State<CategoryFoodSelector> {
  String? _selectedCategory;
  String? _selectedFood;

  List<String> get _foodsForCategory {
    if (_selectedCategory == null) return [];
    final cat = widget.categories.where((c) => c.name == _selectedCategory).firstOrNull;
    if (cat != null) return cat.foods;
    if (_selectedCategory == 'Personnalisé') return widget.customFoods;
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Catégorie'),
          value: _selectedCategory,
          items: widget.categories.map((c) => DropdownMenuItem(
            value: c.name,
            child: Text(c.name),
          )).toList(),
          onChanged: (v) {
            setState(() {
              _selectedCategory = v;
              _selectedFood = null;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Aliment'),
          value: _selectedFood,
          items: _foodsForCategory.map((f) => DropdownMenuItem(
            value: f,
            child: Text(f),
          )).toList(),
          onChanged: _selectedCategory == null ? null : (v) {
            setState(() => _selectedFood = v);
            if (_selectedCategory != null && v != null) {
              widget.onSelected(_selectedCategory!, v);
            }
          },
        ),
      ],
    );
  }
}