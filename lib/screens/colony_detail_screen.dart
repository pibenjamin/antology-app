import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../antology_theme.dart';
import '../models/models.dart';
import '../services/storage_service.dart';

class ColonyDetailScreen extends StatefulWidget {
  final String colonyId;
  final StorageService storage;

  const ColonyDetailScreen({
    super.key,
    required this.colonyId,
    required this.storage,
  });

  @override
  State<ColonyDetailScreen> createState() => _ColonyDetailScreenState();
}

class _ColonyDetailScreenState extends State<ColonyDetailScreen> {
  String _selectedFilter = 'Tous';

  final List<Map<String, dynamic>> _journalEntries = [
    {
      'date': '12 Oct',
      'icon': Icons.restaurant,
      'title': 'Sucre + Criblage',
      'description': 'Remplacé la trémie d\'alimentation. Les ouvrières sont immédiatement actives.',
      'color': AntologyColors.moss,
      'type': 'Alimentation',
    },
    {
      'date': '11 Oct',
      'icon': Icons.people,
      'title': 'Comptage de population',
      'description': '480 ouvrières recensées lors du dernier comptage.',
      'color': AntologyColors.sand,
      'type': 'Observations',
    },
    {
      'date': '10 Oct',
      'icon': Icons.thermostat,
      'title': 'Vérification de la temperature',
      'description': 'Câble de chauffage maintenant à 24.5°C.',
      'color': AntologyColors.slate,
      'type': 'Observations',
    },
    {
      'date': '08 Oct',
      'icon': Icons.warning_amber,
      'title': 'Mousse détectée',
      'description': 'Petite mousse sur la coquille d\'insecte restante.',
      'color': AntologyColors.terracotta,
      'type': 'Alertes',
    },
    {
      'date': '05 Oct',
      'icon': Icons.hive,
      'title': 'Grande pile de couvées',
      'description': 'La reine est couvante en grande quantité. Grande pile d\'œufs.',
      'color': AntologyColors.sand,
      'type': 'Observations',
    },
  ];

  List<Map<String, dynamic>> get _filteredEntries {
    if (_selectedFilter == 'Tous') return _journalEntries;
    return _journalEntries.where((entry) => entry['type'] == _selectedFilter).toList();
  }

  String get _latestTemperature {
    for (final entry in _journalEntries) {
      final desc = (entry['description'] ?? '') as String;
      if (desc.contains('°C')) {
        final match = RegExp(r'(\d+(?:\.\d+)?)°C').firstMatch(desc);
        if (match != null) {
          return '${match.group(1)}°C';
        }
      }
    }
    return '--';
  }

  String get _latestPopulation {
    for (final entry in _journalEntries) {
      final title = entry['title'] as String;
      final desc = entry['description'] as String;
      if (title.contains('population') || desc.contains('ouvrières') || desc.contains('individus')) {
        final words = desc.split(' ');
        for (final word in words) {
          final cleaned = word.replaceAll(RegExp(r'[^0-9]'), '');
          if (cleaned.isNotEmpty) {
            return '~$cleaned';
          }
        }
      }
    }
    return '--';
  }

  Colony? get _colony {
    try {
      return widget.storage.colonies.firstWhere((c) => c.id == widget.colonyId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colony = _colony;

    if (colony == null) {
      return Scaffold(
        backgroundColor: AntologyColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Colonie non trouvée',
                style: GoogleFonts.dmSans(color: AntologyColors.sand),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AntologyColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: Image.network(
                'https://www.transparenttextures.com/patterns/stardust.png',
                repeat: ImageRepeat.repeat,
                errorBuilder: (_, __, ___) => Container(color: AntologyColors.background),
              ),
            ),
          ),
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 24),
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildStatsRow(context),
              const SizedBox(height: 32),
              _buildVitalityBar(context),
              const SizedBox(height: 32),
              _buildJournalSection(context),
              const SizedBox(height: 100),
            ],
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final species = _colony?.species ?? 'Espèce inconnue';
    final colonyName = _colony?.name ?? 'Colonia';
    final createdAt = _colony?.createdAt ?? DateTime.now();
    final dateStr = 'Créée le ${AppConfig.formatDateFull(createdAt)}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            colonyName,
            style: GoogleFonts.ptSerif(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: AntologyColors.amber,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            species,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: AntologyColors.sand,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AntologyColors.surface,
                  borderRadius: BorderRadius.circular(AntologyRadius.sm),
                  border: Border.all(color: AntologyColors.border),
                ),
                child: Text(
                  dateStr,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AntologyColors.sand,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AntologyColors.moss,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Florissante',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AntologyColors.moss,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final temperature = _latestTemperature;
    final population = _latestPopulation;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(icon: Icons.layers, value: '1', label: 'Reine', color: AntologyColors.amber),
          _buildStatItem(icon: Icons.groups, value: population, label: 'Ouvrières', color: AntologyColors.sand),
          _buildStatItem(icon: Icons.circle_outlined, value: 'High', label: 'Couvées', color: AntologyColors.sand),
          _buildStatItem(icon: Icons.thermostat, value: temperature, label: 'Température', color: AntologyColors.slate),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AntologyColors.foreground,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: AntologyColors.sand,
          ),
        ),
      ],
    );
  }

  Widget _buildVitalityBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AntologyColors.surface,
          borderRadius: BorderRadius.circular(AntologyRadius.lg),
          border: Border.all(color: AntologyColors.border),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vitalité de la colonie',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AntologyColors.sand,
                  ),
                ),
                Text(
                  'Post-diapause · Récupération active',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AntologyColors.moss,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: AntologyColors.background,
                borderRadius: BorderRadius.circular(AntologyRadius.full),
                border: Border.all(color: AntologyColors.border),
              ),
              child: FractionallySizedBox(
                widthFactor: 0.78,
                child: Container(
                  decoration: BoxDecoration(
                    color: AntologyColors.moss,
                    borderRadius: BorderRadius.circular(AntologyRadius.full),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Journal',
            style: GoogleFonts.ptSerif(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: AntologyColors.foreground,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Tous', 'Alimentation', 'Observations', 'Notes', 'Alertes']
                  .map((filter) => _buildFilterChip(filter))
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
          _buildTimeline(context),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AntologyColors.amber : Colors.transparent,
            borderRadius: BorderRadius.circular(AntologyRadius.full),
            border: Border.all(
              color: isSelected ? AntologyColors.amber : AntologyColors.border,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: isSelected ? AntologyColors.primaryForeground : AntologyColors.sand,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final entries = _filteredEntries;

    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: Text(
          'Aucun résultat',
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: AntologyColors.sand,
          ),
        ),
      );
    }

    return Column(
      children: entries.map((entry) {
        return _buildTimelineEntry(
          context,
          entry['date'],
          entry['icon'],
          entry['title'],
          entry['description'],
          entry['color'],
        );
      }).toList(),
    );
  }

  Widget _buildTimelineEntry(BuildContext context, String date, IconData icon, String title, String description, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Text(
            date,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AntologyColors.sand,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AntologyColors.background,
                border: Border.all(
                  color: iconColor,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 16,
                color: iconColor,
              ),
            ),
            Container(
              width: 1,
              height: 80,
              color: AntologyColors.border,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AntologyColors.surface,
              borderRadius: BorderRadius.circular(AntologyRadius.lg),
              border: Border.all(color: AntologyColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AntologyColors.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AntologyColors.sand,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AntologyColors.amber,
        borderRadius: BorderRadius.circular(AntologyRadius.full),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add, size: 20, color: AntologyColors.primaryForeground),
          const SizedBox(width: 8),
          Text(
            'Nouvelle entrée',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AntologyColors.primaryForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AntologyColors.surface,
        border: const Border(top: BorderSide(color: AntologyColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.home, 'Accueil', false),
          _buildNavItem(context, Icons.book, 'Journal', true),
          _buildNavItem(context, Icons.hive_outlined, 'Espèces', false),
          _buildNavItem(context, Icons.trending_up, 'Vols', false),
          _buildNavItem(context, Icons.person, 'Profil', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (label == 'Accueil') {
          context.go('/home');
        }
        // TODO: Add navigation for other items when screens are ready
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? AntologyColors.amber : AntologyColors.sand,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: isSelected ? AntologyColors.amber : AntologyColors.sand,
            ),
          ),
        ],
      ),
    );
  }
}
