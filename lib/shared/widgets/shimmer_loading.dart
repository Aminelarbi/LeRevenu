import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';

/// Reusable Shimmer skeleton container for layout structure modeling.
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark ? const Color(0xFF1E293B) : Colors.grey.shade200;
    final highlightColor = isDark
        ? const Color(0xFF334155)
        : Colors.grey.shade50;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// Shimmer skeleton loader for [MarketTickerBar].
class MarketTickerShimmer extends StatelessWidget {
  const MarketTickerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.marketTickerHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.sm,
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkSurface
          : AppColors.primaryNavy,
      child: Row(
        children: List.generate(
          4,
          (index) => Padding(
            padding: const EdgeInsets.only(right: AppSizes.xl),
            child: Row(
              children: [
                ShimmerBox(
                  width: 60,
                  height: 16,
                  borderRadius: AppSizes.borderSm,
                ),
                AppSizes.spacingSm,
                ShimmerBox(
                  width: 40,
                  height: 14,
                  borderRadius: AppSizes.borderSm,
                ),
                AppSizes.spacingSm,
                ShimmerBox(
                  width: 30,
                  height: 14,
                  borderRadius: AppSizes.borderSm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer skeleton loader for [FeaturedArticleCard].
class FeaturedArticleShimmer extends StatelessWidget {
  const FeaturedArticleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.sm,
      ),
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: AppSizes.borderLg,
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
          ),
        ),
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShimmerBox(
                  width: 80,
                  height: 24,
                  borderRadius: AppSizes.borderRound,
                ),
                const Spacer(),
                ShimmerBox(
                  width: 100,
                  height: 14,
                  borderRadius: AppSizes.borderSm,
                ),
              ],
            ),
            AppSizes.spacingMd,
            ShimmerBox(
              width: double.infinity,
              height: 22,
              borderRadius: AppSizes.borderSm,
            ),
            AppSizes.spacingSm,
            ShimmerBox(width: 200, height: 22, borderRadius: AppSizes.borderSm),
            AppSizes.spacingMd,
            Row(
              children: [
                const ShimmerBox(
                  width: 20,
                  height: 20,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                AppSizes.spacingSm,
                ShimmerBox(
                  width: 120,
                  height: 14,
                  borderRadius: AppSizes.borderSm,
                ),
                AppSizes.spacingXs,
                ShimmerBox(
                  width: 60,
                  height: 14,
                  borderRadius: AppSizes.borderSm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer skeleton loader for [ArticleListTile].
class ArticleTileShimmer extends StatelessWidget {
  const ArticleTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.xs,
      ),
      child: Container(
        height: 124,
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: AppSizes.borderMd,
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
          ),
        ),
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: 70,
                    height: 20,
                    borderRadius: AppSizes.borderRound,
                  ),
                  AppSizes.spacingMd,
                  ShimmerBox(
                    width: double.infinity,
                    height: 16,
                    borderRadius: AppSizes.borderSm,
                  ),
                  AppSizes.spacingXs,
                  ShimmerBox(
                    width: 150,
                    height: 16,
                    borderRadius: AppSizes.borderSm,
                  ),
                  AppSizes.spacingMd,
                  ShimmerBox(
                    width: 180,
                    height: 12,
                    borderRadius: AppSizes.borderSm,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.md),
            ShimmerBox(
              width: AppSizes.articleTileImageSize,
              height: AppSizes.articleTileImageSize,
              borderRadius: AppSizes.borderMd,
            ),
          ],
        ),
      ),
    );
  }
}
