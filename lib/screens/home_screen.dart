import 'package:flutter/material.dart';
import '../models/models.dart';
import '../models/food_data.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  final StorageService storage;
  const HomeScreen({super.key, required this.storage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _loadData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [_buildDashboard(), _buildColonies(), _buildSettings()][_currentIndex],
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

  Widget _buildDashboard() {
    final colonies = widget.storage.colonies;
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Fourmis')),
      body: colonies.isEmpty
          ? const Center(child: Text('Aucune colonie\nAppuyez sur + pour ajouter votre première colonie', textAlign: TextAlign.center, style: TextStyle(fontSize: 18)))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Mes Colonies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...colonies.map((c) => Card(child: ListTile(leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.pest_control, color: Colors.white)), title: Text(c.name), subtitle: Text(c.species), trailing: const Icon(Icons.chevron_right), onTap: () => _showColonyDetail(c)))),
              ],
            ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddColony, child: const Icon(Icons.add)),
    );
  }

  Widget _buildColonies() {
    final colonies = widget.storage.colonies;
    return Scaffold(
      appBar: AppBar(title: const Text('Colonies')),
      body: colonies.isEmpty
          ? const Center(child: Text('Aucune colonie', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: colonies.length,
              itemBuilder: (ctx, i) {
                final c = colonies[i];
                return Card(
                  child: ListTile(
                    title: Text(c.name),
                    subtitle: Text(c.species),
                    trailing: PopupMenuButton(
                      itemBuilder: (ctx) => [const PopupMenuItem(value: 'delete', child: Text('Supprimer'))],
                      onSelected: (v) { if (v == 'delete') _deleteColony(c); },
                    ),
                    onTap: () => _showColonyDetail(c),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddColony, child: const Icon(Icons.add)),
    );
  }

  Widget _buildSettings() {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Mode débogage'),
            trailing: Switch(value: AppConfig.debugMode, onChanged: (v) async { await widget.storage.setDebugMode(v); if (v) { setState(() {}); } }),
          ),
          const Divider(),
          const ListTile(leading: Icon(Icons.info), title: Text('Antology v1.0.0'), subtitle: Text('Gérez vos colonies de fourmis')),
        ],
      ),
    );
  }

  void _showAddColony() {
    final nameController = TextEditingController();
    final speciesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter une colonie'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nom')),
          const SizedBox(height: 16),
          TextField(controller: speciesController, decoration: const InputDecoration(labelText: 'Espèce')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty || speciesController.text.isEmpty) return;
              widget.storage.addColony(Colony(id: widget.storage.generateId(), name: nameController.text, species: speciesController.text, createdAt: DateTime.now()));
              _loadData();
              Navigator.pop(ctx);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _deleteColony(Colony c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(title: const Text('Supprimer ?'), content: Text('Supprimer "${c.name}" ?'), actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
        ElevatedButton(onPressed: () { widget.storage.deleteColony(c.id); _loadData(); Navigator.pop(ctx); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('Supprimer')),
      ]),
    );
  }

  void _showColonyDetail(Colony colony) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: DraggableScrollableSheet(initialChildSize: 0.7, minChildSize: 0.5, maxChildSize: 0.95, expand: false, builder: (context, controller) => _ColonyDetailSheet(colony: colony, storage: widget.storage, onUpdate: _loadData, scrollController: controller)),
      ),
    );
  }
}

class _ColonyDetailSheet extends StatefulWidget {
  final Colony colony;
  final StorageService storage;
  final Function() onUpdate;
  final ScrollController scrollController;

  const _ColonyDetailSheet({required this.colony, required this.storage, required this.onUpdate, required this.scrollController});

  @override
  State<_ColonyDetailSheet> createState() => _ColonyDetailSheetState();
}

class _ColonyDetailSheetState extends State<_ColonyDetailSheet> {
  @override
  Widget build(BuildContext context) {
    final colonyEvents = widget.storage.feedingEvents.where((e) => e.colonyId == widget.colony.id).toList()..sort((a, b) => b.fedAt.compareTo(a.fedAt));
    final colonyPrefs = widget.storage.foodPreferences.where((p) => p.colonyId == widget.colony.id).toList();

    return SafeArea(
      bottom: true,
      child: Column(
        children: [
          AppBar(title: Text(widget.colony.name), automaticallyImplyLeading: false, actions: [IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))]),
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.colony.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text(widget.colony.species, style: const TextStyle(fontSize: 16, color: Colors.grey)), const SizedBox(height: 8), Text('Créée le: ${widget.colony.createdAt.day}/${widget.colony.createdAt.month}/${widget.colony.createdAt.year}')]))),
                const SizedBox(height: 16),
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Nourrissage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 8), ElevatedButton.icon(onPressed: () => _showAddFeeding(context), icon: const Icon(Icons.add), label: const Text('Enregistrer'))]))),
                if (colonyEvents.isNotEmpty) ...[const SizedBox(height: 16), const Text('Nourrissages récents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), ...colonyEvents.take(5).map((e) => ListTile(dense: true, title: Text(e.foodType), subtitle: Text('${e.fedAt.day}/${e.fedAt.month}/${e.fedAt.year}')))],
                const SizedBox(height: 16),
                _buildFoodPreferences(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodPreferences(BuildContext context) {
    final colonyPrefs = widget.storage.foodPreferences.where((p) => p.colonyId == widget.colony.id).toList();
    final allCats = getAllCategories(widget.storage.customCategories);
    
    return Card(
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
                    IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => _showAddCategory(context), tooltip: 'Ajouter une catégorie'),
                    IconButton(icon: const Icon(Icons.add_box_outlined), onPressed: () => _showAddFood(context), tooltip: 'Ajouter un aliment'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...allCats.map((cat) {
              return ExpansionTile(
                title: Text(cat.name),
                children: cat.foods.isEmpty 
                  ? [const ListTile(title: Text('Aucun aliment', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)))]
                  : cat.foods.map((f) {
                      final pref = colonyPrefs.where((p) => p.foodType == f).firstOrNull;
                      return ListTile(
                        title: Text(f),
                        trailing: GestureDetector(
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
                      );
                    }).toList(),
              );
            }).toList(),
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
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Nom de la catégorie'), autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              await widget.storage.addCustomCategory(controller.text.trim());
              widget.onUpdate();
              Navigator.pop(ctx);
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
              widget.onUpdate();
              Navigator.pop(ctx);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showAddFeeding(BuildContext context) {
    String? selectedFood;
    final quantityController = TextEditingController();
    final allFoodsList = getAllFoods(widget.storage.customCategories, widget.storage.customFoods);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enregistrer nourrissage'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField<String>(decoration: const InputDecoration(labelText: 'Aliment'), items: allFoodsList.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(), onChanged: (v) => selectedFood = v),
          const SizedBox(height: 16),
          TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantité (optionnel)')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (selectedFood == null) return;
              widget.storage.addFeedingEvent(FeedingEvent(id: widget.storage.generateId(), colonyId: widget.colony.id, foodType: selectedFood!, quantity: quantityController.text.isEmpty ? null : quantityController.text, fedAt: DateTime.now()));
              widget.onUpdate();
              Navigator.pop(ctx);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _togglePref(BuildContext context, String food, FoodStatus? current) async {
    final newStatus = current == null ? FoodStatus.accepted : current == FoodStatus.accepted ? FoodStatus.rejected : FoodStatus.unknown;
    if (newStatus != FoodStatus.unknown) {
      await widget.storage.addFoodPreference(FoodPreference(colonyId: widget.colony.id, foodType: food, status: newStatus));
    }
    widget.onUpdate();
  }
}