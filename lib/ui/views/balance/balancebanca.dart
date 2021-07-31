import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/services/balanceservice.dart';
import 'package:rxdart/rxdart.dart';

class BalanceBancaScreen extends StatefulWidget {
  @override
  _BalanceBancaScreenState createState() => _BalanceBancaScreenState();
}

class _BalanceBancaScreenState extends State<BalanceBancaScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<List<Banca>> _streamControllerBancas;
  StreamController<List> _streamControllerTabla;
  List<Banca> listaBanca = [];
  List<Banca> listaDinamicaBanca = [];
  int _indexBanca = 0;
  bool _cargando = false;
  bool _onCreate = true;
  DateTime _fechaHasta = DateTime.now();
  

  @override
  void initState() {
    // TODO: implement initState
    _streamControllerBancas = BehaviorSubject();
    _streamControllerTabla = BehaviorSubject();
    _bancas();
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
    _streamControllerTabla.close();
    super.dispose();

  }

  _bancas() async {
    try{
      setState(() => _cargando = true);
      List lista = await BalanceService.bancas(fechaHasta: _fechaHasta, scaffoldKey: _scaffoldKey, idGrupo: await Db.idGrupo());
      if(_onCreate && lista != null){
        listaBanca = lista.map((b) => Banca.fromMap(b)).toList();
        listaBanca.insert(0, Banca(id: 0, descripcion: "Todas las bancas"));
        _streamControllerBancas.add(listaBanca);
        _onCreate = false;
      }
      listaDinamicaBanca = lista.map((b) => Banca.fromMap(b)).toList();;
      _streamControllerTabla.add(listaDinamicaBanca);
      _filterTable();
      setState(() => _cargando = false);
    }on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  _filterTable(){
    if(listaBanca[_indexBanca].descripcion == "Todas las bancas")
      _streamControllerTabla.add(listaDinamicaBanca);
    else
      _streamControllerTabla.add(listaDinamicaBanca.where((b) => b.descripcion == listaBanca[_indexBanca].descripcion).toList());
  }

  Widget _buildTableBancas(List<Banca> map){
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
                    child: InkWell(onTap: (){}, child: Text(b.descripcion, style: TextStyle(fontSize: 16, decoration: TextDecoration.underline)))
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b.usuario.usuario}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b.dueno}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: (b.balance >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
                  child: Center(child: Text("${Utils.toCurrency(b.balance)}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("0", style: TextStyle(fontSize: 16)))
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
                    child: Center(child: Text('Banca', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Usuario', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Dueño', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Balance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Prestamo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
                  // ),
                ]
              )
              );

    var total = map.map((e) => e.balance).toList().reduce((value, element) => value + element);
    rows.add(
              TableRow(
                // decoration: BoxDecoration(color: Utils.colorPrimary),
                children: [
                  // buildContainer(Colors.blue, 50.0),
                  // buildContainer(Colors.red, 50.0),
                  // buildContainer(Colors.blue, 50.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Totales', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('${Utils.toCurrency(total)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: total >= 0 ? Utils.colorPrimary : Colors.pink)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('${Utils.toCurrency(0)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
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
              columnWidths: <int, TableColumnWidth>{2 : FractionColumnWidth(.28)},
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
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Desde", style: TextStyle(fontSize: 20),),
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
                        onPressed: (){
                          // _ventas();
                          _bancas();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
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
                            print("Bancas changed: ${banca.descripcion} - ${banca.id}");
                            setState(() {
                              _indexBanca = listaBanca.indexWhere((b) => b.descripcion == banca.descripcion);
                              if(_indexBanca != -1){
                                _filterTable();
                              }
                            });
                          },
                        );
                      }

                      return DropdownButton(value: "No hay datos", items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], onChanged: null);
                    },
                  ),
                ),
                
              ],
            ),
            StreamBuilder<List>(
                  stream: _streamControllerTabla.stream,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return _buildTableBancas(snapshot.data);
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