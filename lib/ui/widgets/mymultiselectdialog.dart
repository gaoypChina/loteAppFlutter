import 'package:flutter/material.dart';

//https://stackoverflow.com/questions/51975690/is-there-an-equivalent-widget-in-flutter-to-the-select-multiple-element-in-htm

class MyMultiselectType {
  const MyMultiselectType._(this.index);

  /// The encoded integer value of this font weight.
  final int index;

  /// Thin, the least thick
  static const MyMultiselectType dialog = MyMultiselectType._(0);

  /// Extra-light
  static const MyMultiselectType overlay = MyMultiselectType._(1);

  /// A list of all the font weights.
  static const List<MyMultiselectType> values = <MyMultiselectType>[
    dialog, overlay
  ];
}

class MyMultiSelectDialogItem<V> {
  const MyMultiSelectDialogItem(this.value, this.label, {this.unSelectOthersItems = false});

  final V value;
  final dynamic label;
  final unSelectOthersItems;
}

class MyMultiSelectDialog<V> extends StatefulWidget {
  MyMultiSelectDialog({Key key, this.items, this.initialSelectedValues, this.type = MyMultiselectType.dialog, this.boxConstraints, this.controlAffinity = ListTileControlAffinity.leading}) : super(key: key);

  final List<MyMultiSelectDialogItem<V>> items;
  final List<V> initialSelectedValues;
  final MyMultiselectType type;
  final BoxConstraints boxConstraints;
  final controlAffinity;

  @override
  State<StatefulWidget> createState() => MyMultiSelectDialogState<V>();
}

class MyMultiSelectDialogState<V> extends State<MyMultiSelectDialog<V>> {
  final List<V> _selectedValues = [];
  bool _unSelectOthersItems = false;
  var _itemValueDoNotUnSelect = 0;
  ScrollController _scrollController;

  void initState() {
    super.initState();
    _scrollController = ScrollController();
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

  Widget _dataScreen(){
   return Container(
    //  height: widget.height,
    constraints: widget.boxConstraints,
     child: Scrollbar(
       controller: _scrollController,
       isAlwaysShown: widget.type != MyMultiselectType.dialog,
       child: SingleChildScrollView(
         controller: _scrollController,
            child: ListTileTheme(
              contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
              child: ListBody(
                children: widget.items.map(_buildItem).toList(),
              ),
            ),
          ),
     ),
   );
  }

  Widget _screen(){
    return 
    widget.type == MyMultiselectType.dialog
    ?
    AlertDialog(
      title: Text('Select loterias'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: _dataScreen(),
      actions: <Widget>[
        TextButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        TextButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    )
    :
    _dataScreen()
    ;
  }

  List<V> getValues(){
    return _selectedValues;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return _screen();
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
      controlAffinity: widget.controlAffinity,
      onChanged: (checked) => _onItemCheckedChange(item, checked),
    );
  }
}