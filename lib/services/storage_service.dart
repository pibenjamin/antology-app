import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/models.dart';
import '../models/food_data.dart';

class StorageService {
  late SharedPreferences _prefs;
  final _uuid = const Uuid();

  List<Colony> colonies = [];
  List<Individual> individuals = [];
  List<FeedingEvent> feedingEvents = [];
  List<FeedingSchedule> feedingSchedules = [];
  List<FoodPreference> foodPreferences = [];
  List<GrowthRecord> growthRecords = [];
  List<FoodCategory> customCategories = [];
  List<String> customFoods = [];

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    AppConfig.debugMode = _prefs.getBool('debugMode') ?? false;
    await _loadData();
    if (colonies.isEmpty) {
      final athena = Colony(id: generateId(), name: 'Athéna', species: 'Messor barbarus', createdAt: DateTime(2025, 4, 1), population: 50);
      final eclair = Colony(id: generateId(), name: 'Eclair', species: 'Messor barbarus', createdAt: DateTime(2025, 4, 1), population: 25);
      final mama = Colony(id: generateId(), name: 'Mama', species: 'Lasius niger', createdAt: DateTime(2025, 6, 1), population: 6);
      colonies.add(athena);
      colonies.add(eclair);
      colonies.add(mama);
      await _saveColonies();
      feedingEvents.add(FeedingEvent(id: generateId(), colonyId: athena.id, foodType: 'Grillons', fedAt: DateTime(2025, 4, 14), rating: 4));
      feedingEvents.add(FeedingEvent(id: generateId(), colonyId: athena.id, foodType: 'Graines de pavot', fedAt: DateTime(2025, 4, 15), rating: 3));
      feedingEvents.add(FeedingEvent(id: generateId(), colonyId: eclair.id, foodType: 'Grillons', fedAt: DateTime(2025, 4, 12), rating: 5));
      feedingEvents.add(FeedingEvent(id: generateId(), colonyId: mama.id, foodType: 'Sirop', fedAt: DateTime(2025, 4, 16), rating: 4));
      await _saveFeedingEvents();
    }
  }

  Future<void> setDebugMode(bool value) async {
    await _prefs.setBool('debugMode', value);
    AppConfig.debugMode = value;
  }

  bool _isValidBase64Image(String? str) {
    if (str == null || str.isEmpty) return false;
    if (!str.startsWith('data:')) return false;
    if (!str.contains(',')) return false;
    final parts = str.split(',');
    if (parts.length < 2) return false;
    final data = parts[1];
    if (data.contains('[') || data.contains('{')) return false;
    try {
      base64Decode(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadData() async {
    final coloniesJson = _prefs.getString('colonies');
    if (coloniesJson != null) {
      final list = jsonDecode(coloniesJson) as List;
      colonies = list.map((e) {
        final rawPhotos = (e['photos'] as List?)?.cast<String>() ?? [];
        final validPhotos = rawPhotos.where(_isValidBase64Image).toList();
        final rawFeatured = e['featuredPhoto'];
        final validFeatured = _isValidBase64Image(rawFeatured) ? rawFeatured : null;
        return Colony(
          id: e['id'],
          name: e['name'],
          species: e['species'],
          createdAt: DateTime.parse(e['createdAt']),
          population: e['population'] ?? 0,
          photos: validPhotos,
          featuredPhoto: validFeatured,
        );
      }).toList();
    }

    final eventsJson = _prefs.getString('feedingEvents');
    if (eventsJson != null) {
      final list = jsonDecode(eventsJson) as List;
      feedingEvents = list.map((e) => FeedingEvent(
        id: e['id'],
        colonyId: e['colonyId'],
        foodType: e['foodType'],
        quantity: e['quantity'],
        fedAt: DateTime.parse(e['fedAt']),
        notes: e['notes'],
        rating: e['rating'],
      )).toList();
    }

    final prefsJson = _prefs.getString('foodPreferences');
    if (prefsJson != null) {
      final list = jsonDecode(prefsJson) as List;
      foodPreferences = list.map((e) => FoodPreference(
        colonyId: e['colonyId'],
        foodType: e['foodType'],
        status: FoodStatus.values.firstWhere((s) => s.name == e['status']),
      )).toList();
    }

    final customCatsJson = _prefs.getString('customCategories');
    if (customCatsJson != null) {
      final list = jsonDecode(customCatsJson) as List;
      customCategories = list.map((e) => FoodCategory(e['name'], List<String>.from(e['foods']))).toList();
    }

    final customFoodsJson = _prefs.getString('customFoods');
    if (customFoodsJson != null) {
      customFoods = List<String>.from(jsonDecode(customFoodsJson));
    }
  }

  Future<void> _saveColonies() async {
    final json = jsonEncode(colonies.map((c) => {
      'id': c.id,
      'name': c.name,
      'species': c.species,
      'createdAt': c.createdAt.toIso8601String(),
      'population': c.population,
      'photos': c.photos,
      'featuredPhoto': c.featuredPhoto,
    }).toList());
    await _prefs.setString('colonies', json);
  }

  Future<void> saveColonies() async {
    await _saveColonies();
  }

  Future<void> _saveFeedingEvents() async {
    final json = jsonEncode(feedingEvents.map((e) => {'id': e.id, 'colonyId': e.colonyId, 'foodType': e.foodType, 'quantity': e.quantity, 'fedAt': e.fedAt.toIso8601String(), 'notes': e.notes, 'rating': e.rating}).toList());
    await _prefs.setString('feedingEvents', json);
  }

  Future<void> _saveFoodPreferences() async {
    final json = jsonEncode(foodPreferences.map((p) => {'colonyId': p.colonyId, 'foodType': p.foodType, 'status': p.status.name}).toList());
    await _prefs.setString('foodPreferences', json);
  }

  String generateId() => _uuid.v4();

  Future<void> addColony(Colony c) async {
    colonies.add(c);
    await _saveColonies();
  }

  Future<void> deleteColony(String id) async {
    colonies.removeWhere((c) => c.id == id);
    feedingEvents.removeWhere((e) => e.colonyId == id);
    foodPreferences.removeWhere((p) => p.colonyId == id);
    await _saveColonies();
    await _saveFeedingEvents();
    await _saveFoodPreferences();
  }

  Future<void> updateColony(Colony updatedColony) async {
    final index = colonies.indexWhere((c) => c.id == updatedColony.id);
    if (index != -1) {
      colonies[index] = updatedColony;
      await _saveColonies();
    }
  }

  Future<void> addPhotoToColony(String colonyId, String photoPath) async {
    final index = colonies.indexWhere((c) => c.id == colonyId);
    if (index != -1) {
      final colony = colonies[index];
      final newPhotos = List<String>.from(colony.photos)..add(photoPath);
      String? newFeatured = colony.featuredPhoto;
      if (newFeatured == null && newPhotos.isNotEmpty) {
        newFeatured = photoPath;
      }
      colonies[index] = Colony(
        id: colony.id,
        name: colony.name,
        species: colony.species,
        createdAt: colony.createdAt,
        population: colony.population,
        photos: newPhotos,
        featuredPhoto: newFeatured,
      );
      await _saveColonies();
    }
  }

  Future<void> removePhotoFromColony(String colonyId, String photoPath) async {
    final index = colonies.indexWhere((c) => c.id == colonyId);
    if (index != -1) {
      final colony = colonies[index];
      final newPhotos = List<String>.from(colony.photos)..remove(photoPath);
      String? newFeatured = colony.featuredPhoto == photoPath ? (newPhotos.isNotEmpty ? newPhotos.first : null) : colony.featuredPhoto;
      colonies[index] = Colony(
        id: colony.id,
        name: colony.name,
        species: colony.species,
        createdAt: colony.createdAt,
        population: colony.population,
        photos: newPhotos,
        featuredPhoto: newFeatured,
      );
      await _saveColonies();
    }
  }

  Future<void> setFeaturedPhoto(String colonyId, String? photoPath) async {
    final index = colonies.indexWhere((c) => c.id == colonyId);
    if (index != -1) {
      final colony = colonies[index];
      colonies[index] = Colony(
        id: colony.id,
        name: colony.name,
        species: colony.species,
        createdAt: colony.createdAt,
        population: colony.population,
        photos: colony.photos,
        featuredPhoto: photoPath,
      );
      await _saveColonies();
    }
  }

  Future<void> addFeedingEvent(FeedingEvent e) async {
    feedingEvents.add(e);
    await _saveFeedingEvents();
  }

  Future<void> updateFeedingEvent(FeedingEvent e) async {
    final index = feedingEvents.indexWhere((fe) => fe.id == e.id);
    if (index != -1) {
      feedingEvents[index] = e;
      await _saveFeedingEvents();
    }
  }

  Future<void> deleteFeedingEvent(String id) async {
    feedingEvents.removeWhere((e) => e.id == id);
    await _saveFeedingEvents();
  }

  Future<void> addFoodPreference(FoodPreference p) async {
    foodPreferences.removeWhere((x) => x.colonyId == p.colonyId && x.foodType == p.foodType);
    foodPreferences.add(p);
    await _saveFoodPreferences();
  }

  Future<void> _saveCustomCategories() async {
    final json = jsonEncode(customCategories.map((c) => {'name': c.name, 'foods': c.foods}).toList());
    await _prefs.setString('customCategories', json);
  }

  Future<void> _saveCustomFoods() async {
    final json = jsonEncode(customFoods);
    await _prefs.setString('customFoods', json);
  }

  Future<bool> addCustomCategory(String name) async {
    final lowerName = name.toLowerCase();
    if (defaultFoodCategories.any((c) => c.name.toLowerCase() == lowerName)) return false;
    if (customCategories.any((c) => c.name.toLowerCase() == lowerName)) return false;
    customCategories.add(FoodCategory(name, []));
    await _saveCustomCategories();
    return true;
  }

  Future<void> addCustomFood(String foodName, {String? categoryName}) async {
    if (allFoods.any((f) => f.toLowerCase() == foodName.toLowerCase())) return;
    customFoods.add(foodName);
    if (categoryName != null) {
      final lowerCat = categoryName.toLowerCase();
      final defaultCat = defaultFoodCategories.where((c) => c.name.toLowerCase() == lowerCat).firstOrNull;
      if (defaultCat != null) {
        defaultCat.foods.add(foodName);
        await _saveCustomFoods();
        return;
      }
      final customCat = customCategories.where((c) => c.name.toLowerCase() == lowerCat).firstOrNull;
      if (customCat != null) {
        customCat.foods.add(foodName);
      } else {
        customCategories.add(FoodCategory(categoryName, [foodName]));
      }
    } else {
      var customCat = customCategories.where((c) => c.name.toLowerCase() == 'personnalisé').firstOrNull;
      if (customCat == null) {
        customCat = FoodCategory('Personnalisé', []);
        customCategories.add(customCat);
      }
      customCat.foods.add(foodName);
    }
    await _saveCustomCategories();
    await _saveCustomFoods();
  }

  Future<void> deleteCustomCategory(String name) async {
    customCategories.removeWhere((c) => c.name.toLowerCase() == name.toLowerCase());
    await _saveCustomCategories();
  }

  Future<void> deleteCustomFood(String foodName) async {
    customFoods.removeWhere((f) => f.toLowerCase() == foodName.toLowerCase());
    for (final cat in customCategories) {
      cat.foods.removeWhere((f) => f.toLowerCase() == foodName.toLowerCase());
    }
    await _saveCustomCategories();
    await _saveCustomFoods();
  }
}