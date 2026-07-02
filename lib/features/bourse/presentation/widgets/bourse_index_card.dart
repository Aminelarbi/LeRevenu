import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/market_index.dart';

class BourseIndexCard extends StatelessWidget {
  final MarketIndex marketIndex;
  final bool isDark;

  const BourseIndexCard({super.key, required this.marketIndex, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = marketIndex.isUp ? AppColors.gainGreen : AppColors.lossRed;
    final icon = marketIndex.isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded;

    return Container(
      width: 135,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            marketIndex.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.uiTitleMedium.copyWith(
              color: isDark ? Colors.white : AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            marketIndex.value < 10
                ? marketIndex.value.toStringAsFixed(4)
                : marketIndex.value.toStringAsFixed(2),
            style: AppTypography.uiBodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              AppSizes.spacingXs,
              Text(
                '${marketIndex.variationPercent >= 0 ? '+' : ''}${marketIndex.variationPercent.toStringAsFixed(2)}%',
                style: AppTypography.uiBodySmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}