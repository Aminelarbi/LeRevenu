import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../data/mock/mock_data.dart';
import '../../../../data/models/market_index.dart';
import '../../../../data/models/stock_quote.dart';
import '../../../../shared/widgets/article_list_tile.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../article_detail/presentation/screens/article_detail_screen.dart';
import '../../../subscription/presentation/screens/subscription_screen.dart';
import 'stock_detail_screen.dart';
import '../widgets/bourse_app_bar.dart';
import '../widgets/bourse_index_card.dart';
import '../widgets/bourse_promo_card.dart';
import '../widgets/bourse_segment_sort_row.dart';
import '../widgets/bourse_stock_row.dart';

/// Bourse section tab screen with a collapsing app bar, segmented dataset
/// controls, market cards, stock rows, and related news.
class BourseScreen extends StatefulWidget {
  const BourseScreen({super.key});

  @override
  State<BourseScreen> createState() => _BourseScreenState();
}

class _BourseScreenState extends State<BourseScreen> {
  int _segmentIndex = 1;
  BourseSortMode _sortMode = BourseSortMode.name;

  List<StockQuote> get _activeList {
    final raw = switch (_segmentIndex) {
      0 => MockData.indexQuotes,
      1 => MockData.stockQuotes,
      2 => MockData.cryptoQuotes,
      _ => MockData.stockQuotes,
    };
    final sorted = List<StockQuote>.from(raw);
    switch (_sortMode) {
      case BourseSortMode.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case BourseSortMode.gainers:
        sorted.sort((a, b) => b.variationPercent.compareTo(a.variationPercent));
      case BourseSortMode.losers:
        sorted.sort((a, b) => a.variationPercent.compareTo(b.variationPercent));
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bourseArticles = MockData.articles
        .where((article) => article.category.id.toLowerCase() == 'bourse')
        .toList();

    final cac40 = MockData.marketIndices.firstWhere(
      (index) => index.name == 'CAC 40',
      orElse: () => const MarketIndex(
        id: 'cac40',
        name: 'CAC 40',
        value: 7842.15,
        variationPercent: 1.24,
      ),
    );

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          BourseAppBar(
            isDark: isDark,
            cac40: cac40,
            onSubscriptionTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
            ),
          ),
          BourseSegmentSortRow(
            isDark: isDark,
            segmentIndex: _segmentIndex,
            sortMode: _sortMode,
            onSegmentChanged: (index) => setState(() => _segmentIndex = index),
            onSortModeChanged: (mode) => setState(() => _sortMode = mode),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Indices à suivre'),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                    itemCount: MockData.marketIndices.length,
                    separatorBuilder: (_, __) => AppSizes.spacingSm,
                    itemBuilder: (context, index) {
                      return BourseIndexCard(
                        marketIndex: MockData.marketIndices[index],
                        isDark: isDark,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: switch (_segmentIndex) {
                0 => 'Principaux indices',
                1 => 'Valeurs du jour (CAC 40)',
                2 => 'Cryptomonnaies',
                _ => 'Valeurs du jour',
              },
            ),
          ),
          SliverList.builder(
            itemCount: _activeList.length,
            itemBuilder: (context, index) {
              return BourseStockRow(
                quote: _activeList[index],
                isDark: isDark,
                onTap: () => _openDetail(context, _activeList[index]),
              );
            },
          ),
          SliverToBoxAdapter(child: BoursePromoCard(isDark: isDark)),
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'Analyses & actualités boursières'),
          ),
          SliverList.builder(
            itemCount: bourseArticles.length,
            itemBuilder: (context, index) {
              final article = bourseArticles[index];
              return ArticleListTile(
                article: article,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ArticleDetailScreen(article: article),
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xl)),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, StockQuote quote) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StockDetailScreen(quote: quote),
      ),
    );
  }
}
