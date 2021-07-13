import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/models/ventaporfecha.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/myfilter2.dart';
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
  GlobalKey<MyFilter2State> _myFilterKey = GlobalKey();
  StreamController<List<VentaPorFecha>> _streamController;
  StreamController<List<Moneda>> _streamControllerMoneda;
  StreamController<List<Banca>> _streamControllerBanca;
  DateTimeRange _date;
  MyDate _fecha;
  List<VentaPorFecha> listaData;
  List<Banca> listaBanca;
  List<Grupo> listaGrupo;
  List<Banca> _bancas = [];
  List<Moneda> listaMoneda;
  List<Moneda> _monedas = [];
  List<Grupo> _grupos = [];
  List<MyFilterSubData2> _selectedFilter = [];
  List<MyFilterData2> listaFiltros = [];
  int _idGrupoDeEsteUsuario;


  _getData() async {
     try {
       _streamController.add(null);
       var parsed = await ReporteService.ventasPorFecha(context: context, date: _date, idGrupos: _grupos.map((e) => e.id).toList(), idBancas: _bancas.map((e) => e.id).toList(), idMonedas: _monedas.map((e) => e.id).toList(),);
       listaData = parsed["data"].map<VentaPorFecha>((e) => VentaPorFecha.fromMap(e)).toList();
       _streamController.add(listaData);
     } on Exception catch (e) {
        _streamController.add([]);
     }
  }

  _init() async {
    _date = MyDate.getTodayDateRange();
      _idGrupoDeEsteUsuario = await Db.idGrupo();
     var parsed = await ReporteService.ventasPorFecha(context: context, date: _date, retornarMonedas: true, retornarBancas: true, retornarGrupos: true, idGrupos: _idGrupoDeEsteUsuario != null ? [_idGrupoDeEsteUsuario] : []);
     listaData = parsed["data"].map<VentaPorFecha>((e) => VentaPorFecha.fromMap(e)).toList();
     listaBanca = parsed["bancas"].map<Banca>((e) => Banca.fromMap(e)).toList();
     listaMoneda = parsed["monedas"].map<Moneda>((e) => Moneda.fromMap(e)).toList();
     listaGrupo = parsed["grupos"].map<Grupo>((e) => Grupo.fromMap(e)).toList();
     if(listaMoneda.length > 0){
      listaFiltros.add(MyFilterData2(child: "Moneda", data: listaMoneda.map((e) => MyFilterSubData2(child: e.descripcion, value: e)).toList()));
    }
    if(listaBanca.length > 0){
      listaFiltros.add(MyFilterData2(child: "Banca", isMultiple: true, data: listaBanca.map((e) => MyFilterSubData2(child: e.descripcion, value: e)).toList()));
    }
    if(listaBanca.length > 0){
      var filtroGrupo = MyFilterData2(child: "Grupo", isMultiple: true, fixed: _idGrupoDeEsteUsuario != null, enabled: _idGrupoDeEsteUsuario == null, data: listaGrupo.map((e) => MyFilterSubData2(child: e.descripcion, value: e)).toList());
      listaFiltros.add(filtroGrupo);
      if(_idGrupoDeEsteUsuario != null){
        setState(() {
          _selectedFilter.add(filtroGrupo.data.firstWhere((element) => element.value.id == _idGrupoDeEsteUsuario, orElse: () => null));
        });
        _grupos = listaGrupo.where((element) => element.id == _idGrupoDeEsteUsuario).toList();
      }
    }


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

  _myFilterWidget(bool isSmallOrMedium){
    return MyFilter2(
            key: _myFilterKey,
            xlarge: 1.1,
            large: 1.1,
            medium: 1,
            small: 1,
            leading: 
            !isSmallOrMedium
            ?
            null
            :
            _selectedFilter.length == 0
            ?
            SizedBox.shrink()
            :
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    _back(){
                      Navigator.pop(context);
                    }
                    showMyModalBottomSheet(
                      context: context, 
                      myBottomSheet2: MyBottomSheet2(
                        child: MyDateRangeDialog(
                          date: _date,
                          onCancel: _back,
                          onOk: (date){
                            _dateChanged(date);
                            _back();
                          },
                        ), 
                      height: 350
                      )
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blue[900]),
                        color: Colors.grey[200]
                      ),
                      child: Center(child: Text(MyDate.dateRangeToNameOrString(_date), style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700)),),
                    ),
                  ),
                ),
                Container(height: 34, width: 1, color: Colors.grey),
              ],
            )
            ,
            widgetWhenNoFilter: Expanded(
              child: MyFilter(
                filterTitle: '',
                filterLeading: SizedBox.shrink(),
                leading: SizedBox.shrink(),
                value: _date,
                paddingContainer: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                onChanged: _dateChanged,
                showListNormalCortaLarga: 3,
              ),
            ),
            onChanged: (data){
              
              if(data.length == 0){
                setState(() {
                  _selectedFilter = [];
                  _bancas = [];
                  _monedas = []; 
                  _grupos = [];
                  _getData();
                });
                return;
              }

              _grupos = [];
              _bancas = [];
              _monedas = []; 
              setState(() {
                _selectedFilter = data;
                for (MyFilterSubData2 myFilterSubData2 in data) {
                  print("HistoricoVentas Filter2 for subData: ${myFilterSubData2.type} value: ${myFilterSubData2.value}");
                  if(myFilterSubData2.type == "Banca")
                    _bancas.add(myFilterSubData2.value);
                  else if(myFilterSubData2.type == "Moneda")
                    _monedas.add(myFilterSubData2.value);
                  if(myFilterSubData2.type == "Grupo")
                    _grupos.add(myFilterSubData2.value);
                }
                _getData();
              });
              
            },
            onDelete: (data){
              setState(() {
                if(data.child == "Banca")
                  _bancas = [];
                if(data.child == "Grupo")
                  _grupos = [];
                if(data.child == "Moneda" )
                  _monedas = [];
                for (var element in data.data) {
                  _selectedFilter.remove(element);
                }
                _getData();
              });
            },
            onDeleteAll: (values){
              setState((){
                // _selectedFilter = [];
                for (var item in values) {
                  _selectedFilter.removeWhere((element) => element.type == item.child);
                  if(item.child == "Banca")
                  _bancas = [];
                  if(item.child == "Grupo")
                    _grupos = [];
                  if(item.child == "Moneda" )
                    _monedas = [];
                }
                _getData();
              });
            },
            data: listaFiltros,
            values: _selectedFilter
          );
  
  }

  _myWebFilterScreen(bool isSmallOrMedium){
    return 
    isSmallOrMedium
    ?
    SizedBox.shrink()
    :
    Padding(
      padding: EdgeInsets.only(bottom: isSmallOrMedium ? 0 : 0, top: 5),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // _mydropdown(),
          // MyDropdown(
          //   large: 5.8,
          //   title: "Filtrar",
          //   hint: "${_selectedOption != null ? _selectedOption : 'No hay opcion'}",
          //   elements: listaOpciones.map((e) => [e, "$e"]).toList(),
          //   onTap: (value){
          //     _opcionChanged(value);
          //   },
          // ),
          // MyDropdown(
          //   large: 5.8,
          //   title: "Grupos",
          //   hint: "${_grupo != null ? _grupo.descripcion : 'No hay grupo'}",
          //   elements: listaGrupo.map((e) => [e, "$e"]).toList(),
          //   onTap: (value){
          //     _opcionChanged(value);
          //   },
          // ),
         _myFilterWidget(isSmallOrMedium),
          // Padding(
          //   padding: EdgeInsets.only(right: 15.0, top: 18.0, bottom: !isSmallOrMedium ? 20 : 0),
          //   child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar banca...", xlarge: 2.6, showOnlyOnLarge: true,),
          // ),
          MyDivider(showOnlyOnLarge: true, padding: EdgeInsets.only(left: isSmallOrMedium ? 4 : 0, right: 10.0, top: 5),),
        ],
      ),
    );
  }


  _subtitle(bool isSmallOrMedium){
    return
    isSmallOrMedium
    ?
    MyCollapseChanged(
      child: 
      
          _myFilterWidget(isSmallOrMedium)
        
      ,
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
    // return Padding(
    //   padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0.0 : 8.0, vertical: isSmallOrMedium ? 10 : 0),
    //   child: StreamBuilder<List<Moneda>>(
    //       stream: _streamControllerMoneda.stream,
    //       builder: (context, snapshot) {
    //         if(snapshot.data == null)
    //           return SizedBox.shrink();

    //         return MyDropdownButton(
    //           title: "Moneda",
    //           hint: "Selec. moneda",
    //           xlarge: 5.8,
    //           large: 5.8,
    //           value: _moneda,
    //           items: snapshot.data.map((e) => [e, "${e.descripcion}"]).toList(),
    //           onChanged: (data){
    //             setState((){
    //               _moneda = data;
    //               if(data != null){
    //                 _bancas = [];
    //                 _streamControllerBanca.add(listaBanca.where((element) => element.idMoneda == data.id).toList());
    //               }
    //               _getData();
    //             });
    //           }
    //         );
    //       }
    //     ),
    // );
                
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
                  _myFilterKey.currentState.openFilter(context);
                  // List data = await showDialog(
                  //   context: context, 
                  //   builder: (context){
                  //     return StatefulBuilder(
                  //       builder: (context, setState) {
                  //         _back(){
                  //           Navigator.pop(context);
                  //         }
                  //         _guardarFiltro(){
                  //           Navigator.pop(context, [_bancas, _moneda]);
                  //         }

                  //         showDialogBancas(AsyncSnapshot snapshot) async {
                  //           var bancasRetornadas = await showDialog(
                  //             context: context, 
                  //             builder: (context){
                  //               return MyMultiselect(
                  //                 title: "Agregar bancas",
                  //                 items: snapshot.data != null ? snapshot.data.map<MyValue>((e) => MyValue(value: e, child: "${e.descripcion}")).toList() : [],
                  //                 initialSelectedItems: _bancas.length == 0 ? [] : _bancas.map<MyValue>((e) => MyValue(value: e, child: "${e.descripcion}")).toList()
                  //               );
                  //             }
                  //           );

                  //           setState((){
                  //             _bancas = bancasRetornadas != null ? List.from(bancasRetornadas) : [];
                  //           });
                  //         }

                  //         bancasWidget(bool isSmallOrMedium){
                  //           return Padding(
                  //           padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0.0 : 8.0, vertical: isSmallOrMedium ? 10 : 0),
                  //             child: StreamBuilder<List<Banca>>(
                  //               stream: _streamControllerBanca.stream,
                  //               builder: (context, snapshot) {
                  //                 return MyDropdown(
                  //                   title: "Bancas", 
                  //                   xlarge: 5.8,
                  //                   large: 5.8,
                  //                   hint: "${_bancas.length > 0 ? _bancas.map((e) => e.descripcion).join(", ") : "Selec. bancas "}",
                  //                   onTap: (){
                  //                     showDialogBancas(snapshot);
                  //                   },
                  //                 );
                  //               }
                  //             ),
                  //           );
                  //         }

                  //         monedasWidget(bool isSmallOrMedium){
                  //           return Padding(
                  //             padding: EdgeInsets.symmetric(horizontal: isSmallOrMedium ? 0.0 : 8.0, vertical: isSmallOrMedium ? 10 : 0),
                  //             child: StreamBuilder<List<Moneda>>(
                  //                 stream: _streamControllerMoneda.stream,
                  //                 builder: (context, snapshot) {
                  //                   if(snapshot.data == null)
                  //                     return SizedBox.shrink();

                  //                   return MyDropdownButton(
                  //                     title: "Moneda",
                  //                     hint: "Selec. moneda",
                  //                     xlarge: 5.8,
                  //                     large: 5.8,
                  //                     value: _moneda,
                  //                     items: snapshot.data.map((e) => [e, "${e.descripcion}"]).toList(),
                  //                     onChanged: (data){
                  //                       setState((){
                  //                         _moneda = data;
                  //                         if(data != null){
                  //                           _bancas = [];
                  //                           _streamControllerBanca.add(listaBanca.where((element) => element.idMoneda == data.id).toList());
                  //                         }
                  //                       });
                  //                     }
                  //                   );
                  //                 }
                  //               ),
                  //           );
                                        
                  //         }


                  //         return MyAlertDialog(
                  //           title: "Filtrar", 
                  //           content: Wrap(
                  //             children: [
                  //               monedasWidget(isSmallOrMedium),
                  //               bancasWidget(isSmallOrMedium),
                  //             ],
                  //           ), 
                  //           okFunction: _guardarFiltro
                  //         );
                  //       }
                  //     );
                  //   }
                  // );                  
                  // if(data == null)
                  //   return;

                  // setState(() {
                  //   _bancas = data[0];
                  //   _moneda = data[1];
                  //   _getData();
                  // });
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
            
            MySliverButton(
              showOnlyOnLarge: true,
              title: Container(
                width: 180,
                child: Builder(
                  builder: (context) {
                    return MyDropdown(title: null, 
                      hint: "${MyDate.dateRangeToNameOrString(_date)}",
                      onTap: (){
                        showMyOverlayEntry(
                          right: 10,
                            context: context,
                            builder: (context, overlay){
                              _cancel(){
                                overlay.remove();
                              }
                              return MyDateRangeDialog(date: _date, onCancel: _cancel, onOk: (date){
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
              onTap: (){}
              ),
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
            _myWebFilterScreen(isSmallOrMedium),
            MySubtitle(title: "${snapshot.data != null ? snapshot.data.length : 0} Filas", padding: EdgeInsets.only(bottom: 20, top: 25),),
            // Wrap(
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.only(left: 0, right: isSmallOrMedium ? 0.0 : 8.0),
            //       child: Builder(
            //         builder: (context) {
            //           return MyDropdown(
            //             xlarge: 5.8,
            //             large: 5.8,
            //             title: "Fecha", 
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
            //     // _bancasWidget(isSmallOrMedium),
            //     // _monedasWidget(isSmallOrMedium)
            //   ],
            // ),
          
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
                    "${Utils.toCurrency(snapshot.data.map((e) => e.ventas).toList().reduce((value, element) => value + element),)}", 
                    "${Utils.toCurrency(snapshot.data.map((e) => e.premios).toList().reduce((value, element) => value + element),)}", 
                    "${Utils.toCurrency(snapshot.data.map((e) => e.comisiones).toList().reduce((value, element) => value + element),)}", 
                    "${Utils.toCurrency(snapshot.data.map((e) => e.descuentoMonto).toList().reduce((value, element) => value + element),)}", 
                    "${Utils.toCurrency(snapshot.data.map((e) => e.neto).toList().reduce((value, element) => value + element),)}"
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