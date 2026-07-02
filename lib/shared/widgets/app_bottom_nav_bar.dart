import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'nav_icon_mark.dart';

/// Floating capsule bottom navigation with custom editorial icons.
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark
        ? AppColors.darkSurface.withAlpha(240)
        : AppColors.lightSurface.withAlpha(242);
    final outlineColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final inactiveColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final highlightColor = isDark
        ? AppColors.brandRed.withAlpha(40)
        : AppColors.brandRed.withAlpha(18);

    final destinations = [
      const _NavDestination(
        label: 'Accueil',
        iconType: NavIconType.frontPage,
      ),
      const _NavDestination(
        label: 'Bourse',
        iconType: NavIconType.market,
      ),
      const _NavDestination(
        label: 'Actualités',
        iconType: NavIconType.feed,
      ),
      const _NavDestination(
        label: 'Placements',
        iconType: NavIconType.growth,
      ),
      const _NavDestination(
        label: 'Profil',
        iconType: NavIconType.profile,
      ),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: outlineColor.withAlpha(170)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 38 : 18),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SizedBox(
                height: 72,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final tabWidth = constraints.maxWidth / destinations.length;
                    final indicatorLeft = currentIndex * tabWidth + 6;
                    final indicatorWidth = tabWidth - 12;

                    return Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutCubic,
                          left: indicatorLeft,
                          top: 8,
                          width: indicatorWidth,
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: highlightColor,
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                        ),
                        Row(
                          children: List.generate(destinations.length, (index) {
                            final isSelected = index == currentIndex;
                            final dest = destinations[index];
                            final iconColor = isSelected ? AppColors.brandRed : inactiveColor;

                            return Expanded(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    onDestinationSelected(index);
                                  },
                                  borderRadius: BorderRadius.circular(22),
                                  splashColor: AppColors.brandRed.withAlpha(20),
                                  highlightColor: Colors.transparent,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        NavIconMark(
                                          type: dest.iconType,
                                          color: iconColor,
                                          size: 24,
                                          isActive: isSelected,
                                        ),
                                        const SizedBox(height: 4),
                                        AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 220),
                                          curve: Curves.easeOutCubic,
                                          style: isSelected
                                              ? AppTypography.uiLabelLarge.copyWith(
                                                  color: AppColors.brandRed,
                                                  fontWeight: FontWeight.w700,
                                                )
                                              : AppTypography.uiLabelMedium.copyWith(
                                                  color: inactiveColor.withAlpha(190),
                                                ),
                                          child: Text(
                                            dest.label,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavDestination {
  final String label;
  final NavIconType iconType;

  const _NavDestination({
    required this.label,
    required this.iconType,
  });
}
