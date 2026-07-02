import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

enum BourseSortMode { name, gainers, losers }

class BourseSegmentSortRow extends StatelessWidget {
  final bool isDark;
  final int segmentIndex;
  final BourseSortMode sortMode;
  final ValueChanged<int> onSegmentChanged;
  final ValueChanged<BourseSortMode> onSortModeChanged;

  const BourseSegmentSortRow({
    super.key,
    required this.isDark,
    required this.segmentIndex,
    required this.sortMode,
    required this.onSegmentChanged,
    required this.onSortModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['Indices', 'Actions', 'Crypto'];
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.lg,
          AppSizes.md,
          AppSizes.lg,
          0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder.withAlpha(80) : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: List.generate(labels.length, (index) {
                    final selected = index == segmentIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onSegmentChanged(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: selected
                                ? (isDark ? AppColors.darkSurface : Colors.white)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(17),
                            boxShadow: selected
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
                          child: Text(
                            labels[index],
                            style: AppTypography.uiLabelLarge.copyWith(
                              color: selected
                                  ? (isDark ? Colors.white : AppColors.primaryNavy)
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            PopupMenuButton<BourseSortMode>(
              initialValue: sortMode,
              onSelected: onSortModeChanged,
              tooltip: 'Trier par',
              icon: Icon(
                Icons.sort_rounded,
                color: isDark ? AppColors.darkTextSecondary : AppColors.primaryNavy,
              ),
              itemBuilder: (_) => const [
                PopupMenuItem(value: BourseSortMode.name, child: Text('Nom (A→Z)')),
                PopupMenuItem(value: BourseSortMode.gainers, child: Text('Plus forte hausse')),
                PopupMenuItem(value: BourseSortMode.losers, child: Text('Plus forte baisse')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}