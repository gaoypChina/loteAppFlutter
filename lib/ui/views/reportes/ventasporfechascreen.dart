import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/models/ventaporfecha.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/mymultiselect.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/showmymodalbottomsheet.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';
import 'package:rxdart/rxdart.dart';

class VentasPorFechaScreen extends StatefulWidget {
  const VentasPorFechaScreen({ Key key }) : super(key: key);

  @override
  _VentasPorFechaScreenState createState() => _VentasPorFechaScreenState();
}

class _VentasPorFechaScreenState extends State<VentasPorFechaScreen> {
  StreamController<List<VentaPorFecha>> _streamController;
  StreamController<List<Moneda>> _streamControllerMoneda;
  StreamController<List<Banca>> _streamControllerBanca;
  DateTimeRange _date;
  MyDate _fecha;
  List<VentaPorFecha> listaData;
  List<Banca> listaBanca;
  List<Banca> _bancas = [];
  List<Moneda> listaMoneda;
  Moneda _moneda;

  _getData() async {
     try {
       _streamController.add(null);
       var parsed = await ReporteService.ventasPorFecha(context: context, date: _date, bancas: _bancas, moneda: _moneda.id != 0 ? _moneda : null, retornarBancas: false, retornarMonedas: false);
       listaData = parsed["data"].map<VentaPorFecha>((e) => VentaPorFecha.fromMap(e)).toList();
       _streamController.add(listaData);
     } on Exception catch (e) {
        _streamController.add([]);
     }
  }

  _init() async {
    _date = MyDate.getTodayDateRange();
     var parsed = await ReporteService.ventasPorFecha(context: context, date: _date, retornarMonedas: true, retornarBancas: true);
     listaData = parsed["data"].map<VentaPorFecha>((e) => VentaPorFecha.fromMap(e)).toList();
     listaBanca = parsed["bancas"].map<Banca>((e) => Banca.fromMap(e)).toList();
     listaMoneda = parsed["monedas"].map<Moneda>((e) => Moneda.fromMap(e)).toList();
     if(listaMoneda.length > 0)
      listaMoneda.insert(0, Moneda(0, "Todas las monedas", "", "", 0, null));

    _moneda = listaMoneda[0];
    _streamController.add(listaData);
    _streamControllerMoneda.add(listaMoneda);
    _streamControllerBanca.add(listaBanca);
  }

  _dateChanged(date){
    setState((){
      _date = date;
      _fecha = MyDate.dateRangeToMyDate(date);
      _getData();
    });
  }

  _subtitle(bool isSmallOrMedium){
    return
    isSmallOrMedium
    ?
    MyCollapseChanged(
      child: MyFilter(
        filterTitle: '',
        filterLeading: SizedBox.shrink(),
        leading: SizedBox.shrink(),
        value: _date,
        paddingContainer: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
        onChanged: _dateChanged,
        showListNormalCortaLarga: 3,
      ),
    )
    :
    "Filtre y agrupe todas las ventas por fecha.";
  }

  _listTile(VentaPorFecha ventaPorFecha, int index){
      return Container(
        padding: EdgeInsets.all(10),
        child: ListTile(
          leading: Text("${index + 1}"),
          // title: Text("${ventaPorFecha.usuario} ( ${ventaPorFecha.banca} )"),
          title: Text("${MyDate.dateRangeToNameOrString(DateTimeRange(start: ventaPorFecha.created_at, end: ventaPorFecha.created_at))}"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "${Utils.toCurrency(ventaPorFecha.ventas)} ventas"),
                    TextSpan(text: "  •  ${Utils.toCurrency(ventaPorFecha.premios)} premios"),
                  ]
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "${Utils.toCurrency(ventaPorFecha.comisiones)} comisiones"),
                    TextSpan(text: "  •  ${Utils.toCurrency(ventaPorFecha.descuentoMonto)} descuentos"),
                  ]
                ),
              )
            ],
          ),
          
          trailing: Text("${Utils.toCurrency(ventaPorFecha.neto)}", style: TextStyle(color: ventaPorFecha.neto > 0 ? Colors.green[600] : Colors.pink),),
        ),
      );
  }

_showDialogBancas(AsyncSnapshot snapshot) async {
    var bancasRetornadas = await showDialog(
      context: context, 
      builder: (context){
        return MyMultiselect(
          title: "Agregar bancas",
          items: snapshot.data != null ? snapshot.data.map<MyValue>((e) => MyValue(value: e, child: "${e.descripcion}")).toList() : [],
          initialSelectedItems: _bancas.length == 0 ? [] : _bancas.map<MyValue>((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
        );
      }
    );

    setState((){
      _bancas = bancasRetornadas != null ? List.from(bancasRetornadas) : [];
      _getData();
    });
  }

  _bancasWidget(bool isSmallOrMedium){
    return Padding(
    padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0.0 : 8.0, vertical: isSmallOrMedium ? 10 : 0),
      child: StreamBuilder<List<Banca>>(
        stream: _streamControllerBanca.stream,
        builder: (context, snapshot) {
          return MyDropdown(
            title: "Bancas", 
            xlarge: 5.8,
            large: 5.8,
            hint: "${_bancas.length > 0 ? _bancas.map((e) => e.descripcion).join(", ") : "Selec. bancas "}",
            onTap: (){
              _showDialogBancas(snapshot);
            },
          );
        }
      ),
    );
  }

  _monedasWidget(bool isSmallOrMedium){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0.0 : 8.0, vertical: isSmallOrMedium ? 10 : 0),
      child: StreamBuilder<List<Moneda>>(
          stream: _streamControllerMoneda.stream,
          builder: (context, snapshot) {
            if(snapshot.data == null)
              return SizedBox.shrink();

            return MyDropdownButton(
              title: "Moneda",
              hint: "Selec. moneda",
              xlarge: 5.8,
              large: 5.8,
              value: _moneda,
              items: snapshot.data.map((e) => [e, "${e.descripcion}"]).toList(),
              onChanged: (data){
                setState((){
                  _moneda = data;
                  if(data != null){
                    _bancas = [];
                    _streamControllerBanca.add(listaBanca.where((element) => element.idMoneda == data.id).toList());
                  }
                  _getData();
                });
              }
            );
          }
        ),
    );
                
  }

  @override
  void initState() {
    // TODO: implement initState
    _streamController = BehaviorSubject();
    _streamControllerMoneda = BehaviorSubject();
    _streamControllerBanca = BehaviorSubject();
    initializeDateFormatting();
    _init();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey(); 

  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      key: _key,
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Ventas por fecha",
          subtitle: _subtitle(isSmallOrMedium),
          expandedHeight: isSmallOrMedium ? 105 : 85,
          actions: [
            MySliverButton(
              title: "title", 
              iconWhenSmallScreen: Icons.date_range,
              showOnlyOnSmall: true,
              onTap: () async {
                if(isSmallOrMedium){
                  // var date = await showDatePicker(context: context, initialDate: _date.start, firstDate: DateTime.now().subtract(Duration(days: 365 * 5)), lastDate: DateTime.now().add(Duration(days: 365 * 2)));
                  // if(date == null)
                  //   return;
                  // _dateChanged(DateTimeRange(
                  //   start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00:00"),
                  //   end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59"),
                  // ));
                  _back(){
                    Navigator.pop(context);
                  }
                  showMyModalBottomSheet(
                    context: context,
                    myBottomSheet2: MyBottomSheet2(
                      height: 450,
                      child: MyDateRangeDialog(
                        date: _date, 
                        onCancel: _back, 
                        onOk: (date){
                                print("SesionesScreen date: ${date}");
                                _dateChanged(date); 
                                _back();
                                // overlay.remove();
                              },
                              )
                            
                    )
                  );
                }
              }
            ),
            
            MySliverButton(
              title: "title", 
              iconWhenSmallScreen: Icons.filter_alt_rounded,
              showOnlyOnSmall: true,
              onTap: () async {
                if(isSmallOrMedium){
                  List data = await showDialog(
                    context: context, 
                    builder: (context){
                      return StatefulBuilder(
                        builder: (context, setState) {
                          _back(){
                            Navigator.pop(context);
                          }
                          _guardarFiltro(){
                            Navigator.pop(context, [_bancas, _moneda]);
                          }

                          showDialogBancas(AsyncSnapshot snapshot) async {
                            var bancasRetornadas = await showDialog(
                              context: context, 
                              builder: (context){
                                return MyMultiselect(
                                  title: "Agregar bancas",
                                  items: snapshot.data != null ? snapshot.data.map<MyValue>((e) => MyValue(value: e, child: "${e.descripcion}")).toList() : [],
                                  initialSelectedItems: _bancas.length == 0 ? [] : _bancas.map<MyValue>((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
                                );
                              }
                            );

                            setState((){
                              _bancas = bancasRetornadas != null ? List.from(bancasRetornadas) : [];
                            });
                          }

                          bancasWidget(bool isSmallOrMedium){
                            return Padding(
                            padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0.0 : 8.0, vertical: isSmallOrMedium ? 10 : 0),
                              child: StreamBuilder<List<Banca>>(
                                stream: _streamControllerBanca.stream,
                                builder: (context, snapshot) {
                                  return MyDropdown(
                                    title: "Bancas", 
                                    xlarge: 5.8,
                                    large: 5.8,
                                    hint: "${_bancas.length > 0 ? _bancas.map((e) => e.descripcion).join(", ") : "Selec. bancas "}",
                                    onTap: (){
                                      showDialogBancas(snapshot);
                                    },
                                  );
                                }
                              ),
                            );
                          }

                          monedasWidget(bool isSmallOrMedium){
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0.0 : 8.0, vertical: isSmallOrMedium ? 10 : 0),
                              child: StreamBuilder<List<Moneda>>(
                                  stream: _streamControllerMoneda.stream,
                                  builder: (context, snapshot) {
                                    if(snapshot.data == null)
                                      return SizedBox.shrink();

                                    return MyDropdownButton(
                                      title: "Moneda",
                                      hint: "Selec. moneda",
                                      xlarge: 5.8,
                                      large: 5.8,
                                      value: _moneda,
                                      items: snapshot.data.map((e) => [e, "${e.descripcion}"]).toList(),
                                      onChanged: (data){
                                        setState((){
                                          _moneda = data;
                                          if(data != null){
                                            _bancas = [];
                                            _streamControllerBanca.add(listaBanca.where((element) => element.idMoneda == data.id).toList());
                                          }
                                        });
                                      }
                                    );
                                  }
                                ),
                            );
                                        
                          }


                          return MyAlertDialog(
                            title: "Filtrar", 
                            content: Wrap(
                              children: [
                                monedasWidget(isSmallOrMedium),
                                bancasWidget(isSmallOrMedium),
                              ],
                            ), 
                            okFunction: _guardarFiltro
                          );
                        }
                      );
                    }
                  );                  
                  if(data == null)
                    return;

                  setState(() {
                    _bancas = data[0];
                    _moneda = data[1];
                    _getData();
                  });
                }
              }
            ),
            
            // MySliverButton(
            //   showOnlyOnLarge: true,
            //   title: Padding(
            //     padding: const EdgeInsets.only(top: 5.0),
            //     child: Container(
            //       width: 180,
            //       child: StreamBuilder<List<Moneda>>(
            //         stream: _streamControllerMoneda.stream,
            //         builder: (context, snapshot) {
            //           if(snapshot.data == null)
            //             return SizedBox.shrink();

            //           return MyDropdownButton(
            //             hint: "Selec. moneda",
            //             value: _moneda,
            //             items: snapshot.data.map((e) => [e, "${e.descripcion}"]).toList(),
            //             onChanged: (data){
            //               setState((){
            //                 _moneda = data;
            //                 if(data != null){
            //                   _bancas = [];
            //                   _streamControllerBanca.add(listaBanca.where((element) => element.idMoneda == data.id).toList());
            //                 }
            //                 _getData();
            //               });
            //             }
            //           );
            //         }
            //       )
            //     ),
            //   ), 
            //   onTap: (){}
            // ),
            // MySliverButton(
            //   showOnlyOnLarge: true,
            //   title: Container(
            //     width: 180,
            //     child: Container(
            //     child: StreamBuilder<List<Banca>>(
            //       stream: _streamControllerBanca.stream,
            //       builder: (context, snapshot) {
            //         if(snapshot.data == null)
            //           return SizedBox.shrink();

            //         return GestureDetector(
            //           onTap: () async {
            //               var bancasRetornadas = await showDialog(
            //                 context: context, 
            //                 builder: (context){
            //                   return MyMultiselect(
            //                     title: "Agregar bancas",
            //                     items: snapshot.data.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
            //                     initialSelectedItems: _bancas.length == 0 ? [] : _bancas.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
            //                   );
            //                 }
            //               );

            //                 setState((){
            //                   _bancas = bancasRetornadas != null ? List.from(bancasRetornadas) : [];
            //                   _getData();
            //                 });
            //             },
            //           child: Container(
            //             width: 180,
            //             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            //             decoration: BoxDecoration(
            //               border: Border.all(color: Colors.grey),
            //               borderRadius: BorderRadius.all(Radius.circular(7))
            //             ),
            //             child: Wrap(
            //               alignment: WrapAlignment.spaceBetween,
            //               crossAxisAlignment: WrapCrossAlignment.center,
            //               children: [
            //                 Text(_bancas.length > 0 ? _bancas.map((e) => e.descripcion).join(", ") : "Selec. bancas ", style: TextStyle(color: Theme.of(context).primaryColor),),
            //                 Icon(Icons.arrow_drop_down,)
            //               ],
            //             )
            //             // ListTile(
            //             //   // leading: Icon(Icons.ballot),
            //             //   trailing: Icon(Icons.arrow_downward),
            //             //   minVerticalPadding: 0,
            //             //   contentPadding: EdgeInsets.all(0),
            //             //   title: Text(_bancas.length > 0 ? _bancas.map((e) => e.descripcion).join(", ") : "Selec. bancas "),
                          
            //             // ),
            //           ),
            //         );
            //       }
            //     ),
            //   ),
            //   ), 
            //   onTap: (){}
            // ),
            
            // MySliverButton(
            //   showOnlyOnLarge: true,
            //   title: Padding(
            //     padding: const EdgeInsets.only(top: 5.0),
            //     child: Container(
            //       width: 180,
            //       child: Builder(
            //         builder: (context) {
            //           return MyDropdown(title: null, 
            //             hint: "${MyDate.dateRangeToNameOrString(_date)}",
            //             onTap: () async {
                          

            //               showMyOverlayEntry(
            //                 context: context,
            //                 builder: (context, overlay){
            //                   _cancel(){
            //                     overlay.remove();
            //                   }
            //                   return MyDateRangeDialog(date: _date, onCancel: _cancel, onOk: (date){
            //                     print("SesionesScreen date: ${date}");
            //                     _dateChanged(date); 
            //                     overlay.remove();
            //                   },);
            //                 }
            //               );
            //             },
            //           );
                     
            //         }
            //       ),
            //     ),
            //   ), 
            //   onTap: (){}
            // ),
            
          
          ],
        ), 
        sliver: StreamBuilder<List<VentaPorFecha>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            
            

            if(isSmallOrMedium){
              if(snapshot.data == null)
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(),),
                );

              if(snapshot.data.length == 0 && isSmallOrMedium)
                return SliverFillRemaining(child: MyEmpty(title: "No hay datos", titleButton: "No hay datos", icon: Icons.do_disturb_alt_sharp,));

              return SliverFillRemaining(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                  if(index == 0)
                    return Column(
                      children: [
                        // ListTile(
                        //   selectedTileColor: ,
                        //   leading: Text("ID"),
                        //   title: Text("Usuario"),
                        //   trailing: Text("Banca"),
                        // ),
                         Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          // color: Colors.amber,
                          color: Colors.grey[100],
                          child: ListTile(
                            leading: Text('ID'),
                            title: Text('Fecha'),
                            trailing: Text('Neto'),
                          ),
                        ),
                        _listTile(snapshot.data[index], index)
                      ],
                    );
                  return _listTile(snapshot.data[index], index);
                }
              ),
            );
            }

          if(snapshot.data == null && snapshot.connectionState == ConnectionState.waiting)
            return SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(),),
            );

          List<Widget> widgets = [
            MySubtitle(title: "${snapshot.data != null ? snapshot.data.length : 0} Datos"),
            Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0, right: isSmallOrMedium ? 0.0 : 8.0),
                  child: Builder(
                    builder: (context) {
                      return MyDropdown(
                        xlarge: 5.8,
                        large: 5.8,
                        title: "Fecha", 
                        hint: "${MyDate.dateRangeToNameOrString(_date)}",
                        onTap: () async {
                          
                  
                          showMyOverlayEntry(
                            context: context,
                            builder: (context, overlay){
                              _cancel(){
                                overlay.remove();
                              }
                              return MyDateRangeDialog(date: _date, onCancel: _cancel, onOk: (date){
                                print("SesionesScreen date: ${date}");
                                _dateChanged(date); 
                                overlay.remove();
                              },);
                            }
                          );
                        },
                      );
                    }
                  ),
                ),
                _bancasWidget(isSmallOrMedium),
                _monedasWidget(isSmallOrMedium)
              ],
            ),
          ];
          if(snapshot.data == null){
            widgets.add(Expanded(child: Center(child: CircularProgressIndicator(),),));
            return SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgets,
              ),
            );
          }
          if(snapshot.data.length == 0){
            widgets.add(Expanded(child: Center(child: MyEmpty(title: "No hay datos", titleButton: "No hay datos", icon: Icons.do_disturb_alt_sharp,),),));
            return SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgets,
              ),
            );
          }

          if(snapshot.data != null){
            if(snapshot.data.length > 1)
              widgets.add(Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Container(
                height: 700,
                child: MyTable(
                  // isScrolled: false,
                  showColorWhenImpar: true,
                  columns: ["Fecha", "Ventas", "Premios", "Comisiones", "Descuentos", "Neto"], 
                  bottom: [
                    "TOTAL", 
                    "${_moneda != null ? _moneda.abreviatura : ''}${Utils.toCurrency(snapshot.data.map((e) => e.ventas).toList().reduce((value, element) => value + element), _moneda.id != 0)}", 
                    "${_moneda != null ? _moneda.abreviatura : ''}${Utils.toCurrency(snapshot.data.map((e) => e.premios).toList().reduce((value, element) => value + element), _moneda.id != 0)}", 
                    "${_moneda != null ? _moneda.abreviatura : ''}${Utils.toCurrency(snapshot.data.map((e) => e.comisiones).toList().reduce((value, element) => value + element), _moneda.id != 0)}", 
                    "${_moneda != null ? _moneda.abreviatura : ''}${Utils.toCurrency(snapshot.data.map((e) => e.descuentoMonto).toList().reduce((value, element) => value + element), _moneda.id != 0)}", 
                    "${_moneda != null ? _moneda.abreviatura : ''}${Utils.toCurrency(snapshot.data.map((e) => e.neto).toList().reduce((value, element) => value + element), _moneda.id != 0)}"
                  ], 
                  rows: snapshot.data.map((e) => [
                    e, 
                    "${MyDate.dateRangeToNameOrString(DateTimeRange(start: e.created_at, end: e.created_at))}", 
                    "${Utils.toCurrency(e.ventas, true)}", 
                    "${Utils.toCurrency(e.premios, true)}", 
                    "${Utils.toCurrency(e.comisiones, true)}", 
                    "${Utils.toCurrency(e.descuentoMonto, true)}", 
                    // Container(color: e.neto < 0 ? Colors.pink[100] : Theme.of(context).primaryColor.withOpacity(0.3),child: Center(child: Text("${Utils.toCurrency(e.neto, true)}"))), 
                    MyTableCell(child: Center(child: Text("${Utils.toCurrency(e.neto, true)}")), value: e, color: e.neto < 0 ? Colors.pink[100] : Theme.of(context).primaryColor.withOpacity(0.3))
                  ]).toList(),
                ),
            ),
              ));
            else
              widgets.add(Center(child: MyEmpty(title: "No hay datos", titleButton: "No hay datos", icon: Icons.do_disturb_alt_sharp,)));
          }

          return SliverList(delegate: SliverChildListDelegate(widgets));

          }
        )
      
      )
    );
  }
}