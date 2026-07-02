import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design system typography tokens for Le Revenu app.
/// Pairs:
/// - 'Playfair Display' (Serif) for headlines, titles, and editorial branding to convey prestige.
/// - 'Inter' (Sans-Serif) for clean, functional UI text, labels, and numeric figures.
abstract class AppTypography {
  // Editorial Headline Fonts (Playfair Display)
  static TextStyle get editorialHeadlineLarge => GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.25,
  );

  static TextStyle get editorialHeadlineMedium => GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    height: 1.25,
  );

  static TextStyle get editorialTitleLarge => GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.25,
  );

  static TextStyle get editorialTitleMedium => GoogleFonts.playfairDisplay(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // UI / System Fonts (Inter)
  static TextStyle get uiTitleLarge =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, height: 1.2);

  static TextStyle get uiTitleMedium =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, height: 1.2);

  static TextStyle get uiBodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get uiBodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.45,
  );

  static TextStyle get uiBodySmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  static TextStyle get uiLabelLarge => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle get uiLabelMedium => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Market Specific (Numeric & Clean)
  static TextStyle get marketTickerText =>
      GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold);

  static TextStyle get marketTickerSubtext =>
      GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500);
}
