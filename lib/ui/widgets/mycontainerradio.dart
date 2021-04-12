import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';

class MyContainerRadio extends StatefulWidget {
  final bool selected;
  final Function onTap;
  MyContainerRadio({Key key, this.selected = false, @required this.onTap}) : super(key: key);
  @override
  _MyContainerRadioState createState() => _MyContainerRadioState();
}

class _MyContainerRadioState extends State<MyContainerRadio> {
  bool _selected = false;
  _init(){
    _selected = widget.selected;
  }
  @override
  void initState() {
    // TODO: implement initState
    _init();
    super.initState();
  }
  
  // @override
  // void didUpdateWidget(dynamic oldWidget) {
  //   if(oldWidget.selected != widget.selected){
  //     _init();
  //   }

  //   super.didUpdateWidget(oldWidget);
  // }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          // setState(() {
          //   _selected = !_selected;
          // });
          widget.onTap(!widget.selected);
        },
        child: 
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: widget.selected ? Colors.blue[700] : null,  
            border: !widget.selected ? Border.all(color: Colors.black26) : null,
            borderRadius: BorderRadius.circular(12.5)
          ),
          child: Center(
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
              color: widget.selected ? Colors.white : null,
              borderRadius: BorderRadius.circular(4)
            ),
            ),
          ),
        )
      //   AnimatedContainer(
      //   padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      //   duration: Duration(milliseconds: 200),
      //   decoration: BoxDecoration(
      //     color: _selected ? Utils.colorPrimary : Colors.transparent,
      //     border: Border.all(color: Utils.colorPrimary),
      //     borderRadius: BorderRadius.circular(20)
      //   ),
      //   child: Text(widget.data[1], style: TextStyle(fontWeight: FontWeight.w700, color: _selected ? Colors.white : Utils.colorPrimary),),
      // ),
    );
  }
}
