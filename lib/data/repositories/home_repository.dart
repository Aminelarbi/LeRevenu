import '../models/article.dart';
import '../models/category.dart';
import '../models/market_index.dart';

/// Abstract contract for home screen data.
/// Decouples the UI and State layer from the concrete data source (mock/API).
abstract class HomeRepository {
  /// Fetches a list of all articles, optionally filtered by a specific category.
  Future<List<Article>> getArticles({String? categoryId});

  /// Fetches the featured articles ("À la une").
  Future<List<Article>> getFeaturedArticles();

  /// Fetches the available editorial categories.
  Future<List<Category>> getCategories();

  /// Fetches the latest stock/market indices.
  Future<List<MarketIndex>> getMarketIndices();
}
