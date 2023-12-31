import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/widgets/mycolor.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';

import 'myresizecontainer.dart';
import 'myscrollbar.dart';


class MyDropdown extends StatefulWidget {
  final String title;  
  final Function onTap; 
  final dynamic hint; 
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
  final String helperText;
  final bool onlyBorder;
  final int maxLengthToEllipsis;
  final int topPositionOfOverlay;
  final bool resized;
  final bool isExpanded;
  final double hintFontSize;
  MyDropdown({Key key, this.color, this.textColor, @required this.title, this.onTap, this.hint, this.elements, this.small = 1, this.medium = 3, this.large = 4, this.xlarge = 3.9, this.padding = const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15, right: 15), this.leading = const Icon(Icons.date_range, size: 20, color: MyColors.blue700), this.isFlat = false, this.enabled = true, this.flexOfSideText = 3, this.flexOfSideField = 1.5, this.isSideTitle = false, this.showOnlyOnLarge = false, this.helperText, this.onlyBorder = false, this.maxLengthToEllipsis = 60, this.topPositionOfOverlay, this.resized: true, this.isExpanded: true, this.hintFontSize}) : super(key: key);
  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  OverlayEntry _overlayEntry;
  String hint;

  _textColor(){
    return widget.textColor != null ? widget.textColor : Colors.blue[700];
  }

  _color(){
    return widget.color != null ? widget.color : Theme.of(context).primaryColor.withOpacity(0.2);
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
          child: _dropdownItemScreen(_overlayEntry, 0),
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

  _dropdownItemScreen(OverlayEntry overlay, double width){
    return Container(
      width: width,
      // height: 80,
      constraints: BoxConstraints(maxHeight: 500),
    // decoration: BoxDecoration(
    //   color: Colors.white,
    //   // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
    //   borderRadius: BorderRadius.all(Radius.circular(8)),
    //   // border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),
    //   boxShadow: [
    //     BoxShadow(
    //       color: Colors.grey[50],
    //       // spreadRadius: 2,
    //       blurRadius: 2,
    //       offset: Offset(0, 2.0), // changes position of shadow
    //     ),
    //   ],
    // ),
    child: 
    
    MyScrollbar(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.elements.map((e) {
          var firstDataToReturnOnChanged = e.first;
         
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){_selectDataAndClose(firstDataToReturnOnChanged, e[1], overlay);},
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

  
  _selectDataAndClose(dynamic data, String hintData, OverlayEntry overlay){
    // if(this._overlayEntry != null){
    //   this._overlayEntry.remove();
    //   this._overlayEntry = null;
    // }
    overlay.remove();
    setState(() => hint = hintData);
    widget.onTap(data);
  }

  textChanged(BuildContext context, double width) async {
    // print("textChanged ${data.isEmpty} ${this._overlayEntry == null}");

        // if(this._overlayEntry == null){
        //   this._overlayEntry = this._createOverlayEntry2();
        //   Overlay.of(context).insert(this._overlayEntry);
        //   // List<String> resultados = lista.where((element) => element.toLowerCase().indexOf(data) != -1).toList();
        // }

        RenderBox renderBox = context.findRenderObject();
        var offset = renderBox.localToGlobal(Offset.zero);


        double topPosition = 80;
        double heightOfAnElement = 32;
        //Add 10 additional to heightOfAnElement
        // heightOfAnElement += 10;
        if(widget.elements != null){
          if(widget.elements.length >= 3){
            double heightOfAllElements = heightOfAnElement * widget.elements.length;
            double half = heightOfAllElements / 2;
            topPosition = topPosition + half;
          }
        }

        //Convert topPosition to negative

        double positionOfTheWidgetMinusTopPositionOverlay = (offset.dy - topPosition).abs();
        //Si el calculo es mayor que la position del widget desde donde se llama al overlay, eso quiere decir
        //Que el sliver sobre pasa el appbar, asi que se resta al topPosition el valor sobrante
        print("MyDropdown textChanged dy:${offset.dy} cal: $positionOfTheWidgetMinusTopPositionOverlay - top: $topPosition restante: ${(positionOfTheWidgetMinusTopPositionOverlay - offset.dy)} top: ${topPosition - ((positionOfTheWidgetMinusTopPositionOverlay - offset.dy).abs() + 50)}");
        if(positionOfTheWidgetMinusTopPositionOverlay > offset.dy - 10)
          topPosition = topPosition - ((positionOfTheWidgetMinusTopPositionOverlay - offset.dy).abs() + heightOfAnElement + 10);

        topPosition = topPosition * -1;

        print("MyDropdown textChanged top: $topPosition");

        showMyOverlayEntry(
          context: context, 
          top: widget.topPositionOfOverlay != null ? widget.topPositionOfOverlay : topPosition,
          builder: (context, overlay){
            return _dropdownItemScreen(overlay, width);
          }
        );

    // setState(() => _tieneFoco = _myFocus.hasFocus);
  }

  _getDecoration(){
    return (widget.isFlat) 
    ? 
    null 
    : 
    widget.onlyBorder
    ?
    BoxDecoration(
      // color: widget.enabled ? Colors.blue.withOpacity(0.15) : Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: Colors.black, width: 0.5)
    )
    :
    BoxDecoration(
      // color: widget.enabled ? Colors.blue.withOpacity(0.15) : Colors.grey.withOpacity(0.2),
      color: widget.enabled ?_color() : Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(5),
    );
  }

  String _getText(){
    if(widget.hint is Widget)
      return "";

    String text = hint == null ?  'No hay datos' : hint;
    return text.substring(0, text.length >= widget.maxLengthToEllipsis ? widget.maxLengthToEllipsis : text.length) + '${widget.maxLengthToEllipsis < text.length ? '...' : ''}';
  }

  _getContentRow(){
    return (widget.isFlat) 
    ? 
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.hint is Widget ? widget.hint :
        (widget.leading == false) 
          ? 
          Expanded(child: Center(child: Text("${_getText()}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GoogleSans", letterSpacing: 0.2, color: widget.enabled ? _textColor() : Colors.grey, fontWeight: !widget.onlyBorder ? FontWeight.w700 : null)))) 
          : 
          Expanded(child: Center(child: Text("${_getText()}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GoogleSans", letterSpacing: 0.2, color: _textColor(), fontWeight: !widget.onlyBorder ? FontWeight.w700 : null))))
        ,
        // Icon(Icons.arrow_drop_down, color: Utils.fromHex("#1967d2")),
        Icon(Icons.arrow_drop_down, color: _textColor()),
      ],
    ) 
    : 
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (widget.leading == false) ? SizedBox() : (widget.leading != null) ? widget.leading : Icon(Icons.calendar_today_outlined, color: widget.enabled ? _textColor() : Colors.grey,),
        !widget.isExpanded
        ?
         widget.hint is Widget ? widget.hint : (widget.leading == false) ? Text("${_getText()}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: widget.hintFontSize, fontFamily: "GoogleSans", color: widget.enabled ? _textColor() : Colors.grey, fontWeight: !widget.onlyBorder ? FontWeight.w700 : null)) : Center(child: Text("${_getText()}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: widget.hintFontSize, fontFamily: "GoogleSans", color: widget.enabled ? _textColor() : Colors.grey, fontWeight: !widget.onlyBorder ? FontWeight.w700 : null)))
:
        Expanded(
          child:  widget.hint is Widget ? widget.hint : (widget.leading == false) ? Text("${_getText()}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GoogleSans", color: widget.enabled ? _textColor() : Colors.grey, fontWeight: !widget.onlyBorder ? FontWeight.w700 : null)) : Center(child: Text("${_getText()}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GoogleSans", color: widget.enabled ? _textColor() : Colors.grey, fontWeight: !widget.onlyBorder ? FontWeight.w700 : null)))
        ),
        // Icon(Icons.arrow_drop_down, color: widget.enabled ? Utils.fromHex("#1967d2") : Colors.grey),
        Icon(Icons.arrow_drop_down, color: widget.enabled ? _textColor() : Colors.grey),
      ],
    );
  }

  _normalScreen(){
    return 
    !widget.resized
    ?
    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(visible: widget.title != null, child: Text("${(widget.title == null) ? '' : widget.title}", style: TextStyle(fontFamily: "GoogleSans"),)),
          // LayoutBuilder(
          //   builder: (context, boxConstraints) {
          //     return Builder(
          //       builder: (context) {
          //         return InkWell(
          //           onTap: (){
          //             if(widget.elements == null && widget.enabled)
          //               widget.onTap();
          //             else{
          //               print("Mydropdown inside Inkwell");
          //               textChanged(context, boxConstraints.maxWidth);
          //             }
          //           },
          //           child: Container(
          //             padding: widget.padding,
          //             decoration: _getDecoration(),
          //             child: _getContentRow(),
          //           ),
          //         );
          //       }
          //     );
          //   }
          // ),
          Builder(
                builder: (context) {
                  return InkWell(
                    onTap: !widget.enabled ? null : (){
                      if(widget.elements == null && widget.enabled)
                        widget.onTap();
                      else{
                        print("Mydropdown inside Inkwell");
                        // textChanged(context, boxConstraints.maxWidth);
                        if(widget.enabled)
                        showModalBottomSheet(
                          shape:  RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                          context: context, 
                          builder: (context){
                            return Container(
                              height: widget.elements.length > 3 ? MediaQuery.of(context).size.height / 2 : 200,
                              child: ListView.builder(
                                itemCount: widget.elements.length,
                                itemBuilder: (context, index){
                                  return ListTile(
                                    title: widget.elements[index][1] is Widget ? widget.elements[index][1] : Text("${widget.elements[index][1]}"),
                                    onTap: (){
                                      widget.onTap(widget.elements[index][0]);
                                      Navigator.pop(context);
                                    },
                                  );
                                }
                              ),
                            );
                          }
                        );
                      }
                    },
                    child: Container(
                      padding: widget.padding,
                      decoration: _getDecoration(),
                      child: _getContentRow(),
                    ),
                  );
                }
              )
        ],
      )
    :
    MyResizedContainer(
      xlarge: widget.xlarge,
      large: widget.large,
      medium: widget.medium,
      small: widget.small,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(visible: widget.title != null, child: Text("${(widget.title == null) ? '' : widget.title}", style: TextStyle(fontFamily: "GoogleSans"),)),
          LayoutBuilder(
            builder: (context, boxConstraints) {
              return Builder(
                builder: (context) {
                  return InkWell(
                    onTap: (){
                      if(widget.elements == null && widget.enabled)
                        widget.onTap();
                      else{
                        print("Mydropdown inside Inkwell");
                        textChanged(context, boxConstraints.maxWidth);
                      }
                    },
                    child: Container(
                      padding: widget.padding,
                      decoration: _getDecoration(),
                      child: _getContentRow(),
                    ),
                  );
                }
              );
            }
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
              child: Builder(
                builder: (context) {
                  return InkWell(
                    onTap: (){
                      if(widget.elements == null && widget.enabled)
                        widget.onTap();
                      else{
                        print("Mydropdown inside Inkwell");
                        textChanged(context, widthOfTheWidget / widget.flexOfSideField);
                      }
                    },
                    child:
                    widget.helperText == null
                    ? 
                    Container(
                      padding: widget.padding,
                      decoration: _getDecoration(),
                      child: 
                      _getContentRow()
                    )
                    :
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: widget.padding,
                          decoration: _getDecoration(),
                          child: _getContentRow()
                        ),
                        Text(widget.helperText, style: TextStyle(fontSize: 13),)
                      ],
                    ),
                  );
                }
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
      hint = widget.hint is Widget ? "" : widget.hint;
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