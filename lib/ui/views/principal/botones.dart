import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PruebaScreen extends StatefulWidget {
  @override
  _PruebaScreenState createState() => _PruebaScreenState();
}

class _PruebaScreenState extends State<PruebaScreen> {

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(minHeight: 100, maxHeight: MediaQuery.of(context).size.height / 4 + 100),
              child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(color: Colors.red,),
                ),
                Expanded(
                  child: Container(color: Colors.blue,),
                ),
                Expanded(
                  child: Container(color: Colors.green,),
                ),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}