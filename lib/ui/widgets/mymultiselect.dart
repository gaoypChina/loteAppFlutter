import 'package:flutter/material.dart';

class MyValue{
  final dynamic value;
  final dynamic child;
  MyValue({@required this.value, @required this.child});
}

class MyMultiselect extends StatefulWidget {
  final dynamic title;
  final List<MyValue> items;
  final List<MyValue> initialSelectedItems;
  MyMultiselect({Key key, @required this.title, this.items = const [], this.initialSelectedItems = const []}) : super(key: key);
  @override
  _MyMultiselectState createState() => _MyMultiselectState();
}

class _MyMultiselectState extends State<MyMultiselect> {
  List<MyValue> _selectedItems = [];

  _title(dynamic data){
    print("MyMultiSelect $data");
    if(data is Widget)
      return data;
    else
      return Text("$data",);
  }

  _onChanged(bool value, data){
    if(value == false){
      if(_selectedItems.length == 0)
        return;

      setState(() => _selectedItems.removeWhere((element) => element.value == data.value));
    }else{
      if(_selectedItems.firstWhere((element) => element.value == data.value, orElse: () => null) == null)
        setState(() => _selectedItems.add(data));
    }
  }

  _selected(dynamic value){
    if(_selectedItems.length == 0)
      return false;

    print("MyMultiSelect length: ${_selectedItems.length} _selected ${value.descripcion}: ${_selectedItems.firstWhere((element) => element.value == value, orElse: () => null) != null}");
    return _selectedItems.firstWhere((element) => element.value == value, orElse: () => null) != null;
  }

  @override
  void initState() {
    // TODO: implement initState
    if(widget.initialSelectedItems.length > 0)
      _selectedItems = widget.initialSelectedItems;
      
    super.initState();
  }

  _seleccionarTodos(){
    var selectedItems = [];
    if(widget.items == null)
      return;
    if(widget.items.length == 0)
      return;

    setState(() => _selectedItems = widget.items);
  }

  _limpiar(){
    setState(() => _selectedItems = []);
  }

  _back(){
    Navigator.pop(context, _selectedItems != null ? _selectedItems.map((e) => e.value).toList() : []);
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _title(widget.title),
      content: SingleChildScrollView(
        child: Column(
          children: widget.items.map((e) => CheckboxListTile(title: _title(e.child), value: _selected(e.value), onChanged: (value){_onChanged(value, e);})).toList(),
        ),
      ),
      actions: [
        // Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: _limpiar, child: Text("Limpiar", style: TextStyle(color: Colors.pink),))),
        TextButton(onPressed: _limpiar, child: Text("Limpiar", style: TextStyle(color: Colors.pink),)),
        TextButton(onPressed: _seleccionarTodos, child: Text("Selec. todos")),
        TextButton(onPressed: _back, child: Text("Ok")),
      ],
    );
  }
}