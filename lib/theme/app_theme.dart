// lib/theme/app_theme.dart
//
// CareerSwipe AI — Design Token System
//
// Single source of truth for color, typography, spacing, radius, elevation
// and motion tokens, plus ThemeData for light/dark/system modes.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// COLOR TOKENS
// ---------------------------------------------------------------------------

class AppColors {
  AppColors._();

  // --- Dark theme -----------------------------------------------------
  static const darkBackground = Color(0xFF0A0E17); // deep midnight/navy
  static const darkSurface = Color(0xFF12161F); // charcoal surface
  static const darkSurfaceElevated = Color(0xFF1A1F2C); // raised card
  static const darkSurfaceOverlay = Color(0xFF232838); // sheets/dialogs

  static const darkPrimary = Color(0xFF8B7CF6); // restrained electric-violet
  static const darkPrimaryVariant = Color(0xFF6D5BD0);
  static const darkSecondary = Color(0xFF3FD1C7); // teal/cyan — AI/positive

  static const darkTextPrimary = Color(0xFFF2F3F7);
  static const darkTextSecondary = Color(0xFFA6ACBD);
  static const darkTextDisabled = Color(0xFF5B6174);

  static const darkBorder = Color(0xFF2A3042);
  static const darkBorderFocus = Color(0xFF8B7CF6);

  static const darkSuccess = Color(0xFF3FD1A0);
  static const darkWarning = Color(0xFFE8B24D);
  static const darkError = Color(0xFFE5637A);

  // --- Light theme ------------------------------------------------------
  static const lightBackground = Color(0xFFFAFAFB); // warm-neutral white
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceElevated = Color(0xFFFFFFFF);
  static const lightSurfaceOverlay = Color(0xFFF3F3F6);

  static const lightPrimary = Color(0xFF6D5BD0); // restrained violet
  static const lightPrimaryVariant = Color(0xFF574AAE);
  static const lightSecondary = Color(0xFF159E93); // teal, darker for contrast

  static const lightTextPrimary = Color(0xFF14151A);
  static const lightTextSecondary = Color(0xFF5B5F6B);
  static const lightTextDisabled = Color(0xFFA7AAB3);

  static const lightBorder = Color(0xFFE4E4EA);
  static const lightBorderFocus = Color(0xFF6D5BD0);

  static const lightSuccess = Color(0xFF1C9A72);
  static const lightWarning = Color(0xFFB8821E);
  static const lightError = Color(0xFFCC3B55);

  // --- Shared / status-agnostic ----------------------------------------
  static const disabledOpacity = 0.38;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [darkPrimary, darkSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1F2C), Color(0xFF0A0E17)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x20FFFFFF), Color(0x0DFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ---------------------------------------------------------------------------
// SPACING TOKENS  (4pt base grid)
// ---------------------------------------------------------------------------

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Standard horizontal screen padding.
  static const double screenPadding = lg;
}

// ---------------------------------------------------------------------------
// RADIUS TOKENS
// ---------------------------------------------------------------------------

class AppRadii {
  AppRadii._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;

  static BorderRadius card = BorderRadius.circular(lg);
  static BorderRadius button = BorderRadius.circular(md);
  static BorderRadius sheet = const BorderRadius.vertical(
    top: Radius.circular(xl),
  );
  static BorderRadius input = BorderRadius.circular(md);
}

// ---------------------------------------------------------------------------
// ELEVATION TOKENS
// ---------------------------------------------------------------------------

class AppElevation {
  AppElevation._();

  static const double flat = 0;
  static const double resting = 1; // default card
  static const double raised = 4; // active/dragged card
  static const double overlay = 8; // sheets, dialogs, menus
  static const double modal = 16; // full-screen modal content

  /// Depth-aware shadow for dark theme — soft, low-opacity, not a drop shadow.
  static List<BoxShadow> darkCardShadow({double intensity = 1}) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.35 * intensity),
          blurRadius: 24 * intensity,
          offset: Offset(0, 8 * intensity),
        ),
        BoxShadow(
          color: AppColors.darkPrimary.withValues(alpha: 0.06 * intensity),
          blurRadius: 40 * intensity,
          offset: Offset.zero,
        ),
      ];

  static List<BoxShadow> lightCardShadow({double intensity = 1}) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06 * intensity),
          blurRadius: 20 * intensity,
          offset: Offset(0, 6 * intensity),
        ),
      ];
}

// ---------------------------------------------------------------------------
// MOTION TOKENS
// ---------------------------------------------------------------------------

class AppMotion {
  AppMotion._();

  // Durations
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration standard = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 360);
  static const Duration deliberate = Duration(milliseconds: 480);

  // Curves — a restrained, consistent easing vocabulary.
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeOutBack; // use sparingly
  static const Curve spring =
      Curves.easeOutCubic; // paired with SpringSimulation for cards

  // Swipe-card physics (used with Draggable/Custom gesture + AnimationController)
  static const double swipeDismissVelocityThreshold = 700; // px/s
  static const double swipeDismissDistanceThreshold = 120; // px
  static const double swipeMaxRotationRadians = 0.35; // ~20deg at full drag
}

// ---------------------------------------------------------------------------
// TYPOGRAPHY
// ---------------------------------------------------------------------------

class AppTypography {
  AppTypography._();

  static const String? fontFamily = null;

  static TextTheme textTheme(Color primaryText, Color secondaryText) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.15,
        color: primaryText,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.2,
        color: primaryText,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: primaryText,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: primaryText,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: primaryText,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: primaryText,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: secondaryText,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: primaryText,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: secondaryText,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// THEME ASSEMBLY
// ---------------------------------------------------------------------------

class AppTheme {
  AppTheme._();

  // Legacy & screen compatibility tokens
  static const Color primaryColor = AppColors.darkPrimary;
  static const Color primaryLight = Color(0xFFA597F8);
  static const Color primaryDark = AppColors.darkPrimaryVariant;
  static const Color accentColor = AppColors.darkSecondary;
  static const Color successColor = AppColors.darkSuccess;
  static const Color warningColor = AppColors.darkWarning;
  static const Color errorColor = AppColors.darkError;
  static const Color infoColor = AppColors.darkSecondary;

  static const Color darkBackground = AppColors.darkBackground;
  static const Color darkSurface = AppColors.darkSurface;
  static const Color darkCard = AppColors.darkSurfaceElevated;
  static const Color darkElevated = AppColors.darkSurfaceOverlay;
  static const Color darkBorder = AppColors.darkBorder;

  static const Color lightBackground = AppColors.lightBackground;
  static const Color lightSurface = AppColors.lightSurface;
  static const Color lightCard = AppColors.lightSurfaceElevated;
  static const Color lightElevated = AppColors.lightSurfaceOverlay;
  static const Color lightBorder = AppColors.lightBorder;

  static const Color darkTextPrimary = AppColors.darkTextPrimary;
  static const Color darkTextSecondary = AppColors.darkTextSecondary;
  static const Color darkTextTertiary = AppColors.darkTextDisabled;

  static const Color lightTextPrimary = AppColors.lightTextPrimary;
  static const Color lightTextSecondary = AppColors.lightTextSecondary;
  static const Color lightTextTertiary = AppColors.lightTextDisabled;

  static const LinearGradient primaryGradient = AppColors.primaryGradient;
  static const LinearGradient darkGradient = AppColors.darkGradient;
  static const LinearGradient glassGradient = AppColors.glassGradient;

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get glowShadow => [
        BoxShadow(
          color: AppColors.darkPrimary.withValues(alpha: 0.3),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];

  static ThemeData get darkTheme => dark;
  static ThemeData get lightTheme => light;

  static ThemeData get dark {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: Colors.white,
      secondary: AppColors.darkSecondary,
      onSecondary: Colors.black,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.darkError,
      onError: Colors.white,
      outline: AppColors.darkBorder,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme(
        AppColors.darkTextPrimary,
        AppColors.darkTextSecondary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurfaceElevated,
        elevation: AppElevation.resting,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.card),
        margin: EdgeInsets.zero,
      ),
      dividerColor: AppColors.darkBorder,
      inputDecorationTheme: _inputTheme(
        fill: AppColors.darkSurfaceElevated,
        border: AppColors.darkBorder,
        focusBorder: AppColors.darkBorderFocus,
        hintColor: AppColors.darkTextSecondary,
      ),
      elevatedButtonTheme: _elevatedButtonTheme(
        bg: AppColors.darkPrimary,
        fg: Colors.white,
      ),
      outlinedButtonTheme: _outlinedButtonTheme(
        fg: AppColors.darkTextPrimary,
        border: AppColors.darkBorder,
      ),
      textButtonTheme: _textButtonTheme(fg: AppColors.darkPrimary),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.darkSurfaceOverlay,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.sheet),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurfaceOverlay,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurfaceOverlay,
        contentTextStyle: const TextStyle(color: AppColors.darkTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      pageTransitionsTheme: _pageTransitions,
    );
  }

  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: Colors.white,
      secondary: AppColors.lightSecondary,
      onSecondary: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      error: AppColors.lightError,
      onError: Colors.white,
      outline: AppColors.lightBorder,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme(
        AppColors.lightTextPrimary,
        AppColors.lightTextSecondary,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurfaceElevated,
        elevation: AppElevation.resting,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.card),
        margin: EdgeInsets.zero,
      ),
      dividerColor: AppColors.lightBorder,
      inputDecorationTheme: _inputTheme(
        fill: AppColors.lightSurfaceOverlay,
        border: AppColors.lightBorder,
        focusBorder: AppColors.lightBorderFocus,
        hintColor: AppColors.lightTextSecondary,
      ),
      elevatedButtonTheme: _elevatedButtonTheme(
        bg: AppColors.lightPrimary,
        fg: Colors.white,
      ),
      outlinedButtonTheme: _outlinedButtonTheme(
        fg: AppColors.lightTextPrimary,
        border: AppColors.lightBorder,
      ),
      textButtonTheme: _textButtonTheme(fg: AppColors.lightPrimary),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.lightSurfaceOverlay,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.sheet),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightTextPrimary,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      pageTransitionsTheme: _pageTransitions,
    );
  }

  // --- shared sub-theme builders ----------------------------------------

  static InputDecorationTheme _inputTheme({
    required Color fill,
    required Color border,
    required Color focusBorder,
    required Color hintColor,
  }) {
    OutlineInputBorder outline(Color c, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: AppRadii.input,
          borderSide: BorderSide(color: c, width: width),
        );
    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      hintStyle: TextStyle(color: hintColor),
      border: outline(border),
      enabledBorder: outline(border),
      focusedBorder: outline(focusBorder, width: 1.5),
      errorBorder: outline(AppColors.darkError),
      focusedErrorBorder: outline(AppColors.darkError, width: 1.5),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme({
    required Color bg,
    required Color fg,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        disabledBackgroundColor:
            bg.withValues(alpha: AppColors.disabledOpacity),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.button),
        elevation: 0,
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme({
    required Color fg,
    required Color border,
  }) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: fg,
        side: BorderSide(color: border),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.button),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme({required Color fg}) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: fg,
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }

  /// Shared-axis-style page transitions; no third-party dependency required.
  static const PageTransitionsTheme _pageTransitions = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
    },
  );
}

// ---------------------------------------------------------------------------
// STATUS COLOR HELPER — for ApplicationTracker / ATS badges, theme-aware
// ---------------------------------------------------------------------------

enum AppStatusTone { success, warning, error, neutral }

Color statusColor(BuildContext context, AppStatusTone tone) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  switch (tone) {
    case AppStatusTone.success:
      return isDark ? AppColors.darkSuccess : AppColors.lightSuccess;
    case AppStatusTone.warning:
      return isDark ? AppColors.darkWarning : AppColors.lightWarning;
    case AppStatusTone.error:
      return isDark ? AppColors.darkError : AppColors.lightError;
    case AppStatusTone.neutral:
      return isDark
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary;
  }
}
