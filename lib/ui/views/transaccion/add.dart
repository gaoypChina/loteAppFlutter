import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/entidades.dart';
import 'package:loterias/core/models/tipos.dart';
import 'package:loterias/core/services/transaccionservice.dart';
import 'package:rxdart/rxdart.dart';

class AddTransaccionesScreen extends StatefulWidget {
  @override
  _AddTransaccionesScreenState createState() => _AddTransaccionesScreenState();
}

class _AddTransaccionesScreenState extends State<AddTransaccionesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  StreamController<List<Banca>> _streamControllerBanca;
  StreamController<List<Entidad>> _streamControllerEntidad;
  StreamController<List<Tipo>> _streamControllerTipo;
  StreamController<List> _streamControllerTransacciones;
  final _txtBalanceEntidad1 = TextEditingController();
  final _txtBalanceEntidad2 = TextEditingController();
  final _txtBalanceFinalEntidad1 = TextEditingController();
  final _txtBalanceFinalEntidad2 = TextEditingController();
  final _txtDebito = TextEditingController();
  final _txtCredito = TextEditingController();
  bool _txtDebitoEnabled = true;
  bool _txtCreditoEnabled = true;
  bool _cargando = false;
  List<Banca> listaBanca = List();
  List<Entidad> listaEntidad = List();
  List<Tipo> listaTipo = List();
  List listaTipoTransaccion = [
      {'idTipoBloqueo' : 1, 'descripcion' : 'Normal'}, 
      {'idTipoBloqueo' : 2, 'descripcion' : 'Programada'}
    ];
  List listaTransaccion = List();
  int _indexTipoTransaccion = 0;
  int _indexBanca = 0;
  int _indexEntidad = 0;
  int _indexTipo = 0;
  DateTime _fecha = DateTime.now();
  bool _esProgramada = false;

  @override
  void initState() {
    // TODO: implement initState
    _streamControllerBanca = BehaviorSubject();
    _streamControllerEntidad = BehaviorSubject();
    _streamControllerTipo = BehaviorSubject();
    _streamControllerTransacciones = BehaviorSubject();
    _init();
    super.initState();
  }

  _init() async {
    try{
      setState(() => _cargando = true);
      var datos = await TransaccionService.grupo(scaffoldKey: _scaffoldKey);
      // _initListaTipoTransaccion();
      listaTipo = datos["tipos"].map<Tipo>((t) => Tipo.fromMap(t)).toList();
      listaBanca = datos["bancas"].map<Banca>((t) => Banca.fromMap(t)).toList();
      listaBanca.insert(0, Banca(descripcion: "Selecc.", id: 0));
      listaEntidad = datos["entidades"].map<Entidad>((t) => Entidad.fromMap(t)).toList();
      listaEntidad.insert(0, Entidad(id: 0, nombre: "Selecc."));
      _streamControllerTipo.add(listaTipo);
      _streamControllerBanca.add(listaBanca);
      _streamControllerEntidad.add(listaEntidad);
      print("datos: ${datos.toString()}");
      setState(() => _cargando = false);
    }catch(e){
      setState(() => _cargando = false);
    }
  }

  _initListaTipoTransaccion(){
    listaTipoTransaccion = [
      {'idTipoBloqueo' : 1, 'descripcion' : 'Normal'}, 
      {'idTipoBloqueo' : 2, 'descripcion' : 'Programada'}
    ];
  }

  _tipoTransaccionChange(){
    if(listaTipoTransaccion[_indexTipoTransaccion]["descripcion"] == "Programada"){
      setState((){
        //  _txtDebitoEnabled = true;
        _fecha = DateTime.now().add(Duration(days: 1));
         _esProgramada = true;
      });
    }else{
      setState((){
        //  _txtDebitoEnabled = true;
        _fecha = DateTime.now();
         _esProgramada = false;
      });
    }
  }

  _tipoChange(){
    switch(listaTipo[_indexTipo].descripcion){
      case "Cobro":
        _txtDebito.text = '';
        setState((){
          _txtDebitoEnabled = false;
          _txtCreditoEnabled = true;
        });
        break;
      case "Pago":
        _txtCredito.text = '';
        setState((){
          _txtDebitoEnabled = true;
          _txtCreditoEnabled = false;
        });
        break; 
      case "Descuento dias no laborados":
        _txtCredito.text = '';
        setState((){
          _txtDebitoEnabled = true;
          _txtCreditoEnabled = false;
        });
        break; 
      default:
        setState((){
          _txtDebitoEnabled = true;
          _txtCreditoEnabled = true;
        });
        break; 
    }
  }

  _bancaChange() async {
    try{
      setState(() => _cargando = true);
      var datos = await TransaccionService.saldo(scaffoldKey: _scaffoldKey, id: listaBanca[_indexBanca].id);
      _txtBalanceEntidad1.text = datos["saldo_inicial"].toString();
      print("datos _bancaChange: ${datos["saldo_inicial"]}");
      setState(() => _cargando = false);
    }catch(e){
      setState(() => _cargando = false);
    }
  }

  _entidadChange() async {
    try{
      setState(() => _cargando = true);
      var datos = await TransaccionService.saldo(scaffoldKey: _scaffoldKey, id: listaBanca[_indexBanca].id, esBanca: false);
      _txtBalanceEntidad2.text = datos["saldo_inicial"].toString();
      print("datos _entidadChange: ${datos["saldo_inicial"]}");
      setState(() => _cargando = false);
    }catch(e){
      setState(() => _cargando = false);
    }
  }


  double _saldoFinalEntidad1(){
    if(_txtDebito.text.isNotEmpty && _txtCredito.text.isEmpty){
      return Utils.toDouble(_txtBalanceEntidad1.text) + Utils.toDouble(_txtDebito.text);
    }
    else if(_txtDebito.text.isEmpty && _txtCredito.text.isNotEmpty)
      return Utils.toDouble(_txtBalanceEntidad1.text) - Utils.toDouble(_txtCredito.text);

    return 0;
  }

  double _saldoFinalEntidad2(){
    if(_txtDebito.text.isNotEmpty && _txtCredito.text.isEmpty){
      return Utils.toDouble(_txtBalanceEntidad2.text) - Utils.toDouble(_txtDebito.text);
    }
    else if(_txtDebito.text.isEmpty && _txtCredito.text.isNotEmpty)
      return Utils.toDouble(_txtBalanceEntidad2.text) + Utils.toDouble(_txtCredito.text);

    return 0;
  }
  
  Widget _buildTableVentasPorLoteria(List map){
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
                  child: Center(child: Text("${b["debito"] != 0 ? b["debito"] : b["credito"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  // padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: IconButton(icon: Icon(Icons.delete), onPressed: (){
                    listaTransaccion.remove(b);
                    _streamControllerTransacciones.add(listaTransaccion);
                  },))
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
                    child: Center(child: Text('Tipo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Monto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Borrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
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

 _empty(){
   _txtBalanceEntidad1.text = "";
   _txtBalanceEntidad2.text = "";
   _txtDebito.text = "";
   _txtCredito.text = "";
   _txtBalanceFinalEntidad1.text = "";
   _txtBalanceFinalEntidad2.text = "";
 }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,

      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), 
          onPressed: (){
            if(_formKey.currentState.validate()){
              Map<String, dynamic> map = {
                "tipo" : listaTipo[_indexTipo].toJson(),
                "entidad1" : listaBanca[_indexBanca].toJson(),
                "entidad2" : listaEntidad[_indexEntidad].toJson(),
                "entidad1_saldo_inicial" : _txtBalanceEntidad1.text,
                "entidad2_saldo_inicial" : _txtBalanceEntidad2.text,
                "debito" : Utils.toDouble(_txtDebito.text),
                "credito" : Utils.toDouble(_txtCredito.text),
                "entidad1_saldo_final" : _saldoFinalEntidad1(),
                "entidad2_saldo_final" : _saldoFinalEntidad2(),
                "nota" : "",
                "nota_grupo" : "",
                "tipoTransaccion" : listaTipoTransaccion[_indexTipoTransaccion]["descripcion"],
                "fecha" : _fecha.toString()
              };
              listaTransaccion.add(map);
              _streamControllerTransacciones.add(listaTransaccion);
              // print("save: ${map.toString()}");
            }
          },),
        appBar: AppBar(
          title: Text('Agregar transacciones', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.clear, color: Utils.colorPrimary, size: 25,),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          textTheme: TextTheme(title: TextStyle(color: Colors.black,),),
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
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  child: Text('Agregar', style: TextStyle(color: Colors.blue),),
                ),
                Tab(
                  child: Text('Todas', style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
        ),
        body: TabBarView(
          children: <Widget>[
            AbsorbPointer(
              absorbing: _cargando,
              child: SafeArea(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 0.0, left: 20.0, right: 20.0),
                      child: DropdownButton<dynamic>(
                        isExpanded: true,
                        value: listaTipoTransaccion[_indexTipoTransaccion],
                        items: listaTipoTransaccion.map<DropdownMenuItem>((t) => DropdownMenuItem<dynamic>(
                          value: t,
                          child: Text(t["descripcion"]),
                        )).toList(),
                        onChanged: (map){
                          int idx = listaTipoTransaccion.indexWhere((t) => t["descripcion"] == map["descripcion"]);
                          if(idx != -1)
                            setState((){
                              _indexTipoTransaccion = idx;
                              _tipoTransaccionChange();
                            });
                        },
                      ),
                    ),
                    Visibility(
                      visible: _esProgramada,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("${_fecha.year}-${_fecha.month}-${_fecha.day}"), 
                          color: Colors.transparent, 
                          onPressed: () async {
                            var fecha = await showDatePicker( context: context, initialDate: DateTime.now(), firstDate: DateTime(2001), lastDate: DateTime(2022));
                            setState(() => _fecha = (fecha != null) ? fecha : _fecha);
                          }, 
                          elevation: 0, shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),),
                      ),
                    ),
                     StreamBuilder<List<Tipo>>(
                       stream: _streamControllerTipo.stream,
                       builder: (context, snapshot) {
                         if(snapshot.hasData){
                           return Padding(
                             padding: const EdgeInsets.only(top: 2.0, bottom: 0.0, left: 20.0, right: 20.0),
                             child: DropdownButton<Tipo>(
                               isExpanded: true,
                              value: listaTipo[_indexTipo],
                              items: listaTipo.map<DropdownMenuItem<Tipo>>((t) => DropdownMenuItem<Tipo>(
                                value: t,
                                child: Text(t.descripcion),
                              )).toList(),
                              onChanged: (tipo){
                                int idx = listaTipo.indexWhere((t) => t.descripcion == tipo.descripcion);
                                if(idx != -1){
                                  setState((){
                                    _indexTipo = idx;
                                    _tipoChange();
                                  });
                                }
                              },
                          ),
                           );
                         }
                         return Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: DropdownButton(isExpanded: true, value: "No hay datos", items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], onChanged: null),
                         );
                       }
                     ),
                     Form(
                       key: _formKey,
                       child: Column(
                         children: <Widget>[
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: Padding(
                                   padding: const EdgeInsets.only(left: 20.0, top: 15.0),
                                   child: StreamBuilder<List<Banca>>(
                                    stream: _streamControllerBanca.stream,
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData){
                                        return DropdownButton<Banca>(
                                          // isExpanded: true,
                                          value: listaBanca[_indexBanca],
                                          items: listaBanca.map<DropdownMenuItem<Banca>>((t) => DropdownMenuItem<Banca>(
                                            value: t,
                                            child: Text(t.descripcion),
                                          )).toList(),
                                          onChanged: (banca){
                                            int idx = listaBanca.indexWhere((t) => t.descripcion == banca.descripcion);
                                            if(idx != -1){
                                              setState((){
                                                 _indexBanca = idx;
                                                 _bancaChange();
                                              });
                                            }
                                          },
                                        );
                                      }
                                      return DropdownButton( value: "No hay datos", items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], onChanged: null);
                                    }
                              ),
                                 ),
                               ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0, left: 10.0),
                                  child: TextFormField(
                                    controller: _txtBalanceEntidad1,
                                    enabled: false,
                                    // decoration: InputDecoration(labelText: "Balance"),
                                  ),
                                ),
                              )
                             ],
                           ),
                           Row(
                             children: <Widget>[
                               Expanded(
                                 child: Padding(
                                   padding: const EdgeInsets.only(left: 20.0, top: 15.0),
                                   child: StreamBuilder<List<Banca>>(
                                    stream: _streamControllerBanca.stream,
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData){
                                        return DropdownButton<Entidad>(
                                          // isExpanded: true,
                                          value: listaEntidad[_indexEntidad],
                                          items: listaEntidad.map<DropdownMenuItem<Entidad>>((t) => DropdownMenuItem<Entidad>(
                                            value: t,
                                            child: Text(t.nombre),
                                          )).toList(),
                                          onChanged: (entidad){
                                            int idx = listaEntidad.indexWhere((t) => t.nombre == entidad.nombre);
                                            if(idx != -1){
                                              setState((){
                                                 _indexEntidad = idx;
                                                 _entidadChange();
                                              });
                                            }
                                          },
                                        );
                                      }
                                      return DropdownButton( value: "No hay datos", items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], onChanged: null);
                                    }
                              ),
                                 ),
                               ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0, left: 10.0),
                                  child: TextFormField(
                                    controller: _txtBalanceEntidad2,
                                    enabled: false,
                                    // decoration: InputDecoration(labelText: "Balance"),
                                  ),
                                ),
                              )
                             ],
                           ),
                           Row(
                             children: <Widget>[
                               Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0, left: 10.0),
                                  child: TextFormField(
                                    controller: _txtDebito,
                                    enabled: _txtDebitoEnabled,
                                    decoration: InputDecoration(labelText: "Debito"),
                                    onChanged: (texto){
                                      _txtBalanceFinalEntidad1.text = _saldoFinalEntidad1().toString();
                                      _txtBalanceFinalEntidad2.text = _saldoFinalEntidad2().toString();
                                    },
                                    validator: (data){
                                      if(data.isEmpty && _txtDebitoEnabled && listaTipo[_indexTipo].descripcion != "Ajuste")
                                        return "Vacio";
                                      else if(data.isEmpty && _txtDebitoEnabled && listaTipo[_indexTipo].descripcion == "Ajuste"){
                                        return (_txtCredito.text.isEmpty) ? "Vacio" : null;
                                      }
                                      else
                                        return null;
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0, left: 10.0),
                                  child: TextFormField(
                                    controller: _txtCredito,
                                    enabled: _txtCreditoEnabled,
                                    decoration: InputDecoration(labelText: "Credito"),
                                    onChanged: (texto){
                                      _txtBalanceFinalEntidad1.text = _saldoFinalEntidad1().toString();
                                      _txtBalanceFinalEntidad2.text = _saldoFinalEntidad2().toString();
                                    },
                                    validator: (data){
                                      if(data.isEmpty && _txtCreditoEnabled && listaTipo[_indexTipo].descripcion != "Ajuste")
                                        return "Vacio";
                                      else if(data.isEmpty && _txtCreditoEnabled && listaTipo[_indexTipo].descripcion == "Ajuste"){
                                        return (_txtDebito.text.isEmpty) ? "Vacio" : null;
                                      }
                                      else
                                        return null;
                                    },
                                  ),
                                ),
                              )
                             ],
                           ),
                           Row(
                             children: <Widget>[
                               Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0, left: 10.0),
                                  child: TextFormField(
                                    controller: _txtBalanceFinalEntidad1,
                                    enabled: false,
                                    decoration: InputDecoration(labelText: "Final entidad1"),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0, left: 10.0),
                                  child: TextFormField(
                                    controller: _txtBalanceFinalEntidad2,
                                    enabled: false,
                                    decoration: InputDecoration(labelText: "Final entidad2"),
                                  ),
                                ),
                              )
                             ],
                           ),
                         ],
                       ),
                     ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: ListView(
                children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    elevation: 0,
                    color: Utils.fromHex("#e4e6e8"),
                    child: Text("Eliminar todas", style: TextStyle(color: Utils.colorPrimary),),
                    onPressed: (){
                      listaTransaccion.clear();
                      _streamControllerTransacciones.add(listaTransaccion);
                    },
                  ),
                ),
                  StreamBuilder<List>(
                    stream: _streamControllerTransacciones.stream,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return _buildTableVentasPorLoteria(listaTransaccion);
                      }
                      return Text("No hay transacciones registradas", style: TextStyle(fontSize: 22));
                    },
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}