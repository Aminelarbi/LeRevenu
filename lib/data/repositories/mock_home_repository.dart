import '../mock/mock_data.dart';
import '../models/article.dart';
import '../models/category.dart';
import '../models/market_index.dart';
import 'home_repository.dart';

/// Concrete mock implementation of [HomeRepository].
/// Simulates network latency (400ms) to model real-world API requests.
class MockHomeRepository implements HomeRepository {
  final Duration _delay;

  const MockHomeRepository({Duration delay = const Duration(milliseconds: 400)})
    : _delay = delay;

  @override
  Future<List<Article>> getArticles({String? categoryId}) async {
    await Future.delayed(_delay);
    if (categoryId == null) {
      return List.unmodifiable(MockData.articles);
    }
    final filtered = MockData.articles
        .where(
          (article) =>
              article.category.id.toLowerCase() == categoryId.toLowerCase(),
        )
        .toList();
    return List.unmodifiable(filtered);
  }

  @override
  Future<List<Article>> getFeaturedArticles() async {
    await Future.delayed(_delay);
    final featured = MockData.articles
        .where((article) => article.isFeatured)
        .toList();
    return List.unmodifiable(featured);
  }

  @override
  Future<List<Category>> getCategories() async {
    await Future.delayed(_delay);
    return List.unmodifiable(MockData.categories);
  }

  @override
  Future<List<MarketIndex>> getMarketIndices() async {
    await Future.delayed(_delay);
    return List.unmodifiable(MockData.marketIndices);
  }
}
