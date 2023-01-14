import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/entidades.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/tipos.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/services/transaccionservice.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/myfilter2.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/myscrollbar.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/showmymodalbottomsheet.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';
import 'package:rxdart/rxdart.dart';

import '../../widgets/mycirclebutton.dart';
import '../../widgets/myfilterv2.dart';
import 'add.dart';

class TransaccionesScreen extends StatefulWidget {
  @override
  _TransaccionesScreenState createState() => _TransaccionesScreenState();
}

class _TransaccionesScreenState extends State<TransaccionesScreen> {
  var _txtSearch = TextEditingController();
  GlobalKey<MyFilter2State> _myFilterKey = GlobalKey();
  GlobalKey<AddTransaccionesScreenState> _addTransaccionScreenKey = GlobalKey();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  bool _cargando = false;
  StreamController<List> _streamControllerTransacciones;
  List listaTransaccion =[];
  MyDate _fecha;
  List<MyFilterSubData2> _selectedFilter = [];
  List<MyFilterData2> listaFiltros = [];
  List<Tipo> listaEntidad = [];
  List<Grupo> listaGrupo = [];
  List<Banca> listaBanca = [];
  List<Usuario> listaUsuario = [];
  List<Tipo> listaTipo = [];
  Entidad _banco;
  Banca _banca;
  Usuario _usuario;
  Tipo _tipo;
  List<Entidad> listaBanco = [];
  Entidad _entidad;
  int _idGrupoDeEsteUsuario;
  DateTimeRange _date;
  Future _futureData;
  

  @override
  void initState() {
    // TODO: implement initState
    _streamControllerTransacciones = BehaviorSubject();
    _date = MyDate.getTodayDateRange();
    _futureData = _init();
    super.initState();
  }

  _init() async {
    try{
      // setState(() => _cargando = true);
      var parsed = await TransaccionService.transacciones(scaffoldKey: _scaffoldkey);
      listaTransaccion = List.from(parsed["transacciones"]);
      listaEntidad = parsed["entidades"] != null ? parsed["entidades"].map<Tipo>((e) => Tipo.fromMap(e)).toList() : [];
      listaBanca = parsed["bancas"] != null ? parsed["bancas"].map<Banca>((e) => Banca.fromMap(e)).toList() : [];
      listaBanca.insert(0, Banca(id: 0, descripcion: 'Todas'));
      listaBanco = parsed["bancos"] != null ? parsed["bancos"].map<Entidad>((e) => Entidad.fromMap(e)).toList() : [];
      listaUsuario = parsed["usuarios"] != null ? parsed["usuarios"].map<Usuario>((e) => Usuario.fromMap(e)).toList() : [];
      listaUsuario.insert(0, Usuario(id: 0, usuario: 'Todos'));
      listaTipo = parsed["tipos"] != null ? parsed["tipos"].map<Tipo>((e) => Tipo.fromMap(e)).toList() : [];
      listaTipo.insert(0, Tipo(0, 'Todos', null, null, null));
      _streamControllerTransacciones.add(listaTransaccion);
      listaTransaccion.forEach((f) => print("debito: ${f["debito"]} - credito: ${f["credito"]}"));
      print("transaccionesscreen transacciones: ${parsed['entidades']}");

      listaEntidad.forEach((element) {print("TransaccionesScreen _init: ${element.descripcion}");});

      if(listaEntidad.length > 0){
        listaFiltros.add(MyFilterData2(
          child: "Entidades", 
          data: listaEntidad.map((e){
            List<MyFilterSubData2> listaTercerSubData;
            if(e.descripcion == "Banca")
              listaTercerSubData = listaBanca.map((element) => MyFilterSubData2(child: element.descripcion, value: element, type: "Entidades")).toList();
            else if(e.descripcion == "Banco")
              listaTercerSubData = listaBanco.map((element) => MyFilterSubData2(child: element.nombre, value: element, type: "Entidades")).toList();

            return MyFilterSubData2(child: e.descripcion, value: e, data: listaTercerSubData);
          }).toList()
        ));
      }

      if(listaUsuario.length > 0){
        listaFiltros.add(MyFilterData2(child: "Usuario", data: listaUsuario.map((e) => MyFilterSubData2(child: e.usuario, value: e)).toList()));
      }
      if(listaTipo.length > 0){
        listaFiltros.add(MyFilterData2(child: "Concepto", data: listaTipo.map((e) => MyFilterSubData2(child: e.descripcion, value: e)).toList()));
      }

      
      // setState(() => _cargando = false);
    }on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  _buscarTransacciones() async {
    try{
      setState(() => _cargando = true);
      // var fechaHasta = new DateTime(_fecha.year, _fecha.month, _fecha.day, 23, 55);
      _streamControllerTransacciones.add(null);
      var entidad = _banca != null ? listaEntidad.firstWhere((element) => element.descripcion == "Banca", orElse: () => null) : _banco != null ? listaEntidad.firstWhere((element) => element.descripcion == "Banco", orElse: () => null) : null;
      var idEntidad = _banca != null ? _banca.id != 0 ? _banca.id : null : _banco != null ? _banco.id : null;
      var datos = await TransaccionService.buscarTransacciones(scaffoldKey: _scaffoldkey, fechaDesde: _date.start, fechaHasta: _date.end, idUsuario: _usuario != null ? _usuario.id != 0 ? _usuario.id : null : null, idTipoEntidad: entidad != null ? entidad.id : null, idEntidad: idEntidad, idTipo: _tipo != null ? _tipo.id != 0 ? _tipo.id : null : null );
      listaTransaccion = List.from(datos["transacciones"]);
      _streamControllerTransacciones.add(listaTransaccion);
      listaTransaccion.forEach((f) => print("debito: ${f["debito"]} - credito: ${f["credito"]}"));
      print("transaccionesscreen transacciones: ${datos['transacciones']}");
      setState(() => _cargando = false);
    }on Exception catch(e){
      _streamControllerTransacciones.add([]);
      setState(() => _cargando = false);
    }
  }

  _goToAddTransacciones(bool isSmallOrMedium) async {
    if(isSmallOrMedium){
      var data2 = await Navigator.pushNamed(context, "/addTransacciones");
      if(data2 == null)
        return;

      _addDataToList(data2);
    }else{
       bool cargandoGuardar = false;
     var data2 = await showDialog(
       context: context, 
       builder: (context){
         return  StatefulBuilder(
           builder: (context, setState) {
             return MyAlertDialog(
              title: "Guardar", 
              medium: 1,
              large: 1,
              xlarge: 2,
              cargando: cargandoGuardar,
              content: MyScrollbar(child: AddTransaccionesScreen(key: _addTransaccionScreenKey, isLarge: true,)), 
              okFunction: () async {
                try {
                  setState(() => cargandoGuardar = true);
                  await _addTransaccionScreenKey.currentState.guardar();
                  setState(() => cargandoGuardar = false);
                } on Exception catch (e) {
                  // TODO
                  setState(() => cargandoGuardar = false);
                }
              }
                 );
           }
         );
       }
      );

      if(data2 == null)
        return;
      _addDataToList(data2);
      print("_goToAddTransactions data: $data2");
    }
  }

   _addDataToList(List data){
     if(data == null)
      return;

    if(data.length == 0)
      return;


    print("TransaccionesScreen _addDataToList validaciones length: ${data.length}");
    print("TransaccionesScreen _addDataToList validaciones data: ${data}");
    for (var item in data) {
      int idx = listaTransaccion.indexWhere((element) => element["id"] == item["id"]);
      print("TransaccionesScreen _addDataToList index: $idx ${item["id"]}");
      if(idx != -1)
        listaTransaccion[idx] = item;
      else
        listaTransaccion.add(item);
    }

    // print("TransaccionesScreen _addDataToList validaciones final: ${listaTransaccion.length}");


    _streamControllerTransacciones.add(listaTransaccion);
  }

  _search(String data){
    print("SucursalesSCreen _search: $data");
    if(data.isEmpty)
      _streamControllerTransacciones.add(listaTransaccion);
    else
      {
        var element = listaTransaccion.where((element) => element["entidad1"]["descripcion"].toLowerCase().indexOf(data) != -1 || element["entidad2"]["nombre"].toLowerCase().indexOf(data) != -1).toList();
        // print("RolesScreen _serach length: ${element.length}");
        _streamControllerTransacciones.add(element);
      }
  }

  _myWebFilterScreen(bool isSmallOrMedium){
    return 
    isSmallOrMedium
    ?
    SizedBox.shrink()
    :
    Padding(
      padding: EdgeInsets.only(bottom: isSmallOrMedium ? 0 : 0, top: 5),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                // _mydropdown(),
                // MyDropdown(
                //   large: 5.8,
                //   title: "Filtrar",
                //   hint: "${_selectedOption != null ? _selectedOption : 'No hay opcion'}",
                //   elements: listaOpciones.map((e) => [e, "$e"]).toList(),
                //   onTap: (value){
                //     _opcionChanged(value);
                //   },
                // ),
                // MyDropdown(
                //   large: 5.8,
                //   title: "Grupos",
                //   hint: "${_grupo != null ? _grupo.descripcion : 'No hay grupo'}",
                //   elements: listaGrupo.map((e) => [e, "$e"]).toList(),
                //   onTap: (value){
                //     _opcionChanged(value);
                //   },
                // ),
               Expanded(
                  child: Container(
                    // width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: _myFilterWidget(isSmallOrMedium),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.0, top: 18.0, bottom: !isSmallOrMedium ? 20 : 0),
                    child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar banca...", xlarge: 2.6, showOnlyOnLarge: true,),
                  ),
                ),
              ],
            ),
          ),
          MyDivider(showOnlyOnLarge: true, padding: EdgeInsets.only(left: isSmallOrMedium ? 4 : 0, right: 10.0, top: 5),),
        ],
      ),
    );
  }



   Widget _buildTableTransaccion(List map, bool isSmallOrMedium){
   var tam = (map != null) ? map.length : 0;
   if(map == null)
    return Center(child: CircularProgressIndicator());

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
                                child: TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Listo", style: TextStyle(color: Utils.colorPrimary, fontSize: 16, fontWeight: FontWeight.bold))),
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
                  child: Center(child: Text("${(b["tipo"]["descripcion"] != 'Ajuste') ? b["tipo"]["descripcion"].toString().substring(0, b["tipo"]["descripcion"].toString().length > 10 ? 10 : b["tipo"]["descripcion"].toString().length) : Utils.toDouble(b["debito"]) != 0 ? b["tipo"]["descripcion"] + '(Debito)' : b["tipo"]["descripcion"] + '(Credito)'}", style: TextStyle(fontSize: 16)))
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



   return 
   isSmallOrMedium == false
   ?
   MyTable(
    //  isScrolled: false,
    showColorWhenImpar: true,
     columns: ["Fecha", "Entidad1", "Entidad2", "saldo inicial entidad #1", "saldo inicial entidad #2", "Tipo", "Monto", "saldo final entidad #1", "saldo final entidad #2", "notas"], 
     rows: map.map((e) => [
        e,
        e["created_at"] != null ? MyDate.datesToString(MyDate.toDateTime(e["created_at"]), MyDate.toDateTime(e["created_at"])) : '',
        // e["tipo"]["descripcion"],
        e["entidad1"]["descripcion"],
        e["entidad2"]["nombre"],
        "${Utils.toCurrency(e["entidad1_saldo_inicial"])}",
        "${Utils.toCurrency(e["entidad2_saldo_inicial"])}",
        "${(e["tipo"]["descripcion"] != 'Ajuste') ?e["tipo"]["descripcion"].toString().substring(0, e["tipo"]["descripcion"].toString().length > 10 ? 10 : e["tipo"]["descripcion"].toString().length) : e["debito"] != 0 ? e["tipo"]["descripcion"] + '(Debito)' : e["tipo"]["descripcion"] + '(Credito)'}",
        "${Utils.toDouble(e["debito"].toString()) > 0 ? Utils.toCurrency(e["debito"]) : Utils.toCurrency(e["credito"])}",
        "${Utils.toCurrency(e["entidad1_saldo_final"])}",
        "${Utils.toCurrency(e["entidad2_saldo_final"])}",
        "${e["nota"]}",
       ]
      ).toList()
    )
   :
   Padding(
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

 _dateChanged(date){
    setState((){
      _date = date;
      _fecha = MyDate.dateRangeToMyDate(date);
      _buscarTransacciones();
    });
  }

  _showDateTimeRangeCalendar(){
    _back(){
      Navigator.pop(context);
    }
    showMyModalBottomSheet(
      context: context, 
      myBottomSheet2: MyBottomSheet2(
        child: MyDateRangeDialog(
          date: _date,
          onCancel: _back,
          onOk: (date){
            _dateChanged(date);
            _back();
          },
        ), 
      height: 350
      )
    );
  }

  _bancaChanged(data){
    setState((){
        _banca = data;
        _buscarTransacciones();
      });
  }

  _usuarioChanged(data){
    setState((){
        _usuario = data;
        _buscarTransacciones();
      });
  }

  _tipoChanged(data){
    setState((){
        _tipo = data;
        _buscarTransacciones();
      });
  }

 _myFilterWidget(bool isSmallOrMedium){
   return MyFilterV2(
        padding: !isSmallOrMedium ? EdgeInsets.symmetric(horizontal: 15, vertical: 10) : null,
                    item: [
                      MyFilterItem(
                        hint: "${_banca != null ? 'Banca:  ' + _banca.descripcion: 'Banca...'}", 
                        data: listaBanca.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                        onChanged: (value){
                          _bancaChanged(value);
                        }
                      ),
                      MyFilterItem(
                        hint: "${_usuario != null ? 'Usuario:  ' + _usuario.usuario: 'Usuario...'}", 
                        data: listaUsuario.map((e) => MyFilterSubItem(child: e.usuario, value: e)).toList(),
                        onChanged: (value){
                          _usuarioChanged(value);
                        }
                      ),
                      MyFilterItem(
                        hint: "${_tipo != null ? 'Tipo:  ' + _tipo.descripcion : 'Tipo...'}", 
                        data: listaTipo.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                        onChanged: (value){
                          _tipoChanged(value);
                        }
                      ),
                    ],
                  );
    return MyFilter2(
            key: _myFilterKey,
            xlarge: 1.65,
            large: 2,
            medium: 1,
            small: 1,
            leading: 
            !isSmallOrMedium
            ?
            null
            :
            _selectedFilter.length == 0
            ?
            SizedBox.shrink()
            :
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                  //   var date = await showDatePicker(context: context, initialDate: _date.start, firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime(DateTime.now().year + 5));

                  // if(date != null)
                  //   setState(() {
                  //     _date = DateTimeRange(
                  //       start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00"),
                  //       end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59")
                  //     );
                  //     _buscarTransacciones();
                  //   });

                    _showDateTimeRangeCalendar();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blue[900]),
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(MyDate.dateRangeToNameOrString(_date), style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700)),),
                    ),
                  ),
                ),
                Container(height: 34, width: 1, color: Colors.grey),
              ],
            )
            ,
            widgetWhenNoFilter: Expanded(
              child: MyFilter(

                filterTitle: '',
                filterLeading: SizedBox.shrink(),
                leading: SizedBox.shrink(),
                value: _date,
                paddingContainer: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                onChanged: _dateChanged,
                showListNormalCortaLarga: 3,
              ),
            ),
            onChanged: (data){
              
              if(data.length == 0){
                setState(() {
                  _selectedFilter = [];
                  _banca = null;
                  _banco = null;
                  _usuario = null;
                  _tipo = null;
                  _entidad = null;
                  _buscarTransacciones();
                });
                return;
              }

              _banco = null;
              _banca = null;
              setState(() {
                _selectedFilter = data;
                print("TransaccionesScreen selectedFilterLength: ${_selectedFilter.length}");
                // _selectedFilter.forEach((element) {print("");})
                for (MyFilterSubData2 myFilterSubData2 in data) {
                  print("HistoricoVentas Filter2 for subData: ${myFilterSubData2.type} value: ${myFilterSubData2.value}");
                  if(myFilterSubData2.value is Banca){
                    _banca = myFilterSubData2.value;
                    _banco = null;
                  }
                  if(myFilterSubData2.value is Entidad){
                    _banco = myFilterSubData2.value;
                    _banca = null;
                  }
                  if(myFilterSubData2.value is Usuario)
                    _usuario = myFilterSubData2.value;
                  if(myFilterSubData2.value is Tipo)
                    _tipo = myFilterSubData2.value;
                }
                _buscarTransacciones();
              });
              
            },
            onDelete: (data){
              print("ONDelete transaccionesscreen: ${data.value}");
              setState(() {
                
                if(data.child == "Usuario")
                  _usuario = null;
                if(data.child == "Tipo")
                  _tipo = null;
                if(data.child == "Entidades"){
                  _banca = null;
                  _banco = null;
                }
                for (var element in data.data) {
                  if(element.data != null){
                    for (var item in element.data) {
                      _selectedFilter.remove(item);
                    }
                  }
                  _selectedFilter.remove(element);
                }
                _buscarTransacciones();
              });
            },
            onDeleteAll: (values){
              setState((){
                // _selectedFilter = [];
                  print("TransaccionesScreeen nofor delete filter: ${values.length}");
                for (var item in values) {
                  print("TransaccionesScreeen for delete filter: ${item.child}");
                  _selectedFilter.removeWhere((element) => element.type == item.child);
                  if(item.child is Banca)
                  _banca = null;
                  if(item.child is Grupo)
                    _banco = null;
                  if(item.child is Usuario)
                    _usuario = null;
                  if(item.child is Tipo)
                    _tipo = null;
                }
                _buscarTransacciones();
              });
            },
            data: listaFiltros,
            values: _selectedFilter
          );
  
  }

  dynamic _dateWidget(bool isSmallOrMedium){
    if(isSmallOrMedium)
    return MyCircleButton(
      child: MyDate.dateRangeToNameOrString(_date), 
      onTap: (){
        _back(){
          Navigator.pop(context);
        }
        showMyModalBottomSheet(
          context: context, 
          myBottomSheet2: MyBottomSheet2(
            child: MyDateRangeDialog(
              date: _date,
              onCancel: _back,
              onOk: (date){
                _dateChanged(date);
                _back();
              },
            ), 
          height: 350
          )
        );
      }
    );


    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: MyDropdown(title: null, 
            leading: Icon(Icons.date_range, size: 20, color: Colors.blue[700],),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            hint: "${MyDate.dateRangeToNameOrString(_date)}",
            onTap: (){
              showMyOverlayEntry(
                context: context,
                right: 20,
                builder: (context, overlay){
                  _cancel(){
                    overlay.remove();
                  }
                  return MyDateRangeDialog(date: _date, onCancel: _cancel, onOk: (date){_dateChanged(date); overlay.remove();},);
                }
              );
            },
          ),
        );
      }
    );
  }

  
 _subtitle(bool isSmallOrMedium){
    return
    isSmallOrMedium
    ?
    Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: MyCollapseChanged(
        child: FutureBuilder<void>(
          future: _futureData,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SizedBox.shrink();

            return Row(
              children: [
                _dateWidget(isSmallOrMedium),
                Expanded(child: _myFilterWidget(isSmallOrMedium)),
              ],
            );
          }
        )
        
          
        ,
      ),
    )
    :
    "Filtre y agrupe todas las ventas por fecha.";
  }



  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      transacciones: true,
      floatingActionButton: isSmallOrMedium ? FloatingActionButton(backgroundColor: Theme.of(context).primaryColor, child: Icon(Icons.add), onPressed: (){_goToAddTransacciones(isSmallOrMedium);},) : null,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Transacciones",
          subtitle: _subtitle(isSmallOrMedium),
          expandedHeight: isSmallOrMedium ? 105 : 85,
          actions: [
            // MySliverButton(
            //   title: "", 
            //   iconWhenSmallScreen: Icons.date_range,
            //   showOnlyOnSmall: true,
            //   onTap: () {
            //     _showDateTimeRangeCalendar();
            //   },
            // ),
            // MySliverButton(
            //   title: "title", 
            //   iconWhenSmallScreen: Icons.filter_alt_rounded,
            //   showOnlyOnSmall: true,
            //   onTap: () async {
            //     if(isSmallOrMedium){
            //       _myFilterKey.currentState.openFilter(context);
            //     }
            //   }
            // ),
            MySliverButton(
              showOnlyOnLarge: true,
              title: Container(
                width: 180,
                child: _dateWidget(isSmallOrMedium)
              ), 
              onTap: (){}
              ),
            MySliverButton(title: "Crear", iconWhenSmallScreen: Icons.save, onTap: (){_goToAddTransacciones(isSmallOrMedium);}, showOnlyOnLarge: true,),

          ],
        ), 
        sliver: StreamBuilder<List>(
          stream: _streamControllerTransacciones.stream,
          builder: (context, snapshot) {
            if(!snapshot.hasData && isSmallOrMedium)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
            if(snapshot.hasData && snapshot.data.length == 0 && isSmallOrMedium)
              return SliverFillRemaining(child: Center(child: MyEmpty(title: "No hay transacciones realizadas", titleButton: "No hay transacciones", icon: Icons.transfer_within_a_station,)));

            var widgets = [

                _myWebFilterScreen(isSmallOrMedium),
                MySubtitle(title: "${snapshot.data != null ? snapshot.data.length : 0} Filas", padding: EdgeInsets.only(bottom: 20, top: 25),),
                snapshot.hasData && snapshot.data.length == 0
                ?
                Center(child:  MyEmpty(title: "No hay transacciones realizadas", titleButton: "No hay transacciones", icon: Icons.transfer_within_a_station),)
                :
                _buildTableTransaccion(snapshot.data, isSmallOrMedium),
                SizedBox(height: 45,)
              ];

              return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index){
                  return widgets[index];
                },
                childCount: widgets.length
              ));

            // return SliverFillRemaining(child: MyScrollbar(child: Column(
            //   children: [

            //     _myWebFilterScreen(isSmallOrMedium),
            //     MySubtitle(title: "${snapshot.data != null ? snapshot.data.length : 0} Filas", padding: EdgeInsets.only(bottom: 20, top: 25),),
            //     snapshot.hasData && snapshot.data.length == 0
            //     ?
            //     Center(child:  MyEmpty(title: "No hay transacciones realizadas", titleButton: "No hay transacciones", icon: Icons.transfer_within_a_station),)
            //     :
            //     _buildTableTransaccion(snapshot.data, isSmallOrMedium),
            //     SizedBox(height: 45,)
            //   ],
            // )),);
          }
        )
      )
    );
    
  }
}