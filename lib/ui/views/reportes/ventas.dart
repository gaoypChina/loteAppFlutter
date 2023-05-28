import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/monitoreo.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/services/bluetoothchannel.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:loterias/core/services/ticketservice.dart';
import 'package:loterias/main.dart';
import 'package:loterias/ui/widgets/MyPadding.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mybutton.dart';
import 'package:loterias/ui/widgets/mycirclebutton.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mycontainerbutton.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/myfilterv2.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytabbar.dart';
import 'package:loterias/ui/widgets/mytext.dart';
import 'package:loterias/ui/widgets/showmymodalbottomsheet.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class VentasScreen extends StatefulWidget {
  final int idBancaReporteGeneral;
  VentasScreen({Key key, this.idBancaReporteGeneral}) : super(key: key);
  @override
  _VentasScreenState createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen>  with TickerProviderStateMixin{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
   DateTimeRange _date;
   var _fechaHoy = DateTime.now();
  StreamController<List<Banca>> _streamControllerBancas;
  StreamController<Map<String, dynamic>> _streamControllerTablas;
  List<Banca> listaBanca = [];
  int _indexBanca = 0;
  DateTime _fechaInicial = DateTime.now();
  DateTime _fechaFinal = DateTime.now();
  bool _cargando = false;
  bool _onCreate = true;
  bool _tienePermiso = false;
  Map<String, dynamic> datos;
  MyDate _fecha = MyDate.hoy;
  Banca _banca;
  DateFormat _dateFormat;
  bool _imprimirTicketsGanadores = false;
  bool _imprimirTotalesPorLoteria = false;
  bool _imprimirNumerosGanadores = false;
  TabController _tabController;
  bool _isSmallOrMedium = false;
  Future<void> _future;


  @override
  void initState() {
    // TODO: implement initState
    initializeDateFormatting();
    _tabController = TabController(length: 2, vsync: this);

    // _dateFormat = new DateFormat.yMMMMd(MyApp.myLocale.languageCode);
    _dateFormat = new DateFormat.yMMMMEEEEd(MyApp.myLocale.languageCode);
    _date = MyDate.getTodayDateRange();
    _confirmarTienePermiso();
    _streamControllerBancas = BehaviorSubject();
    _streamControllerTablas = BehaviorSubject();
    _future = _ventas();
    super.initState();
    // SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.landscapeRight,
    //     DeviceOrientation.landscapeLeft,
    // ]);
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

  _filtrarFecha(){
    print("_filtrarFecha: ${_fecha.toString()}");
    switch (_fecha) {
      case MyDate.hoy:
        var fechas = MyDate.getHoy();
        _fechaInicial = fechas[0];
        _fechaFinal = fechas[1];
        break;
      case MyDate.ayer:
        var fechas = MyDate.getAyer();
        _fechaInicial = fechas[0];
        _fechaFinal = fechas[1];
        break;
      case MyDate.estaSemana:
        var fechas = MyDate.getEstaSemana();
        _fechaInicial = fechas[0];
        _fechaFinal = fechas[1];
        break;
      case MyDate.laSemanaPasada:
        var fechas = MyDate.getSemanaPasada();
        _fechaInicial = fechas[0];
        _fechaFinal = fechas[1];
        break;
      case MyDate.ultimos2Dias:
        var fechas = MyDate.getUltimos2Dias();
        _fechaInicial = fechas[0];
        _fechaFinal = fechas[1];
        break;
      case MyDate.esteMes:
        var fechas = MyDate.getEsteMes();
        _fechaInicial = fechas[0];
        _fechaFinal = fechas[1];
        break;
      default:
        
    }
  }


  _ventas() async {
    try{
      // setState(() => _cargando = true);
      _streamControllerTablas.add(null);
      _filtrarFecha();
      int idBanca = await getIdBanca();
      print("_ventas getIdBanca: $idBanca");
      datos = await ReporteService.ventas(fecha: _date.start, fechaFinal: _date.end, idBanca: idBanca, context: context,);
      print("_ventas fechaInicial: ${datos["bancas"]}");
      if(_onCreate){
        listaBanca = datos["bancas"]  != null ? datos["bancas"].map<Banca>((json) => Banca.fromMap(json)).toList() : [];
        _streamControllerBancas.add(listaBanca);
        _seleccionarBancaPertenecienteAUsuario();
        _onCreate = false;
      }
      _streamControllerTablas.add(datos);
      // setState(() => _cargando = false);
    } on Exception catch(e){
      _streamControllerTablas.add({});
      // setState(() => _cargando = false);
    }
  }

  getIdBanca() async {
    if(_tienePermiso && listaBanca.length > 0)
      return (_banca != null) ? _banca.id : 0;
    else
      return widget.idBancaReporteGeneral != null ? widget.idBancaReporteGeneral : await Db.idBanca();
  }

  _confirmarTienePermiso() async {
   _tienePermiso = await Db.existePermiso("Jugar como cualquier banca");
  }

  _seleccionarBancaPertenecienteAUsuario() async {
  var bancaMap = await Db.getBanca();
  // Banca banca = (bancaMap != null) ? Banca.fromMap(bancaMap) : null;
  // if(banca != null && listaBanca != null){
  //   int idx = listaBanca.indexWhere((b) => b.id == banca.id);
  //   setState(() => _indexBanca = (idx != -1) ? idx : 0);
  // }else{
  //   setState(() =>_indexBanca = 0);
  // }
  // 
   Banca banca = (bancaMap != null) ? Banca.fromMap(bancaMap) : null;
  if(banca != null && listaBanca != null){
    var b = listaBanca.length == 0 ? null : widget.idBancaReporteGeneral != null ? listaBanca.firstWhere((b) => b.id == widget.idBancaReporteGeneral, orElse: () => null) : listaBanca.firstWhere((b) => b.id == banca.id, orElse: () => null);
    setState(() => _banca = (b != null) ? b : listaBanca.length > 0 ? listaBanca[0] : null);
  }else{
    if(_tienePermiso){
      if(listaBanca.length > 0)
        setState(() => _banca = listaBanca[0]);
    }
    else
      setState(() =>_banca = null);
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
                  child: Center(child: Text("${Utils.toCurrency(b["ventas"])}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${Utils.toCurrency(b["comisiones"])}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${Utils.toCurrency(b["premios"])}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: (b["neto"] >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
                  child: Center(child: Text("${Utils.toCurrency(b["neto"])}", style: TextStyle(fontSize: 16)))
                  // Center(child: Text("${b["neto"]}", style: TextStyle(fontSize: 16)))
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
                  child: Center(child: Text("${Utils.toCurrency(b["montoAPagar"])}", style: TextStyle(fontSize: 16)))
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
                // Expanded(child: Center(child: Text("${map["balanceHastaLaFecha"]}", style: TextStyle(fontSize: 20)),),),
                Expanded(
                  child: Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: (map["balanceHastaLaFecha"] >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
                  child: Center(child: Text("${Utils.toCurrency(map["balanceHastaLaFecha"])}", style: TextStyle(fontSize: 16)))
                ),
                ),
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
                Expanded(child: Center(child: Text("${Utils.toCurrency(map["ventas"])}", style: TextStyle(fontSize: 20)),),),
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
                Expanded(child: Center(child: Text("Recargas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),),
                Expanded(child: Center(child: Text("${Utils.toCurrency(map["recargas"])}", style: TextStyle(fontSize: 20)),),),
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
                Expanded(child: Center(child: Text("${Utils.toCurrency(map["comisiones"])}", style: TextStyle(fontSize: 20)),),),
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
                Expanded(child: Center(child: Text("${Utils.toCurrency(map["descuentos"])}", style: TextStyle(fontSize: 20)),),),
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
                Expanded(child: Center(child: Text("${Utils.toCurrency(map["premios"])}", style: TextStyle(fontSize: 20)),),),
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
                // Expanded(child: Center(child: Text("${map["neto"]}", style: TextStyle(fontSize: 20)),),),
                Expanded(
                  child: Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: (map["neto"] >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
                  child: Center(child: Text("${Utils.toCurrency(map["neto"])}", style: TextStyle(fontSize: 16)))
                  )
                )
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
                // Expanded(child: Center(child: Text("${map["balanceActual"]}", style: TextStyle(fontSize: 20)),),),
                Expanded(
                  child: Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: (map["balanceActual"] >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
                  child: Center(child: Text("${Utils.toCurrency(map["balanceActual"])}", style: TextStyle(fontSize: 16)))
                  )
                )
              ],
            )
          ]
        ),
      ],
    );
  }


  _screen1(){
    return Column(
          children: <Widget>[
            Wrap(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 20,
              children: <Widget>[
                Padding(
                  // padding: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 2.0, left: 8.0),
                  child: Text("Desde", style: TextStyle(fontSize: 20),),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0, 
                    backgroundColor: Colors.transparent, 
                    shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
                  ),
                  child: Text("${_fechaInicial.year}-${_fechaInicial.month}-${_fechaInicial.day}", style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    DateTime fecha = await showDatePicker(context: context, initialDate: _fechaInicial, firstDate: DateTime(2000), lastDate: DateTime(2100));
                    setState(() => _fechaInicial = (fecha != null) ? fecha : _fechaInicial);
                  },
                ),
                Padding(
                  // padding: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 2.0, left: 8.0),
                  child: Text("Hasta", style: TextStyle(fontSize: 20),),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0, 
                    backgroundColor: Colors.transparent, 
                    shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
                  ),
                  child: Text("${_fechaFinal.year}-${_fechaFinal.month}-${_fechaFinal.day}", style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    DateTime fecha = await showDatePicker(context: context, initialDate: _fechaFinal, firstDate: DateTime(2000), lastDate: DateTime(2100));
                    setState(() => _fechaFinal = (fecha != null) ? fecha : _fechaFinal);
                  },
                ),
                Visibility(
                  visible: _tienePermiso,
                  child: StreamBuilder<List<Banca>>(
                    stream: _streamControllerBancas.stream,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return DropdownButton<Banca>(
                          value: _banca,
                          items: listaBanca.map((b) => DropdownMenuItem(
                            value: b,
                            child: Text("${b.descripcion}"),
                          )).toList(),
                          onChanged: (Banca banca){
                              setState(() => _banca = banca);
                          },
                        );
                      }

                      return DropdownButton(value: "No hay datos", items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], onChanged: null);
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0, 
                    backgroundColor: Utils.fromHex("#e4e6e8"),
                  ),
                  child: Text("Buscar", style: TextStyle(color: Utils.colorPrimary),),
                  onPressed: (){
                    _ventas();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0, 
                    backgroundColor: Utils.colorInfo,
                  ),
                  child: Text("Imprimir",),
                  onPressed: (){
                    // BluetoothChannel.printCuadre(datos);
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
        );
      
  }

  _getListaFiltro(){
    var mostrarFiltro = false;
    List<MyFilterData> lista = [];
    if(_fecha == null){
      

        

        if(_fecha == null)
          lista.add(MyFilterData(
            text: MyDate.datesToString(_fechaInicial, _fechaFinal), 
            value: MyDate.datesToString(_fechaInicial, _fechaFinal), 
            color: null,
            onChanged: (data){
              setState(() {
                _fecha = MyDate.hoy;
                _ventas();
              });
            })
          );

       
    }else
      lista = [];
    
    return lista;
  }

  _bancaChanged(banca){
    setState((){
        _banca = banca;
        _ventas();
      });
  }

  _showBottomSheetBanca() async {
    if(_tienePermiso == false)
      return;

    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context){
        _back(){
              Navigator.pop(context);
            }
            bancaChanged(banca){
              setState(() => _banca = banca);
              _bancaChanged(banca);
              _back();
            }
        return Container(
              height: MediaQuery.of(context).size.height / 1.3,
              child: Column(
                children: [
                  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaBanca.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          value: _banca == listaBanca[index],
                          onChanged: (data){
                            bancaChanged(listaBanca[index]);
                          },
                          title: Text("${listaBanca[index].descripcion}"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
        // Container(
        //   height: MediaQuery.of(context).size.height / 2,
        //   child: Column(

        //         children: [
        //           Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
        //             ),
        //           Expanded(
        //             child: SingleChildScrollView(child: Column(children: [
                      
        //               // Text("Seleccionar loteria", style: TextStyle(fontSize: 18),),
        //               // Icon(Icons.stop_circle)
        //               // Icon(UniconsLine.stop_circle)
        //               Column(
        //                               children: listaLoteria.map((e) => Padding(
        //                                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //                                 child: GestureDetector(
        //                                   onTap: (){
        //                                     _closeAndReturnData(e);
        //                                   },
        //                                   child: Row(
        //                                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                                     children: [
        //                                     Row(
        //                                       children: [
        //                                         Container(
        //                                           padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
        //                                       decoration: BoxDecoration(
        //                                         border: Border.all(color: Utils.colorPrimary),
        //                                         borderRadius: BorderRadius.circular(18)
        //                                       ),
        //                                       child: Center(child: Text(e.descripcion.substring(0, 1), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Utils.colorPrimary),)),
        //                                     ),
        //                                     Padding(
        //                                       padding: const EdgeInsets.symmetric(horizontal: 14.0),
        //                                       // child: Text("${e.descripcion}", style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.2)),
        //                                       child: Text("${e.descripcion}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0.2)),
        //                                     ),
        //                                       ],
        //                                     ),
        //                                     Expanded(
        //                                       child: GestureDetector(
        //                                         onTap: (){
        //                                           _closeAndReturnData(e);
        //                                         },
        //                                         child: Container(
        //                                           color: Colors.transparent,
        //                                           child: Align(
        //                                             alignment: Alignment.centerRight,
        //                                             child: MyContainerRadio(selected: e == _loteria, onTap: (data){
        //                                                 _closeAndReturnData(e);
        //                                             }),
        //                                           ),
        //                                         ),
        //                                       ),
        //                                     )
        //                                   ],),
        //                                 ),
        //                               )).toList(),
        //                             )
        //               // ValueListenableBuilder(
        //               //             valueListenable: groupValue,
        //               //             builder: (_, value, __) {
        //               //               return Column(
        //               //                 children: listaLoteria.map((e) => Padding(
        //               //                   padding: const EdgeInsets.all(8.0),
        //               //                   child: Row(
        //               //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               //                     children: [
        //               //                     Text("${e.descripcion}", style: TextStyle(fontFamily: "GoogleSans")),
        //               //                     Icon(Icons.stop_circle, color: Utils.colorPrimary, size: 28,)
        //               //                   ],),
        //               //                 )).toList(),
        //               //               );
        //               //             }
        //               //           ),
                      
        //             ],),),
        //           ),
        //         ],
        //       )
        // );
      
      }
  );
    // if(data != null)
    //   setState((){
    //     _loteria = data;
    //     _filtrar();
    //   });
  }

  _filtroScreen() async {
    var fechaInicial = _date.start;
    var fechaFinal = _date.end;
    var fecha = _fecha;
    var data = await showDialog(context: context, 
    builder: (context){
      _back({sendData = false}){
        var map;
        if(sendData)
          map = {
            "fecha" : fecha,
            "fechaInicial" : fechaInicial,
            "fechaFinal" : fechaFinal,
          };

        Navigator.pop(context, map);
      }
  
      return StatefulBuilder(
        builder: (context, setState) {
          _fechaChanged(MyDate tmpFecha){
    var tmpFechaInicial;
    var tmpFechaFinal;
    switch (tmpFecha) {
      case MyDate.hoy:
        var fechas = MyDate.getHoy();
        tmpFechaInicial = fechas[0];
        tmpFechaFinal = fechas[1];
        break;
      case MyDate.ayer:
        var fechas = MyDate.getAyer();
        tmpFechaInicial = fechas[0];
        tmpFechaFinal = fechas[1];
        break;
      case MyDate.estaSemana:
        var fechas = MyDate.getEstaSemana();
        tmpFechaInicial = fechas[0];
        tmpFechaFinal = fechas[1];
        break;
       case MyDate.ultimos2Dias:
        var fechas = MyDate.getUltimos2Dias();
        tmpFechaInicial = fechas[0];
        tmpFechaFinal = fechas[1];
        break;
      case MyDate.esteMes:
        var fechas = MyDate.getEsteMes();
        tmpFechaInicial = fechas[0];
        tmpFechaFinal = fechas[1];
        break;
      default:
        var fechas = MyDate.getSemanaPasada();
        tmpFechaInicial = fechas[0];
        tmpFechaFinal = fechas[1];
     
    }

    setState(() {
      fecha = tmpFecha;
      fechaInicial = tmpFechaInicial;
      fechaFinal = tmpFechaFinal;
    });
  }
 

          _seleccionarFechaSencillaSiPertenece(){
              if(MyDate.isHoy(fechaInicial, fechaFinal))
                fecha = MyDate.hoy;
              else if(MyDate.isAyer(fechaInicial, fechaFinal))
                fecha = MyDate.ayer;
              else if(MyDate.isEstaSemana(fechaInicial, fechaFinal))
                fecha = MyDate.estaSemana;
              else if(MyDate.isSemanaPasada(fechaInicial, fechaFinal))
                fecha = MyDate.laSemanaPasada;
              else if(MyDate.isUltimo2Dias(fechaInicial, fechaFinal))
                fecha = MyDate.ultimos2Dias;
              else if(MyDate.isEsteMes(fechaInicial, fechaFinal))
                fecha = MyDate.esteMes;
              else
                fecha = null;

            }

          _fechaInicialChanged() async {
            DateTime fecha = await showDatePicker(context: context, initialDate: fechaInicial, firstDate: DateTime(2000), lastDate: DateTime(2100));
            if(fecha == null)
              return;
            
            if(fechaInicial != fecha)
              setState(() {
                fechaInicial = (fecha != null) ? fecha : fechaInicial;
                _seleccionarFechaSencillaSiPertenece();
              });

          }

          _fechaFinalChanged() async {
            
            DateTime fecha = await showDatePicker(context: context, initialDate: fechaFinal, firstDate: DateTime(2000), lastDate: DateTime(2100));
            if(fecha == null)
              return;
            
            if(fechaFinal != fecha)
              setState(() {
                fechaFinal = (fecha != null) ? DateTime.parse("${fecha.year}-${Utils.toDosDigitos(fecha.month.toString())}-${Utils.toDosDigitos(fecha.day.toString())} 23:59:59") : fechaFinal;
                _seleccionarFechaSencillaSiPertenece();
              });

          }



          return AlertDialog(
            title: Text("Filtrar por fecha"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Text("Fecha", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
                  //     ),
                      // Row(
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Icon(Icons.date_range, size: 24, color: Colors.grey,),
                      //       ),
                      //       Expanded(
                      //         child: Padding(
                      //           padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      //           child: SingleChildScrollView(
                      //             scrollDirection: Axis.horizontal,
                      //             child: 
                      //             Row(
                      //               children: MyDate.listaFechaLarga.map((e) =>  Padding(
                      //                 padding: const EdgeInsets.all(4.0),
                      //                 child: MyContainerButton(
                      //                   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      //                   selected: e[0] == fecha, data: [e[0], e[1]], onTap: (data){
                      //                     print("_filtroScreen fecha: ${e[1]}");
                      //                     _fechaChanged(e[0]);
                      //                 },),
                      //               )).toList(),
                      //             ),
                                  
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      
                        MyFilter(
                          value: _date,
                          paddingContainer: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          onChanged: (date){
                            setState((){
                              _date = date;
                              _fecha = MyDate.dateRangeToMyDate(date);
                              fechaInicial = _date.start;
                              fechaFinal = _date.end;
                            });
                          },
                        ),
                        ListTile(
                          dense: true,
                          leading: SizedBox(),
                          onTap: _fechaInicialChanged,
                          title: Text("${_dateFormat != null ? _dateFormat.format(fechaInicial) : DateFormat('EEE, MMM d yyy').format(fechaFinal)}"),
                        ),
                        ListTile(
                          dense: true,
                          leading: SizedBox(),
                          onTap: _fechaFinalChanged,
                          title: Text("${_dateFormat != null ? _dateFormat.format(fechaFinal) : DateFormat('EEE, MMM d yyy').format(fechaFinal)}"),
                        ),
                        
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: _back, child: Text("Cancelar")),
              TextButton(onPressed: (){_back(sendData: true);}, child: Text("Filtrar")),
            ],
          );
        }
      );
    });
    if(data == null)
      return;

    if(_fechaInicial == data["fechaInicial"] && _fechaFinal == data["fechaFinal"] && _fecha == data["fecha"])
      return;

    setState(() {
      _date = DateTimeRange(start: data["fechaInicial"], end: data["fechaFinal"]);
      _fecha = data["fecha"];

      _ventas();
    });
  }

 _deleteAllFilter(){
    setState(() {
      if(_fecha == null){
        _fecha = MyDate.hoy;
        _ventas();
      }
    });
  }

  _printCuadre(){
    BluetoothChannel.printCuadre(map: datos, imprimirNumerosGanadores: _imprimirNumerosGanadores, imprimirTotalesPorLoteria: _imprimirTotalesPorLoteria, imprimirTicketsGanadores: _imprimirTicketsGanadores, imprimirReporteResumido: esVentanaResumida());
  }

  esVentanaResumida(){
    return _tabController.index == 0;
  }

  _imprimirTicketsGanadoresChanged(data){
    setState(() => _imprimirTicketsGanadores = data);
  }
  _imprimirTotalesPorLoteriaChanged(data){
    setState(() => _imprimirTotalesPorLoteria = data);
  }
  _imprimirNumerosGanadoresChanged(data){
    setState(() => _imprimirNumerosGanadores = data);
  }

  _showDialogImprimir(){
    showDialog(context: context, builder: (context){
      return StatefulBuilder(
        builder: (context, setState) {
          imprimirTicketsGanadoresChanged(data){
            setState(() => _imprimirTicketsGanadores = data);
            _imprimirTicketsGanadoresChanged(data);
          }
          imprimirTotalesPorLoteriaChanged(data){
            setState(() => _imprimirTotalesPorLoteria = data);
            _imprimirTotalesPorLoteriaChanged(data);
          }
          imprimirNumerosGanadoresChanged(data){
            setState(() => _imprimirNumerosGanadores = data);
            _imprimirNumerosGanadoresChanged(data);
          }
          _back({imprimir = false}){
            if(imprimir)
              _printCuadre();

            Navigator.pop(context);
          }
          return AlertDialog(
            title: Text("Imprimir"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.print_rounded),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Imprimir tickets ganadores", style: TextStyle(fontSize: 12)),
                      ),
                      Expanded(child: Align(alignment: Alignment.centerRight, child: Switch(activeColor: Utils.colorPrimary, value: _imprimirTicketsGanadores, onChanged: imprimirTicketsGanadoresChanged)))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.print_rounded),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Imprimir totales por loteria", style: TextStyle(fontSize: 12)),
                      ),
                      Expanded(child: Align(alignment: Alignment.centerRight, child:  Switch(activeColor: Utils.colorPrimary, value: _imprimirTotalesPorLoteria, onChanged: imprimirTotalesPorLoteriaChanged),))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.print_rounded),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Imprimir numeros ganadores", style: TextStyle(fontSize: 12)),
                      ),
                      Expanded(child: Align(alignment: Alignment.centerRight, child:  Switch(activeColor: Utils.colorPrimary, value: _imprimirNumerosGanadores, onChanged: imprimirNumerosGanadoresChanged),))
                    ],
                  ),
                  // ListTile(
                  //   dense: true,
                  //   leading: Icon(Icons.print_rounded),
                  //   title: Text("Imprimir tickets ganadores"),
                  //   trailing: Switch(activeColor: Utils.colorPrimary, value: _imprimirTicketsGanadores, onChanged: imprimirTicketsGanadoresChanged),
                  // ),
                  // ListTile(
                  //   dense: true,
                  //   leading: Icon(Icons.print_rounded),
                  //   title: Text("Imprimir numeros ganadores"),
                  //   trailing: Switch(activeColor: Utils.colorPrimary, value: _imprimirTicketsGanadores, onChanged: imprimirTicketsGanadoresChanged),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //   child: Divider(thickness: 1,),
                  // ),
                  // ListTile(
                  //   dense: true,
                  //   leading: Icon(Icons.print_rounded),
                  //   title: Text("Imprimir totales por loteria"),
                  //   trailing: Switch(activeColor: Utils.colorPrimary, value: _imprimirTotalesPorLoteria, onChanged: imprimirTotalesPorLoteriaChanged),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //   child: Divider(thickness: 1,),
                  // ),
                  // ListTile(
                  //   dense: true,
                  //   leading: Icon(Icons.print_rounded),
                  //   title: Text("Imprimir numeros ganadores"),
                  //   trailing: Switch(activeColor: Utils.colorPrimary, value: _imprimirNumerosGanadores, onChanged: imprimirNumerosGanadoresChanged),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //   child: Divider(thickness: 1,),
                  // ),
                ],
              ),
              
            ),
            actions: [
              TextButton(onPressed: _back, child: Text("Cancelar")),
              TextButton(onPressed: (){_back(imprimir: true);}, child: Text("Imprimir"))
            ],
          );
        }
      );
    });
  }

  _titleScreen(isSmallOrMedium){
    Widget titleWidget = StreamBuilder(
      stream: _streamControllerBancas.stream,
      builder: (context, snapshot){
        return GestureDetector(
          onTap: _showBottomSheetBanca,
          child: Row(
            children: [
              Text("${_banca != null ? _banca.descripcion : 'No hay banca'}", style: TextStyle(color: Colors.black),),
              Visibility(visible: _tienePermiso, child: Icon(Icons.arrow_drop_down, color: Colors.black54,))
            ],
          ),
        );
      },
    );

    if(isSmallOrMedium)
      titleWidget = MyCollapseChanged(child: titleWidget, actionWhenCollapse: MyCollapseAction.nothing,);

    return titleWidget;
  }

  _subtitleOld(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text("Fecha", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
        // ),
        _getListaFiltro().length == 0
        ?
        Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                // child: Icon(Icons.date_range, size: 35, color: Colors.grey,),
                child: Icon(Icons.date_range, color: Colors.grey,),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: 
                    Row(
                      children: MyDate.listaFechaLarga.map((e) =>  Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: MyContainerButton(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                          selected: e[0] == _fecha, data: [e[0], e[1]], onTap: (data){
                          setState((){
                            print("_build fecha: ${e[1]}");
                            _fecha = e[0];
                            _ventas();
                          });
                        },),
                      )).toList(),
                    )
                  ),
                ),
              ),
            ],
          )
        :
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text("Hola")
          // MyFilter(title: "", data: _getListaFiltro(), onDeleteAll: _deleteAllFilter,),
        ),
      ],
    );
  }

  _dateChanged(date){
    setState((){
      _date = date;
      _fecha = MyDate.dateRangeToMyDate(date);
      _ventas();
    });
  }


  // _subtitle(bool isSmallOrMedium){
  //   return 
  //   isSmallOrMedium == false
  //   ?
  //   "Maneje todas sus ventas y filtrelas por fecha"
  //   :
  //   MyCollapseChanged(
  //     child: MyFilter(
  //       value: _date,
  //       paddingContainer: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
  //       onChanged: _dateChanged,
  //     ),
  //   );
  //   // MyFilter(
  //   //   showListNormalCortaLarga: 3,
  //   //   leading: null,
  //   //   paddingContainer: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
  //   //   contentPadding: EdgeInsets.symmetric(vertical: 2,),
  //   //   value: _date,
  //   //   onChanged: (value){
  //   //     setState(() => _date = value);
  //   //   },
  //   //   onDeleteAll: (){},
  //   // );
  //   Container(
  //     child: 
  //       // Padding(
  //       //   padding: const EdgeInsets.all(8.0),
  //       //   child: Text("Fecha", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
  //       // ),
  //       _getListaFiltro().length == 0
  //       ?
  //       Row(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               // child: Icon(Icons.date_range, size: 35, color: Colors.grey,),
  //               child: Icon(Icons.date_range, color: Colors.grey,),
  //             ),
  //             Expanded(
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
  //                 child: SingleChildScrollView(
  //                   scrollDirection: Axis.horizontal,
  //                   child: 
  //                   Row(
  //                     children: MyDate.listaFechaLarga.map((e) =>  Padding(
  //                       padding: const EdgeInsets.all(4.0),
  //                       child: MyContainerButton(
  //                         padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
  //                         selected: e[0] == _fecha, data: [e[0], e[1]], onTap: (data){
  //                         setState((){
  //                           print("_build fecha: ${e[1]}");
  //                           _fecha = e[0];
  //                           _ventas();
  //                         });
  //                       },),
  //                     )).toList(),
  //                   )
  //                 ),
  //               ),
  //             ),
  //           ],
  //         )
  //       :
  //       Padding(
  //         padding: const EdgeInsets.only(bottom: 8.0),
  //         child:Text("h")
  //         //  MyFilter(title: "", data: _getListaFiltro(), onDeleteAll: _deleteAllFilter,),
  //       ),
      
  //   );
  // }

  _subtitle(){
    return
    esPantallaPequena()
    ?
    ""
    :
    "Verifique las ventas resumidas del día seleccionado y maneje sus bancas";
  }

  Widget _filtroPantallaPequena(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SizedBox.shrink();

            return Row(
              children: [
                Visibility(visible: esPantallaPequena(), child: _dateWidget()),
                Expanded(
                  child: MyFilterV2(
                    item: [
                      MyFilterItem(
                        visible: _tienePermiso,
                        hint: "${_banca != null ? 'Banca: ' + Utils.limitarCaracteres(_banca.descripcion, 35): 'Banca...'}", 
                        data: listaBanca.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                        onChanged: (value){
                          _bancaChanged(value);
                        }
                      ),
                      
                    ],
                  ),
                ),
              ],
            );
          }
        ),
    );
  }

  dynamic _dateWidget(){
    if(esPantallaPequena())
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
              isSimpleDialog: true,
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

  

    return Container(
      width: 180,
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: MyDropdown(
              title: null, 
              leading: Icon(Icons.date_range, size: 20, color: Colors.blue[700],),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
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
      ),
    );
              
  }

  _ventanaDetallada(){
    return StreamBuilder<Map<String, dynamic>>(
      stream: _streamControllerTablas.stream,
      builder: (context, snapshot) {
        if(snapshot.data == null)
          return Center(child: CircularProgressIndicator());

        if(snapshot.data.isEmpty)
          return Center(child: MyEmpty(title: "No hay datos", titleButton: "No hay datos", icon: Icons.error,));

        return SingleChildScrollView(
          child: Column(
            children: [Padding(
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
          ]),
        );
      }
    );
                   
  }

  
  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    _isSmallOrMedium = isSmallOrMedium;
    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      showDrawerOnSmallOrMedium: false,
      ventas: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          expandedHeight: isSmallOrMedium ? 110 : 85,
          // title: _titleScreen(isSmallOrMedium),
          title: "Ventas",
          subtitle: _subtitle(),
          floating: isSmallOrMedium,
          actions: [
            MySliverButton(
              showOnlyOnLarge: true,
              title: Container(
                width: 115,
                child: 
                MyDropdown(
                        isFlat: true,
                        title: null, 
                        leading: Icon(Icons.date_range, size: 20, color: Colors.blue[700],),
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        textColor: Colors.grey[600],
                        color: Colors.grey[600],
                        hint: "Imprimir",
                        onTap: _showDialogImprimir,
                      )
              ), 
              onTap: (){}
            ),
            MySliverButton(
              showOnlyOnLarge: true,
              title: Container(
                width: 180,
                child: Builder(
                  builder: (context) {
                    return MyDropdown(title: null, 
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                      hint: "${MyDate.dateRangeToNameOrString(_date)}",
                      onTap: (){
                        showMyOverlayEntry(
                          context: context,
                          right: 2,
                          builder: (context, overlay){
                            _cancel(){
                              overlay.remove();
                            }
                            return MyDateRangeDialog(date: _date, onCancel: _cancel, onOk: (date){_dateChanged(date); overlay.remove();},);
                          }
                        );
                      },
                    );
                  }
                ),
              ), 
              onTap: (){}
              ),
            
            // MySliverButton(title: null, onTap: _filtroScreen, iconWhenSmallScreen: Icons.date_range, showOnlyOnSmall: true),
            MySliverButton(title: null, onTap: _showDialogImprimir, iconWhenSmallScreen: Icons.print, showOnlyOnSmall: true,),
          ],
        ), 
        sliver: 
        // StreamBuilder<Map<String, dynamic>>(
        //     stream: _streamControllerTablas.stream,
        //     builder: (context, snapshot) {
        //       if(snapshot.data == null)
        //         return SliverFillRemaining(
        //           child: Center(child: CircularProgressIndicator()),
        //         );

        //       if(snapshot.data.isEmpty)
        //         return SliverFillRemaining(
        //           child: Center(child: MyEmpty(title: "No hay datos", titleButton: "No hay datos", icon: Icons.error,)),
        //         );
              
        //       // return SliverList(delegate: SliverChildListDelegate([
               
        //       //           // _sencilloWidget(),
        //       //           // _ventanaSencilla(),
        //       //           _ventanaDetallada(snapshot)
                    
                  
        //       // ]));
        //       return SliverList(delegate: SliverChildListDelegate(_ventanaDetallada(snapshot)));
        //     }
        //   )

        SliverList(delegate: SliverChildListDelegate([
                  MyPadding(child: MyTabBar(controller: _tabController, tabs: ["Resumido", "Detallado"], indicator: _lineasTabBarWidget(),)),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: _filtroPantallaPequena(),
                  ),
                  // FutureBuilder<void>(
                  //   future: _futureCargo,
                  //   builder: (context, snapshot) {
                  //     if(snapshot.connectionState != ConnectionState.done)
                  //       return SizedBox.shrink();

                  //     return _myFilterWidget();
                  //   }
                  // )
                ])),
                withScroll: false,
          sliverFillRemaining: SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: [
            _ventanaResumida(),
            Padding(
              padding: EdgeInsets.only(right: esPantallaPequena() ? 0.0 : 16.0),
              child: SingleChildScrollView(
                child: _ventanaDetallada(),
              ),
            ),
          ]),
        ),
      )
    );
    
  }

  Widget _ventanaResumida(){
    return MyPadding(
      child: StreamBuilder<Map<String, dynamic>>(
        stream: _streamControllerTablas.stream,
        builder: (context, snapshot) {
    
           if(snapshot.data == null)
            return Center(child: CircularProgressIndicator());
    
          if(snapshot.data.isEmpty)
            return Center(child: MyEmpty(title: "No hay datos", titleButton: "No hay datos", icon: Icons.error,));
    
    
          var datos = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 MyResizedContainer(
                  medium: 1,
                  large: 2.8,
                  xlarge: 2.8,
                  child: MySubtitle(title: "Resumen", fontWeight: FontWeight.bold, fontSize: 16, padding: EdgeInsets.only(top: esPantallaPequena() ? 15 : 0.0, bottom: 20.0),)),
                MyResizedContainer(
                  medium: 1,
                  large: 2.8,
                  xlarge: 2.8,
                  child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.grey[400]),
                          borderRadius: BorderRadius.circular(10.0),
                          // color: Colors.grey[100]
                        ),
                        child: Column(children: [
                          ListTile(
                            title: MyText(title: "En fondo", fontSize: 16,),
                            trailing: Text("${Utils.toCurrency(datos["balanceHastaLaFecha"])}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: datos["balanceHastaLaFecha"] >= 0 ? Theme.of(context).primaryColorDark : Utils.colorRosa),)
                            // _contenedor(
                            //   child: Text("${Utils.toCurrency(datos["balance"])}"),
                            //   color: Theme.of(context).primaryColor.withOpacity(0.5)
                            // )
                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            //   decoration: BoxDecoration(
                            //     color: Theme.of(context).primaryColor.withOpacity(0.5),
                            //     borderRadius: BorderRadius.circular(5)
                            //   ),
                            //   child: Text("${Utils.toCurrency(datos["balance"])}")),
                          ),
                          Divider(color: Colors.grey[400],),
                          ListTile(
                            title: MyText(title: "Vendido", fontSize: 16,),
                            // trailing: _contenedor(child: Text("${Utils.toCurrency(datos["ventas"])}"), color: Theme.of(context).primaryColor.withOpacity(0.5)),
                            trailing: Text("${Utils.toCurrency(datos["ventas"])}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.toDouble(datos["ventas"]) >= 0 ? null : Utils.colorRosa),),
                          ),
                          ListTile(
                            title: MyText(title: "Recargado", fontSize: 16,),
                            // trailing: _contenedor(child: Text("${Utils.toCurrency(datos["ventas"])}"), color: Theme.of(context).primaryColor.withOpacity(0.5)),
                            trailing: Text("${Utils.toCurrency(datos["recargas"])}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ),
                          
                          ListTile(
                            title: MyText(title: "Porciento ganado", fontSize: 16,),
                            // trailing: _contenedor(child: Text("${Utils.toCurrency(datos["comisiones"])}"), color: Colors.red),
                            trailing: Text("${Utils.toCurrency(datos["comisiones"])}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink)),
                          ),
                          ListTile(
                            title: MyText(title: "Descontado", fontSize: 16,),
                            // trailing: _contenedor(child: Text("${Utils.toCurrency(datos["comisiones"])}"), color: Colors.red),
                            trailing: Text("${Utils.toCurrency(datos["descuentos"])}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink)),
                          ),
                          ListTile(
                            title: MyText(title: "Sacado", fontSize: 16),
                            // trailing: _contenedor(child: Text("${Utils.toCurrency(datos["premios"])}"), color: Colors.red),
                            trailing: Text("${Utils.toCurrency(datos["premios"])}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink)),
                          ),
                          Divider(color: Colors.grey[400],),
                          ListTile(
                            title: MyText(title: "Total", fontSize: 16, fontWeight: FontWeight.bold,),
                            // trailing: _contenedor(child: Text("${Utils.toCurrency(datos["neto"])}"), color: Theme.of(context).primaryColor.withOpacity(0.5)),
                            trailing: Text("${Utils.toCurrency(datos["neto"])}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.toDouble(datos["neto"]) >= 0 ? Colors.green[600] : Colors.red)),
                          ),
                          ListTile(
                            title: MyText(title: "En fondo + Total", fontSize: 16, fontWeight: FontWeight.bold,),
                            trailing: _contenedor(child: Text("${Utils.toCurrency(datos["balanceActual"])}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),), color: Theme.of(context).primaryColor.withOpacity(0.5)),
                            // (map["balanceActual"] >= 0) ? Utils.colorInfoClaro : Utils.colorRosa
                          ),
                        ]),
                      ),
                )
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _contenedor({Widget child, Color color}){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5)
        ),
        child: child
    );
  }

  _lineasTabBarWidget(){
    return UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        // insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
      );
  }

  esPantallaPequena(){
    return _isSmallOrMedium;
  }

  esPantallaGrande(){
    return !_isSmallOrMedium;
  }
}