import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF000000);
  static const Color primary = Color(0xFFD2FF55); // Vibrant Lime
  static const Color primaryGlow = Color(0x33D2FF55);
  static const Color accent = Color(0xFF55FFD2); // Minty Blue for gradient
  static const Color error = Color(0xFFFF3B3B);
  static const Color text = Colors.white;
  static const Color textSecondary = Color(0xFF808080);
  static const Color cardBackground = Color(0xFF1A1A1A);
  static const Color glassBackground = Color(0x0DFFFFFF);
  static const Color border = Color(0xFF262626);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        onPrimary: AppColors.background,
        error: AppColors.error,
        surface: AppColors.cardBackground,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.playfairDisplay(
          color: AppColors.text, 
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          color: AppColors.text, 
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.inter(
          color: AppColors.text, 
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(color: AppColors.text),
        bodyMedium: GoogleFonts.inter(color: AppColors.text),
        bodySmall: GoogleFonts.inter(color: AppColors.textSecondary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
    );
  }

  static BoxDecoration glassDecoration = BoxDecoration(
    color: AppColors.glassBackground,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: AppColors.border, width: 1),
  );

  static LinearGradient primaryGradient = const LinearGradient(
    colors: [AppColors.primary, AppColors.accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
