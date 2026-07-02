import 'package:flutter/foundation.dart' hide Category;
import '../../../../data/models/article.dart';
import '../../../../data/models/category.dart';
import '../../../../data/models/market_index.dart';

/// Immutable state container for the HomeScreen.
@immutable
class HomeState {
  final bool isLoading;
  final bool isRefreshing;
  final List<Article> allArticles;
  final List<Article> filteredArticles;
  final List<Article> featuredArticles;
  final List<Category> categories;
  final List<MarketIndex> marketIndices;
  final String? selectedCategoryId;
  final String? errorMessage;

  const HomeState({
    required this.isLoading,
    required this.isRefreshing,
    required this.allArticles,
    required this.filteredArticles,
    required this.featuredArticles,
    required this.categories,
    required this.marketIndices,
    this.selectedCategoryId,
    this.errorMessage,
  });

  /// Factory for initial blank state when screen is first mounted.
  factory HomeState.initial() {
    return const HomeState(
      isLoading: true,
      isRefreshing: false,
      allArticles: [],
      filteredArticles: [],
      featuredArticles: [],
      categories: [],
      marketIndices: [],
      selectedCategoryId: null,
      errorMessage: null,
    );
  }

  HomeState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    List<Article>? allArticles,
    List<Article>? filteredArticles,
    List<Article>? featuredArticles,
    List<Category>? categories,
    List<MarketIndex>? marketIndices,
    ValueGetter<String?>?
    selectedCategoryId, // Use ValueGetter to allow resetting to null
    ValueGetter<String?>? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      allArticles: allArticles ?? this.allArticles,
      filteredArticles: filteredArticles ?? this.filteredArticles,
      featuredArticles: featuredArticles ?? this.featuredArticles,
      categories: categories ?? this.categories,
      marketIndices: marketIndices ?? this.marketIndices,
      selectedCategoryId: selectedCategoryId != null
          ? selectedCategoryId()
          : this.selectedCategoryId,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'HomeState(isLoading: $isLoading, allArticles: ${allArticles.length}, filtered: ${filteredArticles.length}, featured: ${featuredArticles.length}, selectedCategory: $selectedCategoryId)';
  }
}
