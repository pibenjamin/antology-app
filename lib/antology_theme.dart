import 'package:flutter/material.dart';

class AntologyColors {
  static const Color forestGreen = Color(0xFF1D9E75);
  static const Color terracotta = Color(0xFFD85A30);
  static const Color stoneGray = Color(0xFF888780);
  static const Color skyBlue = Color(0xFF378ADD);

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

class AntologyTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
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
        outline: AntologyColors.gray400.withValues(alpha: 0.3),
        error: AntologyColors.coral400,
      ),
      scaffoldBackgroundColor: AntologyColors.grayLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0x15000000),
            width: 0.5,
          ),
        ),
      ),
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
          side: const BorderSide(
            color: Color(0x4D000000),
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0x26000000),
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0x26000000),
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
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AntologyColors.gray400,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0x15000000),
        thickness: 0.5,
        space: 1,
      ),
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
        outline: AntologyColors.gray400.withValues(alpha: 0.3),
        error: AntologyColors.coral400,
      ),
      scaffoldBackgroundColor: Colors.black,
    );
  }
}

class AntologySpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  static const EdgeInsets cardPadding = EdgeInsets.all(12);
  static const EdgeInsets screenPadding = EdgeInsets.all(16);
}