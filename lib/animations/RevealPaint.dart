import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:miracle/animations/HexColor.dart';
import 'package:miracle/animations/RevealAnimationController.dart';


class RevealPaint extends CustomPainter {

  late AnimStates animationState;

  late Paint mPaintInit;
  late Paint mPaint;
  late Paint mPaintDot;
  late Paint mPaintReverse;

  late Offset offset;

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

  RevealPaint(this.animationState, this.fractionTouch, this.fractionReverse,  this.alphaTouch,  this.alphaReverse, this.offset) {

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
    //canvas.drawPaint(mPaint);
    canvas.drawPaint(mPaintDot);

    if(animationState == AnimStates.RUNNING) {
      canvas.drawCircle(offset, maxRadius * fractionReverse, mPaintReverse);
    }

  }

  @override
  bool shouldRepaint(RevealPaint oldDelegate) {
    return true;
  }
}