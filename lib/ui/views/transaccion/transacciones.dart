import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/services/transaccionservice.dart';
import 'package:rxdart/rxdart.dart';

class TransaccionesScreen extends StatefulWidget {
  @override
  _TransaccionesScreenState createState() => _TransaccionesScreenState();
}

class _TransaccionesScreenState extends State<TransaccionesScreen> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  bool _cargando = false;
  StreamController<List> _streamControllerTransacciones;
  List listaTransaccion = List();
  DateTime _fecha = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    _streamControllerTransacciones = BehaviorSubject();
    _transacciones();
    super.initState();
  }

  _transacciones() async {
    try{
      setState(() => _cargando = true);
      var datos = await TransaccionService.transacciones(scaffoldKey: _scaffoldkey);
      listaTransaccion = List.from(datos["transacciones"]);
      _streamControllerTransacciones.add(listaTransaccion);
      listaTransaccion.forEach((f) => print("debito: ${f["debito"]} - credito: ${f["credito"]}"));
      print("transaccionesscreen transacciones: ${datos['transacciones']}");
      setState(() => _cargando = false);
    }on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  _buscarTransacciones() async {
    try{
      setState(() => _cargando = true);
      var fechaHasta = new DateTime(_fecha.year, _fecha.month, _fecha.day, 23, 55);
      var datos = await TransaccionService.buscarTransacciones(scaffoldKey: _scaffoldkey, idUsuario: await Db.idUsuario(), fechaDesde: _fecha, fechaHasta: fechaHasta);
      listaTransaccion = List.from(datos["transacciones"]);
      _streamControllerTransacciones.add(listaTransaccion);
      listaTransaccion.forEach((f) => print("debito: ${f["debito"]} - credito: ${f["credito"]}"));
      print("transaccionesscreen transacciones: ${datos['transacciones']}");
      setState(() => _cargando = false);
    }on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

   Widget _buildTableTransaccion(List map){
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
                InkWell(
                  onTap: (){
                    // _showTicket(b["codigoBarra"], context);
                    
                    showModalBottomSheet(
                      context: context, 
                      builder: (context){
                        return 
                        Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: ListView(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topRight,
                                child: FlatButton(onPressed: (){Navigator.pop(context);}, child: Text("Listo", style: TextStyle(color: Utils.colorPrimary, fontSize: 16, fontWeight: FontWeight.bold))),
                              ),
                              Center(child: Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Text("${b["entidad1"]["descripcion"]}", style: TextStyle(fontSize: 24),),
                              )),
                              Table(
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 1)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("Fecha", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("${DateFormat.yMd().add_jm().format(DateTime.parse(b["created_at"]))}", style: TextStyle(fontSize: 16))),
                                      ),
                                    ]
                                  ),
                                  TableRow(
                                    decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 2)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("Tipo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("${b["tipo"]["descripcion"]}", style: TextStyle(fontSize: 16))),
                                      ),
                                    ]
                                  ),
                                  TableRow(
                                    decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 3)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("Entidad2", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("${(b["tipoEntidad2"] == "Banco") ? b["entidad2"]["nombre"] : b["entidad2"]["descripcion"]}", style: TextStyle(fontSize: 16))),
                                      ),
                                    ]
                                  ),
                                  TableRow(
                                    decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 4)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("Sald. ini. entidad1", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("${Utils.toCurrency(b["entidad1_saldo_inicial"])}", style: TextStyle(fontSize: 16))),
                                      ),
                                    ]
                                  ),
                                  TableRow(
                                    decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 5)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("Sald. ini. entidad2", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("${Utils.toCurrency(b["entidad2_saldo_inicial"])}", style: TextStyle(fontSize: 16))),
                                      ),
                                    ]
                                  ),
                                  TableRow(
                                    decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 6)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("Debito", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("${Utils.toCurrency(b["debito"])}", style: TextStyle(fontSize: 16))),
                                      ),
                                    ]
                                  ),
                                  TableRow(
                                    decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 7)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("Credito", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("${Utils.toCurrency(b["credito"])}", style: TextStyle(fontSize: 16))),
                                      ),
                                    ]
                                  ),
                                  TableRow(
                                    decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 8)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("Sald. fin. entidad1", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("${Utils.toCurrency(b["entidad1_saldo_final"])}", style: TextStyle(fontSize: 16))),
                                      ),
                                    ]
                                  ),
                                  TableRow(
                                    decoration: BoxDecoration(color: Utils.colorGreyFromPairIndex(idx: 9)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("Sald. fin. entidad2", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: Text("${Utils.toCurrency(b["entidad2_saldo_final"])}", style: TextStyle(fontSize: 16))),
                                      ),
                                    ]
                                  ),
                                  
                                ],
                              )
                            ],
                          )
                        );
                      }
                    );
                  }, 
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    color: Utils.colorGreyFromPairIndex(idx: idx),
                    child: Center(
                      child: Text(b["entidad1"]["descripcion"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)))
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.only(top: 5, bottom: 5),
                //   color: Utils.colorGreyFromPairIndex(idx: idx),
                //   child: Center(
                //     child: InkWell(onTap: (){}, child: Text(b["entidad1"]["descripcion"], style: TextStyle(fontSize: 16)))
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${(b["tipo"]["descripcion"] != 'Ajuste') ? b["tipo"]["descripcion"].toString().substring(0, b["tipo"]["descripcion"].toString().length > 10 ? 10 : b["tipo"]["descripcion"].toString().length) : b["debito"] != 0 ? b["tipo"]["descripcion"] + '(Debito)' : b["tipo"]["descripcion"] + '(Credito)'}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${Utils.toDouble(b["debito"].toString()) > 0 ? Utils.toCurrency(b["debito"]) : Utils.toCurrency(b["credito"])}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${Utils.toCurrency(b["entidad1_saldo_final"])}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
                ),
                // Container(
                //   // padding: EdgeInsets.only(top: 10, bottom: 10),
                //   color: Utils.colorGreyFromPairIndex(idx: idx), 
                //   child: Center(child: IconButton(icon: Icon(Icons.delete), onPressed: (){
                //     listaTransaccion.remove(b);
                //     _streamControllerTransacciones.add(listaTransaccion);
                //   },))
                // ),
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
                    child: Center(child: Text('Banca', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Tipo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Monto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Balance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
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
              columnWidths: <int, TableColumnWidth>{1 : FractionColumnWidth(.35)},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
          leading: BackButton(
            color: Utils.colorPrimary,
          ),
          title: Text("Transacciones", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0,
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.pushNamed(context, "/addTransacciones");
          },
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("${_fecha.year}-${_fecha.month}-${_fecha.day}"), 
                  color: Colors.transparent, 
                  onPressed: () async {
                    var fecha = await showDatePicker( context: context, initialDate: DateTime.now(), firstDate: DateTime(2001), lastDate: DateTime(2022));
                    setState(() => _fecha = (fecha != null) ? fecha : _fecha);
                    await _buscarTransacciones();
                  }, 
                  elevation: 0, shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),),
              ),
              StreamBuilder<List>(
                stream: _streamControllerTransacciones.stream,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return  _buildTableTransaccion(snapshot.data);
                  }
                  return _buildTableTransaccion(List());
                },
              ),
              
              
            ],
          ),
        ),
    );
  }
}