import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../antology_theme.dart';

class AddColonyScreen extends StatefulWidget {
  final StorageService storage;
  final Colony? colony;

  const AddColonyScreen({super.key, required this.storage, this.colony});

  @override
  State<AddColonyScreen> createState() => _AddColonyScreenState();
}

class _AddColonyScreenState extends State<AddColonyScreen> {
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  int _tierIndex = 0;
  bool get isEditing => widget.colony != null;
  int get population => AppConfig.populationTiers[_tierIndex];

  int _findTierIndex(int pop) {
    final idx = AppConfig.populationTiers.indexOf(pop);
    return idx == -1 ? 0 : idx;
  }

  @override
  void initState() {
    super.initState();
    if (widget.colony != null) {
      _nameController.text = widget.colony!.name;
      _speciesController.text = widget.colony!.species;
      _tierIndex = _findTierIndex(widget.colony!.population);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier la colonie' : 'Ajouter une colonie'),
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
            Text('Population: $population', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Slider(
              value: _tierIndex.toDouble(),
              min: 0,
              max: (AppConfig.populationTiers.length - 1).toDouble(),
              divisions: AppConfig.populationTiers.length - 1,
              label: population.toString(),
              activeColor: AntologyColors.forestGreen,
              onChanged: (value) => setState(() => _tierIndex = value.round()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('0', style: TextStyle(color: Colors.grey)),
                const Text('5000', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveColony,
              child: Text(isEditing ? 'Enregistrer' : 'Ajouter', style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _saveColony() {
    if (_nameController.text.isEmpty || _speciesController.text.isEmpty) return;
    if (isEditing) {
      widget.storage.updateColony(Colony(
        id: widget.colony!.id,
        name: _nameController.text,
        species: _speciesController.text,
        createdAt: widget.colony!.createdAt,
        population: population,
      ));
    } else {
      widget.storage.addColony(Colony(
        id: widget.storage.generateId(),
        name: _nameController.text,
        species: _speciesController.text,
        createdAt: DateTime.now(),
        population: population,
      ));
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    super.dispose();
  }
}