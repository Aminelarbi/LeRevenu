import 'package:flutter/foundation.dart' hide Category;
import 'author.dart';
import 'category.dart';

/// Immutable model representing an article.
@immutable
class Article {
  final String id;
  final String title;
  final String excerpt;
  final String imageUrl;
  final Category category;
  final Author author;
  final DateTime publishedAt;
  final int readTimeMinutes;
  final bool isFeatured;

  const Article({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.imageUrl,
    required this.category,
    required this.author,
    required this.publishedAt,
    required this.readTimeMinutes,
    required this.isFeatured,
  });

  Article copyWith({
    String? id,
    String? title,
    String? excerpt,
    String? imageUrl,
    Category? category,
    Author? author,
    DateTime? publishedAt,
    int? readTimeMinutes,
    bool? isFeatured,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      author: author ?? this.author,
      publishedAt: publishedAt ?? this.publishedAt,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          excerpt == other.excerpt &&
          imageUrl == other.imageUrl &&
          category == other.category &&
          author == other.author &&
          publishedAt == other.publishedAt &&
          readTimeMinutes == other.readTimeMinutes &&
          isFeatured == other.isFeatured;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      excerpt.hashCode ^
      imageUrl.hashCode ^
      category.hashCode ^
      author.hashCode ^
      publishedAt.hashCode ^
      readTimeMinutes.hashCode ^
      isFeatured.hashCode;

  @override
  String toString() =>
      'Article(id: $id, title: $title, category: ${category.label}, isFeatured: $isFeatured)';
}
