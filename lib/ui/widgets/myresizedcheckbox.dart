import 'package:flutter/material.dart';
import 'package:loterias/core/classes/screensize.dart';
import 'package:loterias/core/classes/utils.dart';

class MyResizedCheckBox extends StatefulWidget {
  final String title;
  final String titleSideCheckBox;
  final String helperText;
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;

  final double small;
  final double medium;
  final double large;
  final double xlarge;
  final double padding;

  final bool isSideTitle;
  final double flexOfSideText;
  final double flexOfSideField;

  final bool isRequired;
  final bool disable;
  MyResizedCheckBox({Key key, this.title = "", this.titleSideCheckBox = "", this.helperText = "", this.onChanged, this.value = false, this.small = 1, this.medium = 3, this.large = 4, this.xlarge = 5, this.padding = 8, this.isRequired = false, this.color, this.disable = false, this.isSideTitle = false, this.flexOfSideText = 3, this.flexOfSideField = 1.5}) : super(key: key);
  @override
  _MyResizedCheckBoxState createState() => _MyResizedCheckBoxState();
}

class _MyResizedCheckBoxState extends State<MyResizedCheckBox> {
  double _width;
  @override
  void initState() {
    // TODO: implement initState
    // _width = getWidth();
    super.initState();
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

  _screenwithSideTitle(double widthOfTheWidget){
    return Container(
                // color: Colors.red,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(10),
                //   border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid)
                // ),
                width: widthOfTheWidget, //El padding se multiplica por dos ya que el padding dado es el mismo para la izquiera y derecha
                // height: 50,
                child: Wrap(
                  children: [
                    Container(
                      width: widthOfTheWidget / widget.flexOfSideText,
                      child: Visibility(visible: widget.title != "",child: Text(widget.title, textAlign: TextAlign.start, style: TextStyle(color: widget.isSideTitle ? Utils.fromHex("#3c4043") : Colors.black, fontSize: 14, fontFamily: "GoogleSans",  letterSpacing: 0.4),)),
                    ),
                    Container(
                      width: widthOfTheWidget / widget.flexOfSideField,
                      child: AbsorbPointer(
                        absorbing: widget.disable,
                        child: InkWell(
                          onTap: (){
                            widget.onChanged(!widget.value);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                      height: 8,
                                      child: Checkbox(
                                        // useTapTarget: false,
                                        activeColor: (!widget.disable) ? (widget.color != null) ? widget.color : null : Colors.grey,
                                        value: widget.value,
                                        onChanged: widget.onChanged,
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: InkWell(
                                        onTap: (){
                                          widget.onChanged(!widget.value);
                                        },
                                        child: 
                                        // Text(widget.titleSideCheckBox,  overflow: TextOverflow.ellipsis, style: TextStyle(color: widget.disable ? Colors.grey : null, fontSize: 14, fontFamily: "GoogleSans",  letterSpacing: 0.4 )),
                                            Text(widget.titleSideCheckBox, style: TextStyle(color: widget.disable ? Colors.grey : null, fontSize: 14, fontFamily: "GoogleSans",  letterSpacing: 0.4 )),
                                        
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0, top: 2.0),
                                child: Text(widget.helperText, style: TextStyle(color: widget.disable ? Colors.grey : null, fontSize: 12, fontFamily: "GoogleSans",  letterSpacing: 0.1 )),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
              );
            
  }

  _screenWithNormalTitle(double widthOfTheWidget){
    return Container(
                // color: Colors.red,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(10),
                //   border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid)
                // ),
                width: widthOfTheWidget, //El padding se multiplica por dos ya que el padding dado es el mismo para la izquiera y derecha
                // height: 50,
                child: AbsorbPointer(
                  absorbing: widget.disable,
                  child: InkWell(
                    onTap: (){
                      widget.onChanged(!widget.value);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                          height: 8,
                          child: Checkbox(
                            // useTapTarget: false,
                            activeColor: (!widget.disable) ? (widget.color != null) ? widget.color : null : Colors.grey,
                            value: widget.value,
                            onChanged: widget.onChanged,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          child: 
                          widget.helperText.isEmpty
                          ?
                          InkWell(
                              onTap: (){
                                widget.onChanged(!widget.value);
                              },
                              child: Text(widget.title,  overflow: TextOverflow.ellipsis, style: TextStyle(color: widget.disable ? Colors.grey : null)),
                            )
                          :
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: (){
                                  widget.onChanged(!widget.value);
                                },
                                child: Text(widget.title,  overflow: TextOverflow.ellipsis, style: TextStyle(color: widget.disable ? Colors.grey : null)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 0, top: 2.0),
                                child: Text(widget.helperText, style: TextStyle(color: widget.disable ? Colors.grey : null, fontSize: 12, fontFamily: "GoogleSans",  letterSpacing: 0.1 )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                
              );
            
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxconstraints) {
        return (widget.isSideTitle) ? _screenwithSideTitle(getWidth(boxconstraints.maxWidth) - (widget.padding * 2)) : _screenWithNormalTitle(getWidth(boxconstraints.maxWidth) - (widget.padding * 2));
      }
    );
  }
}