import 'package:flutter/material.dart';

/// Design system color palette for Le Revenu app.
/// Aligned with the official editorial identity: brand red, structural navy, near-white background,
/// and distinct semantic colors for market indicators and categories.
abstract class AppColors {
  // Brand Colors
  static const Color brandRed = Color(
    0xFFC8102E,
  ); // Le Revenu brand red for logo, indicators, primary CTAs
  static const Color primaryNavy = Color(
    0xFF14213D,
  ); // Structural navy/dark grey for headlines and high contrast

  // Semantic Colors
  static const Color gainGreen = Color(
    0xFF1E8E3E,
  ); // Emerald/editorial green for stock gains
  static const Color lossRed = Color(
    0xFFD0021B,
  ); // Brand-aligned red for stock losses

  // Category Colors
  static const Color catBourse = Color(0xFF1A365D); // Deep blue
  static const Color catImmobilier = Color(0xFFA24823); // Warm terracotta/brown
  static const Color catPlacements = Color(0xFFC59B27); // Gold/amber
  static const Color catFiscalite = Color(0xFF5C6B73); // Slate grey
  static const Color catAssurance = Color(0xFF008080); // Teal

  // Light Theme Neutrals
  static const Color lightBackground = Color(0xFFF7F7F8); // Near-white
  static const Color lightSurface = Color(
    0xFFFFFFFF,
  ); // Pure white for cards/tiles
  static const Color lightTextPrimary = Color(
    0xFF14213D,
  ); // Structural navy for high legibility
  static const Color lightTextSecondary = Color(0xFF5C6B73); // Muted slate-grey
  static const Color lightBorder = Color(0xFFEEEEEE); // Light grey border

  // Dark Theme Neutrals
  static const Color darkBackground = Color(0xFF0F172A); // Deep slate-grey
  static const Color darkSurface = Color(0xFF1E293B); // Dark slate card surface
  static const Color darkBorder = Color(0xFF334155); // Dark slate border
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Off-white text
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Muted grey text
}
