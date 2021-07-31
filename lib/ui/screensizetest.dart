import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenSizeTest extends StatefulWidget {
  @override
  _ScreenSizeTestState createState() => _ScreenSizeTestState();
}

class _ScreenSizeTestState extends State<ScreenSizeTest> {

  _rotate(){
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);
  }
  _normal(){
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
    ]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: LayoutBuilder(
        builder: (context, boxconstraints) {
          return Center(child: Column(
            children: [
              Text("${boxconstraints.maxWidth}", style: TextStyle(fontSize: 20),),
              TextButton(onPressed: _rotate, child: Text("Rotate")),
              TextButton(onPressed: _normal, child: Text("Normal")),
            ],
          ));
        }
      )),
    );
  }
}