import 'package:flutter/foundation.dart';

/// Immutable model representing an article author.
@immutable
class Author {
  final String id;
  final String name;
  final String? avatarUrl;

  const Author({required this.id, required this.name, this.avatarUrl});

  Author copyWith({String? id, String? name, String? avatarUrl}) {
    return Author(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Author &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          avatarUrl == other.avatarUrl;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ avatarUrl.hashCode;

  @override
  String toString() => 'Author(id: $id, name: $name, avatarUrl: $avatarUrl)';
}
