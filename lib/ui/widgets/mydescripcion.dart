import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';

class MyDescripcon extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  MyDescripcon({Key key, @required this.title, this.fontSize = 13, this.color, this.fontWeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontSize: fontSize, color: color != null ? color : Utils.fromHex("#5f6368"), fontFamily: "GoogleSans", fontWeight: fontWeight, letterSpacing: 0.2),);
  }
}