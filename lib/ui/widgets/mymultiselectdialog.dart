import 'package:flutter/material.dart';

//https://stackoverflow.com/questions/51975690/is-there-an-equivalent-widget-in-flutter-to-the-select-multiple-element-in-htm

class MyMultiSelectDialogItem<V> {
  const MyMultiSelectDialogItem(this.value, this.label, {this.unSelectOthersItems = false});

  final V value;
  final dynamic label;
  final unSelectOthersItems;
}

class MyMultiSelectDialog<V> extends StatefulWidget {
  MyMultiSelectDialog({Key key, this.items, this.initialSelectedValues}) : super(key: key);

  final List<MyMultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MyMultiSelectDialogState<V>();
}

class _MyMultiSelectDialogState<V> extends State<MyMultiSelectDialog<V>> {
  final _selectedValues = Set<V>();
  bool _unSelectOthersItems = false;
  var _itemValueDoNotUnSelect = 0;

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(MyMultiSelectDialogItem item, bool checked) {
    setState(() {
      if (checked) {
        if(item.unSelectOthersItems){
          _unSelectOthers(item);
        }else{
          _unSelectNomoverNocopiar();
        }
          
        _selectedValues.add(item.value);
      } else {
        if(item.unSelectOthersItems){
          _clearUnSelect();
        }
        _selectedValues.remove(item.value);
      }
    });
  }

  void _unSelectOthers(MyMultiSelectDialogItem item){
    setState((){
        _unSelectOthersItems = true;
        _itemValueDoNotUnSelect = item.value;
        _selectedValues.clear();
    });
  }

  void _unSelectNomoverNocopiar(){
    var items = widget.items.where((element) => element.label == "- NO COPIAR -" || element.label == "- NO MOVER -").toList();
    items.forEach((element) {
      _selectedValues.remove(element.value);
    });
  }

  void _clearUnSelect(){
    setState((){
        _unSelectOthersItems = false;
        _itemValueDoNotUnSelect = 0;
    });
  }

  bool _blockItem(MyMultiSelectDialogItem item){
    print("MyMultiselectDialogItem: ${_unSelectOthersItems == true && _itemValueDoNotUnSelect != item.value}");
    return _unSelectOthersItems == true && _itemValueDoNotUnSelect != item.value;
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text('Select loterias'),
          contentPadding: EdgeInsets.only(top: 12.0),
          content: SingleChildScrollView(
            child: ListTileTheme(
              contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
              child: ListBody(
                children: widget.items.map(_buildItem).toList(),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: _onCancelTap,
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: _onSubmitTap,
            )
          ],
        );
      }
    );
  }

  Widget _buildItem(MyMultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      activeColor: Colors.blue,
      dense: true,
      value: checked,
      title: (item.label is Widget) ? item.label : Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item, checked),
    );
  }
}