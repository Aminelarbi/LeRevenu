import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

enum StockChartPeriod { oneDay, oneWeek, oneMonth, oneYear }

class StockDetailChartSection extends StatelessWidget {
  final List<double> series;
  final StockChartPeriod period;
  final Color color;
  final bool isDark;
  final ValueChanged<StockChartPeriod> onPeriodSelected;

  const StockDetailChartSection({
    super.key,
    required this.series,
    required this.period,
    required this.color,
    required this.isDark,
    required this.onPeriodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final min = series.reduce((a, b) => a < b ? a : b);
    final max = series.reduce((a, b) => a > b ? a : b);
    final labels = const [
      (StockChartPeriod.oneDay, '1J'),
      (StockChartPeriod.oneWeek, '1S'),
      (StockChartPeriod.oneMonth, '1M'),
      (StockChartPeriod.oneYear, '1A'),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppSizes.borderXl,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance',
            style: AppTypography.uiTitleMedium.copyWith(
              color: isDark ? Colors.white : AppColors.primaryNavy,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: labels.map((entry) {
              final selected = entry.$1 == period;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(entry.$2),
                    selected: selected,
                    onSelected: (_) => onPeriodSelected(entry.$1),
                    labelStyle: AppTypography.uiLabelMedium.copyWith(
                      color: selected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                      fontWeight: FontWeight.w600,
                    ),
                    selectedColor: AppColors.brandRed,
                    backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                    side: BorderSide(
                      color: selected ? AppColors.brandRed : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            height: 220,
            child: CustomPaint(
              painter: _StockChartPainter(
                series: series,
                color: color,
                isDark: isDark,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Min: ${min.toStringAsFixed(2)}  •  Max: ${max.toStringAsFixed(2)}',
                    style: AppTypography.uiLabelMedium.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockChartPainter extends CustomPainter {
  final List<double> series;
  final Color color;
  final bool isDark;

  const _StockChartPainter({
    required this.series,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (series.length < 2) return;

    final min = series.reduce((a, b) => a < b ? a : b);
    final max = series.reduce((a, b) => a > b ? a : b);
    final range = (max - min).abs() < 0.0001 ? 1.0 : (max - min);
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : AppColors.primaryNavy).withAlpha(18)
      ..strokeWidth = 1;
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(0, size.height),
        [color.withAlpha(70), color.withAlpha(6)],
      )
      ..style = PaintingStyle.fill;

    for (var i = 1; i <= 3; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    double xFor(int index) => (index / (series.length - 1)) * size.width;
    double yFor(double value) => size.height - ((value - min) / range) * (size.height * 0.78) - size.height * 0.08;

    final path = Path()..moveTo(xFor(0), yFor(series[0]));
    for (var i = 1; i < series.length; i++) {
      final prev = Offset(xFor(i - 1), yFor(series[i - 1]));
      final current = Offset(xFor(i), yFor(series[i]));
      final control1 = Offset(prev.dx + (current.dx - prev.dx) * 0.5, prev.dy);
      final control2 = Offset(prev.dx + (current.dx - prev.dx) * 0.5, current.dy);
      path.cubicTo(control1.dx, control1.dy, control2.dx, control2.dy, current.dx, current.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    canvas.drawCircle(Offset(size.width, yFor(series.last)), 3.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _StockChartPainter oldDelegate) {
    return oldDelegate.series != series || oldDelegate.color != color || oldDelegate.isDark != isDark;
  }
}