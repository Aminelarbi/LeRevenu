import 'package:flutter/material.dart';

/// Design system layout spacing and size constants.
abstract class AppSizes {
  // Padding & Margin (Spacing)
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  // Spacing helper widgets (Saves memory if used as const)
  static const SizedBox spacingXs = SizedBox(width: xs, height: xs);
  static const SizedBox spacingSm = SizedBox(width: sm, height: sm);
  static const SizedBox spacingMd = SizedBox(width: md, height: md);
  static const SizedBox spacingLg = SizedBox(width: lg, height: lg);
  static const SizedBox spacingXl = SizedBox(width: xl, height: xl);
  static const SizedBox spacingXxl = SizedBox(width: xxl, height: xxl);

  // Border Radius
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusRound = 999.0;

  static BorderRadius get borderSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderMd => BorderRadius.circular(radiusMd);
  static BorderRadius get borderLg => BorderRadius.circular(radiusLg);
  static BorderRadius get borderXl => BorderRadius.circular(radiusXl);
  static BorderRadius get borderRound => BorderRadius.circular(radiusRound);

  // Widget specific dimensions
  static const double marketTickerHeight = 56.0;
  static const double bottomNavBarHeight = 64.0;
  static const double categoryBarHeight = 44.0;
  static const double featuredImageHeight = 200.0;
  static const double articleTileImageSize = 92.0;
}
