import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  final Color primary;
  final Color secondary;
  
  // Background colors
  final Color background;
  final Color surface;
  final Color cardBackground;
  
  // Semantic colors
  final Color success;
  final Color error;
  final Color warning;
  
  // Text colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  
  // Icon colors
  final Color iconPrimary;
  final Color iconSecondary;
  
  // Button colors
  final Color buttonPrimary;
  final Color buttonPrimaryText;
  final Color buttonSecondary;
  final Color buttonSecondaryText;
  final Color buttonDanger;
  final Color buttonDangerText;
  
  // Shadow colors
  final Color shadowColor;
  
  // Special colors
  final Color divider;
  final Color glassOverlay;
  final Color chartBackground;
  
  const AppColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.cardBackground,
    required this.success,
    required this.error,
    required this.warning,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.buttonPrimary,
    required this.buttonPrimaryText,
    required this.buttonSecondary,
    required this.buttonSecondaryText,
    required this.buttonDanger,
    required this.buttonDangerText,
    required this.shadowColor,
    required this.divider,
    required this.glassOverlay,
    required this.chartBackground,
  });

  // Light theme colors
  static const AppColors light = AppColors(
    primary: Color(0xFF2196F3), // blue
    secondary: Color(0xFF757575), // grey
    background: Color(0xFFF5F5F5),
    surface: Color(0xFFFFFFFF),
    cardBackground: Color(0xFFFFFFFF),
    success: Color(0xFF4CAF50), // green
    error: Color(0xFFF44336), // red
    warning: Color(0xFFFF9800), // orange
    textPrimary: Color(0xFF212121),
    textSecondary: Color(0xFF757575),
    textTertiary: Color(0xFF9E9E9E),
    iconPrimary: Color(0xFF2196F3), // blue
    iconSecondary: Color(0xFF757575),
    buttonPrimary: Color(0xFF2196F3),
    buttonPrimaryText: Color(0xFFFFFFFF),
    buttonSecondary: Color(0xFF757575),
    buttonSecondaryText: Color(0xFFFFFFFF),
    buttonDanger: Color(0xFFF44336),
    buttonDangerText: Color(0xFFFFFFFF),
    shadowColor: Color(0x33000000), // black with ~20% opacity
    divider: Color(0xFFE0E0E0),
    glassOverlay: Color(0x1AFFFFFF), // white with ~10% opacity
    chartBackground: Color(0xFFFFFFFF),
  );

  // Dark theme colors
  static const AppColors dark = AppColors(
    primary: Color(0xFF64B5F6), // light blue
    secondary: Color(0xFF9E9E9E), // light grey
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    cardBackground: Color(0xFF2D2D2D),
    success: Color(0xFF81C784), // light green
    error: Color(0xFFE57373), // light red
    warning: Color(0xFFFFB74D), // light orange
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFB0B0B0),
    textTertiary: Color(0xFF757575),
    iconPrimary: Color(0xFF64B5F6), // light blue
    iconSecondary: Color(0xFF9E9E9E),
    buttonPrimary: Color(0xFF64B5F6),
    buttonPrimaryText: Color(0xFF121212),
    buttonSecondary: Color(0xFF616161),
    buttonSecondaryText: Color(0xFFFFFFFF),
    buttonDanger: Color(0xFFE57373),
    buttonDangerText: Color(0xFF121212),
    shadowColor: Color(0x66000000), // black with ~40% opacity
    divider: Color(0xFF424242),
    glassOverlay: Color(0x1A000000), // black with ~10% opacity
    chartBackground: Color(0xFF2D2D2D),
  );
}

