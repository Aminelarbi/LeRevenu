import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/market_index.dart';

class BourseAppBar extends StatelessWidget {
  final bool isDark;
  final MarketIndex cac40;
  final VoidCallback onSubscriptionTap;

  const BourseAppBar({
    super.key,
    required this.isDark,
    required this.cac40,
    required this.onSubscriptionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 200.0,
      collapsedHeight: kToolbarHeight,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.primaryNavy,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.workspace_premium_rounded,
            color: AppColors.brandRed,
          ),
          tooltip: 'Abonnements',
          onPressed: onSubscriptionTap,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1.0,
        titlePadding: const EdgeInsetsDirectional.only(
          start: AppSizes.lg,
          bottom: AppSizes.sm,
        ),
        title: Text(
          'Bourse',
          style: AppTypography.uiTitleLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        background: _BourseAppBarBackground(isDark: isDark, cac40: cac40),
      ),
    );
  }
}

class _BourseAppBarBackground extends StatelessWidget {
  final bool isDark;
  final MarketIndex cac40;

  const _BourseAppBarBackground({required this.isDark, required this.cac40});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: AppSizes.lg,
        right: AppSizes.lg,
        bottom: AppSizes.xl,
        top: AppSizes.xl * 2.5,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isDark ? AppColors.darkSurface : AppColors.primaryNavy,
            isDark ? AppColors.darkSurface : AppColors.primaryNavy.withAlpha(220),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRINCIPAL INDICE',
            style: AppTypography.uiLabelMedium.copyWith(
              color: Colors.white.withAlpha(150),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                'CAC 40',
                style: AppTypography.uiTitleLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                '${cac40.value.toStringAsFixed(2)} pts',
                style: AppTypography.uiBodyLarge.copyWith(
                  color: Colors.white.withAlpha(230),
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Icon(
                cac40.isUp ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                color: cac40.isUp ? AppColors.gainGreen : AppColors.lossRed,
                size: 24,
              ),
              Text(
                '${cac40.variationPercent >= 0 ? '+' : ''}${cac40.variationPercent.toStringAsFixed(2)}%',
                style: AppTypography.uiBodyMedium.copyWith(
                  color: cac40.isUp ? AppColors.gainGreen : AppColors.lossRed,
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [ui.FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}