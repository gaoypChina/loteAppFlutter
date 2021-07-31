import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'myresizecontainer.dart';

class MyBarchar extends StatefulWidget {
  final double small;
  final double medium;
  final double large;
  final double xlarge;
  final int leftLabelDivider;
  final List<List<MyBar>> listOfData;
  final List<Text> listOfBottomLabel;
  MyBarchar({Key key, this.listOfData = const [], this.listOfBottomLabel = const [], this.small = 1, this.medium = 3, this.large = 4, this.xlarge = 5, this.leftLabelDivider = 5}) : super(key: key);
  @override
  _MyBarcharState createState() => _MyBarcharState();
}

class _MyBarcharState extends State<MyBarchar> {
  OverlayEntry _overlayEntry;
  GlobalKey _overlayKey = GlobalKey();
  
  double _maxValue = 0;
  List<double> listOfValues = [];
  _init(){
    double maxValue = 0;
    listOfValues = widget.listOfData.map((e) => e.map((e) => e.value).reduce((value, element) => value + element)).toList();
     _maxValue = listOfValues.reduce(max);
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

  _screen({@required double width, @required height}){
    List<Widget> widgets = _createLeftLabel(maxValue: _maxValue, width: 30, height: height);
    widgets.add(
      Align(
                    alignment: Alignment.bottomRight,
                    // child: _screen(width: width, height: MediaQuery.of(context).size.height / 1),
                    child: MyResizedContainer(
                      xlarge: 1.065,
                      // large: 1.128,
                      large: 1.09,
                      medium: 1.12,
                      small: 1.15,
                      padding: EdgeInsets.only(left: 8.0),
                      child: LayoutBuilder(
                        builder: (context, boxConstraints) {
                          return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.listOfBottomLabel.length,
                          itemBuilder: (context, index){
                            // listOfValues[index];
                            print("culooo: ${index}");
                            List<Widget> widgets = [];
                            if(index < widget.listOfData.length)
                              widgets.add(_createBarsWidgets(indexOfLabels: index, width: boxConstraints.maxWidth, height: height));

                            widgets.add(widget.listOfBottomLabel[index]);
                            return Container(
                              // width: (MediaQuery.of(context).size.width / 2) / widget.listOfBottomLabel.length,
                              width: boxConstraints.maxWidth / widget.listOfBottomLabel.length,
                              child: Padding(
                                // padding: EdgeInsets.only(top: 8.0, left: (index == 0) ? 0 : 8.0, right: (index + 1 == widget.listOfBottomLabel.length) ? 0 : 8.0),
                                padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                                child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: widgets
                                    ),
                              ),
                            );
                          }
                  );
                        }
                      ),
                    )
    )
    );

    return widgets;
  }

  _createBarsWidgets({@required indexOfLabels, @required double width, @required double height}){
    /// El parametro indexOfLabels es para obtener la barra que le corresponde al label
    var barWidgets = widget.listOfData[indexOfLabels].map<Widget>((e){
        // print("screenSize: (${e.value} / $_maxValue) * ${MediaQuery.of(context).size.height / 2} = ${(e.value / _maxValue) * boxconstraints.maxWidth}");
        var _changeColor = ValueNotifier<bool>(false);
        print("MyBarCharScreen _CreateBarsWidgets Bar height: ${((e.value / (_maxValue + 20)) * height)}");
        return Builder(
          builder: (context) {
            return MouseRegion(
              onEnter: (pointerEnterEvent){
                _changeColor.value = true;
                // if(_overlayEntry == null){
                // _overlayEntry = _createOverlayEntry(context);
                // Overlay.of(context).insert(_overlayEntry);
                // print("mouse entro: ${pointerEnterEvent.size}");
                // // Navigator.of(context).push(CustomDialog());
                // // List<String> resultados = lista.where((element) => element.toLowerCase().indexOf(data) != -1).toList();
                
                // }
              },
              onExit: (pointerEnterEvent){
                // if(_overlayEntry != null){
                //   this._overlayEntry.remove();
                //   this._overlayEntry = null;
                // }
                print("_creteBarsWidgets context: ${context.widget.toStringShort()} hashCode: ${context.hashCode}");
                _changeColor.value = false;
              },
              child: ValueListenableBuilder(
                valueListenable: _changeColor,
                builder: (context, value, _) {
                  return Container(
                        color: value ? e.color.withOpacity(0.7) : e.color,
                        // width: boxconstraints.maxHeight / 4,
                        width: (width / ((e.width != null) ? e.width : widget.listOfBottomLabel.length)),
                        height: ((e.value / (_maxValue + 20)) * height), 
                        // height: 100, 
                      );
                }
              ),
            );
          }
        );
      }
    ).toList();
    return Builder(
      builder: (context) {
        return MouseRegion(
          onEnter: (pointerEnterEvent){
            if(_overlayEntry == null){
            _overlayEntry = _createOverlayEntry(context: context, bars: widget.listOfData[indexOfLabels], bottomLabel: widget.listOfBottomLabel[indexOfLabels].data);
            Overlay.of(context).insert(_overlayEntry);
              // print("Depends: ${pointerEnterEvent.localPosition.distance}");

            // Navigator.of(context).push(CustomDialog());
            // List<String> resultados = lista.where((element) => element.toLowerCase().indexOf(data) != -1).toList();
            
            }
          },
          onExit: (pointerEnterEvent){
            if(_overlayEntry != null){
              // print("Depends on: ${pointerEnterEvent.obscured}");
              // poin
            // print("mouse entro: ${_getPositions()}");
            // pointerEnterEvent.p
            // print("mouse entro pointer: ${pointerEnterEvent.position.distanceSquared}");
              this._overlayEntry.remove();
              this._overlayEntry = null;
              // pointerEnterEvent.obscured;

            //   Offset offsetOVerlay = _getPositions();
              
            // print("mouse entro pointer: ${(offsetOVerlay - pointerEnterEvent.position).distance}");
            // print("mouse entro pointer direction: ${offsetOVerlay.direction}");

            }
          },
          child: Column(
            children: barWidgets,
          ),
        );
      }
    );
  }

  _createLeftLabel({@required double maxValue, @required double width, @required double height}){
    double tmpMaxValue = 0;
    List<Widget> widgets = [];
    double valueToSubstractofTmpMaxValue = (maxValue / widget.leftLabelDivider);

    for (double i = 0; i < maxValue ; i++) {
      tmpMaxValue += valueToSubstractofTmpMaxValue;
      if(i == 0)
        widgets.add(
        Positioned(
          // top: (widget.leftLabelDivider / maxValue) * height,
          bottom: (i == 0) ? i + 8 : (i / maxValue) * height,
          child: Container(
            color: Colors.red,
            width: width,
            // height: (widget.leftLabelDivider / maxValue) * height,
            child: Align(
              alignment: Alignment.topRight,
              child: Wrap(
                alignment: WrapAlignment.end,
                children: [
                MyResizedContainer(child: Center(child: Text("0", style: TextStyle(fontSize: 11, fontFamily: "GoogleSans", fontWeight: FontWeight.bold))), small: 14, medium: 14, large: 11, xlarge: 16.8,),
                MyResizedContainer(child: Divider(), small: 1.15, medium: 1.12, large: 1.09, xlarge: 1.065, padding: EdgeInsets.only(left: 10.0, ))
              ],),
            ),
          ),
        )
      );
      else
      widgets.add(
        Positioned(
          // top: (widget.leftLabelDivider / maxValue) * height,
          bottom: (i == 0) ? i : ((i / maxValue) * height) + 12,
          child: Container(
            width: width,
            // height: (widget.leftLabelDivider / maxValue) * height,
            child: Align(
              alignment: Alignment.topRight,
              child: Wrap(children: [
                MyResizedContainer(child: Center(child: Text("${tmpMaxValue.toInt()}", style: TextStyle(fontSize: 11, fontFamily: "GoogleSans", fontWeight: FontWeight.bold))), small: 14, medium: 14, large: 11, xlarge: 16.8,),
                MyResizedContainer(child: Divider(), small: 1.15, medium: 1.12, large: 1.09, xlarge: 1.065, padding: EdgeInsets.only(left: 10.0, ),)
              ],),
            ),
          ),
        )
      );

      
      i += valueToSubstractofTmpMaxValue.toInt();
    }

    return widgets;
  }

  OverlayEntry _createOverlayEntry({@required BuildContext context, List<MyBar> bars, String bottomLabel}) {

    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        // left: offset.dx + widget.padding,
        // top: offset.dy + size.height - widget.padding,
        // width: getWidth(size.width) - (widget.padding * 2),
        // key: _overlayKey,
        left: offset.dx - 40,
        bottom: size.height + 40,
        width: getWidth(size.width) + 80,
        // height: 200,
        child:
        Material(
          // key: _overlayKey,
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            key: _overlayKey,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),// borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              // border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  // spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 1.0), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          // border: Border(bottom: BorderSide(width: 0.7, color: Colors.black38))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("$bottomLabel", style: TextStyle(fontSize: 12)),
                        )
                      ),
                    ),
                  ],
                ),
                Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: bars.map<Widget>((e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(width: 10, height: 10, decoration: BoxDecoration(color: e.color, borderRadius: BorderRadius.all(Radius.circular(10))),),
                        ),
                        RichText(text: TextSpan(
                          children: [
                            TextSpan(text: "${e.text} :  ", style: TextStyle(fontSize: 12, fontFamily: "GoogleSans")),
                            TextSpan(text: "${Utils.redondear(e.value)}", style: TextStyle(fontSize: 12, fontFamily: "GoogleSans", fontWeight: FontWeight.w600)),
                          ]
                        ))
                        ],
                        ),
                  )
                  ).toList(),
                )
              ],
            
            ),
          ),
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

  _getPositions() {
    // _overlayKey.currentState.context.fin
    final RenderBox renderBoxRed = _overlayKey.currentContext.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    return positionRed;
    // _overlayEntry.
    print("POSITION of Red: ${positionRed.distanceSquared} ");
  }

  @override
  void initState() {
    // TODO: implement initState
    _init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxconstraints) {
        double width = getWidth(boxconstraints.maxWidth);
        print("MyBarChart height: ${boxconstraints.minHeight}");
        return Container(
          // color: Colors.red,
          // width: MediaQuery.of(context).size.width / 2,
          width: width,
          height: MediaQuery.of(context).size.height / 1.6,
          // height: boxconstraints.maxHeight,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: _screen(width: width, height: (MediaQuery.of(context).size.height / 1.6) - 40)
              ),
            ),
          ),
         
        );
      }
    );
    // return MyResizedContainer(
    //   small: widget.small,
    //   medium: widget.medium,
    //   large: widget.large,
    //   xlarge: widget.xlarge,
    //   child: LayoutBuilder(
    //     builder: (context, boxconstraints) {
    //       return Container(
    //             color: Colors.red,
    //             // width: MediaQuery.of(context).size.width / 2,
    //             height: MediaQuery.of(context).size.height / 1.2,
    //             child: Center(
    //               child: Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Stack(
    //                   children: _screen(width: boxconstraints.maxWidth, height: MediaQuery.of(context).size.height / 1.2)
    //                 ),
    //               ),
    //             ),
               
    //           );
    //     }
    //   ),
    // );
  }
}

class MyBar {
  Color color;
  Function onTap;
  double width;
  double value;
  String text;
  MyBar({@required this.value, @required this.color, this.onTap, this.width, this.text});
}

class ScreenSize{
  static final double sm = 400;
  static final double md = 700;
  static final double lg = 1000;
  static final double xlg = 1300;

  static isSmall(double size){
    return size <= sm;
  }

  static isMedium(double size){
    return  size > sm && size <= md;
  }

  static isLarge(double size){
    return  size > md && size <= lg;
  }

  static isXLarge(double size){
    return  size > lg;
  }

  static ScreenSizeType isType(double size){
    if(ScreenSize.isSmall(size))
      return ScreenSizeType.sm;
    else if(ScreenSize.isMedium(size))
      return ScreenSizeType.md;
    else if(ScreenSize.isLarge(size))
      return ScreenSizeType.lg;
    else
      return ScreenSizeType.xlg;
  }
}

class ScreenSizeType{
  List<String> types = ["sm", "md", "large", "xlarge"];
  int index = 0;
  ScreenSizeType._(int index){
    this.index = index;
  }
  static ScreenSizeType sm = ScreenSizeType._(0);
  static ScreenSizeType md = ScreenSizeType._(1);
  static ScreenSizeType lg = ScreenSizeType._(2);
  static ScreenSizeType xlg = ScreenSizeType._(3);

  String toString() => "${types[index]}";
}