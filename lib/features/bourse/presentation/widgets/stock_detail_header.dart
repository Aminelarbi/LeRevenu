import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/stock_quote.dart';

class StockDetailHeader extends StatelessWidget {
  final StockQuote quote;
  final double previousClose;
  final double absoluteChange;
  final Color trendColor;
  final bool isDark;

  const StockDetailHeader({
    super.key,
    required this.quote,
    required this.previousClose,
    required this.absoluteChange,
    required this.trendColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final signedAbsolute = absoluteChange >= 0 ? '+${absoluteChange.toStringAsFixed(2)}' : absoluteChange.toStringAsFixed(2);

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
            quote.name,
            style: AppTypography.editorialHeadlineMedium.copyWith(
              color: isDark ? Colors.white : AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            quote.ticker,
            style: AppTypography.uiLabelLarge.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                quote.type == QuoteType.crypto && quote.price < 1
                    ? quote.price.toStringAsFixed(4)
                    : quote.price.toStringAsFixed(2),
                style: AppTypography.editorialHeadlineLarge.copyWith(
                  color: isDark ? Colors.white : AppColors.primaryNavy,
                  fontSize: 40,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  quote.currencySymbol,
                  style: AppTypography.uiTitleLarge.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Icon(
                quote.isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                color: trendColor,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                '${quote.variationPercent >= 0 ? '+' : ''}${quote.variationPercent.toStringAsFixed(2)}%',
                style: AppTypography.uiTitleMedium.copyWith(
                  color: trendColor,
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                '($signedAbsolute)',
                style: AppTypography.uiBodyMedium.copyWith(
                  color: trendColor,
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Mis à jour il y a 4 min',
            style: AppTypography.uiBodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}