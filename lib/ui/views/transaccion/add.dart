import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/entidades.dart';
import 'package:loterias/core/models/tipos.dart';
import 'package:loterias/core/services/transaccionservice.dart';
import 'package:loterias/ui/widgets/mybutton.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mytabbar.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:rxdart/rxdart.dart';

class AddTransaccionesScreen extends StatefulWidget {
  bool isLarge;
  AddTransaccionesScreen({Key key, this.isLarge = false}) : super(key: key);
  @override
  AddTransaccionesScreenState createState() => AddTransaccionesScreenState();
}

class AddTransaccionesScreenState extends State<AddTransaccionesScreen> with TickerProviderStateMixin {
  var _tabController;
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
  bool _cargandoBalanceBanca = false;
  bool _cargandoBalanceEntidad = false;
  List<Banca> listaBanca = [];
  List<Entidad> listaEntidad = [];
  List<Tipo> listaTipo = [];
  List listaTipoTransaccion = [
      {'idTipoBloqueo' : 1, 'descripcion' : 'Normal'}, 
      {'idTipoBloqueo' : 2, 'descripcion' : 'Programada'}
    ];
  List listaTransaccion =[];
  int _indexTipoTransaccion = 0;
  int _indexBanca = 0;
  int _indexEntidad = 0;
  int _indexTipo = 0;
  DateTime _fecha = DateTime.now();
  bool _esProgramada = false;
  Banca _banca;
  Entidad _entidad;
  Future _future;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    _streamControllerBanca = BehaviorSubject();
    _streamControllerEntidad = BehaviorSubject();
    _streamControllerTipo = BehaviorSubject();
    _streamControllerTransacciones = BehaviorSubject();
    _future = _init();
    super.initState();
  }

  _init() async {
    try{
      setState(() => _cargando = true);
      var datos = await TransaccionService.grupo(scaffoldKey: _scaffoldKey);
      // _initListaTipoTransaccion();
      listaTipo = datos["tipos"].map<Tipo>((t) => Tipo.fromMap(t)).toList();
      listaBanca = datos["bancas"].map<Banca>((t) => Banca.fromMap(t)).toList();
      listaEntidad = datos["entidades"].map<Entidad>((t) => Entidad.fromMap(t)).toList();
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

  _bancaChange(Banca banca) async {
    try{
      _txtDebito.text = "";
      _txtCredito.text = "";
      _txtBalanceFinalEntidad1.text = "";
      _txtBalanceFinalEntidad2.text = "";
      setState((){
        _banca = banca;
        _cargandoBalanceBanca = true;
      });
      var datos = await TransaccionService.saldo(scaffoldKey: _scaffoldKey, id: banca.id);
      _txtBalanceEntidad1.text = datos["saldo_inicial"].toString();
      print("datos _bancaChange: ${datos["saldo_inicial"]}");

      
      _streamControllerEntidad.add(listaEntidad.where((element) => element.idMoneda == banca.idMoneda).toList());
      setState((){
        _cargandoBalanceBanca = false;
        _entidad = null;
      });
    }catch(e){
      setState((){
        _indexBanca = 0;
        _txtBalanceEntidad1.text = '';
        _cargandoBalanceBanca = false;
      });
    }
  }

  _entidadChange(Entidad entidad) async {
    try{
      _txtDebito.text = "";
      _txtCredito.text = "";
      _txtBalanceFinalEntidad1.text = "";
      _txtBalanceFinalEntidad2.text = "";
      setState((){
        _entidad = entidad;
        _cargandoBalanceEntidad = true;
      });
      var datos = await TransaccionService.saldo(scaffoldKey: _scaffoldKey, id: entidad.id, esBanca: false);
      _txtBalanceEntidad2.text = datos["saldo_inicial"].toString();
      print("datos _entidadChange: ${datos["saldo_inicial"]}");
      setState(() => _cargandoBalanceEntidad = false);
    }catch(e){

      setState((){
        _indexEntidad = 0;
      _txtBalanceEntidad2.text = '';
        _cargandoBalanceEntidad = false;
      });
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

 _addTransaccion() async {
   if(_banca == null){
     Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: "Debe seleccionar una banca");
     return;
   }

   if(_entidad == null){
     Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: "Debe seleccionar un banco");
     return;
   }

    int idx = listaTransaccion.indexWhere((t) => t["entidad1"]["descripcion"] == _banca.descripcion && t["tipo"]["descripcion"] == listaTipo[_indexTipo].descripcion);
    if(idx == -1)
    {
      Map<String, dynamic> map = {
      "tipo" : listaTipo[_indexTipo].toJson(),
      "entidad1" : _banca.toJson(),
      "entidad2" : _entidad.toJson(),
      "entidad1_saldo_inicial" : Utils.toDouble(_txtBalanceEntidad1.text),
      "entidad2_saldo_inicial" : Utils.toDouble(_txtBalanceEntidad2.text),
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
    _empty();
    }else{
      if(await _preguntarDeseaActualizarTransaccionExistente()){
        listaTransaccion[idx]["debito"] = Utils.toDouble(_txtDebito.text);
        listaTransaccion[idx]["credito"] = Utils.toDouble(_txtCredito.text);
        listaTransaccion[idx]["entidad1_saldo_final"] = _saldoFinalEntidad1();
        listaTransaccion[idx]["entidad2_saldo_final"] = _saldoFinalEntidad2();
      _streamControllerTransacciones.add(listaTransaccion);
      _empty();
      }
    }
 }

 _empty(){
   _txtBalanceEntidad1.text = "";
   _txtBalanceEntidad2.text = "";
   _txtDebito.text = "";
   _txtCredito.text = "";
   _txtBalanceFinalEntidad1.text = "";
   _txtBalanceFinalEntidad2.text = "";
   setState((){
     _indexEntidad = 0;
     _indexBanca = 0;
     _banca = null;
     _entidad = null;
   });
 }

  Future<bool> _preguntarDeseaActualizarTransaccionExistente() async {
   return await showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Transaccion existe"),
          content: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(text: "La transaccion de tipo "),
                TextSpan(text: listaTipo[_indexTipo].descripcion, style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " para la banca "),
                TextSpan(text: _banca.descripcion, style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: " ya existe, desea actualizar?"),
              ]
            ),
          ),
          actions: <Widget>[
            FlatButton(child: Text("No"), onPressed: (){Navigator.pop(context, false);},),
            FlatButton(
              child: Text("Si"),
              onPressed: (){
                Navigator.pop(context, true);
              },
            )
          ],
        );
      }
    );
  }

  Future guardar() async {
    if(listaTransaccion.length <= 0){
      Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: "Error: Debe registrar transacciones");
      return;
    }

    try{
      setState(() => _cargando = true);
      var datos = await TransaccionService.guardar(scaffoldKey: _scaffoldKey, idUsuario: await Db.idUsuario(), transacciones: listaTransaccion);
      print("AddTransacciones guardar datos: ${datos}");
      print("");
      print("");
      print("");
      // print("AddTransacciones guardar datos grupos: ${datos["grupo"][0]["transacciones"]}");
      listaTransaccion.clear();
      // Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: "Se ha guardado correctamente");
      Navigator.pop(context, datos != null ? datos["grupo"] != null ? datos["grupo"]["transacciones"] : null : null);
      setState(() => _cargando = false);
    }on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  _formScreen(bool isSmallOrMedium){
    List<Widget> widgets = <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 2.0, bottom: 0.0, left: 20.0, right: 20.0),
        child: 
        // DropdownButton<dynamic>(
        //   isExpanded: true,
        //   value: listaTipoTransaccion[_indexTipoTransaccion],
        //   items: listaTipoTransaccion.map<DropdownMenuItem>((t) => DropdownMenuItem<dynamic>(
        //     value: t,
        //     child: Text(t["descripcion"]),
        //   )).toList(),
        //   onChanged: (map){
        //     int idx = listaTipoTransaccion.indexWhere((t) => t["descripcion"] == map["descripcion"]);
        //     if(idx != -1)
        //       setState((){
        //         _indexTipoTransaccion = idx;
        //         _tipoTransaccionChange();
        //       });
        //   },
        // ),
        MyDropdownButton(
              title: "Tipo",
              value: listaTipoTransaccion[_indexTipoTransaccion],
              items: listaTipoTransaccion.map((e) => [e, e["descripcion"]]).toList(),
              medium: 1,
              large: 1,
              xlarge: 1,
              onChanged: (map){
                int idx = listaTipoTransaccion.indexWhere((t) => t["descripcion"] == map["descripcion"]);
                if(idx != -1)
                  setState((){
                    _indexTipoTransaccion = idx;
                    _tipoTransaccionChange();
                  });
              },
            )
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
              child: 
            //   DropdownButton<Tipo>(
            //     isExpanded: true,
            //     value: listaTipo[_indexTipo],
            //     items: listaTipo.map<DropdownMenuItem<Tipo>>((t) => DropdownMenuItem<Tipo>(
            //       value: t,
            //       child: Text(t.descripcion),
            //     )).toList(),
            //     onChanged: (tipo){
            //       int idx = listaTipo.indexWhere((t) => t.descripcion == tipo.descripcion);
            //       if(idx != -1){
            //         setState((){
            //           _indexTipo = idx;
            //           _tipoChange();
            //         });
            //       }
            //     },
            // ),
            MyDropdownButton(
              title: "Concepto",
              value: listaTipo[_indexTipo],
              items: listaTipo.map((e) => [e, e.descripcion]).toList(),
              medium: 1,
              large: 1,
              xlarge: 1,
              onChanged: (tipo){
                int idx = listaTipo.indexWhere((t) => t.descripcion == tipo.descripcion);
                if(idx != -1){
                  setState((){
                    _indexTipo = idx;
                    _tipoChange();
                  });
                }
              },
            )
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
                          // return DropdownButton<Banca>(
                          //   // isExpanded: true,
                          //   value: listaBanca[_indexBanca],
                          //   items: listaBanca.map<DropdownMenuItem<Banca>>((t) => DropdownMenuItem<Banca>(
                          //     value: t,
                          //     child: Text(t.descripcion),
                          //   )).toList(),
                          //   onChanged: (banca){
                          //     int idx = listaBanca.indexWhere((t) => t.descripcion == banca.descripcion);
                          //     if(idx != -1){
                          //       setState((){
                          //          _indexBanca = idx;
                          //          _bancaChange();
                          //       });
                          //     }
                          //   },
                          // );
                          return MyDropdownButton(
                            hint: "Selec. banca",
                            value: _banca,
                            items: snapshot.data.map((e) => [e, e.descripcion]).toList(),
                            onChanged: (value){
                              _bancaChange(value);
                            }
                          );
                        }
                        return DropdownButton( value: "No hay datos", items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], onChanged: null);
                      }
                ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 10.0),
                        child: MyTextFormField(
                          controller: _txtBalanceEntidad1,
                          enabled: false,
                          type: MyType.normal,
                          title: "Balance",
                          // decoration: InputDecoration(labelText: "Balance"),
                        ),
                      ),
                      Visibility(
                        visible: _cargandoBalanceBanca,
                        child: Positioned(
                          top: 25,
                          right: 20,
                          child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator())
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 15.0),
                    child: StreamBuilder<List<Entidad>>(
                      stream: _streamControllerEntidad.stream,
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          // return DropdownButton<Entidad>(
                          //   // isExpanded: true,
                          //   value: snapshot.data[_indexEntidad],
                          //   items: listaEntidad.map<DropdownMenuItem<Entidad>>((t) => DropdownMenuItem<Entidad>(
                          //     value: t,
                          //     child: Text(t.nombre),
                          //   )).toList(),
                          //   onChanged: (entidad){
                          //     int idx = listaEntidad.indexWhere((t) => t.nombre == entidad.nombre);
                          //     if(idx != -1){
                          //       setState((){
                          //          _indexEntidad = idx;
                          //          _entidadChange();
                          //       });
                          //     }
                          //   },
                          // );
                          return MyDropdownButton(
                            hint: "Selec. banco",
                            value: _entidad,
                            items: snapshot.data.map((e) => [e, e.nombre]).toList(),
                            onChanged: (value){
                              _entidadChange(value);
                            }
                          );
                        }
                        return DropdownButton( value: "No hay datos", items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], onChanged: null);
                      }
                ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0, left: 10.0),
                        child: MyTextFormField(
                          controller: _txtBalanceEntidad2,
                          enabled: false,
                          type: MyType.normal,
                          title: "Balance",
                          // decoration: InputDecoration(labelText: "Balance"),
                        ),
                      ),
                      Visibility(
                        visible: _cargandoBalanceEntidad,
                        child: Positioned(
                          top: 25,
                          right: 20,
                          child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator())
                        ),
                      )
                    ],
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
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        // WhitelistingTextInputFormatter.digitsOnly,
                        // DecimalTextInputFormatter(decimalRange: 2),
                        FilteringTextInputFormatter.allow(RegExp('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$'))
                        // RegExp(r"^(?=.*[1-9])\s*\d*(?:\.\d{1,2})?\s*$")
                      ],
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
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // WhitelistingTextInputFormatter.digitsOnly
                        FilteringTextInputFormatter.allow(RegExp('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$'))

                      ],
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
            Visibility(
              visible: !isSmallOrMedium,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyButton(
                      isResponsive: false,
                      color: Colors.green,
                      medium: 5,
                      large: 5,
                      title: "Agregar",
                      function: (){
                        if(_formKey.currentState.validate()){
                          _addTransaccion();
                          // print("save: ${map.toString()}");
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ];
                            
    return AbsorbPointer(
      absorbing: _cargando || _cargandoBalanceBanca || _cargandoBalanceEntidad,
      child: SafeArea(
        child: 
        isSmallOrMedium
        ?
        ListView(
          shrinkWrap: true,
          children: widgets
        )
        :
        Column(
          children: widgets
        ),
      ),
    );
  }

  _dataScreen(bool isSmallOrMedium){
    List<Widget> widgets = <Widget>[
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: MyResizedContainer(
            small: 1,
            medium: 1,
            child: InkWell(
              onTap: (){
                listaTransaccion.clear();
                _streamControllerTransacciones.add(listaTransaccion);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text("Eliminar todas", style: TextStyle(fontSize: 16))),
              ),
            ),
          ),
        ),
      ),
      StreamBuilder<List>(
        stream: _streamControllerTransacciones.stream,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return _buildTableVentasPorLoteria(listaTransaccion);
          }
          return Center(child: Text("No hay transacciones registradas", style: TextStyle(fontSize: 18)));
        },
      )
    ];
    
    return 
    isSmallOrMedium
    ?
    ListView(
      children: widgets,
    )
    :
    Column(
      // shrinkWrap: true,
      children: widgets
    );
          
  }

  screen(bool isSmallOrMedium){
    
    return 
    widget.isLarge
    ?
    Wrap(
      children: [
        _formScreen(isSmallOrMedium),
        _dataScreen(isSmallOrMedium)
      ],
    )
    :
    Column(
      mainAxisSize: MainAxisSize.min,
              children: [
                  MyTabBar(controller: _tabController, tabs: ["Agregar", "Todas"], isScrollable: false,),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _formScreen(isSmallOrMedium),
                        _dataScreen(isSmallOrMedium)
                      ]
                    )
                  )
              ],
            );
  }

  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    if(widget.isLarge)
      return screen(isSmallOrMedium);

    return myScaffold(
      key: _scaffoldKey,
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      floatingActionButton: isSmallOrMedium ? FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor, 
        child: Icon(Icons.add), onPressed: (){
          if(_formKey.currentState.validate()){
            _addTransaccion();
            // print("save: ${map.toString()}");
          }
        },
      ) : null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Agregar transacciones",
          actions: [
            MySliverButton(title: "Guardar", onTap: guardar)
          ],
        ), 
        sliver: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));

            return SliverFillRemaining(child: 
              screen(isSmallOrMedium)
            );
          }
        )
      )
    );

    return DefaultTabController(
      length: 2,

      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), 
          onPressed: (){
            if(_formKey.currentState.validate()){
             _addTransaccion();
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
                IconButton(
                  icon: Icon(Icons.save, color: Colors.blue,), 
                  onPressed: guardar
                )
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
                                        // return DropdownButton<Banca>(
                                        //   // isExpanded: true,
                                        //   value: listaBanca[_indexBanca],
                                        //   items: listaBanca.map<DropdownMenuItem<Banca>>((t) => DropdownMenuItem<Banca>(
                                        //     value: t,
                                        //     child: Text(t.descripcion),
                                        //   )).toList(),
                                        //   onChanged: (banca){
                                        //     int idx = listaBanca.indexWhere((t) => t.descripcion == banca.descripcion);
                                        //     if(idx != -1){
                                        //       setState((){
                                        //          _indexBanca = idx;
                                        //          _bancaChange();
                                        //       });
                                        //     }
                                        //   },
                                        // );
                                        return MyDropdownButton(
                                          hint: "Selec. banca",
                                          value: _banca,
                                          items: snapshot.data.map((e) => [e, e.descripcion]).toList(),
                                          onChanged: (value){
                                            _bancaChange(value);
                                          }
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
                                   child: StreamBuilder<List<Entidad>>(
                                    stream: _streamControllerEntidad.stream,
                                    builder: (context, snapshot) {
                                      if(snapshot.hasData){
                                        // return DropdownButton<Entidad>(
                                        //   // isExpanded: true,
                                        //   value: snapshot.data[_indexEntidad],
                                        //   items: listaEntidad.map<DropdownMenuItem<Entidad>>((t) => DropdownMenuItem<Entidad>(
                                        //     value: t,
                                        //     child: Text(t.nombre),
                                        //   )).toList(),
                                        //   onChanged: (entidad){
                                        //     int idx = listaEntidad.indexWhere((t) => t.nombre == entidad.nombre);
                                        //     if(idx != -1){
                                        //       setState((){
                                        //          _indexEntidad = idx;
                                        //          _entidadChange();
                                        //       });
                                        //     }
                                        //   },
                                        // );
                                        return MyDropdownButton(
                                          hint: "Selec. banco",
                                          value: _entidad,
                                          items: snapshot.data.map((e) => [e, e.nombre]).toList(),
                                          onChanged: (value){
                                            _entidadChange(value);
                                          }
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
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      // WhitelistingTextInputFormatter.digitsOnly,
                                      // DecimalTextInputFormatter(decimalRange: 2),
                                      FilteringTextInputFormatter.allow(RegExp('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$'))
                                      // RegExp(r"^(?=.*[1-9])\s*\d*(?:\.\d{1,2})?\s*$")
                                    ],
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
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      // WhitelistingTextInputFormatter.digitsOnly
                                      FilteringTextInputFormatter.allow(RegExp('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$'))

                                    ],
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