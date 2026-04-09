import 'package:flutter/material.dart';

/// Lunar Calendar App Design System & Theme
///
/// Color philosophy: Inspired by traditional Korean aesthetics (단청, 오방색)
/// blended with modern Material 3 for a refined, culturally resonant feel.
/// The palette draws from natural elements — indigo night sky, warm earth,
/// cinnabar red, and jade green — to evoke the lunar calendar's connection
/// to nature and tradition.

class AppTheme {
  AppTheme._();

  // ──────────────────────────────────────────────
  // 1. COLOR PALETTE
  // ──────────────────────────────────────────────

  // Primary: Deep Indigo (남색) — evokes the night sky and moonlight
  static const Color primaryLight = Color(0xFF3949AB); // indigo 600
  static const Color primaryDark = Color(0xFF9FA8DA); // indigo 200

  // Secondary: Warm Cinnabar (주홍) — traditional Korean accent
  static const Color secondaryLight = Color(0xFFC62828); // deep red
  static const Color secondaryDark = Color(0xFFEF9A9A); // soft red

  // Tertiary: Jade Green (옥색) — prosperity, nature, spring
  static const Color tertiaryLight = Color(0xFF2E7D32); // green 800
  static const Color tertiaryDark = Color(0xFFA5D6A7); // green 200

  // Semantic colors for anniversary types
  static const Color jesaColor = Color(0xFFC62828); // 제사 — cinnabar red
  static const Color birthdayColor = Color(0xFFE65100); // 생일 — warm orange
  static const Color etcColor = Color(0xFF2E7D32); // 기타 — jade green

  // Surface tones
  static const Color surfaceLight = Color(0xFFFCFAF7); // warm off-white (한지)
  static const Color surfaceDark = Color(0xFF1A1B1E); // deep charcoal

  // ──────────────────────────────────────────────
  // 2. LIGHT THEME
  // ──────────────────────────────────────────────

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryLight,
      brightness: Brightness.light,
      secondary: secondaryLight,
      tertiary: tertiaryLight,
      surface: surfaceLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Typography
      textTheme: _textTheme(colorScheme),

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          letterSpacing: -0.3,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        color: colorScheme.surface,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      ),

      // Chips
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),

      // Filled Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: colorScheme.surface,
        showDragHandle: true,
      ),

      // Segmented Button
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(colorScheme.primary),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        thickness: 1,
        space: 1,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Scaffold
      scaffoldBackgroundColor: surfaceLight,
    );
  }

  // ──────────────────────────────────────────────
  // 3. DARK THEME
  // ──────────────────────────────────────────────

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryLight,
      brightness: Brightness.dark,
      secondary: secondaryDark,
      tertiary: tertiaryDark,
      surface: surfaceDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Typography
      textTheme: _textTheme(colorScheme),

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
          letterSpacing: -0.3,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
        color: colorScheme.surfaceContainer,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      ),

      // Chips
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),

      // Filled Buttons
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: colorScheme.surfaceContainer,
        showDragHandle: true,
      ),

      // Segmented Button
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        thickness: 1,
        space: 1,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Scaffold
      scaffoldBackgroundColor: surfaceDark,
    );
  }

  // ──────────────────────────────────────────────
  // 4. TYPOGRAPHY
  // ──────────────────────────────────────────────
  //
  // Uses the system default font stack for maximum compatibility.
  // On Korean devices this typically renders as Pretendard/Apple SD Gothic Neo.
  // To add a custom font (e.g., Noto Serif KR for headings),
  // add it to pubspec.yaml and set fontFamily below.

  static TextTheme _textTheme(ColorScheme colorScheme) {
    final base = ThemeData(colorScheme: colorScheme).textTheme;
    return base.copyWith(
      // Display — not commonly used, but defined for completeness
      displayLarge: base.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
      ),
      // Headlines — screen titles, section headers
      headlineLarge: base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      // Titles — card titles, app bar
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      // Body — main content text
      bodyLarge: base.bodyLarge?.copyWith(
        height: 1.5,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        height: 1.5,
      ),
      bodySmall: base.bodySmall?.copyWith(
        height: 1.4,
        color: colorScheme.onSurfaceVariant,
      ),
      // Labels — chips, buttons, small UI elements
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelSmall: base.labelSmall?.copyWith(
        letterSpacing: 0.3,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  // ──────────────────────────────────────────────
  // 5. SEMANTIC HELPERS
  // ──────────────────────────────────────────────

  /// Returns the semantic color for an anniversary type.
  static Color anniversaryColor(String type) {
    switch (type) {
      case '제사':
        return jesaColor;
      case '생일':
        return birthdayColor;
      default:
        return etcColor;
    }
  }

  /// Returns the icon for an anniversary type.
  static IconData anniversaryIcon(String type) {
    switch (type) {
      case '제사':
        return Icons.local_fire_department;
      case '생일':
        return Icons.cake;
      default:
        return Icons.star;
    }
  }

  // ──────────────────────────────────────────────
  // 6. SPACING CONSTANTS
  // ──────────────────────────────────────────────

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  // ──────────────────────────────────────────────
  // 7. BORDER RADIUS CONSTANTS
  // ──────────────────────────────────────────────

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
}
