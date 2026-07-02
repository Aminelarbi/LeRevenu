import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/date_helper.dart';
import '../../data/models/article.dart';
import 'category_chip.dart';

/// Reusable horizontal list tile for article feeds.
/// Positions text metadata on the left and a Hero-tagged thumbnail on the right.
/// The [Hero] tag on the image enables a shared-element transition to
/// [ArticleDetailScreen] when this tile is tapped.
class ArticleListTile extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final int? views;

  const ArticleListTile({
    super.key,
    required this.article,
    required this.onTap,
    this.views,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.xs,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Text Info Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Category Badge
                    CategoryChip(
                      category: article.category,
                      isSelectable: false,
                    ),
                    AppSizes.spacingSm,

                    // Editorial Title (2 lines max)
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.editorialTitleMedium.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        height: 1.25,
                      ),
                    ),
                    AppSizes.spacingSm,

                    // Time & Reading Duration Metadata
                    Text(
                      '${article.publishedAt.toRelativeString()} • ${article.readTimeMinutes} min de lecture${views != null ? ' • ${_formatViews(views!)} vues' : ''}',
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.md),

              // 2. Hero-tagged Rounded Thumbnail
              Hero(
                tag: 'article_image_${article.id}',
                child: ClipRRect(
                  borderRadius: AppSizes.borderMd,
                  child: SizedBox(
                    width: AppSizes.articleTileImageSize,
                    height: AppSizes.articleTileImageSize,
                    child: Image.network(
                      article.imageUrl,
                      fit: BoxFit.cover,
                      cacheWidth: 184,
                      cacheHeight: 184,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBorder,
                          child: const Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 1.5,
                              ),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark
                            ? AppColors.darkBackground
                            : AppColors.lightBorder,
                        child: Icon(
                          Icons.image_not_supported,
                          color: isDark ? Colors.white24 : Colors.black26,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatViews(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}
