import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/historico.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:loterias/main.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mybutton.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mycontainerbutton.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/myfilter2.dart';
import 'package:loterias/ui/widgets/myfilterv2.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/showmydaterangedialog.dart';
import 'package:loterias/ui/widgets/showmymodalbottomsheet.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';
import 'package:rxdart/rxdart.dart';

import '../../widgets/mycirclebutton.dart';

class HistoricoVentasScreen extends StatefulWidget {
  @override
  _HistoricoVentasScreenState createState() => _HistoricoVentasScreenState();
}

class _HistoricoVentasScreenState extends State<HistoricoVentasScreen> {
  GlobalKey<MyFilter2State> _myFilterKey = GlobalKey<MyFilter2State>();
  static const int sortName = 0;
  static const int sortStatus = 1;
  bool isAscending = true;
  int sortType = sortName;

  MyDate _fecha = MyDate.hoy;
  DateTimeRange _date;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<List<Historico>> _streamControllerHistorio;
  List<Historico> listaData = [];
  Map<String, dynamic> mapBancas;
  var _fechaInicial = DateTime.now();
  var _fechaFinal = DateTime.now();
  String _selectedOption = "Con ventas";
  List<String> listaOpciones = ["Todos", "Con ventas o recargas", "Con ventas", "Con premios", "Con tickets pendientes", "Sin ventas"];
  bool _cargando = false;
  DateFormat _dateFormat;
  List<int> listaLimite = [70, 120, 180, 240];
  int _limite = 70;
  List<Moneda> listaMoneda = [];
  List<Grupo> listaGrupo = [];
  List<Moneda> _monedas = [];
  List<Grupo> _grupos = [];
  int _idGrupoDeEsteUsuario;
  var _txtSearch = TextEditingController();
  List<MyFilterSubData2> _selctedFilter = [];
  List<MyFilterData2> listaFiltros = [];
  List<String> listaReporteARetornar = ["Historico", "Branchreport"];
  String _reporteARetornar = "Historico";
  String executeTime = "";
  Moneda _moneda;
  Grupo _grupo;
  Future _futureData;

  @override
  initState(){
    _streamControllerHistorio = BehaviorSubject();
    initializeDateFormatting();
    // _dateFormat = new DateFormat.yMMMMd(MyApp.myLocale.languageCode);
    _dateFormat = new DateFormat.yMMMMEEEEd(MyApp.myLocale.languageCode);
    _date = MyDate.getTodayDateRange();
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);
    _selectedOption = listaOpciones[1];
    _futureData = _init();
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

_init() async {
    try{
      // setState(() => _cargando = true);

      _filtrarFecha();
      _idGrupoDeEsteUsuario = await Db.idGrupo();
      print("HistoricoVentas _init _idGrupoDeEsteUsuario: $_idGrupoDeEsteUsuario");
      var parsed = await ReporteService.historico(scaffoldKey: _scaffoldKey, context: context, fechaDesde: _date.start, fechaHasta: _date.end, opcion: _selectedOption, idMonedas: [], limite: _limite, idGrupos: _idGrupoDeEsteUsuario != null ? [_idGrupoDeEsteUsuario] : [], isBranchreport: _reporteARetornar == "Branchreport");
      listaData = parsed["bancas"] != null ? parsed["bancas"].map<Historico>((json) => Historico.fromMap(json)).toList() : [];
      // listaData = List.from(parsed["bancas"]);
      listaMoneda = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((e) => Moneda.fromMap(e)).toList() : [];
      listaMoneda.insert(0, Moneda(id: 0, descripcion: 'Todas', abreviatura: 'Todas'));
      listaGrupo = (parsed["grupos"] != null) ? parsed["grupos"].map<Grupo>((e) => Grupo.fromMap(e)).toList() : [];
      listaGrupo.insert(0, Grupo(id: 0, descripcion: 'Todos'));
      MyFilterData2 filtroGrupo;
      
      

      // if(listaGrupo.length > 0){
      //   var filtro = MyFilterData2(child: "Filas", fixed: true != null, data: listaLimite.map((e) => MyFilterSubData2(child: "$e", value: e, type: "Filas")).toList());
      //   listaFiltros.add(filtro);
      //     var filtroSub = filtro.data[0];
      //     if(filtroSub != null){
      //       _selctedFilter.add(filtroSub);
      //     }
      // }

     if(_idGrupoDeEsteUsuario != null){
       if(listaGrupo.length > 0)
        _grupo = listaGrupo.firstWhere((e) => e.id == _idGrupoDeEsteUsuario, orElse: () => null);
     }
      


      _streamControllerHistorio.add(listaData);

      // if(_moneda == null)
      //   setState(() => _moneda = (listaMoneda.length > 0) ? listaMoneda[0] : null);

      _filterTable();
    } on Exception catch(e){
      _streamControllerHistorio.add([]);
      
    }
  }

  _historicoVentas() async {
    try{
      // setState(() => _cargando = true);
        _streamControllerHistorio.add(null);
      _filtrarFecha();

      var parsed = await ReporteService.historico(scaffoldKey: _scaffoldKey, context: context, fechaDesde: _date.start, fechaHasta: _date.end, opcion: _selectedOption, idMonedas: _moneda != null ? _moneda.id != 0 ? [_moneda.id] : [] : [], limite: _limite, idGrupos: _grupo != null ? _grupo.id != 0 ? [_grupo.id] : [] : [], isBranchreport: _reporteARetornar == "Branchreport");
      print("HistoricoVentasScreen _historicoVentas query: ${parsed["bancas"]}");
      listaData = parsed["bancas"] != null ? parsed["bancas"].map<Historico>((json) => Historico.fromMap(json)).toList() : [];
      executeTime = parsed["time"];
      // listaData = List.from(parsed["bancas"]);
      // if(listaMoneda.length == 0)
      //   listaMoneda = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((e) => Moneda.fromMap(e)).toList() : [];
      _streamControllerHistorio.add(listaData);

      _filterTable();
    } on Exception catch(e){
      _streamControllerHistorio.add([]);
      
    }
  }

  _filterTable(){
    // switch(_selectedOption){
    //   case "Con ventas":
    //     _streamControllerHistorio.add(listaData.where((b) => b.ventas > 0).toList());
    //     break;
    //   case "Con premios":
    //     _streamControllerHistorio.add(listaData.where((b) => b.premios > 0).toList());
    //     break;
    //   case "Con tickets pendientes":
    //     _streamControllerHistorio.add(listaData.where((b) => b.pendientes > 0).toList());
    //     break;
    //   default:
    //     _streamControllerHistorio.add(listaData);
    //     break;
    // }
  }

  Widget _buildTable(List map){
   var tam = (map != null) ? map.length : 0;
   List<DataRow> rows;
   if(tam == 0){
     rows = [];
   }else{
    //  rows = map.asMap().map((idx, b)
    //       => MapEntry(
    //         idx,
    //         TableRow(
              
    //           children: [
    //             Container(
    //               padding: EdgeInsets.only(top: 5, bottom: 5),
    //               color: Utils.colorGreyFromPairIndex(idx: idx),
    //               child: Center(
    //                 child: InkWell(onTap: (){}, child: Text(b["descripcion"], style: TextStyle(fontSize: 14, decoration: TextDecoration.underline)))
    //               ),
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(top: 5, bottom: 5),
    //               color: Utils.colorGreyFromPairIndex(idx: idx), 
    //               child: Center(child: Text("${Utils.toCurrency(b["ventas"])}", style: TextStyle(fontSize: 14)))
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(top: 5, bottom: 5),
    //               color: Utils.colorGreyFromPairIndex(idx: idx), 
    //               child: Center(child: Text("${Utils.toCurrency(b["comisiones"])}", style: TextStyle(fontSize: 14)))
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(top: 5, bottom: 5),
    //               color: Utils.colorGreyFromPairIndex(idx: idx), 
    //               child: Center(child: Text("${Utils.toCurrency(b["descuentos"])}", style: TextStyle(fontSize: 14)))
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(top: 5, bottom: 5),
    //               color: Utils.colorGreyFromPairIndex(idx: idx), 
    //               child: Center(child: Text("${Utils.toCurrency(b["premios"])}", style: TextStyle(fontSize: 14)))
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(top: 5, bottom: 5),
    //               color: (Utils.toDouble(b["totalNeto"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
    //               child: Center(child: Text("${Utils.toCurrency(b["totalNeto"])}", style: TextStyle(fontSize: 14)))
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(top: 5, bottom: 5),
    //               color: (Utils.toDouble(b["balance"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
    //               child: Center(child: Text("${Utils.toCurrency(b["balance"])}", style: TextStyle(fontSize: 14)))
    //             ),
    //             Container(
    //               padding: EdgeInsets.only(top: 5, bottom: 5),
    //               color: (Utils.toDouble(b["balanceActual"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
    //               child: Center(child: Text("${Utils.toCurrency(b["balanceActual"])}", style: TextStyle(fontSize: 14)))
    //             ),
    //             // Center(child: IconButton(icon: Icon(Icons.delete, size: 28,), onPressed: () async {},)),
    //           ],
    //         )
    //       )
        
    //     ).values.toList();
        
    // rows.insert(0, 
    //           TableRow(
    //             decoration: BoxDecoration(color: Utils.colorPrimary),
    //             children: [
    //               // buildContainer(Colors.blue, 50.0),
    //               // buildContainer(Colors.red, 50.0),
    //               // buildContainer(Colors.blue, 50.0),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Bancas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Ventas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, )),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Comis.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Desc.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Premios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Neto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Balance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
    //                 child: Center(child: Text('Balance mas ventas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               ),
    //               // Padding(
    //               //   padding: const EdgeInsets.all(8.0),
    //               //   child: Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
    //               // ),
    //             ]
    //           )
    //           );

      rows = map.asMap().map((idx, b)
                    => MapEntry(
                      idx,
                      DataRow(

                        cells: [DataCell(Text(b["descripcion"])), DataCell(Text("${Utils.toCurrency(b["ventas"])}")), DataCell(Text("${Utils.toCurrency(b["comisiones"])}")), DataCell(Text("${Utils.toCurrency(b["descuentos"])}")), 
                      DataCell(Text("${Utils.toCurrency(b["premios"])}")), 
                      DataCell(
                        Container(
                          // padding: EdgeInsets.only(top: 5, bottom: 5),
                          color: (Utils.toDouble(b["totalNeto"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
                          child: Center(child: Text("${Utils.toCurrency(b["totalNeto"])}", style: TextStyle(fontSize: 14)))
                        ),
                      ),  
                      DataCell(
                        Container(
                          // padding: EdgeInsets.only(top: 5, bottom: 5),
                          color: (Utils.toDouble(b["balance"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
                          child: Center(child: Text("${Utils.toCurrency(b["balance"])}", style: TextStyle(fontSize: 14)))
                        ),
                      ), 
                      DataCell(
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          color: (Utils.toDouble(b["balanceActual"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
                          child: Center(child: Text("${Utils.toCurrency(b["balanceActual"])}", style: TextStyle(fontSize: 14)))
                        ),
                      )
                      ])
                    )
                  ).values.toList();

      var totales = _calcularTotal(map);
      rows.add( 
              DataRow(
                // decoration: BoxDecoration(color: Utils.colorPrimary),
                cells: [
                  // buildContainer(Colors.blue, 50.0),
                  // buildContainer(Colors.red, 50.0),
                  // buildContainer(Colors.blue, 50.0),
                  DataCell(
                     Center(child: Text('Totales', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  DataCell(
                    Center(child: Text('${Utils.toCurrency(Utils.redondear(totales["ventas"]))}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  DataCell(
                    Center(child: Text('${Utils.toCurrency(Utils.redondear(totales["comisiones"]))}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  DataCell(
                    Center(child: Text('${Utils.toCurrency(Utils.redondear(totales["descuentos"]))}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  DataCell(
                    Center(child: Text('${Utils.toCurrency(Utils.redondear(totales["premios"]))}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  DataCell(
                    Center(child: Text('${Utils.toCurrency(Utils.redondear(totales["totalNeto"]))}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  DataCell(
                    Center(child: Text('${Utils.toCurrency(Utils.redondear(totales["balance"]))}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  DataCell(
                    Center(child: Text('${Utils.toCurrency(Utils.redondear(totales["balanceActual"]))}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                 
                ]
              )
              );
        
   }

  // return Flexible(
  //   child: ListView.builder(
  //     itemCount: map == null ? 1 : map.length + 1,
  //     itemBuilder: (BuildContext context, int index) {
  //         if (index == 0) {
  //             // return the header
  //             return new Row(children: [
  //               Padding(
  //                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
  //                   child: Center(child: Text('Bancas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
  //                   child: Center(child: Text('Ventas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, )),),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
  //                   child: Center(child: Text('Comis.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
  //                   child: Center(child: Text('Desc.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
  //                   child: Center(child: Text('Premios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
  //                   child: Center(child: Text('Neto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
  //                   child: Center(child: Text('Balance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
  //                   child: Center(child: Text('Balance mas ventas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
  //                 ),
  //             ],);
  //         }
  //         index -= 1;

  //         // return row
  //         var b = map[index];
  //         return Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Container(
  //                 padding: EdgeInsets.only(top: 5, bottom: 5),
  //                 color: Utils.colorGreyFromPairIndex(idx: index),
  //                 child: Center(
  //                   child: InkWell(onTap: (){}, child: Text(b["descripcion"], style: TextStyle(fontSize: 14, decoration: TextDecoration.underline)))
  //                 ),
  //               ),
  //               Container(
  //                 padding: EdgeInsets.only(top: 5, bottom: 5),
  //                 color: Utils.colorGreyFromPairIndex(idx: index), 
  //                 child: Center(child: Text("${Utils.toCurrency(b["ventas"])}", style: TextStyle(fontSize: 14)))
  //               ),
  //               Container(
  //                 padding: EdgeInsets.only(top: 5, bottom: 5),
  //                 color: Utils.colorGreyFromPairIndex(idx: index), 
  //                 child: Center(child: Text("${Utils.toCurrency(b["comisiones"])}", style: TextStyle(fontSize: 14)))
  //               ),
  //               Container(
  //                 padding: EdgeInsets.only(top: 5, bottom: 5),
  //                 color: Utils.colorGreyFromPairIndex(idx: index), 
  //                 child: Center(child: Text("${Utils.toCurrency(b["descuentos"])}", style: TextStyle(fontSize: 14)))
  //               ),
  //               Container(
  //                 padding: EdgeInsets.only(top: 5, bottom: 5),
  //                 color: Utils.colorGreyFromPairIndex(idx: index), 
  //                 child: Center(child: Text("${Utils.toCurrency(b["premios"])}", style: TextStyle(fontSize: 14)))
  //               ),
  //               Container(
  //                 padding: EdgeInsets.only(top: 5, bottom: 5),
  //                 color: (Utils.toDouble(b["totalNeto"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
  //                 child: Center(child: Text("${Utils.toCurrency(b["totalNeto"])}", style: TextStyle(fontSize: 14)))
  //               ),
  //               Container(
  //                 padding: EdgeInsets.only(top: 5, bottom: 5),
  //                 color: (Utils.toDouble(b["balance"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
  //                 child: Center(child: Text("${Utils.toCurrency(b["balance"])}", style: TextStyle(fontSize: 14)))
  //               ),
  //               Container(
  //                 padding: EdgeInsets.only(top: 5, bottom: 5),
  //                 color: (Utils.toDouble(b["balanceActual"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
  //                 child: Center(child: Text("${Utils.toCurrency(b["balanceActual"])}", style: TextStyle(fontSize: 14)))
  //               ),
  //           ],
  //         );
  //     },
  //   ),
  // );
  // 
  // return Flexible(
  //   child: HorizontalDataTable(
  //     headerWidgets: [

  //     ],
  //   )
  // )

  return Flexible(
      child: ListView(
      children: <Widget>[
        // ListTile(
        //   leading: CircleAvatar(child: Text("01", style: TextStyle(color: Colors.white),), backgroundColor: Colors.blue,),
        //   title: Text("Banca1"),
        //   subtitle: RichText(text: TextSpan(
        //     style: TextStyle(color: Colors.grey),
        //     children: [
        //       TextSpan(text: "10,000 Comis."),
        //       TextSpan(text: "  •  100 Desc."),
        //       TextSpan(text: "  •  200,000 premios"),
        //       TextSpan(text: "  •  200,000 Balance"),
        //       TextSpan(text: "  •  1000,000 Balance mas ventas"),
              
        //     ]
        //   )),
        //   trailing: Text("\$30,000", style: TextStyle(color: Colors.green[700]),),
        // ),
        // ListTile(
        //   leading: CircleAvatar(child: Text("02", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red,),
        //   title: Text("Banca2"),
        //   subtitle: RichText(text: TextSpan(
        //     style: TextStyle(color: Colors.grey),
        //     children: [
        //       TextSpan(text: "200 Comis."),
        //       TextSpan(text: "  •  500 Desc."),
        //       TextSpan(text: "  •  1,000 premios"),
        //       TextSpan(text: "  •  200,000 Balance"),
        //       TextSpan(text: "  •  1000,000 Balance mas ventas"),
        //     ]
        //   )),
        //   trailing: Text("\$30,000", style: TextStyle(color: Colors.green[700]),),
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: 
                DataTable(
                  headingRowHeight: 30,
                  // horizontalMargin: 0,
                  headingTextStyle: TextStyle(color: Colors.white),
                  headingRowColor: MaterialStateProperty.all(Utils.colorPrimary),
                  columns: [DataColumn(label: Text("Banca",)), DataColumn(label: Center(child: Text("Venta"))), DataColumn(label: Text("Comis.")), DataColumn(label: Text("Desc.")), DataColumn(label: Text("Premios")), DataColumn(label: Center(child: Text("Neto"))), DataColumn(label: Text("Balance")), DataColumn(label: Text("Balance mas ventas"))],
                  rows: rows
                ),
              //   Table(
              //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              //   columnWidths: <int, TableColumnWidth>{
              //     // 1 : FractionColumnWidth(.12),
              //     7 : FractionColumnWidth(.28)
              //     },
              //   children: rows,
              //  ),
          ),
        ),
      ],
    ),
  );
  
 }

 Map<String, dynamic> _calcularTotal(List<Historico> lista){
  double ventas = 0;
  double recargas = 0;
  double comisiones = 0;
  double descuentos = 0;
  double premios = 0;
  double totalNeto = 0;
  double balance = 0;
  double balanceActual = 0;

  int pendientes = 0;
  int ganadores = 0;
  int perdedores = 0;
  int tickets = 0;

  for (var b in lista) {
    ventas += b.ventas;
    recargas += b.recargas;
    comisiones += b.comisiones;
    descuentos += b.descuentos;
    premios += b.premios;
    totalNeto += b.totalNeto;
    balance += b.balance;
    balanceActual += b.balanceActual;
    pendientes += b.pendientes;
    ganadores += b.ganadores;
    perdedores += b.perdedores;
    tickets += b.tickets;
  }

  // lista.forEach((b){
  //   ventas += b.ventas;
  //   comisiones += b.comisiones;
  //   descuentos += b.descuentos;
  //   premios += b.premios;
  //   totalNeto += b.totalNeto;
  //   balance += b.balance;
  //   balanceActual += b.balanceActual;
  // });

  Map<String, dynamic> map = {"ventas" : ventas, "recargas" : recargas, "comisiones" : comisiones, "descuentos" : descuentos, 
  "premios" : premios, "totalNeto" : totalNeto, "balance" : balance, "balanceActual" :  balanceActual, 
  "pendientes" :  pendientes, "ganadores" :  ganadores, "perdedores" :  perdedores, "tickets" :  tickets, };

  return map;
 }


_getListaFiltro(){
    var mostrarFiltro = false;
    List<MyFilterData> lista = [];
    if(_fecha == null || _limite != 20){
      

        

        if(_fecha == null)
          lista.add(MyFilterData(
            text: MyDate.datesToString(_fechaInicial, _fechaFinal), 
            value: MyDate.datesToString(_fechaInicial, _fechaFinal), 
            color: null,
            onChanged: (data){
              setState(() {
                _fecha = MyDate.hoy;
                _historicoVentas();
              });
            })
          );


          if(_limite != 20)
          lista.add(MyFilterData(
            text: "$_limite filas", 
            value: _limite, 
            color: Colors.green[700],

            onChanged: (data){
              setState(() {
                _limite = 20;
                _historicoVentas();
              });
            })
          );

       
    }else
      lista = [];
    
    return lista;
  }

  _filtroScreen() async {
    _myFilterKey.currentState.openFilter(context);
    return;
    var fecha = _fecha;
    var fechaInicial = _date.start;
    var fechaFinal = _date.end;
    var dateRange = _date;
    var limite = _limite;
    var data = await showDialog(context: context, builder: (context){
      _back({sendData = false}){
        var map;
        if(sendData)
          map = {
            "fecha" : fecha,
            "date" : dateRange,
            "limite" : limite,
          };

        Navigator.pop(context, map);
      }
  
      return StatefulBuilder(
        builder: (context, setState) {
          dateChanged(date){
            setState((){
              dateRange = date;
              fecha = MyDate.dateRangeToMyDate(date);
            });
          }


 
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
            DateTime fecha = await showDatePicker(context: context, initialDate: dateRange.start, firstDate: DateTime(2000), lastDate: DateTime(2100));
            if(fecha == null)
              return;
            
            if(dateRange.start != fecha)
              setState(() {
                dateRange = (fecha != null) ? DateTimeRange(start: DateTime.parse("${fecha.year}-${Utils.toDosDigitos(fecha.month.toString())}-${Utils.toDosDigitos(fecha.day.toString())} 00:00"), end: dateRange.end) : fechaInicial;
                // _seleccionarFechaSencillaSiPertenece();
              });

          }

          _fechaFinalChanged() async {
            
            DateTime fecha = await showDatePicker(context: context, initialDate: dateRange.end, firstDate: DateTime(2000), lastDate: DateTime(2100));
            if(fecha == null)
              return;
            
            if(fechaFinal != fecha)
              setState(() {
                dateRange = (fecha != null) ? DateTimeRange(start: dateRange.start, end: DateTime.parse("${fecha.year}-${Utils.toDosDigitos(fecha.month.toString())}-${Utils.toDosDigitos(fecha.day.toString())} 23:59:59")) : fechaFinal;
                // _seleccionarFechaSencillaSiPertenece();
              });

          }



          return AlertDialog(
            title: Text("Filtrar"),
            contentPadding: EdgeInsets.only(top: 8, bottom: 0, left: 24, right: 24),
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
                          value: dateRange,
                          showListNormalCortaLarga: 3,
                          showDateFilterOnly: true,
                          paddingContainer: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                          onChanged: dateChanged,
                        ),
                        ListTile(
                          dense: true,
                          leading: SizedBox(),
                          onTap: _fechaInicialChanged,
                          title: Text("${_dateFormat != null ? _dateFormat.format(dateRange.start) : DateFormat('EEE, MMM d yyy').format(dateRange.start)}"),
                        ),
                        ListTile(
                          dense: true,
                          leading: SizedBox(),
                          onTap: _fechaFinalChanged,
                          title: Text("${_dateFormat != null ? _dateFormat.format(dateRange.end) : DateFormat('EEE, MMM d yyy').format(dateRange.end)}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Divider(thickness: 1,),
                        ),
                        // ListTile(
                        //   leading: Icon(Icons.attach_money),
                        //   // title: Text("${_moneda != null ? _moneda.descripcion : ''}"),
                        //   dense: true,
                        //   title: DropdownButtonHideUnderline(
                        //     child: DropdownButton(
                        //       value: moneda,
                        //       // selectedItemBuilder: (context){
                        //       //   return listaLimite.map((e) => Center(child: Text("$e filas a mostrar"))).toList();
                        //       // },
                        //       items: listaMoneda.map((e) => DropdownMenuItem(child: Text("${e.descripcion}"), value: e),).toList(),
                        //       onChanged: (data){
                        //         setState(() => moneda = data);
                        //       },
                        //     ),
                        //   ),
                        //   // onTap: _showMoneda,
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(thickness: 1,),
                        ),
                        ListTile(
                          dense: true,
                          leading: Icon(Icons.table_rows_rounded),
                          onTap: _fechaFinalChanged,
                          title: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: limite,
                              selectedItemBuilder: (context){
                                return listaLimite.map((e) => Center(child: Text("$e filas a mostrar"))).toList();
                              },
                              items: listaLimite.map((e) => DropdownMenuItem(child: Text("$e"), value: e),).toList(),
                              onChanged: (data){
                                setState(() => limite = data);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Divider(thickness: 1,),
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

    // if(_fechaInicial == data["fechaInicial"] && _fechaFinal == data["fechaFinal"] && _fecha == data["fecha"] && _limite == data["limite"] && _moneda == data["moneda"])
    if(_date == data["date"] && _fecha == data["fecha"] && _limite == data["limite"])
      return;

    setState(() {
      // _fechaInicial = data["fechaInicial"];
      // _fechaFinal = data["fechaFinal"];
      _fecha = data["fecha"];
      _date = data["date"];
      _limite = data["limite"];

      _historicoVentas();
    });
  }




  _showBottomSheetMoneda() async {
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
            monedaChanged(moneda){
              _back();
            }
        return Container(
              height: 150,
              child: Column(
                children: [
                  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaMoneda.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          // value: _moneda == listaMoneda[index],
                          value: true,
                          onChanged: (data){
                            monedaChanged(listaMoneda[index]);
                          },
                          title: Text("${listaMoneda[index].descripcion}",),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
        
      
      }
  );
    // if(data != null)
    //   setState((){
    //     _loteria = data;
    //     _filtrar();
    //   });
  }


   _search(String data){
    print("SucursalesSCreen _search: $data");
    if(data.isEmpty)
      _streamControllerHistorio.add(listaData);
    else
      {
        var element = listaData.where((element) => element.descripcion.toLowerCase().indexOf(data) != -1).toList();
        print("RolesScreen _serach length: ${element.length}");
        _streamControllerHistorio.add(listaData.where((element) => element.descripcion.toLowerCase().indexOf(data) != -1).toList());
      }
  }

  Widget _getBodyWidget(List<Historico> data, bool isSmallOrMedium) {
    if(data == null)
      return Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Center(child: CircularProgressIndicator()),
      );
    if(data.length == 0)
      return Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Center(child: MyEmpty(title: "No hay bancas $_selectedOption", icon: Icons.home_work_sharp, titleButton: "No hay bancas",)),
      );

    // return Text("Klk");

    if(!isSmallOrMedium)
      return Column(
        children: [
          // MySubtitle(title: "$executeTime"),
          MyTable(
            // type: MyTableType.custom,
            showColorWhenImpar: true,
            columns: [
              "Banca",
              "Pendientes",
              "Ganadores",
              "Perdedores",
              "Tickets",
              "Ventas",
              "Recargas",
              "Comi.",
              "Desc.",
              "Premios",
              "Neto",
              "Balance",
              "Balance mas ventas",
            ], 
            rows: data.map((e) => [
              e, 
              "${e.descripcion}", 
              "${e.pendientes}", 
              "${e.ganadores}", 
              "${e.perdedores}", 
              "${e.tickets}", 
              "${Utils.toCurrency(e.ventas)}", 
              "${Utils.toCurrency(e.recargas)}", 
              "${Utils.toCurrency(e.comisiones)}", 
              "${Utils.toCurrency(e.descuentos)}", 
              "${Utils.toCurrency(e.premios)}", 
              "${Utils.toCurrency(e.totalNeto)}", 
              "${Utils.toCurrency(e.balance)}", 
              "${Utils.toCurrency(e.balanceActual)}"]).toList(),
              totals: [[
                "Total",
               "${data.map((e) => e.pendientes).reduce((value, element) => value + element)}",
               "${data.map((e) => e.ganadores).reduce((value, element) => value + element)}",
               "${data.map((e) => e.perdedores).reduce((value, element) => value + element)}",
               "${data.map((e) => e.tickets).reduce((value, element) => value + element)}",
               "${Utils.toCurrency(data.map((e) => e.ventas).reduce((value, element) => value + element))}",
               "${Utils.toCurrency(data.map((e) => e.comisiones).reduce((value, element) => value + element))}",
               "${Utils.toCurrency(data.map((e) => e.descuentos).reduce((value, element) => value + element))}",
               "${Utils.toCurrency(data.map((e) => e.premios).reduce((value, element) => value + element))}",
               "${Utils.toCurrency(data.map((e) => e.totalNeto).reduce((value, element) => value + element))}",
               "${Utils.toCurrency(data.map((e) => e.balance).reduce((value, element) => value + element))}",
               "${Utils.toCurrency(data.map((e) => e.balanceActual).reduce((value, element) => value + element))}",
            ]],
          ),
        ],
      );
    
    return Column(
      children: [
          // MySubtitle(title: "$executeTime"),
        Expanded(
          child: HorizontalDataTable(
            leftHandSideColumnWidth: 120,
            // rightHandSideColumnWidth: isSmallOrMedium ? 820 : 1270,
            rightHandSideColumnWidth: isSmallOrMedium ? 940 : 1390,
            isFixedHeader: true,
            headerWidgets: _getTitleWidget(isSmallOrMedium),
            leftSideItemBuilder: (context, index) => _generateFirstColumnRow(context, index, data.length, data),
            rightSideItemBuilder: (context, index) => _generateRightHandSideColumnRow(context, index, data.length, data, isSmallOrMedium),
            itemCount: data.length + 1,
            rowSeparatorWidget: const Divider(
              color: Colors.transparent,
              height: 0,
              thickness: 0.0,
            ),
            leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
            rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
            // verticalScrollbarStyle: const ScrollbarStyle(
            //   isAlwaysShown: true,
            //   thickness: 4.0,
            //   radius: Radius.circular(5.0),
            // ),
            // horizontalScrollbarStyle: const ScrollbarStyle(
            //   isAlwaysShown: true,
            //   thickness: 4.0,
            //   radius: Radius.circular(5.0),
            // ),
            // enablePullToRefresh: false,
            // refreshIndicator: const WaterDropHeader(),
            // refreshIndicatorHeight: 60,
            // onRefresh: () async {
            //   //Do sth
            //   await Future.delayed(const Duration(milliseconds: 500));
            //   _hdtRefreshController.refreshCompleted();
            // },
            // htdRefreshController: _hdtRefreshController,
          ),
        ),
      ],
    );
      
  }

  List<Widget> _getTitleWidget([bool isSmallOrMedium = false]) {
    // return [
      // TextButton(
      //   style: TextButton.styleFrom(
      //     padding: EdgeInsets.zero,
      //   ),
      //   child: _getTitleItemWidget(
      //       'Banca' + (sortType == sortName ? (isAscending ? '↓' : '↑') : ''),
      //       120),
      //   onPressed: () {
      //     // sortType = sortName;
      //     // isAscending = !isAscending;
      //     // user.sortName(isAscending);
      //     // setState(() {});
      //   },
      // ),
      // TextButton(
      //   style: TextButton.styleFrom(
      //     padding: EdgeInsets.zero,
      //   ),
      //   child: _getTitleItemWidget(
      //       'Ventas' +
      //           (sortType == sortStatus ? (isAscending ? '↓' : '↑') : ''),
      //       120),
      //   onPressed: () {
      //     // sortType = sortStatus;
      //     // isAscending = !isAscending;
      //     // user.sortStatus(isAscending);
      //     // setState(() {});
      //   },
      // ),
    // ]
    return 
    isSmallOrMedium
    ?
    [
      _getTitleItemWidget('Banca', 120),
      _getTitleItemWidget('Ventas.', 120),
      _getTitleItemWidget('Recargas.', 120),
      _getTitleItemWidget('Comis.', 120),
      _getTitleItemWidget('Desc.', 100),
      _getTitleItemWidget('Premios', 120),
      _getTitleItemWidget('Neto', 120),
      _getTitleItemWidget('Balance', 120),
      _getTitleItemWidget('Balance mas ventas', 120),
    ]
    :
    [
      _getTitleItemWidget('Banca', 120),
      _getTitleItemWidget('Pendientes', 120),
      _getTitleItemWidget('Ganadores', 120),
      _getTitleItemWidget('Perded.', 100),
      _getTitleItemWidget('Tickets', 110),
      _getTitleItemWidget('Ventas.', 120),
      _getTitleItemWidget('Recargas.', 120),
      _getTitleItemWidget('Comis.', 120),
      _getTitleItemWidget('Desc.', 100),
      _getTitleItemWidget('Premios', 120),
      _getTitleItemWidget('Neto', 120),
      _getTitleItemWidget('Balance', 120),
      _getTitleItemWidget('Balance mas ventas', 120),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Center(child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
      width: width,
      height: 30,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      color: Utils.colorPrimary,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index, int length, List<Historico> data) {
    if(index != length)
      return Container(
        child: Center(child: Text(data[index].descripcion, style: TextStyle(fontWeight: FontWeight.bold)),),
        width: 120,
        height: 30,
        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
        color: Utils.colorGreyFromPairIndex(idx: index),
      );

    return Container(
      child: Center(child: Text("Totales", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
      width: 120,
      height: 30,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      color: Utils.colorGreyFromPairIndex(idx: index),
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index, int length, List<Historico> data, bool isSmallOrMedium) {
    if(index != length){
      Row row = Row(
      children: <Widget>[
        Container(
          child: Center(child: Text("${Utils.toCurrency(data[index].ventas)}", style: TextStyle(fontWeight: FontWeight.w600))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),
        Container(
          child: Center(child: Text("${Utils.toCurrency(data[index].recargas)}", style: TextStyle(fontWeight: FontWeight.w600))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),
        Container(
          child: Center(child: Text("${Utils.toCurrency(data[index].comisiones)}", style: TextStyle(fontWeight: FontWeight.w600))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),
        Container(
          child: Center(child: Text("${Utils.toCurrency(data[index].descuentos)}", style: TextStyle(fontWeight: FontWeight.w600))),
          width: 100,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),
        Container(
          child: Center(child: Text("${Utils.toCurrency(data[index].premios)}", style: TextStyle(fontWeight: FontWeight.w600))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),
        Container(
          color: (Utils.toDouble(data[index].totalNeto.toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa,
          child: Center(child: Text("${Utils.toCurrency(data[index].totalNeto)}", style: TextStyle(fontWeight: FontWeight.w600))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Center(child: Text("${Utils.toCurrency(data[index].balance)}", style: TextStyle(fontWeight: FontWeight.w600))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: (Utils.toDouble(data[index].balance.toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa,
        ),
        Container(
          child: Center(child: Text("${Utils.toCurrency(data[index].balanceActual)}", style: TextStyle(fontWeight: FontWeight.w600))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: (Utils.toDouble(data[index].balanceActual.toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
        ),
      ],
    );
    
      if(isSmallOrMedium == false){
        row.children.insert(1, Container(
          child: Center(child: Text("${Utils.toCurrency(data[index].pendientes)}", style: TextStyle(fontWeight: FontWeight.w600))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        row.children.insert(2, Container(
          child: Center(child: Text("${Utils.toCurrency(data[index].ganadores)}", style: TextStyle(fontWeight: FontWeight.w600))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        row.children.insert(3, Container(
          child: Center(child: Text("${Utils.toCurrency(data[index].perdedores)}", style: TextStyle(fontWeight: FontWeight.w600))),
          width: 100,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
        row.children.insert(4, Container(
          child: Center(child: Text("${Utils.toCurrency(data[index].tickets)}", style: TextStyle(fontWeight: FontWeight.w600))),
          width: 110,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ));
      }

      return row;
    }

    var totales = _calcularTotal(data);
    Row row = Row(
      children: <Widget>[
        
        Container(
          child: Center(child: Text("${Utils.toCurrency(Utils.redondear(totales["ventas"]))}", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorPrimary))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),
        Container(
          child: Center(child: Text("${Utils.toCurrency(Utils.redondear(totales["recargas"]))}", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorPrimary))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),
        Container(
          child: Center(child: Text("${Utils.toCurrency(Utils.redondear(totales["comisiones"]))}", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorPrimary))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),
        Container(
          child: Center(child: Text("${Utils.toCurrency(Utils.redondear(totales["descuentos"]))}", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorPrimary))),
          width: 100,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),
        Container(
          child: Center(child: Text("${Utils.toCurrency(Utils.redondear(totales["premios"]))}", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorPrimary))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),
        Container(
          // color: (Utils.toDouble(listaData[index]["totalNeto"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa,
          child: Center(child: Text("${Utils.toCurrency(Utils.redondear(totales["totalNeto"]))}", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorPrimary))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Center(child: Text("${Utils.toCurrency(Utils.redondear(totales["balance"]))}", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorPrimary))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          // color: (Utils.toDouble(listaData[index]["balance"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa,
        ),
        Container(
          child: Center(child: Text("${Utils.toCurrency(Utils.redondear(totales["balanceActual"]))}", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorPrimary))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          // color: (Utils.toDouble(listaData[index]["balanceActual"].toString()) >= 0) ? Utils.colorInfoClaro : Utils.colorRosa, 
        ),
      ],
    );
    if(isSmallOrMedium == false){
      row.children.insert(1, Container(
          child: Center(child: Text("${Utils.toCurrency(Utils.redondear(totales["pendientes"]))}", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorPrimary))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),);
      row.children.insert(2, Container(
          child: Center(child: Text("${Utils.toCurrency(Utils.redondear(totales["ganadores"]))}", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorPrimary))),
          width: 120,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),);
      row.children.insert(2, Container(
          child: Center(child: Text("${Utils.toCurrency(Utils.redondear(totales["perdedores"]))}", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorPrimary))),
          width: 100,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),);
      row.children.insert(2, Container(
          child: Center(child: Text("${Utils.toCurrency(Utils.redondear(totales["tickets"]))}", style: TextStyle(fontWeight: FontWeight.bold, color: Utils.colorPrimary))),
          width: 110,
          height: 30,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          color: Utils.colorGreyFromPairIndex(idx: index),
        ),);
    }
    return row;
  }

  _opcionChanged(opcion){
    setState((){
        _selectedOption = opcion;
        _historicoVentas();
      });
  }

  _showBottomSheetBanca() async {
    // if(_tienePermiso == false)
    //   return;

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
            opcionChanged(opcion){
              setState(() => _selectedOption = opcion);
              _opcionChanged(opcion);
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
                      itemCount: listaOpciones.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          value: _selectedOption == listaOpciones[index],
                          onChanged: (data){
                            opcionChanged(listaOpciones[index]);
                          },
                          title: Text("${listaOpciones[index]}"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          
      }
  );
    // if(data != null)
    //   setState((){
    //     _loteria = data;
    //     _filtrar();
    //   });
  }

 _deleteAllFilter(){
    setState(() {
      if(_fecha == null)
        _fecha = MyDate.hoy;

      if(_limite != 20)
        _limite = 20;

      _historicoVentas();
    });
  }



  _titleScreen(bool isSmallOrMedium){
    return
    // isSmallOrMedium
    // ?
    // MyCollapseChanged(
    //   actionWhenCollapse: MyCollapseAction.nothing,
    //   child: Row(
    //     children: [
    //       Text("${_selectedOption != null ? _selectedOption : 'No hay opcion'}", style: TextStyle(color: Colors.black),),
    //       Icon(Icons.arrow_drop_down, color: Colors.black54,)
    //     ],
    //   ),
    // )
    // :
    "Historico ventas";
  }

  _dateChanged(date){
    setState((){
      _date = date;
      _fecha = MyDate.dateRangeToMyDate(date);
      _historicoVentas();
    });
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


    return Container(
      width: 180,
      child: Builder(
        builder: (context) {
          return MyDropdown(title: null, 
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
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
          );
        }
      ),
    );
              

  }


  _subtitle(bool isSmallOrMedium){
    return 
    isSmallOrMedium == false
    ?
    "Maneje todas sus ventas y filtrelas por fecha"
    :
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
                Expanded(child: _myFilterWidget(isSmallOrMedium))
              ],
            );
          }
        )
        // MyFilter(
        //   filterTitle: "",
        //   value: _date,
        //   showListNormalCortaLarga: 3,
        //   paddingContainer: EdgeInsets.symmetric(vertical: 7, horizontal: 20),
        //   onChanged: _dateChanged,
        //   onDeleteAll: (){
        //     setState(() {
        //       _limite = listaLimite[0];
        //       _date = MyDate.getTodayDateRange();
        //       _historicoVentas();
        //     });
        //   },
        //   data: [
        //     MyFilterData(text: "$_limite filas", defaultValue: 70, value: _limite, color: Colors.green, onChanged: (value){setState((){
        //       _limite = listaLimite[0];
        //       _historicoVentas();
        //     });}),
        //   ],
        // ),
      ),
    );
    // MyFilter(
    //   showListNormalCortaLarga: 3,
    //   leading: null,
    //   paddingContainer: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    //   contentPadding: EdgeInsets.symmetric(vertical: 2,),
    //   value: _date,
    //   onChanged: (value){
    //     setState(() => _date = value);
    //   },
    //   onDeleteAll: (){},
    // );
    
  }

  _coinButton(bool isSmallOrMedium){
    return MySliverButton(title: SizedBox.shrink());
    // isSmallOrMedium
    // ?
    //  MySliverButton(
    //   // title: TextButton(onPressed: _showBottomSheetMoneda, child: Text("${_moneda != null ? _moneda.abreviatura : ''}", style: TextStyle(color: (_moneda != null) ? Utils.fromHex(_moneda.color) : Utils.colorPrimary))), 
    //   title: TextButton(onPressed: _showBottomSheetMoneda, child: Text("", style: TextStyle(color: Utils.colorPrimary))), 
    //   onTap: _showBottomSheetMoneda
    // )
    // :
    // MySliverButton(
    //   title: DropdownButtonHideUnderline(
    //     child: DropdownButton(
    //       isDense: true,
    //       // value: _moneda,
    //       value: true,
    //       items: listaMoneda.map((e) => DropdownMenuItem(child: Text("${e.descripcion}", style: TextStyle(color: Utils.fromHex(e.color), fontWeight: FontWeight.w600),), value: e)).toList(),
    //       onChanged: _monedaChanged,
    //     ),
    //   ),
    //   onTap: (){}
    // );

  }

  _limiteButton(bool isSmallOrMedium){
    return
    MySliverButton(
      padding: EdgeInsets.all(0),
      title: Container(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: MyDropdown(
                maxLengthToEllipsis: 10,
                title: null,
                textColor: Colors.grey[600],
                color: Colors.grey[600],
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                isFlat: true,
                hint: "$_limite filas",
                elements: listaLimite.map((e) => [e, "$e filas"]).toList(),
                onTap: (value){
                  setState(() {
                    _limite = value;
                    _historicoVentas();
                  });
                },
              ),
            ),
          )
      
      // DropdownButtonHideUnderline(
      //   child: DropdownButton(
      //     isDense: true,
      //     value: _limite,
      //     items: listaLimite.map((e) => DropdownMenuItem(child: Text("$e filas", style: TextStyle(fontWeight: FontWeight.w600),), value: e)).toList(),
      //     onChanged: (value){
      //       setState(() {
      //         _limite = value;
      //         _historicoVentas();
      //       });
      //     },
      //   ),
      // )
      ,
      showOnlyOnLarge: true,
      onTap: (){}
    );
  }

  _selectOrRemoveFilter(MyFilterSubData2 data, [bool delete = false]){
     int index = _selctedFilter.indexWhere((element) => element == data);
    if(index == -1 || !delete)
      setState(() => _selctedFilter.add(data));
    else
      setState(() => _selctedFilter.remove(data));

    print("HistoricoVentasScreen _selectOrRemoveFilter type: ${data.type}");
  }

  _monedaChanged(data){
    setState((){
        _moneda = data;
        _historicoVentas();
      });
  }

   _grupoChanged(data){
    setState((){
        _grupo = data;
        _historicoVentas();
      });
  }

  _myFilterWidget(bool isSmallOrMedium){
    return MyFilterV2(
                  padding: !isSmallOrMedium ? EdgeInsets.symmetric(horizontal: 15, vertical: 10) : null,
                    item: [
                      MyFilterItem(
                        enabled: _idGrupoDeEsteUsuario == null,
                        hint: "${_grupo != null ? 'Grupo:  ' + _grupo.descripcion: 'Grupo...'}", 
                        data: listaGrupo.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                        onChanged: (value){
                          _grupoChanged(value);
                        }
                      ),
                      MyFilterItem(
                        hint: "${_moneda != null ? 'Moneda:  ' + _moneda.descripcion: 'Moneda...'}", 
                        data: listaMoneda.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                        onChanged: (value){
                          _monedaChanged(value);
                        }
                      ),
                      MyFilterItem(
                        hint: "${_selectedOption != null ? 'Opcion:  ' + _selectedOption : 'Opciones...'}", 
                        data: listaOpciones.map((e) => MyFilterSubItem(child: e, value: e)).toList(),
                        onChanged: (value){
                          _opcionChanged(value);
                        }
                      ),
                    ],
                  );
    return  MyFilter2(
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
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
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
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blue[900]),
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(child: Text(MyDate.dateRangeToNameOrString(_date), style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w700)),),
                    ),
                  ),
                ),
                Container(height: 34, width: 1, color: Colors.grey),
              ],
            ),
            onChanged: (data){
              
              if(data.length == 0){
                setState(() {
                  _selctedFilter = [];
                  _grupos = [];
                  _monedas = []; 
                  _historicoVentas();
                });
                return;
              }

              _grupos = [];
              _monedas = []; 
              setState(() {
                _selctedFilter = data;
                for (MyFilterSubData2 myFilterSubData2 in data) {
                  print("HistoricoVentas Filter2 for subData: ${myFilterSubData2.type} value: ${myFilterSubData2.value}");
                  if(myFilterSubData2.type == "Grupo")
                    _grupos.add(myFilterSubData2.value);
                  else if(myFilterSubData2.type == "Moneda")
                    _monedas.add(myFilterSubData2.value);
                  else if(myFilterSubData2.type == "Opcion")
                    _selectedOption = myFilterSubData2.value;
                  else if(myFilterSubData2.type == "Filas")
                    _limite = myFilterSubData2.value;
                }
                _historicoVentas();
              });
              
            },
            onDelete: (data){
              setState(() {
                if(data.child == "Grupo")
                  _grupos = [];
                if(data.child == "Moneda" )
                  _monedas = [];
                for (var element in data.data) {
                  _selctedFilter.remove(element);
                }
                _historicoVentas();
              });
            },
            onDeleteAll: (values){
              setState((){
                // for (var item in _selctedFilter) {
                //   if(item.type == "Grupo" && _idGrupoDeEsteUsuario == null)
                //     _selctedFilter.remove(item);
                //   else
                //     _selctedFilter.remove(item);
                // }

                for (var item in values) {
                  _selctedFilter.removeWhere((element) => element.type == item.child);
                  if(item.child == "Grupo")
                  _grupos = [];
                  if(item.child == "Moneda" )
                    _monedas = [];

                }
                _historicoVentas();
              });
            },
            data: listaFiltros,
            values: _selctedFilter
          );
  }

  _myWebFilterScreen(bool isSmallOrMedium){
    return 
    isSmallOrMedium
    ?
    SizedBox.shrink()
    :
    Padding(
      padding: EdgeInsets.only(bottom: isSmallOrMedium ? 0 : 0),
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
          MyDivider(showOnlyOnLarge: true, padding: EdgeInsets.only(left: isSmallOrMedium ? 4 : 0, right: 10.0),),
        ],
      ),
    );
  }

 

 _showFilas(){
    showMyModalBottomSheet(
      context: context,
      myBottomSheet2: MyBottomSheet2(
        height: 270,
        child: Column(
          children: listaLimite.map((e) => CheckboxListTile(title: Text("$e filas"), controlAffinity: ListTileControlAffinity.leading, value: _limite == e, onChanged: (value){setState(() => _limite = e); _historicoVentas(); Navigator.pop(context);},)).toList(),
        ),
      )
    );
  }

  _reporteARetornarWidget(bool isSmallOrMedium){
    return
    MySliverButton(
      title: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            isDense: true,
            value: _reporteARetornar,
            items: listaReporteARetornar.map((e) => DropdownMenuItem(child: Text("$e filas", style: TextStyle(fontWeight: FontWeight.w600),), value: e)).toList(),
            onChanged: (value){
              setState(() {
                _reporteARetornar = value;
                _historicoVentas();
              });
            },
          ),
        ),
      ),
      // showOnlyOnLarge: true,
      onTap: (){}
    ); 
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      historicoVentas: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: _titleScreen(isSmallOrMedium),
          subtitle: _subtitle(isSmallOrMedium),
          expandedHeight: isSmallOrMedium ? 95 : 85,
          actions: [
            //  MySliverButton(
            //   title: Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //   child: Container(
            //     // width: 52,
            //     // color: Colors.grey[100],
            //     child: InkWell(
            //           onTap: _showFilas,
            //           child: Row(children: [
            //             Text("${_limite != null ? _limite.toString() + ' filas' : ''}", style: TextStyle(color: Colors.black),),
            //             Icon(Icons.arrow_drop_down, color: Colors.black)
            //           ],),
            //         ),
            //   ),
            // ),
            //   onTap: (){}
            // ),
            _reporteARetornarWidget(isSmallOrMedium),
           _limiteButton(isSmallOrMedium),
           _coinButton(isSmallOrMedium),
            // IconButton(icon: Icon(Icons.filter_alt_rounded), onPressed: _filtroScreen, color: Utils.colorPrimary,),
            MySliverButton(
              padding: EdgeInsets.all(0),
              showOnlyOnLarge: true,
              title: _dateWidget(isSmallOrMedium),
              onTap: (){}
              ),
            
          ],
        ),
        sliver:  StreamBuilder<List<Historico>>(
          stream: _streamControllerHistorio.stream,
          builder: (context, snapshot) {
            print("StreamBuilder<List<Historico>> connectionstate: ${snapshot.connectionState.toString()}");
            if(snapshot.data == null && ( isSmallOrMedium || snapshot.connectionState == ConnectionState.waiting))
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator(),));

            // if(snapshot.data == null && isSmallOrMedium == false && snapshot.connectionState == ConnectionState.active)
            //   return SliverFillRemaining(child: Column(
            //     children: [
            //       _myWebFilterScreen(isSmallOrMedium),
            //       Expanded(child: Center(child: CircularProgressIndicator(),)),
            //     ],
            //   ));

            // if(snapshot.data.length == 0 && isSmallOrMedium == false && snapshot.connectionState == ConnectionState.active)
            //   return SliverFillRemaining(child: Column(
            //     children: [
            //       _myWebFilterScreen(isSmallOrMedium),
            //       Expanded(child: Center(child: MyEmpty(title: "No hay bancas $_selectedOption", icon: Icons.home_work_sharp, titleButton: "No hay bancas",),)),
            //     ],
            //   ));

            if(snapshot.hasData && snapshot.data.length == 0 && isSmallOrMedium)
              return SliverFillRemaining(child: Center(child: MyEmpty(title: "No hay bancas $_selectedOption", icon: Icons.home_work_sharp, titleButton: "No hay bancas",),));

            if(isSmallOrMedium)
              return SliverFillRemaining(
                child: _getBodyWidget(snapshot.data, isSmallOrMedium)
              );

            var widgets = [
              _getBodyWidget(snapshot.data, isSmallOrMedium)
            ];

            if(!isSmallOrMedium){
              widgets.insert(0, _myWebFilterScreen(isSmallOrMedium));
              widgets.insert(1, MySubtitle(title: "${snapshot.data != null ? snapshot.data.length : 0} Bancas", showOnlyOnLarge: true,));
            }

            return SliverList(delegate: SliverChildBuilderDelegate(
              (context, index){
                return widgets[index];
              },
              childCount: widgets.length
            ));

            // return 
            // isSmallOrMedium
            // ?
            // SliverFillRemaining(
            //   child: _getBodyWidget(snapshot.data, isSmallOrMedium),
            // )
            // :
           
            // SliverFillRemaining(child: Column(
            //   children: [
            //   _myWebFilterScreen(isSmallOrMedium),
            //   MySubtitle(title: "${snapshot.data != null ? snapshot.data.length : 0} Bancas", showOnlyOnLarge: true,),
              
            //   Expanded(child: _getBodyWidget(snapshot.data, isSmallOrMedium))
              
            // ]));

          }
        ),
      )
    );
    
  }
}