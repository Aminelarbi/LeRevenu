import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

void showComingSoonSnackbar(
  BuildContext context, {
  String? featureName,
}) {
  final messenger = ScaffoldMessenger.of(context);
  final message = featureName == null || featureName.trim().isEmpty
      ? 'Cette fonctionnalité arrive bientôt.'
      : '$featureName arrive bientôt.';

  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.primaryNavy,
      margin: const EdgeInsets.all(AppSizes.lg),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 18,
          ),
          AppSizes.spacingSm,
          Flexible(
            child: Text(
              message,
              style: AppTypography.uiBodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}