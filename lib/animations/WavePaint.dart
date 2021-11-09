import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:miracle/animations/HexColor.dart';


class WavePaint extends CustomPainter {

  late Paint mPaintInit;
  late Paint mPaintDot;

  late Offset offset;

  double fractionTouch = 0.0;
  double alphaTouch = 90.0;
  String revealColor = "6d3eff";

  final Gradient gradientFancy = new RadialGradient(
    colors: <Color>[
      Color.fromRGBO(109,62,255, 0.4),
      Color.fromRGBO(109,62,255, 0.0),
    ],
    stops: [
      0.1,
      1.0,
    ],
  );

  final Gradient gradientFancy2 = new RadialGradient(
    colors: <Color>[
      Color.fromRGBO(109,62,255, 0.0),
      Color.fromRGBO(109,62,255, 0.89),
      Color.fromRGBO(109,62,255, 0.0),
    ],
    stops: [
      0.1,
      0.7,
      1.0,
    ],
  );

  WavePaint(this.fractionTouch, this.alphaTouch,  this.offset) {
    var alphaI = alphaTouch.toInt();
    var alphaD = alphaTouch ~/ 2 ;

    mPaintInit = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0
      ..isAntiAlias = true;
    mPaintInit.color = HexColor("#$alphaI$revealColor");

    mPaintDot = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    mPaintDot.color = HexColor("#$alphaD$revealColor");
  }

  double hypot(double x, double y) {
    return math.sqrt(x * x + y * y);
  }

  @override
  void paint(Canvas canvas, Size size) {

    double maxRadius = hypot(size.width, size.height);
    double finalRadius = (maxRadius * fractionTouch);

    Rect rectInit = new Rect.fromCircle(
      center: offset,
      radius: maxRadius * (0.1+fractionTouch) / 4,
    );

    Rect rect2 = new Rect.fromCircle(
      center: offset,
      radius: finalRadius * 2,
    );

    mPaintInit.shader = gradientFancy.createShader(rectInit);
    mPaintDot.shader = gradientFancy2.createShader(rect2);
    canvas.drawPaint(mPaintInit);
    canvas.drawPaint(mPaintDot);
  }

  @override
  bool shouldRepaint(WavePaint oldDelegate) {
    return true;
  }
}