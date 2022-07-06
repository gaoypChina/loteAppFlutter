import 'package:flutter/material.dart';

class MyValue<T>{
  final T value;
  final dynamic child;
  MyValue({@required this.value, @required this.child});
}

class MyMultiselect<T> extends StatefulWidget {
  final dynamic title;
  final dynamic subtitle;
  final List<MyValue<T>> items;
  final List<MyValue<T>> initialSelectedItems;
  MyMultiselect({Key key, @required this.title, this.subtitle, this.items = const [], this.initialSelectedItems = const []}) : super(key: key);
  @override
  _MyMultiselectState<T> createState() => _MyMultiselectState<T>();
}

class _MyMultiselectState<T> extends State<MyMultiselect<T>> {
  // List<MyValue<T>> widget.initialSelectedItems = [];

  _subtitle(){
    return Visibility(visible: widget.subtitle != null, child: widget.subtitle != null ? widget.subtitle  is Widget ? widget.subtitle : Text("${widget.subtitle}", style: TextStyle(color: Colors.grey, fontSize: 12),) : Text(""));
  }

  _title(dynamic data){
    print("MyMultiSelect $data");
    if(data is Widget){
      if(widget.subtitle == null)
        return data;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          data,
          _subtitle()
        ],
      );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$data",),
          _subtitle()
        ],
      );
    }
  }

  _listTileTitle(dynamic data){
    print("MyMultiSelect $data");
    if(data is Widget){
        return data;
    }else{
      return Text("$data",);
    }
  }

  _onChanged(bool value, MyValue<T> data){
    print("MyMultiSelect onChanged: ${data.runtimeType}");
    if(value == false){
      if(widget.initialSelectedItems.length == 0)
        return;

      setState(() => widget.initialSelectedItems.removeWhere((element) => element.value == data.value));
    }else{
      if(widget.initialSelectedItems.firstWhere((element) => element.value == data.value, orElse: () => null) == null)
        setState(() => widget.initialSelectedItems.add(data));
    }
  }

  _selected(dynamic value){
    if(widget.initialSelectedItems.length == 0)
      return false;

    print("MyMultiSelect length: ${widget.initialSelectedItems.length} _selected ${value.descripcion}: ${widget.initialSelectedItems.firstWhere((element) => element.value == value, orElse: () => null) != null}");
    return widget.initialSelectedItems.firstWhere((element) => element.value == value, orElse: () => null) != null;
  }

  @override
  void initState() {
    // TODO: implement initState
    // if(widget.initialSelectedItems.length > 0)
    //   widget.initialSelectedItems = widget.initialSelectedItems;
      
    super.initState();
  }

  _seleccionarTodos(){
    var selectedItems = [];
    if(widget.items == null)
      return;
    if(widget.items.length == 0)
      return;

    

    setState((){
      for (var item in widget.items) {
        if(widget.initialSelectedItems.firstWhere((element) => element == item, orElse: () => null) == null)
          widget.initialSelectedItems.add(item);
      }
    });
  }

  _limpiar(){
    setState(() => widget.initialSelectedItems.clear());
  }

  _back(){
    var lista = widget.initialSelectedItems != null ? widget.initialSelectedItems.map<T>((e) => e.value).toList() : [];
    print("MyMultiSelect _back runtimeType: ${widget.initialSelectedItems.runtimeType}");
    Navigator.pop<List<T>>(context, widget.initialSelectedItems.map<T>((e) => e.value).toList());
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: _title(widget.title),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map((e) => CheckboxListTile(title: _listTileTitle(e.child), value: _selected(e.value), onChanged: (value){_onChanged(value, e);})).toList(),
          ),
        ),
      ),
      actions: [
        // Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: _limpiar, child: Text("Limpiar", style: TextStyle(color: Colors.pink),))),
        TextButton(onPressed: _limpiar, child: Text("Limpiar", style: TextStyle(color: Colors.pink),)),
        TextButton(onPressed: _seleccionarTodos, child: Text("Todos")),
        TextButton(onPressed: _back, child: Text("Ok")),
      ],
    );
  }
}