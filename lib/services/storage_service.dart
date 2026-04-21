import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/models.dart';

class StorageService {
  late SharedPreferences _prefs;

  List<Colony> colonies = [];
  List<Individual> individuals = [];
  List<FeedingEvent> feedingEvents = [];
  List<FeedingSchedule> feedingSchedules = [];
  List<FoodPreference> foodPreferences = [];
  List<GrowthRecord> growthRecords = [];

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    AppConfig.debugMode = _prefs.getBool('debugMode') ?? false;
    await _loadData();
  }

  Future<void> setDebugMode(bool value) async {
    await _prefs.setBool('debugMode', value);
    AppConfig.debugMode = value;
  }

  Future<void> _loadData() async {
    final coloniesJson = _prefs.getString('colonies');
    if (coloniesJson != null) {
      final list = jsonDecode(coloniesJson) as List;
      colonies = list.map((e) => Colony(
        id: e['id'],
        name: e['name'],
        species: e['species'],
        createdAt: DateTime.parse(e['createdAt']),
      )).toList();
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
  }

  Future<void> _saveColonies() async {
    final json = jsonEncode(colonies.map((c) => {'id': c.id, 'name': c.name, 'species': c.species, 'createdAt': c.createdAt.toIso8601String()}).toList());
    await _prefs.setString('colonies', json);
  }

  Future<void> _saveFeedingEvents() async {
    final json = jsonEncode(feedingEvents.map((e) => {'id': e.id, 'colonyId': e.colonyId, 'foodType': e.foodType, 'quantity': e.quantity, 'fedAt': e.fedAt.toIso8601String(), 'notes': e.notes}).toList());
    await _prefs.setString('feedingEvents', json);
  }

  Future<void> _saveFoodPreferences() async {
    final json = jsonEncode(foodPreferences.map((p) => {'colonyId': p.colonyId, 'foodType': p.foodType, 'status': p.status.name}).toList());
    await _prefs.setString('foodPreferences', json);
  }

  String generateId() => DateTime.now().millisecondsSinceEpoch.toString();

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

  Future<void> addFeedingEvent(FeedingEvent e) async {
    feedingEvents.add(e);
    await _saveFeedingEvents();
  }

  Future<void> addFoodPreference(FoodPreference p) async {
    foodPreferences.removeWhere((x) => x.colonyId == p.colonyId && x.foodType == p.foodType);
    foodPreferences.add(p);
    await _saveFoodPreferences();
  }
}