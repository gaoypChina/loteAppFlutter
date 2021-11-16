import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';

class MySubtitle extends StatefulWidget {
  final String title;
  final double fontSize;
  final EdgeInsets padding;
  final FontWeight fontWeight;
  final double letterSpacing;
  final bool showOnlyOnSmall;
  final bool showOnlyOnLarge;
  final MainAxisAlignment mainAxisAlignment;
  final Color color;
  MySubtitle({Key key, @required this.title, this.fontSize = 20, this.fontWeight = FontWeight.w500, this.padding = const EdgeInsets.only(bottom: 15, top: 15), this.letterSpacing = 0.3, this.showOnlyOnSmall = false, this.showOnlyOnLarge = false, this.mainAxisAlignment = MainAxisAlignment.start, this.color}) : super(key: key);
  @override
  _MySubtitleState createState() => _MySubtitleState();
}

class _MySubtitleState extends State<MySubtitle> {
  _screen(context){
    if(widget.showOnlyOnSmall){
      if(!Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
        return SizedBox.shrink();
    }

    if(widget.showOnlyOnLarge){
      if(Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
        return SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      children: [
        Padding(
          padding: widget.padding,
          child: Text(widget.title, style: TextStyle(fontSize: widget.fontSize, fontWeight: widget.fontWeight, fontFamily: "GoogleSans", letterSpacing: widget.letterSpacing, color: widget.color),),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _screen(context);
  }
}