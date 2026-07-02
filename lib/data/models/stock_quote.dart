import 'package:flutter/foundation.dart';

/// Type of financial instrument shown in the Bourse screen list.
enum QuoteType { indexQuote, stock, crypto }

/// Immutable model representing a specific stock/crypto/index quote.
@immutable
class StockQuote {
  final String name;
  final String ticker;
  final double price;
  final double variationPercent;
  final String volume;
  final QuoteType type;

  /// Fake historical sparkline points (last 7 data points, relative values).
  final List<double> sparklinePoints;

  const StockQuote({
    required this.name,
    required this.ticker,
    required this.price,
    required this.variationPercent,
    required this.volume,
    this.type = QuoteType.stock,
    this.sparklinePoints = const [
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
    ],
  });

  bool get isUp => variationPercent >= 0.0;

  String get currencySymbol =>
      type == QuoteType.crypto ? '\$' : '€';

  StockQuote copyWith({
    String? name,
    String? ticker,
    double? price,
    double? variationPercent,
    String? volume,
    QuoteType? type,
    List<double>? sparklinePoints,
  }) {
    return StockQuote(
      name: name ?? this.name,
      ticker: ticker ?? this.ticker,
      price: price ?? this.price,
      variationPercent: variationPercent ?? this.variationPercent,
      volume: volume ?? this.volume,
      type: type ?? this.type,
      sparklinePoints: sparklinePoints ?? this.sparklinePoints,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockQuote &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          ticker == other.ticker &&
          price == other.price &&
          variationPercent == other.variationPercent &&
          volume == other.volume &&
          type == other.type;

  @override
  int get hashCode =>
      name.hashCode ^
      ticker.hashCode ^
      price.hashCode ^
      variationPercent.hashCode ^
      volume.hashCode ^
      type.hashCode;

  @override
  String toString() =>
      'StockQuote(name: $name, ticker: $ticker, price: $price, '
      'variationPercent: $variationPercent, volume: $volume, type: $type)';
}
