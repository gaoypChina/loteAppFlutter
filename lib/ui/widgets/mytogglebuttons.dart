import 'package:flutter/material.dart';
import 'package:loterias/ui/widgets/myscrollbar.dart';
class MyToggleData{
  final value;
  final child;
  MyToggleData({@required this.value, @required this.child});
}


class MyToggleButtons extends StatefulWidget {
  final List<MyToggleData> items;
  final List<MyToggleData> selectedItems;
  final Function(dynamic) onTap;
  MyToggleButtons({Key key, this.items, this.selectedItems, @required this.onTap}) : super(key: key);
  @override
  _MyToggleButtonsState createState() => _MyToggleButtonsState();
}

class _MyToggleButtonsState extends State<MyToggleButtons> {
  List<bool> isSelected;

  _init(){
    if(widget.items == null)
      return;

    isSelected = List.generate(widget.items.length, (index) => false);
  }

  _selectItems(){
    if(widget.selectedItems == null){
      isSelected = List.generate(widget.items.length, (index) => false);
      return;
    }
    if(widget.selectedItems.length == 0){
      isSelected = List.generate(widget.items.length, (index) => false);
      return;
    }

    isSelected = List.generate(widget.items.length, (index) => false);
    for (var item in widget.selectedItems) {
      int idx = widget.items.indexWhere((element) => element.value == item.value);
      if(idx != -1)
        isSelected[idx] = !isSelected[idx];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _init();
    _selectItems();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyToggleButtons oldWidget) {
    // TODO: implement didUpdateWidget
    if(oldWidget.selectedItems != widget.selectedItems){
      _selectItems();
    }
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return MyScrollbar(
      direction: Axis.horizontal,
      child: ToggleButtons(
        borderColor: Colors.grey,
        
        // fillColor: Colors.grey,
        // borderWidth: 2,
        // selectedBorderColor: Colors.black,
        // selectedColor: Colors.white,
        borderWidth: 0.5,
        
        
        // selectedColor: Colors.pink,
        // selectedBorderColor: Colors.black,
        fillColor: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
        constraints: BoxConstraints(minHeight: 34, minWidth: 48),
        children: 
        widget.items.map((e) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: e.child is Widget ? e.child : Text(e.child,),
        )).toList(),
        // listaLoteria.map((e) => Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
        //   child: Text(e.descripcion, style: TextStyle(fontWeight: FontWeight.w600),),
        // )).toList(),
        // children: [Text("Hola"), Text("Hola")],
        onPressed: (int index) {
            // setState(() {
            // // for (int i = 0; i < isSelected.length; i++) {
            // //     isSelected[i] = i == index;
            // // }
            // isSelectedLoteria[index] = !isSelectedLoteria[index];
            // });
          widget.onTap(widget.items[index].value);
        },
        isSelected: isSelected,
      ),
    );
          
  }
}