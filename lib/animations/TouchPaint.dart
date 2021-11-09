import 'dart:math' as math;

import 'package:flutter/material.dart';

class TouchPaint extends CustomPainter {

  late Paint mPaint;
  late Offset offset;
  double fraction = 0.0;

  TouchPaint( this.fraction, this.offset) {

    mPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..isAntiAlias = true;

    mPaint.color = Color(0x9925B1EB);
  }

  double hypot(double x, double y) {
    return math.sqrt(x * x + y * y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    double maxRadius = hypot(size.width, size.height);
    canvas.drawCircle(offset, maxRadius * fraction, mPaint);
  }

  @override
  bool shouldRepaint(TouchPaint oldDelegate) {
    return true;
  }
}