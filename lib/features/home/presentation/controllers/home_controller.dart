import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/home_repository.dart';
import '../../../../data/models/article.dart';
import '../../../../data/models/category.dart';
import '../../../../data/models/market_index.dart';
import 'home_state.dart';

/// State controller managing data flow for the Home Screen.
/// Performs parallel async fetches on load/refresh and in-memory filtering for categories.
class HomeController extends StateNotifier<HomeState> {
  final HomeRepository _repository;

  HomeController(this._repository) : super(HomeState.initial()) {
    loadHomeData();
  }

  /// Fetches initial homepage data from repository.
  /// Uses parallel executing Futures via [Future.wait].
  Future<void> loadHomeData({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(isRefreshing: true);
    } else {
      state = state.copyWith(isLoading: true, errorMessage: () => null);
    }

    try {
      // Execute all repository fetches in parallel
      final results = await Future.wait([
        _repository.getCategories(),
        _repository.getMarketIndices(),
        _repository.getFeaturedArticles(),
        _repository.getArticles(),
      ]);

      var categories = results[0] as List<dynamic>;
      var marketIndices = results[1] as List<MarketIndex>;
      var featuredArticles = results[2] as List<dynamic>;
      var articles = results[3] as List<dynamic>;

      // Cast lists to correct model types
      final categoriesList = categories.cast<Category>();
      var indicesList = marketIndices.cast<MarketIndex>();
      final featuredList = featuredArticles.cast<Article>();
      var articlesList = articles.cast<Article>();

      // Polish: Simulate live market fluctuations and article shuffles on Pull-to-Refresh
      if (isRefresh) {
        indicesList = _simulateMarketFluctuations(indicesList);
        articlesList = List<Article>.from(articlesList)..shuffle(Random());
      }

      // Re-apply filter if a category was already selected
      final selectedId = state.selectedCategoryId;
      final filteredList = selectedId == null || selectedId == 'all'
          ? articlesList
          : articlesList.where((art) => art.category.id == selectedId).toList();

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        categories: categoriesList,
        marketIndices: indicesList,
        featuredArticles: featuredList,
        allArticles: articlesList,
        filteredArticles: filteredList,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: () =>
            'Erreur lors du chargement des données. Veuillez réessayer.',
      );
    }
  }

  /// Filters articles list in-memory based on selected category ID.
  void selectCategory(String? categoryId) {
    final cleanId = (categoryId == 'all') ? null : categoryId;

    final filtered = cleanId == null
        ? state.allArticles
        : state.allArticles.where((art) => art.category.id == cleanId).toList();

    state = state.copyWith(
      selectedCategoryId: () => cleanId,
      filteredArticles: filtered,
    );
  }

  /// Helper to generate slightly modified stock variations on Pull-to-Refresh
  List<MarketIndex> _simulateMarketFluctuations(
    List<MarketIndex> currentIndices,
  ) {
    final random = Random();
    return currentIndices.map((index) {
      // Vary percentage by +/- 0.3%
      final change = (random.nextDouble() * 0.6) - 0.3;
      final newVariation = index.variationPercent + change;

      // Vary index total value accordingly
      final valueMultiplier = 1.0 + (change / 100.0);
      final newValue = index.value * valueMultiplier;

      return index.copyWith(value: newValue, variationPercent: newVariation);
    }).toList();
  }
}
