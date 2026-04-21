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
      builder: (ctx) => DraggableScrollableSheet(initialChildSize: 0.7, minChildSize: 0.5, maxChildSize: 0.95, expand: false, builder: (context, controller) => _ColonyDetailSheet(colony: colony, storage: widget.storage, onUpdate: _loadData, scrollController: controller)),
    );
  }
}

class _ColonyDetailSheet extends StatelessWidget {
  final Colony colony;
  final StorageService storage;
  final Function() onUpdate;
  final ScrollController scrollController;

  const _ColonyDetailSheet({required this.colony, required this.storage, required this.onUpdate, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final colonyEvents = storage.feedingEvents.where((e) => e.colonyId == colony.id).toList()..sort((a, b) => b.fedAt.compareTo(a.fedAt));
    final colonyPrefs = storage.foodPreferences.where((p) => p.colonyId == colony.id).toList();

    return SafeArea(
      child: Column(
        children: [
          AppBar(title: Text(colony.name), automaticallyImplyLeading: false, actions: [IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))]),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(colony.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text(colony.species, style: const TextStyle(fontSize: 16, color: Colors.grey)), const SizedBox(height: 8), Text('Créée le: ${colony.createdAt.day}/${colony.createdAt.month}/${colony.createdAt.year}')]))),
                const SizedBox(height: 16),
                Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Alimentation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 8), ElevatedButton.icon(onPressed: () => _showAddFeeding(context), icon: const Icon(Icons.add), label: const Text('Enregistrer'))]))),
                if (colonyEvents.isNotEmpty) ...[const SizedBox(height: 16), const Text('Alimentations récentes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), ...colonyEvents.take(5).map((e) => ListTile(dense: true, title: Text(e.foodType), subtitle: Text('${e.fedAt.day}/${e.fedAt.month}/${e.fedAt.year}')))],
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
    final colonyPrefs = storage.foodPreferences.where((p) => p.colonyId == colony.id).toList();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Préférences alimentaires', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...foodCategories.map((cat) {
              return ExpansionTile(
                title: Text(cat.name),
                children: cat.foods.map((f) {
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

  void _showAddFeeding(BuildContext context) {
    String? selectedFood;
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enregistrer alimentation'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField<String>(decoration: const InputDecoration(labelText: 'Aliment'), items: allFoods.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(), onChanged: (v) => selectedFood = v),
          const SizedBox(height: 16),
          TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Quantité (optionnel)')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (selectedFood == null) return;
              storage.addFeedingEvent(FeedingEvent(id: storage.generateId(), colonyId: colony.id, foodType: selectedFood!, quantity: quantityController.text.isEmpty ? null : quantityController.text, fedAt: DateTime.now()));
              onUpdate();
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
      await storage.addFoodPreference(FoodPreference(colonyId: colony.id, foodType: food, status: newStatus));
    }
    onUpdate();
  }
}