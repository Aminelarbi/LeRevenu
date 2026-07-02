import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/mock/mock_data.dart';
import '../../../../data/models/article.dart';
import '../../../../shared/widgets/article_list_tile.dart';
import '../../../../shared/widgets/category_tab_bar.dart';
import '../../../../shared/widgets/fade_in_widget.dart';
import '../../../article_detail/presentation/screens/article_detail_screen.dart';

enum NewsSortFilter { plusRecent, plusLu }

/// Actualités tab screen presenting the full list of mock articles with
/// category filtering and "Plus récent" / "Plus lu" sorting.
class ActualitesScreen extends StatefulWidget {
  const ActualitesScreen({super.key});

  @override
  State<ActualitesScreen> createState() => _ActualitesScreenState();
}

class _ActualitesScreenState extends State<ActualitesScreen> {
  String? _selectedCategoryId;
  NewsSortFilter _sortFilter = NewsSortFilter.plusRecent;

  // Mock view counts for sorting by "Plus lu"
  static const Map<String, int> _mockViews = {
    'art1': 24500,
    'art2': 18900,
    'art3': 31200,
    'art4': 9300,
    'art5': 15100,
    'art6': 12400,
    'art7': 22800,
    'art8': 17400,
    'art9': 11300,
    'art10': 27400,
    'art11': 14200,
    'art12': 19500,
    'art13': 21000,
    'art14': 28600,
    'art15': 10500,
    'art16': 13900,
    'art17': 16700,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filter by Category
    List<Article> articles = MockData.articles;
    if (_selectedCategoryId != null && _selectedCategoryId != 'all') {
      articles = articles
          .where(
            (art) =>
                art.category.id.toLowerCase() ==
                _selectedCategoryId!.toLowerCase(),
          )
          .toList();
    } else {
      articles = List.from(articles);
    }

    // Sort Articles
    if (_sortFilter == NewsSortFilter.plusRecent) {
      articles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } else {
      articles.sort((a, b) {
        final viewsA = _mockViews[a.id] ?? 0;
        final viewsB = _mockViews[b.id] ?? 0;
        return viewsB.compareTo(viewsA);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualités'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.primaryNavy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Category Tab Bar ───────────────────────────────────────────────
          const SizedBox(height: AppSizes.sm),
          CategoryTabBar(
            categories: MockData.categories,
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: (id) {
              setState(() {
                _selectedCategoryId = id;
              });
            },
          ),
          const SizedBox(height: AppSizes.sm),

          // ── Sorting Row ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${articles.length} articles disponibles',
                  style: AppTypography.uiBodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    _buildSortButton(
                      'Plus récents',
                      NewsSortFilter.plusRecent,
                      isDark,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    _buildSortButton('Plus lus', NewsSortFilter.plusLu, isDark),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: Divider(),
          ),

          // ── Article Feed ───────────────────────────────────────────────────
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: articles.isEmpty
                  ? _buildEmptyState(isDark)
                  : ListView.builder(
                      key: ValueKey('${_selectedCategoryId}_$_sortFilter'),
                      physics: const BouncingScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        final views = _mockViews[article.id] ?? 0;
                        return FadeInWidget(
                          duration: Duration(
                            milliseconds: 200 + (index * 30).clamp(0, 300),
                          ),
                          child: ArticleListTile(
                            article: article,
                            views: _sortFilter == NewsSortFilter.plusLu
                                ? views
                                : null,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ArticleDetailScreen(article: article),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(String label, NewsSortFilter filter, bool isDark) {
    final isActive = _sortFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _sortFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.brandRed
              : (isDark ? AppColors.darkSurface : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.brandRed
                : (isDark ? AppColors.darkBorder : Colors.transparent),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.uiLabelMedium.copyWith(
            color: isActive
                ? Colors.white
                : (isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary),
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.newspaper_rounded,
            size: 48,
            color: isDark
                ? AppColors.darkBorder
                : AppColors.lightTextSecondary.withAlpha(127),
          ),
          AppSizes.spacingMd,
          Text(
            'Aucun article disponible.',
            style: AppTypography.uiBodyMedium.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
