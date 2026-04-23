import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ──────────────────────────────────────────────
  // 1. COLOR PALETTE
  // ──────────────────────────────────────────────

  // Primary: Moonlight Blue
  static const Color primaryLight = Color(0xFF1E3A7B);
  static const Color primaryDark = Color(0xFF7BA7E2);

  // Secondary: Gold accent
  static const Color secondaryLight = Color(0xFFC8951A);
  static const Color secondaryDark = Color(0xFFE8BE5A);

  // Tertiary: Jade
  static const Color tertiaryLight = Color(0xFF2E7D32);
  static const Color tertiaryDark = Color(0xFFA5D6A7);

  // Semantic colors for anniversary types
  static const Color jesaColor = Color(0xFFC62828);
  static const Color birthdayColor = Color(0xFFE65100);
  static const Color etcColor = Color(0xFF2E7D32);

  // Surface tones
  static const Color surfaceLight = Color(0xFFF5F6FA);
  static const Color surfaceDark = Color(0xFF080E20);

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
      textTheme: _textTheme(colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme, Brightness.light),
      chipTheme: _chipTheme(),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputTheme(colorScheme, Brightness.light),
      dialogTheme: _dialogTheme(colorScheme),
      bottomSheetTheme: _bottomSheetTheme(colorScheme, Brightness.light),
      segmentedButtonTheme: _segmentedButtonTheme(),
      navigationBarTheme: _navBarTheme(colorScheme),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
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
    ).copyWith(
      surface: surfaceDark,
      surfaceContainer: const Color(0xFF111828),
      surfaceContainerHigh: const Color(0xFF182038),
      surfaceContainerHighest: const Color(0xFF1E2A42),
      onSurface: const Color(0xFFE2E8F8),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _textTheme(colorScheme),
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme, Brightness.dark),
      chipTheme: _chipTheme(),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputTheme(colorScheme, Brightness.dark),
      dialogTheme: _dialogTheme(colorScheme),
      bottomSheetTheme: _bottomSheetTheme(colorScheme, Brightness.dark),
      segmentedButtonTheme: _segmentedButtonTheme(),
      navigationBarTheme: _navBarTheme(colorScheme),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.25),
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      scaffoldBackgroundColor: surfaceDark,
    );
  }

  // ──────────────────────────────────────────────
  // 4. SUB-THEME BUILDERS
  // ──────────────────────────────────────────────

  static AppBarTheme _appBarTheme(ColorScheme cs) => AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        titleTextStyle: TextStyle(
          fontFamily: GoogleFonts.nanumMyeongjo().fontFamily,
          fontSize: 21,
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
          letterSpacing: 0.2,
        ),
      );

  static CardThemeData _cardTheme(ColorScheme cs, Brightness brightness) =>
      CardThemeData(
        elevation: brightness == Brightness.dark ? 0 : 2,
        shadowColor: brightness == Brightness.dark
            ? Colors.transparent
            : Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: brightness == Brightness.dark
              ? BorderSide(
                  color: cs.outlineVariant.withValues(alpha: 0.2))
              : BorderSide.none,
        ),
        color: brightness == Brightness.dark
            ? cs.surfaceContainer
            : cs.surface,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      );

  static ChipThemeData _chipTheme() => ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      );

  static FilledButtonThemeData _filledButtonTheme() => FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  static OutlinedButtonThemeData _outlinedButtonTheme() =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  static TextButtonThemeData _textButtonTheme() => TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  static InputDecorationTheme _inputTheme(
          ColorScheme cs, Brightness brightness) =>
      InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark
            ? cs.surfaceContainerHigh
            : cs.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: TextStyle(color: cs.onSurfaceVariant),
      );

  static DialogThemeData _dialogTheme(ColorScheme cs) => DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: TextStyle(
          fontFamily: GoogleFonts.nanumMyeongjo().fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: cs.onSurface,
        ),
      );

  static BottomSheetThemeData _bottomSheetTheme(
          ColorScheme cs, Brightness brightness) =>
      BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        backgroundColor: brightness == Brightness.dark
            ? cs.surfaceContainer
            : cs.surface,
        showDragHandle: true,
      );

  static SegmentedButtonThemeData _segmentedButtonTheme() =>
      SegmentedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );

  static NavigationBarThemeData _navBarTheme(ColorScheme cs) =>
      NavigationBarThemeData(
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: cs.primary.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: cs.primary);
          }
          return TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: cs.onSurfaceVariant);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: cs.primary, size: 24);
          }
          return IconThemeData(color: cs.onSurfaceVariant, size: 24);
        }),
      );

  // ──────────────────────────────────────────────
  // 5. TYPOGRAPHY
  // ──────────────────────────────────────────────

  static TextTheme _textTheme(ColorScheme colorScheme) {
    final serifFamily = GoogleFonts.nanumMyeongjo().fontFamily;
    final base = ThemeData(colorScheme: colorScheme).textTheme;
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: serifFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontFamily: serifFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: serifFamily,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontFamily: serifFamily,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontFamily: serifFamily,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.6),
      bodyMedium: base.bodyMedium?.copyWith(height: 1.6),
      bodySmall: base.bodySmall?.copyWith(
        height: 1.4,
        color: colorScheme.onSurfaceVariant,
      ),
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
  // 6. SEMANTIC HELPERS
  // ──────────────────────────────────────────────

  static Color anniversaryColor(String type) {
    switch (type) {
      case 'jesa':
      case '제사':
        return jesaColor;
      case 'birthday':
      case '생일':
        return birthdayColor;
      default:
        return etcColor;
    }
  }

  static IconData anniversaryIcon(String type) {
    switch (type) {
      case 'jesa':
      case '제사':
        return Icons.local_fire_department;
      case 'birthday':
      case '생일':
        return Icons.cake;
      default:
        return Icons.star;
    }
  }

  // ──────────────────────────────────────────────
  // 7. SPACING & RADIUS CONSTANTS
  // ──────────────────────────────────────────────

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  static const double radiusSm = 8;
  static const double radiusMd = 14;
  static const double radiusLg = 20;
  static const double radiusXl = 24;

  // ──────────────────────────────────────────────
  // 8. GRADIENT HELPERS (for fortune/hero cards)
  // ──────────────────────────────────────────────

  static LinearGradient nightSkyGradient = const LinearGradient(
    colors: [Color(0xFF0D1B3E), Color(0xFF1A2F6A), Color(0xFF0A1628)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static LinearGradient goldAccentGradient = const LinearGradient(
    colors: [Color(0xFFB8860B), Color(0xFFD4A72C), Color(0xFFF5C842)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
