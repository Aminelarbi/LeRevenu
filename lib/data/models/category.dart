import 'package:flutter/material.dart';

/// Immutable model representing an article category (e.g. Bourse, Immobilier).
@immutable
class Category {
  final String id;
  final String label;
  final String
  colorHex; // Hex string representation of the color (e.g. '0xFF0D2240')
  final IconData? icon;

  const Category({
    required this.id,
    required this.label,
    required this.colorHex,
    this.icon,
  });

  /// Resolves the colorHex string into a Flutter [Color] object.
  Color get color {
    try {
      return Color(int.parse(colorHex));
    } catch (_) {
      return Colors.blueGrey; // Safe fallback
    }
  }

  Category copyWith({
    String? id,
    String? label,
    String? colorHex,
    IconData? icon,
  }) {
    return Category(
      id: id ?? this.id,
      label: label ?? this.label,
      colorHex: colorHex ?? this.colorHex,
      icon: icon ?? this.icon,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          colorHex == other.colorHex &&
          icon == other.icon;

  @override
  int get hashCode =>
      id.hashCode ^ label.hashCode ^ colorHex.hashCode ^ icon.hashCode;

  @override
  String toString() => 'Category(id: $id, label: $label, colorHex: $colorHex)';
}
