import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/stock_quote.dart';
import 'stock_detail_stat_tile.dart';

class StockDetailStatsGrid extends StatelessWidget {
  final bool isDark;
  final StockQuote quote;
  final List<double> series;
  final double previousClose;

  const StockDetailStatsGrid({
    super.key,
    required this.isDark,
    required this.quote,
    required this.series,
    required this.previousClose,
  });

  @override
  Widget build(BuildContext context) {
    final min = series.reduce((a, b) => a < b ? a : b);
    final max = series.reduce((a, b) => a > b ? a : b);
    final open = series.first;
    final high = max;
    final low = min;
    final cap = _marketCapFor(quote.price);

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppSizes.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques clés',
            style: AppTypography.uiTitleMedium.copyWith(
              color: isDark ? Colors.white : AppColors.primaryNavy,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.9,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSizes.sm,
            mainAxisSpacing: AppSizes.sm,
            children: [
              StockDetailStatTile(label: 'Ouverture', value: open.toStringAsFixed(2), isDark: isDark),
              StockDetailStatTile(label: 'Clôture précédente', value: previousClose.toStringAsFixed(2), isDark: isDark),
              StockDetailStatTile(label: 'Plus haut du jour', value: high.toStringAsFixed(2), isDark: isDark),
              StockDetailStatTile(label: 'Plus bas du jour', value: low.toStringAsFixed(2), isDark: isDark),
              StockDetailStatTile(label: 'Volume', value: quote.volume, isDark: isDark),
              StockDetailStatTile(label: 'Capitalisation', value: cap, isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }

  String _marketCapFor(double price) {
    final value = price * 12000000;
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)} Md€';
    }
    return '${(value / 1000000).toStringAsFixed(0)} M€';
  }
}