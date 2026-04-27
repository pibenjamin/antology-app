import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart'; // For ImageSource, ImagePicker
import 'package:image_cropper/image_cropper.dart'; // For ImageCropper, UiSettings classes, CropAspectRatio, etc.
import 'dart:convert'; // For base64Decode, base64Encode
import 'dart:io'; // For Platform.isAndroid, Platform.isIOS (for non-web mobile check)
import '../models/models.dart';
import '../models/food_data.dart';
import '../services/storage_service.dart';
import '../antology_theme.dart';
import '../widgets/category_food_selector.dart';
import 'add_colony_screen.dart';

class ColonyDetailScreen extends StatefulWidget {
  final String colonyId;
  final StorageService storage;

  const ColonyDetailScreen({super.key, required this.colonyId, required this.storage});

  @override
  State<ColonyDetailScreen> createState() => _ColonyDetailScreenState();
}

class _ColonyDetailScreenState extends State<ColonyDetailScreen> {
  void _refresh() => setState(() {});
  String get colId => widget.colonyId;
  Colony? get targetColony => widget.storage.colonies.where((c) => c.id == colId).firstOrNull;

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
    final colony = targetColony;
    if (colony == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Colonie ID: ${widget.colonyId}')),
        body: Center(child: Text('Colonie non trouvée: ${widget.colonyId}')),
      );
    }
    final colonyEvents = widget.storage.feedingEvents.where((e) => e.colonyId == colony.id).toList()..sort((a, b) => b.fedAt.compareTo(a.fedAt));
    final colonyPrefs = widget.storage.foodPreferences.where((p) => p.colonyId == colony.id).toList();
    final allCats = getAllCategories(widget.storage.customCategories);

    return Scaffold(
      appBar: AppBar(
        title: Text(colony.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editColony(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context, colony),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPhotoSection(),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(colony.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(colony.species, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text('Créée le: ${colony.createdAt.day}/${colony.createdAt.month}/${colony.createdAt.year}'),
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
                      const Text('Population', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${colony.population}', style: const TextStyle(fontSize: 24, color: AntologyColors.forestGreen)),
                    ],
                  ),
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
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _showAddFeedingDialog(context),
                      ),
                    ],
                  ),
                  if (colonyEvents.isNotEmpty) ...[
                    ...colonyEvents.take(10).map((e) => Card(
                      child: ListTile(
                        title: Text(e.foodType),
                        subtitle: Text('${e.fedAt.day}/${e.fedAt.month}/${e.fedAt.year}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...List.generate(e.rating ?? 0, (i) => const Icon(Icons.restaurant_menu, size: 16, color: AntologyColors.terracotta)),
                            IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _showEditFeedingDialog(context, e)),
                            IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () => _showDeleteFeeding(context, e)),
                          ],
                        ),
                      ),
                    )),
                  ] else
                    const Text('Aucun nourrissage', style: TextStyle(color: Colors.grey)),
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
                      const Text('Préférences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add),
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
                              Color chipColor = Colors.grey;
                              if (pref != null) {
                                chipColor = pref.status == FoodStatus.accepted
                                    ? Colors.green
                                    : pref.status == FoodStatus.rejected ? Colors.red : Colors.grey;
                              }
                              return ListTile(
                                title: Text(f),
                                trailing: GestureDetector(
                                  onTap: () => _toggleFoodPreference(context, f),
                                  child: Chip(
                                    label: Text(pref?.status.name ?? 'Non testé'),
                                    backgroundColor: chipColor.withAlpha(51),
                                    labelStyle: TextStyle(color: chipColor),
                                  ),
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

  Widget _buildPhotoSection() {
    final c = targetColony;
    if (c == null) return const SizedBox();
    final photos = c.photos;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: _showPhotoOptions,
                ),
              ],
            ),
            if (photos.isEmpty)
              const Center(child: Text('Aucune photo', style: TextStyle(color: Colors.grey)))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final path = photos[index];
                  final isFeatured = c.featuredPhoto == path;
                  return GestureDetector(
                    onTap: () => _showPhotoViewer(path, index),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _decodeBase64Image(path).isEmpty
                              ? Container(color: Colors.grey[300], child: const Icon(Icons.image, color: Colors.grey))
                              : Image.memory(
                                  _decodeBase64Image(path),
                                  fit: BoxFit.cover,
                                  gaplessPlayback: true,
                                  errorBuilder: (_, __, ___) => Container(color: Colors.grey[300], child: const Icon(Icons.broken_image, color: Colors.grey)),
                                ),
                        ),
                        if (isFeatured)
                          const Positioned(
                            top: 4,
                            right: 4,
                            child: Icon(Icons.star, color: Colors.amber, size: 20),
                          ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _editColony(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddColonyScreen(storage: widget.storage, colony: targetColony)),
    );
    if (mounted) {
      setState(() {});
    }
  }

  void _showDeleteConfirmation(BuildContext context, Colony colonyToDelete) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ?'),
        content: Text('Supprimer "${colonyToDelete.name}" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              widget.storage.deleteColony(targetColony!.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AntologyColors.terracotta, foregroundColor: Colors.white),
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
        content: const Text('Supprimer ce nourrissage ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              widget.storage.deleteFeedingEvent(event.id);
              Navigator.pop(ctx);
              _refresh();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AntologyColors.terracotta, foregroundColor: Colors.white),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _showAddFeedingDialog(BuildContext context) {
    final allCats = getAllCategories(widget.storage.customCategories);
    String? selectedFood;
    final quantityController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    int? selectedRating;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Ajouter un nourritsage'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              CategoryFoodSelector(
                categories: allCats,
                customFoods: widget.storage.customFoods,
                onSelected: (category, food) => selectedFood = food,
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
                        color: selectedRating != null && rating <= selectedRating! ? AntologyColors.terracotta : Colors.grey,
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
                  colonyId: targetColony!.id,
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

  void _showEditFeedingDialog(BuildContext context, FeedingEvent event) {
    final allCats = getAllCategories(widget.storage.customCategories);
    String selectedFood = event.foodType;
    final quantityController = TextEditingController(text: event.quantity);
    DateTime selectedDate = event.fedAt;
    int? selectedRating = event.rating;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Modifier nourrissage'),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              CategoryFoodSelector(
                categories: allCats,
                customFoods: widget.storage.customFoods,
                onSelected: (category, food) => selectedFood = food,
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
                        color: selectedRating != null && rating <= selectedRating! ? AntologyColors.terracotta : Colors.grey,
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
                  foodType: selectedFood,
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
    final allCats = getAllCategories(widget.storage.customCategories);
    String? selectedCategory;
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter un aliment'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Catégorie'),
            items: allCats.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
            onChanged: (v) => selectedCategory = v,
          ),
          const SizedBox(height: 16),
          TextField(controller: controller, decoration: const InputDecoration(labelText: 'Nom de l\'aliment')),
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

  void _showDeleteCategory(BuildContext context, String categoryName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la catégorie ?'),
        content: Text('Supprimer "$categoryName" ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              widget.storage.deleteCustomCategory(categoryName);
              Navigator.pop(ctx);
              _refresh();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AntologyColors.terracotta, foregroundColor: Colors.white),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFoodPreference(BuildContext context, String food) async {
    final c = targetColony;
    if (c == null) return;
    final colonyPrefs = widget.storage.foodPreferences.where((p) => p.colonyId == c.id);
    final pref = colonyPrefs.where((p) => p.foodType == food).firstOrNull;
    FoodStatus newStatus;
    if (pref == null || pref.status == FoodStatus.unknown) {
      newStatus = FoodStatus.accepted;
    } else if (pref.status == FoodStatus.accepted) {
      newStatus = FoodStatus.rejected;
    } else {
      newStatus = FoodStatus.unknown;
    }
    await widget.storage.addFoodPreference(FoodPreference(colonyId: c.id, foodType: food, status: newStatus));
    _refresh();
  }

  Future<void> _addPhoto(ImageSource source) async {
    debugPrint('[_addPhoto] Starting...');
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      debugPrint('[_addPhoto] Image picked: ${picked.path}');
      CroppedFile? croppedFile;

      try {
        if (kIsWeb) {
          debugPrint('[_addPhoto] Cropping for Web...');
          croppedFile = await ImageCropper().cropImage(
            sourcePath: picked.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            uiSettings: [
              WebUiSettings(context: context),
            ],
          );
          debugPrint('[_addPhoto] Web cropping result: ${croppedFile?.path}');
        } else if (Platform.isAndroid || Platform.isIOS) {
          debugPrint('[_addPhoto] Cropping for Android/iOS...');
          croppedFile = await ImageCropper().cropImage(
            sourcePath: picked.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Rogner en carré',
                toolbarColor: AntologyColors.forestGreen,
                toolbarWidgetColor: Colors.white,
                backgroundColor: Colors.black,
                lockAspectRatio: true,
                showCropGrid: true,
                hideBottomControls: false,
                initAspectRatio: CropAspectRatioPreset.square,
                aspectRatioPresets: [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ],
              ),
              IOSUiSettings(
                title: 'Rogner en carré',
                aspectRatioLockEnabled: true,
                rotateButtonsHidden: false,
                aspectRatioPresets: [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ],
              ),
            ],
          );
          debugPrint('[_addPhoto] Mobile cropping result: ${croppedFile?.path}');
        }
      } catch (e) {
        debugPrint('[_addPhoto] Error during cropping: $e');
        // Fallback to original image if cropping fails
        final bytes = await picked.readAsBytes();
        final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        await widget.storage.addPhotoToColony(targetColony!.id, base64Image);
        _refresh();
        return; // Exit after adding original image
      }

      if (croppedFile != null) {
        debugPrint('[_addPhoto] Cropped file not null, processing...');
        final bytes = await croppedFile.readAsBytes();
        final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        await widget.storage.addPhotoToColony(targetColony!.id, base64Image);
        _refresh();
        debugPrint('[_addPhoto] Photo added and refreshed.');
      } else if (!kIsWeb && !(Platform.isAndroid || Platform.isIOS)) {
        debugPrint('[_addPhoto] Platform not supported by cropper, adding original image...');
        // For platforms not supported by image_cropper, add the image directly
        final bytes = await picked.readAsBytes();
        final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        await widget.storage.addPhotoToColony(targetColony!.id, base64Image);
        _refresh();
        debugPrint('[_addPhoto] Original photo added and refreshed.');
      } else {
        debugPrint('[_addPhoto] Cropped file is null, and no fallback for this platform. Doing nothing.');
      }
    } else {
      debugPrint('[_addPhoto] No image picked.');
    }
    debugPrint('[_addPhoto] Exiting.');
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choisir dans la galerie'),
              onTap: () {
                Navigator.pop(ctx);
                _addPhoto(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo'),
              onTap: () {
                Navigator.pop(ctx);
                _addPhoto(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoViewer(String photoPath, int index) {
    final currentColony = targetColony;
    if (currentColony == null) return;
    final currentFeatured = currentColony.featuredPhoto;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: _decodeBase64Image(photoPath).isEmpty
                    ? Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.broken_image, size: 48)))
                    : Image.memory(_decodeBase64Image(photoPath), fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (currentFeatured != photoPath)
                      TextButton.icon(
                        icon: const Icon(Icons.star),
                        label: const Text('En avant'),
                        onPressed: () {
                          widget.storage.setFeaturedPhoto(currentColony.id, photoPath);
                          Navigator.pop(ctx);
                          _refresh();
                        },
                      )
                    else
                      TextButton.icon(
                        icon: const Icon(Icons.star_border),
                        label: const Text('Retirer'),
                        onPressed: () {
                          widget.storage.setFeaturedPhoto(currentColony.id, null);
                          Navigator.pop(ctx);
                          _refresh();
                        },
                      ),
                    TextButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        widget.storage.removePhotoFromColony(currentColony.id, photoPath);
                        Navigator.pop(ctx);
                        _refresh();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}