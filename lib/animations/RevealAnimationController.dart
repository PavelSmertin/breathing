import 'dart:math';

import 'package:flutter/material.dart';

class RevealAnimationController {

  static ValueNotifier<List<double>> valueListener = ValueNotifier([.0, .0]);

  late Animation<double> tweenFade;
  late  Animation<double> tweenFadeReverse;
  late  Animation<double> tweenFadeHold;
  late Animation<double> tweenExpand;
  late Animation<double> tweenExpandReverse;
  late Animation<double> tweenExpandHold;
  late VoidCallback tweenFadeCallback;
  late VoidCallback tweenExpandCallback;
  late VoidCallback tweenHoldCallback;

  late AnimationStatusListener animationControllerStatusListener;
  late AnimationStatusListener holdControllerStatusListener;

  late AnimationController animationController;
  late AnimationController holdController;

  late Offset contactPosition;
  late double maxEpselent;
  late double maxDistance;
  late double minDistance;
  late double minEpselent;
  bool upTrend = true;
  DateTime before = DateTime.now();
  DateTime after = DateTime.now();
  int diff = 0;

  double fractionTouch = 0;
  double fractionReverse = 0;
  double fractionHold = 0;
  int alpha = 0;
  int alphaReverse = 0;

  double MAX_TWEEN_VALUE = 0.715;
  double MIN_TWEEN_VALUE = 0.0;

  double MAX_HOLD_VALUE = 0.2;
  double MIN_HOLD_VALUE = 0.1;

  static final int MAX_ALPHA = 0;
  static final int MIN_ALPHA = 90;

  static const int INHALE_DURATION = 2500;
  static const int EXHALE_DURATION = 4500;
  static const int INHALE_DELAY = 900;
  static const int EXHALE_DELAY = 800;

  late ControllerCallback callback;

  AnimStates animationState = AnimStates.NOT_STARTED;

  RevealAnimationController(TickerProviderStateMixin mixin, ControllerCallback callback) {
    this.callback = callback;
    fractionTouch = MIN_TWEEN_VALUE;
    fractionReverse = MAX_TWEEN_VALUE;
    fractionHold = MIN_HOLD_VALUE;
    alpha = MAX_ALPHA;
    alphaReverse = MIN_ALPHA;
    animationState = AnimStates.NOT_STARTED;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: mixin);

    holdController = AnimationController(
        reverseDuration: const Duration(milliseconds: EXHALE_DURATION),
        duration: const Duration(milliseconds: INHALE_DURATION),
        vsync: mixin
    );

    tweenFade = Tween<double>(begin: MIN_ALPHA.toDouble(), end: MAX_ALPHA.toDouble())
        .animate(
      new CurvedAnimation(
          parent: animationController,
          curve: new Interval(
            0.0,
            .3,
            curve: Curves.fastOutSlowIn,
          ),
          reverseCurve: new Interval(
            0.7,
            1.0,
            curve: Curves.fastOutSlowIn,
          ),
      ),
    );

    tweenExpand = Tween<double>(begin: MIN_TWEEN_VALUE, end: MAX_TWEEN_VALUE)
        .animate(
          new CurvedAnimation(
            parent: animationController,
            curve: new Interval(
              0.000,
              1.000,
              curve: Curves.ease,
            ),
            reverseCurve: Curves.ease
          ),
        );

    tweenFadeReverse = Tween<double>(begin: 0, end: 50)
        .animate(
      new CurvedAnimation(
        parent: animationController,
        curve: new Interval(
          0.1,
          .2,
          curve: Curves.easeIn,
        ),
        reverseCurve: new Interval(
          0.7,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    tweenExpandReverse = Tween<double>(begin: MAX_TWEEN_VALUE, end: 0.1)
        .animate(
      new CurvedAnimation(
          parent: animationController,
          curve: new Interval(
            0.000,
            1.000,
            curve: Curves.elasticOut,
          ),
          reverseCurve: Curves.ease
      ),
    );

    tweenExpandHold = Tween<double>(begin: MIN_HOLD_VALUE, end: MAX_HOLD_VALUE)
        .animate(
      new CurvedAnimation(
          parent: holdController,
          curve: new Interval(
            0.000,
            1.000,
            curve: Curves.easeOutCubic,
          ),
          reverseCurve: Curves.fastOutSlowIn
      ),
    );

    _prepareTweenCallback();
  }

  onTapDown(TapDownDetails details) {
    animationState = AnimStates.RUNNING;
    animationController.reset();
    holdController.reset();
    animationController.forward();

    before = DateTime.now();
    after = DateTime.now();
    contactPosition = details.localPosition;
    maxEpselent = 0;
    maxDistance = 0;
    minDistance = 0;
    minEpselent = 0;

  }

  onMove(DragUpdateDetails details, BuildContext context) {
    animationState = AnimStates.RUNNING;
    var distance = hypot(details.localPosition.dx - contactPosition.dx,
        details.localPosition.dy - contactPosition.dy);
    double maxRadius = hypot(context.size?.width, context.size?.height);
    fractionReverse = distance / maxRadius;
    callback.onAnimationUpdate();
    
    trackPath(fractionReverse);
  }

  double hypot(double? x, double? y) {
    if(y == null || x == null) {
      return 0;
    }
    return sqrt(x * x + y * y);
  }

  trackPath(double distance) {
    after = DateTime.now();
    diff = after.difference(before).inMilliseconds;
    if(diff >= 100) {
      before = after;
      callback.onEventIssue( distance, diff );
    }
  }

  void detectUp(double distance) {
    if( distance >= maxDistance ) {
      maxDistance = distance;
      maxEpselent = distance * 0.85;
    } else if( distance < maxEpselent ) {
      after = DateTime.now();
      diff = after.difference(before).inMilliseconds;
      before = after;
      callback.onEventIssue( maxDistance, diff );
      minDistance = maxDistance;
      minEpselent = maxDistance * 0.15;
      upTrend = false;
    }
  }

  void detectDown(double distance) {
    if( distance <= minDistance ) {
      minDistance = distance;
    } else if( distance > minEpselent ) {
      after = DateTime.now();
      diff = after.difference(before).inMilliseconds;
      before = after;
      callback.onEventIssue( minDistance, diff );
      maxDistance = 0;
      maxEpselent = 0;
      upTrend = true;
    }
  }

  onLongMove(LongPressMoveUpdateDetails details, BuildContext context) {
    animationState = AnimStates.RUNNING;
    var distance = hypot(details.localPosition.dx - contactPosition.dx,
        details.localPosition.dy - contactPosition.dy);
    double maxRadius = hypot(context.size?.width, context.size?.height);
    fractionReverse = distance / maxRadius;
    callback.onAnimationUpdate();
  }

  onTapUp() {
    callback.onAnimationComplete();
    animationState = AnimStates.COMPLETED;
    holdController.reset();
  }

  onSocketDown() {
    animationController.reset( );
    animationController.forward( );
  }

  _prepareTweenCallback() {

    tweenFadeCallback = () {
      alpha = tweenFade.value.toInt();
      alphaReverse = tweenFadeReverse.value.toInt();
      callback.onAnimationUpdate();
    };

    tweenExpandCallback = () {
      fractionTouch = tweenExpand.value;
      fractionReverse = tweenExpandReverse.value;
      callback.onAnimationUpdate();
    };

    animationControllerStatusListener = (status) {
      if (status == AnimationStatus.completed) {
        if(animationState == AnimStates.RUNNING) {
          holdController.forward();
        }
      } else if (status == AnimationStatus.dismissed) {
      }
    };

    tweenHoldCallback = () {
      fractionReverse = tweenExpandHold.value;
      callback.onAnimationUpdate();
    };

    holdControllerStatusListener = (status) async {
      if(animationState != AnimStates.RUNNING) {
        return;
      }
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(milliseconds: INHALE_DELAY), () => loopReverse());
      } else if (status == AnimationStatus.dismissed) {
        await Future.delayed(Duration(milliseconds: EXHALE_DELAY), () => loopForward());
      }
    };

    animationController
      ..addListener(tweenExpandCallback)
      ..addListener(tweenFadeCallback);
    holdController.addListener(tweenHoldCallback);

    animationController.addStatusListener(animationControllerStatusListener);
    holdController.addStatusListener(holdControllerStatusListener);

  }

  loopReverse() {
    holdController.reverse();
  }
  loopForward() {
    holdController.forward();
  }

  dispose() {
    animationController.dispose();
    holdController.dispose();
  }
}

abstract class ControllerCallback {
  void onAnimationUpdate();
  void onAnimationComplete();
  void onEventIssue(double radius, int velocity);
}

enum AnimStates { NOT_STARTED, RUNNING, COMPLETED, CANCELLING }