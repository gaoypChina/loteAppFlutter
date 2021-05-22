import 'package:flutter/material.dart';

class MyRichText extends StatefulWidget {
  final String text;
  final String boldText;
  final Color boldTextColor;

  MyRichText({Key key, this.text, this.boldText, this.boldTextColor = Colors.black}) : super(key: key);
  @override
  _MyRichTextState createState() => _MyRichTextState();
}

class _MyRichTextState extends State<MyRichText> {

  _style(){
    return widget.boldTextColor != null ? TextStyle(color: widget.boldTextColor, fontSize: 18, fontWeight: FontWeight.w600) : TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  }
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: "GoogleSans"),
        children: [
          TextSpan(text: widget.text),
          TextSpan(text: widget.boldText, style: _style())
        ]
      )
    );
  }
}