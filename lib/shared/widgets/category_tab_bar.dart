import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';
import '../../data/models/category.dart';
import 'category_chip.dart';

/// A horizontal scrollable list of [CategoryChip]s.
/// Provides filtering tabs for the articles list, including an implicit 'All' ('Toutes') category.
class CategoryTabBar extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  const CategoryTabBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    // Reusable "All" virtual category representation using brand red
    const allCategory = Category(
      id: 'all',
      label: 'Toutes',
      colorHex: '0xFFC8102E',
      icon: Icons.apps_rounded,
    );

    final isAllSelected =
        selectedCategoryId == null || selectedCategoryId == 'all';

    return SizedBox(
      height: AppSizes.categoryBarHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) => AppSizes.spacingSm,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Render the "Toutes" chip
            return CategoryChip(
              key: const ValueKey('category_chip_all'),
              category: allCategory,
              isSelected: isAllSelected,
              onTap: () => onCategorySelected(null),
            );
          }

          final category = categories[index - 1];
          final isSelected = selectedCategoryId == category.id;

          return CategoryChip(
            key: ValueKey('category_chip_${category.id}'),
            category: category,
            isSelected: isSelected,
            onTap: () => onCategorySelected(category.id),
          );
        },
      ),
    );
  }
}
