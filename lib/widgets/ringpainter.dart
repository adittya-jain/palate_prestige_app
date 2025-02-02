import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

class RingsPainter extends CustomPainter {
  final double animationValue;

  RingsPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint ringPaintA = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = calculateStrokeWidth(animationValue, 20, 30)
      ..strokeCap = StrokeCap.round;
    final Paint ringPaintB = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = calculateStrokeWidth(animationValue, 20, 30)
      ..strokeCap = StrokeCap.round;
    final Paint ringPaintC = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = calculateStrokeWidth(animationValue, 20, 30)
      ..strokeCap = StrokeCap.round;
    final Paint ringPaintD = Paint()
      ..color = Colors.pink
      ..style = PaintingStyle.stroke
      ..strokeWidth = calculateStrokeWidth(animationValue, 20, 30)
      ..strokeCap = StrokeCap.round;

    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw the rings
    drawRing(canvas, center, 105, 660, -330, animationValue, ringPaintA);
    drawRing(canvas, center, 35, 220, -110, animationValue, ringPaintB);
    drawRing(canvas, Offset(center.dx - 35, center.dy), 70, 440, 0, animationValue, ringPaintC);
    drawRing(canvas, Offset(center.dx + 35, center.dy), 70, 440, 0, animationValue, ringPaintD);
  }

  void drawRing(Canvas canvas, Offset center, double radius, double maxDash, double offset,
      double animationValue, Paint paint) {
    double dashArray = calculateDashArray(animationValue, maxDash);
    final path = Path();
    path.addArc(Rect.fromCircle(center: center, radius: radius), 0, 2 * pi);

    canvas.drawPath(
      dashPath(path, dashArray, offset + animationValue * maxDash),
      paint,
    );
  }

  Path dashPath(Path path, double dashArray, double offset) {
    Path dashPath = Path();
    double distance = 0.0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      double length = pathMetric.length;
      bool draw = true;
      while (distance < length) {
        double segment = draw ? dashArray : dashArray;
        if (distance + segment > length) {
          segment = length - distance;
        }
        dashPath.addPath(pathMetric.extractPath(distance, distance + segment), Offset.zero);
        distance += segment;
        draw = !draw;
      }
    }
    return dashPath;
  }

  double calculateDashArray(double t, double maxDash) {
    return maxDash * (1 - (t % 1));
  }

  double calculateStrokeWidth(double t, double minWidth, double maxWidth) {
    return t < 0.5 ? minWidth + t * (maxWidth - minWidth) * 2 : maxWidth - (t - 0.5) * (maxWidth - minWidth) * 2;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
