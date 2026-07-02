import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/date_helper.dart';
import '../../data/models/article.dart';
import 'category_chip.dart';

/// Large cinematic hero card to showcase a featured ("À la une") article.
/// Features a dark gradient overlay over the image for high legibility.
/// Incorporates a signature red "À LA UNE" tag in the top-left corner.
class FeaturedArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const FeaturedArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.sm,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppSizes.borderLg),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 280,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero-tagged image for fluid shared-element transition
              Hero(
                tag: 'article_image_${article.id}',
                child: Image.network(
                  article.imageUrl,
                  fit: BoxFit.cover,
                  cacheWidth: 800,
                  cacheHeight: 500,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: theme.brightness == Brightness.dark
                          ? AppColors.darkSurface
                          : AppColors.lightBorder,
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.primaryNavy,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                      size: 48,
                    ),
                  ),
                ),
              ),

              // Strengthened Gradient Overlay for premium text legibility
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54, Colors.black],
                    stops: [0.0, 0.35, 1.0],
                  ),
                ),
              ),

              // Signature red "À LA UNE" badge
              Positioned(
                top: AppSizes.md,
                left: AppSizes.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm + 2,
                    vertical: AppSizes.xs + 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brandRed,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'À LA UNE',
                    style: AppTypography.uiLabelMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              // Article Metadata Content
              Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Read Time Row
                    Row(
                      children: [
                        CategoryChip(
                          category: article.category,
                          isSelectable: false,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.white70,
                            ),
                            AppSizes.spacingXs,
                            Text(
                              '${article.readTimeMinutes} min de lecture',
                              style: AppTypography.uiLabelMedium.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    AppSizes.spacingSm,

                    // Headline
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.editorialHeadlineMedium.copyWith(
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    AppSizes.spacingSm,

                    // Author & Date Row
                    Row(
                      children: [
                        if (article.author.avatarUrl != null) ...[
                          CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(
                              article.author.avatarUrl!,
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          AppSizes.spacingSm,
                        ],
                        Flexible(
                          child: Text(
                            article.author.name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.uiLabelMedium.copyWith(
                              color: Colors.white.withAlpha(230),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          ' • ${article.publishedAt.toRelativeString()}',
                          style: AppTypography.uiLabelMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
