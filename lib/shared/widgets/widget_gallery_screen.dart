import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';
import '../../data/mock/mock_data.dart';
import 'app_bottom_nav_bar.dart';
import 'article_list_tile.dart';
import 'category_tab_bar.dart';
import 'featured_article_card.dart';
import 'market_ticker_bar.dart';
import 'section_header.dart';
import 'shimmer_loading.dart';

/// Set to [true] during development to route to the widget gallery instead of
/// the real [HomeScreen]. Must be [false] for production / submission builds.
const bool kShowWidgetGallery = false;

/// A interactive widget gallery used to inspect and verify the visual styling,
/// layouts, and micro-interactions of the custom widgets in both Light and Dark modes.
class WidgetGalleryScreen extends StatefulWidget {
  const WidgetGalleryScreen({super.key});

  @override
  State<WidgetGalleryScreen> createState() => _WidgetGalleryScreenState();
}

class _WidgetGalleryScreenState extends State<WidgetGalleryScreen> {
  String? _selectedCategoryId;
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Get a sample featured article
    final featuredArticle = MockData.articles.firstWhere(
      (art) => art.isFeatured,
    );
    // Get a sample standard article
    final standardArticle = MockData.articles.firstWhere(
      (art) => !art.isFeatured,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Gallery (Le Revenu)'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              // Informative notification (in real usage it updates system settings)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isDark
                        ? 'Bascule vers le mode Clair...'
                        : 'Bascule vers le mode Sombre...',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Market Ticker Bar
            const SectionHeader(title: '1. Market Ticker Bar (Indices)'),
            MarketTickerBar(indices: MockData.marketIndices),
            AppSizes.spacingLg,

            // 2. Section Header
            const SectionHeader(title: '2. Section Header'),
            SectionHeader(
              title: 'Section Titre',
              actionLabel: 'Voir tout',
              onActionTap: () {
                _showSnackBar(context, 'Tapped Voir tout');
              },
            ),
            AppSizes.spacingLg,

            // 3. Featured Article Card
            const SectionHeader(title: '3. Featured Article Card'),
            FeaturedArticleCard(
              article: featuredArticle,
              onTap: () {
                _showSnackBar(
                  context,
                  'Tapped Featured Article: "${featuredArticle.title}"',
                );
              },
            ),
            AppSizes.spacingLg,

            // 4. Category Tab Bar
            const SectionHeader(title: '4. Category Tab Bar (Interactive)'),
            CategoryTabBar(
              categories: MockData.categories,
              selectedCategoryId: _selectedCategoryId,
              onCategorySelected: (id) {
                setState(() {
                  _selectedCategoryId = id;
                });
                _showSnackBar(context, 'Selected category: ${id ?? "Toutes"}');
              },
            ),
            AppSizes.spacingLg,

            // 5. Article List Tile
            const SectionHeader(title: '5. Article List Tile'),
            ArticleListTile(
              article: standardArticle,
              onTap: () {
                _showSnackBar(
                  context,
                  'Tapped Article: "${standardArticle.title}"',
                );
              },
            ),
            AppSizes.spacingLg,

            // 6. Shimmer Loading States
            const SectionHeader(title: '6. Shimmer Skeletons (Loading States)'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
              child: Text(
                'Ticker Shimmer:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            AppSizes.spacingSm,
            const MarketTickerShimmer(),
            AppSizes.spacingMd,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
              child: Text(
                'Featured Card Shimmer:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const FeaturedArticleShimmer(),
            AppSizes.spacingMd,
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.lg),
              child: Text(
                'List Tile Shimmer:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const ArticleTileShimmer(),
            AppSizes.spacingXxl,

            // 7. App Bottom Nav Bar inline display
            const SectionHeader(title: '7. Bottom Navigation Bar'),
            Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: AppSizes.borderMd,
                ),
                clipBehavior: Clip.antiAlias,
                child: AppBottomNavBar(
                  currentIndex: _navIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _navIndex = index;
                    });
                    _showSnackBar(context, 'Tab $index selected');
                  },
                ),
              ),
            ),
            AppSizes.spacingXxl,
          ],
        ),
      ),
      // Set the active navigation bar at bottom of page as well to demo full page docking
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _navIndex,
        onDestinationSelected: (index) {
          setState(() {
            _navIndex = index;
          });
          _showSnackBar(context, 'Docked bottom bar tab $index selected');
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }
}
