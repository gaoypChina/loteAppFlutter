import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/dashboardservice.dart';
import 'package:loterias/ui/views/dashboard/grafica.dart';
import 'package:rxdart/rxdart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<List<Moneda>> _streamControllerMonedas;
  StreamController<List> _streamControllerGrafica;
  List<Moneda> listaMoneda = List();
  List listaVentasGrafica = List();
  List listaVentasPorLoteria = List();
  double _totalVentasLoterias = 0;
  double _totalPremiosLoterias = 0;
  List listaLoteriasJugadasDashboard = List();
  List listaJugada = List();
  List listaSorteo = List();
  int _indexMoneda = 0;
  int _indexLoteriaJugadas = 0;
  int _indexSorteo = 0;
  bool _cargando = false;
  bool _onCreate = true;
  var _fecha = DateTime.now();

  @override
  initState(){
    _streamControllerMonedas = BehaviorSubject();
    _streamControllerGrafica = BehaviorSubject();
    
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

      listaVentasGrafica = List.from(datos["ventasGrafica"]);
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

      listaVentasGrafica = List.from(datos["ventasGrafica"]);
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

  @override
  Widget build(BuildContext context) {
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
            StreamBuilder<List>(
              stream: _streamControllerGrafica.stream,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  if(snapshot.data.isEmpty)
                    return Center(child: Text("No hay datos"));
                  return Column(
                    children: <Widget>[
                      Container( height: 200, child: GroupedStackedBarChart(datosGrafica(snapshot.data)),),
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

static List<charts.Series<OrdinalSales, String>> datosGrafica(List listaVentasGrafica) {

  final desktopSalesDataA = listaVentasGrafica.map((v) => OrdinalSales(v["dia"].toString(), Utils.toDouble(v["total"].toString()))).toList();
  final tableSalesDataA = listaVentasGrafica.map((v) => OrdinalSales(v["dia"].toString(), Utils.toDouble(v["neto"].toString()))).toList();
    

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