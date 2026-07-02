import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// App-wide theme configuration (Light & Dark modes) matching Le Revenu's visual identity.
abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.brandRed,
      colorScheme: const ColorScheme.light(
        primary: AppColors.brandRed,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFF8DDE1),
        onPrimaryContainer: AppColors.primaryNavy,
        secondary: AppColors.primaryNavy,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFDDE5F2),
        onSecondaryContainer: AppColors.primaryNavy,
        tertiary: AppColors.catPlacements,
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xFFF3E7BD),
        onTertiaryContainer: AppColors.primaryNavy,
        error: AppColors.lossRed,
        onError: Colors.white,
        errorContainer: Color(0xFFF8D7DC),
        onErrorContainer: Color(0xFF5E0B16),
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        surfaceContainerHighest: Color(0xFFE8ECEF),
        onSurfaceVariant: AppColors.lightTextSecondary,
        outline: AppColors.lightBorder,
        outlineVariant: Color(0xFFE2E6EA),
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: AppColors.darkSurface,
        onInverseSurface: AppColors.darkTextPrimary,
        inversePrimary: AppColors.brandRed,
        surfaceTint: AppColors.brandRed,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryNavy,
        contentTextStyle: AppTypography.uiBodyMedium.copyWith(
          color: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.primaryNavy,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.editorialTitleLarge.copyWith(
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 1,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTypography.editorialHeadlineLarge.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        headlineMedium: AppTypography.editorialHeadlineMedium.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        titleLarge: AppTypography.editorialTitleLarge.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        titleMedium: AppTypography.editorialTitleMedium.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        bodyLarge: AppTypography.uiBodyLarge.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        bodyMedium: AppTypography.uiBodyMedium.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        bodySmall: AppTypography.uiBodySmall.copyWith(
          color: AppColors.lightTextSecondary,
        ),
        labelLarge: AppTypography.uiLabelLarge.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        labelMedium: AppTypography.uiLabelMedium.copyWith(
          color: AppColors.lightTextSecondary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.brandRed.withAlpha(
          26,
        ), // Very subtle red active pill tint
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.uiLabelMedium.copyWith(
              color: AppColors.brandRed,
              fontWeight: FontWeight.bold,
            );
          }
          return AppTypography.uiLabelMedium.copyWith(
            color: AppColors.lightTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.brandRed);
          }
          return const IconThemeData(color: AppColors.lightTextSecondary);
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.brandRed,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.brandRed,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFF7E1224),
        onPrimaryContainer: Color(0xFFFFD9DD),
        secondary: AppColors.primaryNavy,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFF2A3856),
        onSecondaryContainer: Color(0xFFE0E7FF),
        tertiary: AppColors.catPlacements,
        onTertiary: Colors.white,
        tertiaryContainer: Color(0xFF6B5310),
        onTertiaryContainer: Color(0xFFFFE9B5),
        error: AppColors.lossRed,
        onError: Colors.white,
        errorContainer: Color(0xFF7A1221),
        onErrorContainer: Color(0xFFFFDADC),
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        surfaceContainerHighest: AppColors.darkBorder,
        onSurfaceVariant: AppColors.darkTextSecondary,
        outline: AppColors.darkBorder,
        outlineVariant: Color(0xFF475569),
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: AppColors.lightSurface,
        onInverseSurface: AppColors.lightTextPrimary,
        inversePrimary: AppColors.brandRed,
        surfaceTint: AppColors.brandRed,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryNavy,
        contentTextStyle: AppTypography.uiBodyMedium.copyWith(
          color: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.editorialTitleLarge.copyWith(
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
      textTheme: TextTheme(
        headlineLarge: AppTypography.editorialHeadlineLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        headlineMedium: AppTypography.editorialHeadlineMedium.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        titleLarge: AppTypography.editorialTitleLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        titleMedium: AppTypography.editorialTitleMedium.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        bodyLarge: AppTypography.uiBodyLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        bodyMedium: AppTypography.uiBodyMedium.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        bodySmall: AppTypography.uiBodySmall.copyWith(
          color: AppColors.darkTextSecondary,
        ),
        labelLarge: AppTypography.uiLabelLarge.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        labelMedium: AppTypography.uiLabelMedium.copyWith(
          color: AppColors.darkTextSecondary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        indicatorColor: AppColors.brandRed.withAlpha(51),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.uiLabelMedium.copyWith(
              color: AppColors.brandRed,
              fontWeight: FontWeight.bold,
            );
          }
          return AppTypography.uiLabelMedium.copyWith(
            color: AppColors.darkTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.brandRed);
          }
          return const IconThemeData(color: AppColors.darkTextSecondary);
        }),
      ),
    );
  }
}
