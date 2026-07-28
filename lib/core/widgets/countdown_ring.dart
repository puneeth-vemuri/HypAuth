import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CountdownRing extends StatelessWidget {
  final int remainingSeconds;
  final int totalPeriod;
  final double size;

  const CountdownRing({
    super.key,
    required this.remainingSeconds,
    this.totalPeriod = 30,
    this.size = 36.0,
  });

  @override
  Widget build(BuildContext context) {
    final progress = remainingSeconds / totalPeriod;
    final isWarning = remainingSeconds <= 5;
    final color = isWarning
        ? AppColors.darkError
        : Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: progress,
          color: color,
          trackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Center(
          child: Text(
            '$remainingSeconds',
            style: TextStyle(
              fontSize: size * 0.38,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.12;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
