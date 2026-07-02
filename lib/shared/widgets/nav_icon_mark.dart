import 'dart:ui' as ui;

import 'package:flutter/material.dart';

enum NavIconType { frontPage, market, feed, growth, profile }

class NavIconMark extends StatelessWidget {
  final NavIconType type;
  final Color color;
  final double size;
  final bool isActive;

  const NavIconMark({
    super.key,
    required this.type,
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
      builder: (context, value, child) {
        final scale = ui.lerpDouble(0.96, 1.08, value)!;
        return Transform.scale(
          scale: scale,
          child: CustomPaint(
            size: Size.square(size),
            painter: _NavIconPainter(
              type: type,
              color: color,
              progress: value,
            ),
          ),
        );
      },
    );
  }
}

class _NavIconPainter extends CustomPainter {
  final NavIconType type;
  final Color color;
  final double progress;

  const _NavIconPainter({
    required this.type,
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = ui.lerpDouble(1.25, 2.15, progress)!;
    final fillOpacity = ui.lerpDouble(0.10, 0.24, progress)!;
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fillPaint = Paint()
      ..color = color.withValues(alpha: fillOpacity)
      ..style = PaintingStyle.fill;

    switch (type) {
      case NavIconType.frontPage:
        _paintFrontPage(canvas, size, strokePaint, fillPaint);
      case NavIconType.market:
        _paintMarket(canvas, size, strokePaint, fillPaint);
      case NavIconType.feed:
        _paintFeed(canvas, size, strokePaint, fillPaint);
      case NavIconType.growth:
        _paintGrowth(canvas, size, strokePaint, fillPaint);
      case NavIconType.profile:
        _paintProfile(canvas, size, strokePaint, fillPaint);
    }
  }

  void _paintFrontPage(
    Canvas canvas,
    Size size,
    Paint stroke,
    Paint fill,
  ) {
    final frame = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.16, size.height * 0.18, size.width * 0.68, size.height * 0.64),
      Radius.circular(size.shortestSide * 0.12),
    );
    canvas.drawRRect(frame, stroke);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.22, size.height * 0.23, size.width * 0.56, size.height * 0.12),
        Radius.circular(size.shortestSide * 0.08),
      ),
      fill,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.45),
      Offset(size.width * 0.72, size.height * 0.45),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.59),
      Offset(size.width * 0.62, size.height * 0.59),
      stroke,
    );
    canvas.drawCircle(Offset(size.width * 0.70, size.height * 0.58), size.shortestSide * 0.03, fill);
  }

  void _paintMarket(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final baseline = size.height * 0.78;
    canvas.drawLine(
      Offset(size.width * 0.18, baseline),
      Offset(size.width * 0.84, baseline),
      stroke,
    );
    final bars = <double>[0.34, 0.58, 0.76, 0.5];
    for (var i = 0; i < bars.length; i++) {
      final left = size.width * (0.22 + i * 0.14);
      final top = size.height * (0.78 - bars[i]);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, size.width * 0.08, size.height * bars[i]),
        Radius.circular(size.shortestSide * 0.03),
      );
      canvas.drawRRect(rect, fill);
      canvas.drawRRect(rect, stroke);
    }
  }

  void _paintFeed(Canvas canvas, Size size, Paint stroke, Paint fill) {
    canvas.drawCircle(Offset(size.width * 0.22, size.height * 0.29), size.shortestSide * 0.035, fill);
    canvas.drawLine(
      Offset(size.width * 0.31, size.height * 0.29),
      Offset(size.width * 0.78, size.height * 0.29),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.49),
      Offset(size.width * 0.72, size.height * 0.49),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.22, size.height * 0.68),
      Offset(size.width * 0.60, size.height * 0.68),
      stroke,
    );
  }

  void _paintGrowth(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final coinCenter = Offset(size.width * 0.30, size.height * 0.70);
    final coinRadius = size.shortestSide * 0.10;
    canvas.drawCircle(coinCenter, coinRadius, fill);
    canvas.drawCircle(coinCenter, coinRadius, stroke);

    final arrowPath = Path()
      ..moveTo(size.width * 0.24, size.height * 0.64)
      ..lineTo(size.width * 0.45, size.height * 0.44)
      ..lineTo(size.width * 0.56, size.height * 0.44)
      ..lineTo(size.width * 0.56, size.height * 0.29)
      ..lineTo(size.width * 0.74, size.height * 0.29);
    canvas.drawPath(arrowPath, stroke);
    canvas.drawLine(
      Offset(size.width * 0.67, size.height * 0.21),
      Offset(size.width * 0.74, size.height * 0.29),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.67, size.height * 0.37),
      Offset(size.width * 0.74, size.height * 0.29),
      stroke,
    );
  }

  void _paintProfile(Canvas canvas, Size size, Paint stroke, Paint fill) {
    final headCenter = Offset(size.width * 0.50, size.height * 0.34);
    final headRadius = size.shortestSide * 0.15;
    canvas.drawCircle(headCenter, headRadius, fill);
    canvas.drawCircle(headCenter, headRadius, stroke);

    final torso = Path()
      ..moveTo(size.width * 0.26, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.50, size.height * 0.55, size.width * 0.74, size.height * 0.78);
    canvas.drawPath(torso, stroke);
  }

  @override
  bool shouldRepaint(covariant _NavIconPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.color != color ||
        oldDelegate.progress != progress;
  }
}