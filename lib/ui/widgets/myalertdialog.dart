import 'package:flutter/material.dart';
import 'package:loterias/core/classes/screensize.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/widgets/mybutton.dart';
import 'myscrollbar.dart';


class MyAlertDialog extends StatefulWidget {
  final dynamic title;
  final String description;
  final Widget content;
  final String okDescription;
  final Function okFunction;
  final bool cargando;
  final ValueNotifier cargandoNotify;
  final bool isDeleteDialog;
  final String deleteDescripcion;
  final String thirdButtonTitle;
  final Function thirdButtonFunction;
  final Widget okButton;
  final bool isFlat;

  final double small;
  final double medium;
  final double large;
  final double xlarge;
  // final double padding;
  final Widget Function(BuildContext context, double width) builder;

  MyAlertDialog({Key key, @required this.title, @required this.content, this.description, this.okDescription = "Ok", @required this.okFunction, this.isDeleteDialog = false, this.deleteDescripcion = "Eliminar", this.cargando = false, this.cargandoNotify, this.thirdButtonTitle = "", this.thirdButtonFunction, this.builder, this.small = 1, this.medium = 1.6, this.large = 2.5, this.xlarge = 2.5, this.okButton, this.isFlat = false}) : super(key: key);
  @override
  _MyAlertDialogState createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
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

 
  _screen(double width){
    return LayoutBuilder(
      builder: (context, boxconstraints){
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              titlePadding: EdgeInsets.only(left: 24, right: 15, top: 10),
              contentPadding: EdgeInsets.fromLTRB(24.0, 0, 15.0, 5.0),
              title:
              Container(
                width: getWidth(width),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.title is Widget
                        ?
                        widget.title
                        :
                        Text(widget.title, style: TextStyle(fontFamily: "GoogleSans",fontSize: 18, color: Colors.black,fontWeight: FontWeight.w600)),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                        )
                      ],
                    ),
                      Padding(
                      // padding: const EdgeInsets.only(top: 3.0, bottom: 14, right: 3.0),
                      padding: const EdgeInsets.only(top: 3.0, bottom: 0, right: 3.0),
                      child: Text((widget.description != null) ? widget.description : "", style: TextStyle(fontFamily: "GoogleSans", fontSize: 14, fontWeight: FontWeight.w400, color: Utils.fromHex("#5f6368"), letterSpacing: 0.5),),
                    ),
                  ],
                ),
              )
              ,
              content: Container(
                // padding: EdgeInsets.only(bottom: 20),
                // width: MediaQuery.of(context).size.width / 2.5,
                width: getWidth(width),
                child: MyScrollbar(
                  child: 
                  widget.builder == null
                  ?
                  (widget.content != null) 
                  ? 
                  widget.content 
                  : 
                  SizedBox()
                  :
                  LayoutBuilder(
                    builder: (context, boxconstraints){
                      return widget.builder(context,getWidth(width));
                    }
                  )
                  ,
                ),
                // Wrap(
                //   children: [
                    
               
                //      Padding(
                //       padding: const EdgeInsets.only(top: 3.0, bottom: 14, right: 3.0),
                //       child: Text((widget.description != null) ? widget.description : "", style: TextStyle(fontFamily: "GoogleSans", fontSize: 14, fontWeight: FontWeight.w400, color: Utils.fromHex("#5f6368"), letterSpacing: 0.5),),
                //     ),
                //     (widget.content != null) ? SingleChildScrollView(child: widget.content) : SizedBox(),
                    
                //     // Padding(
                //     //   padding: const EdgeInsets.only(top: 18.0),
                //     //   child: Row(
                //     //     // mainAxisAlignment: MainAxisAlignment.end,
                //     //     children: [
                //     //       Visibility(
                //     //         visible: widget.cargando,
                //     //         child: Align(
                //     //           alignment: Alignment.topLeft,
                //     //           child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
                //     //         ),
                //     //       ),
                //     //       Expanded(
                //     //         child: Row(
                //     //           mainAxisAlignment: MainAxisAlignment.end,
                //     //           children: [
                //     //             Padding(
                //     //               padding: const EdgeInsets.only(bottom: 10.0),
                //     //               child: FlatButton(child: Text("Cancelar", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)), onPressed: (){Navigator.pop(context);}),
                //     //             ),
                //     //           // FlatButton(child: Text("Agregar", style: TextStyle(color: Utils.colorPrimaryBlue)), onPressed: () => _retornarReferencia(referencia: Referencia(nombre: _txtNombre.text, telefono: _txtTelefono.text, tipo: _tipo, parentesco: _parentesco)),),
                //     //             Visibility(
                //     //               visible: !widget.isDeleteDialog,
                //     //               child: Padding(
                //     //                 padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                //     //                 child: AbsorbPointer(
                //     //                   absorbing: widget.cargando,
                //     //                   child:  myButton(
                //     //                   text: "Ok",
                //     //                   function: widget.okFunction, 
                //     //                   color: (widget.cargando) ? Colors.grey[300] : null,
                //     //                   letterColor: (widget.cargando) ? Colors.grey : null,
                //     //                 ),
                //     //                 )
                //     //               ),
                //     //             ),
                //     //             Visibility(
                //     //               visible: widget.isDeleteDialog,
                //     //               child: Padding(
                //     //                 padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                //     //                 child: AbsorbPointer(
                //     //                   absorbing: widget.cargando,
                //     //                   child:  FlatButton(
                //     //                   child: Text(widget.deleteDescripcion, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: (widget.cargando) ? Colors.grey : Colors.red)),
                //     //                   onPressed: widget.okFunction, 
                //     //                   // color: (widget.cargando) ? Colors.grey[300] : null,
                //     //                 ),
                //     //                 )
                //     //               ),
                //     //             ),
                //     //           ],
                //     //         )
                //     //       )
            
                //     //     ],
                //     //   ),
                //     // )
                  
                //   ],
                // )
              
              ),
              actions: [
                Container(
                  // padding: EdgeInsets.only(right: 6.0),
                  width: getWidth(width),
                  child: Row(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              (widget.cargandoNotify != null)
                              ?
                              ValueListenableBuilder(
                                valueListenable: widget.cargandoNotify, 
                                builder: (context, value, _){
                                  return Visibility(
                                    visible: value,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
                                    ),
                                  );
                                }
                              )
                              :
                              Visibility(
                                visible: widget.cargando,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
                                ),
                              ),
                              Visibility(
                                visible: widget.thirdButtonFunction != null,
                                child: TextButton(
                                  // child: Text("${widget.thirdButtonTitle}", style: TextStyle(fontSize: 15, fontFamily: "GoogleSans", color: Utils.colorPrimaryBlue, fontWeight: FontWeight.bold),),
                                  child: Text("${widget.thirdButtonTitle}", style: TextStyle(fontSize: 15, fontFamily: "GoogleSans", color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold),),
                                  onPressed: widget.thirdButtonFunction,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Visibility(
                                      visible: widget.okFunction != null,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 4.0),
                                        child: TextButton(child: Text("Cancelar", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)), onPressed: (){Navigator.pop(context);}),
                                      ),
                                    ),
                                  // FlatButton(child: Text("Agregar", style: TextStyle(color: Utils.colorPrimaryBlue)), onPressed: () => _retornarReferencia(referencia: Referencia(nombre: _txtNombre.text, telefono: _txtTelefono.text, tipo: _tipo, parentesco: _parentesco)),),
                                    Visibility(
                                      visible: !widget.isDeleteDialog && (widget.okFunction != null || widget.okButton != null),
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 4, left: 20, right: 20),
                                        child: AbsorbPointer(
                                          absorbing: widget.cargando,
                                          child: 
                                          widget.okButton != null
                                          ?
                                          widget.okButton
                                          :
                                          widget.isFlat
                                          ?
                                          TextButton(onPressed: widget.okFunction, child: Text(widget.okDescription))
                                          :
                                          MyButton(
                                            // type: MyButtonType.noResponsive,
                                            isResponsive: false,
                                            title: widget.okDescription,
                                            function: widget.okFunction,
                                            color: (widget.cargando) ? Colors.grey[300] : null,
                                            textColor: (widget.cargando) ? Colors.grey : null,
                                          )
                                        //    myButton(
                                        //   text: widget.okDescription,
                                        //   function: widget.okFunction, 
                                        //   color: (widget.cargando) ? Colors.grey[300] : null,
                                        //   letterColor: (widget.cargando) ? Colors.grey : null,
                                        // ),
                                        )
                                      ),
                                    ),
                                    Visibility(
                                      visible: widget.isDeleteDialog,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 4, left: 10, right: 10),
                                        child: AbsorbPointer(
                                          absorbing: widget.cargando,
                                          child:  FlatButton(
                                          child: Text(widget.deleteDescripcion, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: (widget.cargando) ? Colors.grey : Colors.red)),
                                          onPressed: widget.okFunction, 
                                          // color: (widget.cargando) ? Colors.grey[300] : null,
                                        ),
                                        )
                                      ),
                                    ),
                                  ],
                                )
                              )
            
                            ],
                          ),
                ),
              ],

            //   actions: [
            //     Visibility(
            //       visible: widget.cargando,
            //       child: Align(
            //         alignment: Alignment.topLeft,
            //         child: CircularProgressIndicator(),
            //       ),
            //     ),
            //   Padding(
            //     padding: const EdgeInsets.only(bottom: 10.0),
            //     child: FlatButton(child: Text("Cancelar", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)), onPressed: (){Navigator.pop(context);}),
            //   ),
            // // FlatButton(child: Text("Agregar", style: TextStyle(color: Utils.colorPrimaryBlue)), onPressed: () => _retornarReferencia(referencia: Referencia(nombre: _txtNombre.text, telefono: _txtTelefono.text, tipo: _tipo, parentesco: _parentesco)),),
            //   Padding(
            //     padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            //     child: myButton(
            //       text: "Ok",
            //       function: widget.okFunction, 
            //     ),
            //   ),
            
            //   ],
            );
          }
        );
      
    //     Container(
    //   // color: Colors.red,
    //   // decoration: BoxDecoration(
    //   //   borderRadius: BorderRadius.circular(10),
    //   //   border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid)
    //   // ),
    //   width: getWidth(width) - (widget.padding * 2), //El padding se multiplica por dos ya que el padding dado es el mismo para la izquiera y derecha
    //   // height: 50,
    //   child:
    //   (widget.labelText == "")
    //   ?
    //    TextFormField(
    //      enabled: widget.enabled,
    //       controller: widget.controller,
    //       maxLines: widget.maxLines,
    //       keyboardType: (widget.maxLines != 1) ? TextInputType.multiline : null,
    //       style: TextStyle(fontSize: 15),
    //         decoration: InputDecoration(
    //           hintText: widget.hint,
    //           contentPadding: EdgeInsets.all(10),
    //           isDense: true,
    //           border: new OutlineInputBorder(
    //             // borderRadius: new BorderRadius.circular(25.0),
    //             borderSide: new BorderSide(),
    //           ),
    //         ),
    //         validator: (data){
    //           if(data.isEmpty && widget.isRequired)
    //             return "Campo requerido";
    //           return null;
    //         },
    //       )
    //     :
    //     TextFormField(
    //       controller: widget.controller,
    //       maxLines: widget.maxLines,
    //       keyboardType: (widget.maxLines != 1) ? TextInputType.multiline : null,
    //       style: TextStyle(fontSize: 15),
    //         decoration: InputDecoration(
    //           labelText: widget.labelText
    //         ),
    //         validator: (data){
    //           if(data.isEmpty && widget.isRequired)
    //             return "Campo requerido";
    //           return null;
    //         },
    //       ),
    // );
          
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxconstraints) {
        // print("mytextformfield boxconstrants: ${boxconstraints.maxWidth}");
        return _screen(boxconstraints.maxWidth);
      }
    );
  }
}