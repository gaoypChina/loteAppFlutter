import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/monitoreo.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/services/bluetoothchannel.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:loterias/core/services/ticketservice.dart';
import 'package:rxdart/rxdart.dart';

class VentasScreen extends StatefulWidget {
  @override
  _VentasScreenState createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<List<Banca>> _streamControllerBancas;
  StreamController<Map<String, dynamic>> _streamControllerTablas;
  List<Banca> listaBanca = List();
  int _indexBanca = 0;
  DateTime _fechaDesde = DateTime.now();
  bool _cargando = false;
  bool _onCreate = true;
  bool _tienePermiso = false;
  Map<String, dynamic> datos;

  @override
  void initState() {
    // TODO: implement initState
    _confirmarTienePermiso();
    _streamControllerBancas = BehaviorSubject();
    _streamControllerTablas = BehaviorSubject();
    _ventas();
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
    _streamControllerTablas.close();
    super.dispose();

  }

  _ventas() async {
    try{
      setState(() => _cargando = true);
      datos = await ReporteService.ventas(fecha: _fechaDesde, idBanca: await getIdBanca(), scaffoldKey: _scaffoldKey);
      if(_onCreate){
        listaBanca = datos["bancas"].map<Banca>((json) => Banca.fromMap(json)).toList();
        _streamControllerBancas.add(listaBanca);
        _seleccionarBancaPertenecienteAUsuario();
        _onCreate = false;
      }
      _streamControllerTablas.add(datos);
      setState(() => _cargando = false);
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  getIdBanca() async {
    if(_tienePermiso && listaBanca.length > 0)
      return listaBanca[_indexBanca].id;
    else
      return await Db.idBanca();
  }

  _confirmarTienePermiso() async {
   _tienePermiso = await Db.existePermiso("Jugar como cualquier banca");
  }

  _seleccionarBancaPertenecienteAUsuario() async {
  var bancaMap = await Db.getBanca();
  Banca banca = (bancaMap != null) ? Banca.fromMap(bancaMap) : null;
  if(banca != null && listaBanca != null){
    int idx = listaBanca.indexWhere((b) => b.id == banca.id);
    setState(() => _indexBanca = (idx != -1) ? idx : 0);
  }else{
    setState(() =>_indexBanca = 0);
  }

  // print('seleccionarBancaPerteneciente: $_indexBanca : ${banca.descripcion} : ${listaBanca.length}');
}

_showTicket(String codigoBarra, BuildContext context) async {
    try{
      setState(()=> _cargando = true);
      var datos = await TicketService.buscarTicketAPagar(context: context, codigoBarra: codigoBarra);
      setState(()=> _cargando = false);
      Monitoreo.showDialogVerTicket(context: context, mapVenta: datos["venta"]);
    }on Exception catch(e){
      setState(()=> _cargando = false);
    }
  }

  Widget _buildTableTotalesPorLoteria(List map){
   var tam = (map != null) ? map.length : 0;
   List<TableRow> rows;
   if(tam == 0){
     rows = <TableRow>[];
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
                    child: InkWell(onTap: (){}, child: Text(b["descripcion"], style: TextStyle(fontSize: 16)))
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["ventas"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["comisiones"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["premios"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["neto"]}", style: TextStyle(fontSize: 16)))
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
                    child: Center(child: Text('Loteria', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Venta total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Comisiones', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Premios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Neto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
                  // ),
                ]
              )
              );
        
   }

   return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: <int, TableColumnWidth>{7 : FractionColumnWidth(.28)},
              children: rows,
             ),
        );

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

Widget _buildTableNumerosGanadores(List map){
   var tam = (map != null) ? map.length : 0;
   List<TableRow> rows;
   if(tam == 0){
     rows = <TableRow>[];
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
                    child: InkWell(onTap: (){}, child: Text(b["descripcion"], style: TextStyle(fontSize: 16,)))
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${(b["primera"] != null) ? b["primera"] : ''}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${(b["segunda"] != null) ? b["segunda"] : ''}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${(b["tercera"] != null) ? b["tercera"] : ''}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${(b["pick3"] != null) ? b["pick3"] : ''}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${(b["pick4"] != null) ? b["pick4"] : ''}", style: TextStyle(fontSize: 16)))
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
                    child: Center(child: Text('Loteria', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Primera', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Segunda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Tercera', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Pick3', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Pick4', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
                  // ),
                ]
              )
              );
        
   }

   return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: <int, TableColumnWidth>{7 : FractionColumnWidth(.28)},
              children: rows,
             ),
        );

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
                    child: Center(child: Text('A pagar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('fecha', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
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
                InkWell(
                  onTap: (){
                    _showTicket(b["codigoBarra"], context);
                  }, 
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    color: Utils.colorGreyFromPairIndex(idx: idx),
                    child: Center(
                      child: Text("${Utils.toSecuencia(b["primera"], BigInt.from(b["idTicket"]), false)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)))
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["montoAPagar"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
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

   return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: <int, TableColumnWidth>{7 : FractionColumnWidth(.28)},
              children: rows,
             ),
        );

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


  Table _tablaPrincipal(Map<String, dynamic> map){
    return Table(
      children: [
        TableRow(
          decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 1)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Center(child: Text("Balance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["balanceHastaLaFecha"]}", style: TextStyle(fontSize: 20)),),),
              ],
            )
          ]
        ),
        TableRow(
          decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 2)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Center(child: Text("Banca", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["banca"]["descripcion"]}", style: TextStyle(fontSize: 20)),),),
              ],
            )
          ]
        ),
        TableRow(
          decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 3)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Center(child: Text("Codigo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["banca"]["codigo"]}", style: TextStyle(fontSize: 20)),),),
              ],
            )
          ]
        ),
        TableRow(
          decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 4)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Center(child: Text("Pendientes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["pendientes"]}", style: TextStyle(fontSize: 20)),),),
              ],
            )
          ]
        ),
        TableRow(
          decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 5)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Center(child: Text("Perdedores", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["perdedores"]}", style: TextStyle(fontSize: 20)),),),
              ],
            )
          ]
        ),
        TableRow(
          decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 6)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Center(child: Text("Ganadores", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["ganadores"]}", style: TextStyle(fontSize: 20)),),),
              ],
            )
          ]
        ),
        TableRow(
          decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 7)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Center(child: Text("Total", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["total"]}", style: TextStyle(fontSize: 20)),),),
              ],
            )
          ]
        ),
        TableRow(
          decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 8)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Center(child: Text("Ventas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["ventas"]}", style: TextStyle(fontSize: 20)),),),
              ],
            )
          ]
        ),
        TableRow(
          decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 9)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Center(child: Text("Comisiones", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["comisiones"]}", style: TextStyle(fontSize: 20)),),),
              ],
            )
          ]
        ),
        TableRow(
          decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 10)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Center(child: Text("Descuentos", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["descuentos"]}", style: TextStyle(fontSize: 20)),),),
              ],
            )
          ]
        ),
        TableRow(
          decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 11)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Center(child: Text("Premios", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["premios"]}", style: TextStyle(fontSize: 20)),),),
              ],
            )
          ]
        ),
        TableRow(
          decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 12)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Center(child: Text("Neto", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["neto"]}", style: TextStyle(fontSize: 20)),),),
              ],
            )
          ]
        ),
        TableRow(
          decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 13)),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Center(child: Text("Balance mas ventas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["balanceActual"]}", style: TextStyle(fontSize: 20)),),),
              ],
            )
          ]
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ventas", style: TextStyle(color: Colors.black),),
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
            Wrap(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 20,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Desde", style: TextStyle(fontSize: 20),),
                ),
                RaisedButton(
                  elevation: 0, 
                  color: Colors.transparent, 
                  shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
                  child: Text("${_fechaDesde.year}-${_fechaDesde.month}-${_fechaDesde.day}", style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    DateTime fecha = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                    setState(() => _fechaDesde = (fecha != null) ? fecha : _fechaDesde);
                  },
                ),
                Visibility(
                  visible: _tienePermiso,
                  child: StreamBuilder<List<Banca>>(
                    stream: _streamControllerBancas.stream,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return DropdownButton<Banca>(
                          value: listaBanca[_indexBanca],
                          items: listaBanca.map((b) => DropdownMenuItem(
                            value: b,
                            child: Text("${b.descripcion}"),
                          )).toList(),
                          onChanged: (Banca banca){
                            int idx = listaBanca.indexWhere((b) => b.descripcion == banca.descripcion);
                            if(idx != -1)
                              setState(() => _indexBanca = idx);
                          },
                        );
                      }

                      return DropdownButton(value: "No hay datos", items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], onChanged: null);
                    },
                  ),
                ),
                RaisedButton(
                  elevation: 0,
                  color: Utils.fromHex("#e4e6e8"),
                  child: Text("Buscar", style: TextStyle(color: Utils.colorPrimary),),
                  onPressed: (){
                    _ventas();
                  },
                ),
                RaisedButton(
                  elevation: 0,
                  color: Utils.colorInfo,
                  child: Text("Imprimir",),
                  onPressed: (){
                    BluetoothChannel.printCuadre(datos);
                  },
                ),
              ],
            ),
            
            StreamBuilder<Map<String, dynamic>>(
              stream: _streamControllerTablas.stream,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Expanded(
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("Resumen de ventas", style: TextStyle(fontSize: 25),),),
                        ),
                        _tablaPrincipal(snapshot.data),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 15),
                          child: Center(child: Text("Totales por loteria", style: TextStyle(fontSize: 25),),),
                        ),
                        _buildTableTotalesPorLoteria((snapshot.data["loterias"] != null) ? List.from(snapshot.data["loterias"]) : List()),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 15),
                          child: Center(child: Text("Numeros ganadores", style: TextStyle(fontSize: 25),),),
                        ),
                        _buildTableNumerosGanadores((snapshot.data["loterias"] != null) ? List.from(snapshot.data["loterias"]) : List()),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 15),
                          child: Center(child: Text("Tickets ganadores", style: TextStyle(fontSize: 25),),),
                        ),
                        _buildTableTicketsGanadores((snapshot.data["ticketsGanadores"] != null) ? List.from(snapshot.data["ticketsGanadores"]) : List()),
                        
                      ],
                    ),
                  );
                }

                return Text("No hay datos");
              },
            ),
          ],
        ),
      ),
    );
  }
}