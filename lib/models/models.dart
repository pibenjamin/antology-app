class AppConfig {
  static bool debugMode = false;
  static String debugEmail = 'benjaminpiscart@gmail.com';
  static String debugPassword = 'welcome2HRSD2022!';
}

enum Role { queen, worker, male, brood }
enum Frequency { daily, every2days, weekly, biweekly, monthly }
enum FoodStatus { accepted, rejected, unknown }

class Colony {
  final String id;
  final String name;
  final String species;
  final DateTime createdAt;

  Colony({required this.id, required this.name, required this.species, required this.createdAt});
}

class Individual {
  final String id;
  final String colonyId;
  final Role role;
  final String? notes;
  final DateTime createdAt;

  Individual({required this.id, required this.colonyId, required this.role, this.notes, required this.createdAt});
}

class FeedingEvent {
  final String id;
  final String colonyId;
  final String foodType;
  final String? quantity;
  final DateTime fedAt;
  final String? notes;

  FeedingEvent({required this.id, required this.colonyId, required this.foodType, this.quantity, required this.fedAt, this.notes});
}

class FeedingSchedule {
  final String id;
  final String colonyId;
  final Frequency frequency;
  final String foodType;
  final bool enabled;

  FeedingSchedule({required this.id, required this.colonyId, required this.frequency, required this.foodType, required this.enabled});
}

class FoodPreference {
  final String colonyId;
  final String foodType;
  final FoodStatus status;

  FoodPreference({required this.colonyId, required this.foodType, required this.status});
}

class GrowthRecord {
  final String id;
  final String colonyId;
  final int populationEstimate;
  final DateTime recordedAt;
  final String? notes;

  GrowthRecord({required this.id, required this.colonyId, required this.populationEstimate, required this.recordedAt, this.notes});
}