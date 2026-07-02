import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/article_detail/presentation/screens/article_detail_screen.dart';
import '../../../../data/models/article.dart';
import '../../../../shared/widgets/article_list_tile.dart';

class StockDetailRelatedNewsSection extends StatelessWidget {
  final List<Article> articles;

  const StockDetailRelatedNewsSection({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: AppSizes.borderXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actualités liées',
            style: AppTypography.uiTitleMedium.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.primaryNavy,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          ...articles.map(
            (article) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: ArticleListTile(
                article: article,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ArticleDetailScreen(article: article),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}