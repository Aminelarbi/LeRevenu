import 'package:flutter/foundation.dart';

/// Immutable model representing a subscription plan offering.
@immutable
class SubscriptionPlan {
  final String id;
  final String title;
  final double price;
  final String? pricePerIssue;
  final String description;
  final List<String> features;
  final bool isPopular;
  final String? badge;

  const SubscriptionPlan({
    required this.id,
    required this.title,
    required this.price,
    this.pricePerIssue,
    required this.description,
    required this.features,
    this.isPopular = false,
    this.badge,
  });

  SubscriptionPlan copyWith({
    String? id,
    String? title,
    double? price,
    String? pricePerIssue,
    String? description,
    List<String>? features,
    bool? isPopular,
    String? badge,
  }) {
    return SubscriptionPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      pricePerIssue: pricePerIssue ?? this.pricePerIssue,
      description: description ?? this.description,
      features: features ?? this.features,
      isPopular: isPopular ?? this.isPopular,
      badge: badge ?? this.badge,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionPlan &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          price == other.price &&
          pricePerIssue == other.pricePerIssue &&
          description == other.description &&
          listEquals(features, other.features) &&
          isPopular == other.isPopular &&
          badge == other.badge;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      price.hashCode ^
      pricePerIssue.hashCode ^
      description.hashCode ^
      features.hashCode ^
      isPopular.hashCode ^
      badge.hashCode;

  @override
  String toString() =>
      'SubscriptionPlan(id: $id, title: $title, price: $price, pricePerIssue: $pricePerIssue, description: $description, features: $features, isPopular: $isPopular, badge: $badge)';
}
