import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/article.dart';
import '../../../../data/models/category.dart';
import '../../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../../shared/widgets/article_list_tile.dart';
import '../../../../shared/widgets/category_tab_bar.dart';
import '../../../../shared/widgets/coming_soon_snackbar.dart';
import '../../../../shared/widgets/fade_in_widget.dart';

import '../../../../shared/widgets/featured_carousel.dart';
import '../../../../shared/widgets/market_ticker_bar.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../article_detail/presentation/screens/article_detail_screen.dart';
import '../../../bourse/presentation/screens/bourse_screen.dart';
import '../../../actualites/presentation/screens/actualites_screen.dart';
import '../../../placements/presentation/screens/placements_screen.dart';
import '../../../profil/presentation/screens/profil_screen.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../../../subscription/presentation/screens/subscription_screen.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_state.dart';
import '../providers/home_providers.dart';

/// Main screen of the application.
/// Uses [CustomScrollView] with slivers for GPU-friendly, lazy scroll performance.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentNavIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentNavIndex = index),
      ),
      body: _buildBody(context, state, controller, isDark),
    );
  }

  /// Returns the appropriate body depending on the active nav tab.
  Widget _buildBody(
    BuildContext context,
    HomeState state,
    HomeController controller,
    bool isDark,
  ) {
    switch (_currentNavIndex) {
      case 0:
        return _buildHomeFeed(context, state, controller, isDark);
      case 1:
        return const BourseScreen();
      case 2:
        return const ActualitesScreen();
      case 3:
        return const PlacementsScreen();
      case 4:
        return const ProfilScreen();
      default:
        return _buildHomeFeed(context, state, controller, isDark);
    }
  }

  Widget _buildHomeFeed(
    BuildContext context,
    HomeState state,
    HomeController controller,
    bool isDark,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        // Capture the messenger before the async gap to satisfy
        // the use_build_context_synchronously lint rule.
        final messenger = ScaffoldMessenger.of(context);
        await controller.loadHomeData(isRefresh: true);
        if (mounted) {
          messenger.clearSnackBars();
          messenger.showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.gainGreen,
                    size: 18,
                  ),
                  SizedBox(width: AppSizes.sm),
                  Text('Contenu mis à jour'),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      color: AppColors.brandRed,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // 1. Floating SliverAppBar — snaps back into view on scroll-up
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: true,
            expandedHeight: 56.0,
            elevation: 0,
            backgroundColor: isDark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
            foregroundColor: isDark ? Colors.white : AppColors.primaryNavy,
            title: Image.asset(
              'assets/logo.jpg',
              height: 32,
              fit: BoxFit.contain,
            ),
            actions: [
              // Search button
              IconButton(
                icon: const Icon(Icons.search_rounded),
                tooltip: 'Rechercher',
                onPressed: () => _openSearch(context, state),
              ),
              // Premium shortcut — brand red to distinguish it visually
              IconButton(
                icon: const Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.brandRed,
                ),
                tooltip: 'Abonnements',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const SubscriptionScreen(),
                  ),
                ),
              ),
              // Notifications
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                tooltip: 'Notifications',
                onPressed: () => _showComingSoon(context, 'Les notifications'),
              ),
            ],
          ),

          // 2. Market Ticker Strip — shimmer while loading
          SliverToBoxAdapter(
            child: state.isLoading && !state.isRefreshing
                ? const MarketTickerShimmer()
                : MarketTickerBar(indices: state.marketIndices),
          ),

          // 3–6: Main content area — shimmer / error / populated
          if (state.isLoading && !state.isRefreshing) ...[
            const SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: 'À la une'),
                  FeaturedArticleShimmer(),
                  AppSizes.spacingMd,
                  SectionHeader(title: "Toute l'actualité"),
                ],
              ),
            ),
            SliverList.builder(
              itemCount: 3,
              itemBuilder: (_, __) => const ArticleTileShimmer(),
            ),
          ] else if (state.errorMessage != null) ...[
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.lossRed,
                        size: 48,
                      ),
                      AppSizes.spacingMd,
                      Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: AppTypography.uiBodyMedium,
                      ),
                      AppSizes.spacingLg,
                      ElevatedButton(
                        onPressed: () => controller.loadHomeData(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryNavy,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            // 3. Featured "À la une" section — hidden when a category is active
            if (state.featuredArticles.isNotEmpty &&
                state.selectedCategoryId == null) ...[
              const SliverToBoxAdapter(child: SectionHeader(title: 'À la une')),
              SliverToBoxAdapter(
                child: FeaturedCarousel(
                  articles: state.featuredArticles,
                  onArticleTap: (article) =>
                      _openArticleDetail(context, article),
                ),
              ),
              const SliverToBoxAdapter(child: AppSizes.spacingMd),
            ],

            // Special subscription banner CTA
            if (state.selectedCategoryId == null) ...[
              SliverToBoxAdapter(
                child: _buildHomeSubscriptionBanner(context, isDark),
              ),
              const SliverToBoxAdapter(child: AppSizes.spacingMd),
            ],

            // 4. Category selector strip
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: CategoryTabBar(
                  categories: state.categories,
                  selectedCategoryId: state.selectedCategoryId,
                  onCategorySelected: (id) => controller.selectCategory(id),
                ),
              ),
            ),

            // 5. Feed section header — label reflects active category
            SliverToBoxAdapter(
              child: SectionHeader(title: _getFeedSectionTitle(state)),
            ),

            // 6. Article feed — AnimatedSwitcher handles fade when category changes
            SliverToBoxAdapter(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                // Key changes when category changes, triggering the animation
                child: state.filteredArticles.isEmpty
                    ? _buildEmptyState(
                        isDark,
                        key: ValueKey(
                          'empty_${state.selectedCategoryId ?? "all"}',
                        ),
                      )
                    : _buildArticleFeed(
                        context,
                        state,
                        key: ValueKey(state.selectedCategoryId ?? 'all'),
                      ),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xl)),
          ],
        ],
      ),
    );
  }

  /// Builds the article list column inside [AnimatedSwitcher].
  /// Uses a [Column] here because [AnimatedSwitcher] needs a single widget;
  /// the outer [SliverToBoxAdapter] already handles the sliver boundary.
  Widget _buildArticleFeed(
    BuildContext context,
    HomeState state, {
    required Key key,
  }) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < state.filteredArticles.length; i++)
          FadeInWidget(
            // Stagger each tile by 40ms for a cascade entrance effect
            duration: Duration(milliseconds: 250 + (i * 40).clamp(0, 400)),
            child: ArticleListTile(
              key: ValueKey('feed_${state.filteredArticles[i].id}'),
              article: state.filteredArticles[i],
              onTap: () =>
                  _openArticleDetail(context, state.filteredArticles[i]),
            ),
          ),
      ],
    );
  }

  /// Empty state shown when no articles match the selected category.
  Widget _buildEmptyState(bool isDark, {required Key key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.xxl,
        horizontal: AppSizes.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.newspaper,
            size: 48,
            color: isDark
                ? AppColors.darkBorder
                : AppColors.lightTextSecondary.withAlpha(127),
          ),
          AppSizes.spacingMd,
          Text(
            'Aucun article disponible\npour cette rubrique.',
            textAlign: TextAlign.center,
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

  /// Resolves the feed section title based on selected category.
  String _getFeedSectionTitle(HomeState state) {
    if (state.selectedCategoryId == null) return "Toute l'actualité";
    final activeCategory = state.categories.firstWhere(
      (cat) => cat.id == state.selectedCategoryId,
      orElse: () => const Category(id: '', label: '', colorHex: ''),
    );
    return activeCategory.label.isNotEmpty
        ? activeCategory.label
        : "Dernières actus";
  }

  /// Navigates to [ArticleDetailScreen] with a custom slide+fade transition.
  void _openArticleDetail(BuildContext context, Article article) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 280),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ArticleDetailScreen(article: article),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideAnimation =
              Tween<Offset>(
                begin: const Offset(0.0, 0.06),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slideAnimation, child: child),
          );
        },
      ),
    );
  }

  /// Opens the live [SearchScreen] with the current article + category lists.
  void _openSearch(BuildContext context, HomeState state) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, _) => SearchScreen(
          allArticles: state.allArticles,
          categories: state.categories,
        ),
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  /// Shows a "coming soon" snackbar for unimplemented features.
  void _showComingSoon(BuildContext context, String featureName) {
    showComingSoonSnackbar(context, featureName: featureName);
  }

  /// Special subscription banner shown in Home feed
  Widget _buildHomeSubscriptionBanner(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.brandRed.withAlpha(51), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md + 2),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.brandRed.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.card_membership_rounded,
                  color: AppColors.brandRed,
                  size: 24,
                ),
              ),
              AppSizes.spacingSm,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OFFRE SPÉCIALE',
                      style: AppTypography.uiLabelMedium.copyWith(
                        color: AppColors.brandRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Accédez à toutes les analyses en illimité',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.uiTitleMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.primaryNavy,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              AppSizes.spacingSm,
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Offres',
                  style: AppTypography.uiLabelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
