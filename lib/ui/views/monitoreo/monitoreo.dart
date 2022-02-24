import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/monitoreo.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/ticketimage.dart';
import 'package:loterias/core/classes/ticketimagev2.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/sale.dart';
import 'package:loterias/core/models/salesdetails.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/models/ventas.dart';
import 'package:loterias/core/services/bancaservice.dart';
import 'package:loterias/core/services/bluetoothchannel.dart';
import 'package:loterias/core/services/sharechannel.dart';
import 'package:loterias/core/services/ticketservice.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mydaterangedialog.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilter.dart';
import 'package:loterias/ui/widgets/myfilter2.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/showmymodalbottomsheet.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';
import 'package:rxdart/rxdart.dart';

class MonitoreoScreen extends StatefulWidget {
  @override
  _MonitoreoScreenState createState() => _MonitoreoScreenState();
}

class _MonitoreoScreenState extends State<MonitoreoScreen> {
  var _txtSearch = TextEditingController();
  var _myFilterKey = GlobalKey<MyFilter2State>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<List<Banca>> _streamControllerBanca;
  DateTime _fecha = DateTime.now();
  DateTimeRange _date;
  List<Banca> listaBanca = [];
  List<Loteria> listaLoteria = [];
  Future<bool> listaBancaFuture;
  StreamController<List<Venta>> _streamControllerMonitoreo;
  bool _tienePermisoMonitoreo = false;
  bool _tienePermisoJugarComoCualquierBanca = false;
  bool _tienePermisoCancelarCualquierMomento = false;
  bool _cargando = false;
  int _indexBanca = 0;
  List<Venta> _listaVenta;
  List<Venta> _tmpListaVenta;
  List<List<dynamic>> listaTipoTicket = [[-1, "Todos los tickets"], [1, "Pendientes"], [2, "Ganadores"], [3, "Perdedores"], [0, "Cancelados"]];
  List<dynamic> _tipoTicket;
  List<MyFilterData2> listaFiltro = [];
  List<MyFilterSubData2> _filtros = [];
  Banca _banca;
  Grupo _grupo;
  Loteria _loteria;
  int _idBancaDeEsteUsuario;

  _getDefaultDateRange(){
    return DateTimeRange(
      start:  DateTime.parse("${_fecha.year}-${Utils.toDosDigitos(_fecha.month.toString())}-${Utils.toDosDigitos(_fecha.day.toString())} 00:00"), 
      end: DateTime.parse("${_fecha.year}-${Utils.toDosDigitos(_fecha.month.toString())}-${Utils.toDosDigitos(_fecha.day.toString())} 23:59:59")
    );
  }

  @override
  initState() {
    // TODO: implement initState
    initializeDateFormatting();
  _streamControllerMonitoreo = BehaviorSubject();
  _streamControllerBanca = BehaviorSubject();
  _tipoTicket = listaTipoTicket[0];
    _init();
    // listaBancaFuture = _futureBancas();
    super.initState();
  }

  @override
  dispose(){
    super.dispose();
  }

  _getBanca() async {
    var banca = await Db.getBanca();
    if(banca != null)
      _banca = Banca.fromMap(banca);
    else{
      if(listaBanca == null)
        return;

      if(listaBanca.length == 0)
        return;

      _banca = listaBanca[0];
    }
  }

  // Future<bool> _futureBancas() async{
  //   listaBanca = await BancaService.all(scaffoldKey: _scaffoldKey);
  //   _seleccionarBancaPertenecienteAUsuario();
  //   return true;
  // }

  Future _confirmarTienePermiso() async {
   _tienePermisoMonitoreo = await Db.existePermiso("Monitorear ticket");
   _tienePermisoJugarComoCualquierBanca = await Db.existePermiso("Jugar como cualquier banca");
   _tienePermisoCancelarCualquierMomento = await Db.existePermiso("Cancelar tickets en cualquier momento");
  }

  _init() async {
   try{
    //  setState(() => _cargando = true);
    _date = MyDate.getTodayDateRange();
    await _confirmarTienePermiso();
    print("_getMonitoreo fechaInicial: ${_date.start.toString()}");
    print("_getMonitoreo fechaFinal: ${_date.end.toString()}");
    _idBancaDeEsteUsuario = await Db.idBanca();
    var parsed = await TicketService.monitoreoV2(scaffoldKey: _scaffoldKey, fecha: _date.start, fechaFinal: _date.end, idBanca: _idBancaDeEsteUsuario, retornarBancas: true, idGrupo: await Db.idGrupo());
    print("MonitoreoScreen _init parsed: ${parsed["bancas"]}");
    _listaVenta = parsed["monitoreo"].map<Venta>((json) => Venta.fromMap(json)).toList();
    listaBanca = parsed["bancas"].map<Banca>((json) => Banca.fromMap(json)).toList();
    listaLoteria = parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList();
    _seleccionarBancaPertenecienteAUsuario();
    _tmpListaVenta = _listaVenta.map((v) => v).toList();;
    _streamControllerMonitoreo.add(_listaVenta.where((element) => element.status != 0).toList());
    _streamControllerBanca.add(listaBanca);
    _getBanca();


    if(listaBanca.length > 0 && _tienePermisoJugarComoCualquierBanca){
      var filtro = MyFilterData2(child: "Banca", data: listaBanca.map((e) => MyFilterSubData2(child: e.descripcion, value: e)).toList());
      listaFiltro.add(filtro);
    }

    if(listaLoteria.length > 0){
      var filtro = MyFilterData2(child: "Loteria", data: listaLoteria.map((e) => MyFilterSubData2(child: e.descripcion, value: e)).toList());
      listaFiltro.add(filtro);
    }

    if(listaLoteria.length > 0){
      var filtro = MyFilterData2(child: "Estado ticket", data: listaTipoTicket.map((e) => MyFilterSubData2(child: e[1], value: e)).toList());
      listaFiltro.add(filtro);
    }


    // setState(() => _cargando = false);
   } on Exception catch(e){
      // setState(() => _cargando = false);
    _streamControllerMonitoreo.add([]);
   }
  }

  _getMonitoreo() async {
   try{
    //  setState(() => _cargando = true);
    _streamControllerMonitoreo.add(null);
    print("_getMonitoreo fechaInicial: ${_date.start.toString()}");
    print("_getMonitoreo fechaFinal: ${_date.end.toString()}");
    int idBanca = (_tienePermisoJugarComoCualquierBanca && listaBanca != null) ? _banca != null ? _banca.id : await Db.idBanca() : await Db.idBanca();
    print("MonitoreoScreen _getMonitoreo idBanca: $idBanca, _tienePermisoJugarComoCualquierBanca: $_tienePermisoJugarComoCualquierBanca");
    var parsed = await TicketService.monitoreoV2(scaffoldKey: _scaffoldKey, fecha: _date.start, fechaFinal: _date.end, idBanca: idBanca, idLoteria: _loteria != null ? _loteria.id : null);
    _listaVenta = parsed["monitoreo"].map<Venta>((json) => Venta.fromMap(json)).toList();
    _tmpListaVenta = _listaVenta.map((v) => v).toList();;
    _streamControllerMonitoreo.add(_listaVenta.where((element) => element.status != 0).toList());
    // setState(() => _cargando = false);
   } on Exception catch(e){
      // setState(() => _cargando = false);
    _streamControllerMonitoreo.add([]);
   }
  }

  _seleccionarBancaPertenecienteAUsuario() async {
  var bancaMap = await Db.getBanca();
  Banca banca = (bancaMap != null) ? Banca.fromMap(bancaMap) : null;
  if(banca != null && listaBanca != null){
    int idx = listaBanca.indexWhere((b) => b.id == banca.id);
    // print('_seleccionarBancaPertenecienteAUsuario idx: $idx : ${listaBanca.length}');
    _indexBanca = (idx != -1) ? idx : 0;
  }else{
    setState(() =>_indexBanca = 0);
  }

  // print('seleccionarBancaPerteneciente: $_indexBanca : ${banca.descripcion} : ${listaBanca.length}');
}

  Widget _buildTable(List<Venta> ventas, Banca banca){
   var tam = ventas.length;
   List<TableRow> rows;
   if(tam == 0){
     rows = <TableRow>[];
   }else{
     rows = ventas.map((v)
          => TableRow(
            children: [
              Center(
                child: InkWell(onTap: (){Monitoreo.showDialogImprimirCompartir(venta: v, context: context);}, child: Text(Utils.toSecuencia(banca.codigo, v.idTicket, false), style: TextStyle(fontSize: 16, decoration: TextDecoration.underline)))
              ),
              Center(child: Text(v.total.toString(), style: TextStyle(fontSize: 16))),
              Center(child: IconButton(icon: Icon(Icons.delete, size: 28,), onPressed: () async {
                bool cancelar = await TicketService.showDialogAceptaCancelar(context: context, ticket: Utils.toSecuencia(banca.codigo, v.idTicket, false));
                if(cancelar){
                  if(_tienePermisoCancelarCualquierMomento){
                    bool imprimir = await TicketService.showDialogDeseaImprimir(context: context);
                    if(imprimir){
                       if(await Utils.exiseImpresora() == false){
                        Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: "Debe registrar una impresora");
                        return;
                      }

                      if(!(await BluetoothChannel.turnOn())){
                        return;
                      }

                      try{
                        setState(() => _cargando = true);
                        var datos = await TicketService.cancelar(scaffoldKey: _scaffoldKey, codigoBarra: v.codigoBarra);
                        await BluetoothChannel.printTicket(datos["ticket"], BluetoothChannel.TYPE_CANCELADO);
                        setState(() => _cargando = false);
                        Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: datos["mensaje"]);
                      } on Exception catch(e){
                        setState(() => _cargando = false);
                      }
                    }else{
                      try{
                        setState(() => _cargando = true);
                        var datos = await TicketService.cancelar(scaffoldKey: _scaffoldKey, codigoBarra: v.codigoBarra);
                        setState(() => _cargando = false);
                        Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: datos["mensaje"]);
                      }on Exception catch(e){
                        setState(() => _cargando = false);
                      }
                    }
                  }else{

                    if(await Utils.exiseImpresora() == false){
                      Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: "Debe registrar una impresora");
                      return;
                    }

                    if(!(await BluetoothChannel.turnOn())){
                      return;
                    }
                    try{
                      setState(() => _cargando = true);
                      var datos = await TicketService.cancelar(scaffoldKey: _scaffoldKey, codigoBarra: v.codigoBarra);
                      setState(() => _cargando = false);
                      await BluetoothChannel.printTicket(datos["ticket"], BluetoothChannel.TYPE_CANCELADO);
                      Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: datos["mensaje"]);
                    } on Exception catch(e){
                      setState(() => _cargando = false);
                    }
                  }
                  await _getMonitoreo();
                }
              },)),
            ],
          )
        
        ).toList();
        
    rows.insert(0, 
              TableRow(
                decoration: BoxDecoration(color: Utils.colorPrimary),
                children: [
                  // buildContainer(Colors.blue, 50.0),
                  // buildContainer(Colors.red, 50.0),
                  // buildContainer(Colors.blue, 50.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Ticket', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Monto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),),
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
              columnWidths: <int, TableColumnWidth>{0 : FractionColumnWidth(.35)},
              children: rows,
             ),
        ),
      ],
    ),
  );
  
 }


  _getAvatar(Venta venta, bool isSmallOrMedium){
    Color background;
    IconData icon;
    print("_getAvatar status: ${venta.status} ");
    if(venta.status == 1){
      if(venta.premios > 0){
        background = Utils.colorPrimary;
        icon = Icons.attach_money;
      }
      else{
        background = Colors.grey;
        icon = Icons.timer;
      }
    }
    else if(venta.status == 2){
      background = Utils.colorPrimary;
      icon = Icons.attach_money;
    }else if(venta.status == 3){
        background = Colors.pink;
        icon = Icons.money_off;
    }else{
        background = Colors.red[700];
        icon = Icons.auto_delete;
    }

    // if(!isSmallOrMedium)
    //   return Container(
    //     padding: EdgeInsets.symmetric(vertical: 6, horizontal: 3),
    //     decoration: BoxDecoration(
    //       color: background,
    //       borderRadius: BorderRadius.circular(3)
    //     ),
    //     child: Row(
    //       children: [
    //         Text("${venta.status == 1 ? 'Pendiente' : venta.status == 2 ? 'Ganador' : venta.status == 3 ? 'Perdedor' : 'Cancelado'}"),
    //         Icon(icon, color: Colors.white,)
    //       ],
    //     ),
    //   );

    return CircleAvatar(
      radius: isSmallOrMedium ? null : 16,
      backgroundColor: background ,
      child: Icon(icon, color: Colors.white, size: isSmallOrMedium ? null : 16),
    );
  }

  _dateChanged(DateTimeRange value){
    setState(() {_date = value; _getMonitoreo();});
  }

  _onDeleteAll(){
    setState(() {_date = _getDefaultDateRange(); _getMonitoreo();});
  }

  _showFiltrarScreen() async {
    // var date = await showDateRangePicker(
    //   context: context, 
    //   initialDateRange: _date,
    //   firstDate: DateTime(DateTime.now().year - 5), 
    //   lastDate: DateTime(DateTime.now().year + 5),
      
    // );

    var date = await showDatePicker(context: context, initialDate: _date.start, firstDate: DateTime(DateTime.now().year - 5), lastDate: DateTime(DateTime.now().year + 5));

    if(date != null)
      setState(() {
        _date = DateTimeRange(
          start: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 00:00"),
          end: DateTime.parse("${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())} 23:59:59")
        );
        _getMonitoreo();
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


  _showOpciones(Venta venta, bool isSmallOrMedium) async {
    bool _cargandoVerTicket = false;
    bool _cargandoImprimirTicket = false;
    bool _cargandoCompartirTicket = false;
    bool _cargandoCancelarTicket = false;
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context){
            
        return StatefulBuilder(
          builder: (context, setState) {

            _back(){
              Navigator.pop(context);
            }

            _verTicket() async {
               try{
                    setState(() => _cargandoVerTicket = true);
                    var datos = await TicketService.buscarTicket(context: context, codigoBarra: venta.codigoBarra);
                    setState(() => _cargandoVerTicket = false);
                    _back();
                    Monitoreo.showDialogVerTicket(context: context, mapVenta: datos["venta"], isSmallOrMedium: isSmallOrMedium);
                  } on Exception catch(e){
                    setState(() => _cargandoVerTicket = false);
                  }
            }

            _reImprimirTicket() async {
              try{
                  if(await Utils.exiseImpresora() == false){
                    _back();
                    Utils.showAlertDialog(context: context, title: "Alerta", content: "Debe registrar una impresora");
                    return;
                  }

                  setState(() => _cargandoImprimirTicket = true);
                  var datos = await TicketService.buscarTicketAPagar(context: context, codigoBarra: venta.codigoBarra);
                  print("Monitoreo _showOpciones: $datos");
                  await BluetoothChannel.printTicket(datos["venta"], BluetoothChannel.TYPE_COPIA);
                  setState(() => _cargandoImprimirTicket = false);
                  _back();
                } on Exception catch(e){
                  setState(() => _cargandoImprimirTicket = false);
                }
            }

            _compartirTicket() async {
              try{
                    setState(() => _cargandoCompartirTicket = true);
                    var parsed = await TicketService.ticketV2(context: context, idVenta: venta.id);
                    Sale sale = parsed["sale"] != null ? Sale.fromMap(parsed["sale"]) : null;
                    if(sale == null)
                      return;

                    print("_compartirTicket datos: ${parsed}");
                    List<Salesdetails> salesdetails = (parsed["salesdetails"] != null) ? parsed["salesdetails"].map<Salesdetails>((json) => Salesdetails.fromMap(json)).toList() : [];
                    // Uint8List image = await TicketImage.create(sale, salesdetails);
                    Uint8List image = await TicketImageV2.create(sale, salesdetails);
                    print("_compartirTicket datos descuento: ${sale.descuentoMonto} hayDescuento: ${sale.hayDescuento}");

                    // ShareChannel.shareHtmlImageToSmsWhatsapp(html: datos["ticket"]["img"], codigoQr: datos["ticket"]["codigoQr"], sms_o_whatsapp: true);
                    ShareChannel.shareHtmlImageToSmsWhatsapp(base64image: image, codigoQr: sale.ticket.codigoBarra, sms_o_whatsapp: true);
                    setState(() => _cargandoCompartirTicket = false);
                    _back();
                  } on Exception catch(e){
                    Utils.showAlertDialog(context: context, content: "$e", title: "Error");
                    setState(() => _cargandoCompartirTicket = false);
                  }
            }

            _updateStreamControllerVenta(ventaMap){
              if(ventaMap == null)
                return;

              print("_updateStreamControllerVenta validation1 passed: ${ventaMap.runtimeType}");
              // if(!(ventaMap is Map<String, dynamic>))
              //   return;

                print("_updateStreamControllerVenta validation2 passed");
              var index = _listaVenta.indexWhere((element) => element.id == venta.id);
              if(index == -1)
                return;

                print("_updateStreamControllerVenta validation3 passed");

              _listaVenta[index].status = 0;
              _listaVenta[index].usuarioCancelacion = ventaMap["usuarioCancelacion"];
              _listaVenta[index].fechaCancelacion = ventaMap["fechaCancelacion"] != null ? DateTime.parse(ventaMap["fechaCancelacion"]) : null;
                print("_updateStreamControllerVenta before _stremaController");
              _streamControllerMonitoreo.add(_listaVenta.where((element) => element.status != 0).toList());
            }

            _cancelarTicket() async {
              bool cancelar = await TicketService.showDialogAceptaCancelar(context: context, ticket: Utils.toSecuencia((_tienePermisoMonitoreo && listaBanca != null) ? listaBanca[_indexBanca].codigo : _banca.codigo, venta.idTicket, false));
                  if(!cancelar){
                    _back();
                    return;
                  }

                  
                  bool imprimir = await TicketService.showDialogDeseaImprimir(context: context);
                  if(imprimir){
                       if(await Utils.exiseImpresora() == false){
                        Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: "Debe registrar una impresora");
                        return;
                      }

                      if(!(await BluetoothChannel.turnOn())){
                        return;
                      }

                      try{
                        setState(() => _cargandoCancelarTicket = true);
                        var datos = await TicketService.cancelar(scaffoldKey: _scaffoldKey, codigoBarra: venta.codigoBarra);
                        await BluetoothChannel.printTicket(datos["ticket"], BluetoothChannel.TYPE_CANCELADO);
                        setState(() => _cargandoCancelarTicket = false);
                        Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: datos["mensaje"]);
                        _updateStreamControllerVenta(datos["ticketToUpdateList"]);
                        _back();
                      } on Exception catch(e){
                        setState(() => _cargandoCancelarTicket = false);
                      }
                    }else{
                      try{
                        setState(() => _cargandoCancelarTicket = true);
                        var datos = await TicketService.cancelar(scaffoldKey: _scaffoldKey, codigoBarra: venta.codigoBarra);
                        setState(() => _cargandoCancelarTicket = false);
                        Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: datos["mensaje"]);
                        _updateStreamControllerVenta(datos["ticketToUpdateList"]);
                        _back();
                      }on Exception catch(e){
                        setState(() => _cargandoCancelarTicket = false);
                      }
                    }
                  
                
            }

            return Container(
                  height: 290,
                  child: Column(
                    children: [
                      Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                            ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
                                child: Center(child: Text("${Utils.toSecuencia(null,venta.idTicket, false)}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16))),
                              ),
                              ListTile(
                                leading: Icon(Icons.remove_red_eye),
                                title: Text("Ver ticket", style: TextStyle(color: Colors.black)),
                                trailing: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: Visibility(
                                    visible: _cargandoVerTicket,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                                      child: new CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                                onTap: _verTicket,
                              ),
                              ListTile(
                                leading: Icon(Icons.print),
                                title: Text("Reimprimir", style: TextStyle(color: Colors.black)),
                                trailing: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: Visibility(
                                    visible: _cargandoImprimirTicket,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                                      child: new CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                                onTap: _reImprimirTicket,
                              ),
                              ListTile(
                                leading: Icon(Icons.share),
                                title: Text("Compartir", style: TextStyle(color: Colors.black)),
                                trailing: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: Visibility(
                                    visible: _cargandoCompartirTicket,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                                      child: new CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                                onTap: _compartirTicket,
                              ),
                              ListTile(
                                leading: Icon(Icons.delete),
                                title: Text("Eliminar", style: TextStyle(color: Colors.black)),
                                trailing: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: Visibility(
                                    visible: _cargandoCancelarTicket,
                                    child: Theme(
                                      data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                                      child: new CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                                onTap: _cancelarTicket,
                              ),
                            ],
                          ),
                        )
                       
                        
                      
                      ),
                    ],
                  ),
                );
          }
        );
        
      
      }
  );
    
  }

  _dropdownBancas(){
    return StreamBuilder<List<Banca>>(
        stream: _streamControllerBanca.stream,
        builder: (context, snapshot){
          // print("FutureBuilder: ${snapshot.connectionState}");
          // if(snapshot.hasData){
            if(!snapshot.hasData)
              return SizedBox.shrink();

             return GestureDetector(
                  onTap: _showBottomSheetBanca,
                  child: Row(
                    children: [
                      Text("${listaBanca.length > 0 ? listaBanca[_indexBanca].descripcion : 'No hay bancas'}", softWrap: true, style: TextStyle(color: Colors.black),),
                      Icon(Icons.arrow_drop_down, color: Colors.black54,)
                    ],
                  ),
                );
            
            // listaBanca = snapshot.data;
            // return DropdownButton(
            //   hint: Text("Sel. banca"),
            //   // isExpanded: true,
            //   value: listaBanca[_indexBanca],
            //   onChanged: (Banca banca) async {
            //     int idx = listaBanca.indexWhere((b) => b.id == banca.id);
            //     setState(() => _indexBanca = (idx != -1) ? idx : 0);
            //     // print("banca: ${banca.descripcion}");
            //     _getMonitoreo();
            //   },
            //   items: listaBanca.map((b) => DropdownMenuItem<Banca>(
            //     value: b,
            //     child: Text("${b.descripcion}"),
            //   )).toList(),
            // );
          // }
          // return DropdownButton(
          //   value: "No hay bancas",
          //   onChanged: (String data){},
          //   items: [DropdownMenuItem(value: "No hay bancas", child: Text("No hay bancas"),)],
          // );
        },
      );
  }
 
  _bancaChanged(index){
    setState((){
        _indexBanca = index;
        _getMonitoreo();
      });
  }

  _showBottomSheetBanca() async {
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
            bancaChanged(index){
              setState(() => _indexBanca = index);
              _bancaChanged(index);
              _back();
            }
        return Container(
              height: MediaQuery.of(context).size.height / 2,
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

                          value: _indexBanca == index,
                          onChanged: (data){
                            bancaChanged(index);
                          },
                          title: Text("${listaBanca[index].descripcion}"),
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
 
 _tipoTicketChanged(tipoTicket){
    setState((){
        _tipoTicket = tipoTicket;
      
        _streamControllerMonitoreo.add(_tipoTicket[0] != -1 ? _tmpListaVenta.where((element) => element.status == _tipoTicket[0]).toList() : _tmpListaVenta.where((element) => element.status != 0).toList());
      });
  }
 
  _showBottomSheetTicket() async {
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
            tipoTicketChanged(tipoTicket){
              setState(() => _tipoTicket = tipoTicket);
              _tipoTicketChanged(tipoTicket);
              _back();
            }
        return Container(
              height: 300,
              child: Column(
                children: [
                  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaTipoTicket.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          value: _tipoTicket == listaTipoTicket[index],
                          onChanged: (data){
                            tipoTicketChanged(listaTipoTicket[index]);
                          },
                          title: Text("${listaTipoTicket[index][1]}"),
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

  
  _myFilterWidget(bool isSmallOrMedium){
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
            _filtros.length == 0
            ?
            SizedBox.shrink()
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
                  _filtros = [];
                  _banca = null;
                  _grupo = null;
                  _loteria = null;
                  _getMonitoreo();
                });
                return;
              }

              _grupo = null;
              _banca = null;
              _loteria = null;
              bool soloFiltroEstado = false;
              setState(() {
                _filtros = data;
                for (MyFilterSubData2 myFilterSubData2 in data) {
                  print("HistoricoVentas Filter2 for subData: ${myFilterSubData2.type} value: ${myFilterSubData2.value}");
                  if(myFilterSubData2.type == "Banca")
                    _banca = myFilterSubData2.value;
                  else if(myFilterSubData2.type == "Grupo")
                    _grupo = myFilterSubData2.value;
                  else if(myFilterSubData2.type == "Loteria")
                    _loteria = myFilterSubData2.value;
                  else if(myFilterSubData2.type == "Estado ticket"){
                    // if(_tipoTicket != myFilterSubData2.value)
                      soloFiltroEstado = true;
                    _tipoTicket = myFilterSubData2.value;
                  }
                  
                }
                if(soloFiltroEstado)
                  _tipoTicketChanged(_tipoTicket);
                else
                  _getMonitoreo();

              });
              
            },
            onDelete: (data){
              var soloFiltroEstado = false;
              setState(() {
                if(data.child == "Banca")
                  _banca = null;
                if(data.child == "Grupo")
                  _grupo = null;
                if(data.child == "Loteria" )
                  _loteria = null;
                if(data.child == "Estado ticket"){
                  soloFiltroEstado = true;
                  _tipoTicket = listaTipoTicket.firstWhere((element) => element[0] == -1, orElse: () => null);
                }
                for (var element in data.data) {
                  _filtros.remove(element);
                }

                if(soloFiltroEstado)
                  _tipoTicketChanged(_tipoTicket);
                else
                  _getMonitoreo();
              });
            },
            onDeleteAll: (values){
              setState((){
                // _selectedFilter = [];
                for (var item in values) {
                  _filtros.removeWhere((element) => element.type == item.child);
                  if(item.child == "Banca")
                    _banca = null;
                  if(item.child == "Grupo")
                    _grupo = null;
                  if(item.child == "Loteria")
                    _loteria = null;
                  if(item.child == "Estado ticket")
                    _tipoTicket = listaTipoTicket.firstWhere((element) => element[0] == -1, orElse: () => null);
                }
                _getMonitoreo();
              });
            },
            data: listaFiltro,
            values: _filtros
          );
  
  }

  _search(String text){
    print("TextField chagned: $text");
    if(text.isEmpty)
      _listaVenta = _tmpListaVenta;
    else
      _listaVenta = _tmpListaVenta.where((v) => v.idTicket.toString().indexOf(text) != -1).toList();
    
    _streamControllerMonitoreo.add(_listaVenta);  
  }

  _myWebFilterScreen(bool isSmallOrMedium){
    return 
    isSmallOrMedium
    ?
    SizedBox.shrink()
    :
    Padding(
      padding: EdgeInsets.only(bottom: isSmallOrMedium ? 0 : 0, top: 5),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
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
         _myFilterWidget(isSmallOrMedium),
          // Padding(
          //   padding: EdgeInsets.only(right: 15.0, top: 18.0, bottom: !isSmallOrMedium ? 20 : 0),
          //   child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar banca...", xlarge: 2.6, showOnlyOnLarge: true,),
          // ),
          Padding(
            padding: EdgeInsets.only(right: 15.0, top: 18.0, bottom: !isSmallOrMedium ? 20 : 0),
            child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar banca...", xlarge: 2.6, showOnlyOnLarge: true,),
          ),
          MyDivider(showOnlyOnLarge: true, padding: EdgeInsets.only(left: isSmallOrMedium ? 4 : 0, right: 10.0, top: 5),),
        ],
      ),
    );
  }



  _subtitle(bool isSmallOrMedium){
    return
    isSmallOrMedium
    ?
    MyCollapseChanged(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _myFilterWidget(isSmallOrMedium),
      )
      
        
      ,
    )
    :
    "Visualiza informes detallados y personalizables sobre los tickets creados por cada banca";
  }

  _pay(Venta venta){

  }

  _screen(List<Venta> data, bool isSmallOrMedium){
    if(data == null)
      return Center(child: CircularProgressIndicator());
    if(!isSmallOrMedium)
      return MyTable(
        columns: ["Estado", "Numero", "Creado", "Usuario", "Monto", "Premio", "Cancelado por", "Fecha cancelado", "Monto a pagar", "Monto pagado", ""], 
        rows: data.map((e) => [
          e,
          Row(children: [
            _getAvatar(e, isSmallOrMedium),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text("${e.status == 1 ? 'Pendiente' : e.status == 2 ? 'Ganador' : e.status == 3 ? 'Perdedor' : 'Cancelado'}", style: TextStyle(fontWeight: FontWeight.bold),),
            )
          ],),
          Text("${Utils.toSecuencia((_tienePermisoMonitoreo && listaBanca != null) ? listaBanca[_indexBanca].descripcion : _banca.descripcion, e.idTicket, false)}", style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
          "${MyDate.dateRangeToNameOrString(DateTimeRange(start: e.created_at, end: e.created_at))}",
          "${e.usuario}",
          "${Utils.toCurrency(e.total)}",
          "${Utils.toCurrency(e.premios)}",
          "${e.usuarioCancelacion != null ? e.usuarioCancelacion : '-'}",
          "${e.fechaCancelacion != null ? MyDate.dateRangeToNameOrString(DateTimeRange(start: e.fechaCancelacion, end: e.fechaCancelacion)) : '-'}",
          // "${e.status == 1 ? 'Pendiente' : e.status == 2 ? 'Ganador' : e.status == 3 ? 'Perdedor' : 'Cancelado'}",
          "${Utils.toCurrency(e.montoAPagar)}",
          "${Utils.toCurrency(e.montoPagado)}",
          IconButton(tooltip: "Mostrar opciones", onPressed: () => _showOpciones(e, isSmallOrMedium), icon: Icon(Icons.arrow_right_alt, color: Theme.of(context).primaryColor))
        ]).toList(),
        onTap: (Venta venta){
          _showOpciones(venta, isSmallOrMedium);
        },
      );
    
    return Column(
      children: data.map((e) => ListTile(
        onTap: (){_showOpciones(e, isSmallOrMedium);},
      leading: _getAvatar(e, isSmallOrMedium),
      trailing: 
      (e.premios <= 0)
      ?
      Text(Utils.toCurrency(e.total), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),)
      :
      Column(
        children: [
          Text(Utils.toCurrency(e.total), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),),
          Text(Utils.toCurrency(e.premios), style: TextStyle(color: Colors.pink, fontSize: 16),),
        ],
      ),
      title: Text("${Utils.toSecuencia((_tienePermisoMonitoreo && listaBanca != null) ? listaBanca[_indexBanca].descripcion : _banca.descripcion, e.idTicket, false)}", style: TextStyle(fontWeight: FontWeight.w700),),
      subtitle: 
      e.status != 0
      ?
      RichText(text: TextSpan(
        style: TextStyle(color: Colors.grey),
        children: [
          // TextSpan(text: "${_loteria != null ? _loteria.abreviatura.substring(0, _loteria.abreviatura.length < 3 ? _loteria.abreviatura.length : 3) : ''}"),
          TextSpan(text: "${MyDate.datetimeToHour(e.created_at)}"),
        ]
      ))
      :
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(text: TextSpan(
            text: "${MyDate.datetimeToHour(e.created_at)}",
            style: TextStyle(color: Colors.grey),
          )),
          RichText(text: TextSpan(
            style: TextStyle(color: Colors.red[700]),
            children: [
              TextSpan(text: "Cancelado por ${e.usuarioCancelacion}"),
              TextSpan(text: "  •  ${MyDate.datetimeToHour(e.fechaCancelacion)}"),
            ]
          ))
        ],
      )
    )
      ).toList(),
    );
  }



  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      key: _scaffoldKey,
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      monitoreo: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Monitoreo",
          expandedHeight: isSmallOrMedium ? 105 : 85,
          subtitle: _subtitle(isSmallOrMedium),
          actions: [
            // IconButton(icon: Icon(Icons.date_range, color: Utils.colorPrimary), onPressed: _showFiltrarScreen),
            // IconButton(icon: Icon(Icons.filter_alt, color: Utils.colorPrimary), onPressed: _showBottomSheetTicket),
            MySliverButton(
              title: "", 
              iconWhenSmallScreen: Icons.date_range,
              showOnlyOnSmall: true,
              onTap: () {
                // _showFiltrarScreen();
                _showDateTimeRangeCalendar();
              },
            ),
            MySliverButton(
              title: "title", 
              iconWhenSmallScreen: Icons.filter_alt_rounded,
              showOnlyOnSmall: true,
              onTap: () async {
                if(isSmallOrMedium){
                  _myFilterKey.currentState.openFilter(context);
                }
              }
            ),
            MySliverButton(
              showOnlyOnLarge: true,
              title: Container(
                width: 180,
                child: Builder(
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: MyDropdown(title: null, 
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
              ), 
              onTap: (){}
              ),
          ],
        ), 
        sliver: StreamBuilder<List<Venta>>(
                stream: _streamControllerMonitoreo.stream,
                builder: (context, snapshot) {
                  if((snapshot.data == null && isSmallOrMedium) || (snapshot.data == null && !isSmallOrMedium && _listaVenta == null))
                    return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));

                  if(snapshot.hasData && _listaVenta.length == 0 && isSmallOrMedium)
                    return SliverFillRemaining(child: MyEmpty(title: "No hay tickets creados", icon: Icons.receipt, titleButton: "No hay tickets"));

                  var widgets = [
                    Visibility(
                      visible: isSmallOrMedium,
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(hintText: "Numero ticket"),
                        onChanged: _search,
                      ),
                                      ),
                    ),
                    _myWebFilterScreen(isSmallOrMedium),
                    MySubtitle(title: "${snapshot.data != null ? snapshot.data.length : 0} Filas", padding: EdgeInsets.only(bottom: 20, top: 25), showOnlyOnLarge: true,),
                    snapshot.hasData && snapshot.data.length == 0
                    ?
                    Center(child:  MyEmpty(title: "No hay tickets realizadaos", titleButton: "No hay tickets", icon: Icons.transfer_within_a_station),)
                    :
                  _screen(snapshot.data, isSmallOrMedium)
                  ];


                  return SliverList(delegate: SliverChildBuilderDelegate(
                    (context, index){
                      return widgets[index];
                    },
                    childCount: widgets.length
                  ));

                  // return SliverList(delegate: SliverChildListDelegate([
                  //   Visibility(
                  //     visible: isSmallOrMedium,
                  //     child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: TextField(
                  //       decoration: InputDecoration(hintText: "Numero ticket"),
                  //       onChanged: _search,
                  //     ),
                  //                     ),
                  //   ),
                  //   _myWebFilterScreen(isSmallOrMedium),
                  //   MySubtitle(title: "${snapshot.data != null ? snapshot.data.length : 0} Filas", padding: EdgeInsets.only(bottom: 20, top: 25), showOnlyOnLarge: true,),
                  //   snapshot.hasData && snapshot.data.length == 0
                  //   ?
                  //   Center(child:  MyEmpty(title: "No hay tickets realizadaos", titleButton: "No hay tickets", icon: Icons.transfer_within_a_station),)
                  //   :
                  // _screen(snapshot.data, isSmallOrMedium)
                       
           
                  // ]));
                }
              )
      )
    );

    return  Scaffold(
      key: _scaffoldKey,
        // appBar: AppBar(
        //   leading: BackButton(
        //     color: Utils.colorPrimary,
        //   ),
        //   title: Text("Monitoreo", style: TextStyle(color: Colors.black)),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   actions: <Widget>[
        //      Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: <Widget>[
        //           Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: SizedBox(
        //               width: 30,
        //               height: 30,
        //               child: Visibility(
        //                 visible: _cargando,
        //                 child: Theme(
        //                   data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
        //                   child: new CircularProgressIndicator(),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //   ],
        // ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: BackButton(color: Utils.colorPrimary,),
                backgroundColor: Colors.white,
                title: StreamBuilder<List<Banca>>(
                  stream: _streamControllerBanca.stream,
                  builder: (context, snapshot) {
                    return AnimatedCrossFade(
                      firstChild: Text("Monitoreo", style: TextStyle(color: Colors.black),), 
                      secondChild: _dropdownBancas(), 
                      crossFadeState: !_tienePermisoJugarComoCualquierBanca ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
                      duration: Duration(milliseconds: 200)
                      );
                  }
                ),
                
                expandedHeight: 120,
                flexibleSpace: Align(
                  alignment: Alignment.bottomCenter,
                  child: MyFilter(
                    showListNormalCortaLarga: 2,
                    value: _date,
                    onChanged: _dateChanged,
                    onDeleteAll: _onDeleteAll,
                  ),
                ),
                actions: [
                  IconButton(icon: Icon(Icons.date_range, color: Utils.colorPrimary), onPressed: _showFiltrarScreen),
                  IconButton(icon: Icon(Icons.filter_alt, color: Utils.colorPrimary), onPressed: _showBottomSheetTicket),
                ],
              ),
              StreamBuilder<List<Venta>>(
                stream: _streamControllerMonitoreo.stream,
                builder: (context, snapshot) {
                  if(snapshot.data == null)
                    return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));

                  if(snapshot.hasData && _listaVenta.length == 0)
                    return SliverFillRemaining(child: MyEmpty(title: "No hay tickets creados", icon: Icons.receipt, titleButton: "No hay tickets"));

                  return SliverList(delegate: SliverChildListDelegate([
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(hintText: "Numero ticket"),
                      onChanged: (String text){
                        print("TextField chagned: $text");
                        if(text.isEmpty)
                          _listaVenta = _tmpListaVenta;
                        else
                          _listaVenta = _tmpListaVenta.where((v) => v.idTicket.toString().indexOf(text) != -1).toList();
                        
                        _streamControllerMonitoreo.add(_listaVenta);  
                      },
                    ),
                  ),
                  Column(
                          children: snapshot.data.map((e) => ListTile(
                            // onTap: (){_showOpciones(e);},
                          // leading: _getAvatar(e),
                          trailing: 
                          (e.premios <= 0)
                          ?
                          Text(Utils.toCurrency(e.total), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),)
                          :
                          Column(
                            children: [
                              Text(Utils.toCurrency(e.total), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),),
                              Text(Utils.toCurrency(e.premios), style: TextStyle(color: Colors.pink, fontSize: 16),),
                            ],
                          ),
                          title: Text("${Utils.toSecuencia((_tienePermisoMonitoreo && listaBanca != null) ? listaBanca[_indexBanca].descripcion : _banca.descripcion, e.idTicket, false)}", style: TextStyle(fontWeight: FontWeight.w700),),
                          subtitle: 
                          e.status != 0
                          ?
                          RichText(text: TextSpan(
                            style: TextStyle(color: Colors.grey),
                            children: [
                              // TextSpan(text: "${_loteria != null ? _loteria.abreviatura.substring(0, _loteria.abreviatura.length < 3 ? _loteria.abreviatura.length : 3) : ''}"),
                              TextSpan(text: "${MyDate.datetimeToHour(e.created_at)}"),
                            ]
                          ))
                          :
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(text: TextSpan(
                                text: "${MyDate.datetimeToHour(e.created_at)}",
                                style: TextStyle(color: Colors.grey),
                              )),
                              RichText(text: TextSpan(
                                style: TextStyle(color: Colors.red[700]),
                                children: [
                                  TextSpan(text: "Cancelado por ${e.usuarioCancelacion}"),
                                  TextSpan(text: "  •  ${MyDate.datetimeToHour(e.fechaCancelacion)}"),
                                ]
                              ))
                            ],
                          )
                        )
                          ).toList(),
                        )
                       
                  // StreamBuilder<List<Venta>>(
                  //   stream: _streamControllerMonitoreo.stream,
                  //   builder: (context, snapshot){
                  //     // print("${snapshot.hasData}");
                  //     if(snapshot.hasData){
                  //     var lista = snapshot.data.where((v) => v.status != 0 && v.status != 5).toList();
                  //       return Column(
                  //         children: lista.map((e) => ListTile(
                  //         leading: _getAvatar(e),
                  //         trailing: 
                  //         (e.premios <= 0)
                  //         ?
                  //         Text(Utils.toCurrency(e.total), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),)
                  //         :
                  //         Column(
                  //           children: [
                  //             Text(Utils.toCurrency(e.total), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),),
                  //             Text(Utils.toCurrency(e.premios), style: TextStyle(color: Colors.pink, fontSize: 16),),
                  //           ],
                  //         ),
                  //         title: Text("${Utils.toSecuencia((_tienePermisoMonitoreo && listaBanca != null) ? listaBanca[_indexBanca].descripcion : _banca.descripcion, e.idTicket, false)}", style: TextStyle(fontWeight: FontWeight.w700),),
                  //         subtitle: RichText(text: TextSpan(
                  //           style: TextStyle(color: Colors.grey),
                  //           children: [
                  //             // TextSpan(text: "${_loteria != null ? _loteria.abreviatura.substring(0, _loteria.abreviatura.length < 3 ? _loteria.abreviatura.length : 3) : ''}"),
                  //             TextSpan(text: "${MyDate.datetimeToHour(e.created_at)}"),
                  //           ]
                  //         )),
                  //       )
                  //         ).toList(),
                  //       );
                  //       return _buildTable(_listaVenta.where((v) => v.status != 0 && v.status != 5).toList(), (_tienePermisoMonitoreo && listaBanca != null) ? listaBanca[_indexBanca] : _banca);
                  //     }
                  //     return _buildTable(List<Venta>(), null);
                  //   },
                  // )
           
                  ]));
                }
              )
            ],
          )
          // ListView(
          //   children: <Widget>[
          //     Row(
          //       children: <Widget>[
          //         Visibility(
          //           visible: _tienePermisoJugarComoCualquierBanca,
          //           child: Expanded(
          //             child: Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: FutureBuilder<bool>(
          //                 future: listaBancaFuture,
          //                 builder: (context, snapshot){
          //                   // print("FutureBuilder: ${snapshot.connectionState}");
          //                   if(snapshot.hasData){
                              
          //                     // listaBanca = snapshot.data;
          //                     return DropdownButton(
          //                       hint: Text("Sel. banca"),
          //                       // isExpanded: true,
          //                       value: listaBanca[_indexBanca],
          //                       onChanged: (Banca banca) async {
          //                         int idx = listaBanca.indexWhere((b) => b.id == banca.id);
          //                         setState(() => _indexBanca = (idx != -1) ? idx : 0);
          //                         // print("banca: ${banca.descripcion}");
          //                         _getMonitoreo();
          //                       },
          //                       items: listaBanca.map((b) => DropdownMenuItem<Banca>(
          //                         value: b,
          //                         child: Text("${b.descripcion}"),
          //                       )).toList(),
          //                     );
          //                   }
          //                   return DropdownButton(
          //                     value: "No hay bancas",
          //                     onChanged: (String data){},
          //                     items: [DropdownMenuItem(value: "No hay bancas", child: Text("No hay bancas"),)],
          //                   );
          //                 },
          //               ),
          //             ),
          //           ),
          //         ),
          //         Expanded(
          //           child: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: RaisedButton(
          //               child: Text("${_fecha.year}-${_fecha.month}-${_fecha.day}"), 
          //               color: Colors.transparent, 
          //               onPressed: () async {
          //                 var fecha = await showDatePicker( context: context, initialDate: DateTime.now(), firstDate: DateTime(2001), lastDate: DateTime(2022));
          //                 setState(() => _fecha = (fecha != null) ? fecha : _fecha);
          //                 await _getMonitoreo();
          //                 // showModalBottomSheet(
          //                 //   context: context, 
                            
          //                 //   builder: (context){
          //                 //     return Container(
          //                 //       height: MediaQuery.of(context).size.height / 3,
          //                 //       child: CupertinoDatePicker(
          //                 //         initialDateTime: DateTime.now(),
          //                 //         mode: CupertinoDatePickerMode.date,
          //                 //         minuteInterval: 1,
          //                 //         onDateTimeChanged: (fecha){
          //                 //           setState(() => _fecha = fecha);
          //                 //         }
          //                 //       ),
          //                 //     );
          //                 //   }
          //                 // );
          //                 // showDialog(
          //                 //   context: context,
          //                 //   builder: (context){
          //                 //     return AlertDialog(
          //                 //       title: Text("Seleccionar fecha"),
          //                 //       content: Container(
          //                 //       height: MediaQuery.of(context).size.height / 3,
                                
          //                 //       child: SizedBox(
          //                 //         width: MediaQuery.of(context).size.width - 100,
          //                 //         child: CupertinoDatePicker(
          //                 //           initialDateTime: DateTime.now(),
          //                 //           mode: CupertinoDatePickerMode.date,
          //                 //           minuteInterval: 1,

          //                 //           onDateTimeChanged: (fecha){
          //                 //             setState(() => _fecha = fecha);
          //                 //           }
          //                 //         ),
          //                 //       ),
          //                 //     ),
          //                 //     );
          //                 //   }
          //                 // );
          //               }, 
          //               elevation: 0, shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),),
          //           )
          //         )
          //       ],
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: TextField(
          //         decoration: InputDecoration(hintText: "Numero ticket"),
          //         onChanged: (String text){
          //           print("TextField chagned: $text");
          //           if(text.isEmpty)
          //             _listaVenta = _tmpListaVenta;
          //           else
          //             _listaVenta = _tmpListaVenta.where((v) => v.idTicket.toString().indexOf(text) != -1).toList();
                    
          //           _streamControllerMonitoreo.add(true);  
          //         },
          //       ),
          //     ),
          //     StreamBuilder<bool>(
          //       stream: _streamControllerMonitoreo.stream,
          //       builder: (context, snapshot){
          //         // print("${snapshot.hasData}");
          //         if(snapshot.hasData){
          //         var lista = _listaVenta.where((v) => v.status != 0 && v.status != 5).toList();
          //           return Column(
          //             children: lista.map((e) => ListTile(
          //             leading: _getAvatar(e),
          //             trailing: 
          //             (e.premios <= 0)
          //             ?
          //             Text(Utils.toCurrency(e.total), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),)
          //             :
          //             Column(
          //               children: [
          //                 Text(Utils.toCurrency(e.total), style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700, fontSize: 16),),
          //                 Text(Utils.toCurrency(e.premios), style: TextStyle(color: Colors.pink, fontSize: 16),),
          //               ],
          //             ),
          //             title: Text("${Utils.toSecuencia((_tienePermisoMonitoreo && listaBanca != null) ? listaBanca[_indexBanca].descripcion : _banca.descripcion, e.idTicket, false)}", style: TextStyle(fontWeight: FontWeight.w700),),
          //             subtitle: RichText(text: TextSpan(
          //               style: TextStyle(color: Colors.grey),
          //               children: [
          //                 // TextSpan(text: "${_loteria != null ? _loteria.abreviatura.substring(0, _loteria.abreviatura.length < 3 ? _loteria.abreviatura.length : 3) : ''}"),
          //                 TextSpan(text: "${MyDate.datetimeToHour(e.created_at)}"),
          //               ]
          //             )),
          //           )
          //             ).toList(),
          //           );
          //           return _buildTable(_listaVenta.where((v) => v.status != 0 && v.status != 5).toList(), (_tienePermisoMonitoreo && listaBanca != null) ? listaBanca[_indexBanca] : _banca);
          //         }
          //         return _buildTable(List<Venta>(), null);
          //       },
          //     )
          //   ],
          // ),
        ),
      );
    
  }
}