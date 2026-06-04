import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette
  static const Color navy = Color(0xFF0A1628);
  static const Color navyLight = Color(0xFF112040);
  static const Color navyCard = Color(0xFF162035);
  static const Color gold = Color(0xFFE8A020);
  static const Color goldLight = Color(0xFFFFBB44);
  static const Color green = Color(0xFF22C55E);
  static const Color red = Color(0xFFEF4444);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8BA0C0);
  static const Color textMuted = Color(0xFF4A6080);
  static const Color cardBorder = Color(0xFF1E3050);

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: navy,
        primaryColor: gold,
        colorScheme: const ColorScheme.dark(
          primary: gold,
          secondary: goldLight,
          surface: navyCard,
          background: navy,
        ),
        textTheme: GoogleFonts.outfitTextTheme(
          ThemeData.dark().textTheme.copyWith(
                displayLarge: GoogleFonts.bebasNeue(
                  color: textPrimary,
                  fontSize: 64,
                  letterSpacing: 2,
                ),
                displayMedium: GoogleFonts.bebasNeue(
                  color: gold,
                  fontSize: 48,
                  letterSpacing: 2,
                ),
                headlineLarge: GoogleFonts.outfit(
                  color: textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
                headlineMedium: GoogleFonts.outfit(
                  color: textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                bodyLarge: GoogleFonts.outfit(
                  color: textPrimary,
                  fontSize: 16,
                ),
                bodyMedium: GoogleFonts.outfit(
                  color: textSecondary,
                  fontSize: 14,
                ),
                labelSmall: GoogleFonts.jetBrainsMono(
                  color: gold,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),
        ),
        cardTheme: CardTheme(
          color: navyCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: cardBorder, width: 1),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: navy,
          elevation: 0,
          titleTextStyle: GoogleFonts.outfit(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(color: textPrimary),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: navyLight,
          selectedItemColor: gold,
          unselectedItemColor: textMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: gold,
            foregroundColor: navy,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
}
