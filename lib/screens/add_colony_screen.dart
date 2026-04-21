import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';
import '../antology_theme.dart';

class AddColonyScreen extends StatefulWidget {
  final StorageService storage;

  const AddColonyScreen({super.key, required this.storage});

  @override
  State<AddColonyScreen> createState() => _AddColonyScreenState();
}

class _AddColonyScreenState extends State<AddColonyScreen> {
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  int _population = 0;

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
            Text('Population: $_population', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Slider(
              value: _population.toDouble(),
              min: 0,
              max: 5000,
              divisions: 50,
              label: _population.toString(),
              activeColor: AntologyColors.forestGreen,
              onChanged: (value) => setState(() => _population = value.round()),
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
              onPressed: _addColony,
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
      population: _population,
    ));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    super.dispose();
  }
}