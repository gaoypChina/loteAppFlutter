import 'package:flutter/material.dart';

class MySubtitle extends StatefulWidget {
  final String title;
  final double fontSize;
  final EdgeInsets padding;
  final FontWeight fontWeight;
  final double letterSpacing;
  MySubtitle({Key key, @required this.title, this.fontSize = 20, this.fontWeight = FontWeight.w500, this.padding = const EdgeInsets.only(bottom: 15, top: 15), this.letterSpacing = 0.3}) : super(key: key);
  @override
  _MySubtitleState createState() => _MySubtitleState();
}

class _MySubtitleState extends State<MySubtitle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: widget.padding,
          child: Text(widget.title, style: TextStyle(fontSize: widget.fontSize, fontWeight: widget.fontWeight, fontFamily: "GoogleSans", letterSpacing: widget.letterSpacing),),
        ),
      ],
    );
  }
}