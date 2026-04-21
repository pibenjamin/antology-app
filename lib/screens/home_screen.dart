import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/models.dart';
import '../models/food_data.dart';
import '../services/storage_service.dart';
import '../antology_theme.dart';
import 'colony_detail_screen.dart';
import 'add_colony_screen.dart';

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
        destinations: [
          const NavigationDestination(icon: Icon(Icons.dashboard), label: 'Tableau de bord'),
          NavigationDestination(icon: SvgPicture.asset(AntologyImages.antLogo, width: 24, height: 24), label: 'Colonies'),
          const NavigationDestination(icon: Icon(Icons.settings), label: 'Paramètres'),
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
                ...colonies.map((c) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: AntologyColors.tealLight, child: SvgPicture.asset(AntologyImages.antLogo, width: 24, height: 24)), title: Text(c.name), subtitle: Text(c.species), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ColonyDetailScreen(colony: c, storage: widget.storage))).then((_) => _loadData())))),
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
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ColonyDetailScreen(colony: c, storage: widget.storage))).then((_) => _loadData()),
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
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddColonyScreen(storage: widget.storage))).then((_) => _loadData());
  }

  void _deleteColony(Colony c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(title: const Text('Supprimer ?'), content: Text('Supprimer "${c.name}" ?'), actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
        ElevatedButton(onPressed: () { widget.storage.deleteColony(c.id); _loadData(); Navigator.pop(ctx); }, style: ElevatedButton.styleFrom(backgroundColor: AntologyColors.terracotta, foregroundColor: Colors.white), child: const Text('Supprimer')),
      ]),
    );
  }
}