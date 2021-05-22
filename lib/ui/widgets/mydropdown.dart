import 'package:flutter/material.dart';

import 'myresizecontainer.dart';
import 'myscrollbar.dart';


class MyDropdown extends StatefulWidget {
  final String title;  
  final Function onTap; 
  final String hint; 
  final List<List<dynamic>> elements;
  final bool enabled;

  final double small;
  final double medium;
  final double large;
  final double xlarge;

  final EdgeInsets padding;
  final dynamic leading;
  final bool isFlat;

  MyDropdown({Key key, @required this.title, this.onTap, this.hint, this.elements, this.small = 1, this.medium = 3, this.large = 4, this.xlarge = 3.9, this.padding = const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15, right: 15), this.leading, this.isFlat = false, this.enabled = true}) : super(key: key);
  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  OverlayEntry _overlayEntry;
  String hint;


  OverlayEntry _createOverlayEntry2() {

    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        // left: offset.dx + widget.padding,
        // top: offset.dy + size.height - widget.padding,
        // width: size.width - (widget.padding * 2),
        // width: getWidth(size.width) - (widget.padding * 2),
        left: offset.dx + (widget.padding.left),
        top: offset.dy + size.height,
        width: size.width - (widget.padding.left + widget.padding.right),
        child:
        Material(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          elevation: 6,
          child: _dropdownItemScreen(),
        )
        //  Material(
        //   elevation: 4.0,
        //   child: ListView(
        //     padding: EdgeInsets.zero,
        //     shrinkWrap: true,
        //     children: <Widget>[
        //       ListTile(
        //         title: Text('Syria'),
        //       ),
        //       ListTile(
        //         title: Text('Lebanon'),
        //       )
        //     ],
        //   ),
        // ),
      )
    );
  }

  _dropdownItemScreen(){
    return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      // border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),
      boxShadow: [
        BoxShadow(
          color: Colors.grey[50],
          // spreadRadius: 2,
          blurRadius: 2,
          offset: Offset(0, 2.0), // changes position of shadow
        ),
      ],
    ),
    child: 
    
    MyScrollbar(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.elements.map((e) {
          var firstDataToReturnOnChanged = e.first;
         
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){_selectDataAndClose(firstDataToReturnOnChanged, e[1]);},
              child: Row(
                children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${e[1]}", style: TextStyle(fontFamily: "GoogleSans", fontSize: 17, fontWeight: FontWeight.w300),),
                  )),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ),
    );
  }

  
  _selectDataAndClose(dynamic data, String hintData){
    if(this._overlayEntry != null){
      this._overlayEntry.remove();
      this._overlayEntry = null;
    }
    setState(() => hint = hintData);
    widget.onTap(data);
  }

  textChanged() async {
    // print("textChanged ${data.isEmpty} ${this._overlayEntry == null}");
        if(this._overlayEntry == null){
          this._overlayEntry = this._createOverlayEntry2();
          Overlay.of(context).insert(this._overlayEntry);
          // List<String> resultados = lista.where((element) => element.toLowerCase().indexOf(data) != -1).toList();
        }
    // setState(() => _tieneFoco = _myFocus.hasFocus);
  }

  _getDecoration(){
    return (widget.isFlat) 
    ? 
    null 
    : 
    BoxDecoration(
      color: widget.enabled ? Colors.blue.withOpacity(0.15) : Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(5)
    );
  }

  _getRow(){
    return (widget.isFlat) 
    ? 
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child:  (widget.leading == false) ? Text("${hint == null ?  'No hay datos' : hint}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GoogleSans", color: widget.enabled ? Theme.of(context).primaryColorDark : Colors.grey, fontWeight: FontWeight.w700)) : Center(child: Text("${hint == null ?  'No hay datos' : hint}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GoogleSans", color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.w700)))
        ),
        // Icon(Icons.arrow_drop_down, color: Utils.fromHex("#1967d2")),
        Icon(Icons.arrow_drop_down, color: Theme.of(context).primaryColorDark),
      ],
    ) 
    : 
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (widget.leading == false) ? SizedBox() : (widget.leading != null) ? widget.leading : Icon(Icons.calendar_today_outlined, color: widget.enabled ? Theme.of(context).primaryColorDark : Colors.grey,),
        Expanded(
          child:  (widget.leading == false) ? Text("${hint == null ?  'No hay datos' : hint}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GoogleSans", color: widget.enabled ? Theme.of(context).primaryColorDark : Colors.grey, fontWeight: FontWeight.w700)) : Center(child: Text("${hint == null ?  'No hay datos' : hint}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GoogleSans", color: widget.enabled ? Theme.of(context).primaryColorDark : Colors.grey, fontWeight: FontWeight.w700)))
        ),
        // Icon(Icons.arrow_drop_down, color: widget.enabled ? Utils.fromHex("#1967d2") : Colors.grey),
        Icon(Icons.arrow_drop_down, color: widget.enabled ? Theme.of(context).primaryColorDark : Colors.grey),
      ],
    );
  }

  _normalScreen(){
    return MyResizedContainer(
      xlarge: widget.xlarge,
      large: widget.large,
      medium: widget.medium,
      small: widget.small,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(visible: widget.title != null, child: Text("${(widget.title == null) ? '' : widget.title}", style: TextStyle(fontFamily: "GoogleSans"),)),
          InkWell(
            onTap: (){
              if(widget.elements == null && widget.enabled)
                widget.onTap();
              else{
                print("Mydropdown inside Inkwell");
                textChanged();
              }
            },
            child: Container(
              padding: widget.padding,
              decoration: _getDecoration(),
              child: _getRow(),
            ),
          ),
        ],
      ),
    );
  }

  _sideScreen(){

  }

  @override
  void initState() {
    // TODO: implement initState
    hint = widget.hint;
    super.initState();
  }

  @override
  void didUpdateWidget(dynamic oldWidget) {
    if (oldWidget.hint != widget.hint) {
      hint = widget.hint;
    }
    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    return _normalScreen();
  }
}