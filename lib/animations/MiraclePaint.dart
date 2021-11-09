import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:miracle/animations/HexColor.dart';
import 'package:miracle/animations/RevealAnimationController.dart';


class MiraclePaint extends CustomPainter {

  AnimStates animationState;

  late Paint mPaintInit;
  late Paint mPaint;
  late Paint mPaintDot;
  late Paint mPaintReverse;

  Offset offset;

  double fractionTouch = 0.0;
  double fractionReverse = 0.0;

  int alphaTouch = 50;
  int alphaReverse = 10;
  int alphaDot = 50;


  String revealColor = "25b1eb";
  static int gradientAlpha1 = 95;
  static String gradientrevealColor1 = "25b1eb";
  static int gradientAlpha2 = 0;
  static String gradientrevealColor2 = "25b1eb";

  List<Color> circleColors = [
    Color(0x336d3eff),
    Color(0x33357eff),
    Color(0x3339a3ff),
    Color(0x3354fef5),
    Color(0x333ebcff),
    Color(0x3325b1eb),
  ];

  List<String> circleColorsStrings = [
    '6d3eff',
    '357eff',
    '39a3ff',
    '54fef5',
    '3ebcff',
    '25b1eb',
  ];

  final Gradient gradientFancy = new RadialGradient(
    colors: <Color>[
      Color.fromRGBO(37, 177, 235, 0.4),
      Color.fromRGBO(37, 177, 235, 0.0),
    ],
    stops: [
      0.1,
      1.0,
    ],
  );

  final Gradient gradientFancy2 = new RadialGradient(
    colors: <Color>[
      Color.fromRGBO(37, 177, 235, 0.0),
      Color.fromRGBO(37, 177, 235, 0.89),
      Color.fromRGBO(37, 177, 235, 0.0),
    ],
    stops: [
      0.1,
      0.7,
      1.0,
    ],
  );

  MiraclePaint(this.animationState, this.fractionTouch, this.fractionReverse,  this.alphaTouch,  this.alphaReverse, this.offset) {

    var alphaI = alphaTouch.toInt();
    var alphaT = alphaTouch.toInt() ~/ 2 ;
    var alphaD = alphaTouch ~/ 2 ;
    var alphaR = alphaReverse.toInt();

    mPaintInit = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0
      ..isAntiAlias = true;
    mPaintInit.color = HexColor("#$alphaI$revealColor");

    mPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0
      ..isAntiAlias = true;



    mPaint.color = HexColor("#$alphaT$revealColor");

    mPaintDot = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0
      ..isAntiAlias = true;


    mPaintDot.color = HexColor("#$alphaD$revealColor");


    mPaintReverse = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0
      ..isAntiAlias = true;


    mPaintReverse.color = HexColor("#$alphaR$revealColor");
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

    Rect rect = new Rect.fromCircle(
      center: offset,
      radius: finalRadius,
    );

    Rect rect2 = new Rect.fromCircle(
      center: offset,
      radius: finalRadius * 2,
    );

    mPaintInit.shader = gradientFancy.createShader(rectInit);
    mPaint.shader = gradientFancy2.createShader(rect);
    mPaintDot.shader = gradientFancy2.createShader(rect2);
    canvas.drawPaint(mPaintInit);
    canvas.drawPaint(mPaintDot);

    if(animationState == AnimStates.RUNNING) {
      drawCircles(canvas, maxRadius);
    }

  }

  drawCircles(Canvas canvas, double maxRadius) {
    double radius = maxRadius * (fractionReverse - 0.1) * 1;

    double circleRadius = maxRadius * (fractionReverse) * 0.5;

    for(int i = 0; i < 6; i++) {
      double alfa = pi * (i - (fractionReverse - 0.1) * 20) / 3;
      Offset circleOffset = getOffset( offset, radius, alfa );
      Paint paint = Paint()
        ..style = PaintingStyle.fill
        ..strokeWidth = 2.0
        ..isAntiAlias = true
        ..color = circleColors[i];
      var alphaR = alphaReverse.toInt();
      var color = circleColorsStrings[i];
      paint.color = HexColor("#$alphaR$color");

      canvas.drawCircle( circleOffset, circleRadius, paint );
    }
  }

  Offset getOffset( Offset offset, double radius, double alfa ) {
    return new Offset(offset.dx + radius * sin(alfa), offset.dy + radius * cos(alfa));
  }


  @override
  bool shouldRepaint(MiraclePaint oldDelegate) {
    return true;
  }
}