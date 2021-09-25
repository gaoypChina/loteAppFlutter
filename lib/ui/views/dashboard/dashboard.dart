import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/graficaventas.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/dashboardservice.dart';
import 'package:loterias/ui/views/dashboard/grafica.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/mybarchart.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:rxdart/rxdart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<List<Moneda>> _streamControllerMonedas;
  StreamController<List<GraficaVentas>> _streamControllerGrafica;
  List<Moneda> listaMoneda = [];
  List<GraficaVentas> listaVentasGrafica = [];
  List listaVentasPorLoteria = [];
  double _totalVentasLoterias = 0;
  double _totalPremiosLoterias = 0;
  List listaLoteriasJugadasDashboard = [];
  List listaJugada = [];
  List listaSorteo = [];
  int _indexMoneda = 0;
  int _indexLoteriaJugadas = 0;
  int _indexSorteo = 0;
  bool _cargando = false;
  bool _onCreate = true;
  var _fecha = DateTime.now();
  DateTimeRange _date;

  @override
  initState(){
    _streamControllerMonedas = BehaviorSubject();
    _streamControllerGrafica = BehaviorSubject();
    _date = MyDate.getTodayDateRange();
    _dashboard();
    super.initState();
  }

  _dashboard() async {
    try{
      setState(() => _cargando = true);
      var datos = await DashboardService.dashboard(scaffoldKey: _scaffoldKey, fecha: _fecha);
      if(_onCreate){
        listaMoneda = datos["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList();
        _streamControllerMonedas.add(listaMoneda);
        setState(() => _onCreate = false);
      }

      listaVentasGrafica = datos["ventasGrafica"] != null ? datos["ventasGrafica"].map<GraficaVentas>((e) => GraficaVentas.fromMap(e)).toList() : [];
      listaVentasPorLoteria = List.from(datos["loterias"]);
      _totalVentasLoterias = Utils.toDouble(datos["totalVentasLoterias"].toString());
      _totalPremiosLoterias = Utils.toDouble(datos["totalPremiosLoterias"].toString());
      listaLoteriasJugadasDashboard = (datos["loteriasJugadasDashboard"] != null) ? List.from(datos["loteriasJugadasDashboard"]) : List();
      listaSorteo = List.from(datos["sorteos"]);
      if(listaSorteo != null)
        _cambiarValorListaJugada(listaSorteo[_indexSorteo]["descripcion"]);
      
      _streamControllerGrafica.add(listaVentasGrafica);
      setState(() => _cargando = false);
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  _dashboardMoneda() async {
    try{
      setState(() => _cargando = true);
      var datos = await DashboardService.dashboard(scaffoldKey: _scaffoldKey, fecha: _fecha, idMoneda: listaMoneda[_indexMoneda].id);
      if(_onCreate){
        listaMoneda = datos["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList();
        _streamControllerMonedas.add(listaMoneda);
        setState(() => _onCreate = false);
      }

      listaVentasGrafica = datos["ventasGrafica"] != null ? datos["ventasGrafica"].map<GraficaVentas>((e) => GraficaVentas.fromMap(e)).toList() : [];
      listaVentasPorLoteria = List.from(datos["loterias"]);
      _totalVentasLoterias = Utils.toDouble(datos["totalVentasLoterias"].toString());
      _totalPremiosLoterias = Utils.toDouble(datos["totalPremiosLoterias"].toString());
      listaLoteriasJugadasDashboard = (datos["loteriasJugadasDashboard"] != null) ? List.from(datos["loteriasJugadasDashboard"]) : List();
      listaSorteo = List.from(datos["sorteos"]);
      if(listaSorteo != null)
        _cambiarValorListaJugada(listaSorteo[_indexSorteo]["descripcion"]);
      
      _streamControllerGrafica.add(listaVentasGrafica);
      setState(() => _cargando = false);
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  _cambiarValorListaJugada(String sorteo){
    if(listaLoteriasJugadasDashboard.length == 0)
      return;
    List sorteosLoteriasJugadas = List.from(listaLoteriasJugadasDashboard[_indexLoteriaJugadas]["sorteos"]);
    if(sorteosLoteriasJugadas != null){
      Map<String, dynamic> sort = sorteosLoteriasJugadas.firstWhere((s) => s["descripcion"] == sorteo);
      if(sort != null)
        setState(() => listaJugada = List.from(sort["jugadas"]));
    }
  }

  _dateChanged(var date){
    if(date != null && date == DateTime)
      setState(() {
        _date = DateTimeRange(
          start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00"),
          end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59")
        );
        _dashboard();
      });
    else
      _date = date;
  }

   _dateDialog() async {
    var date = await showDatePicker(context: context, initialDate: _date.start, firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime(DateTime.now().year + 5));
    _dateChanged(date);
    
  }

  _subtitle(bool isSmallOrMedium){
    return
    isSmallOrMedium
    ?
    SingleChildScrollView(
      child: MyCollapseChanged(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              MyFilter(
                filterTitle: '',
                filterLeading: SizedBox.shrink(),
                leading: SizedBox.shrink(),
                value: _date, 
                onChanged: _dateChanged,
                showListNormalCortaLarga: 2,
              ),
              // _mysearch()
            ]
          ),
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
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Dashboard",
          subtitle: _subtitle(isSmallOrMedium),
          expandedHeight: isSmallOrMedium ? 105 : 85,
          actions: [
             MySliverButton(
              // showOnlyOnLarge: true,
              showOnlyOnSmall: true,
              title: Container(
                width: 120,
                // width: 140,
              height: 37,
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
              decoration: BoxDecoration(
              color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)
              ),
                child: Builder(
                  builder: (context) {
                    return InkWell(
                    onTap: _dateDialog,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Icon(Icons.date_range),
                        Expanded(child: Center(child: Text("${MyDate.dateRangeToNameOrString(_date)}", style: TextStyle(color: Colors.black), overflow: TextOverflow.ellipsis, softWrap: true,))),
                        Icon(Icons.arrow_drop_down, color: Colors.black)
                      ],),
                    ),
                  );
                  }
                ),
              ), 
              onTap: (){}
              ),
          ],
        ), 
        sliver: StreamBuilder<Object>(
          stream: _streamControllerGrafica.stream,
          builder: (context, snapshot) {
            if(snapshot.data == null && (isSmallOrMedium || listaVentasGrafica == null))
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()),);

            return SliverFillRemaining(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    child: MyBarchar(
                      leftLabelDivider: 2,
                      borderRadius: BorderRadius.circular(2),
                      type: MyBarType.stack,
                      listOfBottomLabel: [Text("Trasan", style: TextStyle(fontSize: 10),), Text("Antesayer", style: TextStyle(fontSize: 10)), Text("Ayer", style: TextStyle(fontSize: 10)), Text("Hoy", style: TextStyle(fontSize: 10))],
                      listOfData: [
                        [MyBar(value: 20, color: Colors.grey), MyBar(value: 10, color: Colors.green)],
                        [MyBar(value: 30, color: Colors.grey), MyBar(value: 15, color: Colors.green)],
                        [MyBar(value: 50, color: Colors.grey), MyBar(value: 45, color: Colors.green)],
                        [MyBar(value: 20, color: Colors.grey), MyBar(value: 12, color: Colors.green)],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        )
      )
    );
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
        child: ListView(
          children: <Widget>[
            Wrap(
              spacing: 12,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: RaisedButton(
                      elevation: 0, 
                      color: Colors.transparent, 
                      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
                      child: Text("${_fecha.year}-${_fecha.month}-${_fecha.day}", style: TextStyle(fontSize: 16)),
                      onPressed: () async {
                        DateTime fecha = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                        setState((){ 
                          _fecha = (fecha != null) ? fecha : _fecha;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: StreamBuilder<List<Moneda>>(
                    stream: _streamControllerMonedas.stream,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return DropdownButton<Moneda>(
                          isExpanded: true,
                          value: snapshot.data[_indexMoneda],
                          items: snapshot.data.map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(m.abreviatura, style: TextStyle(color: Utils.fromHex(m.color)),),
                          )).toList(), 
                          onChanged: (Moneda moneda){
                            int idx = snapshot.data.indexWhere((m) => m.id == moneda.id);
                            setState(() {
                              _indexMoneda = idx;
                            });
                          }
                        );
                      }

                      return DropdownButton(
                        value: "No hay datos",
                        items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], 
                        onChanged: (data){}
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: RaisedButton(
                    elevation: 0,
                    color: Utils.fromHex("#e4e6e8"),
                    child: Icon(Icons.search, color: Utils.colorPrimary,),
                    onPressed: (){
                      _dashboardMoneda();
                    },
                  ),
                ),
              ],
            ),
            StreamBuilder<List<GraficaVentas>>(
              stream: _streamControllerGrafica.stream,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  if(snapshot.data.isEmpty)
                    return Center(child: Text("No hay datos"));
                  return Column(
                    children: <Widget>[
                      Container( height: 200, child: GroupedStackedBarChart(datosGrafica(snapshot.data)),),
                      // Container( 
                      //   height: 200, 
                      //   child: MyBarchar(
                      //     medium: 1,
                      //     listOfBottomLabel: snapshot.data.map((e) => Text(e.dia)).toList(),
                      //     leftLabelDivider: 5,
                      //     listOfData: snapshot.data.map((e) => [MyBar(value: e.total, color: Colors.grey[50]), MyBar(value: e.neto, color: e.neto >= 0 ? Colors.green : Colors.pink)]).toList(),
                      //   ),
                      // ),
                      Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 15),
                          child: Center(child: Text("Totales por loteria", style: TextStyle(fontSize: 25),),),
                        ),
                      _buildTableVentasPorLoteria(listaVentasPorLoteria),
                       _buildJugadasRealizadas()
                    ],
                  );
                }

                return Center(child: Text("No hay datos"));
              },
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildJugadasRealizadas()
  {
    if(listaLoteriasJugadasDashboard == null)
      return SizedBox();
    if(listaLoteriasJugadasDashboard.length == 0)
      return SizedBox();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 15),
          child: Center(child: Text("Jugadas realizadas", style: TextStyle(fontSize: 25),),),
        ),
        DropdownButton<String>(
          value: listaLoteriasJugadasDashboard[_indexLoteriaJugadas]["descripcion"],
          items: listaLoteriasJugadasDashboard.map((l) => DropdownMenuItem<String>(
            value: l["descripcion"],
            child: Text(l["descripcion"])
          )).toList(), 
          onChanged: (String loteria){
            int idx = listaLoteriasJugadasDashboard.indexWhere((s) => s["descripcion"] == loteria);
            setState(() => _indexLoteriaJugadas = idx);
            _cambiarValorListaJugada(listaSorteo[_indexSorteo]["descripcion"]);
          }
        ),
        DropdownButton<String>(
          value: listaSorteo[_indexSorteo]["descripcion"],
          items: listaSorteo.map((s) => DropdownMenuItem<String>(
            value: s["descripcion"],
            child: Text(s["descripcion"])
          )).toList(), 
          onChanged: (String sorteo){
            int idx = listaSorteo.indexWhere((s) => s["descripcion"] == sorteo);
            if(idx != -1){
              setState(() => _indexSorteo = idx);
              print("Changed sorteos: ${listaSorteo[_indexSorteo]}");
              _cambiarValorListaJugada(sorteo);
            }
          }
        ),
        _buildTableLoteriasJugadasDashboard()
      ],
    );
  }

static List<charts.Series<OrdinalSales, String>> datosGrafica(List<GraficaVentas> listaVentasGrafica) {

  final desktopSalesDataA = listaVentasGrafica.map((v) => OrdinalSales(v.dia, Utils.toDouble(v.total.toString()))).toList();
  final tableSalesDataA = listaVentasGrafica.map((v) => OrdinalSales(v.dia.toString(), Utils.toDouble(v.neto.toString()))).toList();
    

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop A',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesDataA,
        labelAccessorFn: (OrdinalSales sales, _) => sales.sales.toString(),
        insideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = charts.MaterialPalette.black;
          return new charts.TextStyleSpec(color: color, fontSize: 30);
        },
        outsideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = charts.MaterialPalette.black;
          return new charts.TextStyleSpec(color: color, fontSize: 7);
        },
        colorFn: (OrdinalSales sales, _) => charts.Color.fromHex(code: "#95999e"),
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet A',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesDataA,
        labelAccessorFn: (OrdinalSales sales, _) => sales.sales.toString(),
        insideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = charts.MaterialPalette.black;
          return new charts.TextStyleSpec(color: color, fontSize: 30);
        },
        outsideLabelStyleAccessorFn: (OrdinalSales sales, _) {
          final color = charts.MaterialPalette.black;
          return new charts.TextStyleSpec(color: color, fontSize: 7);
        },
        colorFn: (OrdinalSales sales, _) => sales.sales > 0 ? charts.Color.fromHex(code: "#75b281") : charts.Color.fromHex(code: "#dc2365"),
      ),
    ];
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
                  child: Center(child: Text("${b["ventas"] == null ? Utils.toCurrency('0') : Utils.toCurrency(b["ventas"])}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["premios"] == null ? Utils.toCurrency('0') : Utils.toCurrency(b["premios"])}", style: TextStyle(fontSize: 16)))
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
                    child: Center(child: Text('Ventas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Premios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
                  // ),
                ]
              )
              );

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
                    child: Center(child: Text('${Utils.toCurrency(_totalVentasLoterias)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('${Utils.toCurrency(_totalPremiosLoterias)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Utils.colorPrimary)),),
                  ),
                ]
              )
              );
        
   }

   return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: <int, TableColumnWidth>{0 : FractionColumnWidth(.35)},
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

  // Widget _buildJugadasRealizadas()
  // {
  //   if(listaLoteriasJugadasDashboard == null)
  //     return SizedBox();
  //   if(listaLoteriasJugadasDashboard.length == 0)
  //     return SizedBox();

  //   return Column(
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.only(top: 20, bottom: 15),
  //         child: Center(child: Text("Jugadas realizadas", style: TextStyle(fontSize: 25),),),
  //       ),
  //       DropdownButton<String>(
  //         value: listaLoteriasJugadasDashboard[_indexLoteriaJugadas]["descripcion"],
  //         items: listaLoteriasJugadasDashboard.map((l) => DropdownMenuItem<String>(
  //           value: l["descripcion"],
  //           child: Text(l["descripcion"])
  //         )).toList(), 
  //         onChanged: (String loteria){
  //           int idx = listaLoteriasJugadasDashboard.indexWhere((s) => s["descripcion"] == loteria);
  //           setState(() => _indexLoteriaJugadas = idx);
  //           _cambiarValorListaJugada(listaSorteo[_indexSorteo]["descripcion"]);
  //         }
  //       ),
  //       DropdownButton<String>(
  //         value: listaSorteo[_indexSorteo]["descripcion"],
  //         items: listaSorteo.map((s) => DropdownMenuItem<String>(
  //           value: s["descripcion"],
  //           child: Text(s["descripcion"])
  //         )).toList(), 
  //         onChanged: (String sorteo){
  //           int idx = listaSorteo.indexWhere((s) => s["descripcion"] == sorteo);
  //           if(idx != -1){
  //             setState(() => _indexSorteo = idx);
  //             print("Changed sorteos: ${listaSorteo[_indexSorteo]}");
  //             _cambiarValorListaJugada(sorteo);
  //           }
  //         }
  //       ),
  //       _buildTableLoteriasJugadasDashboard()
  //     ],
  //   );
  // }

  Widget _buildTableLoteriasJugadasDashboard(){
   var tam = (listaJugada != null) ? listaJugada.length : 0;
   List<TableRow> rows;
   if(tam == 0){
     rows = <TableRow>[];
   }else{
     rows = listaJugada.asMap().map((idx, b)
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
                  child: Center(child: Text("${b["jugada"] == null ? '0' : b["jugada"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["monto"] == null ? '0' : b["monto"]}", style: TextStyle(fontSize: 16)))
                ),
              ],
            )
          )
        
        ).values.toList();
        
    rows.insert(0, 
              TableRow(
                decoration: BoxDecoration(color: Utils.colorInfo),
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
                    child: Center(child: Text('Jugada', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
                    child: Center(child: Text('Monto', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
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
          child: 
            (rows.length == 0)
            ? Text("No hay datos", style: TextStyle(fontSize: 20),)
            :
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: <int, TableColumnWidth>{0 : FractionColumnWidth(.35)},
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

}

class OrdinalSales {
  final String year;
  final double sales;

  OrdinalSales(this.year, this.sales);
}