import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/screensize.dart';
import 'package:loterias/core/classes/utils.dart';
// import 'package:loterias/core/models/cliente.dart';
// import 'package:loterias/core/services/customerservice.dart';

import 'myresizecontainer.dart';

class MySearchFieldType {
  const MySearchFieldType._(this.index);

  /// The encoded integer value of this font weight.
  final int index;

  /// Thin, the least thick
  static const MySearchFieldType automaticHover = MySearchFieldType._(0);

  /// Extra-light
  static const MySearchFieldType manualHover = MySearchFieldType._(1);

  /// Light
  /// A list of all the font weights.
  static const List<MySearchFieldType> values = <MySearchFieldType>[
    automaticHover, manualHover
  ];
}

class MySearchField extends StatefulWidget {
  final ValueChanged<Object> onSelected;
  final ValueChanged<String> onChanged;
  final String title;
  final String labelText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final maxLines;

  final double small;
  final double medium;
  final double large;
  final double xlarge;
  final EdgeInsets padding;
  final EdgeInsets iconPadding;
  final borderRadius;

  final bool isRequired;
  final EdgeInsets contentPadding;
  final bool showOnlyOnSmall;
  final bool showOnlyOnLarge;
  final bool enabled;
  final Function onTap;
  final ValueChanged<bool> focusChanged;
  final MySearchFieldType type;
  final bool hasFocusManual;
  final bool autofocus;
  MySearchField({Key key, this.title = "", this.labelText = "", this.controller, this.focusNode, this.onSelected, this.onChanged, this.hint, this.maxLines = 1, this.small = 1, this.medium = 3, this.large = 4, this.xlarge = 5, this.padding = const EdgeInsets.all(2.5), this.borderRadius, this.iconPadding = const EdgeInsets.only(left: 8.0, right: 8.0), this.isRequired = false, this.contentPadding = const EdgeInsets.only(top: 15, bottom: 15), this.showOnlyOnSmall = false, this.showOnlyOnLarge = false, this.enabled = true, this.onTap, this.focusChanged, this.type = MySearchFieldType.automaticHover, this.hasFocusManual = false, this.autofocus = false}) : super(key: key);
  @override
  _MySearchFieldState createState() => _MySearchFieldState();
}

class _MySearchFieldState extends State<MySearchField> {
  FocusNode _myFocus = FocusNode();
  bool _tieneFoco = false;
  var _borderRadius;
  @override
  void initState() {
    // TODO: implement initState
    // _width = getWidth();
    _borderRadius = (widget.borderRadius != null) ? widget.borderRadius : BorderRadius.circular(10);
    _myFocus.addListener(focusChanged);
    if(widget.autofocus)
      _myFocus.requestFocus();
    super.initState();
  }

  focusChanged(){
    // if (_myFocus.hasFocus) {

    //     // this._overlayEntry = this._createOverlayEntry();
    //     // Overlay.of(context).insert(this._overlayEntry);

    //   } else {
    //     this._overlayEntry.remove();
    //   }
    if(widget.focusChanged != null)
      widget.focusChanged(_myFocus.hasFocus);
    print('mysearch focusChange: ${_myFocus.hasFocus}');
    setState(() => _tieneFoco = _myFocus.hasFocus);

  }

  textChanged(String data) async {
    print("textChanged ${data.isEmpty}");
    // if (data.isNotEmpty) {
        if(widget.onChanged != null)
          widget.onChanged(data);

      // } 
  }





  

  getWidth(double screenSize){
    double width = 0;
    if(ScreenSize.isSmall(screenSize))
      width = (widget.small != null) ? screenSize / widget.small : screenSize / getNotNullScreenSize();
    else if(ScreenSize.isMedium(screenSize))
      width = (widget.medium != null) ? screenSize / widget.medium : screenSize / getNotNullScreenSize();
    else if(ScreenSize.isLarge(screenSize))
      width = (widget.large != null) ? screenSize / widget.large : screenSize / getNotNullScreenSize();
    else if(ScreenSize.isXLarge(screenSize))
      width = (widget.xlarge != null) ? screenSize / widget.xlarge : screenSize / getNotNullScreenSize();
    return width;
  }

  getNotNullScreenSize(){
    if(widget.small != null)
      return widget.small;
    else if(widget.medium != null)
      return widget.medium;
    else if(widget.large != null)
      return widget.large;
    else
      return widget.xlarge;
  }

  tieneFoco(){
    return widget.type == MySearchFieldType.automaticHover ? _tieneFoco : widget.hasFocusManual;
  }

  _screen(){
    if(widget.showOnlyOnSmall){
      if(!Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
        return SizedBox.shrink();
    }

    if(widget.showOnlyOnLarge){
      if(Utils.isSmallOrMedium(MediaQuery.of(context).size.width))
        return SizedBox.shrink();
    }

    return MyResizedContainer(
      small: widget.small,
      medium: widget.medium,
      large: widget.large,
      xlarge: widget.xlarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(visible: widget.title != "",child: Text(widget.title, textAlign: TextAlign.start, style: TextStyle(fontSize: 15),)),
              Container(
                      // duration: Duration(milliseconds: 100),
                      // padding: EdgeInsets.all(3.0),
                      padding: widget.padding,
                      decoration:
                      tieneFoco() 
                      ?
                       BoxDecoration(
                        color: Colors.white,
                        borderRadius: _borderRadius,
                        // BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        // border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            // spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 1.0), // changes position of shadow
                          ),
                        ],
                      )
                      :
                      BoxDecoration(
                        color: Utils.fromHex("#f1f3f4"),
                        borderRadius: _borderRadius,
                        // border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid)
                      )
                      ,
                      // width: getWidth(boxconstraints.maxWidth) , 
                      //El padding se multiplica por dos ya que el padding dado es el mismo para la izquiera y derecha
                      // height: 50,
                      child:
                      (widget.labelText == "")
                      ?
                       Row(
                         children: [
                           Padding(
                             padding: widget.iconPadding,
                             child: Icon(Icons.search),
                           ),
                           Expanded(
                             child: TextFormField(
                               autofocus: widget.autofocus,
                               onTap: widget.onTap,
                               enabled: widget.enabled,
                               focusNode: _myFocus,
                                controller: widget.controller,
                                maxLines: widget.maxLines,
                                keyboardType: (widget.maxLines != 1) ? TextInputType.multiline : null,
                                style: TextStyle(fontSize: 15),
                                  decoration: InputDecoration(
                                    hintText: widget.hint,
                                    hintStyle: TextStyle(color: Utils.fromHex("#72777c"), fontWeight: FontWeight.w500),
                                    contentPadding: widget.contentPadding,
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  validator: (data){
                                    if(data.isEmpty && widget.isRequired)
                                      return "Campo requerido";
                                    return null;
                                  },
                                  onChanged: (data){
                                    textChanged(data);
                                  },
                                ),
                           ),
                         ],
                       )
                        :
                        TextFormField(
                          controller: widget.controller,
                          maxLines: widget.maxLines,
                          keyboardType: (widget.maxLines != 1) ? TextInputType.multiline : null,
                          style: TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              labelText: widget.labelText
                            ),
                            validator: (data){
                              if(data.isEmpty && widget.isRequired)
                                return "Campo requerido";
                              return null;
                            },
                          ),
                    ),
                    
              
              
              // Container(
              //         // duration: Duration(milliseconds: 100),
              //         padding: EdgeInsets.all(3.0),
              //         decoration:
              //         _tieneFoco 
              //         ?
              //          BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(10),
              //           // border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),
              //           boxShadow: [
              //             BoxShadow(
              //               color: Colors.grey,
              //               // spreadRadius: 2,
              //               blurRadius: 2,
              //               offset: Offset(0, 1.0), // changes position of shadow
              //             ),
              //           ],
              //         )
              //         :
              //         BoxDecoration(
              //           color: Utils.fromHex("#f1f3f4"),
              //           borderRadius: BorderRadius.circular(10),
              //           // border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid)
              //         )
              //         ,
              //         width: getWidth(boxconstraints.maxWidth) - (widget.padding * 2), //El padding se multiplica por dos ya que el padding dado es el mismo para la izquiera y derecha
              //         // height: 50,
              //         child:
              //         (widget.labelText == "")
              //         ?
              //          Row(
              //            children: [
              //              Icon(Icons.search),
              //              Expanded(
              //                child: TextFormField(
              //                  focusNode: widget.focusNode,
              //                   controller: widget.controller,
              //                   maxLines: widget.maxLines,
              //                   keyboardType: (widget.maxLines != 1) ? TextInputType.multiline : null,
              //                   style: TextStyle(fontSize: 15),
              //                     decoration: InputDecoration(
              //                       hintText: widget.hint,
              //                       hintStyle: TextStyle(color: Utils.fromHex("#72777c"), fontWeight: FontWeight.w500),
              //                       contentPadding: EdgeInsets.all(10),
              //                       isDense: true,
              //                       border: InputBorder.none,
              //                       focusedBorder: InputBorder.none,
              //                       enabledBorder: InputBorder.none,
              //                       errorBorder: InputBorder.none,
              //                       disabledBorder: InputBorder.none,
              //                     ),
              //                     validator: (data){
              //                       if(data.isEmpty && widget.isRequired)
              //                         return "Campo requerido";
              //                       return null;
              //                     },
              //                   ),
              //              ),
              //            ],
              //          )
              //           :
              //           TextFormField(
              //             controller: widget.controller,
              //             maxLines: widget.maxLines,
              //             keyboardType: (widget.maxLines != 1) ? TextInputType.multiline : null,
              //             style: TextStyle(fontSize: 15),
              //               decoration: InputDecoration(
              //                 labelText: widget.labelText
              //               ),
              //               validator: (data){
              //                 if(data.isEmpty && widget.isRequired)
              //                   return "Campo requerido";
              //                 return null;
              //               },
              //             ),
              //       ),
                  
             
            ],
          )
       
    );
  
  }


  @override
  Widget build(BuildContext context) {
    return _screen();
  }
}