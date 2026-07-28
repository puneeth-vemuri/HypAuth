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

  static const Color darkBackground = ink;
  static const Color darkSurface = ink;
  static const Color darkTextPrimary = paper;
  static const Color darkError = danger;
  static const Color darkAccent = accent;
  static const Color darkPrimary = accent;
  static const Color lightBackground = paper;
  static const Color lightSurface = paper;
  static const Color lightTextPrimary = ink;
  static const Color lightError = danger;
}

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color paper;
  final Color ink;
  final Color ink2;
  final Color ink3;
  final Color ink4;
  final Color rule;
  final Color rule2;
  final Color wash;
  final Color accent;
  final Color danger;
  final Color dangerRule;

  const AppColorsExtension({
    required this.paper,
    required this.ink,
    required this.ink2,
    required this.ink3,
    required this.ink4,
    required this.rule,
    required this.rule2,
    required this.wash,
    required this.accent,
    required this.danger,
    required this.dangerRule,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? paper,
    Color? ink,
    Color? ink2,
    Color? ink3,
    Color? ink4,
    Color? rule,
    Color? rule2,
    Color? wash,
    Color? accent,
    Color? danger,
    Color? dangerRule,
  }) {
    return AppColorsExtension(
      paper: paper ?? this.paper,
      ink: ink ?? this.ink,
      ink2: ink2 ?? this.ink2,
      ink3: ink3 ?? this.ink3,
      ink4: ink4 ?? this.ink4,
      rule: rule ?? this.rule,
      rule2: rule2 ?? this.rule2,
      wash: wash ?? this.wash,
      accent: accent ?? this.accent,
      danger: danger ?? this.danger,
      dangerRule: dangerRule ?? this.dangerRule,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      paper: Color.lerp(paper, other.paper, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      ink2: Color.lerp(ink2, other.ink2, t)!,
      ink3: Color.lerp(ink3, other.ink3, t)!,
      ink4: Color.lerp(ink4, other.ink4, t)!,
      rule: Color.lerp(rule, other.rule, t)!,
      rule2: Color.lerp(rule2, other.rule2, t)!,
      wash: Color.lerp(wash, other.wash, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerRule: Color.lerp(dangerRule, other.dangerRule, t)!,
    );
  }
}

extension AppThemeExtension on BuildContext {
  AppColorsExtension get colors => Theme.of(this).extension<AppColorsExtension>()!;
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
      extensions: const [
        AppColorsExtension(
          paper: AppColors.paper,
          ink: AppColors.ink,
          ink2: AppColors.ink2,
          ink3: AppColors.ink3,
          ink4: AppColors.ink4,
          rule: AppColors.rule,
          rule2: AppColors.rule2,
          wash: AppColors.wash,
          accent: AppColors.accent,
          danger: AppColors.danger,
          dangerRule: AppColors.dangerRule,
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF141414),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFCFBF8),
        secondary: Color(0xFF7B72E9),
        surface: Color(0xFF141414),
        error: Color(0xFFE55D5D),
        onPrimary: Color(0xFF141414),
        onSurface: Color(0xFFFCFBF8),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF141414),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFFCFBF8)),
        titleTextStyle: TextStyle(
          color: Color(0xFFFCFBF8),
          fontSize: 21,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.15,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2C2A26),
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFCFBF8),
          foregroundColor: const Color(0xFF141414),
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
          foregroundColor: const Color(0xFFB5B3AD),
          side: const BorderSide(color: Color(0xFF3F3D38), width: 1),
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
      extensions: const [
        AppColorsExtension(
          paper: Color(0xFF141414),
          ink: Color(0xFFFCFBF8),
          ink2: Color(0xFFB5B3AD),
          ink3: Color(0xFF8D8B82),
          ink4: Color(0xFF5A5852),
          rule: Color(0xFF2C2A26),
          rule2: Color(0xFF3F3D38),
          wash: Color(0xFF1A1A1A),
          accent: Color(0xFF7B72E9),
          danger: Color(0xFFE55D5D),
          dangerRule: Color(0xFF592727),
        ),
      ],
    );
  }
}
