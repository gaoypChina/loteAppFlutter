import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:loterias/ui/views/reportes/filtrarreportejugadasscree.dart';
import 'package:loterias/ui/widgets/mycontainerbutton.dart';
import 'package:loterias/ui/widgets/mycontainerradio.dart';
import 'package:loterias/ui/widgets/mycustomdropdownbutton.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unicons/unicons.dart';

class ReporteJugadasScreen extends StatefulWidget {
  @override
  _ReporteJugadasScreenState createState() => _ReporteJugadasScreenState();
}

class _ReporteJugadasScreenState extends State<ReporteJugadasScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<Loteria> groupValue = ValueNotifier<Loteria>(null);
  bool _mostrarFiltro = false;

  StreamController<List<Draws>> _streamController;
  StreamController<List<Loteria>> _streamControllerLoteria;
  bool _cargando = false;
  DateTime _fechaActual = DateTime.now();
  DateTime _fechaInicial;
  DateTime _fechaFinal;
  List<Loteria> listaLoteria = [];
  List<Draws> listaSorteo = [];
  List<Moneda> listaMoneda = [];
  List<Jugada> listaJugada = [];
  Loteria _loteria;
  Draws _sorteo;
  Moneda _moneda;
  MyDate _fecha = MyDate.hoy;
  String _jugada;
  int _limite = 20;

  
 

  _init() async {
    // setState(() => _cargando = true);
    var parsed = await ReporteService.jugadas(context: context, scaffoldKey: _scaffoldKey, fechaInicial: _fechaInicial, fechaFinal: _fechaFinal, retornarLoterias: true, retornarSorteos: true, retornarMonedas: true);
    print("ReporteJugadasScreen _init: $parsed");
    listaLoteria = (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((e) => Loteria.fromMap(e)).toList() : [];
    listaSorteo = (parsed["sorteos"] != null) ? parsed["sorteos"].map<Draws>((e) => Draws.fromMap(e)).toList() : [];
    listaJugada = (parsed["data"] != null) ? parsed["data"].map<Jugada>((e) => Jugada.fromMap(e)).toList() : [];
    listaMoneda = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((e) => Moneda.fromMap(e)).toList() : [];
    if(listaLoteria.length > 1)
      listaLoteria.insert(0, Loteria(id: null, descripcion: "Todas las loterias", abreviatura: "Todas"));
    if(listaSorteo.length > 1)
      listaSorteo.insert(0, Draws(null, "Todos los sorteos", 0, 0, 0, DateTime.now()));
      
    setState(() {
      _loteria = (listaLoteria.length > 0) ? listaLoteria[0] : null;
      _moneda = (listaMoneda.length > 0) ? listaMoneda[0] : null;
    });
    _sorteo = (listaSorteo.length > 0) ? listaSorteo[0] : null;
    
    _streamController.add(listaSorteo);
    _streamControllerLoteria.add(listaLoteria);
    // setState(() => _cargando = false);
  }

  _filtrarFecha(){
    switch (_fecha) {
      case MyDate.hoy:
        var fechas = MyDate.getHoy();
        _fechaInicial = fechas[0];
        _fechaFinal = fechas[1];
        break;
      case MyDate.ayer:
        var fechas = MyDate.getAyer();
        _fechaInicial = fechas[0];
        _fechaFinal = fechas[1];
        break;
      case MyDate.estaSemana:
        var fechas = MyDate.getEstaSemana();
        _fechaInicial = fechas[0];
        _fechaFinal = fechas[1];
        break;
      case MyDate.laSemanaPasada:
        var fechas = MyDate.getSemanaPasada();
        _fechaInicial = fechas[0];
        _fechaFinal = fechas[1];
        break;
      default:
        
    }
    // if(_fecha == "Hoy"){
    //   _fechaInicial = DateTime.parse("${_fechaActual.year}-${Utils.toDosDigitos(_fechaActual.month.toString())}-${Utils.toDosDigitos(_fechaActual.day.toString())} 00:00");
    //   _fechaFinal = DateTime.parse("${_fechaActual.year}-${Utils.toDosDigitos(_fechaActual.month.toString())}-${Utils.toDosDigitos(_fechaActual.day.toString())} 23:59:59");
    // }
    // else if(_fecha == "Ayer"){
    //   var fechaAyer = _fechaActual.subtract(Duration(days: 1));
    //   _fechaInicial = DateTime.parse("${fechaAyer.year}-${Utils.toDosDigitos(fechaAyer.month.toString())}-${Utils.toDosDigitos(fechaAyer.day.toString())} 00:00");
    //   _fechaFinal = DateTime.parse("${fechaAyer.year}-${Utils.toDosDigitos(fechaAyer.month.toString())}-${Utils.toDosDigitos(fechaAyer.day.toString())} 23:59:59");
    // }
    // else if(_fecha == "Esta semana"){
    //   int diasARestar = _fechaActual.weekday - 1;
    //   var lunesDeEstaSemana = _fechaActual.subtract(Duration(days: diasARestar));
    //   _fechaInicial = DateTime.parse("${lunesDeEstaSemana.year}-${Utils.toDosDigitos(lunesDeEstaSemana.month.toString())}-${Utils.toDosDigitos(lunesDeEstaSemana.day.toString())} 00:00");
    //   _fechaFinal = DateTime.parse("${_fechaActual.year}-${Utils.toDosDigitos(_fechaActual.month.toString())}-${Utils.toDosDigitos(_fechaActual.day.toString())} 23:59:59");
    // }
    // else if(_fecha == "La semana pasada"){
    //   int diasARestar = _fechaActual.weekday;
    //   var domingoDeLaSemanaPasada = _fechaActual.subtract(Duration(days: diasARestar));
    //   diasARestar = domingoDeLaSemanaPasada.weekday - 1;
    //   var lunesDeLaSemanaPasada = domingoDeLaSemanaPasada.subtract(Duration(days: diasARestar));
    //   _fechaInicial = DateTime.parse("${lunesDeLaSemanaPasada.year}-${Utils.toDosDigitos(lunesDeLaSemanaPasada.month.toString())}-${Utils.toDosDigitos(lunesDeLaSemanaPasada.day.toString())} 00:00");
    //   _fechaFinal = DateTime.parse("${domingoDeLaSemanaPasada.year}-${Utils.toDosDigitos(domingoDeLaSemanaPasada.month.toString())}-${Utils.toDosDigitos(domingoDeLaSemanaPasada.day.toString())} 23:59:59");
    // }
  }

  _filtrar() async {
    try {
      _filtrarFecha();
      print("_filtrar fechaInicial: ${_fechaInicial.toString()}");
      print("_filtrar fechaFinal: ${_fechaFinal.toString()}");
      // return;
      _streamController.add(null);
      var parsed = await ReporteService.jugadas(context: context, scaffoldKey: _scaffoldKey, fechaInicial: _fechaInicial, fechaFinal: _fechaFinal, loteria: (_loteria.id != null) ? _loteria : null, sorteo: (_sorteo.id != null) ? _sorteo : null, jugada: _jugada, moneda: (_moneda.id != null) ? _moneda : null, limite: _limite);
      listaJugada = (parsed["data"] != null) ? parsed["data"].map<Jugada>((e) => Jugada.fromMap(e)).toList() : [];
      _streamController.add(listaSorteo);
    } on Exception catch (e) {

          // TODO
    }

  }

  _onChanged(data){
    groupValue.value = data;
    // setState(() => groupValue = data);
  }

  _loteriaChanged(loteria){
    setState((){
        _loteria = loteria;
        _filtrar();
      });
  }

  _monedaChanged(moneda){
    setState((){
        _moneda = moneda;
        _filtrar();
      });
  }

  _showBottomSheetLoteria() async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context){
        _back(){
              Navigator.pop(context);
            }
            loteriaChanged(loteria){
              setState(() => _loteria = loteria);
              _loteriaChanged(loteria);
              _back();
            }
        return Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                children: [
                  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaLoteria.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          value: _loteria == listaLoteria[index],
                          onChanged: (data){
                            loteriaChanged(listaLoteria[index]);
                          },
                          title: Text("${listaLoteria[index].descripcion}"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
        // Container(
        //   height: MediaQuery.of(context).size.height / 2,
        //   child: Column(

        //         children: [
        //           Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
        //             ),
        //           Expanded(
        //             child: SingleChildScrollView(child: Column(children: [
                      
        //               // Text("Seleccionar loteria", style: TextStyle(fontSize: 18),),
        //               // Icon(Icons.stop_circle)
        //               // Icon(UniconsLine.stop_circle)
        //               Column(
        //                               children: listaLoteria.map((e) => Padding(
        //                                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //                                 child: GestureDetector(
        //                                   onTap: (){
        //                                     _closeAndReturnData(e);
        //                                   },
        //                                   child: Row(
        //                                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                                     children: [
        //                                     Row(
        //                                       children: [
        //                                         Container(
        //                                           padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        //                                       decoration: BoxDecoration(
        //                                         border: Border.all(color: Utils.colorPrimary),
        //                                         borderRadius: BorderRadius.circular(18)
        //                                       ),
        //                                       child: Center(child: Text(e.descripcion.substring(0, 1), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Utils.colorPrimary),)),
        //                                     ),
        //                                     Padding(
        //                                       padding: const EdgeInsets.symmetric(horizontal: 14.0),
        //                                       // child: Text("${e.descripcion}", style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.2)),
        //                                       child: Text("${e.descripcion}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.2)),
        //                                     ),
        //                                       ],
        //                                     ),
        //                                     Expanded(
        //                                       child: GestureDetector(
        //                                         onTap: (){
        //                                           _closeAndReturnData(e);
        //                                         },
        //                                         child: Container(
        //                                           color: Colors.transparent,
        //                                           child: Align(
        //                                             alignment: Alignment.centerRight,
        //                                             child: MyContainerRadio(selected: e == _loteria, onTap: (data){
        //                                                 _closeAndReturnData(e);
        //                                             }),
        //                                           ),
        //                                         ),
        //                                       ),
        //                                     )
        //                                   ],),
        //                                 ),
        //                               )).toList(),
        //                             )
        //               // ValueListenableBuilder(
        //               //             valueListenable: groupValue,
        //               //             builder: (_, value, __) {
        //               //               return Column(
        //               //                 children: listaLoteria.map((e) => Padding(
        //               //                   padding: const EdgeInsets.all(8.0),
        //               //                   child: Row(
        //               //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               //                     children: [
        //               //                     Text("${e.descripcion}", style: TextStyle(fontFamily: "GoogleSans")),
        //               //                     Icon(Icons.stop_circle, color: Utils.colorPrimary, size: 28,)
        //               //                   ],),
        //               //                 )).toList(),
        //               //               );
        //               //             }
        //               //           ),
                      
        //             ],),),
        //           ),
        //         ],
        //       )
        // );
      
      }
  );
    // if(data != null)
    //   setState((){
    //     _loteria = data;
    //     _filtrar();
    //   });
  }


_showBottomSheetMoneda() async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context){
        _back(){
              Navigator.pop(context);
            }
            monedaChanged(moneda){
              setState(() => _moneda = moneda);
              _monedaChanged(moneda);
              _back();
            }
        return Container(
              height: 150,
              child: Column(
                children: [
                  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaMoneda.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          value: _moneda == listaMoneda[index],
                          onChanged: (data){
                            monedaChanged(listaMoneda[index]);
                          },
                          title: Text("${listaMoneda[index].descripcion}",),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
        
      
      }
  );
    // if(data != null)
    //   setState((){
    //     _loteria = data;
    //     _filtrar();
    //   });
  }


  _drawsBackground(String sorteo){
    Color color = Utils.colorPrimary;
    // switch (sorteo) {
    //   case "Directo":
    //     color = Colors.green;
    //     break;
    //   case "Pale":
    //     color = Colors.pink;
    //     break;
    //   case "Tripleta":
    //     color = Colors.blue;
    //     break;
    //   default:
    //     color = Colors.blueGrey;
    // }

    return color;
  }

  _getListaFiltro(){
    var mostrarFiltro = false;
    List<MyFilterData> lista = [];
    if(_sorteo != null || _fecha == null || _jugada != null){
      if(_sorteo.descripcion != "Todos los sorteos")
        lista.add(MyFilterData(
          text: _sorteo.descripcion, 
          value: _sorteo, 
          color: Colors.green, 
          onChanged: (data){
            setState((){
              _sorteo = listaSorteo[0];
              _filtrar();
            });
          })
        );

        if(_jugada != null)
          lista.add(MyFilterData(
            text: _jugada, 
            value: _jugada, 
            color: Colors.pink, 
            onChanged: (data){
              setState(() {
                _jugada = null;
                _filtrar();
              });
            })
          );

        if(_fecha == null)
          lista.add(MyFilterData(
            text: MyDate.datesToString(_fechaInicial, _fechaFinal), 
            value: MyDate.datesToString(_fechaInicial, _fechaFinal), 
            color: null,
            onChanged: (data){
              setState(() {
                _fecha = MyDate.hoy;
                _filtrar();
              });
            })
          );

        if(_limite != 20)
          lista.add(MyFilterData(
            text: "$_limite registros por sorteo", 
            value: _limite, 
            color: Colors.grey,

            onChanged: (data){
              setState(() {
                _limite = 20;
                _filtrar();
              });
            })
          );
    }else
      lista = [];
    
    return lista;
  }

  _filtroScreen() async {
    var data = await Navigator.push(context, MaterialPageRoute(builder: (context) => FiltrarReporteJugadasScreen(loteriaSeleccionada: _loteria, loterias: listaLoteria, sorteoSeleccionado: _sorteo, sorteos: listaSorteo, monedaSeleccionada: _moneda, monedas: listaMoneda, fechaSelecionada: _fecha, fechaInicial: _fechaInicial, fechaFinal: _fechaFinal, jugada: _jugada, limiteSeleccionado: _limite,)));
    if(data == null)
      return;

    setState(() {
      _sorteo = data["sorteo"];
      _loteria = data["loteria"];
      _jugada = data["jugada"];
      _fechaInicial = data["fechaInicial"];
      _fechaFinal = data["fechaFinal"];
      _fecha = data["fecha"];
      _limite = data["limite"];
      _moneda = data["moneda"];

      _filtrar();
    });
    print("_filtroScreen: ${data}");
  }

  _deleteAllFilter(){
    setState(() {
      if(_fecha == null)
        _fecha = MyDate.hoy;

      if(_sorteo.descripcion != "Todos los sorteos")
        _sorteo = listaSorteo[0];

      if(_jugada != null)
        _jugada = null;

      if(_limite != 20)
        _limite = 20;

      _filtrar();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _streamController = BehaviorSubject();
    _streamControllerLoteria = BehaviorSubject();
    _fechaInicial = DateTime.parse("${_fechaActual.year}-${Utils.toDosDigitos(_fechaActual.month.toString())}-${Utils.toDosDigitos(_fechaActual.day.toString())} 00:00");
    _fechaFinal = DateTime.parse("${_fechaActual.year}-${Utils.toDosDigitos(_fechaActual.month.toString())}-${Utils.toDosDigitos(_fechaActual.day.toString())} 23:59:59");
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      // appBar: AppBar(
      //     leading: BackButton(
      //       color: Utils.colorPrimary,
      //     ),
      //     title: Text("Jugadas", style: TextStyle(color: Colors.black)),
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //     actions: <Widget>[
      //        Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: <Widget>[
      //             Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: SizedBox(
      //                 width: 30,
      //                 height: 30,
      //                 child: Visibility(
      //                   visible: _cargando,
      //                   child: Theme(
      //                     data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
      //                     child: new CircularProgressIndicator(),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //         IconButton(icon: Icon(Icons.filter_alt_rounded), onPressed: _guardar, color: Utils.colorPrimary,),
      //         // ElevatedButton(child: Text("Guardar"), 
      //         // onPressed: _guardar,
      //         // style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Utils.colorPrimary)),)
      //     ],
      //   ),
      body: SafeArea(child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: StreamBuilder(
              stream: _streamControllerLoteria.stream,
              builder: (context, snapshot){
                return GestureDetector(
                  onTap: _showBottomSheetLoteria,
                  child: Row(
                    children: [
                      Text("${_loteria != null ? _loteria.descripcion : 'No hay loterias'}", style: TextStyle(color: Colors.black),),
                      Icon(Icons.arrow_drop_down, color: Colors.black54,)
                    ],
                  ),
                );
               
                return DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      items: (snapshot.hasData) ? listaLoteria.map((e) => DropdownMenuItem(child: Text(e.descripcion), value: e,)).toList() : []
                    ),
                  ),
                  
                  );
                return MyDropdownButton(
                  isExpanded: false,
                  withScreenSize: false,
                  items: (snapshot.hasData) ? listaLoteria.map((e) => [e, e.descripcion]).toList() : [],
                  onChanged: (data){

                  },
                );
              },
            ),
            leading: BackButton(
              color: Utils.colorPrimary,
            ),
            backgroundColor: Colors.white,
            actions: [
              TextButton(onPressed: _showBottomSheetMoneda, child: Text("${_moneda != null ? _moneda.abreviatura : ''}", style: TextStyle(color: (_moneda != null) ? Utils.fromHex(_moneda.color) : Utils.colorPrimary))),
              IconButton(icon: Icon(Icons.filter_alt_rounded), onPressed: _filtroScreen, color: Utils.colorPrimary,),
            ],
            expandedHeight: (_getListaFiltro().length == 0) ? 150 : 238,
            floating: true,
            pinned: true,
            flexibleSpace: 
            
            FlexibleSpaceBar(
              // alignment: Alignment.bottomRight,
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Fecha", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
                  ),
                  Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // child: Icon(Icons.date_range, size: 35, color: Colors.grey,),
                          child: Icon(Icons.date_range, color: Colors.grey,),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: 
                              Row(
                                children: MyDate.listaFecha.map((e) =>  Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: MyContainerButton(selected: e[0] == _fecha, data: [e[0], e[1]], onTap: (data){
                                    setState((){
                                      _fecha = e[0];
                                      _filtrar();
                                    });
                                  },),
                                )).toList(),
                              )
                              // Row(
                              //   children: [
                              //     Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: MyContainerButton(selected: _fecha, data: ["Hoy", "Hoy"], onTap: (data){
                              //       print("$data");
                              //     },),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: MyContainerButton(data: ["Ayer", "Ayer"], onTap: (data){
                              //       print("$data");

                              //     },),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: MyContainerButton(data: ["Esta semana", "Esta semana"], onTap: (data){
                              //       print("$data");

                              //     },),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(4.0),
                              //     child: MyContainerButton(data: ["La semana pasada", "La semana pasada"], onTap: (data){
                              //       print("$data");

                              //     },),
                              //   ),
                              //   ],
                              // ),
                              
                              // children: [
                              //   Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: MyContainerButton(data: ["Hoy", "Hoy"], onTap: (data){
                              //       print("$data");
                              //     },),
                              //   ),
                              //   Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: MyContainerButton(data: ["Ayer", "Ayer"], onTap: (data){
                              //       print("$data");

                              //     },),
                              //   ),
                              // ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  _getListaFiltro().length == 0
                  ?
                  SizedBox()
                  :
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: MyFilter(title: "Filtros", data: _getListaFiltro(), onDeleteAll: _deleteAllFilter,),
                  ),
                  
                ],
              ),
            
            ),
            
            
            
          ),
          StreamBuilder<List<Draws>>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if(snapshot.data == null)
                      return SliverFillRemaining(child: Center(child: CircularProgressIndicator(),));

              if(listaJugada.length == 0)
                return SliverFillRemaining(child: MyEmpty(title: "No hay jugadas realizadas", icon: Icons.format_list_numbered_rounded, titleButton: "No hay jugadas",));

              return SliverList(delegate: SliverChildBuilderDelegate((context, index){
                var lista = listaJugada.where((element) => element.idSorteo == snapshot.data[index].id).toList();
                return 
                lista.length == 0
                ?
                SizedBox()
                :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Divider(thickness: 1,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(snapshot.data[index].descripcion, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                    ),
                    Column(
                      children: lista.map((e) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _drawsBackground(snapshot.data[index].descripcion) ,
                        child: Text(_loteria.descripcion.substring(0, 1), style: TextStyle(color: Colors.white),),
                      ),
                      trailing: 
                      (e.premio <= 0)
                      ?
                      Text(Utils.toCurrency(e.monto), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),)
                      :
                      Column(
                        children: [
                          Text(Utils.toCurrency(e.monto), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),),
                          Text(Utils.toCurrency(e.premio), style: TextStyle(color: Colors.pink, fontSize: 16),),
                        ],
                      ),
                      title: Text("${Utils.agregarSignoYletrasParaImprimir(e.jugada, snapshot.data[index].descripcion)}", style: TextStyle(fontWeight: FontWeight.w700),),
                      subtitle: RichText(text: TextSpan(
                        style: TextStyle(color: Colors.grey),
                        children: [
                          // TextSpan(text: "${_loteria != null ? _loteria.abreviatura.substring(0, _loteria.abreviatura.length < 3 ? _loteria.abreviatura.length : 3) : ''}"),
                          TextSpan(text: "${e.cantidadVecesQueSeHaJugado != null ? 'Jugado ' + e.cantidadVecesQueSeHaJugado.toString() : ''} ${e.cantidadVecesQueSeHaJugado != null ? e.cantidadVecesQueSeHaJugado == 1 ? 'vez' : 'veces' : ''}"),
                          TextSpan(text: "${e.cantidadVecesQueHaSalido != null ? '  |  Salido ' + e.cantidadVecesQueHaSalido.toString() : ''} ${e.cantidadVecesQueHaSalido != null ? e.cantidadVecesQueHaSalido == 1 ? 'vez' : 'veces' : ''}"),
                        ]
                      )),
                    )).toList(),
                    )
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: DataTable(
                    //         columns: [DataColumn(label: Text("Jugada")), DataColumn(label: Text("Monto")), DataColumn(label: Text("Premio"))],
                    //         rows: lista.map((e) => DataRow(cells: [DataCell(Text(e.jugada)), DataCell(Text("RD\$${e.monto}")), DataCell(Text("RD\$${e.premio}"))])).toList(),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    
                    // Expanded(
                    //   flex: 1,
                    //   child: Container(
                    //     height: 100,
                    //     child: SingleChildScrollView(
                    //       child: Column(
                    //         children: lista.map((e) =>  ListTile(
                    //           title: Text(lista[index].jugada),
                    //         )).toList(),
                    //       ),
                    //     )
                    //     // ListView.builder(
                    //     //   shrinkWrap: true,
                    //     //   itemCount: lista.length,
                    //     //   itemBuilder: (context, index){
                    //     //     return ListTile(
                    //     //       title: Text(lista[index].jugada),
                    //     //     );
                    //     //   },
                    //     // ),
                    //   ),
                    // )
                  ],
                );
              }, childCount: snapshot.data.length));
              return SliverFillRemaining(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(children: [
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                //   child: Text("Fecha", style: TextStyle(fontWeight: FontWeight.w700),),
                // ),
                // Row(
                //   children: [
                //     Icon(Icons.date_range, size: 35, color: Colors.grey,),
                //     Expanded(
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 14.0),
                //         child: SingleChildScrollView(
                //           scrollDirection: Axis.horizontal,
                //           child: Row(
                //             children: [
                //               Padding(
                //               padding: const EdgeInsets.all(4.0),
                //               child: MyContainerButton(data: ["Hoy", "Hoy"], onTap: (data){
                //                 print("$data");
                //               },),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.all(4.0),
                //               child: MyContainerButton(data: ["Ayer", "Ayer"], onTap: (data){
                //                 print("$data");

                //               },),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.all(4.0),
                //               child: MyContainerButton(data: ["Esta semana", "Esta semana"], onTap: (data){
                //                 print("$data");

                //               },),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.all(4.0),
                //               child: MyContainerButton(data: ["La semana pasada", "La semana pasada"], onTap: (data){
                //                 print("$data");

                //               },),
                //             ),
                //             ],
                //           ),
                //           // children: [
                //           //   Padding(
                //           //     padding: const EdgeInsets.all(8.0),
                //           //     child: MyContainerButton(data: ["Hoy", "Hoy"], onTap: (data){
                //           //       print("$data");
                //           //     },),
                //           //   ),
                //           //   Padding(
                //           //     padding: const EdgeInsets.all(8.0),
                //           //     child: MyContainerButton(data: ["Ayer", "Ayer"], onTap: (data){
                //           //       print("$data");

                //           //     },),
                //           //   ),
                //           // ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 12.0),
                //   child: Divider(thickness: 1,),
                // ),
                StreamBuilder<List<Draws>>(
                  stream: _streamController.stream,
                  builder: (context, snapshot){
                    if(snapshot.data == null)
                      return Center(child: CircularProgressIndicator(),);

                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                        return Column(
                          children: [
                            Text(snapshot.data[index].descripcion, style: TextStyle(fontSize: 20),),
                            // ListView.builder(itemBuilder: itemBuilder)
                          ],
                        );
                      },
                    );
                  },
                )
              ],),
        ),
      
              );
            }
          )
        ],
      )),
    );
  }
}