import 'package:flutter/material.dart';
import '../models/food_data.dart';

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
    final cat = widget.categories
        .where((c) => c.name == _selectedCategory)
        .firstOrNull;
    if (cat != null) return cat.foods;
    if (_selectedCategory == 'Personnalisé') return widget.customFoods;
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Catégorie',
            prefixIcon: Icon(Icons.folder_outlined),
          ),
          value: _selectedCategory,
          isExpanded: true,
          items: widget.categories
              .map((c) => DropdownMenuItem(
                    value: c.name,
                    child: Text(c.name),
                  ))
              .toList(),
          onChanged: (v) {
            setState(() {
              _selectedCategory = v;
              _selectedFood = null;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Aliment',
            prefixIcon: Icon(Icons.restaurant_menu),
          ),
          value: _selectedFood,
          isExpanded: true,
          items: _foodsForCategory
              .map((f) => DropdownMenuItem(
                    value: f,
                    child: Text(f),
                  ))
              .toList(),
          onChanged: _selectedCategory == null
              ? null
              : (v) {
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