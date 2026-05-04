import 'package:antology_app/models/models.dart';

class TimelineEvent {
  final DateTime date;
  final String type; // 'fondation', 'nourrissage', 'croissance', 'photo'
  final String label;
  final Map<String, dynamic>? details;

  TimelineEvent({
    required this.date,
    required this.type,
    required this.label,
    this.details,
  });
}

class TimelineService {
  static List<TimelineEvent> generateEvents({
    required Colony colony,
    required List<FeedingEvent> feedingEvents,
    required List<GrowthRecord> growthRecords,
    required List<int> growthThresholds,
  }) {
    final events = <TimelineEvent>[];

    // 1. Fondation
    events.add(TimelineEvent(
      date: colony.createdAt,
      type: 'fondation',
      label: 'Fondation de ${colony.name}',
    ));

    // 2. Nourrissages
    for (final event in feedingEvents.where((e) => e.colonyId == colony.id)) {
      events.add(TimelineEvent(
        date: event.fedAt,
        type: 'nourrissage',
        label: '${event.foodType} (note: ${event.rating ?? "N/A"})',
        details: {'foodType': event.foodType, 'rating': event.rating, 'quantity': event.quantity},
      ));
    }

    // 3. Photos
    for (final photo in colony.photos) {
      // TODO: Extraire la date réelle d'ajout depuis les métadonnées
      events.add(TimelineEvent(
        date: DateTime.now(), // Placeholder
        type: 'photo',
        label: 'Photo ajoutée',
        details: {'path': photo},
      ));
    }

    // 4. Enregistrements de croissance (changements de population)
    for (final record in growthRecords.where((r) => r.colonyId == colony.id)) {
      // Si des seuils sont définis, on les utilise
      if (growthThresholds.isNotEmpty) {
        for (final threshold in growthThresholds) {
          if (record.populationEstimate >= threshold) {
            events.add(TimelineEvent(
              date: record.recordedAt,
              type: 'croissance',
              label: 'Seuil $threshold individus atteint',
              details: {'threshold': threshold, 'population': record.populationEstimate},
            ));
          }
        }
      } else {
        // Sinon, on ajoute chaque changement de population
        events.add(TimelineEvent(
          date: record.recordedAt,
          type: 'croissance',
          label: 'Population: ${record.populationEstimate} individus',
          details: {'population': record.populationEstimate},
        ));
      }
    }

    // Trier par date
    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }
}
