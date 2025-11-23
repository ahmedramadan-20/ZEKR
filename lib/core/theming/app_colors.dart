import 'package:flutter/material.dart';

/// Refined Spiritual Color Palette for Quran App
/// Artistically balanced with harmonious tones inspired by Islamic art
/// Maintains WCAG 4.5:1 contrast ratio for accessibility
class AppColors {
  // ============ LIGHT MODE: REFINED PALETTE ============

  // Primary - Deep Emerald (رParadise Gardens)
  static const Color primary = Color(0xFF2E7D32); // Rich emerald green
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF43A047);

  // Gradient Components - Multi-step for depth
  static const Color gradientStart = Color(0xFF2E7D32); // Deep emerald
  static const Color gradientMiddle = Color(0xFF388E3C); // Mid emerald
  static const Color gradientEnd = Color(0xFF43A047); // Bright emerald

  // Secondary - Sunset Gold (رIslamic Calligraphy)
  static const Color secondary = Color(0xFFF57C00); // Deep warm gold
  static const Color secondaryDark = Color(0xFFE65100);
  static const Color accent = Color(0xFFF57C00);

  // ============ BACKGROUNDS - Serene Tones ============

  static const Color background = Color(0xFFF5F7FA); // Soft blue-gray tint
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color backgroundGradient1 = Color(0xFFE8F5E9); // Misty green
  static const Color backgroundGradient2 = Color(0xFFFFF3E0); // Cream gold

  // ============ TEXT COLORS - Refined Typography ============

  static const Color textPrimary = Color(
    0xFF1A237E,
  ); // Deep indigo (spiritual depth)
  static const Color textSecondary = Color(0xFF616161); // Neutral gray
  static const Color textOnGradient = Color(0xFFFFFFFF);

  // Arabic Text (enhanced for readability)
  static const Color arabicText = Color(0xFF1A237E); // Deep indigo
  static const Color ayahNumber = Color(0xFF2E7D32); // Emerald
  static const Color bismillah = Color(0xFFF57C00); // Sunset gold

  // ============ UI ELEMENTS ============

  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFFBDBDBD);
  static const Color error = Color(0xFFC62828); // Deeper red
  static const Color success = Color(0xFF2E7D32); // Emerald
  static const Color shadowLight = Color(0x14000000);
  static const Color shadowMedium = Color(0x29000000);

  // ============ BADGES & LABELS - Distinctive ============

  static const Color makkiBadge = Color(0xFF2E7D32); // Emerald for Makki
  static const Color madaniBadge = Color(0xFFF57C00); // Gold for Madani
  static const Color juzBadge = Color(0xFF5E35B1); // Deep purple for Juz

  // ============ PROGRESS COLORS - Vibrant ============

  static const Color progressGreen = Color(0xFF43A047);
  static const Color progressYellow = Color(0xFFFFA000);
  static const Color progressOrange = Color(0xFFF57C00);

  // ============ READING PAGE - Warm Paper Tone ============

  static const Color pageBackground = Color(0xFFFFFBE6); // Warm parchment
  static const Color highlightColor = Color(0xFFFFE082); // Soft gold highlight

  // ============ ICON COLORS ============

  static const Color iconPrimary = Color(0xFF2E7D32);
  static const Color iconSecondary = Color(0xFFF57C00);
  static const Color iconInactive = Color(0xFFBDBDBD);

  // ============ LIGHT MODE GRADIENTS - Artistic Blends ============

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1B5E20), // Dark emerald
      Color(0xFF2E7D32), // Deep emerald
      Color(0xFF43A047), // Bright emerald
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF57C00), // Deep gold
      Color(0xFFFFB74D), // Soft gold
    ],
  );

  // New: Sunset Gradient for special elements
  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF57C00), // Deep gold
      Color(0xFFFF9800), // Bright orange
      Color(0xFFFFB74D), // Soft gold
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ============ DARK MODE COLORS - Refined Depths ============

  // Backgrounds - True OLED Black with subtle tints
  static const Color darkBackground = Color(0xFF000000); // Pure black (OLED)
  static const Color darkSurface = Color(0xFF121212); // Subtle gray
  static const Color darkCardBackground = Color(0xFF1E1E1E);

  // Primary - Luminous Jade
  static const Color darkPrimary = Color(0xFF66BB6A); // Luminous jade
  static const Color darkPrimaryDark = Color(0xFF4CAF50);
  static const Color darkPrimaryLight = Color(0xFF81C784);

  // Secondary - Golden Amber
  static const Color darkSecondary = Color(0xFFFFCA28); // Golden amber

  // Text - High Contrast
  static const Color darkTextPrimary = Color(0xFFECEFF1); // Almost white
  static const Color darkTextSecondary = Color(0xFFB0BEC5); // Light blue-gray

  // UI Elements
  static const Color darkDivider = Color(0xFF263238);
  static const Color darkShadowLight = Color(0x66000000);
  static const Color darkShadowMedium = Color(0x99000000);

  // ============ DARK MODE GRADIENTS - Sophisticated ============

  static const LinearGradient darkPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0D1F14), // Deep forest
      Color(0xFF1B3320), // Dark jade
      Color(0xFF264D2C), // Rich emerald
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
  );

  // ============ CONTEXT-AWARE HELPERS ============

  static LinearGradient getPrimaryGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkPrimaryGradient
        : primaryGradient;
  }

  static LinearGradient getCardGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkCardGradient
        : cardGradient;
  }

  static List<Color> getStatsGradient1Colors(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)] // Jade tones
        : [const Color(0xFF2E7D32), const Color(0xFF43A047)]; // Emerald tones
  }

  static List<Color> getStatsGradient2Colors(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? [
            const Color(0xFFFFCA28),
            const Color(0xFFFFE082),
          ] // Amber to soft gold
        : [
            const Color(0xFFF57C00),
            const Color(0xFFFFB74D),
          ]; // Deep to soft gold
  }

  static List<Color> getQuickAccessGradientColors(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? [const Color(0xFF5E35B1), const Color(0xFF7E57C2)] // Royal purple
        : [const Color(0xFF4527A0), const Color(0xFF5E35B1)]; // Deep purple
  }
}
