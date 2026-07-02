import 'package:flutter_test/flutter_test.dart';
import 'package:lerevenu/data/repositories/mock_home_repository.dart';

void main() {
  group('MockHomeRepository Tests', () {
    // Inject zero delay for fast-running tests
    const repository = MockHomeRepository(delay: Duration.zero);

    test('getCategories returns the 5 default categories', () async {
      final categories = await repository.getCategories();
      expect(categories.length, 5);
      expect(categories.first.label, 'Bourse');
      expect(categories[1].label, 'Immobilier');
      expect(categories[2].label, 'Placements');
    });

    test('getMarketIndices returns non-empty list containing CAC 40', () async {
      final indices = await repository.getMarketIndices();
      expect(indices.isNotEmpty, true);
      expect(indices.first.name, 'CAC 40');
      expect(indices.first.variationPercent, 1.24);
    });

    test('getArticles filters correctly by category', () async {
      final bourseArticles = await repository.getArticles(categoryId: 'bourse');
      expect(bourseArticles.isNotEmpty, true);
      expect(bourseArticles.every((art) => art.category.id == 'bourse'), true);

      final immoArticles = await repository.getArticles(
        categoryId: 'immobilier',
      );
      expect(immoArticles.isNotEmpty, true);
      expect(
        immoArticles.every((art) => art.category.id == 'immobilier'),
        true,
      );
    });

    test('getFeaturedArticles returns only featured articles', () async {
      final featured = await repository.getFeaturedArticles();
      expect(featured.isNotEmpty, true);
      expect(featured.every((art) => art.isFeatured), true);
    });
  });
}
