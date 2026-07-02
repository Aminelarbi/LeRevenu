import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../data/models/category.dart';

class CategoryMark extends StatelessWidget {
  final Category category;
  final Color color;
  final double size;
  final bool isActive;

  const CategoryMark({
    super.key,
    required this.category,
    required this.color,
    required this.size,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: isActive ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 220),
      curve: isActive ? Curves.easeOutBack : Curves.easeOutCubic,
      builder: (context, progress, _) {
        return Transform.scale(
          scale: ui.lerpDouble(0.96, 1.06, progress)!,
          child: CustomPaint(
            size: Size.square(size),
            painter: _CategoryMarkPainter(
              category: category,
              color: color,
              progress: progress,
            ),
          ),
        );
      },
    );
  }
}

class _CategoryMarkPainter extends CustomPainter {
  final Category category;
  final Color color;
  final double progress;

  const _CategoryMarkPainter({
    required this.category,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = ui.lerpDouble(1.1, 2.0, progress)!;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color.withValues(alpha: ui.lerpDouble(0.10, 0.24, progress)!)
      ..style = PaintingStyle.fill;

    switch (category.id.toLowerCase()) {
      case 'bourse':
        _paintBourse(canvas, size, stroke, fill);
      case 'immobilier':
        _paintImmobilier(canvas, size, stroke, fill);
      case 'placements':
        _paintPlacements(canvas, size, stroke, fill);
      case 'fiscalite':
        _paintFiscalite(canvas, size, stroke, fill);
      case 'assurance':
        _paintAssurance(canvas, size, stroke, fill);
      default:
        _paintFallback(canvas, size, stroke, fill);
    }
  }

  void _paintBourse(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final bars = <double>[0.32, 0.58, 0.78];
    for (var i = 0; i < bars.length; i++) {
      final left = size.width * (0.18 + i * 0.22);
      final top = size.height * (0.72 - bars[i]);
      final rect = Rect.fromLTWH(left, top, size.width * 0.12, size.height * bars[i]);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(size.shortestSide * 0.05)), fill);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(size.shortestSide * 0.05)), stroke);
      canvas.drawLine(
        Offset(left + rect.width / 2, top - size.height * 0.06),
        Offset(left + rect.width / 2, top + rect.height + size.height * 0.06),
        stroke,
      );
    }
  }

  void _paintImmobilier(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final outer = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.20, size.height * 0.18, size.width * 0.60, size.height * 0.64),
      Radius.circular(size.shortestSide * 0.08),
    );
    canvas.drawRRect(outer, fill);
    canvas.drawRRect(outer, stroke);
    for (final row in [0.30, 0.50]) {
      for (final col in [0.28, 0.50, 0.72]) {
        final rect = Rect.fromCenter(
          center: Offset(size.width * col, size.height * row),
          width: size.width * 0.09,
          height: size.height * 0.12,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(size.shortestSide * 0.03)),
          fill,
        );
      }
    }
    canvas.drawLine(
      Offset(size.width * 0.50, size.height * 0.18),
      Offset(size.width * 0.50, size.height * 0.82),
      stroke,
    );
  }

  void _paintPlacements(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final coin = Offset(size.width * 0.28, size.height * 0.70);
    canvas.drawCircle(coin, size.shortestSide * 0.12, fill);
    canvas.drawCircle(coin, size.shortestSide * 0.12, stroke);
    final arrow = Path()
      ..moveTo(size.width * 0.20, size.height * 0.60)
      ..lineTo(size.width * 0.44, size.height * 0.36)
      ..lineTo(size.width * 0.55, size.height * 0.36)
      ..lineTo(size.width * 0.55, size.height * 0.22)
      ..lineTo(size.width * 0.78, size.height * 0.22);
    canvas.drawPath(arrow, stroke);
    canvas.drawLine(
      Offset(size.width * 0.69, size.height * 0.15),
      Offset(size.width * 0.78, size.height * 0.22),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.69, size.height * 0.29),
      Offset(size.width * 0.78, size.height * 0.22),
      stroke,
    );
  }

  void _paintFiscalite(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final paper = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.22, size.height * 0.16, size.width * 0.56, size.height * 0.68),
      Radius.circular(size.shortestSide * 0.08),
    );
    canvas.drawRRect(paper, fill);
    canvas.drawRRect(paper, stroke);
    canvas.drawLine(
      Offset(size.width * 0.30, size.height * 0.34),
      Offset(size.width * 0.64, size.height * 0.34),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.30, size.height * 0.50),
      Offset(size.width * 0.58, size.height * 0.50),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.30, size.height * 0.66),
      Offset(size.width * 0.52, size.height * 0.66),
      stroke,
    );
  }

  void _paintAssurance(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final path = Path()
      ..moveTo(size.width * 0.50, size.height * 0.14)
      ..quadraticBezierTo(size.width * 0.80, size.height * 0.22, size.width * 0.76, size.height * 0.50)
      ..quadraticBezierTo(size.width * 0.72, size.height * 0.82, size.width * 0.50, size.height * 0.88)
      ..quadraticBezierTo(size.width * 0.28, size.height * 0.82, size.width * 0.24, size.height * 0.50)
      ..quadraticBezierTo(size.width * 0.20, size.height * 0.22, size.width * 0.50, size.height * 0.14)
      ..close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
    canvas.drawLine(
      Offset(size.width * 0.38, size.height * 0.54),
      Offset(size.width * 0.47, size.height * 0.63),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.47, size.height * 0.63),
      Offset(size.width * 0.64, size.height * 0.41),
      stroke,
    );
  }

  void _paintFallback(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.22, size.height * 0.22, size.width * 0.56, size.height * 0.56),
      Radius.circular(size.shortestSide * 0.08),
    );
    canvas.drawRRect(rect, fill);
    canvas.drawRRect(rect, stroke);
  }

  @override
  bool shouldRepaint(covariant _CategoryMarkPainter oldDelegate) {
    return oldDelegate.category != category ||
        oldDelegate.color != color ||
        oldDelegate.progress != progress;
  }
}