import 'package:flutter/material.dart';
import '../models/models.dart';
import '../models/food_data.dart';
import '../services/storage_service.dart';

class ColonyDetailScreen extends StatefulWidget {
  final Colony colony;
  final StorageService storage;

  const ColonyDetailScreen({super.key, required this.colony, required this.storage});

  @override
  State<ColonyDetailScreen> createState() => _ColonyDetailScreenState();
}

class _ColonyDetailScreenState extends State<ColonyDetailScreen> {
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final colonyEvents = widget.storage.feedingEvents.where((e) => e.colonyId == widget.colony.id).toList()..sort((a, b) => b.fedAt.compareTo(a.fedAt));
    final colonyPrefs = widget.storage.foodPreferences.where((p) => p.colonyId == widget.colony.id).toList();
    final allCats = getAllCategories(widget.storage.customCategories);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.colony.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nourrissage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        onPressed: () => _showAddFeeding(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Enregistrer'),
                      ),
                    ],
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
                    IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _showEditFeeding(context, e)),
                    IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => _showDeleteFeeding(context, e)),
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
                            onPressed: () => _showAddCategory(context),
                            tooltip: 'Ajouter une catégorie',
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_box_outlined),
                            onPressed: () => _showAddFood(context),
                            tooltip: 'Ajouter un aliment',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...allCats.map((cat) {
                    final isCustomCategory = widget.storage.customCategories.any((c) => c.name.toLowerCase() == cat.name.toLowerCase());
                    return ExpansionTile(
                      title: Row(
                        children: [
                          Expanded(child: Text(cat.name)),
                          if (isCustomCategory)
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                              onPressed: () => _showDeleteCategory(context, cat.name),
                              tooltip: 'Supprimer la catégorie',
                            ),
                        ],
                      ),
                      children: cat.foods.isEmpty
                          ? [const ListTile(title: Text('Aucun aliment', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)))]
                          : cat.foods.map((f) {
                              final pref = colonyPrefs.where((p) => p.foodType == f).firstOrNull;
                              final isCustomFood = widget.storage.customFoods.any((food) => food.toLowerCase() == f.toLowerCase());
                              return ListTile(
                                title: Text(f),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isCustomFood)
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                        onPressed: () => _showDeleteFood(context, f),
                                        tooltip: 'Supprimer l\'aliment',
                                      ),
                                    GestureDetector(
                                      onTap: () => _togglePref(context, f, pref?.status),
                                      child: Chip(
                                        label: Text(pref?.status?.name == 'accepted' ? 'Accepté' : pref?.status?.name == 'rejected' ? 'Refusé' : 'Non testé'),
                                        backgroundColor: pref?.status == FoodStatus.accepted
                                            ? Colors.green.shade100
                                            : pref?.status == FoodStatus.rejected
                                                ? Colors.red.shade100
                                                : Colors.grey.shade200,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ?'),
        content: Text('Supprimer "${widget.colony.name}" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              widget.storage.deleteColony(widget.colony.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteFeeding(BuildContext context, FeedingEvent event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ?'),
        content: Text('Supprimer ce nourrissage de "${event.foodType}" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              widget.storage.deleteFeedingEvent(event.id);
              Navigator.pop(ctx);
              _refresh();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showEditFeeding(BuildContext context, FeedingEvent event) {
    String? selectedFood = event.foodType;
    final quantityController = TextEditingController(text: event.quantity);
    final allFoodsList = getAllFoods(widget.storage.customCategories, widget.storage.customFoods);
    DateTime selectedDate = event.fedAt;
    int? selectedRating = event.rating;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Modifier nourrissage'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              DropdownButtonFormField<String>(
                value: allFoodsList.contains(event.foodType) ? event.foodType : null,
                decoration: const InputDecoration(labelText: 'Aliment'),
                items: allFoodsList.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                onChanged: (v) => selectedFood = v,
              ),
              const SizedBox(height: 16),
              TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantité (optionnel)')),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setDialogState(() => selectedDate = picked);
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text('Note', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final rating = index + 1;
                  return GestureDetector(
                    onTap: () => setDialogState(() => selectedRating = rating),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.restaurant_menu,
                        size: selectedRating != null && rating <= selectedRating! ? 32 : 24,
                        color: selectedRating != null && rating <= selectedRating! ? Colors.orange : Colors.grey,
                      ),
                    ),
                  );
                }),
              ),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () {
                if (selectedFood == null) return;
                widget.storage.updateFeedingEvent(FeedingEvent(
                  id: event.id,
                  colonyId: event.colonyId,
                  foodType: selectedFood!,
                  quantity: quantityController.text.isEmpty ? null : quantityController.text,
                  fedAt: selectedDate,
                  rating: selectedRating,
                ));
                Navigator.pop(ctx);
                _refresh();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFeeding(BuildContext context) {
    String? selectedFood;
    final quantityController = TextEditingController();
    final allFoodsList = getAllFoods(widget.storage.customCategories, widget.storage.customFoods);
    DateTime selectedDate = DateTime.now();
    int? selectedRating;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Enregistrer nourrissage'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Aliment'),
                items: allFoodsList.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                onChanged: (v) => selectedFood = v,
              ),
              const SizedBox(height: 16),
              TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantité (optionnel)')),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setDialogState(() => selectedDate = picked);
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text('Note', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final rating = index + 1;
                  return GestureDetector(
                    onTap: () => setDialogState(() => selectedRating = rating),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        Icons.restaurant_menu,
                        size: selectedRating != null && rating <= selectedRating! ? 32 : 24,
                        color: selectedRating != null && rating <= selectedRating! ? Colors.orange : Colors.grey,
                      ),
                    ),
                  );
                }),
              ),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () {
                if (selectedFood == null) return;
                widget.storage.addFeedingEvent(FeedingEvent(
                  id: widget.storage.generateId(),
                  colonyId: widget.colony.id,
                  foodType: selectedFood!,
                  quantity: quantityController.text.isEmpty ? null : quantityController.text,
                  fedAt: selectedDate,
                  rating: selectedRating,
                ));
                Navigator.pop(ctx);
                _refresh();
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCategory(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter une catégorie'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: controller, decoration: const InputDecoration(labelText: 'Nom de la catégorie'), autofocus: true),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              final success = await widget.storage.addCustomCategory(controller.text.trim());
              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cette catégorie existe déjà')),
                );
                return;
              }
              Navigator.pop(ctx);
              _refresh();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showAddFood(BuildContext context) {
    final controller = TextEditingController();
    String? selectedCategory;
    final allCats = getAllCategories(widget.storage.customCategories);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter un aliment'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: controller, decoration: const InputDecoration(labelText: 'Nom de l\'aliment')),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Catégorie (optionnel)'),
            items: allCats.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
            onChanged: (v) => selectedCategory = v,
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              await widget.storage.addCustomFood(controller.text.trim(), categoryName: selectedCategory);
              Navigator.pop(ctx);
              _refresh();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _togglePref(BuildContext context, String food, FoodStatus? current) async {
    final FoodStatus newStatus;
    if (current == null || current == FoodStatus.unknown) {
      newStatus = FoodStatus.accepted;
    } else if (current == FoodStatus.accepted) {
      newStatus = FoodStatus.rejected;
    } else {
      newStatus = FoodStatus.unknown;
    }
    await widget.storage.addFoodPreference(FoodPreference(colonyId: widget.colony.id, foodType: food, status: newStatus));
    _refresh();
  }

  void _showDeleteCategory(BuildContext context, String categoryName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la catégorie ?'),
        content: Text('Supprimer "$categoryName" et tous ses aliments ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              await widget.storage.deleteCustomCategory(categoryName);
              Navigator.pop(ctx);
              _refresh();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showDeleteFood(BuildContext context, String foodName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer l\'aliment ?'),
        content: Text('Supprimer "$foodName" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              await widget.storage.deleteCustomFood(foodName);
              Navigator.pop(ctx);
              _refresh();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
