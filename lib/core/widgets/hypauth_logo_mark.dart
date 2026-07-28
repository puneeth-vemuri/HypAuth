import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HypAuthLogoMark extends StatelessWidget {
  final double size;
  final Color color;

  const HypAuthLogoMark({
    super.key,
    this.size = 32.0,
    this.color = AppColors.ink,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _HypAuthLogoPainter(color: color),
      ),
    );
  }
}

class _HypAuthLogoPainter extends CustomPainter {
  final Color color;

  _HypAuthLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 2) / 2;

    // Outer circle ring
    final ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, ringPaint);

    // Inner sweeping clock hand line
    final handPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final angle = 38 * (pi / 180);
    final handLength = radius * 0.75;
    final endPoint = Offset(
      center.dx + handLength * sin(angle),
      center.dy - handLength * cos(angle),
    );

    canvas.drawLine(center, endPoint, handPaint);
  }

  @override
  bool shouldRepaint(covariant _HypAuthLogoPainter oldDelegate) =>
      oldDelegate.color != color;
}
