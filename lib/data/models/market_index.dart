import 'package:flutter/foundation.dart';

/// Immutable model representing a financial index/stock quote (e.g. CAC 40, EUR/USD).
@immutable
class MarketIndex {
  final String id;
  final String name;
  final double value;
  final double variationPercent;

  const MarketIndex({
    required this.id,
    required this.name,
    required this.value,
    required this.variationPercent,
  });

  /// Derived value: returns true if the change is flat or positive
  bool get isUp => variationPercent >= 0.0;

  MarketIndex copyWith({
    String? id,
    String? name,
    double? value,
    double? variationPercent,
  }) {
    return MarketIndex(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      variationPercent: variationPercent ?? this.variationPercent,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarketIndex &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          value == other.value &&
          variationPercent == other.variationPercent;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ value.hashCode ^ variationPercent.hashCode;

  @override
  String toString() =>
      'MarketIndex(id: $id, name: $name, value: $value, variationPercent: $variationPercent)';
}
