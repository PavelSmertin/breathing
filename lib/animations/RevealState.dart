import 'package:flutter/material.dart';
import 'package:miracle/animations/MiraclePaint.dart';
import 'package:miracle/animations/RevealAnimationController.dart';
import 'package:miracle/animations/WavePaint.dart';

class RevealState extends State with TickerProviderStateMixin, ControllerCallback {

  late Widget child;
  late RevealAnimationController controller;
  late RevealAnimationController waveController;

  late Offset offset;
  late MiraclePaint revealPaint;

  Map<String, Widget> touchList = {};

  List<Widget> avatars = [];

  RevealState(this.child) {
    controller = RevealAnimationController(this, this);
    waveController = RevealAnimationController(this, this);
  }

  @override
  void initState() {
    super.initState();
    offset = Offset(10,10);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [ ];
    widgetList.add(child);

    revealPaint = MiraclePaint(
        controller.animationState,
        controller.fractionTouch,
        controller.fractionReverse,
        controller.alpha,
        controller.alphaReverse,
        offset
    );
    widgetList.add(drawPaint(revealPaint));

    return GestureDetector(
      child: Stack(children: widgetList),
      onTapUp: (e) {
        handleTapUp();
      },
      onLongPressUp: () {
        handleTapUp();
      },
      onTapDown: (e) {
        handleTapDown(e);
      },
    );
  }


  void handleTapDown(TapDownDetails e) {
    setState(() {
      setOffset(e);
      controller.onTapDown(e);
    });
  }

  void handleMove(DragUpdateDetails details, BuildContext context) {
    setState(() {
      controller.onMove(details, context);
    });
  }
  void handleLongMove(LongPressMoveUpdateDetails details, BuildContext context) {
    setState(() {
      controller.onLongMove(details, context);
    });
  }

  void handleTapUp() {
    controller.onTapUp();
  }

  void setOffset(TapDownDetails e) {
    RenderBox box = context.findRenderObject() as RenderBox;
    offset = box.globalToLocal(e.globalPosition);
  }



  Widget drawPaint(CustomPainter paint) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: paint,
      ),
    );
  }


  Widget drawWavePaint( Offset touchOffset) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: AnimatedBuilder(
        animation: waveController.tweenExpand,
        builder: (context, child) => CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: WavePaint(waveController.tweenExpand.value, waveController.tweenFade.value, touchOffset),
        ),
      ),
    );
  }

  @override
  void onAnimationUpdate() {
    setState(() {
    });
  }

  @override
  void onAnimationComplete() {
    setState(() {
    });
  }

  @override
  void onEventIssue(double radius, int velocity) {
  }

  @override
  void dispose() {
    controller.dispose();
    waveController.dispose();
    super.dispose();
  }




}