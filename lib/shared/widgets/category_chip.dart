import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/category.dart';
import 'category_mark.dart';

/// A reusable Chip/Badge representing a category.
/// In static mode (isSelectable = false), it displays as an editorial tag with a 15% opacity background,
/// full-strength category color text, and a matching subtle border.
class CategoryChip extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final bool isSelectable;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
    this.isSelectable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color backgroundColor;
    final Color textColor;
    final Border? border;

    if (isSelectable) {
      if (isSelected) {
        backgroundColor = category.color;
        textColor = Colors.white;
        border = null;
      } else {
        // Tag look: translucent background with clear text and border
        backgroundColor = category.color.withAlpha(isDark ? 38 : 15);
        textColor = isDark ? Colors.white.withAlpha(222) : category.color;
        border = Border.all(
          color: category.color.withAlpha(isDark ? 76 : 38),
          width: 1,
        );
      }
    } else {
      // Static editorial badge: 15% opacity background, full-color text and border
      backgroundColor = category.color.withAlpha(isDark ? 38 : 25); // ~10-15%
      textColor = isDark
          ? Color.lerp(category.color, Colors.white, 0.3)!
          : category.color;
      border = Border.all(
        color: category.color.withAlpha(isDark ? 76 : 51),
        width: 1,
      );
    }

    final chipWidget = IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.xs + 1,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppSizes.borderRound,
          border: border,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelectable) ...[
              CategoryMark(
                category: category,
                color: textColor,
                size: 16,
                isActive: isSelected,
              ),
              AppSizes.spacingXs,
            ],
            Flexible(
              child: Text(
                category.label,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: AppTypography.uiLabelLarge.copyWith(
                  color: textColor,
                  fontWeight: (isSelected || !isSelectable)
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (isSelectable && onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: chipWidget,
      );
    }

    return chipWidget;
  }
}
