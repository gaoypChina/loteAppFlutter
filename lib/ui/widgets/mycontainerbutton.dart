import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';

class MyContainerButton extends StatefulWidget {
  final bool selected;
  final Function onTap;
  final List data;
  final EdgeInsets padding;
  final Color textColor;
  final Color borderColor;
  final IconData icon;
  final Widget trailing;
  final Color iconColor;
  MyContainerButton({Key key, this.selected = false, @required this.data, @required this.onTap, this.trailing, this.padding = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), this.textColor, this.borderColor, this.icon, this.iconColor}) : super(key: key);
  @override
  _MyContainerButtonState createState() => _MyContainerButtonState();
}

class _MyContainerButtonState extends State<MyContainerButton> {
  bool _selected = false;
  Color _textColor;
  Color _borderColor;
  Color _iconColor;

  _init(){
    _selected = widget.selected;
    _textColor = widget.textColor != null ? widget.textColor : Utils.colorPrimary;
    _borderColor = widget.borderColor != null ? widget.borderColor : Utils.colorPrimary;
    _iconColor = widget.borderColor != null ? widget.borderColor : Utils.colorPrimary;
  }
  @override
  void initState() {
    // TODO: implement initState
    _init();
    super.initState();
  }
  
  @override
  void didUpdateWidget(dynamic oldWidget) {
    if(oldWidget.selected != widget.selected || oldWidget.textColor != widget.textColor || oldWidget.borderColor != widget.borderColor){
      _init();
    }

    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          // setState(() {
          //   _selected = !_selected;
          // });
          widget.onTap(widget.data[0]);
        },
        child: AnimatedContainer(
        padding: widget.padding,
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.selected ? Utils.colorPrimary : Colors.transparent,
          border: Border.all(color: _borderColor),
          borderRadius: BorderRadius.circular(20)
        ),
        child: 
        (widget.icon == null && widget.trailing == null)
        ?
        Text(widget.data[1], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: widget.selected ? Colors.white : _textColor),)
        :
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text(widget.data[1], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: widget.selected ? Colors.white : _textColor),),
          Visibility(visible: widget.icon != null, child: Icon(widget.icon != null ? widget.icon : Icons.add, color: _iconColor, size: 18,)),
          Visibility(visible: widget.trailing != null, child: widget.trailing != null ? widget.trailing : SizedBox.shrink())
        ],)
      ),
    );
  }
}