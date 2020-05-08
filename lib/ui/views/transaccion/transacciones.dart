import 'dart:async';

import 'package:flutter/material.dart';
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
                  child: Center(child: Text("${(b["tipo"]["descripcion"] != 'Ajuste') ? b["tipo"]["descripcion"] : b["debito"] != 0 ? b["tipo"]["descripcion"] + '(Debito)' : b["tipo"]["descripcion"] + '(Credito)'}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${Utils.toDouble(b["debito"].toString()) > 0 ? b["debito"] : b["credito"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["entidad1_saldo_final"]}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
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
              StreamBuilder<List>(
                stream: _streamControllerTransacciones.stream,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return _buildTableTransaccion(snapshot.data);
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