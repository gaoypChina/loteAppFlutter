import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';

class MyDescripcon extends StatelessWidget {
  final String title;
  final double fontSize;
  MyDescripcon({Key key, @required this.title, this.fontSize = 13}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontSize: fontSize, color: Utils.fromHex("#5f6368"), fontFamily: "GoogleSans", letterSpacing: 0.2),);
  }
}