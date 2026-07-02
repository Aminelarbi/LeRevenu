import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/coming_soon_snackbar.dart';
import '../../../subscription/presentation/screens/subscription_screen.dart';

/// Profil tab screen representing user account info, mock subscription state,
/// settings stubs, and navigation entry to SubscriptionScreen.
class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.primaryNavy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── 1. User Header ───────────────────────────────────────────────
            Container(
              width: double.infinity,
              color: isDark ? AppColors.darkSurface : AppColors.primaryNavy,
              padding: const EdgeInsets.only(
                bottom: AppSizes.xl,
                left: AppSizes.lg,
                right: AppSizes.lg,
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=33',
                    ),
                    backgroundColor: Colors.white,
                  ),
                  AppSizes.spacingMd,
                  Text(
                    'Med Amine Larbi',
                    style: AppTypography.editorialHeadlineMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Membre depuis : Mars 2024',
                    style: AppTypography.uiBodySmall.copyWith(
                      color: Colors.white.withAlpha(178),
                    ),
                  ),
                ],
              ),
            ),

            // ── 2. Abonnement Section ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.brandRed.withAlpha(51)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 8,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'MON ABONNEMENT',
                            style: AppTypography.uiLabelLarge.copyWith(
                              color: AppColors.brandRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lossRed.withAlpha(15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Non abonné',
                              style: AppTypography.uiLabelMedium.copyWith(
                                color: AppColors.lossRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSizes.spacingMd,
                      Text(
                        'Accédez à toutes les analyses exclusives de nos experts boursiers et placements en illimité.',
                        style: AppTypography.uiBodyMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      AppSizes.spacingLg,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SubscriptionScreen(),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'S\'abonner aux formules',
                            style: AppTypography.uiTitleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── 3. Settings List ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      context,
                      Icons.notifications_none_rounded,
                      'Notifications',
                      'Gérer les alertes infos et bourse',
                      isDark,
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      context,
                      Icons.palette_outlined,
                      'Thème de l\'application',
                      'Automatique / Clair / Sombre',
                      isDark,
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      context,
                      Icons.help_outline_rounded,
                      'Aide & Contact',
                      'FAQ, support client et rédaction',
                      isDark,
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      context,
                      Icons.info_outline_rounded,
                      'Mentions légales',
                      'CGU, CGV et politique de confidentialité',
                      isDark,
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      context,
                      Icons.logout_rounded,
                      'Se déconnecter',
                      'Fermer la session actuelle',
                      isDark,
                      textColor: AppColors.lossRed,
                      iconColor: AppColors.lossRed,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool isDark, {
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? (isDark ? Colors.white70 : AppColors.primaryNavy),
      ),
      title: Text(
        title,
        style: AppTypography.uiTitleMedium.copyWith(
          color: textColor ?? (isDark ? Colors.white : AppColors.primaryNavy),
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.uiBodySmall.copyWith(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: () {
        showComingSoonSnackbar(context, featureName: title);
      },
    );
  }
}
