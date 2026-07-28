import 'package:flutter/material.dart';

class AppColors {
  // HypAuth 1.0 Palette Tokens
  static const Color paper = Color(0xFFFCFBF8); // Every surface. Warm white, never pure white.
  static const Color ink = Color(0xFF1A1A18); // Primary text, codes, filled buttons, scanner background.
  static const Color ink2 = Color(0xFF4A4842); // Secondary actions and quiet button labels.
  static const Color ink3 = Color(0xFF8D8B82); // Body copy, account emails, key labels.
  static const Color ink4 = Color(0xFFA8A69C); // Micro labels, seconds counters, inactive icons.
  static const Color rule = Color(0xFFEDEBE3); // Default 1px divider and empty countdown track.
  static const Color rule2 = Color(0xFFDEDCD4); // Outlined button borders and stronger dividers.
  static const Color wash = Color(0xFFF5F3EC); // The only fill in the app. Active drag row only.
  static const Color accent = Color(0xFF534AB7); // Countdown fill, search match, active handle, toggles, scan line.
  static const Color danger = Color(0xFFA32D2D); // Final 10 seconds, failed unlock, removal.
  static const Color dangerRule = Color(0xFFE8CFCF); // Outlined red button border.

  // Legacy aliases for backward compatibility
  static const Color darkBackground = ink;
  static const Color darkSurface = ink;
  static const Color darkTextPrimary = paper;
  static const Color darkError = danger;
  static const Color lightBackground = paper;
  static const Color lightSurface = paper;
  static const Color lightTextPrimary = ink;
  static const Color lightError = danger;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paper,
      colorScheme: const ColorScheme.light(
        primary: AppColors.ink,
        secondary: AppColors.accent,
        surface: AppColors.paper,
        error: AppColors.danger,
        onPrimary: AppColors.paper,
        onSurface: AppColors.ink,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.paper,
        elevation: 0,
        scaffoldBackgroundColor: AppColors.paper,
        iconTheme: IconThemeData(color: AppColors.ink),
        titleTextStyle: TextStyle(
          color: AppColors.ink,
          fontSize: 21,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.15,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.rule,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.paper,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink2,
          side: const BorderSide(color: AppColors.rule2, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme; // V1 is Light Mode only per spec
}
