import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';

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
  final bool isSideTitle;

  final double flexOfSideText;
  final double flexOfSideField;
  final bool showOnlyOnLarge;
  final Color color;
  final Color textColor;
  MyDropdown({Key key, this.color, this.textColor, @required this.title, this.onTap, this.hint, this.elements, this.small = 1, this.medium = 3, this.large = 4, this.xlarge = 3.9, this.padding = const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15, right: 15), this.leading, this.isFlat = false, this.enabled = true, this.flexOfSideText = 3, this.flexOfSideField = 1.5, this.isSideTitle = false, this.showOnlyOnLarge = false}) : super(key: key);
  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  OverlayEntry _overlayEntry;
  String hint;

  _textColor(){
    return widget.textColor != null ? widget.textColor : Theme.of(context).primaryColor;
  }

  _color(){
    return widget.color != null ? widget.color : Theme.of(context).primaryColorLight.withOpacity(0.4);
  }

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
      // color: widget.enabled ? Colors.blue.withOpacity(0.15) : Colors.grey.withOpacity(0.2),
      color: widget.enabled ?_color() : Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(5)
    );
  }

  _getContentRow(){
    return (widget.isFlat) 
    ? 
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child:  (widget.leading == false) ? Text("${hint == null ?  'No hay datos' : hint}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GoogleSans", color: widget.enabled ? _textColor() : Colors.grey, fontWeight: FontWeight.w700)) : Center(child: Text("${hint == null ?  'No hay datos' : hint}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GoogleSans", color: _textColor(), fontWeight: FontWeight.w700)))
        ),
        // Icon(Icons.arrow_drop_down, color: Utils.fromHex("#1967d2")),
        Icon(Icons.arrow_drop_down, color: _textColor()),
      ],
    ) 
    : 
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (widget.leading == false) ? SizedBox() : (widget.leading != null) ? widget.leading : Icon(Icons.calendar_today_outlined, color: widget.enabled ? _textColor() : Colors.grey,),
        Expanded(
          child:  (widget.leading == false) ? Text("${hint == null ?  'No hay datos' : hint}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GoogleSans", color: widget.enabled ? _textColor() : Colors.grey, fontWeight: FontWeight.w700)) : Center(child: Text("${hint == null ?  'No hay datos' : hint}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GoogleSans", color: widget.enabled ? _textColor() : Colors.grey, fontWeight: FontWeight.w700)))
        ),
        // Icon(Icons.arrow_drop_down, color: widget.enabled ? Utils.fromHex("#1967d2") : Colors.grey),
        Icon(Icons.arrow_drop_down, color: widget.enabled ? _textColor() : Colors.grey),
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
              child: _getContentRow(),
            ),
          ),
        ],
      ),
    );
  }

   _screenWithSideTitle(){

    return MyResizedContainer(
      xlarge: widget.xlarge,
      large: widget.large,
      medium: widget.medium,
      small: widget.small,
      builder: (context, width){
        double widthOfTheWidget = width - (widget.padding.left);
        return Container(
          
          child: Wrap(
          children: [
            Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      // color: Colors.red,
                      width: widthOfTheWidget / widget.flexOfSideText,
                      child: Visibility(visible: widget.title != "",child: Text(widget.title, textAlign: TextAlign.start, style: TextStyle(color: widget.isSideTitle ? Utils.fromHex("#3c4043") : Colors.black, fontSize: 14, fontFamily: "GoogleSans",  letterSpacing: 0.4),)),
                    ),
                  ),
            Container(
              width: widthOfTheWidget / widget.flexOfSideField,
              child: InkWell(
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
                  child: _getContentRow(),
                ),
              ),
            ),
          ],
      ),
        );
      },
    );
    
    // double widthOfTheWidget = getWidth(width) - (widget.padding.left + widget.padding.right);
    // return Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           // Visibility(visible: widget.title != "" && widget.type == MyType.border,child: Text(widget.title, textAlign: TextAlign.start, style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"))),
                  
    //           // Visibility(visible: widget.title != "",child: MyDescripcon(title: "Proximo pago",),),
    //           Container(
    //             // color: Colors.red,
    //             // decoration: BoxDecoration(
    //             //   borderRadius: BorderRadius.circular(10),
    //             //   border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid)
    //             // ),
    //             width: widthOfTheWidget, //El padding se multiplica por dos ya que el padding dado es el mismo para la izquiera y derecha
    //             // height: 50,
    //             child: 
    //             Wrap(children: [
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 10.0),
    //                 child: Container(
    //                   // color: Colors.red,
    //                   width: widthOfTheWidget / widget.flexOfSideText,
    //                   child: Visibility(visible: widget.title != "",child: Text(widget.title, textAlign: TextAlign.start, style: TextStyle(color: widget.isSideTitle ? Utils.fromHex("#3c4043") : Colors.black, fontSize: 14, fontFamily: "GoogleSans",  letterSpacing: 0.4),)),
    //                 ),
    //               ),
    //               Container(
    //                 width: widthOfTheWidget / widget.flexOfSideField,
    //                 child: 
    //                 // (widget.isBlue == false)
    //                 // ?
    //                 // _dropdownBlue(width)
    //                 // :
    //                 // _dropdownNormal(width)  
    //                 _screenDropdownType(width)  
    //               ),
    //             ],)
    //         //     Row(
    //         //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         //       children: [
    //         // Flexible(flex: 2, child: Visibility(visible: widget.title != "" && widget.type == MyType.border,child: Text(widget.title, textAlign: TextAlign.start, style: TextStyle(color: widget.isSideTitle ? Utils.fromHex("#3c4043") : Colors.black, fontSize: 14, fontFamily: "GoogleSans",  letterSpacing: 0.4),))),

    //         //         Flexible(
    //         //           flex: 4,
    //         //           child: Padding(
    //         //             padding: const EdgeInsets.only(top: 15.0),
    //         //             child: Column(
    //         //               crossAxisAlignment: CrossAxisAlignment.start,
    //         //               children: [
    //         //                 // (widget.labelText == "")
    //         //                 // ?
    //         //                 // _textFormFieldWithoutLabel()
    //         //                 // :
    //         //                 // _textFormFieldWithLabel(),
    //         //                 _typeOfTextFormField(),
    //         //                 Visibility(visible: widget.helperText != "",child: Text(widget.helperText, textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12, fontFamily: "GoogleSans", color: Utils.fromHex("#5f6368"), letterSpacing: 1.3))),
    //         //               ],
    //         //             ),
    //         //           ),
    //         //         ),
    //         //       ],
    //         //     )
    //           ),
    //         ],
    //       );
     
          
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

  _screen(){
    if(widget.showOnlyOnLarge){
      if(Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
        return SizedBox.shrink();
    }

    return 
    widget.isSideTitle
    ?
    _screenWithSideTitle()
    :
    _normalScreen();
  }

  @override
  Widget build(BuildContext context) {
    return _screen();
  }
}