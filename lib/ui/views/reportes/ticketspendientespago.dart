import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loterias/core/classes/monitoreo.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:loterias/core/services/ticketservice.dart';
import 'package:rxdart/rxdart.dart';

class TicketsPendientesPagoScreen extends StatefulWidget {
  @override
  _TicketsPendientesPagoScreenState createState() => _TicketsPendientesPagoScreenState();
}

class _TicketsPendientesPagoScreenState extends State<TicketsPendientesPagoScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _cargando = false;
  bool _onCreate = true;
  bool _ckbTodasLasFechas = false;
  List<Banca> listaBanca = List();
  int _idBanca = 0;
  int _indexBanca = 0;
  List lista = List();
  StreamController<List<Banca>> _streamControllerBancas;
  StreamController<List> _streamControllerTabla;
  String _fechaString;
  DateTime _fechaActual = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    _streamControllerBancas = BehaviorSubject();
    _streamControllerTabla = BehaviorSubject();
    _fechaString = "${_fechaActual.year}-${_fechaActual.month}-${_fechaActual.day}";
    _tickets();
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _streamControllerBancas.close();
    // _streamControllerTabla.close();
    super.dispose();

  }
  
  _tickets() async {
    try{
      setState(() => _cargando = true);
      var datos = await ReporteService.ticketsPendientesPago(fechaString: _fechaString, idBanca: _idBanca, scaffoldKey: _scaffoldKey);
      if(_onCreate && datos != null){
        List list = List.from(datos["bancas"]);
        listaBanca = list.map((b) => Banca.fromMap(b)).toList();
        listaBanca.insert(0, Banca(id: 0, descripcion: "Todas las bancas"));
        _streamControllerBancas.add(listaBanca);
        _onCreate = false;
      }
      lista = datos["ticketsPendientesDePago"];
      _streamControllerTabla.add(lista);
      setState(() => _cargando = false);
    }on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  _showTicket(String codigoBarra, BuildContext context) async {
    try{
      setState(()=> _cargando = true);
      // var datos = await TicketService.ticket(scaffoldKey: _scaffoldKey, idTicket: idTicket);
      var datos = await TicketService.buscarTicketAPagar(context: context, codigoBarra: codigoBarra);
      setState(()=> _cargando = false);
      print("_showTicket datos: ${datos["venta"]}");
      Monitoreo.showDialogVerTicket(context: context, mapVenta: datos["venta"]);
    }on Exception catch(e){
      setState(()=> _cargando = false);
    }
  }

  Widget _buildTableTicketsGanadores(List map){
   var tam = (map != null) ? map.length : 0;
   List<TableRow> rows;
   if(tam == 0){
     rows = <TableRow>[];
     rows.insert(0, 
              TableRow(
                decoration: BoxDecoration(color: Utils.colorPrimary),
                children: [
                  // buildContainer(Colors.blue, 50.0),
                  // buildContainer(Colors.red, 50.0),
                  // buildContainer(Colors.blue, 50.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Numero de ticket', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Banca', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('A pagar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Fecha', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
                  // ),
                ]
              )
              );
   }else{
     rows = map.asMap().map((idx, b)
          => MapEntry(
            idx,
            TableRow(
              
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx),
                  child: Center(
                    child: InkWell(
                      onTap: (){
                        // _showTicket(b["codigoBarra"], context);
                        showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Text("Hola"),
                              content: Text("Hey klk"),
                            );
                          }
                        );
                      }, 
                      child: Text("${Utils.toSecuencia(b["primera"], BigInt.from(b["idTicket"]), false)}", style: TextStyle(fontSize: 16, decoration: TextDecoration.underline)))
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["banca"]["descripcion"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["montoAPagar"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["fecha"]}", style: TextStyle(fontSize: 16)))
                ),
              ],
            )
          )
        
        ).values.toList();
        
    rows.insert(0, 
              TableRow(
                decoration: BoxDecoration(color: Utils.colorPrimary),
                children: [
                  // buildContainer(Colors.blue, 50.0),
                  // buildContainer(Colors.red, 50.0),
                  // buildContainer(Colors.blue, 50.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Numero de ticket', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Banca', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('A pagar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Fecha', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
                  // ),
                ]
              )
              );
        
   }

  //  return Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Table(
  //             defaultVerticalAlignment: TableCellVerticalAlignment.middle,
  //             columnWidths: <int, TableColumnWidth>{7 : FractionColumnWidth(.28)},
  //             children: rows,
  //            ),
  //       );

  return Flexible(
      child: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: <int, TableColumnWidth>{7 : FractionColumnWidth(.28)},
              children: rows,
             ),
        ),
      ],
    ),
  );
  
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Balance bancas", style: TextStyle(color: Colors.black),),
        leading: BackButton(
          color: Utils.colorPrimary,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Visibility(
                    visible: _cargando,
                    child: Theme(
                      data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3 - 40,
                  child: Row(
                    children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RaisedButton(
                            elevation: 0, 
                            color: Colors.transparent, 
                            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
                            child: Text("${_fechaString}", style: TextStyle(fontSize: 16)),
                            onPressed: () async {
                              DateTime fecha = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                              setState(() => _fechaString = (fecha != null) ? "${fecha.year}-${fecha.month}-${fecha.day}" : _fechaString);
                            },
                          ),
                        ),
                        Checkbox(value: _ckbTodasLasFechas, onChanged: (bool check) {
                          if(check)
                            setState((){_fechaString = "Todas las fechas"; _ckbTodasLasFechas = check;});
                          else
                            setState((){_fechaString = "${_fechaActual.year}-${_fechaActual.month}-${_fechaActual.day}"; _ckbTodasLasFechas = check;});
                        })
                      ],
                    ),
                ),
                
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3 + 20,
                  child: StreamBuilder<List<Banca>>(
                    stream: _streamControllerBancas.stream,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return DropdownButton<Banca>(
                          isExpanded: true,
                          value: listaBanca[_indexBanca],
                          items: listaBanca.map((b) => DropdownMenuItem(
                            value: b,
                            child: Text("${b.descripcion}"),
                          )).toList(),
                          onChanged: (Banca banca){
                            setState(() {
                              _indexBanca = listaBanca.indexWhere((b) => b.descripcion == banca.descripcion);
                              _idBanca = listaBanca[_indexBanca].id;
                            });
                          },
                        );
                      }

                      return DropdownButton(value: "No hay datos", items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], onChanged: null);
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3 - 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: RaisedButton(
                      elevation: 0,
                      color: Utils.fromHex("#e4e6e8"),
                      child: Text("Buscar", style: TextStyle(color: Utils.colorPrimary),),
                      onPressed: (){
                        // _ventas();
                        _tickets();
                      },
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder<List>(
                  stream: _streamControllerTabla.stream,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return _buildTableTicketsGanadores(snapshot.data);
                    }
                    return Center(child: Text("No hay datos", style: TextStyle(fontSize: 25),));
                  },
                ),
          ],
        ),
      ),
    );
  }
}