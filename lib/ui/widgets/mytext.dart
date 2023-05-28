import 'package:flutter/material.dart';

class MyText extends StatefulWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  const MyText({key, @required this.title, this.fontSize = 14, this.fontWeight});

  @override
  State<MyText> createState() => _MyTextState();
}

class _MyTextState extends State<MyText> {
  @override
  Widget build(BuildContext context) {
     var brightness = MediaQuery.of(context).platformBrightness;
    return Text(widget.title, style: TextStyle(fontSize: widget.fontSize, color: _getColor(brightness), fontWeight: widget.fontWeight),);
  }

  _getColor(brightness) {
    // return brightness == Brightness.light ? Colors.black : Colors.white;
    return  Colors.black;
  }
}