import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';

class MyDivider extends StatelessWidget {
  final EdgeInsets padding;
  final Color color;
  final double thickness;
  final double height;
  final bool showOnlyOnSmall;
  MyDivider({Key key, this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 10.0), this.color, this.thickness = 0.9, this.height = 1, this.showOnlyOnSmall = false}) : super(key: key);

  _screen(context){
    if(showOnlyOnSmall){
      if(!Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
        return SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: Divider(color: color == null ? Colors.grey.shade300 : color, thickness: thickness, height: height,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _screen(context);
  }
}