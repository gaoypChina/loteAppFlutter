import 'package:flutter/material.dart';
import 'package:loterias/core/classes/screensize.dart';
import 'package:loterias/core/classes/utils.dart';

class MyDropdownType {
  const MyDropdownType._(this.index);

  /// The encoded integer value of this font weight.
  final int index;

  /// Thin, the least thick
  static const MyDropdownType normal = MyDropdownType._(0);

  /// Extra-light
  static const MyDropdownType border = MyDropdownType._(1);

  /// Light
  static const MyDropdownType blue = MyDropdownType._(2);

  /// blueNoBorder
  static const MyDropdownType blueNoBorder = MyDropdownType._(3);
  static const MyDropdownType noBorder = MyDropdownType._(4);

  /// A list of all the font weights.
  static const List<MyDropdownType> values = <MyDropdownType>[
    normal, border, blueNoBorder, noBorder
  ];
}

class MyDropdownButton extends StatefulWidget {
  final dynamic leading;
  final ValueChanged<dynamic> onChanged;
  final dynamic value;
  final dynamic initialValue;
  final String title;
  final String hint;
  final bool enabled;
  final bool isAllBorder;
  final double flexOfSideText;
  final double flexOfSideField;

  final double small;
  final double medium;
  final double large;
  final double xlarge;

   final double smallSide;
  final double mediumSide;
  final double largeSide;
  final double xlargeSide;

  final List<List<dynamic>> items;
  final EdgeInsets padding;
  final EdgeInsets paddingBlue;
  final bool isSideTitle;
  final MyDropdownType type;
  final String nullHint;
  final bool addNingunoToFirstElement;
  final String helperText;
  MyDropdownButton({Key key, this.value, this.initialValue, this.title = "", @required this.onChanged, this.hint, this.small = 1, this.medium = 3, this.large = 4, this.xlarge = 4,  this.smallSide = 1, this.mediumSide = 1, this.largeSide = 4, this.xlargeSide = 1.35, this.padding = const EdgeInsets.only(left: 8.0, right: 8.0, top: 3), this.paddingBlue = const EdgeInsets.only(left: 8.0, right: 8.0, top: 8), this.enabled = true, this.isAllBorder = false, this.leading, this.items, this.isSideTitle = false, 
    // this.flexOfSideText = 3, 
    this.flexOfSideText = 3.05, 
    // this.flexOfSideField = 1.5, 
    this.flexOfSideField = 1.523, 
    this.type = MyDropdownType.normal, this.nullHint = "Ninguno", this.addNingunoToFirstElement = false, this.helperText}) : super(key: key);
  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  int _index = 0;
  var _value;
  List<List<dynamic>> _items = [];

  void initState() {
    // TODO: implement initState
    _init();
    // _addNingunoToFirstElement();
    _initialValue();
    super.initState();
  }

  _init(){
    _items = widget.items;
    // _items.forEach((element) {print("MyDropdown initState: ${element[0]}");});
    _addNingunoToFirstElement();
  }

  _initialValue(){
      print("MyDropdownButton initialValue: ${widget.initialValue}");
    // if(widget.initialValue != null){
    //   _value = widget.initialValue;
    //   // if(_items.length > 0){
    //   //   var idx = _items.indexWhere((element) => element[0] == widget.initialValue);
    //   //   if(idx != -1){
    //   //     _index = idx;
    //   //     _value = _items.indexWhere((element) => element[0] == widget.initialValue);
    //   //   }
    //   // }
    // }
    if(widget.value != null && widget.value != _value){
      _value = widget.value;
    }
  }

  _addNingunoToFirstElement(){
      print("MyDropdownButton _addNingunoToFirstElement: ${_value}");

    if(widget.addNingunoToFirstElement){
      if(_items != null){
        if(widget.items.length > 0){
          print("MyDropdownButton _addNingunoToFirstElement1: ${_value} : ${_items}");
          if(_items.indexWhere((element) => element[0] == "Ninguno") == -1){
            _items.insert(0, ["Ninguno", "Ninguno"]);
            _value = (_value != null) ? _value : "Ninguno";
            print("MyDropdownButton _addNingunoToFirstElement2: ${_value} : ${_items.length}");
          }
          else{
            if(widget.items.length == 1 && widget.items.first[0] == "Ninguno")
              _value = "Ninguno";
            else
            _value = (widget.items.length > 0) ? (_value != null) ? _value : "Ninguno" : "Ninguno";
          }
        }
        else{
          print("MyDropdownButton _addNingunoToFirstElement4: ${_value} : ${_items.length}");
          if(_items.length == 0){
            _items.add(["Ninguno", "Ninguno"]);
            print("MyDropdownButton _addNingunoToFirstElement5: ${_value} : ${_items.length}");
          }
          _value = "Ninguno";
        }
      }
    }else{
      if(widget.items.length == 0)
        _value = widget.nullHint;
      // else{
      //   if(widget.initialValue == null && _value == null)
      //     _value = widget.items[0];
      // }

      print("MyDropdownButton _addNingunoToFirstElement ultimooo: ${widget.initialValue} : ${_value}");

    }
  }

  @override
  void didUpdateWidget(dynamic oldWidget) {
    if(oldWidget.items != widget.items){
      _init();
    }
    if (oldWidget.initialValue != widget.initialValue) {
      // hint = widget.hint;
      _initialValue();
    }
    
    super.didUpdateWidget(oldWidget);
  }

  getWidth(double screenSize){
    double width = 0;
    if(widget.isSideTitle){
      if(ScreenSize.isSmall(screenSize))
        width = (widget.smallSide != null) ? screenSize / widget.smallSide : screenSize / getNotNullScreenSize();
      else if(ScreenSize.isMedium(screenSize))
        width = (widget.mediumSide != null) ? screenSize / widget.mediumSide : screenSize / getNotNullScreenSize();
      else if(ScreenSize.isLarge(screenSize))
        width = (widget.largeSide != null) ? screenSize / widget.largeSide : screenSize / getNotNullScreenSize();
      else if(ScreenSize.isXLarge(screenSize))
        width = (widget.xlargeSide != null) ? screenSize / widget.xlargeSide : screenSize / getNotNullScreenSize();
    }else{
      if(ScreenSize.isSmall(screenSize))
        width = (widget.small != null) ? screenSize / widget.small : screenSize / getNotNullScreenSize();
      else if(ScreenSize.isMedium(screenSize))
        width = (widget.medium != null) ? screenSize / widget.medium : screenSize / getNotNullScreenSize();
      else if(ScreenSize.isLarge(screenSize))
        width = (widget.large != null) ? screenSize / widget.large : screenSize / getNotNullScreenSize();
      else if(ScreenSize.isXLarge(screenSize))
        width = (widget.xlarge != null) ? screenSize / widget.xlarge : screenSize / getNotNullScreenSize();
    }
    
    return width;
    
  }
  
  getNotNullScreenSize(){
    
    if(widget.isSideTitle){
      if(widget.smallSide != null)
        return widget.smallSide;
      else if(widget.mediumSide != null)
        return widget.mediumSide;
      else if(widget.largeSide != null)
        return widget.largeSide;
      else
        return widget.xlargeSide;
    }else{
      if(widget.small != null)
        return widget.small;
      else if(widget.medium != null)
        return widget.medium;
      else if(widget.large != null)
        return widget.large;
      else
        return widget.xlarge;
    }
  }


  _dropdownFormFieldWithBorder(double width){
    print("_dropdownFormFieldWIthBOrder: ${_items.length}");
    return Container(
      // color: Colors.red,
      width: getWidth(width),
      child: 
        DropdownButtonFormField(
          decoration: InputDecoration(
          
          // contentPadding: EdgeInsetsGeometry.lerp(a, b, t),
          // contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(borderSide: BorderSide(width: 0.2, color: Colors.black)),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0.0),
          helperText: widget.helperText
        ),
        disabledHint: Text("${(_items.length > 0) ? (_index > _items.length) ? _items[0][0] : _items[_index][1] : ''}"),
        isExpanded: true, 
        hint: widget.hint != null ? Text(widget.hint) : null,
        items: (_items.length > 0) ? _items.map<DropdownMenuItem>((e) => DropdownMenuItem(child: Text(e[1]), value: e[0], )).toList() : [DropdownMenuItem(child: Text(widget.nullHint), value: widget.nullHint,)],
        onChanged: (!widget.enabled || _items.length == 0) ? null : (data){
          widget.onChanged(data != "Ninguno" ? data : null);
          // int idx = widget.elements.indexWhere((element) => element == data);
          // setState(() => _value = data);
          int idx = _items.indexWhere((element) => element[0] == data);
          setState(() => _value = data);
            
        }, 
        value: _value,
      )
    );
    return DropdownButtonFormField(
      // decoration: InputDecoration(
        
      //   // contentPadding: EdgeInsetsGeometry.lerp(a, b, t),
      //   // contentPadding: EdgeInsets.all(10),
      //   border: OutlineInputBorder(borderSide: BorderSide(width: 1))
      // ),
      
      // itemHeight: 50,
      disabledHint: Text("${_items[_index][1]}"),
      isDense: false, 
      
      items: 
      _items.map<DropdownMenuItem>((e) => DropdownMenuItem(child: Text(e[1], style: TextStyle(fontSize: 13),), value: e[0],)).toList(),
      onChanged: (!widget.enabled) ? null : (data){
        widget.onChanged(data != "Ninguno" ? data : null);
        // int idx = widget.elements.indexWhere((element) => element == data);
        // setState(() => _value = data);
        int idx = _items.indexWhere((element) => element[0] == data);
        setState(() => _value = data);
      }, 
      value: _value,
    );
                  
  }

  _dropdownFormFieldWithNoBorder(double width){
    print("_dropdownFormFieldWIthBOrder: ${widget.leading != null }");
    var dropdown = Container(
      width: getWidth(width),
      child: 
        DropdownButtonFormField(
          decoration: InputDecoration(
          
          // contentPadding: EdgeInsetsGeometry.lerp(a, b, t),
          // contentPadding: EdgeInsets.all(10),
          // border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          helperText: widget.helperText
        ),
        hint: widget.hint != null ? Text(widget.hint) : null,
        disabledHint: Text("${(_items.length > 0) ? (_index > _items.length) ? _items[0][0] : _items[_index][1] : ''}"),
        isExpanded: true, 
        
        items: (_items.length > 0) ? _items.map<DropdownMenuItem>((e) => DropdownMenuItem(child: Text(e[1]), value: e[0], )).toList() : [DropdownMenuItem(child: Text(widget.nullHint), value: widget.nullHint,)],
        onChanged: (!widget.enabled || _items.length == 0) ? null : (data){
          widget.onChanged(data != "Ninguno" ? data : null);
          // int idx = widget.elements.indexWhere((element) => element == data);
          // setState(() => _value = data);
          int idx = _items.indexWhere((element) => element[0] == data);
          setState(() => _value = data);
            
        }, 
        value: _value,
      )
    );
   if(widget.leading != null)
    return ListTile(leading: widget.leading, title: dropdown,);

    return dropdown;             
  }

  // _dropdowHideUnderline(){
  //   return DropdownButtonHideUnderline(
  //         child: Container(
  //           decoration: ShapeDecoration(
  //             shape: RoundedRectangleBorder(
  //               side: BorderSide(width: 1.0, style: BorderStyle.solid),
  //               borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //             ),
  //           ),
  //           child: ButtonTheme(
  //             alignedDropdown: true,
  //             padding: EdgeInsets.only(top: 0, bottom: 0),
  //             child: DropdownButton(
                
  //               disabledHint: Text("${(widget.elements.length == 0) ? '' : widget.elements[_index]}"),
  //               isExpanded: true, 
                
  //               items: widget.elements.map<DropdownMenuItem>((e) => DropdownMenuItem(child: Text(e, style: TextStyle(fontSize: 13),), value: e,)).toList(), 
  //               onChanged: (!widget.enabled) ? null : (data){
  //                 widget.onChanged(data != "Ninguno" ? data : null);
  //                 int idx = widget.elements.indexWhere((element) => element == data);
  //                 setState(() => _value = data);
  //               }, 
  //               value: widget.elements[_index],
  //       ),
  //           ),
  //     ),
  //   );
  // }

  _dropdownBlue(double width){
    return Container(
      width: getWidth(width),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        children: [
          (widget.leading == false) ? SizedBox() : (widget.leading != null) ? widget.leading : 
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(Icons.calendar_today_outlined, color: Utils.fromHex("#1967d2"),),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
          
                  // contentPadding: EdgeInsetsGeometry.lerp(a, b, t),
                  // contentPadding: EdgeInsets.all(10),
                  // border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  helperText: widget.helperText

                ),
                disabledHint: Text("${(_items.length > 0) ? (_index > _items.length) ? _items[0][0] : _items[_index][1] : ''}"),
                hint: widget.hint != null ? Text(widget.hint) : null,

                // style: TextStyle(color: Utils.fromHex("#1967d2")),
                // underline: SizedBox(),
                selectedItemBuilder: (context){
                  return _items.map((e) => Align(alignment: Alignment.center, child: Text("${e[1]}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontFamily: "GoogleSans", color: Utils.fromHex("#1967d2"), fontWeight: FontWeight.w700)))).toList();
                },
                isExpanded: true, 
                items: (_items.length > 0) ? _items.map<DropdownMenuItem>((e) => DropdownMenuItem(child: Text(e[1], style: TextStyle(fontFamily: "GoogleSans")), value: e[0], )).toList() : [DropdownMenuItem(child: Text(widget.nullHint), value: widget.nullHint,)],
                onChanged: (!widget.enabled || _items.length == 0) ? null : (data){
                  widget.onChanged(data != "Ninguno" ? data : null);
                    int idx = _items.indexWhere((element) => element[0] == data);
                    setState(() => _value = data);
                    // int idx = widget.elements.indexWhere((element) => element == data);
                    // setState(() => _value = data);
                }, 
                value: (_items.length == 0) ? widget.nullHint : _items.length == 0 ? null : (_index > _items.length) ? _items[0][0] : _items[_index][0],
              ),
            )
          )
        ],
      )
  );
  }
  _dropdownBlueNoBorder(double width){
    return Container(
      width: getWidth(width),
      // decoration: BoxDecoration(
      //   color: Colors.blue.withOpacity(0.15),
      //   borderRadius: BorderRadius.circular(5)
      // ),
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            iconEnabledColor: Utils.fromHex("#1967d2"),
            disabledHint: Text("${(_items.length > 0) ? (_index > _items.length) ? _items[0][0] : _items[_index][1] : ''}"),
            hint: widget.hint != null ? Text(widget.hint) : null,

            // style: TextStyle(color: Utils.fromHex("#1967d2")),
            // underline: SizedBox(),
            selectedItemBuilder: (context){
              return _items.map((e) => Align(alignment: Alignment.center, child: Text("${e[1]}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontFamily: "GoogleSans", color: Utils.fromHex("#1967d2"), fontWeight: FontWeight.w700)))).toList();
            },
            isExpanded: true, 
            items: (_items.length > 0) ? _items.map<DropdownMenuItem>((e) => DropdownMenuItem(child: Text(e[1], style: TextStyle(fontFamily: "GoogleSans")), value: e[0], )).toList() : [DropdownMenuItem(child: Text(widget.nullHint), value: widget.nullHint,)],
            onChanged: (!widget.enabled || _items.length == 0) ? null : (data){
              widget.onChanged(data != "Ninguno" ? data : null);
                int idx = _items.indexWhere((element) => element[0] == data);
                setState(() => _value = data);
                // int idx = widget.elements.indexWhere((element) => element == data);
                // setState(() => _value = data);
            }, 
            value: _value,
          ),
        ),
      )
  );
  }

  _dropdownNormal(double width){
    print("_dropdownNormal _index > items: ${(_index > _items.length)}");
    return Container(
      width: getWidth(width),
      child: 
      DropdownButton(
        disabledHint: Text("${(_items.length > 0) ? (_index < _items.length) ? _items[_index][1] : _items[0][1] : ''}"),
        isExpanded: true, 
        hint: widget.hint != null ? Text(widget.hint) : null,
        
        items: (_items.length > 0) ? _items.map<DropdownMenuItem>((e) => DropdownMenuItem(child: Text(e[1], style: TextStyle(fontFamily: "GoogleSans")), value: e[0], )).toList() : [DropdownMenuItem(child: Text(widget.nullHint), value: widget.nullHint,)],
        onChanged: (!widget.enabled || _items.length == 0) ? null : (data){
          widget.onChanged(data != "Ninguno" ? data : null);
          // int idx = widget.elements.indexWhere((element) => element == data);
          // setState(() => _value = data);
          int idx = _items.indexWhere((element) => element[0] == data);
          setState(() => _value = data);
            
        }, 
        // value: _items.length == 0 ? widget.nullHint : (_index > _items.length) ? _items[_items.length][0] : _items[_index][0],
        value: _value,
      )
    );
  }

  _screenWithSideTitle(double width){
    print("_screenWithSIdeTitle wdth:$width function:${getWidth(width)}");
    // return Container(
    //   color: Colors.red,
    //   // decoration: BoxDecoration(
    //   //   borderRadius: BorderRadius.circular(10),
    //   //   border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid)
    //   // ),
    //   width: getWidth(width) - (widget.padding.left + widget.padding.right), //El padding se multiplica por dos ya que el padding dado es el mismo para la izquiera y derecha
    //   // height: 50,
    //   child:
    //   SizedBox(
    //     width: 100,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Flexible(flex: 2, child: Visibility(visible: widget.title != "" && widget.type == MyType.border,child: Text(widget.title, textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: "GoogleSans",  letterSpacing: 0.4),))),

    //         Flexible(
    //           flex: 4,
    //           child: Column(
    //             children: [
    //               // (widget.labelText == "")
    //               // ?
    //               // _textFormFieldWithoutLabel()
    //               // :
    //               // _textFormFieldWithLabel(),
    //               _typeOfTextFormField(),
    //               Visibility(visible: widget.helperText != "",child: Text(widget.helperText, textAlign: TextAlign.start, style: TextStyle(fontSize: 13, fontFamily: "GoogleSans", color: Utils.fromHex("#5f6368"), letterSpacing: 0.4))),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   )
    // );

    double widthOfTheWidget = getWidth(width);
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Visibility(visible: widget.title != "" && widget.type == MyType.border,child: Text(widget.title, textAlign: TextAlign.start, style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"))),
                  
              // Visibility(visible: widget.title != "",child: MyDescripcon(title: "Proximo pago",),),
              Container(
                // color: Colors.red,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(10),
                //   border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid)
                // ),
                width: widthOfTheWidget, //El padding se multiplica por dos ya que el padding dado es el mismo para la izquiera y derecha
                // height: 50,
                child: 
                Wrap(children: [
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
                    child: 
                    // (widget.isBlue == false)
                    // ?
                    // _dropdownBlue(width)
                    // :
                    // _dropdownNormal(width)  
                    _screenDropdownType(width)  
                  ),
                ],)
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            // Flexible(flex: 2, child: Visibility(visible: widget.title != "" && widget.type == MyType.border,child: Text(widget.title, textAlign: TextAlign.start, style: TextStyle(color: widget.isSideTitle ? Utils.fromHex("#3c4043") : Colors.black, fontSize: 14, fontFamily: "GoogleSans",  letterSpacing: 0.4),))),

            //         Flexible(
            //           flex: 4,
            //           child: Padding(
            //             padding: const EdgeInsets.only(top: 15.0),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 // (widget.labelText == "")
            //                 // ?
            //                 // _textFormFieldWithoutLabel()
            //                 // :
            //                 // _textFormFieldWithLabel(),
            //                 _typeOfTextFormField(),
            //                 Visibility(visible: widget.helperText != "",child: Text(widget.helperText, textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12, fontFamily: "GoogleSans", color: Utils.fromHex("#5f6368"), letterSpacing: 1.3))),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     )
              ),
            ],
          );
     
          
  }

  _screenWithNormalTitle(double width){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: widget.title != "",
            child: Text(widget.title, textAlign: TextAlign.start, style: TextStyle(fontSize: 15, fontFamily: "GoogleSans"),)
          ),
          // (widget.isBlue == false)
          // ?
          // Container(
          //     width: getWidth(width) - (widget.padding.left + widget.padding.right),
          //     child: 
          //     (widget.isAllBorder)
          //     ?
          //     _dropdownFormField()
          //     :
          //     DropdownButton(
          //       disabledHint: Text("${_items[_index][1]}"),
          //       isExpanded: true, 
                
          //       items: _items.map<DropdownMenuItem>((e) => DropdownMenuItem(child: Text(e[1], style: TextStyle(fontFamily: "GoogleSans")), value: e[0], )).toList(),
          //       onChanged: (!widget.enabled) ? null : (data){
          //         widget.onChanged(data != "Ninguno" ? data : null);
          //         // int idx = widget.elements.indexWhere((element) => element == data);
          //         // setState(() => _value = data);
          //         int idx = _items.indexWhere((element) => element[0] == data);
          //         setState(() => _value = data);
                    
          //       }, 
          //       value: _value,
          //     )
          //   )
          //   :
          // Container(
          //     width: getWidth(width) - (widget.paddingBlue.left + widget.paddingBlue.right),
          //     decoration: BoxDecoration(
          //       color: Colors.blue.withOpacity(0.15),
          //       borderRadius: BorderRadius.circular(5)
          //     ),
          //     child: Row(
          //       children: [
          //         (widget.leading == false) ? SizedBox() : (widget.leading != null) ? widget.leading : 
          //         Padding(
          //           padding: const EdgeInsets.only(left: 8.0),
          //           child: Icon(Icons.calendar_today_outlined, color: Utils.fromHex("#1967d2"),),
          //         ),
          //         Expanded(
          //           child: Padding(
          //             padding: const EdgeInsets.only(right: 8.0),
          //             child: DropdownButtonHideUnderline(
          //               child: DropdownButton(
                          
          //                 disabledHint: Text("${_items[_index][1]}"),

          //                 // style: TextStyle(color: Utils.fromHex("#1967d2")),
          //                 // underline: SizedBox(),
          //                 selectedItemBuilder: (context){
          //                   return _items.map((e) => Align(alignment: Alignment.center, child: Text("${e[1]}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, fontFamily: "GoogleSans", color: Utils.fromHex("#1967d2"), fontWeight: FontWeight.w700)))).toList();
          //                 },
          //                 isExpanded: true, 
          //                 items: _items.map<DropdownMenuItem>((e) => DropdownMenuItem(child: Text(e[1], style: TextStyle(fontFamily: "GoogleSans")), value: e[0], )).toList(),
          //                 onChanged: (!widget.enabled) ? null : (data){
          //                   widget.onChanged(data != "Ninguno" ? data : null);
          //                     int idx = _items.indexWhere((element) => element[0] == data);
          //                     setState(() => _value = data);
          //                     // int idx = widget.elements.indexWhere((element) => element == data);
          //                     // setState(() => _value = data);
          //                 }, 
          //                 value: _value,
          //               ),
          //             ),
          //           )
          //         )
          //       ],
          //     )
          // )
          _screenDropdownType(width)
        ],
      );
  }

  _screenDropdownType(double width){
    var dropdownType;
    switch (widget.type) {
      case MyDropdownType.blue:
        dropdownType = _dropdownBlue(width);
        break;
      case MyDropdownType.blueNoBorder:
        dropdownType = _dropdownBlueNoBorder(width);
        break;
      case MyDropdownType.border:
        dropdownType = _dropdownFormFieldWithBorder(width);
        break;
      case MyDropdownType.noBorder:
        dropdownType = _dropdownFormFieldWithNoBorder(width);
        break;
      default:
        dropdownType = _dropdownNormal(width);
    }

    return dropdownType;
  }
  

  _screen(double width){
    return (widget.isSideTitle) ? _screenWithSideTitle(width) : _screenWithNormalTitle(width);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxconstraints) {
        return _screen(boxconstraints.maxWidth);
      }
    );
  }
}