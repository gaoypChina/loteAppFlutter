import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/monitoreo.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/services/reporteservice.dart';
import 'package:loterias/core/services/ticketservice.dart';
import 'package:loterias/ui/views/reportes/ticketssearch.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mycirclebutton.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydescripcion.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilterv2.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/showmymodalbottomsheet.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';
import 'package:rxdart/rxdart.dart';

class TicketsPendientesPagoScreen extends StatefulWidget {
  @override
  _TicketsPendientesPagoScreenState createState() => _TicketsPendientesPagoScreenState();
}

class _TicketsPendientesPagoScreenState extends State<TicketsPendientesPagoScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTimeRange _date;
  bool _cargando = false;
  bool _onCreate = true;
  bool _ckbTodasLasFechas = false;
  List<Banca> listaBanca = [];
  int _idBanca = 0;
  int _indexBanca = 0;
  List lista = [];
  StreamController<List<Banca>> _streamControllerBancas;
  StreamController<List> _streamControllerTabla;
  String _fechaString;
  DateTime _fechaActual = DateTime.now();
  int _idGrupoDeEsteUsuario;
  Banca _banca;
  Future<void> _future;
  var _txtSearch = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _streamControllerBancas = BehaviorSubject();
    _streamControllerTabla = BehaviorSubject();
    _fechaString = "${_fechaActual.year}-${_fechaActual.month}-${_fechaActual.day}";
    _future = _init();
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
    // _streamControllerTabla.close();
    super.dispose();

  }

  _init() async {
    try{
      // setState(() => _cargando = true);
      List<DateTime> fechasDeEstaSemana = MyDate.getEstaSemana();
      _date = DateTimeRange(start: fechasDeEstaSemana[0], end: fechasDeEstaSemana[1]);
      _idGrupoDeEsteUsuario = await Db.idGrupo();
      // var datos = await ReporteService.ticketsPendientesPago(fechaString: _fechaString, idBanca: await Db.idBanca(), scaffoldKey: _scaffoldKey, idGrupo: await Db.idGrupo(), retornarBancas: true);
      var datos = await ReporteService.ticketsPendientesPago(fecha: _date, idBanca: await null, scaffoldKey: _scaffoldKey, idGrupo: await Db.idGrupo(), retornarBancas: true);
      if(_onCreate && datos != null){
        List list = List.from(datos["bancas"]);
        listaBanca = list.map((b) => Banca.fromMap(b)).toList();
        listaBanca.insert(0, Banca.getBancaTodas);
        if(listaBanca.length > 0)
          _idBanca = listaBanca[0].id;
          _banca = listaBanca[0];
        _streamControllerBancas.add(listaBanca);
        _onCreate = false;
      }
      lista = datos["ticketsPendientesDePago"];
      _streamControllerTabla.add(lista);
      // setState(() => _cargando = false);
    }on Exception catch(e){
      // setState(() => _cargando = false);
      _streamControllerTabla.addError(e.toString());
    }
  }

  

  
  _tickets() async {
    try{
      setState(() => _cargando = true);
      // var datos = await ReporteService.ticketsPendientesPago(fechaString: _fechaString, idBanca: _idBanca, scaffoldKey: _scaffoldKey, idGrupo: _idGrupoDeEsteUsuario);
      var datos = await ReporteService.ticketsPendientesPago(fecha: _date, idBanca: _idBanca, scaffoldKey: _scaffoldKey, idGrupo: _idGrupoDeEsteUsuario);
      if(_onCreate && datos != null){
        List list = List.from(datos["bancas"]);
        listaBanca = list.map((b) => Banca.fromMap(b)).toList();
        listaBanca.insert(0, Banca(id: 0, descripcion: "Todas las bancas"));
        _streamControllerBancas.add(listaBanca);
        _onCreate = false;
      }
      lista = datos["ticketsPendientesDePago"];
      _streamControllerTabla.add(lista);
      setState(() => _cargando = false);
    }on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  _showTicket(String codigoBarra, BuildContext context, isSmallOrMedium) async {
    try{
      setState(()=> _cargando = true);
      // var datos = await TicketService.ticket(scaffoldKey: _scaffoldKey, idTicket: idTicket);
      var datos = await TicketService.buscarTicketAPagar(context: context, codigoBarra: codigoBarra);
      setState(()=> _cargando = false);
      print("_showTicket datos: ${datos["venta"]}");
      Monitoreo.showDialogVerTicket(context: context, mapVenta: datos["venta"], isSmallOrMedium: isSmallOrMedium);
    }on Exception catch(e){
      setState(()=> _cargando = false);
    }
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
                    child: Center(child: Text('Banca', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
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
   }else{
     rows = map.asMap().map((idx, b)
          => MapEntry(
            idx,
            TableRow(
              
              children: [
                InkWell(
                  onTap: (){
                    _showTicket(b["codigoBarra"], context, true);
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
                  child: Center(child: Text("${b["banca"]["descripcion"]}", style: TextStyle(fontSize: 16)))
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Utils.colorGreyFromPairIndex(idx: idx), 
                  child: Center(child: Text("${b["montoAPagar"]}", style: TextStyle(fontSize: 16)))
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
                    child: Center(child: Text('Banca', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),),
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
              columnWidths: <int, TableColumnWidth>{7 : FractionColumnWidth(.28)},
              children: rows,
             ),
        ),
      ],
    ),
  );
  
 }

 _bancaChanged(Banca banca){
  setState(() {
    _banca = banca;
    _idBanca = banca.id;
    _tickets();
  });
  
 }

//  _dateChanged(var date){
//     print("Hola");
//     // if(date == null)
//     //   return;

//     if(date != null && date is DateTime)
//       setState(() {
//         _date = DateTimeRange(
//           start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00"),
//           end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59")
//         );
//         _tickets();
//       });
//     else
//      setState((){
//         _date = date;
//         _tickets();
//      });

//   }

_dateChanged(DateTimeRange value){
  setState(() {_date = value; _tickets();});
}


//  _dateDialog() async {
//     var date = await showDatePicker(
//       context: context, 
//       initialDate: _date != null ? _date.start : DateTime.now(), 
//       firstDate: DateTime(DateTime.now().year - 5), 
//       lastDate: DateTime(DateTime.now().year + 5),
//     );
//     _dateChanged(date);
    
//   }

  _search(String data){
    // _txtSearch
    _streamControllerTabla.add(lista.where((element) => element["idTicket"].toString().indexOf(data) != -1).toList());
  }

  _circularProgressBarIndicator(){
    return Center(child: CircularProgressIndicator());
  }

  _columns(bool isSmallOrMedium){
    return isSmallOrMedium ? ["# de ticket", "A pagar", "Fecha"] : ["Numero de ticket", "Banca", "A pagar", "Fecha"];
  }

  List<List> _rows(AsyncSnapshot<List<dynamic>> snapshot, bool isSmallOrMedium){
    return 
    isSmallOrMedium
    ?
     snapshot.data.map((e) => [e, Text("${Utils.toSecuencia(e["primera"], BigInt.from(e["idTicket"]), false)}", style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),), e["montoAPagar"], e["fecha"]]).toList()
     :
     snapshot.data.map((e) => [e, Text("${Utils.toSecuencia(e["primera"], BigInt.from(e["idTicket"]), false)}", style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),), e["banca"]["descripcion"], e["montoAPagar"], e["fecha"]]).toList();
  }

  dynamic _dateWidget(bool isSmallOrMedium){
    if(isSmallOrMedium)
    return MyCircleButton(
      child: _date == null ? 'Todas las fechas' : MyDate.dateRangeToNameOrString(_date), 
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

    _subtitle(bool isSmallOrMedium){
    return
    isSmallOrMedium
    ?
    Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: MyCollapseChanged(
        child: FutureBuilder<void>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SizedBox.shrink();

            return Row(
              children: [
                _dateWidget(isSmallOrMedium),
                Expanded(
                  child: MyFilterV2(
                    item: [
                      MyFilterItem(
                        hint: "${_banca != null ? 'Banca: ' + _banca.descripcion: 'Banca...'}", 
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
        )
      ),
    )
    :
    "Aqui podrá ver todos los tickets pendientes de pago";
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
          title: "Pendientes de pago",
          expandedHeight: isSmallOrMedium ? 110 : 85,
          subtitle: _subtitle(isSmallOrMedium),
          actions: [
            MySliverButton(
              showOnlyOnSmall: true,
              title: IconButton(
              icon: Icon(Icons.search, color: Colors.black,),
              onPressed: () async{
                var data = await showSearch(context: context, delegate: TicketsSearch(lista));
                if(data == null)
                  return;
                _showTicket(data["codigoBarra"], context, isSmallOrMedium);
              },
            )),
            MySliverButton(
              showOnlyOnLarge: true,
              title: Container(
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FutureBuilder<Object>(
                    future: _future,
                    builder: (context, snapshot) {
                      if(snapshot.connectionState != ConnectionState.done)
                        return SizedBox.shrink();

                      
                      return MyDropdown(
                        title: null,
                        textColor: Colors.grey[600],
                        color: Colors.grey[600],
                        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                        isFlat: true,
                        hint: "${_banca != null ? 'Banca: ' + _banca.descripcion : 'Selec. banca'}",
                        elements: listaBanca.map((e) => [e, e.descripcion]).toList(),
                        onTap: _bancaChanged,
                      );
                    }
                  ),
                ),
              ), 
              onTap: null
            ),
            MySliverButton(
              showOnlyOnLarge: true,
              title: _dateWidget(isSmallOrMedium), 
              onTap: (){}
              )
            
          ],
        ),
        sliver: StreamBuilder<List>(
          stream: _streamControllerTabla.stream,
          builder: (context, snapshot) {
            if(snapshot.data == null && (isSmallOrMedium || snapshot.connectionState == ConnectionState.waiting))
              return SliverFillRemaining(child: _circularProgressBarIndicator(),);

            if(snapshot.hasError)
              return SliverFillRemaining(child: MyEmpty(title: "${snapshot.error}", titleButton: "Cargar nuevamente", onTap: (){_init();}),);
              
              
            List<Widget> widgets = [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: MyDescripcon(title: "${snapshot.data != null ? snapshot.data.length : 0} Filas", color: Colors.black, fontSize: 20,),
                  ),
                  Visibility(
                    visible: !isSmallOrMedium,
                    child: Container(
                      width: !isSmallOrMedium ? MediaQuery.of(context).size.width / 3 : null,
                      child: Padding(
                        padding: EdgeInsets.only(right: isSmallOrMedium ? 0 : 15.0, top: 0.0, bottom: !isSmallOrMedium ? 20 : 0),
                        child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar ticket...", small: 2.6, medium: 2.6, xlarge: 2.6, contentPadding: isSmallOrMedium ? EdgeInsets.only(bottom: 10, top: 10) : EdgeInsets.only(bottom: 15, top: 15),),
                      ),
                    ),
                  ),
                ],),
              ),
              snapshot.data == null
              ?
              _circularProgressBarIndicator()
              :
              snapshot.data.isEmpty
              ?
              Center(child: MyEmpty(title: "No hay tickets pendientes de pago", icon: Icons.attach_money, titleButton: "Cargar nuevamente", onTap: (){_tickets();}))
              :
               Padding(
                 padding: EdgeInsets.only(left: isSmallOrMedium ? 8.0 : 0.0, right: isSmallOrMedium ? 8.0 : 18.0),
                 child: MyTable(
                    isScrolled: false,
                    headerColor: Theme.of(context).primaryColor,
                    headerTitleColor: Colors.white,
                    columns: _columns(isSmallOrMedium),
                    rows: snapshot.data == null ? [[]] : _rows(snapshot, isSmallOrMedium),
                    onTap: (element) => _showTicket(element["codigoBarra"], context, isSmallOrMedium),
                  ),
               )
            ];

            return SliverList(delegate: SliverChildBuilderDelegate(
              (context, index) => widgets[index],
              childCount: widgets.length
            ));
          }
        ),
      )
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Pendientes pago", style: TextStyle(color: Colors.black),),
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
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3 - 40,
                  child: Row(
                    children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RaisedButton(
                            elevation: 0, 
                            color: Colors.transparent, 
                            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
                            child: Text("${_fechaString}", style: TextStyle(fontSize: 16)),
                            onPressed: () async {
                              DateTime fecha = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                              setState(() => _fechaString = (fecha != null) ? "${fecha.year}-${fecha.month}-${fecha.day}" : _fechaString);
                            },
                          ),
                        ),
                        Checkbox(value: _ckbTodasLasFechas, onChanged: (bool check) {
                          if(check)
                            setState((){_fechaString = "Todas las fechas"; _ckbTodasLasFechas = check;});
                          else
                            setState((){_fechaString = "${_fechaActual.year}-${_fechaActual.month}-${_fechaActual.day}"; _ckbTodasLasFechas = check;});
                        })
                      ],
                    ),
                ),
                
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3 + 20,
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
                            setState(() {
                              _indexBanca = listaBanca.indexWhere((b) => b.descripcion == banca.descripcion);
                              _idBanca = listaBanca[_indexBanca].id;
                            });
                          },
                        );
                      }

                      return DropdownButton(value: "No hay datos", items: [DropdownMenuItem(value: "No hay datos", child: Text("No hay datos"),)], onChanged: null);
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3 - 40,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: RaisedButton(
                      elevation: 0,
                      color: Utils.fromHex("#e4e6e8"),
                      child: Text("Buscar", style: TextStyle(color: Utils.colorPrimary),),
                      onPressed: (){
                        // _ventas();
                        _tickets();
                      },
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder<List>(
                  stream: _streamControllerTabla.stream,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return _buildTableTicketsGanadores(snapshot.data);
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