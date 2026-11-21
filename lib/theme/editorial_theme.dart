// lib/theme/editorial_theme.dart
//
// CareerSwipe AI — Editorial Utility Design System Tokens & Themes
// Strictly based on Stitch design specifications in editorial_utility/DESIGN.md
// and careerswipe_ai_developer_handoff_architecture_package.md.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// 1. COLOR TOKENS
// ---------------------------------------------------------------------------

class EditorialColors {
  EditorialColors._();

  // Brand Primitives
  static const Color primary = Color(0xFF1E4B38); // Deep Spruce Green
  static const Color primaryDark = Color(0xFF023423);
  static const Color primaryContainer = Color(0xFF2A634D);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF8BBAA2);
  static const Color primaryLight = Color(0xFFEBF3EE); // Subtle spruce tint
  static const Color primaryActive = Color(0xFF153527); // Active pressed spruce

  // Secondary & Muted Tones
  static const Color secondary = Color(0xFF585F65); // Muted Slate
  static const Color secondaryContainer = Color(0xFFDAE0E7);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF5C6369);

  // Tertiary / Alert Tones
  static const Color tertiary = Color(0xFF782912); // Brick Oxide
  static const Color tertiaryContainer = Color(0xFFA84C32);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color alertUrgent = Color(0xFFA84C32);

  // Semantic Signals & Status
  static const Color success = Color(0xFF1B5E20); // Verified SLA passed
  static const Color successContainer = Color(0xFFC8E6C9);
  static const Color warning = Color(0xFFB78103); // Pending window
  static const Color danger = Color(0xFFBA1A1A); // Account purge / error
  static const Color dangerContainer = Color(0xFFFFDAD6);

  // Decision Stamps
  static const Color stampInterested = Color(0xFF1E4B38);
  static const Color stampInterestedBg =
      Color(0x0F1E4B38); // rgba(30, 75, 56, 0.06)
  static const Color stampPass = Color(0xFF636A70);
  static const Color stampPassBg =
      Color(0x0F636A70); // rgba(99, 106, 112, 0.06)

  // Neutral Light (Warm Archival Paper)
  static const Color paperBackground = Color(0xFFFBFBFA); // #FBFBFA / #F9F9F8
  static const Color paperSurface = Color(0xFFFFFFFF);
  static const Color paperSurfaceDim = Color(0xFFDADAD9);
  static const Color paperContainerLow = Color(0xFFF3F4F3);
  static const Color paperContainerMid = Color(0xFFECECEC);
  static const Color paperContainerHigh = Color(0xFFE2E2E2);
  static const Color paperHairline = Color(0xFFE5E5E2); // 1px structural stroke
  static const Color paperTextPrimary = Color(0xFF191C1B);
  static const Color paperTextSecondary = Color(0xFF424945);
  static const Color paperTextTertiary = Color(0xFF717974);
  static const Color paperPlaceholder = Color(0xFF8C9296);

  // Neutral Dark (Rich Charcoal)
  static const Color darkBackground = Color(0xFF121314); // Rich Charcoal canvas
  static const Color darkSurface = Color(0xFF1E2022); // Tactile dark card
  static const Color darkSurfaceElevated = Color(0xFF222527);
  static const Color darkContainerLow = Color(0xFF1A1C1D);
  static const Color darkContainerMid = Color(0xFF282B2D);
  static const Color darkHairline = Color(0xFF2F3235); // 1px dark stroke
  static const Color darkTextPrimary = Color(0xFFEAEAE7);
  static const Color darkTextSecondary = Color(0xFFA5AAA7);
  static const Color darkTextTertiary = Color(0xFF727875);
  static const Color darkPlaceholder = Color(0xFF676D6A);
}

// ---------------------------------------------------------------------------
// 2. SPACING TOKENS (Disciplined 4pt Grid)
// ---------------------------------------------------------------------------

class EditorialSpacing {
  EditorialSpacing._();

  static const double spaceXs = 4.0; // 0.25rem: micro gaps, inner badge padding
  static const double spaceSm = 8.0; // 0.5rem: icon-to-text, list item padding
  static const double spaceMd =
      16.0; // 1.0rem: card internal padding, field separation
  static const double spaceLg =
      24.0; // 1.5rem: card-to-control distance, section stacking
  static const double spaceXl = 32.0; // 2.0rem: major contextual block breaks
  static const double gutter = 16.0; // 1.0rem
  static const double margin = 20.0; // 1.25rem: outer canvas margins
}

// ---------------------------------------------------------------------------
// 3. RADIUS TOKENS (Strict 3-Tier Geometry)
// ---------------------------------------------------------------------------

class EditorialRadii {
  EditorialRadii._();

  /// Tier 1 (4px): Micro elements—metadata badges, chips, stamp outlines, skill tags
  static const double tier1 = 4.0;
  static const Radius r4 = Radius.circular(4.0);
  static const BorderRadius roundedSm = BorderRadius.all(r4);

  /// Tier 2 (8px): Interactive controls—action buttons, text inputs, segmented tabs
  static const double tier2 = 8.0;
  static const Radius r8 = Radius.circular(8.0);
  static const BorderRadius roundedMd = BorderRadius.all(r8);

  /// Tier 3 (16px): Canvas structures—main job swipe cards, persistent bottom sheets
  static const double tier3 = 16.0;
  static const Radius r16 = Radius.circular(16.0);
  static const BorderRadius roundedLg = BorderRadius.all(r16);

  /// Full Pill (for signal fit tags, avatar badges)
  static const BorderRadius roundedFull =
      BorderRadius.all(Radius.circular(9999.0));
}

// ---------------------------------------------------------------------------
// 4. ELEVATION & SHADOW TOKENS (Tactile Paper Depth)
// ---------------------------------------------------------------------------

class EditorialElevation {
  EditorialElevation._();

  /// Minimal tactile paper shadow (swipe cards, floating sheets)
  static const List<BoxShadow> paperCard = [
    BoxShadow(
      color: Color(0x0D121314), // rgba(18, 19, 20, 0.05)
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x08121314), // rgba(18, 19, 20, 0.03)
      blurRadius: 2.0,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> paperCardDark = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 14.0,
      offset: Offset(0, 4),
    ),
  ];
}

// ---------------------------------------------------------------------------
// 5. TYPOGRAPHY (Newsreader Serif + Inter Sans)
// ---------------------------------------------------------------------------

class EditorialTypography {
  EditorialTypography._();

  /// Flag for widget and unit tests to disable remote HTTP font fetching.
  static bool debugDisableGoogleFonts = false;

  // Newsreader Serif Headlines
  static TextStyle headlineXl({Color? color}) => debugDisableGoogleFonts
      ? TextStyle(
          fontFamily: 'Newsreader',
          fontFamilyFallback: const ['serif'],
          fontSize: 34.0,
          fontWeight: FontWeight.w500,
          height: 40.0 / 34.0,
          letterSpacing: -0.68,
          color: color,
        )
      : GoogleFonts.newsreader(
          fontSize: 34.0,
          fontWeight: FontWeight.w500,
          height: 40.0 / 34.0,
          letterSpacing: -0.68, // -0.02em
          color: color,
        );

  static TextStyle headlineXlMobile({Color? color}) => debugDisableGoogleFonts
      ? TextStyle(
          fontFamily: 'Newsreader',
          fontFamilyFallback: const ['serif'],
          fontSize: 28.0,
          fontWeight: FontWeight.w500,
          height: 34.0 / 28.0,
          letterSpacing: -0.42,
          color: color,
        )
      : GoogleFonts.newsreader(
          fontSize: 28.0,
          fontWeight: FontWeight.w500,
          height: 34.0 / 28.0,
          letterSpacing: -0.42, // -0.015em
          color: color,
        );

  static TextStyle headlineLg({Color? color}) => debugDisableGoogleFonts
      ? TextStyle(
          fontFamily: 'Newsreader',
          fontFamilyFallback: const ['serif'],
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
          height: 30.0 / 24.0,
          letterSpacing: -0.24,
          color: color,
        )
      : GoogleFonts.newsreader(
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
          height: 30.0 / 24.0,
          letterSpacing: -0.24, // -0.01em
          color: color,
        );

  static TextStyle headlineMd({Color? color}) => debugDisableGoogleFonts
      ? TextStyle(
          fontFamily: 'Newsreader',
          fontFamilyFallback: const ['serif'],
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          height: 26.0 / 20.0,
          letterSpacing: -0.1,
          color: color,
        )
      : GoogleFonts.newsreader(
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          height: 26.0 / 20.0,
          letterSpacing: -0.1, // -0.005em
          color: color,
        );

  static TextStyle headlineSm({Color? color}) => debugDisableGoogleFonts
      ? TextStyle(
          fontFamily: 'Newsreader',
          fontFamilyFallback: const ['serif'],
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          height: 24.0 / 18.0,
          color: color,
        )
      : GoogleFonts.newsreader(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          height: 24.0 / 18.0,
          color: color,
        );

  // Inter Sans Body
  static TextStyle bodyLg({Color? color}) => debugDisableGoogleFonts
      ? TextStyle(
          fontFamily: 'Inter',
          fontFamilyFallback: const ['sans-serif'],
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          height: 24.0 / 16.0,
          letterSpacing: -0.16,
          color: color,
        )
      : GoogleFonts.inter(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          height: 24.0 / 16.0,
          letterSpacing: -0.16, // -0.01em
          color: color,
        );

  static TextStyle bodyMd({Color? color, FontWeight? fontWeight}) =>
      debugDisableGoogleFonts
          ? TextStyle(
              fontFamily: 'Inter',
              fontFamilyFallback: const ['sans-serif'],
              fontSize: 14.0,
              fontWeight: fontWeight ?? FontWeight.w400,
              height: 20.0 / 14.0,
              color: color,
            )
          : GoogleFonts.inter(
              fontSize: 14.0,
              fontWeight: fontWeight ?? FontWeight.w400,
              height: 20.0 / 14.0,
              color: color,
            );

  static TextStyle bodySm({Color? color, FontWeight? fontWeight}) =>
      debugDisableGoogleFonts
          ? TextStyle(
              fontFamily: 'Inter',
              fontFamilyFallback: const ['sans-serif'],
              fontSize: 12.0,
              fontWeight: fontWeight ?? FontWeight.w400,
              height: 16.0 / 12.0,
              color: color,
            )
          : GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: fontWeight ?? FontWeight.w400,
              height: 16.0 / 12.0,
              color: color,
            );

  // Inter Sans Labels & Stamps
  static TextStyle labelLg({Color? color, FontWeight? fontWeight}) =>
      debugDisableGoogleFonts
          ? TextStyle(
              fontFamily: 'Inter',
              fontFamilyFallback: const ['sans-serif'],
              fontSize: 14.0,
              fontWeight: fontWeight ?? FontWeight.w600,
              height: 18.0 / 14.0,
              letterSpacing: 0.14,
              color: color,
            )
          : GoogleFonts.inter(
              fontSize: 14.0,
              fontWeight: fontWeight ?? FontWeight.w600,
              height: 18.0 / 14.0,
              letterSpacing: 0.14,
              color: color,
            );

  static TextStyle labelMd({Color? color, FontWeight? fontWeight}) =>
      debugDisableGoogleFonts
          ? TextStyle(
              fontFamily: 'Inter',
              fontFamilyFallback: const ['sans-serif'],
              fontSize: 12.0,
              fontWeight: fontWeight ?? FontWeight.w500,
              height: 16.0 / 12.0,
              letterSpacing: 0.24,
              color: color,
            )
          : GoogleFonts.inter(
              fontSize: 12.0,
              fontWeight: fontWeight ?? FontWeight.w500,
              height: 16.0 / 12.0,
              letterSpacing: 0.24,
              color: color,
            );

  /// Editorial Verification Stamp: 11px uppercase, wide tracking 0.08em
  static TextStyle labelStamp({Color? color}) => debugDisableGoogleFonts
      ? TextStyle(
          fontFamily: 'Inter',
          fontFamilyFallback: const ['sans-serif'],
          fontSize: 11.0,
          fontWeight: FontWeight.w700,
          height: 14.0 / 11.0,
          letterSpacing: 0.88,
          color: color,
        )
      : GoogleFonts.inter(
          fontSize: 11.0,
          fontWeight: FontWeight.w700,
          height: 14.0 / 11.0,
          letterSpacing: 0.88, // 0.08em
          color: color,
        );

  // JetBrains Mono for telemetry, hashes, tokens
  static TextStyle telemetryCode({Color? color}) => debugDisableGoogleFonts
      ? TextStyle(
          fontFamily: 'JetBrains Mono',
          fontFamilyFallback: const ['monospace'],
          fontSize: 11.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: color,
        )
      : GoogleFonts.jetBrainsMono(
          fontSize: 11.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: color,
        );
}

// ---------------------------------------------------------------------------
// 6. THEMEDATA BUILDERS
// ---------------------------------------------------------------------------

class EditorialTheme {
  EditorialTheme._();

  static ThemeData get light {
    final textTheme = TextTheme(
      headlineLarge: EditorialTypography.headlineXl(
          color: EditorialColors.paperTextPrimary),
      headlineMedium: EditorialTypography.headlineLg(
          color: EditorialColors.paperTextPrimary),
      headlineSmall: EditorialTypography.headlineMd(
          color: EditorialColors.paperTextPrimary),
      titleLarge: EditorialTypography.headlineSm(
          color: EditorialColors.paperTextPrimary),
      titleMedium:
          EditorialTypography.labelLg(color: EditorialColors.paperTextPrimary),
      titleSmall: EditorialTypography.labelMd(
          color: EditorialColors.paperTextSecondary),
      bodyLarge:
          EditorialTypography.bodyLg(color: EditorialColors.paperTextPrimary),
      bodyMedium:
          EditorialTypography.bodyMd(color: EditorialColors.paperTextPrimary),
      bodySmall:
          EditorialTypography.bodySm(color: EditorialColors.paperTextSecondary),
      labelLarge:
          EditorialTypography.labelLg(color: EditorialColors.paperTextPrimary),
      labelMedium: EditorialTypography.labelMd(
          color: EditorialColors.paperTextSecondary),
      labelSmall: EditorialTypography.labelStamp(
          color: EditorialColors.paperTextTertiary),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: EditorialColors.paperBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: EditorialColors.primary,
        onPrimary: EditorialColors.onPrimary,
        primaryContainer: EditorialColors.primaryContainer,
        onPrimaryContainer: EditorialColors.onPrimaryContainer,
        secondary: EditorialColors.secondary,
        onSecondary: EditorialColors.onSecondary,
        secondaryContainer: EditorialColors.secondaryContainer,
        onSecondaryContainer: EditorialColors.onSecondaryContainer,
        tertiary: EditorialColors.tertiary,
        onTertiary: EditorialColors.onTertiary,
        error: EditorialColors.danger,
        onError: Colors.white,
        errorContainer: EditorialColors.dangerContainer,
        onErrorContainer: Color(0xFF93000A),
        surface: EditorialColors.paperBackground,
        onSurface: EditorialColors.paperTextPrimary,
        outline: EditorialColors.paperHairline,
        outlineVariant: EditorialColors.paperHairline,
      ),
      textTheme: textTheme,
      cardTheme: const CardThemeData(
        color: EditorialColors.paperSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: EditorialRadii.roundedLg,
          side: BorderSide(color: EditorialColors.paperHairline, width: 1.0),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: EditorialColors.paperBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: EditorialTypography.headlineSm(
            color: EditorialColors.paperTextPrimary),
        iconTheme: const IconThemeData(color: EditorialColors.paperTextPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: EditorialColors.primary,
          foregroundColor: EditorialColors.onPrimary,
          minimumSize: const Size(double.infinity, 48.0),
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius: EditorialRadii.roundedMd),
          textStyle: EditorialTypography.labelLg(color: Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: EditorialColors.paperTextPrimary,
          minimumSize: const Size(double.infinity, 48.0),
          elevation: 0,
          side: const BorderSide(
              color: EditorialColors.paperHairline, width: 1.0),
          shape: const RoundedRectangleBorder(
              borderRadius: EditorialRadii.roundedMd),
          textStyle: EditorialTypography.labelLg(
              color: EditorialColors.paperTextPrimary),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: EditorialColors.paperSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        hintStyle:
            EditorialTypography.bodyMd(color: EditorialColors.paperPlaceholder),
        border: const OutlineInputBorder(
          borderRadius: EditorialRadii.roundedMd,
          borderSide:
              BorderSide(color: EditorialColors.paperHairline, width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: EditorialRadii.roundedMd,
          borderSide:
              BorderSide(color: EditorialColors.paperHairline, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: EditorialRadii.roundedMd,
          borderSide: BorderSide(color: EditorialColors.primary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: EditorialRadii.roundedMd,
          borderSide: BorderSide(color: EditorialColors.danger, width: 1.0),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: EditorialColors.paperHairline,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }

  static ThemeData get dark {
    final textTheme = TextTheme(
      headlineLarge: EditorialTypography.headlineXl(
          color: EditorialColors.darkTextPrimary),
      headlineMedium: EditorialTypography.headlineLg(
          color: EditorialColors.darkTextPrimary),
      headlineSmall: EditorialTypography.headlineMd(
          color: EditorialColors.darkTextPrimary),
      titleLarge: EditorialTypography.headlineSm(
          color: EditorialColors.darkTextPrimary),
      titleMedium:
          EditorialTypography.labelLg(color: EditorialColors.darkTextPrimary),
      titleSmall:
          EditorialTypography.labelMd(color: EditorialColors.darkTextSecondary),
      bodyLarge:
          EditorialTypography.bodyLg(color: EditorialColors.darkTextPrimary),
      bodyMedium:
          EditorialTypography.bodyMd(color: EditorialColors.darkTextPrimary),
      bodySmall:
          EditorialTypography.bodySm(color: EditorialColors.darkTextSecondary),
      labelLarge:
          EditorialTypography.labelLg(color: EditorialColors.darkTextPrimary),
      labelMedium:
          EditorialTypography.labelMd(color: EditorialColors.darkTextSecondary),
      labelSmall: EditorialTypography.labelStamp(
          color: EditorialColors.darkTextTertiary),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: EditorialColors.darkBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: EditorialColors.primary,
        onPrimary: EditorialColors.onPrimary,
        primaryContainer: EditorialColors.primaryContainer,
        onPrimaryContainer: EditorialColors.onPrimaryContainer,
        secondary: EditorialColors.secondary,
        onSecondary: EditorialColors.onSecondary,
        secondaryContainer: EditorialColors.darkContainerMid,
        onSecondaryContainer: EditorialColors.darkTextSecondary,
        tertiary: EditorialColors.tertiary,
        onTertiary: EditorialColors.onTertiary,
        error: EditorialColors.danger,
        onError: Colors.white,
        errorContainer: Color(0xFF93000A),
        onErrorContainer: EditorialColors.dangerContainer,
        surface: EditorialColors.darkBackground,
        onSurface: EditorialColors.darkTextPrimary,
        outline: EditorialColors.darkHairline,
        outlineVariant: EditorialColors.darkHairline,
      ),
      textTheme: textTheme,
      cardTheme: const CardThemeData(
        color: EditorialColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: EditorialRadii.roundedLg,
          side: BorderSide(color: EditorialColors.darkHairline, width: 1.0),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: EditorialColors.darkBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: EditorialTypography.headlineSm(
            color: EditorialColors.darkTextPrimary),
        iconTheme: const IconThemeData(color: EditorialColors.darkTextPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: EditorialColors.primary,
          foregroundColor: EditorialColors.onPrimary,
          minimumSize: const Size(double.infinity, 48.0),
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius: EditorialRadii.roundedMd),
          textStyle: EditorialTypography.labelLg(color: Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: EditorialColors.darkTextPrimary,
          minimumSize: const Size(double.infinity, 48.0),
          elevation: 0,
          side:
              const BorderSide(color: EditorialColors.darkHairline, width: 1.0),
          shape: const RoundedRectangleBorder(
              borderRadius: EditorialRadii.roundedMd),
          textStyle: EditorialTypography.labelLg(
              color: EditorialColors.darkTextPrimary),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: EditorialColors.darkSurface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        hintStyle:
            EditorialTypography.bodyMd(color: EditorialColors.darkPlaceholder),
        border: const OutlineInputBorder(
          borderRadius: EditorialRadii.roundedMd,
          borderSide:
              BorderSide(color: EditorialColors.darkHairline, width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: EditorialRadii.roundedMd,
          borderSide:
              BorderSide(color: EditorialColors.darkHairline, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: EditorialRadii.roundedMd,
          borderSide: BorderSide(color: EditorialColors.primary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: EditorialRadii.roundedMd,
          borderSide: BorderSide(color: EditorialColors.danger, width: 1.0),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: EditorialColors.darkHairline,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }
}
