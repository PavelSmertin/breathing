import 'package:flutter/material.dart';

import 'animations/RevealWidget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'miracle',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Nunito',
        ),
        home: Stack(children: <Widget>[
          RevealWidget(Container(
              color: Colors.white12,
              child: Align(
                alignment: Alignment.center,
              )))
        ]));
  }
}
