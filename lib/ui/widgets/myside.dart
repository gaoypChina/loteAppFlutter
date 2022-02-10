import 'package:flutter/material.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';

class MySide extends StatefulWidget {
  final double flexOfSideFirstWidget;
  final double flexOfSideSecondWidget;
  final bool isVertical;
  final Widget first;
  final Widget second;

  final double small;
  final double medium;
  final double large;
  final double xlarge;

  const MySide({ Key key, this.first, this.second, this.flexOfSideFirstWidget = 3, this.flexOfSideSecondWidget = 1.5, this.isVertical = false, this.small = 1, this.medium = 1.35, this.large = 1.35, this.xlarge = 1.35,}) : super(key: key);
  

  @override
  _MySideState createState() => _MySideState();
}

class _MySideState extends State<MySide> {

  Widget _firstWidget([double width]){
    return 
    widget.isVertical
    ?
    widget.first
    :
    Container(
      width: width / widget.flexOfSideFirstWidget,
      child: widget.first,
    );
  }
  Widget _secondWidget([double width]){
    return 
    widget.isVertical
    ?
    widget.second
    :
    Container(
      width: width / widget.flexOfSideSecondWidget,
      child: widget.second,
    );
  }
  @override
  Widget build(BuildContext context) {
    return MyResizedContainer(
      small: widget.small,
      medium: widget.medium,
      large: widget.large,
      xlarge: widget.xlarge,
      builder: (context, width){
        return 
        widget.isVertical
        ?
        Column(
          children: [
            _firstWidget(),
            _secondWidget()
          ],
        )
        :
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _firstWidget(width),
            _secondWidget(width),
          ],
        );
        
      },
    );
  }
}