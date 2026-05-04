import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:antology_app/services/timeline_service.dart';

class TimelineWidget extends StatelessWidget {
  final List<TimelineEvent> events;

  const TimelineWidget({super.key, required this.events});

  Color _getEventColor(String type) {
    switch (type) {
      case 'fondation':
        return Colors.brown;
      case 'nourrissage':
        return Colors.green;
      case 'croissance':
        return Colors.blue;
      case 'photo':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'fondation':
        return FontAwesomeIcons.bug;
      case 'nourrissage':
        return Icons.restaurant;
      case 'croissance':
        return Icons.trending_up;
      case 'photo':
        return Icons.camera;
      default:
        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(child: Text('Aucun événement à afficher'));
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final color = _getEventColor(event.type);
          final icon = _getEventIcon(event.type);

          return Container(
            width: 120,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Container(
                  width: 2,
                  height: 20,
                  color: color.withOpacity(0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  '${event.date.day}/${event.date.month}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    event.label,
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
