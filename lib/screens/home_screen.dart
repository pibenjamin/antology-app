import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'dart:io';
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

  Uint8List _decodeBase64Image(String base64String) {
    try {
      if (base64String.startsWith('data:')) {
        final parts = base64String.split(',');
        if (parts.length >= 2) {
          return base64Decode(parts[1]);
        }
      }
      return base64Decode(base64String);
    } catch (e) {
      debugPrint('Error decoding image: $e');
      return Uint8List(0);
    }
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
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.bug, size: 24, color: AntologyColors.forestGreen),
            label: 'Colonies',
          ),
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
                ...colonies.map((c) => _buildColonyCard(c)),
              ],
            ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddColony, child: const Icon(Icons.add)),
    );
  }

  Widget _buildColonyCard(Colony c) {
    final featuredPhoto = c.featuredPhoto;
    final bytes = featuredPhoto != null && featuredPhoto.isNotEmpty ? _decodeBase64Image(featuredPhoto) : Uint8List(0);
    return Card(
      child: ListTile(
        leading: featuredPhoto != null && featuredPhoto.isNotEmpty && bytes.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.memory(
                  bytes,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => CircleAvatar(backgroundColor: AntologyColors.tealLight, child: SvgPicture.asset(AntologyImages.antLogo, width: 24, height: 24)),
                ),
              )
            : CircleAvatar(backgroundColor: AntologyColors.tealLight, child: SvgPicture.asset(AntologyImages.antLogo, width: 24, height: 24)),
        title: Text(c.name),
        subtitle: Text(c.species),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go('/colony/${c.id}'),
      ),
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
                return _buildColonyCard(c);
              },
            ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddColony, child: const Icon(Icons.add)),
    );
  }

  ListTile _buildColonyListItem(Colony c) {
    return ListTile(
      title: Text(c.name),
      subtitle: Text(c.species),
      trailing: PopupMenuButton(
        itemBuilder: (ctx) => [const PopupMenuItem(value: 'delete', child: Text('Supprimer'))],
        onSelected: (v) { if (v == 'delete') _deleteColony(c); },
      ),
      onTap: () => context.go('/colony/${c.id}'),
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
    context.go('/add-colony');
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