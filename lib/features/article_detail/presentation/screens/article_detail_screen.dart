import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/date_helper.dart';
import '../../../../data/models/article.dart';
import '../../../../shared/widgets/category_chip.dart';

/// Full-page article detail screen with a collapsing Hero-image header.
/// The [Hero] tag on the image must match the tag in [FeaturedArticleCard]
/// and [ArticleListTile] so the shared-element transition is fluid.
class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── 1. Collapsing Hero-image header ──────────────────────────────
          SliverAppBar(
            expandedHeight: 280.0,
            pinned: true,
            backgroundColor: isDark
                ? AppColors.darkSurface
                : AppColors.primaryNavy,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Shared-element Hero image
                  Hero(
                    tag: 'article_image_${article.id}',
                    child: Image.network(
                      article.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.primaryNavy,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white54,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  // Gradient so the back arrow stays legible on bright images
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black38, Colors.transparent],
                        stops: [0.0, 0.4],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 2. Article body ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge & read time
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
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                          AppSizes.spacingXs,
                          Text(
                            '${article.readTimeMinutes} min de lecture',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  AppSizes.spacingLg,

                  // Headline (Lora Serif from theme)
                  Text(article.title, style: theme.textTheme.headlineLarge),
                  AppSizes.spacingMd,

                  // Author row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (article.author.avatarUrl != null) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                            article.author.avatarUrl!,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        AppSizes.spacingSm,
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.author.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              article.publishedAt.toRelativeString(),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSizes.spacingLg,
                  const Divider(),
                  AppSizes.spacingLg,

                  // Excerpt with category-coloured left border
                  Container(
                    padding: const EdgeInsets.only(left: AppSizes.md),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: article.category.color,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Text(
                      article.excerpt,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        height: 1.55,
                      ),
                    ),
                  ),
                  AppSizes.spacingXl,

                  // Body paragraphs (financial journalism tone)
                  Text(
                    "Face aux incertitudes économiques mondiales et à la réorientation "
                    "stratégique des grands investisseurs institutionnels, l'évolution "
                    "récente des marchés invite à une vigilance accrue. Les experts "
                    "s'accordent à dire que l'équilibre entre actifs risqués et "
                    "placements de rendement doit être réévalué.",
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.65),
                  ),
                  AppSizes.spacingLg,
                  Text(
                    "Dans ce contexte, les choix d'allocation patrimoniale requièrent "
                    "une étude minutieuse des indicateurs macroéconomiques. Les ménages "
                    "français, historiquement prudents, manifestent un intérêt renouvelé "
                    "pour des supports garantissant à la fois sécurité et liquidité, "
                    "tout en explorant avec parcimonie des opportunités de croissance "
                    "sur les marchés secondaires.",
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.65),
                  ),
                  AppSizes.spacingLg,
                  Text(
                    "Ce dossier spécial, élaboré par la rédaction de Le Revenu, rassemble "
                    "les analyses conjoncturelles détaillées, les avis d'experts financiers "
                    "et nos conseils pratiques de gestion pour vous guider au mieux dans "
                    "l'optimisation fiscale et le développement de votre épargne.",
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.65),
                  ),
                  AppSizes.spacingXxl,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
