import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../data/models/stock_quote.dart';

class BourseStockRow extends StatelessWidget {
  final StockQuote quote;
  final bool isDark;
  final VoidCallback onTap;

  const BourseStockRow({
    super.key,
    required this.quote,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = quote.isUp ? AppColors.gainGreen : AppColors.lossRed;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.uiTitleMedium.copyWith(
                      color: isDark ? Colors.white : AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    quote.ticker,
                    style: AppTypography.uiBodySmall.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 36,
                child: _Sparkline(points: quote.sparklinePoints, color: color),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    quote.type == QuoteType.crypto && quote.price < 1
                        ? '${quote.price.toStringAsFixed(4)}${quote.currencySymbol}'
                        : '${quote.price.toStringAsFixed(2)}${quote.currencySymbol}',
                    style: AppTypography.uiBodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withAlpha(isDark ? 38 : 20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${quote.variationPercent >= 0 ? '+' : ''}${quote.variationPercent.toStringAsFixed(2)}%',
                      style: AppTypography.uiLabelLarge.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.xs),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _Sparkline extends StatelessWidget {
  final List<double> points;
  final Color color;

  const _Sparkline({required this.points, required this.color});

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return const SizedBox.shrink();
    return CustomPaint(painter: _SparklinePainter(points: points, color: color));
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> points;
  final Color color;

  const _SparklinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final minY = points.reduce((a, b) => a < b ? a : b);
    final maxY = points.reduce((a, b) => a > b ? a : b);
    final range = (maxY - minY).abs();
    final effectiveRange = range < 0.0001 ? 1.0 : range;

    double mapX(int i) => (i / (points.length - 1)) * size.width;
    double mapY(double v) => size.height - ((v - minY) / effectiveRange) * size.height * 0.8 - size.height * 0.1;

    final path = Path()..moveTo(mapX(0), mapY(points[0]));
    for (var i = 1; i < points.length; i++) {
      path.lineTo(mapX(i), mapY(points[i]));
    }

    final fillPath = Path.from(path)
      ..lineTo(mapX(points.length - 1), size.height)
      ..lineTo(mapX(0), size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = color.withAlpha(30)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) => old.points != points || old.color != color;
}