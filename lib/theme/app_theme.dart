import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand palette pulled from the Adwaitha Sangamam logo:
/// deep rust-brown ink line art on a warm cream background.
class AppColors {
  static const Color brown = Color(0xFF5B3421); // deep brown - primary
  static const Color rust = Color(0xFF8B4A26); // warm rust - accent / headings
  static const Color gold = Color(0xFFC17D26); // saffron-gold - highlights
  static const Color cream = Color(0xFFFBF6EE); // background
  static const Color card = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF2E2117); // near-black text
  static const Color muted = Color(0xFF8A7A6B);
  static const Color success = Color(0xFF3E7D4C); // "entered" state
  static const Color danger = Color(0xFFB3402A); // "cancel" state
  static const Color divider = Color(0xFFE7DCCB);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.brown,
        secondary: AppColors.gold,
        surface: AppColors.card,
        error: AppColors.danger,
      ),
      textTheme: GoogleFonts.latoTextTheme(base.textTheme).copyWith(
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: AppColors.brown,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.brown,
        ),
        bodyLarge: const TextStyle(color: AppColors.ink),
        bodyMedium: const TextStyle(color: AppColors.ink),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        elevation: 0,
        foregroundColor: AppColors.brown,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.brown,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brown,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.divider),
        ),
      ),
    );
  }
}
