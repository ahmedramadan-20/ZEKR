import 'package:flutter/material.dart';

class AppColors {
  // New Modern Design Colors - Inspired by Dribbble design

  // Primary Gradient Colors (Teal to Purple)
  static const Color gradientStart = Color(0xFF13B4B4); // Teal
  static const Color gradientMiddle = Color(0xFF5E81F4); // Blue-Purple
  static const Color gradientEnd = Color(0xFF9D4EDD); // Purple

  // Primary & Accent
  static const Color primary = Color(0xFF13B4B4); // Teal
  static const Color primaryDark = Color(0xFF0E8A8A);
  static const Color primaryLight = Color(0xFF5DD5D5);

  static const Color secondary = Color(0xFF9D4EDD); // Purple
  static const Color secondaryDark = Color(0xFF7B3FB2);
  static const Color accent = Color(0xFFFFC107); // Warm Yellow

  // Background Colors
  static const Color background = Color(0xFFF8F9FE); // Very light blue-white
  static const Color backgroundGradient1 = Color(0xFFE8F5F5); // Light teal tint
  static const Color backgroundGradient2 = Color(
    0xFFF3E8FF,
  ); // Light purple tint
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1D3D); // Dark blue-black
  static const Color textSecondary = Color(0xFF8896AB); // Muted blue-gray
  static const Color textOnGradient = Color(0xFFFFFFFF);

  // Arabic Text
  static const Color arabicText = Color(0xFF1A1D3D);
  static const Color ayahNumber = Color(0xFF13B4B4);
  static const Color bismillah = Color(0xFF9D4EDD);

  // Badges & Labels
  static const Color makkiBadge = Color(0xFF13B4B4);
  static const Color madaniBadge = Color(0xFF9D4EDD);
  static const Color juzBadge = Color(0xFF5E81F4);

  // Progress & Success
  static const Color progressGreen = Color(0xFF2ECC71);
  static const Color progressYellow = Color(0xFFFFC107);
  static const Color progressOrange = Color(0xFFFF6B35);

  // UI Elements
  static const Color divider = Color(0xFFE8EDF2);
  static const Color dividerDark = Color(0xFFD1D9E6);
  static const Color error = Color(0xFFE74C3C);
  static const Color success = Color(0xFF2ECC71);

  // Card Shadows
  static const Color shadowLight = Color(0x1A13B4B4);
  static const Color shadowMedium = Color(0x3313B4B4);

  // Quran Reading
  static const Color pageBackground = Color(0xFFFFFDF7); // Warm white
  static const Color highlightColor = Color(0xFFFFE5CC); // Light orange

  // Icon Colors
  static const Color iconPrimary = Color(0xFF13B4B4);
  static const Color iconSecondary = Color(0xFF9D4EDD);
  static const Color iconInactive = Color(0xFFD1D9E6);

  // Gradient Helper
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientMiddle, gradientEnd],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF13B4B4), Color(0xFF5E81F4)],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9D4EDD), Color(0xFF5E81F4)],
  );

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F1419); // Dark blue-black
  static const Color darkSurface = Color(0xFF1A1D3D); // Navy
  static const Color darkCardBackground = Color(0xFF1A1D3D); // Navy for cards
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // White
  static const Color darkTextSecondary = Color(
    0xFF8896AB,
  ); // Same muted blue-gray

  // Dark Mode Gradients
  static const LinearGradient darkPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0E8A8A), // Darker Teal
      Color(0xFF4A63B0), // Darker Blue-Purple
    ],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1D3D), // Navy
      Color(0xFF2A2D55), // Lighter Navy
    ],
  );

  // Context-aware helpers
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
        ? [
            const Color(0xFF0E8A8A),
            const Color(0xFF2A4075),
          ] // Dark Teal -> Dark Blue
        : [gradientStart, gradientMiddle];
  }

  static List<Color> getStatsGradient2Colors(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? [
            const Color(0xFF2A4075),
            const Color(0xFF4A2575),
          ] // Dark Blue -> Dark Purple
        : [gradientMiddle, gradientEnd];
  }

  static List<Color> getQuickAccessGradientColors(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? [const Color(0xFF2A4075), const Color(0xFF4A2575)]
        : [gradientMiddle, gradientEnd];
  }
}
