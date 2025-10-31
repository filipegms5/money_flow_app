import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: AppColors.light.primary,
    scaffoldBackgroundColor: AppColors.light.background,
    cardColor: AppColors.light.cardBackground,
    colorScheme: ColorScheme.light(
      primary: AppColors.light.primary,
      secondary: AppColors.light.secondary,
      surface: AppColors.light.surface,
      error: AppColors.light.error,
      onPrimary: AppColors.light.buttonPrimaryText,
      onSecondary: AppColors.light.buttonSecondaryText,
      onSurface: AppColors.light.textPrimary,
      onError: AppColors.light.buttonDangerText,
      background: AppColors.light.background,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.light.textPrimary),
      bodyMedium: TextStyle(color: AppColors.light.textPrimary),
      bodySmall: TextStyle(color: AppColors.light.textSecondary),
      titleLarge: TextStyle(color: AppColors.light.textPrimary, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: AppColors.light.textPrimary, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(color: AppColors.light.textPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.light.cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.light.divider,
      thickness: 1,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    primaryColor: AppColors.dark.primary,
    scaffoldBackgroundColor: AppColors.dark.background,
    cardColor: AppColors.dark.cardBackground,
    colorScheme: ColorScheme.dark(
      primary: AppColors.dark.primary,
      secondary: AppColors.dark.secondary,
      surface: AppColors.dark.surface,
      error: AppColors.dark.error,
      onPrimary: AppColors.dark.buttonPrimaryText,
      onSecondary: AppColors.dark.buttonSecondaryText,
      onSurface: AppColors.dark.textPrimary,
      onError: AppColors.dark.buttonDangerText,
      background: AppColors.dark.background,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.dark.textPrimary),
      bodyMedium: TextStyle(color: AppColors.dark.textPrimary),
      bodySmall: TextStyle(color: AppColors.dark.textSecondary),
      titleLarge: TextStyle(color: AppColors.dark.textPrimary, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: AppColors.dark.textPrimary, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(color: AppColors.dark.textPrimary),
    ),
    cardTheme: CardThemeData(
      color: AppColors.dark.cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.dark.divider,
      thickness: 1,
    ),
  );

  static AppColors getColors(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;
  }
}

