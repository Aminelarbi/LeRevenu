import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/mock/mock_data.dart';
import '../../../../shared/widgets/article_list_tile.dart';
import '../../../../shared/widgets/coming_soon_snackbar.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../article_detail/presentation/screens/article_detail_screen.dart';

/// Placements tab screen containing a mock calculator card, thematic guides slider,
/// and placements articles list.
class PlacementsScreen extends StatelessWidget {
  const PlacementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filter placement articles
    final placementArticles = MockData.articles
        .where((art) => art.category.id.toLowerCase() == 'placements')
        .toList();

    // Thematic guides mock data
    final guides = [
      _ThematicGuide(
        title: 'Guide Assurance-Vie 2026',
        subtitle: 'Optimisez votre fiscalité et vos rendements',
        icon: Icons.shield_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
        ),
      ),
      _ThematicGuide(
        title: 'Guide PEA',
        subtitle: 'Les meilleures actions de rendement à y loger',
        icon: Icons.trending_up_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF1F1C2C), Color(0xFF928DAB)],
        ),
      ),
      _ThematicGuide(
        title: 'Guide Immobilier Locatif',
        subtitle: 'Pinel, LMNP, SCI : faites les bons choix',
        icon: Icons.apartment_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF3E5151), Color(0xFFDECBA4)],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Placements'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.primaryNavy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Simulateur Teaser Card ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.brandRed.withAlpha(25),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.calculate_rounded,
                              color: AppColors.brandRed,
                              size: 24,
                            ),
                          ),
                          AppSizes.spacingSm,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SIMULATEUR RAPIDE',
                                  style: AppTypography.uiLabelLarge.copyWith(
                                    color: AppColors.brandRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Estimez vos gains de placement',
                                  style: AppTypography.uiTitleLarge.copyWith(
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.primaryNavy,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AppSizes.spacingLg,

                      // Mock sliders / input UI elements
                      _buildMockInputRow('Capital initial', '10 000 €', isDark),
                      const SizedBox(height: AppSizes.md),
                      _buildMockInputRow(
                        'Versements mensuels',
                        '150 €',
                        isDark,
                      ),
                      const SizedBox(height: AppSizes.md),
                      _buildMockInputRow(
                        'Durée du placement',
                        '10 ans',
                        isDark,
                      ),
                      AppSizes.spacingLg,

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            showComingSoonSnackbar(
                              context,
                              featureName: 'Le simulateur de placements',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? AppColors.darkBorder
                                : AppColors.primaryNavy,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Simuler mes placements'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── 2. Thematic Guides Slider ────────────────────────────────────
            const SectionHeader(title: 'Nos guides thématiques'),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                itemCount: guides.length,
                separatorBuilder: (_, __) => AppSizes.spacingSm,
                itemBuilder: (context, index) {
                  final guide = guides[index];
                  return _buildGuideCard(context, guide, isDark);
                },
              ),
            ),
            AppSizes.spacingMd,

            // ── 3. Recommendations List ──────────────────────────────────────
            const SectionHeader(title: 'Nos recommandations placements'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: placementArticles.length,
              itemBuilder: (context, index) {
                final article = placementArticles[index];
                return ArticleListTile(
                  article: article,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ArticleDetailScreen(article: article),
                    ),
                  ),
                );
              },
            ),

            // Bottom padding
            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildMockInputRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.uiBodyMedium.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBackground : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
            ),
          ),
          child: Text(
            value,
            style: AppTypography.uiTitleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.primaryNavy,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuideCard(
    BuildContext context,
    _ThematicGuide guide,
    bool isDark,
  ) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        gradient: guide.gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showComingSoonSnackbar(
              context,
              featureName: 'Le guide ${guide.title}',
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(guide.icon, color: Colors.white, size: 24),
                    const Icon(
                      Icons.download_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guide.title,
                      style: AppTypography.uiTitleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      guide.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.uiBodySmall.copyWith(
                        color: Colors.white70,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThematicGuide {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;

  const _ThematicGuide({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}
