import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'shared/widgets/widget_gallery_screen.dart';

void main() {
  runApp(
    // ProviderScope is required for all Riverpod providers to work.
    const ProviderScope(child: LeRevenuApp()),
  );
}

/// Root application widget.
/// Applies the [AppTheme] design system and hands off to [ThemeMode.system]
/// so the OS dark/light preference is honoured automatically.
class LeRevenuApp extends StatelessWidget {
  const LeRevenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LeRevenu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Automatically follows the device's light/dark mode setting.
      themeMode: ThemeMode.system,
      // Toggle [kShowWidgetGallery] in widget_gallery_screen.dart during dev.
      home: kShowWidgetGallery
          ? const WidgetGalleryScreen()
          : const SplashScreen(),
    );
  }
}
