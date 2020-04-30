import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:rxdart/rxdart.dart';

class HistoricoVentasScreen extends StatefulWidget {
  @override
  _HistoricoVentasScreenState createState() => _HistoricoVentasScreenState();
}

class _HistoricoVentasScreenState extends State<HistoricoVentasScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<List> _streamControllerHistorio;
  List listaDinamicaBancas = List();
  Map<String, dynamic> mapBancas;
  var _fechaDesde = DateTime.now();
  var _fechaHasta = DateTime.now();
  String _selectedOption = "Con ventas";
  bool _cargando = false;

  @override
  initState(){
    _streamControllerHistorio = BehaviorSubject();
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);
    _historicoVentas();
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _streamControllerHistorio.close();
    super.dispose();
    
    // _streamControllerHistorio.close();

  }

  _historicoVentas() async {
    try{
      setState(() => _cargando = true);
      listaDinamicaBancas = await ReporteService.historico(scaffoldKey: _scaffoldKey, fechaDesde: _fechaDesde, fechaHasta: _fechaHasta);
      _streamControllerHistorio.add(listaDinamicaBancas);
      _filterTable();
      setState(() => _cargando = false);
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  _filterTable(){
    switch(_selectedOption){
      case "Con ventas":
        _streamControllerHistorio.add(listaDinamicaBancas.where((b) => Utils.toDouble(b["ventas"].toString()) > 0).toList());
        break;
      case "Con premios":
        _streamControllerHistorio.add(listaDinamicaBancas.where((b) => Utils.toDouble(b["premios"].toString()) > 0).toList());
        break;
      case "Con tickets pendientes":
        _streamControllerHistorio.add(listaDinamicaBancas.where((b) => Utils.toDouble(b["pendientes"].toString()) > 0).toList());
        break;
      default:
        _streamControllerHistorio.add(listaDinamicaBancas);
        break;
    }
  }

  Widget _buildTable(List map){
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
                    child: InkWell(onTap: (){}, child: Text(b["descripcion"], style: TextStyle(fontSize: 16, decoration: TextDecoration.underline)))
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
                  child: Center(child: Text("${b["descuentos"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["premios"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: (Utils.toDouble(b["totalNeto"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
                  child: Center(child: Text("${b["totalNeto"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: (Utils.toDouble(b["balance"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
                  child: Center(child: Text("${b["balance"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: (Utils.toDouble(b["balanceActual"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
                  child: Center(child: Text("${b["balanceActual"]}", style: TextStyle(fontSize: 16)))
                ),
                // Center(child: IconButton(icon: Icon(Icons.delete, size: 28,), onPressed: () async {},)),
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
                    child: Center(child: Text('Bancas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Ventas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Comis.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Desc.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Premios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Neto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Balance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Balance mas ventas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
                  // ),
                ]
              )
              );

      var totales = _calcularTotal(map);
      rows.add( 
              TableRow(
                // decoration: BoxDecoration(color: Utils.colorPrimary),
                children: [
                  // buildContainer(Colors.blue, 50.0),
                  // buildContainer(Colors.red, 50.0),
                  // buildContainer(Colors.blue, 50.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Totales', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('${totales["ventas"]}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('${totales["comisiones"]}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('${totales["descuentos"]}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('${totales["premios"]}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('${totales["totalNeto"]}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('${totales["balance"]}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('${totales["balanceActual"]}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                 
                ]
              )
              );
        
   }

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

 Map<String, dynamic> _calcularTotal(List lista){
  double ventas = 0;
  double comisiones = 0;
  double descuentos = 0;
  double premios = 0;
  double totalNeto = 0;
  double balance = 0;
  double balanceActual = 0;

  lista.forEach((b){
    ventas += Utils.toDouble(b["ventas"].toString());
    comisiones += Utils.toDouble(b["comisiones"].toString());
    descuentos += Utils.toDouble(b["descuentos"].toString());
    premios += Utils.toDouble(b["premios"].toString());
    totalNeto += Utils.toDouble(b["totalNeto"].toString());
    balance += Utils.toDouble(b["balance"].toString());
    balanceActual += Utils.toDouble(b["balanceActual"].toString());
  });

  Map<String, dynamic> map = {"ventas" : ventas, "comisiones" : comisiones, "descuentos" : descuentos, 
  "premios" : premios, "totalNeto" : totalNeto, "balance" : balance, "balanceActual" :  balanceActual};

  return map;
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Historico ventas", style: TextStyle(color: Colors.black),),
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
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 40),
            child: DropdownButton<String>(
              value: _selectedOption,
              items: [
                DropdownMenuItem(value: "Todos", child: Text("Todos"),),
                DropdownMenuItem(value: "Con ventas", child: Text("Con ventas"),),
                DropdownMenuItem(value: "Con premios", child: Text("Con premios"),),
                DropdownMenuItem(value: "Con tickets pendientes", child: Text("Con tickets pendientes"),),
              ],
              onChanged: (String data){
                setState(()
                  { 
                    _selectedOption = data;
                    _filterTable();
                  }
                );
                
              },
            ),
          )
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Hasta", style: TextStyle(fontSize: 20),),
                ),
                RaisedButton(
                  elevation: 0,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
                  child: Text("${_fechaHasta.year}-${_fechaHasta.month}-${_fechaHasta.day}", style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    DateTime fecha = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                    setState(() => _fechaHasta = (fecha != null) ? fecha : _fechaHasta);
                  },
                ),
                RaisedButton(
                  elevation: 0,
                  color: Utils.fromHex("#e4e6e8"),
                  child: Text("Buscar", style: TextStyle(color: Utils.colorPrimary),),
                  onPressed: (){_historicoVentas();},
                ),
                
              ],
            ),
            StreamBuilder<List>(
              stream: _streamControllerHistorio.stream,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  // mapBancas = snapshot.data;
                  return _buildTable(snapshot.data);
                }
                return _buildTable(List());
              },
            )
          ],
        ),
      ),
    );
  }
}