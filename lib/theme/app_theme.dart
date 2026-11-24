// lib/theme/app_theme.dart
//
// CareerSwipe AI — Editorial Utility Design System Tokens
// Aligned with blueprint specifications in editorial_utility/DESIGN.md:
// - Spruce green primary (#1E4B38)
// - Warm archival paper surfaces (#FBFBFA / #F9F9F8)
// - Newsreader serif headlines + Inter sans-serif body/labels
// - Strict 3-tier geometry: Tier 1 (4px), Tier 2 (8px), Tier 3 (16px)
// - Minimal tactile paper depth (no heavy neon blurs/gradients)

import 'package:flutter/material.dart';
import 'editorial_theme.dart';

// ---------------------------------------------------------------------------
// COLOR TOKENS
// ---------------------------------------------------------------------------

class AppColors {
  AppColors._();

  // --- Dark theme (Rich Charcoal) --------------------------------------
  static const darkBackground = EditorialColors.darkBackground; // #121314
  static const darkSurface = EditorialColors.darkSurface; // #1E2022
  static const darkSurfaceElevated = EditorialColors.darkSurfaceElevated; // #222527
  static const darkSurfaceOverlay = EditorialColors.darkContainerLow; // #1A1C1D

  static const darkPrimary = EditorialColors.primary; // #1E4B38
  static const darkPrimaryVariant = EditorialColors.primaryDark; // #023423
  static const darkSecondary = EditorialColors.onPrimaryContainer; // #8BBAA2

  static const darkTextPrimary = EditorialColors.darkTextPrimary; // #EAEAE7
  static const darkTextSecondary = EditorialColors.darkTextSecondary; // #A5AAA7
  static const darkTextDisabled = EditorialColors.darkTextTertiary; // #727875

  static const darkBorder = EditorialColors.darkHairline; // #2F3235
  static const darkBorderFocus = EditorialColors.primary; // #1E4B38

  static const darkSuccess = EditorialColors.success; // #1B5E20
  static const darkWarning = EditorialColors.warning; // #B78103
  static const darkError = EditorialColors.danger; // #BA1A1A

  // --- Light theme (Warm Archival Paper) -------------------------------
  static const lightBackground = EditorialColors.paperBackground; // #FBFBFA / #F9F9F8
  static const lightSurface = EditorialColors.paperSurface; // #FFFFFF
  static const lightSurfaceElevated = EditorialColors.paperSurface; // #FFFFFF
  static const lightSurfaceOverlay = EditorialColors.paperContainerLow; // #F3F4F3

  static const lightPrimary = EditorialColors.primary; // #1E4B38
  static const lightPrimaryVariant = EditorialColors.primaryDark; // #023423
  static const lightSecondary = EditorialColors.secondary; // #585F65

  static const lightTextPrimary = EditorialColors.paperTextPrimary; // #191C1B
  static const lightTextSecondary = EditorialColors.paperTextSecondary; // #424945
  static const lightTextDisabled = EditorialColors.paperTextTertiary; // #717974

  static const lightBorder = EditorialColors.paperHairline; // #E5E5E2
  static const lightBorderFocus = EditorialColors.primary; // #1E4B38

  static const lightSuccess = EditorialColors.success; // #1B5E20
  static const lightWarning = EditorialColors.warning; // #B78103
  static const lightError = EditorialColors.danger; // #BA1A1A

  // --- Shared / status-agnostic ----------------------------------------
  static const disabledOpacity = 0.38;

  // Editorial Tonal Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [EditorialColors.primary, EditorialColors.primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [EditorialColors.darkSurface, EditorialColors.darkBackground],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x0A000000), Color(0x04000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ---------------------------------------------------------------------------
// SPACING TOKENS (Disciplined 4pt Grid)
// ---------------------------------------------------------------------------

class AppSpacing {
  AppSpacing._();

  static const double xs = EditorialSpacing.spaceXs; // 4.0
  static const double sm = EditorialSpacing.spaceSm; // 8.0
  static const double md = 12.0;
  static const double lg = EditorialSpacing.spaceMd; // 16.0
  static const double xl = EditorialSpacing.spaceLg; // 24.0
  static const double xxl = EditorialSpacing.spaceXl; // 32.0
  static const double xxxl = 48.0;

  /// Standard horizontal screen padding.
  static const double screenPadding = EditorialSpacing.gutter; // 16.0
  static const double margin = EditorialSpacing.margin; // 20.0
}

// ---------------------------------------------------------------------------
// RADIUS TOKENS (Strict 3-Tier Geometry)
// ---------------------------------------------------------------------------

class AppRadii {
  AppRadii._();

  /// Tier 1: 4px micro elements (badges, chips, stamps)
  static const double sm = EditorialRadii.tier1; // 4.0

  /// Tier 2: 8px interactive controls (buttons, inputs)
  static const double md = EditorialRadii.tier2; // 8.0

  /// Tier 3: 16px canvas structures (cards, sheets)
  static const double lg = EditorialRadii.tier3; // 16.0
  static const double xl = 16.0;
  static const double pill = 9999.0;

  static BorderRadius card = EditorialRadii.roundedLg; // 16.0
  static BorderRadius button = EditorialRadii.roundedMd; // 8.0
  static BorderRadius sheet = const BorderRadius.vertical(
    top: Radius.circular(EditorialRadii.tier3),
  );
  static BorderRadius input = EditorialRadii.roundedMd; // 8.0
}

// ---------------------------------------------------------------------------
// ELEVATION TOKENS (Tactile Paper Depth)
// ---------------------------------------------------------------------------

class AppElevation {
  AppElevation._();

  static const double flat = 0;
  static const double resting = 0; // Flat Editorial with 1px stroke
  static const double raised = 2;
  static const double overlay = 4;
  static const double modal = 8;

  /// Tactile paper shadow for dark theme
  static List<BoxShadow> darkCardShadow({double intensity = 1}) =>
      EditorialElevation.paperCardDark;

  /// Tactile paper shadow for light theme
  static List<BoxShadow> lightCardShadow({double intensity = 1}) =>
      EditorialElevation.paperCard;
}

// ---------------------------------------------------------------------------
// MOTION TOKENS
// ---------------------------------------------------------------------------

class AppMotion {
  AppMotion._();

  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration standard = Duration(milliseconds: 240);
  static const Duration slow = Duration(milliseconds: 360);
  static const Duration deliberate = Duration(milliseconds: 480);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeOutBack;
  static const Curve spring = Curves.easeOutCubic;

  static const double swipeDismissVelocityThreshold = 700;
  static const double swipeDismissDistanceThreshold = 120;
  static const double swipeMaxRotationRadians = 0.35;
}

// ---------------------------------------------------------------------------
// TYPOGRAPHY (Newsreader Serif + Inter Sans)
// ---------------------------------------------------------------------------

class AppTypography {
  AppTypography._();

  static TextTheme textTheme(Color primaryText, Color secondaryText) {
    return TextTheme(
      headlineLarge: EditorialTypography.headlineXl(color: primaryText),
      headlineMedium: EditorialTypography.headlineLg(color: primaryText),
      headlineSmall: EditorialTypography.headlineMd(color: primaryText),
      titleLarge: EditorialTypography.headlineSm(color: primaryText),
      titleMedium: EditorialTypography.labelLg(color: primaryText),
      titleSmall: EditorialTypography.labelMd(color: secondaryText),
      bodyLarge: EditorialTypography.bodyLg(color: primaryText),
      bodyMedium: EditorialTypography.bodyMd(color: primaryText),
      bodySmall: EditorialTypography.bodySm(color: secondaryText),
      labelLarge: EditorialTypography.labelLg(color: primaryText),
      labelMedium: EditorialTypography.labelMd(color: secondaryText),
      labelSmall: EditorialTypography.labelStamp(color: secondaryText),
    );
  }
}

// ---------------------------------------------------------------------------
// THEME ASSEMBLY
// ---------------------------------------------------------------------------

class AppTheme {
  AppTheme._();

  // Screen compatibility tokens
  static const Color primaryColor = EditorialColors.primary;
  static const Color primaryLight = EditorialColors.primaryLight;
  static const Color primaryDark = EditorialColors.primaryDark;
  static const Color accentColor = EditorialColors.secondary;
  static const Color successColor = EditorialColors.success;
  static const Color warningColor = EditorialColors.warning;
  static const Color errorColor = EditorialColors.danger;
  static const Color infoColor = EditorialColors.secondary;

  static const Color darkBackground = EditorialColors.darkBackground;
  static const Color darkSurface = EditorialColors.darkSurface;
  static const Color darkCard = EditorialColors.darkSurfaceElevated;
  static const Color darkElevated = EditorialColors.darkContainerLow;
  static const Color darkBorder = EditorialColors.darkHairline;

  static const Color lightBackground = EditorialColors.paperBackground;
  static const Color lightSurface = EditorialColors.paperSurface;
  static const Color lightCard = EditorialColors.paperSurface;
  static const Color lightElevated = EditorialColors.paperContainerLow;
  static const Color lightBorder = EditorialColors.paperHairline;

  static const Color darkTextPrimary = EditorialColors.darkTextPrimary;
  static const Color darkTextSecondary = EditorialColors.darkTextSecondary;
  static const Color darkTextTertiary = EditorialColors.darkTextTertiary;

  static const Color lightTextPrimary = EditorialColors.paperTextPrimary;
  static const Color lightTextSecondary = EditorialColors.paperTextSecondary;
  static const Color lightTextTertiary = EditorialColors.paperTextTertiary;

  static const LinearGradient primaryGradient = AppColors.primaryGradient;
  static const LinearGradient darkGradient = AppColors.darkGradient;
  static const LinearGradient glassGradient = AppColors.glassGradient;

  static List<BoxShadow> get softShadow => EditorialElevation.paperCard;
  static List<BoxShadow> get mediumShadow => EditorialElevation.paperCard;
  static List<BoxShadow> get glowShadow => EditorialElevation.paperCard;

  static ThemeData get darkTheme => dark;
  static ThemeData get lightTheme => light;

  /// Returns the blueprint's Editorial Utility Dark ThemeData
  static ThemeData get dark => EditorialTheme.dark;

  /// Returns the blueprint's Editorial Utility Light ThemeData
  static ThemeData get light => EditorialTheme.light;
}
