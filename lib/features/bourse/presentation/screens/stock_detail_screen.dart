import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/mock/mock_data.dart';
import '../../../../data/models/article.dart';
import '../../../../data/models/stock_quote.dart';
import '../../../../shared/widgets/coming_soon_snackbar.dart';
import '../widgets/stock_detail_chart_section.dart';
import '../widgets/stock_detail_header.dart';
import '../widgets/stock_detail_related_news_section.dart';
import '../widgets/stock_detail_stats_grid.dart';

class StockDetailScreen extends StatefulWidget {
  final StockQuote quote;

  const StockDetailScreen({super.key, required this.quote});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  StockChartPeriod _period = StockChartPeriod.oneDay;

  List<Article> get _relatedArticles => MockData.articles
      .where((article) => article.category.id.toLowerCase() == 'bourse')
      .take(4)
      .toList();

  List<double> _buildSeries(String ticker, StockChartPeriod period) {
    final seed = _seedFor('$ticker-${period.name}');
    final random = Random(seed);
    final points = switch (period) {
      StockChartPeriod.oneDay => 24,
      StockChartPeriod.oneWeek => 14,
      StockChartPeriod.oneMonth => 22,
      StockChartPeriod.oneYear => 30,
    };

    final start = widget.quote.price * (0.96 + random.nextDouble() * 0.08);
    final drift = widget.quote.variationPercent >= 0 ? 0.55 : -0.45;
    final series = <double>[];
    var current = start;
    for (var i = 0; i < points; i++) {
      final seasonal = sin(i / max(points - 1, 1) * pi * 2) * widget.quote.price * 0.008;
      current += drift + seasonal + (random.nextDouble() - 0.5) * widget.quote.price * 0.015;
      series.add(max(0.1, current));
    }
    return series;
  }

  int _seedFor(String value) => value.codeUnits.fold(17, (hash, codeUnit) => 37 * hash + codeUnit);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final trendColor = widget.quote.isUp ? AppColors.gainGreen : AppColors.lossRed;
    final series = _buildSeries(widget.quote.ticker, _period);
    final previousClose = widget.quote.price / (1 + (widget.quote.variationPercent / 100));
    final absoluteChange = widget.quote.price - previousClose;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          widget.quote.ticker,
          style: AppTypography.editorialTitleLarge.copyWith(color: Colors.white),
        ),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.primaryNavy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.lg),
        children: [
          StockDetailHeader(
            quote: widget.quote,
            previousClose: previousClose,
            absoluteChange: absoluteChange,
            trendColor: trendColor,
            isDark: isDark,
          ),
          const SizedBox(height: AppSizes.md),
          StockDetailChartSection(
            series: series,
            period: _period,
            color: trendColor,
            isDark: isDark,
            onPeriodSelected: (period) => setState(() => _period = period),
          ),
          const SizedBox(height: AppSizes.md),
          StockDetailStatsGrid(
            isDark: isDark,
            quote: widget.quote,
            series: series,
            previousClose: previousClose,
          ),
          const SizedBox(height: AppSizes.md),
          StockDetailRelatedNewsSection(articles: _relatedArticles),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => showComingSoonSnackbar(
                context,
                featureName: 'Le suivi de cette valeur',
              ),
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Suivre cette valeur'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          Text(
            '⚠ Données indicatives uniquement. Il ne s\'agit pas de conseils d\'investissement.',
            textAlign: TextAlign.center,
            style: AppTypography.uiBodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}