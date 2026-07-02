import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SplashMotif extends StatelessWidget {
  final double opacity;

  const SplashMotif({super.key, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SplashMotifPainter(
        opacity: opacity,
        color: AppColors.brandRed,
        accent: Colors.white,
      ),
    );
  }
}

class _SplashMotifPainter extends CustomPainter {
  final double opacity;
  final Color color;
  final Color accent;

  const _SplashMotifPainter({
    required this.opacity,
    required this.color,
    required this.accent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final alpha = (opacity.clamp(0.0, 1.0) * 255).round();
    final stroke = Paint()
      ..color = color.withAlpha((alpha * 0.35).round())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    final glow = Paint()
      ..color = accent.withAlpha((alpha * 0.08).round())
      ..style = PaintingStyle.fill;

    final centerX = size.width * 0.50;
    final centerY = size.height * 0.46;

    canvas.drawCircle(Offset(centerX, centerY), size.shortestSide * 0.22, glow);

    for (var i = 0; i < 4; i++) {
      final x = size.width * (0.24 + i * 0.14);
      final h = size.height * (0.10 + i * 0.03);
      canvas.drawLine(
        Offset(x, centerY + h),
        Offset(x, centerY - h * 0.3),
        stroke,
      );
      canvas.drawLine(
        Offset(x - 4, centerY + h * 0.1),
        Offset(x + 4, centerY + h * 0.1),
        stroke,
      );
    }

    final line = Path()
      ..moveTo(size.width * 0.16, size.height * 0.64)
      ..cubicTo(
        size.width * 0.30,
        size.height * 0.56,
        size.width * 0.42,
        size.height * 0.70,
        size.width * 0.54,
        size.height * 0.58,
      )
      ..cubicTo(
        size.width * 0.64,
        size.height * 0.48,
        size.width * 0.74,
        size.height * 0.60,
        size.width * 0.86,
        size.height * 0.42,
      );
    canvas.drawPath(line, stroke);

    canvas.drawLine(
      Offset(size.width * 0.16, size.height * 0.80),
      Offset(size.width * 0.86, size.height * 0.80),
      Paint()..color = Colors.white.withAlpha((alpha * 0.08).round())..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _SplashMotifPainter oldDelegate) {
    return oldDelegate.opacity != opacity ||
        oldDelegate.color != color ||
        oldDelegate.accent != accent;
  }
}