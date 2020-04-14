import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/services/reporteservice.dart';
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
  bool _primeraCarga = true;

  @override
  void initState() {
    // TODO: implement initState
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
      var datos = await ReporteService.ventas(fecha: _fechaDesde, idBanca: await getIdBanca(), scaffoldKey: _scaffoldKey);
      if(_primeraCarga){
        listaBanca = datos["bancas"].map<Banca>((json) => Banca.fromMap(json)).toList();
        _streamControllerBancas.add(listaBanca);
        _primeraCarga = false;
      }
      _streamControllerTablas.add(datos);
      setState(() => _cargando = false);
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  getIdBanca() async {
    if(await Db.existePermiso("Jugar como cualquier banca") && listaBanca.length > 0)
      return listaBanca[_indexBanca].id;
    else
      return await Db.idBanca();
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
                Expanded(child: Center(child: Text("Balance", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["balanceHastaLaFecha"]}", style: TextStyle(fontSize: 22)),),),
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
                Expanded(child: Center(child: Text("Banca", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["banca"]["descripcion"]}", style: TextStyle(fontSize: 22)),),),
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
                Expanded(child: Center(child: Text("Codigo", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["banca"]["codigo"]}", style: TextStyle(fontSize: 22)),),),
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
                Expanded(child: Center(child: Text("Pendientes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["pendientes"]}", style: TextStyle(fontSize: 22)),),),
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
                Expanded(child: Center(child: Text("Perdedores", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["perdedores"]}", style: TextStyle(fontSize: 22)),),),
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
                Expanded(child: Center(child: Text("Ganadores", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["ganadores"]}", style: TextStyle(fontSize: 22)),),),
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
                Expanded(child: Center(child: Text("Total", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["total"]}", style: TextStyle(fontSize: 22)),),),
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
                Expanded(child: Center(child: Text("Ventas", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["ventas"]}", style: TextStyle(fontSize: 22)),),),
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
                Expanded(child: Center(child: Text("Comisiones", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["comisiones"]}", style: TextStyle(fontSize: 22)),),),
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
                Expanded(child: Center(child: Text("Descuentos", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["descuentos"]}", style: TextStyle(fontSize: 22)),),),
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
                Expanded(child: Center(child: Text("Premios", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["premios"]}", style: TextStyle(fontSize: 22)),),),
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
                Expanded(child: Center(child: Text("Neto", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["neto"]}", style: TextStyle(fontSize: 22)),),),
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
                Expanded(child: Center(child: Text("Balance mas ventas", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${map["balanceActual"]}", style: TextStyle(fontSize: 22)),),),
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
                StreamBuilder<List<Banca>>(
                  stream: _streamControllerBancas.stream,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return DropdownButton<Banca>(
                        value: listaBanca[_indexBanca],
                        items: listaBanca.map((b) => DropdownMenuItem(
                          value: b,
                          child: Text("${listaBanca[_indexBanca].descripcion}"),
                        )).toList(),
                        onChanged: (Banca banca){

                        },
                      );
                    }

                    return DropdownButton(value: "No hay datos", items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], onChanged: null);
                  },
                ),
                RaisedButton(
                  elevation: 0,
                  color: Utils.fromHex("#e4e6e8"),
                  child: Text("Buscar", style: TextStyle(color: Utils.colorPrimary),),
                  onPressed: (){},
                ),
                RaisedButton(
                  elevation: 0,
                  color: Utils.colorInfo,
                  child: Text("Imprimir",),
                  onPressed: (){},
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
                          child: Center(child: Text("Resumen de ventas", style: TextStyle(fontSize: 20),),),
                        ),
                        _tablaPrincipal(snapshot.data)
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