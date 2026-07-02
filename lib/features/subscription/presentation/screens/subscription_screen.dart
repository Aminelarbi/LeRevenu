import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/mock/mock_data.dart';
import '../../../../data/models/subscription_plan.dart';

/// Subscription page with monthly/annual billing toggle, polished plan cards,
/// FAQ accordion, and a scrollable layout using ListView (no nested scrollables).
class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  bool _isAnnual = true;
  late final AnimationController _popularController;
  late final Animation<double> _popularAnimation;

  @override
  void initState() {
    super.initState();
    _popularController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _popularAnimation = CurvedAnimation(
      parent: _popularController,
      curve: Curves.easeOutBack,
    );
    // Animate the popular card in on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _popularController.forward();
    });
  }

  @override
  void dispose() {
    _popularController.dispose();
    super.dispose();
  }

  double _displayPrice(SubscriptionPlan plan) {
    if (_isAnnual) return plan.price;
    // Monthly = annual / 12, rounded to nearest integer
    return (plan.price / 12).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Abonnements'),
        backgroundColor:
            isDark ? AppColors.darkSurface : AppColors.primaryNavy,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // ── Header ───────────────────────────────────────────────────────
          _buildHeader(isDark),

          // ── Trust Strip ──────────────────────────────────────────────────
          _buildTrustStrip(isDark),

          // ── Monthly / Annual Toggle ───────────────────────────────────────
          _buildBillingToggle(isDark),

          // ── Plan Cards ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.sm,
            ),
            child: Column(
              children: [
                for (final plan in MockData.subscriptionPlans) ...[
                  if (plan.isPopular)
                    _buildPopularCard(context, plan, isDark)
                  else
                    _buildPlanCard(context, plan, isDark),
                  AppSizes.spacingMd,
                ],
              ],
            ),
          ),

          // ── FAQ ───────────────────────────────────────────────────────────
          _buildFaq(isDark),

          // ── Footer Reassurance ────────────────────────────────────────────
          _buildFooter(isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      color: isDark ? AppColors.darkSurface : AppColors.primaryNavy,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.xl,
      ),
      child: Column(
        children: [
          Text(
            'Abonnez-vous au Revenu',
            textAlign: TextAlign.center,
            style: AppTypography.editorialHeadlineMedium.copyWith(
              color: Colors.white,
            ),
          ),
          AppSizes.spacingSm,
          Text(
            "L'information fiable et indépendante depuis 1967",
            textAlign: TextAlign.center,
            style: AppTypography.uiBodyMedium.copyWith(
              color: Colors.white.withAlpha(204),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustStrip(bool isDark) {
    return Container(
      color: isDark
          ? AppColors.darkSurface.withAlpha(127)
          : Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TrustItem(
            icon: Icons.history_edu_rounded,
            boldText: '55 ans',
            normalText: "d'expertise",
            isDark: isDark,
          ),
          _TrustItem(
            icon: Icons.people_rounded,
            boldText: '500k+',
            normalText: 'lecteurs',
            isDark: isDark,
          ),
          _TrustItem(
            icon: Icons.verified_user_rounded,
            boldText: '100%',
            normalText: 'indépendant',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildBillingToggle(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.lg,
        AppSizes.xl,
        AppSizes.lg,
        AppSizes.sm,
      ),
      child: Column(
        children: [
          // Animated pill toggle
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBorder.withAlpha(80)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                _ToggleSegment(
                  label: 'Mensuel',
                  isActive: !_isAnnual,
                  isDark: isDark,
                  onTap: () => setState(() => _isAnnual = false),
                ),
                _ToggleSegment(
                  label: 'Annuel',
                  isActive: _isAnnual,
                  isDark: isDark,
                  onTap: () => setState(() => _isAnnual = true),
                  badge: '–17%',
                ),
              ],
            ),
          ),
          if (!_isAnnual) ...[
            AppSizes.spacingSm,
            Text(
              'Facturé mensuellement — sans engagement',
              style: AppTypography.uiBodySmall.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ] else ...[
            AppSizes.spacingSm,
            Text(
              'Facturé en une fois annuellement',
              style: AppTypography.uiBodySmall.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPopularCard(
    BuildContext context,
    SubscriptionPlan plan,
    bool isDark,
  ) {
    return ScaleTransition(
      scale: _popularAnimation,
      child: FadeTransition(
        opacity: _popularController,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.brandRed, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandRed.withAlpha(35),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: _PlanCardContent(
            plan: plan,
            isDark: isDark,
            displayPrice: _displayPrice(plan),
            isAnnual: _isAnnual,
            onTap: () => _handlePaymentTap(context, plan.title),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    SubscriptionPlan plan,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _PlanCardContent(
        plan: plan,
        isDark: isDark,
        displayPrice: _displayPrice(plan),
        isAnnual: _isAnnual,
        onTap: () => _handlePaymentTap(context, plan.title),
      ),
    );
  }

  Widget _buildFaq(bool isDark) {
    const faqs = [
      (
        q: 'Puis-je résilier à tout moment ?',
        a:
            "Oui, vous pouvez résilier votre abonnement mensuel à tout moment depuis votre espace abonné, sans frais ni pénalités. Pour les abonnements annuels, la résiliation prend effet à l'échéance.",
      ),
      (
        q: 'Le paiement est-il sécurisé ?',
        a:
            "Tous les paiements sont traités via Stripe, certifié PCI-DSS niveau 1. Vos données bancaires ne sont jamais stockées sur nos serveurs. La transaction est chiffrée de bout en bout.",
      ),
      (
        q: 'Puis-je changer de formule plus tard ?',
        a:
            "Oui, vous pouvez évoluer vers une formule supérieure à tout moment. Le prorata sera calculé automatiquement. Pour passer à une formule inférieure, le changement prendra effet à la prochaine échéance.",
      ),
      (
        q: "L'accès digital est-il immédiat ?",
        a:
            "Oui, dès validation de votre paiement, votre accès numérique est activé instantanément. Pour les abonnements incluant la version papier, comptez 3 à 5 jours ouvrés pour la réception du premier numéro.",
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions fréquentes',
            style: AppTypography.editorialTitleLarge.copyWith(
              color: isDark ? Colors.white : AppColors.primaryNavy,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          for (final faq in faqs)
            _FaqTile(question: faq.q, answer: faq.a, isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSizes.xxl,
        left: AppSizes.lg,
        right: AppSizes.lg,
        top: AppSizes.md,
      ),
      child: Column(
        children: [
          const Divider(),
          AppSizes.spacingMd,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 16,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              AppSizes.spacingXs,
              Text(
                'Paiement 100% sécurisé',
                style: AppTypography.uiBodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(width: AppSizes.lg),
              Icon(
                Icons.sync_disabled_rounded,
                size: 16,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              AppSizes.spacingXs,
              Text(
                'Sans engagement long',
                style: AppTypography.uiBodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handlePaymentTap(BuildContext context, String planTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Option : $planTitle',
          style: AppTypography.editorialTitleLarge,
        ),
        content: Text(
          'Fonctionnalité de paiement non implémentée — test technique.',
          style: AppTypography.uiBodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Fermer',
              style: TextStyle(color: AppColors.brandRed),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _ToggleSegment extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;
  final String? badge;

  const _ToggleSegment({
    required this.label,
    required this.isActive,
    required this.isDark,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? AppColors.darkSurface : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(19),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: AppTypography.uiLabelLarge.copyWith(
                  color: isActive
                      ? (isDark ? Colors.white : AppColors.primaryNavy)
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  fontWeight:
                      isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gainGreen.withAlpha(isActive ? 40 : 30),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge!,
                    style: AppTypography.uiLabelMedium.copyWith(
                      color: AppColors.gainGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String boldText;
  final String normalText;
  final bool isDark;

  const _TrustItem({
    required this.icon,
    required this.boldText,
    required this.normalText,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.brandRed),
        AppSizes.spacingXs,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              boldText,
              style: AppTypography.uiTitleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.primaryNavy,
              ),
            ),
            Text(
              normalText,
              style: AppTypography.uiBodySmall.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlanCardContent extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isDark;
  final double displayPrice;
  final bool isAnnual;
  final VoidCallback onTap;

  const _PlanCardContent({
    required this.plan,
    required this.isDark,
    required this.displayPrice,
    required this.isAnnual,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Popular badge
        if (plan.isPopular && plan.badge != null)
          Container(
            decoration: const BoxDecoration(
              color: AppColors.brandRed,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  plan.badge!.toUpperCase(),
                  style: AppTypography.uiLabelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

        Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plan title
              Text(
                plan.title,
                style: AppTypography.editorialTitleLarge.copyWith(
                  color: isDark ? Colors.white : AppColors.primaryNavy,
                ),
              ),
              AppSizes.spacingSm,

              // Price Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${displayPrice.toStringAsFixed(0)}€',
                    style: AppTypography.editorialHeadlineLarge.copyWith(
                      color: isDark ? Colors.white : AppColors.primaryNavy,
                      fontSize: 36,
                    ),
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Text(
                    isAnnual ? '/ an' : '/ mois',
                    style: AppTypography.uiBodyMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),

              // Billing note
              AppSizes.spacingXs,
              Text(
                isAnnual
                    ? (plan.pricePerIssue ?? 'Facturé annuellement')
                    : 'Facturé annuellement (≈ ${plan.price.toStringAsFixed(0)}€/an)',
                style: AppTypography.uiBodySmall.copyWith(
                  color: AppColors.brandRed,
                  fontWeight: FontWeight.w600,
                ),
              ),

              AppSizes.spacingMd,
              // Description
              Text(
                plan.description,
                style: AppTypography.uiBodyMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSizes.md),
                child: Divider(),
              ),

              // Features bullet list
              for (final feature in plan.features) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.gainGreen,
                      size: 18,
                    ),
                    AppSizes.spacingSm,
                    Expanded(
                      child: Text(
                        feature,
                        style: AppTypography.uiBodyMedium.copyWith(height: 1.3),
                      ),
                    ),
                  ],
                ),
                AppSizes.spacingSm,
              ],

              AppSizes.spacingLg,

              // Buy CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: plan.isPopular
                        ? AppColors.brandRed
                        : (isDark
                              ? AppColors.darkBorder
                              : AppColors.primaryNavy),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Je m'abonne",
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
      ],
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  final bool isDark;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.isDark,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg,
            vertical: 2,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSizes.lg,
            0,
            AppSizes.lg,
            AppSizes.md,
          ),
          leading: AnimatedRotation(
            turns: _isExpanded ? 0.25 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.brandRed,
            ),
          ),
          trailing: const SizedBox.shrink(),
          title: Text(
            widget.question,
            style: AppTypography.uiTitleMedium.copyWith(
              color: widget.isDark ? Colors.white : AppColors.primaryNavy,
            ),
          ),
          onExpansionChanged: (v) => setState(() => _isExpanded = v),
          children: [
            Text(
              widget.answer,
              style: AppTypography.uiBodyMedium.copyWith(
                color: widget.isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
