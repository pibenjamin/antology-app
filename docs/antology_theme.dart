/// Antology Design System
/// Design system complet pour l'application de myrmécologie amateur
/// 
/// Palette inspirée de l'observation naturaliste scientifique :
/// - Forest Green (#1D9E75) : Actions primaires, états actifs
/// - Terracotta (#D85A30) : Warnings, espèces invasives
/// - Stone Gray (#888780) : Texte secondaire, bordures
/// - Sky Blue (#378ADD) : Information, liens

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================================
// COLORS PALETTE
// ============================================================================

class AntologyColors {
  // Couleurs primaires
  static const Color forestGreen = Color(0xFF1D9E75);
  static const Color terracotta = Color(0xFFD85A30);
  static const Color stoneGray = Color(0xFF888780);
  static const Color skyBlue = Color(0xFF378ADD);
  
  // Couleurs étendues (palette complète)
  static const Color tealLight = Color(0xFFE1F5EE);
  static const Color teal100 = Color(0xFF9FE1CB);
  static const Color teal200 = Color(0xFF5DCAA5);
  static const Color teal400 = Color(0xFF1D9E75);
  static const Color teal600 = Color(0xFF0F6E56);
  static const Color teal800 = Color(0xFF085041);
  
  static const Color coralLight = Color(0xFFFAECE7);
  static const Color coral400 = Color(0xFFD85A30);
  static const Color coral800 = Color(0xFF712B13);
  
  static const Color grayLight = Color(0xFFF1EFE8);
  static const Color gray200 = Color(0xFFB4B2A9);
  static const Color gray400 = Color(0xFF888780);
  static const Color gray600 = Color(0xFF5F5E5A);
  static const Color gray800 = Color(0xFF444441);
  
  static const Color blueLight = Color(0xFFE6F1FB);
  static const Color blue400 = Color(0xFF378ADD);
  static const Color blue800 = Color(0xFF0C447C);
  
  static const Color greenLight = Color(0xFFEAF3DE);
  static const Color green600 = Color(0xFF3B6D11);
  
  static const Color purpleLight = Color(0xFFEEEDFE);
  static const Color purple600 = Color(0xFF3C3489);
  
  static const Color redLight = Color(0xFFFCEBEB);
  static const Color red600 = Color(0xFFA32D2D);
}

// ============================================================================
// THEME DATA
// ============================================================================

class AntologyTheme {
  /// Theme principal (Light mode)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AntologyColors.forestGreen,
        onPrimary: Colors.white,
        secondary: AntologyColors.terracotta,
        onSecondary: Colors.white,
        tertiary: AntologyColors.skyBlue,
        onTertiary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black87,
        surfaceContainerHighest: AntologyColors.grayLight,
        outline: AntologyColors.gray400.withOpacity(0.3),
        error: AntologyColors.coral400,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AntologyColors.grayLight,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.merriweather(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      
      // Typography
      textTheme: _buildTextTheme(),
      
      // Cards
      cardTheme: CardTheme(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.black.withOpacity(0.08),
            width: 0.5,
          ),
        ),
      ),
      
      // Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AntologyColors.forestGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          minimumSize: const Size(140, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          minimumSize: const Size(140, 44),
          side: BorderSide(
            color: Colors.black.withOpacity(0.3),
            width: 0.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.15),
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.15),
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AntologyColors.forestGreen,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AntologyColors.coral400,
            width: 0.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        hintStyle: TextStyle(
          fontSize: 14,
          color: AntologyColors.gray400,
        ),
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: Colors.black.withOpacity(0.08),
        thickness: 0.5,
        space: 1,
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AntologyColors.grayLight,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  /// Theme sombre (Dark mode)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      
      colorScheme: ColorScheme.dark(
        primary: AntologyColors.teal200,
        onPrimary: Colors.black,
        secondary: AntologyColors.coral400,
        onSecondary: Colors.white,
        tertiary: AntologyColors.blue400,
        onTertiary: Colors.white,
        surface: AntologyColors.gray800,
        onSurface: Colors.white,
        surfaceContainerHighest: AntologyColors.gray600,
        outline: AntologyColors.gray400.withOpacity(0.3),
        error: AntologyColors.coral400,
      ),
      
      scaffoldBackgroundColor: Colors.black,
      
      textTheme: _buildTextTheme(isDark: true),
      
      // Les autres propriétés restent similaires au light theme
      // avec des ajustements pour le mode sombre
    );
  }
  
  static TextTheme _buildTextTheme({bool isDark = false}) {
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color secondaryTextColor = isDark 
        ? Colors.white70 
        : AntologyColors.gray600;
    
    return TextTheme(
      // Display - Pour les noms scientifiques (Merriweather)
      displayLarge: GoogleFonts.merriweather(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: textColor,
        fontStyle: FontStyle.italic,
      ),
      displayMedium: GoogleFonts.merriweather(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.2,
        color: textColor,
        fontStyle: FontStyle.italic,
      ),
      displaySmall: GoogleFonts.merriweather(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.3,
        color: textColor,
        fontStyle: FontStyle.italic,
      ),
      
      // Headlines - Titres de sections
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: textColor,
      ),
      
      // Titles - Sous-titres
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: textColor,
      ),
      
      // Body - Texte principal
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.7,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: textColor,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: secondaryTextColor,
      ),
      
      // Labels - Étiquettes
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        letterSpacing: 0.5,
      ),
    );
  }
}

// ============================================================================
// SPACING CONSTANTS
// ============================================================================

class AntologySpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  
  // Padding presets
  static const EdgeInsets cardPadding = EdgeInsets.all(12);
  static const EdgeInsets screenPadding = EdgeInsets.all(16);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 24,
  );
}

// ============================================================================
// REUSABLE WIDGETS
// ============================================================================

/// Card pour afficher une espèce de fourmi
class AntSpeciesCard extends StatelessWidget {
  final String scientificName;
  final String commonName;
  final String? imageUrl;
  final VoidCallback? onTap;
  
  const AntSpeciesCard({
    super.key,
    required this.scientificName,
    required this.commonName,
    this.imageUrl,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: AntologySpacing.cardPadding,
          child: Row(
            children: [
              // Icône ou image
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AntologyColors.tealLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imageUrl != null 
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.hive_outlined,
                            color: AntologyColors.teal600,
                            size: 28,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.hive_outlined,
                      color: AntologyColors.teal600,
                      size: 28,
                    ),
              ),
              
              const SizedBox(width: 12),
              
              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scientificName,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      commonName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              
              if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: AntologyColors.gray400,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Badge de statut (Native, Invasive, Rare)
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;
  
  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
  });
  
  @override
  Widget build(BuildContext context) {
    final colors = _getColors(type);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: colors.$2,
        ),
      ),
    );
  }
  
  (Color, Color) _getColors(StatusType type) {
    return switch (type) {
      StatusType.native => (
        AntologyColors.greenLight,
        AntologyColors.green600,
      ),
      StatusType.invasive => (
        AntologyColors.redLight,
        AntologyColors.red600,
      ),
      StatusType.rare => (
        AntologyColors.purpleLight,
        AntologyColors.purple600,
      ),
    };
  }
}

enum StatusType { native, invasive, rare }

/// Card de statistiques de colonie
class ColonyStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;
  
  const ColonyStatCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AntologyColors.grayLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: AntologyColors.teal600,
            ),
            const SizedBox(height: 4),
          ],
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Grille de statistiques de colonie (2x2)
class ColonyStatsGrid extends StatelessWidget {
  final int workers;
  final int daysOld;
  final String temperature;
  final String humidity;
  
  const ColonyStatsGrid({
    super.key,
    required this.workers,
    required this.daysOld,
    required this.temperature,
    required this.humidity,
  });
  
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.4,
      children: [
        ColonyStatCard(
          value: workers.toString(),
          label: 'Workers',
          icon: Icons.groups,
        ),
        ColonyStatCard(
          value: daysOld.toString(),
          label: 'Days old',
          icon: Icons.calendar_today,
        ),
        ColonyStatCard(
          value: temperature,
          label: 'Temperature',
          icon: Icons.thermostat,
        ),
        ColonyStatCard(
          value: humidity,
          label: 'Humidity',
          icon: Icons.water_drop,
        ),
      ],
    );
  }
}

/// Input de recherche avec icône
class AntologySearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  
  const AntologySearchField({
    super.key,
    this.hintText = 'Search species, locations...',
    this.onChanged,
    this.controller,
  });
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(
          Icons.search,
          size: 20,
        ),
      ),
    );
  }
}

/// Section header avec titre
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ============================================================================
// EXEMPLE D'UTILISATION
// ============================================================================

/// Exemple de page utilisant le design system
class ExampleAntologyPage extends StatelessWidget {
  const ExampleAntologyPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Colony'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: AntologySpacing.screenPadding,
        children: [
          // Search field
          const AntologySearchField(),
          
          const SizedBox(height: 24),
          
          // Section: Mes espèces
          const SectionHeader(
            title: 'My species',
            subtitle: '3 colonies active',
          ),
          
          AntSpeciesCard(
            scientificName: 'Messor barbarus',
            commonName: 'Harvester ant',
            onTap: () {},
          ),
          
          const SizedBox(height: 8),
          
          AntSpeciesCard(
            scientificName: 'Lasius niger',
            commonName: 'Black garden ant',
            onTap: () {},
          ),
          
          const SizedBox(height: 24),
          
          // Section: Statistiques
          const SectionHeader(title: 'Colony statistics'),
          
          const ColonyStatsGrid(
            workers: 847,
            daysOld: 12,
            temperature: '24°C',
            humidity: '65%',
          ),
          
          const SizedBox(height: 24),
          
          // Section: Status badges
          const SectionHeader(title: 'Conservation status'),
          
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusBadge(
                label: 'Native',
                type: StatusType.native,
              ),
              StatusBadge(
                label: 'Invasive',
                type: StatusType.invasive,
              ),
              StatusBadge(
                label: 'Rare',
                type: StatusType.rare,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Buttons
          FilledButton(
            onPressed: () {},
            child: const Text('Log observation'),
          ),
          
          const SizedBox(height: 8),
          
          OutlinedButton(
            onPressed: () {},
            child: const Text('View history'),
          ),
        ],
      ),
    );
  }
}
