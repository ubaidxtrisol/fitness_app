import 'package:flutter/material.dart';

/// AppColors contains the color palette for the cloud storage application.
/// It defines primary, secondary, semantic, and neutral colors used throughout the app.
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Brand Colors
  static const Color primary = Color(0xFFE45881);
  static const Color primaryLight = Color(0xFFFEEFF2);
  static const Color primaryDark = Color(0xFFFF0C53);

  ///Primary Gradient Colors
  static const Color primaryGradientStart = Color(0xFFE94093);
  static const Color primaryGradientEnd = Color(0xFFFD8360);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutral Colors (Text, Borders, Backgrounds)
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF9C9C9C);
  static const Color textLight = Color(0xFF4D4D4D);

  static const Color background = Color(0xFFFDFAF9);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFFF5C8C);
  static const Color borderLight = Color(0xFFF3F3F3);
  static const Color borderDark = Color(0xFFDADADA);

  // Shimmer & Overlay
  static const Color shimmerBase = Color(0xFFF9F9F9);
  static const Color shimmerHighlight = Color(0xFFFFFFFF);
}
