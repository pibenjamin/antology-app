import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class AddColonyScreen extends StatefulWidget {
  final StorageService storage;

  const AddColonyScreen({super.key, required this.storage});

  @override
  State<AddColonyScreen> createState() => _AddColonyScreenState();
}

class _AddColonyScreenState extends State<AddColonyScreen> {
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
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    super.dispose();
  }
}