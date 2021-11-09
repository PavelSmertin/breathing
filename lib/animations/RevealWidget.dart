import 'package:flutter/material.dart';
import 'package:miracle/animations/RevealState.dart';


class RevealWidget extends StatefulWidget{
  Widget child;

  RevealWidget(this.child);

  @override
  State<StatefulWidget> createState() {
    return RevealState(child);
  }

}