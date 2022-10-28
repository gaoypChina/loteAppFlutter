import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loterias/core/classes/cross_device_info.dart';
import 'package:loterias/core/classes/cross_platform_keypress/cross_platform_keypress.dart';
import 'package:loterias/core/classes/cross_platform_reques_permissions/cross_platform_request_permissions.dart';
import 'package:loterias/core/classes/cross_platform_timezone/cross_platform_timezone.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/drift_database.dart' as driftDatabase;
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/myfilemanager.dart';
import 'package:loterias/core/classes/mynotification.dart';
import 'package:loterias/core/classes/mysocket.dart';
import 'package:loterias/core/classes/screensize.dart';
import 'package:loterias/core/classes/ticketimage.dart';
import 'package:loterias/core/classes/ticketimagev2.dart';
import 'package:loterias/core/models/BlocksgeneralsJugada.dart';
import 'package:loterias/core/models/BlockslotteriesJugada.dart';
import 'package:loterias/core/models/blocksplaysgeneralsjugadas.dart';
import 'package:loterias/core/models/blocksplaysjugadas.dart';
import 'package:loterias/core/models/duplicar.dart';
import 'package:loterias/core/models/estadisticajugada.dart';
import 'package:loterias/core/models/lotterycolor.dart';
import 'package:loterias/core/models/montodisponible.dart';
import 'package:loterias/core/models/notificacion.dart';
import 'package:loterias/core/models/pago.dart';
import 'package:loterias/core/models/sale.dart';
import 'package:loterias/core/models/salesdetails.dart';
import 'package:loterias/core/models/searchdata.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/models/stockjugada.dart';
import 'package:loterias/core/models/ticket.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/services/bluetoothchannel.dart';
import 'package:loterias/core/services/loginservice.dart';
import 'package:loterias/core/services/notificationservice.dart';
import 'package:loterias/core/services/sharechannel.dart';
import 'package:loterias/core/services/sorteoservice.dart';
import 'package:loterias/core/services/ticketservice.dart';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:loterias/ui/splashscreen.dart';
import 'package:loterias/ui/views/prueba/pruebaticketimage.dart';
import 'package:loterias/ui/views/recargas/recargasadialogddscreen.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mybutton.dart';
import 'package:loterias/ui/widgets/mycheckbox.dart';
import 'package:loterias/ui/widgets/mydescripcion.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/mymobiledrawer.dart';
import 'package:loterias/ui/widgets/mymultiselectdialog.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/myscrollbar.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';
import 'package:ntp/ntp.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:screenshot/screenshot.dart';
import 'package:loterias/core/extensions/listextensions.dart';



// import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/principal.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/blocksgenerals.dart';
import 'package:loterias/core/models/blockslotteries.dart';
import 'package:loterias/core/models/blocksplays.dart';
import 'package:loterias/core/models/blocksplaysgenerals.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/stocks.dart';
import 'package:loterias/core/models/ventas.dart';
import 'package:loterias/core/services/realtime.dart';
import 'package:loterias/ui/views/principal/multiselectdialogitem.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:timezone/timezone.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as webSocketstatus;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../main.dart';
import '../../widgets/mymultiselect.dart';


class PrincipalApp extends StatefulWidget {
  final bool callThisScreenFromLogin;
  PrincipalApp({Key key, this.callThisScreenFromLogin = false}) : super(key: key);
  @override
  _PrincipalAppState createState() => _PrincipalAppState();
}

class _PrincipalAppState extends State<PrincipalApp> with WidgetsBindingObserver{
  Future<Pago> _futureFactura;
  var valueNotifyDrawer = ValueNotifier<bool>(false);
  IO.Socket socket;
  var _scrollController = ItemScrollController();
  List<String> _listaMensajes = [];
  static int _socketContadorErrores = 0;
  static int _socketNotificacionContadorErrores = 0;
  var _connectionNotify = ValueNotifier<bool>(false);
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formLigarKey = GlobalKey<FormState>();
  var _myMultiselectKey = GlobalKey<MyMultiSelectDialogState>();
  bool _jugadaOmonto = true;
  // var listaBanca = List<String>.generate(10, (i) => "Banca $i");
  List<Banca> listaBanca = List<Banca>.generate(1, (i) => Banca(descripcion: 'No hay bancas', id: 0));
  List<Loteria> listaLoteria = List<Loteria>.generate(1, (i) => Loteria(descripcion: 'No hay loterias', id: 0));
  List<Loteria> listaLoteriaTmp = List<Loteria>.generate(1, (i) => Loteria(descripcion: 'No hay loterias', id: 0));
  List<Venta> listaVenta = List<Venta>.generate(1, (i) => Venta(idTicket: BigInt.from(0), id: BigInt.from(0)));
  List<Jugada> listaJugadas = [];
  List<Jugada> listaJugadasSeleccionadas = [];
  List<EstadisticaJugada> listaEstadisticaJugada = [];
  bool _isSeleccionarScreen = false;

String currentTimeZone;
Future<String> _montoFuture;
String _montoPrueba = '0';
  String _idVenta = null;
  int _indexBanca = 0;
  int _indexVenta = 0;
  String _timeString;
  bool _cargando = false;
  bool _cargandoDatosSesionUsuario = false;
  bool _ckbDescuento = false;
  bool _ckbPrint = true;
  bool _ckbMessage = false;
  bool _ckbWhatsapp = false;
  bool _ckbLigarPale = true;
  bool _ckbLigarTripleta = false;
  bool _drawerIsOpen = false;
  bool _tienePermisoRealizarRecargas = false;
  bool _tienePermisoJugarFueraDeHorario = false;
  bool _tienePermisoJugarSinDisponibilidad = false;
  bool _tienePermisoJugarMinutosExtras = false;
  bool _tienePermisoJugarComoCualquierBanca = false;
  bool _tienePermisoManejarResultados = false;
  bool _tienePermisoMarcarTicketComoPagado = false;
  bool _tienePermisoMonitorearTicket = false;
  bool _tienePermisoVerGeneral = false;
  bool _tienePermisoVerDashboard = false;
  bool _tienePermisoVerVentas = false;
  bool _tienePermisoVerHistoricoVentas = false;
  bool _tienePermisoVerListaDeBalancesDeBancass = false;
  bool _tienePermisoVerListaDeBalancesDeBancos = false;
  bool _tienePermisoVerReporteJugadas = false;
  bool _tienePermisoTransacciones = false;
  bool _tienePermisoVerAjustes = false;
  bool _tienePermisoManejarBancas = false;
  bool _tienePermisoManejarUsuarios = false;
  bool _tienePermisoVerBalanceBancas = false;
  bool _tienePermisoManejarLoterias = false;
  bool _tienePermisoManejarManejarReglas = false;
  bool _tienePermisoManejarManejarGrupos = false;
  bool _tienePermisoVerIniciosDeSesion = false;
  bool _tienePermisoVerVentasPorFecha = false;
  bool _tienePermisoManejarHorariosDeLoterias = false;
  bool _tienePermisoManejarMonedas = false;
  bool _tienePermisoManejarEntidadesContables = false;
  static bool _tienePermisoAdministrador = false;
  static bool _tienePermisoProgramador = false;
  StreamController<bool> _streamControllerBanca;
  StreamController<List<Loteria>> _streamControllerLoteria;
  StreamController<bool> _streamControllerVenta;
  StreamController<List<Jugada>> _streamControllerJugada;
  var _txtJugada = TextEditingController();
  var _jugadaFocusNode = FocusNode();
  var _txtMontoDisponible = TextEditingController();
  var _txtMonto = TextEditingController(); 
  var _montoFocusNode = FocusNode();
  var _txtMontoLigar = TextEditingController(); 
  var _txtLoteriasSeleccionadasParaLigar = TextEditingController(); 
  var _txtNombreImpresora = TextEditingController(); 
  bool _txtMontoPrimerCaracter = true;
  List<Loteria> _selectedLoterias;
  Timer _timer;
  Timer _timerSaveVentaNoSubidas;
  List<Lotterycolor> _listaLotteryColor;

 
  Usuario _usuario;
  Banca _banca;
  Future<Map<String, dynamic>> futureBanca;
  Future<Map<String, dynamic>> futureUsuario;

  static const String opcionRecargar = "recargar";
  static const String opcionImpresora = "impresora";
  static const String opcionNotificaciones = "notificaciones";


  
// 0xFF2196F3
// 0xFF42A5F5
// MaterialColor colorCustom = MaterialColor(0xFF039BE5, color);
MaterialColor colorCustom = MaterialColor(0xFF0990D0, Utils.color);
// Color _colorPrimary = Utils.fromHex("#1db7bd");
// Color _colorPrimary = Utils.fromHex("#1db7bd");
// Color _colorSegundary = Color(0xFF0990D0);
var _colorPrimary = Utils.fromHex("#1db7bd");
var _colorSegundary = Utils.colorInfo;
FocusNode focusNode;
// static SocketIOManager manager;
static var manager;
// SocketIO socket;
// static SocketIO socketNotificaciones;
static var socketNotificaciones;
String initSocketNotificationTask = "initSocketNotificationTask";



  getIdBanca() async {
    if(await Db.existePermiso("Jugar como cualquier banca")){
      // return listaBanca[_indexBanca].id;
      int idBanca = listaBanca[_indexBanca].id;
      return idBanca == 0 ? await Db.idBanca() : idBanca;
    }else
      return await Db.idBanca();
  }

  Future<Banca> getBanca() async {
    if(await Db.existePermiso("Jugar como cualquier banca"))
      return listaBanca[_indexBanca];
    else{
      var bancaTmp = Banca.fromMap(await Db.getBanca());
      Banca banca = listaBanca.firstWhere((element) => element.id == bancaTmp.id, orElse: () => null);
      return banca;
    }
  }

  indexPost(bool seleccionarBancaPertenecienteAUsuario) async {
    
    
    try{
      setState(() => _cargando = true);
      var banca = await getIdBanca();
      var datos = await TicketService.indexPost(idUsuario: await Db.idUsuario(), idBanca: banca, scaffoldKey: _scaffoldKey);
      
      setState((){
        _cargando = false;
        _idVenta = datos['idVenta'];
        listaBanca = datos["bancas"];
        listaVenta = datos["ventas"];
        _streamControllerBanca.add(true);
        _streamControllerVenta.add(true);
        listaLoteria = datos['loterias'];
        listaLoteriaTmp = datos['loterias'];
        _streamControllerLoteria.add(datos['loterias']);
        _seleccionarPrimeraLoteria();
        (seleccionarBancaPertenecienteAUsuario) ? _seleccionarBancaPertenecienteAUsuario() : null;
        // _emitToGetNewIdTicket();
      });
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  

  guardar() async{
    if(listaJugadas.length <= 0){
      Utils.showAlertDialog(context: context, title: "Jugadas", content: "No hay jugadas realizadas");
      return;
    }

    var c = await DB.create();

    if(_ckbPrint){
      if(await Utils.exiseImpresora() == false){
        Utils.showAlertDialog(context: context, title: "Impresora", content: "Debe registrar una impresora");
        return;
      }

      if(!kIsWeb){
        if(!(await BluetoothChannel.turnOn())){
          return;
        }
      }
    }

    if(!kIsWeb){
      if(await hayJugadasSuciasNuevo()){
        sendNotificationJugadasSucias();
        return;
      }
    }

    // if(!kIsWeb){
      _guardarLocal();
      return;
    // }

    try{
      // setState(() => _cargando = true);
      var datos = await TicketService.guardar(idVenta: _idVenta, compartido:  !_ckbPrint,descuentomonto: await _calcularDescuento(), hayDescuento: _ckbDescuento, total: _calcularTotal(), loterias: Principal.loteriaToJson(_selectedLoterias), jugadas: Principal.jugadaToJson(listaJugadas), idUsuario: await Db.idUsuario(), idBanca: await getIdBanca(), context: context);
      
      setState(() {
         
        _idVenta = datos['idVenta'];
        listaBanca = datos["bancas"];
        _streamControllerBanca.add(true);
        listaLoteria = datos['loterias'];
        listaVenta = datos["ventas"];
        _streamControllerVenta.add(true);
        _streamControllerLoteria.add(datos['loterias']);
        listaJugadas.clear();
        _selectedLoterias.clear();
        _seleccionarPrimeraLoteria();
        _cargando = false;
        listaEstadisticaJugada.clear();
        // (_ckbPrint) ? BluetoothChannel.printTicket(datos['venta'], BluetoothChannel.TYPE_ORIGINAL) : ShareChannel.shareHtmlImageToSmsWhatsapp(html: datos["img"], codigoQr: datos["venta"]["codigoQr"], sms_o_whatsapp: _ckbMessage);
        if(_ckbPrint)
          BluetoothChannel.printTicket(datos['venta'], BluetoothChannel.TYPE_ORIGINAL) ;
      
      });
    } on Exception catch(e){
      // setState(() => _cargando = false);
    }
  }

  _dateToDateTime(var parsed){
    try {
      DateTime fecha = DateTime.parse(parsed["created_at"]);
      return fecha;
    } on Exception catch (e) {
      // TODO
      print("PrincipalView _dateToDateTime error: ${e.toString()}");
      return DateTime.now();
    }
  }


  _guardarLocal() async {
    try {
      if(_connectionNotify.value == false){
        Utils.showAlertDialog(context: context, title: "Sin conexión", content: 'No tiene conexión a internet');
        return;
      }

      setState(() => _cargando = true);

      // var listaDatos = await Realtime.guardarVentaV2(banca: await getBanca(), jugadas: listaJugadas, socket: socket, listaLoteria: listaLoteria, compartido: !_ckbPrint, descuentoMonto: await _calcularDescuento(), tienePermisoJugarFueraDeHorario: _tienePermisoJugarFueraDeHorario, tienePermisoJugarMinutosExtras: _tienePermisoJugarMinutosExtras, tienePermisoJugarSinDisponibilidad: _tienePermisoJugarSinDisponibilidad);
      var listaDatos = await Db.guardarVentaV2(banca: await getBanca(), jugadas: List<Jugada>.from(listaJugadas), socket: socket, listaLoteria: listaLoteria, compartido: !_ckbPrint, descuentoMonto: await _calcularDescuento(), tienePermisoJugarFueraDeHorario: _tienePermisoJugarFueraDeHorario, tienePermisoJugarMinutosExtras: _tienePermisoJugarMinutosExtras, tienePermisoJugarSinDisponibilidad: _tienePermisoJugarSinDisponibilidad);
      var parsed = await TicketService.guardarV2(context: context, sale: listaDatos[0], listSalesdetails: listaDatos[1], usuario: listaDatos[2], codigoBarra: listaDatos[3], idLoterias: listaDatos[4], idLoteriasSuperpale: listaDatos[5]);
      // var parsed = await TicketService.guardarGzipV2(context: context, sale: listaDatos[0], listSalesdetails: listaDatos[1], usuario: listaDatos[2], codigoBarra: listaDatos[3], idLoterias: listaDatos[4], idLoteriasSuperpale: listaDatos[5]);
      // print("PrincipalView _guardarLocal: $parsed");
      listaDatos[0].idTicket = BigInt.from(parsed["idTicket"]);
      listaDatos[0].ticket.id = BigInt.from(parsed["idTicket"]);
      listaDatos[0].ticket.codigoBarra = listaDatos[3];
      listaDatos[0].ticket.idBanca = listaDatos[0].idBanca;
      listaDatos[0].created_at = parsed["created_at"] != null ? _dateToDateTime(parsed) : listaDatos[0].created_at;

      setState(() => _cargando = false);
     _seleccionarPrimeraLoteria();
      listaJugadas = [];
      _streamControllerJugada.add(listaJugadas);
      if(_ckbPrint){
        BluetoothChannel.printTicketV2(sale: listaDatos[0], salesdetails: listaDatos[1], type: BluetoothChannel.TYPE_ORIGINAL);
      }else{
        // var ticketImage = await TicketImage.create(listaDatos[0], listaDatos[1]);
        // ShareChannel.shareHtmlImageToSmsWhatsapp(base64image: ticketImage, codigoQr: listaDatos[0].ticket.codigoBarra, sms_o_whatsapp: _ckbMessage);
        // Navigator.push(context, MaterialPageRoute(builder: (context) => PruebaTicketImage(image: ticketImage,)));
        // ScreenshotController screenshotController = ScreenshotController();
        var ticketImage = await TicketImageV2.create(listaDatos[0], listaDatos[1]);
        ShareChannel.shareHtmlImageToSmsWhatsapp(base64image: ticketImage, codigoQr: listaDatos[0].ticket.codigoBarra, sms_o_whatsapp: _ckbMessage);
      }
    } on dynamic catch (e) {
      setState(() => _cargando = false);
      Utils.showAlertDialog(context: context, content: "$e", title: "Error");
    }
  }

  // esDirecto(String jugada){
  //   return jugada.length == 2;
  // }

  // esPale(String jugada){
  //   return jugada.length == 4 && Utils.toInt(jugada) > 0;
  // }

  // esTripleta(String jugada){
  //   return jugada.length == 6;
  // }

  Future<dynamic> sendNotificationJugadasSucias() async {
     Banca banca = await _selectedBanca();
      String directos = "";
      String pales = "";
      String tripletas = "";
      String superPale = "";
      String pick3 = "";
      String pick4 = "";

      int cantidadDirectos = 0;
      int cantidadPales = 0;
      int cantidadTripletas = 0;
      int cantidadSuperpales = 0;
      int cantidadPick3 = 0;
      int cantidadPick4 = 0;
      listaEstadisticaJugada.sort((a, b) => a.idLoteria.compareTo(b.idLoteria));
      for(int i=0; i < listaEstadisticaJugada.length; i++){
        if(listaEstadisticaJugada[i].descripcionSorteo == "Directo"){
           cantidadDirectos = listaEstadisticaJugada[i].cantidad;
          List<Jugada> listaDirectos = listaJugadas.where((element) => element.sorteo == "Directo" && element.idLoteria == listaEstadisticaJugada[i].idLoteria).toList();
           //Ordenamos los directos de menor a mayor
          listaDirectos.sort((a, b) => a.jugada.compareTo(b.jugada));
          for(int indexDirecto=0; indexDirecto < listaDirectos.length; indexDirecto++){
            if(indexDirecto == 0)
              directos+= "\n${listaEstadisticaJugada[i].descripcion} ${listaEstadisticaJugada[i].descripcionSorteo} ( ${listaEstadisticaJugada[i].cantidad} ) \n";
            directos+= "${listaDirectos[indexDirecto].jugada}\n";
          }
        }
        if(listaEstadisticaJugada[i].descripcionSorteo == "Pale"){
          cantidadPales = listaEstadisticaJugada[i].cantidad;
          List<Jugada> listaPale = listaJugadas.where((element) => element.sorteo == "Pale" && element.idLoteria == listaEstadisticaJugada[i].idLoteria).toList();
          listaPale.sort((a, b) => a.jugada.compareTo(b.jugada));
          for(int indexPale=0; indexPale < listaPale.length; indexPale++){
            if(indexPale == 0)
              pales+= "\n${listaEstadisticaJugada[i].descripcion} ${listaEstadisticaJugada[i].descripcionSorteo} ( ${listaEstadisticaJugada[i].cantidad} ) \n";
            pales+= "${Utils.agregarSignoYletrasParaImprimir(listaPale[indexPale].jugada, listaEstadisticaJugada[i].descripcionSorteo)}\n";
          }
        }
        if(listaEstadisticaJugada[i].descripcionSorteo == "Tripleta"){
          cantidadTripletas = listaEstadisticaJugada[i].cantidad;
          List<Jugada> listaTripleta = listaJugadas.where((element) => element.sorteo == "Tripleta" && element.idLoteria == listaEstadisticaJugada[i].idLoteria).toList();
          listaTripleta.sort((a, b) => a.jugada.compareTo(b.jugada));
          for(int indexTripleta=0; indexTripleta < listaTripleta.length; indexTripleta++){
            if(indexTripleta == 0)
              tripletas+= "\n${listaEstadisticaJugada[i].descripcion} ${listaEstadisticaJugada[i].descripcionSorteo} ( ${listaEstadisticaJugada[i].cantidad} ) \n";
            tripletas+= "${Utils.agregarSignoYletrasParaImprimir(listaTripleta[indexTripleta].jugada, listaEstadisticaJugada[i].descripcionSorteo)}\n";
          }
        }
        if(listaEstadisticaJugada[i].descripcionSorteo == "Super pale"){
          cantidadSuperpales = listaEstadisticaJugada[i].cantidad;
          List<Jugada> listaSuperpale = listaJugadas.where((element) => element.sorteo == "Super pale" && element.idLoteria == listaEstadisticaJugada[i].idLoteria).toList();
          listaSuperpale.sort((a, b) => a.jugada.compareTo(b.jugada));
          for(int indexSuperpale=0; indexSuperpale < listaSuperpale.length; indexSuperpale++){
            if(indexSuperpale == 0)
              superPale+= "\n${listaEstadisticaJugada[i].descripcion} ${listaEstadisticaJugada[i].descripcionSorteo} ( ${listaEstadisticaJugada[i].cantidad} ) \n";
            superPale+= "${Utils.agregarSignoYletrasParaImprimir(listaSuperpale[indexSuperpale].jugada, listaEstadisticaJugada[i].descripcionSorteo)}\n";
          }
        }
        if(listaEstadisticaJugada[i].descripcionSorteo == "Pick 3 Box" || listaEstadisticaJugada[i].descripcionSorteo == "Pick 3 Straight"){
          cantidadPick3 = listaEstadisticaJugada[i].cantidad;
          List<Jugada> listaPick3 = listaJugadas.where((element) => (element.sorteo == "Pick 3 Box" || element.sorteo == "Pick 3 Straight") && element.idLoteria == listaEstadisticaJugada[i].idLoteria).toList();
          listaPick3.sort((a, b) => a.jugada.compareTo(b.jugada));
          for(int indexPick3=0; indexPick3 < listaPick3.length; indexPick3++){
            if(indexPick3 == 0)
              pick3+= "\n${listaEstadisticaJugada[i].descripcion} ${listaEstadisticaJugada[i].descripcionSorteo} ( ${listaEstadisticaJugada[i].cantidad} ) \n";
            pick3+= "${Utils.agregarSignoYletrasParaImprimir(listaPick3[indexPick3].jugada, listaEstadisticaJugada[i].descripcionSorteo)}\n";
          }
        }
        if(listaEstadisticaJugada[i].descripcionSorteo == "Pick 4 Box" || listaEstadisticaJugada[i].descripcionSorteo == "Pick 4 Straight"){
          cantidadPick4 = listaEstadisticaJugada[i].cantidad;
          List<Jugada> listaPick4 = listaJugadas.where((element) => (element.sorteo == "Pick 4 Box" || element.sorteo == "Pick 4 Straight") && element.idLoteria == listaEstadisticaJugada[i].idLoteria).toList();
          listaPick4.sort((a, b) => a.jugada.compareTo(b.jugada));
          for(int indexPick4=0; indexPick4 < listaPick4.length; indexPick4++){
            if(indexPick4 == 0)
              pick4+= "\n${listaEstadisticaJugada[i].descripcion} ${listaEstadisticaJugada[i].descripcionSorteo} ( ${listaEstadisticaJugada[i].cantidad} ) \n";
            pick4+= "${Utils.agregarSignoYletrasParaImprimir(listaPick4[indexPick4].jugada, listaEstadisticaJugada[i].descripcionSorteo)}\n";
          }
        }
      }
        // print("sendNotification Directos: ${directos}");
        // print("sendNotification Pale: ${pales}");
        // print("sendNotification Tripletas: ${tripletas}");

      var u = await Db.getUsuario();
      var fechaActual = DateTime.now();
      String contenido = "${banca.descripcion} ( ${u["usuario"]} ) ${Utils.toDosDigitos(fechaActual.day.toString())}-${Utils.toDosDigitos(fechaActual.month.toString())}-${fechaActual.year} ${Utils.toDosDigitos(fechaActual.hour.toString())}:${Utils.toDosDigitos(fechaActual.second.toString())}\n\n";
      if(directos.isNotEmpty)
        contenido += directos +"\n\n";
      if(pales.isNotEmpty)
        contenido += pales +"\n\n";
      if(tripletas.isNotEmpty)
        contenido += tripletas +"\n\n";
      if(superPale.isNotEmpty)
        contenido += superPale +"\n\n";
      if(pick3.isNotEmpty)
        contenido += pick3 +"\n\n";
      if(pick4.isNotEmpty)
        contenido += pick4 +"\n\n";


      var notificacion = Notificacion(titulo: "Jugadas sucias", subtitulo: "Se ha detectado jugadas sucias en la banca ${banca.descripcion}", contenido: contenido);
      await NotificationService.guardar(context: context, notificacion: notificacion);
    return true;
  }
  

  montoDisponibleHttp() async {
    
    if(_selectedLoterias.length > 1){
      _txtMontoDisponible.text = 'X';
       setState(() => _cargando = false);
      return;
    }

    var map = new Map<String, dynamic>();
    var map2 = new Map<String, dynamic>();
    
    map["idUsuario"] = "1";
    map["jugada"] = _txtJugada.text;
    map["idBanca"] = "11";
    map["idLoteria"] = _selectedLoterias.asMap()[0].id;
    map2["datos"] =map;
    
    const Map<String, String> header = {
      // 'Content-type': 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json',
      'Accept': 'application/json',
    };
    // A function that converts a response body into a List<Photo>.
//  _cargando = true;
      setState((){
      _cargando = true;
      _txtMontoDisponible.text = null;
      });

     http.post(Uri.parse(Utils.URL +"/api/principal/montodisponible"), body: json.encode(map2), headers: header ).then((http.Response resp){
      final int statusCode = resp.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      final parsed = json.decode(resp.body).cast<String, dynamic>();
      // setState(() => _cargando = false);
      // _cargando = false;
      setState((){
        _cargando = false;
      _txtMontoDisponible.text = parsed["monto"];
      });
      
      
    });

  



    
  }

  
  
  Future<List<Banca>> _futureBanca;
  Future<bool> _getDatosSessionUsuario() async {
    setState(() => _cargandoDatosSesionUsuario = true);
    bool seGuardaronLosDatosDeLaSesion = await Principal.mockCheckForSession(scaffoldKey: _scaffoldKey);
    // print("PrincipalScreen inside function seGuardaronLosDatosDeLaSesion: $seGuardaronLosDatosDeLaSesion");
    if(seGuardaronLosDatosDeLaSesion == false){
      await Principal.cerrarSesion(context);
      await stopSocketNoticacionInForeground();
      setState(() => _cargandoDatosSesionUsuario = false);
    }else{
      if(!widget.callThisScreenFromLogin){
        if(await Db.existePermiso("Ver reporte general")){
          Utils.navigateToReporteGeneral(true);
        }else
          setState(() => _cargandoDatosSesionUsuario = false);
      }
      else
        setState(() => _cargandoDatosSesionUsuario = false);
    }

    return seGuardaronLosDatosDeLaSesion;
  }

  _getCurrentTimeZone() async {
    var crossPlatform = CrossTimezone();
    currentTimeZone = await crossPlatform.getCurrentTimezone();
  }

  @override
  void initState() {
    initializeDateFormatting();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
    ]);
    _listaLotteryColor = Lotterycolor.getAll();
    if(widget.callThisScreenFromLogin){
      _getCurrentTimeZone();
      CrossPlatformRequesPermission().requestNecesaryPermissions();

      indexPost(true);
      _getPermisos();
      _getUsuarioYBanca();
      // indexPost(true);
      // manager = SocketIOManager();
      initSocket();
      // // initSocketNoticacion();
      // // initSocketNoticacionInForeground();
      futureBanca = Db.getBanca();
      futureUsuario = Db.getUsuario();
      // _showIntentNotificationIfExists();
    }else{
      _getDatosSessionUsuario().then((value){
       if(value == false)
        return;
        
        _getCurrentTimeZone();
        CrossPlatformRequesPermission().requestNecesaryPermissions();
        _getPermisos();
        _getUsuarioYBanca();
        indexPost(true);
        // manager = SocketIOManager();
        initSocket();
        // initSocketNoticacion();
        // initSocketNoticacionInForeground();
        futureBanca = Db.getBanca();
        futureUsuario = Db.getUsuario();
        _showIntentNotificationIfExists();
      });
    }
    
    
    _timeString = Utils.formatDateTime(DateTime.now());
    _streamControllerBanca = BehaviorSubject();
    _streamControllerLoteria = BehaviorSubject();
    _streamControllerVenta = BehaviorSubject();
    _streamControllerJugada = BehaviorSubject();
    _streamControllerJugada.add(listaJugadas);
    
    
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
      // if(!kIsWeb)
      //   _timerSaveVentaNoSubidas = Timer.periodic(Duration(seconds: 2), (Timer t) => _emitToSaveTicketsNoSubidos());
    
    
    focusNode = FocusNode();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) { 
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      if(notification != null && android != null){
        flutterLocalNotificationsPlugin.show(
          notification.hashCode, 
          notification.title, 
          notification.body, 
          NotificationDetails(
            android:AndroidNotificationDetails(
              channel.id, 
              channel.name, 
              channelDescription: channel.description, 
              color: Colors.blue, 
              playSound: true,
              icon: "@mipmap/ic_loteria"
            )
          ),
          // payload: "Hola mi panaaaaaaaaaaaaaaaaaa"
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) { 
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      

      if(notification != null && android != null){
        // print("PrincipalScreen onMessageOpenedApp data: ${message.data}");
        Navigator.pushNamed(context, "/pagos/ver", arguments:message.data["idPago"] != null ? Utils.toInt(message.data["idPago"]) : null);
        // showDialog(
        //   context: context, 
        //   builder: (context){
        //     return AlertDialog(
        //       title: Text(notification.title),
        //       content: SingleChildScrollView(
        //         child: Column(
        //           children: [
        //             Text(notification.body),
                    
        //           ],
        //         ),
        //       )
        //     );
        //   }
        // );
      }
    });
  
    (CrossKeyPress()).listen((e){
      // print("PrincipalView initState Web: " + e.keyCode);
      // print("PrincipalView myScaffold onChanged ${event.data.keyLabel} guardar: ${(event.logicalKey == LogicalKeyboardKey.asterisk || event.logicalKey == LogicalKeyboardKey.numpadMultiply)}");
      
      // if(event.runtimeType.toString() != 'RawKeyUpEvent')
      //   return;
      // print("PrincipalView myScaffold onChanged ${event.data.keyLabel} guardar: ${(event.logicalKey == LogicalKeyboardKey.asterisk || event.logicalKey == LogicalKeyboardKey.numpadMultiply)}");
      // if(event.logicalKey == LogicalKeyboardKey.asterisk || event.logicalKey == LogicalKeyboardKey.numpadMultiply)
      
      

      if(mounted){
        // print("PrincipalView CrossKeyPress mounted: $mounted route: ${ModalRoute.of(context).isCurrent}");
        //Verificamos si es la misma ruta, si es una ruta diferente pues no dejamos que se ejecute los keypress
        if(!ModalRoute.of(context).isCurrent)
          return;

        if(e.keyCode == "*")
          guardar();
        else if(e.keyCode == "/")
          _escribir("/");
        else if(e.keyCode == "c")
          _showDialogDuplicar(false);
        else if(e.keyCode == "p")
          _pagar(false);
      }
    });
    
    //_montoFuture = fetchMonto();
    
  // platform.setMethodCallHandler(this._saludos);

  }

  _initMobileFunction(){

  }

  _getUsuarioYBanca() async {
    var usuario = await Db.getUsuario();
    var banca = await Db.getBanca();
    // print("PrincipalScreen _getUsuarioYBanca: ${usuario}");
    if(usuario != null){
      _usuario = Usuario.fromMap(usuario);
      if(banca != null)
        _banca = Banca.fromMap(banca);
      else{
        if(listaBanca.length > 0)
          _banca = listaBanca[0];
      }
    }else{
      await Principal.cerrarSesion(context);
    }
  }

   @override
  dispose() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
    // _txtLoteriasSeleccionadasParaLigar.dispose();
    // _txtMontoLigar.dispose();
    _timer.cancel();
    if(!kIsWeb){
      if(_timerSaveVentaNoSubidas != null)
        _timerSaveVentaNoSubidas.cancel();
    }
    focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _streamControllerBanca.close();
    _streamControllerVenta.close();
    _streamControllerLoteria.close();
    // await manager.clearInstance(socket);
    await _disconnectSocket();
    
  }

  static const stream =
      const EventChannel('flutter.bluetooh.stream');

  StreamSubscription _timerSubscription = null;

  _getPermisos() async {
    bool permiso = await Db.existePermiso("Jugar como cualquier banca");
    bool permisoJugarFueraDeHorario = await Db.existePermiso("Jugar fuera de horario");
    bool permisoJugarMinutosExtras = await Db.existePermiso("Jugar minutos extras");
    bool permisoManejarResultados = await Db.existePermiso("Manejar resultados");
    bool permisoMarcarTicketComoPagado = await Db.existePermiso("Marcar ticket como pagado");
    bool permisoMonitorearTicket = await Db.existePermiso("Monitorear ticket");
    bool permisoVerGeneral = await Db.existePermiso("Ver reporte general");
    bool permisoVerDashboard = await Db.existePermiso("Ver Dashboard");
    bool permisoVerVentas = await Db.existePermiso("Ver ventas");
    bool permisoVerHistoricoVentas = await Db.existePermiso("Ver historico ventas");
    bool permisoAccesoAlSistema = await Db.existePermiso("Acceso al sistema");
    bool permisoVerListaDeBalancesDeBancas = await Db.existePermiso("Ver lista de balances de bancas");
    bool permisoVerListaDeBalancesDeBancos = await Db.existePermiso("Ver lista de balances de bancos");
    bool permisoTransacciones = await Db.existePermiso("Manejar transacciones");
    bool permisoAdministrador  = await (await DB.create()).getValue("administrador");
    bool permisoProgramador  = (await (await DB.create()).getValue("tipoUsuario")) == "Programador";
    bool permisoVerReporteJugadas  = await Db.existePermiso("Ver reporte jugadas");
    bool permisoVerAjustes  = await Db.existePermiso("Ver ajustes");
    bool tienePermisoManejarBancas = await Db.existePermiso("Manejar bancas");
    bool tienePermisoManejarUsuarios = await Db.existePermiso("Manejar usuarios");
    bool tienePermisoVerIniciosDeSesion = await Db.existePermiso("Ver inicios de sesion");
    bool tienePermisoVerBalanceBancas = await Db.existePermiso("Ver lista de balances de bancas");
    bool tienePermisoManejarLoterias = await Db.existePermiso("Manejar loterias");
    bool tienePermisoManejarManejarReglas = await Db.existePermiso("Manejar reglas");
    bool tienePermisoManejarManejarGrupos = await Db.existePermiso("Manejar grupos");
    bool tienePermisoVerVentasPorFecha = await Db.existePermiso("Ver ventas por fecha");
    bool tienePermisoJugarSinDisponibilidad = await Db.existePermiso("Jugar sin disponibilidad");
    bool tienePermisoManejarHorariosDeLoterias = await Db.existePermiso("Manejar horarios de loterias");
    bool tienePermisoManejarMonedas = await Db.existePermiso("Manejar monedas");
    bool tienePermisoManejarEntidadesContables = await Db.existePermiso("Manejar entidades contables");
    bool tienePermisoRealizarRecargas = await Db.existePermiso("Realizar recargas");

    print("PrincipalScreen tienePermisoRealizarRecargas: ${tienePermisoRealizarRecargas}");

    if(permisoAccesoAlSistema == false){
      Principal.cerrarSesion(context);
      await stopSocketNoticacionInForeground();
    }

    if(mounted)

    setState((){
      _tienePermisoJugarComoCualquierBanca = permiso;
      _tienePermisoJugarFueraDeHorario = permisoJugarFueraDeHorario;
      _tienePermisoJugarSinDisponibilidad = tienePermisoJugarSinDisponibilidad;
      _tienePermisoJugarMinutosExtras = permisoJugarMinutosExtras;
      _tienePermisoProgramador = permisoProgramador;
      _tienePermisoAdministrador = permisoAdministrador;
      _tienePermisoManejarResultados = permisoManejarResultados;
      _tienePermisoMarcarTicketComoPagado = permisoMarcarTicketComoPagado;
      _tienePermisoMonitorearTicket = permisoMonitorearTicket;
      _tienePermisoVerGeneral = permisoVerGeneral;
      _tienePermisoVerDashboard = permisoVerDashboard;
      _tienePermisoVerVentas = permisoVerVentas;
      _tienePermisoVerHistoricoVentas = permisoVerHistoricoVentas;
      _tienePermisoTransacciones = permisoTransacciones;
      _tienePermisoVerListaDeBalancesDeBancass = permisoVerListaDeBalancesDeBancas;
      _tienePermisoVerListaDeBalancesDeBancos = permisoVerListaDeBalancesDeBancos;
      _tienePermisoVerReporteJugadas = permisoVerReporteJugadas;
      _tienePermisoVerAjustes = permisoVerAjustes;

      _tienePermisoManejarBancas = tienePermisoManejarBancas;
      _tienePermisoManejarUsuarios = tienePermisoManejarUsuarios;
      _tienePermisoVerIniciosDeSesion = tienePermisoVerIniciosDeSesion;
      _tienePermisoVerBalanceBancas = tienePermisoVerBalanceBancas;
      _tienePermisoManejarLoterias = tienePermisoManejarLoterias;
      _tienePermisoManejarManejarReglas = tienePermisoManejarManejarReglas;
      _tienePermisoManejarManejarGrupos = tienePermisoManejarManejarGrupos;

      _tienePermisoVerVentasPorFecha = tienePermisoVerVentasPorFecha;

      _tienePermisoManejarHorariosDeLoterias = tienePermisoManejarHorariosDeLoterias;
      _tienePermisoManejarMonedas = tienePermisoManejarMonedas;
      _tienePermisoManejarEntidadesContables = tienePermisoManejarEntidadesContables;
      _tienePermisoRealizarRecargas = tienePermisoRealizarRecargas;
      // initSocketNoticacionInForeground();
    });
  }

  Future _desconectarYConectarNuevamente() async {
    // await manager.clearInstance(socket);
    await _disconnectSocket();
    _socketContadorErrores = 0;
    initSocket();
  }

  static Future _desconectarYConectarNuevamenteSocketNotificacion() async {
    await manager.clearInstance(socketNotificaciones);
    _socketNotificacionContadorErrores = 0;
    initSocketNoticacion();
  }

  _disconnectSocket(){
    if(socket == null)
      return;
      
    // socket.dis
    socket.dispose();
  }

  _updateBranchesList(Map<String, dynamic> parsed) async {




      try {
        // if(parsed["branch"] == null){
        //   if(parsed['id'] == null)
        //     return

        //   banca = Banca.fromMap(parsed);
        //   print("Dentro principal view _updateBranchesList 3 is null id-descripcion: ${parsed['id']}-${parsed['descripcion']} ${parsed['id'] == null}-${parsed['descripcion'] == null} banca:${banca == null}");
        //   // return;
        // }else{
        //   banca = Banca.fromMap(parsed["branch"]);
        // }

        if(parsed["branch"] == null && parsed["id"] == null)
          return;

        Banca banca = parsed["branch"] == null ? Banca.fromMap(parsed) : Banca.fromMap(parsed["branch"]);

        print("Dentro principal view _updateBranchesList 3 is null: ${banca == null}");

        if(banca == null)
          return;
        
        if(_tienePermisoJugarComoCualquierBanca){
          int idx = listaBanca.indexWhere((element) => element.id == banca.id);
          // print("Dentro principal view _updateBranchesList 3: $idx");
          // print("Dentro principal view _updateBranchesList 4 la primera pertenece: ${banca.loterias.indexWhere((element) => element.descripcion == "La Primera") == -1}");

          if(idx != -1 && idx == _indexBanca){
            listaBanca[idx] = banca;
            quitarLoteriasProvenientesDelSocketQueEstenCerradas(null, loterias: listaLoteriaTmp);
            print("Principal view _updateBranchesList admin quitarLoterias");
          }
        }
        

        if(await Db.idBanca() == banca.id){
          await Db.deleteAllBranches();
          // await Db.insertBranche('Branches', banca.toJson());
          print("Principal view _updateBranchesList limiteVenta: ${banca.limiteVenta}");
          await Db.insertBranch(driftDatabase.Branch(
        id: banca.id, descripcion: banca.descripcion, codigo: banca.codigo, dueno: banca.dueno, idUsuario: banca.usuario != null ? banca.usuario.id : 0, 
        limiteVenta: banca.limiteVenta, descontar: banca.descontar, deCada: banca.deCada, minutosCancelarTicket: banca.minutosCancelarTicket, 
        piepagina1: banca.piepagina1, piepagina2: banca.piepagina2, piepagina3: banca.piepagina3, piepagina4: banca.piepagina4, idMoneda: banca.idMoneda, 
        moneda: banca.moneda, monedaAbreviatura: banca.monedaAbreviatura, monedaColor: banca.monedaColor, status: banca.status, ventasDelDia: banca.ventasDelDia));

          int idx = listaBanca.indexWhere((element) => element.id == banca.id);
          if(idx != -1 && idx == _indexBanca){
            listaBanca[idx] = banca;
            quitarLoteriasProvenientesDelSocketQueEstenCerradas(null, loterias: listaLoteriaTmp);
            print("Principal view _updateBranchesList quitarLoterias");
          }
        }
        
      } catch (e) {
        print("Principal view _updateBranchesList error: $e");
      }
  }

  _changeSocketBranchRoom(int idBancaAnterior) async {
    var idBanca = await getIdBanca();
    print("_changeSocketBranchRoom idBanca: $idBanca");
    if(idBanca != null)
      socket.emit("changeBranchRoom", {"servidor" : await Db.servidor(), "idBanca" : idBanca, "idBancaAnterior" : idBancaAnterior});
  }

  _emitToGetNewIdTicket() async {
    if(kIsWeb)
      return;

    var idBanca = await getIdBanca();
    print("_emitToGetNewIdTicket idBanca: $idBanca");
    if(idBanca != null)
      socket.emit("ticket", await Utils.createJwt({"servidor" : await Db.servidor(), "idBanca" : idBanca, "uuid" : await CrossDeviceInfo.getUIID(), "createNew" : false}));
  }
  _emitToGetVentasDelDia() async {
    if(kIsWeb)
      return;

    var idBanca = await getIdBanca();
    print("_emitToGetVentasDelDia idBanca: ${idBanca}");
    if(idBanca != null)
      socket.emit("obtenerVentasDelDia", await Utils.createJwt({"servidor" : await Db.servidor(), "idBanca" : idBanca}));
  }

  // _emitToSaveTicketsNoSubidos() async {
  //   if(kIsWeb)
  //     return;

  //   if(socket == null)
  //     return;

  //   if(!socket.connected)
  //     return;

  //   var saleMap = await Db.getSaleNoSubida();
  //   print("PrincipalView _emitToSaveTicketsNoSubidos: ${saleMap}");
  //   // var saleMapAll = await Db.query("Sales");

  //   // print("_emitToSaveTicketsNoSubidos before validate, saleMap: ${saleMap}");
  //   // print("_emitToSaveTicketsNoSubidos before validate, saleMapAll: ${saleMapAll}");
  //   Sale sale = saleMap != null ? Sale.fromMap(saleMap) : null;
  //   if(sale == null)
  //     return;

  //   print("PrincipalView _emitToSaveTicketsNoSubidos servidor: ${saleMap["servidor"]}");
  //   print("PrincipalView _emitToSaveTicketsNoSubidos saleObject: ${sale.toJson()}");

  //   if(sale.subido != 0)
  //     return;

  //   var ticketMap = await Db.queryBy("Tickets", "id", sale.idTicket.toInt());
  //   Ticket ticket = Ticket.fromMap(ticketMap);
  //   sale.ticket = ticket;
  //   if(sale.servidor == null)
  //     throw Exception("PrincipalView El servidor es nulo");
  //   if(sale.servidor == '')
  //     throw Exception("PrincipalView El servidor es nulo");
      


  //   var salesdetailsOfThisSaleListMap = await Db.database.rawQuery("SELECT * FROM Salesdetails WHERE idVenta = ${sale.id.toInt()} AND idTicket = ${sale.idTicket.toInt()}");
  //   List<Salesdetails> salesdetails2 = salesdetailsOfThisSaleListMap.map<Salesdetails>((e) => Salesdetails.fromMap(e)).toList();

  //   print("PrincipalView _emitToSaveTicketsNoSubidos ticket: ${ticketMap}");
  //   print("PrincipalView _emitToSaveTicketsNoSubidos sale: ${saleMap}");
  //   print("");
  //   print("");
  //   salesdetailsOfThisSaleListMap.forEach((e) => print("PrincipalView _emitToSaveTicketsNoSubidos salesdetails222: $e"));
    
  //   // return;

  //   socket.emit("guardarVenta", await Utils.createJwt({"servidor" : sale.servidor, "usuario" : await Db.getUsuario(), "sale" : sale.toJsonFull(), "salesdetails" : Salesdetails.salesdetailsToJson(salesdetails2)}));
  // }

  // _addVentaSubidaToListVenta(var parsed) async {
  //   if(Utils.isNumber(parsed) == false)
  //     return;
  //   var saleMap = await Db.queryBy("Sales", "idTicket", parsed); 
  //   Sale sale = saleMap != null ? Sale.fromMap(saleMap) : null;

  //   if(sale == null)
  //     return;

  //   var ticketMap = await Db.queryBy("Tickets", "id", sale.idTicket.toInt());
  //   Ticket ticket = Ticket.fromMap(ticketMap);
  //   sale.ticket = ticket;

  //   if(listaVenta.indexWhere((element) => element.idTicket == sale.idTicket) == -1){
  //     listaVenta.add(Venta(idTicket: sale.idTicket, total: sale.total, codigoBarra: sale.ticket != null ? sale.ticket.codigoBarra : ''));
  //     _streamControllerVenta.add(true);
  //   }
  // }

  Future updateMontoStockFromJugadas(var parsed) async {
    var stocks = await compute(Stock.fromMapList, parsed['stocks']);
    var jugadas = await compute(Principal.updateMontoStockFromJugadas, StockJugada(stocks: stocks, jugadas: listaJugadas));
    for (var jugada in jugadas) {
      var j = listaJugadas.firstWhere((element) => element.loteria.id == jugada.loteria.id && element.idSorteo == jugada.idSorteo && element.jugada == jugada.jugada);
      if(j.idSorteo != 4){
        j.stock = jugada.stock;
        j.stockEliminado = jugada.stockEliminado;
      }else{
        if(j.loteriaSuperPale.id == jugada.loteriaSuperPale.id){
          j.stock = jugada.stock;
          j.stockEliminado = jugada.stockEliminado;
        }
      }
    }
  }

  Future updateMontoBlocksgeneralsFromJugadas(var parsed) async {
    var blocksgenerals = await compute(Blocksgenerals.fromMapList, parsed['blocksgenerals']);
    var jugadas = await compute(Principal.updateMontoBlocksgeneralsFromJugadas, BlocksgeneralsJugada(blocksgenerals: blocksgenerals, jugadas: listaJugadas));
    for (var jugada in jugadas) {
      var j = listaJugadas.firstWhere((element) => element.loteria.id == jugada.loteria.id && element.idSorteo == jugada.idSorteo && element.jugada == jugada.jugada);
      j.stock = jugada.stock;
      j.stockEliminado = jugada.stockEliminado;
    }
  }

  Future updateMontoBlockslotteriesFromJugadas(var parsed) async {
    var blockslotteries = await compute(Blockslotteries.fromMapList, parsed['blockslotteries']);
    var jugadas = await compute(Principal.updateMontoBlockslotteriesFromJugadas, BlockslotteriesJugada(blockslotteries: blockslotteries, jugadas: listaJugadas));
    for (var jugada in jugadas) {
      var j = listaJugadas.firstWhere((element) => element.loteria.id == jugada.loteria.id && element.idSorteo == jugada.idSorteo && element.jugada == jugada.jugada);
      j.stock = jugada.stock;
      j.stockEliminado = jugada.stockEliminado;
    }
  }

  Future updateMontoBlocksplaysFromJugadas(var parsed) async {
    var blocksplays = await compute(Blocksplays.fromMapList, parsed['blocksplays']);

    var jugadas = await compute(Principal.updateMontoBlocksplaysFromJugadas, BlocksplaysJugada(blocksplays: blocksplays, jugadas: listaJugadas));
    for (var jugada in jugadas) {
      var j = listaJugadas.firstWhere((element) => element.loteria.id == jugada.loteria.id && element.idSorteo == jugada.idSorteo && element.jugada == jugada.jugada);
      j.stock = jugada.stock;
      j.stockEliminado = jugada.stockEliminado;
    }
  }

  Future updateMontoBlocksplaysgeneralsFromJugadas(var parsed) async {
    var blocksplaysgenerals = await compute(Blocksplaysgenerals.fromMapList, parsed['blocksplaysgenerals']);
    var jugadas = await compute(Principal.updateMontoBlocksplaysgeneralsFromJugadas, BlocksplaysgeneralsJugada(blocksplaysgenerals: blocksplaysgenerals, jugadas: listaJugadas));
    for (var jugada in jugadas) {
      var j = listaJugadas.firstWhere((element) => element.loteria.id == jugada.loteria.id && element.idSorteo == jugada.idSorteo && element.jugada == jugada.jugada);
      j.stock = jugada.stock;
      j.stockEliminado = jugada.stockEliminado;
    }
  }

  // Future deleteSubidaYesterdaysSale() async {
  //   if(kIsWeb)
  //     return;

  //   try {
  //     DateTime today = await NTP.now(timeout: Duration(seconds: 2));
  //     DateTime yesterday = today.subtract(Duration(days: 1));
  //     DateTime cincoDiasAtras = yesterday.subtract(Duration(days: 5));
  //     print("PricipalView deleteSubidaYesterdaysSale today: ${today.toString()}");
  //     print("PricipalView deleteSubidaYesterdaysSale yesterday: ${yesterday.toString()}");
  //     print("PricipalView deleteSubidaYesterdaysSale cincoDiasAtras: ${cincoDiasAtras.toString()}");
      
  //     print("PrincipalView deleteSubidaYesterdaysSale sales: ${await Db.database.rawQuery("SELECT idTicket FROM Sales WHERE subido == 1 AND created_at BETWEEN '${Utils.dateTimeToDate(cincoDiasAtras, "00:00")}' AND '${Utils.dateTimeToDate(yesterday, "23:59")}'")}");
  //     print("");
  //     print("");
  //     print("");
  //     print("PrincipalView deleteSubidaYesterdaysSale salesdetails: ${await Db.database.rawQuery("SELECT * FROM Tickets WHERE id IN(SELECT idTicket FROM Sales WHERE subido == 1 AND created_at BETWEEN '${Utils.dateTimeToDate(cincoDiasAtras, "00:00")}' AND '${Utils.dateTimeToDate(yesterday, "23:59")}')")}");
  //     print("");
  //     print("");
  //     print("");
  //     print("PrincipalView deleteSubidaYesterdaysSale tickets: ${await Db.database.rawQuery("SELECT jugada, idTicket, created_at FROM Salesdetails WHERE idTicket IN(SELECT idTicket FROM Sales WHERE subido == 1 AND created_at BETWEEN '${Utils.dateTimeToDate(cincoDiasAtras, "00:00")}' AND '${Utils.dateTimeToDate(yesterday, "23:59")}')")}");
      
  //     await Db.database.rawQuery("DELETE FROM Salesdetails WHERE idTicket IN(SELECT idTicket FROM Sales WHERE subido == 1 AND created_at BETWEEN '${Utils.dateTimeToDate(cincoDiasAtras, "00:00")}' AND '${Utils.dateTimeToDate(yesterday, "23:59")}')");
  //     await Db.database.rawQuery("DELETE FROM Tickets WHERE id IN(SELECT idTicket FROM Sales WHERE subido == 1 AND created_at BETWEEN '${Utils.dateTimeToDate(cincoDiasAtras, "00:00")}' AND '${Utils.dateTimeToDate(yesterday, "23:59")}')");
  //     await Db.database.rawQuery("DELETE FROM Sales WHERE subido == 1 AND created_at BETWEEN '${Utils.dateTimeToDate(cincoDiasAtras, "00:00")}' AND '${Utils.dateTimeToDate(yesterday, "23:59")}'");
      
  //     // String query = "DELETE FROM Sales WHERE subido == 1 AND created_at BETWEEN '${Utils.dateTimeToDate(cincoDiasAtras, "00:00")}' AND '${Utils.dateTimeToDate(yesterday, "23:59")}'";
  //     // await Db.database.rawQuery(query);
  //   } on Exception catch (e) {
  //     print("PrincipalView deleteSubidaYesterdaysSale error: ${e.toString()}");
  //     // TODO
  //   }

  //   // String query = "SELECT * FROM Sales WHERE subido == 1 AND created_at BETWEEN '${Utils.dateTimeToDate(cincoDiasAtras, "00:00")}' AND '${Utils.dateTimeToDate(yesterday, "23:59")}' ORDER BY ID ASC";
  //   // var sales = await Db.database.rawQuery(query);
  //   // print("PricipalView deleteSubidaYesterdaysSale yesterdaySale: ${sales.length}");
  //   // print("PricipalView deleteSubidaYesterdaysSale yesterdaySale: $sales");
  //   // query = "DELETE FROM Sales WHERE subido == 1 AND created_at BETWEEN '${Utils.dateTimeToDate(cincoDiasAtras, "00:00")}' AND '${Utils.dateTimeToDate(yesterday, "23:59")}'";
  //   // sales = await Db.database.rawQuery(query);
  //   // query = "SELECT * FROM Sales WHERE subido == 1 AND created_at BETWEEN '${Utils.dateTimeToDate(today, "00:00")}' AND '${Utils.dateTimeToDate(today, "23:59")}' ORDER BY ID ASC";
  //   // sales = await Db.database.rawQuery(query);
  //   // print("PricipalView deleteSubidaYesterdaysSale todaySale: ${sales.length}");
  //   // print("PricipalView deleteSubidaYesterdaysSale todaySale: $sales");
  // }


  Future<void> updatePayment(var parsed) async {
    var c = await DB.create();
    if(parsed != null){
        await c.addOrRemovePagoPendiente(Pago.fromMap(parsed));
    }else{
        await c.removePagoPendiente();
    }
    _futureFactura = c.getPagoPendiente();
    if(_tienePermisoAdministrador || _tienePermisoProgramador){
      if((await c.getPagoPendiente()) != null){
        SHOW_PAYMENT_APPBAR = true;
        Utils.showScaffoldMessanger(context, "Tiene una factura pendiente por pagar");
      }else{
        SHOW_PAYMENT_APPBAR = false;
      }
    }
      
    // ScaffoldMessenger.of(context).showMaterialBanner(
    //           MaterialBanner(
    //             content: const Text('Hello, I am a Material Banner'),
    //             leading: const Icon(Icons.info),
    //             backgroundColor: Colors.yellow,
    //             actions: [
    //               // TextButton(
    //               //   child: const Text('Dismiss'),
    //               //   onPressed: () => ScaffoldMessenger.of(context)
    //               //       .hideCurrentMaterialBanner()
    //               // ),
    //             ],
    //           ),
    //         )
    //       ),
    //     ),
    //   );
    print("PrincipalVIew updatePayment holaa: $parsed");
  }

  initSocket() async {
    // var builder = new JWTBuilder();
    // var token = builder
    //   // ..issuer = 'https://api.foobar.com'
    //   // ..expiresAt = new DateTime.now().add(new Duration(minutes: 1))
    //   ..setClaim('data', {'id': 836, 'username' : "john.doe"})
    //   ..getToken(); // returns token without signature

    // var signer = new JWTHmacSha256Signer('quierocomerpopola');
    // var signedToken = builder.getSignedToken(signer);
    // print(signedToken); // prints encoded JWT
    // var stringToken = signedToken.toString();

  // Utils.showAlertDialog(context: context, title: "Principal initSocket", content: "Before start socket");
    
    // _listaMensajes.add("Before initSocket ${DateTime.now().hour}:${DateTime.now().minute}");
    // manager = SocketIOManager();
    var signedToken = await Utils.createJwtForSocket(data: {'id': 836, 'username' : "john.doe"}, key: 'quierocomerpopola');
    
    // socket = await manager.createInstance(SocketOptions(
    //                 //Socket IO server URI
    //                   // 'http://pruebass.ml:3000',
    //                   // 'http://192.168.43.63:3000',
    //                   // '10.0.0.11:3000',
    //                   Utils.URL_SOCKET,
    //                   nameSpace: "/",
    //                   //Query params - can be used for authentication
    //                   // query: {
    //                   //   "query": 'auth_token=${signedToken}'
    //                   // },
    //                   query: {
    //                     "auth_token": '${signedToken.toString()}',
    //                     "room" : await Db.servidor()
    //                   },

    //                   //Enable or disable platform channel logging
    //                   enableLogging: true,
    //                   // transports: [Transports.WEB_SOCKET/*, Transports.POLLING*/] //Enable required transport
    //     ));       //TODO change the port  accordingly
    print("initSOcket servidor beforeConnect ${await Db.servidor()}");
    print("initSOcket servidor beforeConnect builder ${OptionBuilder().setTimeout(2000).build()}");
    print("initSOcket servidor beforeConnect builder ${OptionBuilder().enableForceNew().build()}");
    print("initSOcket getIdBanca ${await getIdBanca()}");
    // print("initSOcket servidor beforeConnect builder ${OptionBuilder().}");
    // IO.
    IO.cache.forEach((key, value) {print("initSocket cache $key : $value");});
    socket = IO.io(Utils.URL_SOCKET, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      // 'timeout': 1000,
      // 'reconnectionDelay': 1000,
      'extraHeaders': {'foo': 'bar'}, // optional
      'query': 'auth_token='+signedToken +'&room=' + "${await Db.servidor()}" + "&idUsuario=" + "${await Db.idUsuario()}",
      // 'rejectUnauthorized': false
      // 'query': 'auth_token='+"hola" +'&room=' + "valentin"
    });

    socket.on('connect', (_) async {
     print("initSocket connected... servidor: ${await Db.servidor()}");
      // print(data);
      // socket.emit("message", ["Hello world!"]);
      _emitToGetNewIdTicket();
      _emitToGetVentasDelDia();

      // _connectionNotify.value = false;
      // await Realtime.sincronizarTodos(_scaffoldKey, await Db.idBanca());
      // print("PrincipalView initSocket after connect");
      // _connectionNotify.value = true;
      // await _getPermisos();

      _socketContadorErrores = 0;
    });
    socket.on("sincronizarTodos", (data) async {
      print("PrincipalView initSocket sincronizarTodos from server before: $data");
      var parsed = await compute(Utils.parseDatosDynamic, data);
      if(parsed["error"] == 1)
        return;
      // print("PrincipalView initSocket sincronizarTodos from server before: ${parsed["datos"]["idBanca"]}");

      _changeSocketBranchRoom(parsed["datos"]["idBanca"]);
      _connectionNotify.value = true;
      if(listaJugadas.length > 0){
        await updateMontoBlocksgeneralsFromJugadas(data["datos"]);
        await updateMontoBlocksplaysgeneralsFromJugadas(data["datos"]);
        await updateMontoBlockslotteriesFromJugadas(data["datos"]);
        await updateMontoBlocksplaysFromJugadas(data["datos"]);
        await updateMontoStockFromJugadas(data["datos"]);
      }
      await Realtime.sincronizarTodosDataBatch(_scaffoldKey, parsed["datos"]);
      _connectionNotify.value = true;
      await _getPermisos();
      await updatePayment(parsed["datos"]["payment"]);
      // deleteSubidaYesterdaysSale();
      print("PrincipalView initSocket sincronizarTodos from server after: $data");
    });
    socket.on("initLoteriasOrdenadasPorHoraCierre", (data) async {
      print("PrincipalView initSocket initLoteriasOrdenadasPorHoraCierre from server after: $data");
      var parsed = await compute(Utils.parseDatosDynamic, data);
      quitarLoteriasProvenientesDelSocketQueEstenCerradas(parsed["datos"]);
    });
    // socket.onConnect((data) => print("PrincipalView initSocket onConnect: $data"));

    // socket.onConnect((data) async {
    //   print("connected...");
    //   print(data);
    //   socket.emit("message", ["Hello world!"]);
    //   await Realtime.sincronizarTodos(_scaffoldKey);
    //   await _getPermisos();
    //   _socketContadorErrores = 0;
    // // _listaMensajes.add("initSocket onConnect ${DateTime.now().hour}:${DateTime.now().minute}");

    // });
    //  socket.on("realtime-stock:App\\Events\\RealtimeStockEvent", (data) async {   //sample event
    //   // var parsed = Utils.parseDatos(data);
    //   var parsed = data.cast<String, dynamic>();
    //   // print('type List<stocks>: ${parsed['stocks'].runtimeType.toString() ==  'List<dynamic>'}');
    //   // print('type stock: ${parsed['stocks']}');
    //   //await Realtime.addStocksDatosNuevos(parsed['stocks']);
    //   // print('event parsed: ${parsed}');
    //   // print("realtime-stock1");
    //   // print(data);
    //   print("realtime-stock antes");
    //   if(parsed['stocks'].runtimeType.toString() !=  'List<dynamic>'){
    //     await Realtime.addStock(parsed['stocks']);
    //     // print("realtime-stock despues");
    //   }else{
    //     await Realtime.addStocks(parsed['stocks']);
    //   }
    // });
    // if(kIsWeb == false){
      socket.on("realtime-stock:App\\Events\\RealtimeStockEvent", (data) async {   //sample event
        // var parsed = data.cast<String, dynamic>();
        print("PrincipalView realtime-stock:App\\Events\\RealtimeStockEvent primero parsed: $data");
        var parsed = await compute(Utils.parseDatosDynamic, data);
        print("PrincipalView realtime-stock:App\\Events\\RealtimeStockEvent parsed: $parsed");
        var stocks = await compute(Stock.fromMapList, parsed['stocks']);
        // await compute(Principal.updateMontoStockFromJugadas, StockJugada(stocks: stocks, jugadas: listaJugadas));
        Principal.updateMontoStockFromJugadas(StockJugada(stocks: stocks, jugadas: listaJugadas));
        await Realtime.addStocks(stocks, (parsed['action'] == 'delete') ? true : false);
      });
      socket.on("blocksgenerals:App\\Events\\BlocksgeneralsEvent", (data) async {   //sample event
        var parsed = data.cast<String, dynamic>();
        var blocksgenerals = await compute(Blocksgenerals.fromMapList, parsed['blocksgenerals']);
        print("blocksgeneralsEvent: $parsed");
        // await compute(Principal.updateMontoBlocksgeneralsFromJugadas, BlocksgeneralsJugada(blocksgenerals: blocksgenerals, jugadas: listaJugadas));
        Principal.updateMontoBlocksgeneralsFromJugadas(BlocksgeneralsJugada(blocksgenerals: blocksgenerals, jugadas: listaJugadas, eliminar: (parsed['action'] == 'delete') ? true : false));
        await Realtime.addBlocksgeneralsDatosNuevos(blocksgenerals, (parsed['action'] == 'delete') ? true : false);
      });
      socket.on("blockslotteries:App\\Events\\BlockslotteriesEvent", (data) async {   //sample event
        var parsed = data.cast<String, dynamic>();
        print("PrincipalViewo initSocket blockslotteries: $parsed");
        // print("PrincipalViewo initSocket blockslotteries action: ${parsed['action']}");
        // print("PrincipalViewo initSocket blockslotteries data: ${parsed['blockslotteries']}");
        var blockslotteries = await compute(Blockslotteries.fromMapList, parsed['blockslotteries']);
        Principal.updateMontoBlockslotteriesFromJugadas(BlockslotteriesJugada(blockslotteries: blockslotteries, jugadas: listaJugadas, eliminar: (parsed['action'] == 'delete') ? true : false));
        await Realtime.addBlockslotteriesDatosNuevos(blockslotteries, (parsed['action'] == 'delete') ? true : false);
      });
      socket.on("blocksplays:App\\Events\\BlocksplaysEvent", (data) async {   //sample event
        var parsed = data.cast<String, dynamic>();
        print("BlocksplaysEvent: $parsed");
        var blocksplays = await compute(Blocksplays.fromMapList, parsed['blocksplays']);
        Principal.updateMontoBlocksplaysFromJugadas(BlocksplaysJugada(blocksplays: blocksplays, jugadas: listaJugadas, eliminar: (parsed['action'] == 'delete') ? true : false));
        await Realtime.addBlocksplaysDatosNuevos(blocksplays, (parsed['action'] == 'delete') ? true : false);
      });
      socket.on("blocksplaysgenerals:App\\Events\\BlocksplaysgeneralsEvent", (data) async {   //sample event
        var parsed = data.cast<String, dynamic>();
        print("BlocksplaysgeneralsEvent: $parsed");
        var blocksplaysgenerals = await compute(Blocksplaysgenerals.fromMapList, parsed['blocksplaysgenerals']);
        Principal.updateMontoBlocksplaysgeneralsFromJugadas(BlocksplaysgeneralsJugada(blocksplaysgenerals: blocksplaysgenerals, jugadas: listaJugadas, eliminar: (parsed['action'] == 'delete') ? true : false));
        await Realtime.addBlocksplaysgeneralsDatosNuevos(blocksplaysgenerals, (parsed['action'] == 'delete') ? true : false);
      });
      socket.on("versions:App\\Events\\VersionsEvent", (data) async {   //sample event
        var parsed = data.cast<String, dynamic>();
        await Principal.version(context: _scaffoldKey.currentContext, version: parsed["version"]);
      });
      socket.on("blocksdirtygenerals:App\\Events\\BlocksdirtygeneralsEvent", (data) async {   //sample event
        var parsed = data.cast<String, dynamic>();
        print("Principalview blocksdirtygenerals: $parsed");
        await Realtime.addBlocksdirtygeneralsDatosNuevos(parsed['blocksdirtygenerals'], (parsed['action'] == 'delete') ? true : false);
      });
      socket.on("blocksdirty:App\\Events\\BlocksdirtyEvent", (data) async {   //sample event
        var parsed = data.cast<String, dynamic>();
        print("Principalview blocksdirty: $parsed");
        await Realtime.addBlocksdirtyDatosNuevos(parsed['blocksdirty'], (parsed['action'] == 'delete') ? true : false);
      });

      socket.on("ticket", (data) async {
        // print("Socket ticket from server before: $data");
        // if(data != null){
        //   Ticket ticket = Ticket.fromMap(data);
        //     print("Socket ticket from server before validation ticket: ${ticket.toJson()}");
        //     print("Socket ticket from server before validation banca: ${await getIdBanca()}");
        //   if(ticket.idBanca != await getIdBanca()){
        //     _emitToGetNewIdTicket();
        //     print("Socket ticket from server inside validation: $data");
        //     return;
        //   }
        // }

        // Realtime.createTicketIfNotExists(data);
        // print("Socket ticket from server after: $data");
      });
      socket.on("recibirVenta", (data) async {
        print("Socket recibirVenta from server before: $data");
        // await Realtime.setVentaToSubido(data);
        // await _addVentaSubidaToListVenta(data);
        print("Socket recibirVenta from server after: $data");
      });
      socket.on("obtenerVentasDelDia", (data) async {
        print("Socket obtenerVentasDelDia 1: $data");
        if(data == null)
          return;

        var parsed = data.cast<String, dynamic>();
        print("Socket obtenerVentasDelDia 2: $data");
        await _updateBranchesList(parsed);
        print("Socket obtenerVentasDelDia 3: $data");
      });
    // }
    
    socket.on("users:App\\Events\\UsersEvent", (data) async {   //sample event
      // var parsed = data.cast<String, dynamic>();
      var parsed = await compute(Utils.parseDatosDynamic, data);
      print("PrincipalView socket usuario: ${context == null}");
      await Realtime.usuario(context:  _scaffoldKey.currentContext != null ? _scaffoldKey.currentContext : context, usuario: parsed["user"]);
      await _getPermisos();
    });
    socket.on("lotteries:App\\Events\\LotteriesEvent", (data) async {   //sample event
      // var parsed = data.cast<String, dynamic>();
      var parsed = await compute(Utils.parseDatosDynamic, data);
      quitarLoteriasProvenientesDelSocketQueEstenCerradas(parsed);
      // print("lotteriesevent: $parsed");
    });
    
    socket.on("settings:App\\Events\\SettingsEvent", (data) async {   //sample event
      var parsed = data.cast<String, dynamic>();
      Realtime.ajustes(parsed);
      // await Principal.version(context: _scaffoldKey.currentContext, version: parsed["version"]);
    });
    socket.on("branches:App\\Events\\BranchesEvent", (data) async {   //sample event
      var parsed = data.cast<String, dynamic>();
      _updateBranchesList(parsed);
      // await Principal.version(context: _scaffoldKey.currentContext, version: parsed["version"]);
    });
    socket.on("payment:App\\Events\\PaymentEvent", (data) async {   //sample event
      var parsed = data.cast<String, dynamic>();
      await updatePayment(parsed["payment"]);
      print("PrincipalVIew PaymentEvent holaa: $parsed");
      // await Principal.version(context: _scaffoldKey.currentContext, version: parsed["version"]);
    });
    socket.on("error", (data){   //sample event
      _connectionNotify.value = false;
      print("onError: $data");
    });
    socket.on('connect_error', (data) {
      _connectionNotify.value = false;
      print("PrincipalView initSocket connect_error: $data");
    });
    socket.on('error', (data) {
      _connectionNotify.value = false;
      print("errr: ${data}");
    });
    socket.onDisconnect((data){
      _connectionNotify.value = false;
      print("principalview onDisconnect: ${data}");
    });
    //  socket.onConnecting((data){
    //   // _connectionNotify.value = false;
    //   print("principalview onConnecting: ${data}");
    // });
    //  socket.onReconnecting((data){
    //   // _connectionNotify.value = false;
    //   print("principalview onReconnecting: ${data}");
    // });
    //  socket.onConnectError((data){
    //   // _connectionNotify.value = false;
    //   print("principalview onConnectError: ${data}");
    // });
  //   socket.onConnectError((er) async {
  //     _socketContadorErrores++;
  //     if(_socketContadorErrores == 4)
  //       await _desconectarYConectarNuevamente();
  //     print("onConnectError: $er");
  //   _listaMensajes.add("initSocket onConnectError ${DateTime.now().hour}:${DateTime.now().minute}");

  // // Utils.showAlertDialog(context: context, title: "Principal initSocket", content: "onConnectError start socket");

  //   });
  //   socket.onError((e) => print(e));
    socket.connect();





    
  }

  initSocketNoticacionInForeground() async {
    print("Principal initSocketNoticacionInForeground: admin: $_tienePermisoAdministrador pro: $_tienePermisoProgramador");
    if(_tienePermisoAdministrador == true || _tienePermisoProgramador == true)
      await MySocket.connect(await Db.servidor());
  }

  stopSocketNoticacionInForeground() async {
    if(_tienePermisoAdministrador == true || _tienePermisoProgramador == true)
      await MySocket.disconnect();
  }

  //Socket notificacion
  static initSocketNoticacion() async {
    // var builder = new JWTBuilder();
    // var token = builder
    //   // ..issuer = 'https://api.foobar.com'
    //   // ..expiresAt = new DateTime.now().add(new Duration(minutes: 1))
    //   ..setClaim('data', {'id': 836, 'username' : "john.doe"})
    //   ..getToken(); // returns token without signature

    // var signer = new JWTHmacSha256Signer('quierocomerpopola');
    // var signedToken = builder.getSignedToken(signer);
    // print(signedToken); // prints encoded JWT
    // var stringToken = signedToken.toString();

  // Utils.showAlertDialog(context: context, title: "Principal initSocket", content: "Before start socket");
    
    // _listaMensajes.add("Before initSocket ${DateTime.now().hour}:${DateTime.now().minute}");
    
    var signedToken = Utils.createJwtForSocket(data: {'id': 836, 'username' : "john.doe"}, key: 'quierocomerpopola');
    



print("Inside socketNotificaciones");

  //   socketNotificaciones = await manager.createInstance(SocketOptions(
  //                   //Socket IO server URI
  //                     // 'http://pruebass.ml:3000',
  //                     // 'http://192.168.43.63:3000',
  //                     // '10.0.0.11:3000',
  //                     Utils.URL_SOCKET,
  //                     nameSpace: "/",
  //                     //Query params - can be used for authentication
  //                     // query: {
  //                     //   "query": 'auth_token=${signedToken}'
  //                     // },
  //                     query: {
  //                       "auth_token": '${signedToken.toString()}',
  //                       "room" : await Db.servidor()
  //                     },

  //                     //Enable or disable platform channel logging
  //                     enableLogging: true,
  //                     // transports: [Transports.WEB_SOCKET/*, Transports.POLLING*/] //Enable required transport
  //       )); 
  //   socketNotificaciones.onConnect((data) async {
  //     _socketNotificacionContadorErrores = 0;
  //     print("socketNotificaciones connected...");
  //     print(data);
  //     // socketNotificaciones.emit("message", ["Hello world Notificaciones!"]);
  //   });
  //   socketNotificaciones.on("notification:App\\Events\\NotificationEvent", (data) async {   //sample event
  //     var parsed = data.cast<String, dynamic>();
      
  //     if(_tienePermisoAdministrador == true || _tienePermisoProgramador == true){
  //       var notificacion = Notificacion.fromMap(parsed["notification"]);
  //       print("Principalview NotificationEvent Mostrar notificacion: ${notificacion.toJson()}");
  //       MyNotification.show(route: "/notificaciones", title: notificacion.titulo, subtitle: notificacion.subtitulo, content: notificacion.contenido);
  //     }
  //     print("Principalview NotificationEvent: $parsed");
  //   });
  //   socketNotificaciones.onConnectError((er) async {
  //     _socketNotificacionContadorErrores++;
  //     if(_socketNotificacionContadorErrores == 4)
  //       await _desconectarYConectarNuevamenteSocketNotificacion();
  //     print("onConnectError: $er");
  //   });
  //   socketNotificaciones.on("error", (data){   //sample event
  //     print("onErrorNoti: $data");
  //   // _listaMensajes.add("initSocket OnError ${DateTime.now().hour}:${DateTime.now().minute}");

  // // Utils.showAlertDialog(context: context, title: "Principal initSocket error", content: "onError start socket");

  //     // print(data);
  //   });
  //   socketNotificaciones.onError((e) => print("SocketNotificaciones error $e"));
  //   socketNotificaciones.connect();

    print("inside NotificationEvent:");
  }

_showIntentNotificationIfExists() async {
  if(kIsWeb)
    return;
    
  var notificacion = await MyNotification.getIntentDataNotification();
  
  if(notificacion != null){
    // print("_showIntentNotificationIfExists ${notificacion.toJson()}");
    Navigator.pushNamed(context, "/verNotificaciones", arguments: notificacion);
  }
}

  _ckbDescuentoChanged(newValue){
    setState(() {
      _ckbDescuento = newValue; 
    });
  }
  _ckbPrintChanged(newValue){
    setState(() {
      _ckbPrint = newValue; 
      if(newValue){
        _ckbMessage = false;
        _ckbWhatsapp = false;
      }
    });
  }
  _ckbMessageChanged(newValue){
    setState(() {
      _ckbMessage = newValue; 
      if(newValue){
        _ckbPrint = false;
        _ckbWhatsapp = false;
      }
    });
  }

  _ckbWhatsappChanged(newValue){
    setState(() {
      _ckbWhatsapp = newValue; 
      if(newValue){
        _ckbMessage = false;
        _ckbPrint = false;
      }
    });
  }

  _duplicar(Map<String, dynamic> datos, [bool copiarJugadasSeleccionadas = false]) async {
    bool cargando = true;
    ValueNotifier cargandoNotifier = ValueNotifier(true);
    List loteriasAbiertas = listaLoteria.map((l) => l).toList();
    print("PrincipalView _duplicar: ${datos['loterias']}");
    List<dynamic> loteriasAduplicar = [];
    List<Duplicar> listaDuplicar = await Principal.showDialogDuplicarV2(context: context, scaffoldKey: _scaffoldKey, mapVenta: datos, loterias: loteriasAbiertas, esCopiarJugadasSeleccionadas: copiarJugadasSeleccionadas);
    
    if(loteriasAduplicar == null || listaDuplicar == null){
      if(copiarJugadasSeleccionadas)
        listaJugadasSeleccionadas.clear();

      return;
    }

    await TicketService.showDialogJugadasSinMontoDisponible(
      context, 
      () async {
        List<Jugada> jugadasSinMontoDisponible = [];
        for (var duplicar in listaDuplicar) {
          if(duplicar.loteriasADuplicar.length == 0)
            continue;
            
            if(duplicar.loteriaSuperpale == null){
              List<dynamic> jugadas = 
                copiarJugadasSeleccionadas ? 
                listaJugadasSeleccionadas.where((element) => element.idLoteria == duplicar.loteria.id && element.sorteo != Draws.superPale).toList()
                :
                List.from(datos["jugadas"]).where((e) => e["idLoteria"] == duplicar.loteria.id && e["sorteo"] != Draws.superPale).toList();

              for (var jugada in jugadas) {
                print("No super: $jugada");
                if(!copiarJugadasSeleccionadas)
                  jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
                
                List<Jugada> jugadasSinMontoDisponibleTmp = await addJugada(jugada: copiarJugadasSeleccionadas ? jugada.jugada : Utils.ordenarMenorAMayor(jugada["jugada"]), montoDisponible: "0", monto: copiarJugadasSeleccionadas ? jugada.monto.toString() : jugada["monto"], selectedLoterias: duplicar.loteriasADuplicar, cambiarFocusJugadaMonto: false);
                if(jugadasSinMontoDisponibleTmp.length > 0)
                  jugadasSinMontoDisponible.addAll(jugadasSinMontoDisponibleTmp);
                  
              }
            }else{
              List<dynamic> jugadas = 
              copiarJugadasSeleccionadas ? 
                listaJugadasSeleccionadas.where((element) => element.idLoteria == duplicar.loteria.id && element.idLoteriaSuperpale == duplicar.loteriaSuperpale.id && element.sorteo == Draws.superPale).toList()
                :
                List.from(datos["jugadas"]).where((e) => e["idLoteria"] == duplicar.loteria.id && e["idLoteriaSuperpale"] == duplicar.loteriaSuperpale.id && e["sorteo"] == Draws.superPale).toList();
              
              for (var jugada in jugadas) {
                print("Si super: $jugada");
                if(!copiarJugadasSeleccionadas)
                  jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
                
                List<Jugada> jugadasSinMontoDisponibleTmp = await addJugada(jugada: copiarJugadasSeleccionadas ? jugada.jugada : Utils.ordenarMenorAMayor(jugada["jugada"]), montoDisponible: "0", monto: copiarJugadasSeleccionadas ? jugada.monto.toString() : jugada["monto"], selectedLoterias: duplicar.loteriasADuplicar, cambiarFocusJugadaMonto: false);
                if(jugadasSinMontoDisponibleTmp.length > 0)
                  jugadasSinMontoDisponible.addAll(jugadasSinMontoDisponibleTmp);
              }
            }
        }

        if(copiarJugadasSeleccionadas)
          listaJugadasSeleccionadas.clear();

        if(jugadasSinMontoDisponible.length == 0)
          Navigator.pop(context);
        else
          cargandoNotifier.value = false;

        return jugadasSinMontoDisponible;
      },
      // title: cargando ? 'Duplicando...' : 'Error monto disponible'
      title: ValueListenableBuilder(
        valueListenable: cargandoNotifier, 
        builder: (context, value, __) => value ? Text('${copiarJugadasSeleccionadas ? 'Copiando' : 'Duplicando'}...') : Text('Error monto', softWrap: true,)
      ),
      okButton: ValueListenableBuilder(
        valueListenable: cargandoNotifier, 
        builder: (context, value, __) => value ? SizedBox.shrink() : TextButton(onPressed: () => Navigator.pop(context), child: Text("Ok", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)))
      ),
    );
    
    return;

    loteriasAduplicar.forEach((l) async {
      for(Map<String, dynamic> jugada in datos["jugadas"]){
        if(l["id"] == jugada["idLoteria"]){
          if(l["duplicar"] == '- NO MOVER -'){
            if(jugada["sorteo"] != "Super pale"){
              jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
              // print("duplicarSuperpale ${l["duplicarSuperpale"]}");
              await addJugada(loteriaMap: l, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
            }else{
              Map<String, dynamic> mapLoteria = Map<String, dynamic>();
              Loteria loteria = listaLoteria.firstWhere((lote) => lote.id == l["id"]);
              if(l["duplicarSuperpale"] == '- NO MOVER -'){
                  mapLoteria["id"] = loteria.id;
                  mapLoteria["descripcion"] = loteria.descripcion;
                  mapLoteria["abreviatura"] = loteria.abreviatura;
                  // print("_duplicar Superpale jugadaBefore: ${jugada["jugada"]}");
                  jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
                  // print("_duplicar Superpale jugadaAfter: ${jugada["jugada"]}");
                  await addJugada(loteriaMap: mapLoteria, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
                }
                else if(l["duplicarSuperpale"] != '- NO COPIAR -'){
                  // print("duplicarSuperpale: ${l["duplicarSuperpale"]}");
                  mapLoteria = Map<String, dynamic>();
                  loteria = listaLoteria.firstWhere((lote) => lote.id == l["duplicarIdSuperpale"][0]);
                  Loteria loteriaSuperpale = listaLoteria.firstWhere((lote) => lote.id == l["duplicarIdSuperpale"][1]);
                  if(loteria.id > loteriaSuperpale.id){
                    Loteria tmp = loteriaSuperpale;
                    loteriaSuperpale = loteria;
                    loteria = tmp;
                  }

                  // print("loteriaSuperpale show: ${loteriaSuperpale.toJson()}");
                  mapLoteria["id"] = loteria.id;
                  mapLoteria["descripcion"] = loteria.descripcion;
                  mapLoteria["abreviatura"] = loteria.abreviatura;
                  jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
                  jugada["loteriaSuperpale"] = loteriaSuperpale.toJson();
                  await addJugada(loteriaMap: mapLoteria, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
                }
            }
          }
          else if(l["duplicar"] != '- NO COPIAR -'){
            // print('dentro no copiar');
            Map<String, dynamic> mapLoteria = Map<String, dynamic>();
            Loteria loteria = listaLoteria.firstWhere((lote) => lote.id == l["duplicarId"]);
            if(loteria != null){
              if(jugada["sorteo"] != "Super pale"){
                mapLoteria["id"] = loteria.id;
                mapLoteria["descripcion"] = loteria.descripcion;
                mapLoteria["abreviatura"] = loteria.abreviatura;
                jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
                await addJugada(loteriaMap: mapLoteria, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
              }else{
                loteria = listaLoteria.firstWhere((lote) => lote.id == l["id"]);
                if(l["duplicarSuperpale"] == '- NO MOVER -'){
                  mapLoteria["id"] = loteria.id;
                  mapLoteria["descripcion"] = loteria.descripcion;
                  mapLoteria["abreviatura"] = loteria.abreviatura;
                  jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
                  await addJugada(loteriaMap: mapLoteria, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
                }
                else if(l["duplicarSuperpale"] != '- NO COPIAR -'){
                  // print("duplicarSuperpale: ${l["duplicarSuperpale"]}");
                  mapLoteria = Map<String, dynamic>();
                  loteria = listaLoteria.firstWhere((lote) => lote.id == l["duplicarIdSuperpale"][0]);
                  Loteria loteriaSuperpale = listaLoteria.firstWhere((lote) => lote.id == l["duplicarIdSuperpale"][1]);
                  if(loteria.id > loteriaSuperpale.id){
                    Loteria tmp = loteriaSuperpale;
                    loteriaSuperpale = loteria;
                    loteria = tmp;
                  }

                  mapLoteria["id"] = loteria.id;
                  mapLoteria["descripcion"] = loteria.descripcion;
                  mapLoteria["abreviatura"] = loteria.abreviatura;
                  jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
                  jugada["loteriaSuperpale"] = loteriaSuperpale.toJson();
                  await addJugada(loteriaMap: mapLoteria, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
                }
              }
            }

          }
        }
      }
    });
  }

  _duplicarViejo(Map<String, dynamic> datos) async {
    List loteriasAbiertas = listaLoteria.map((l) => l).toList();
    List<dynamic> loteriasAduplicar = await Principal.showDialogDuplicar(context: context, scaffoldKey: _scaffoldKey, mapVenta: datos, loterias: loteriasAbiertas);
    
    if(loteriasAduplicar == null)
      return;

    loteriasAduplicar.forEach((l) async {
      for(Map<String, dynamic> jugada in datos["jugadas"]){
        if(l["id"] == jugada["idLoteria"]){
          if(l["duplicar"] == '- NO MOVER -'){
            if(jugada["sorteo"] != "Super pale"){
              jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
              // print("duplicarSuperpale ${l["duplicarSuperpale"]}");
              await addJugada(loteriaMap: l, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
            }else{
              Map<String, dynamic> mapLoteria = Map<String, dynamic>();
              Loteria loteria = listaLoteria.firstWhere((lote) => lote.id == l["id"]);
              if(l["duplicarSuperpale"] == '- NO MOVER -'){
                  mapLoteria["id"] = loteria.id;
                  mapLoteria["descripcion"] = loteria.descripcion;
                  mapLoteria["abreviatura"] = loteria.abreviatura;
                  // print("_duplicar Superpale jugadaBefore: ${jugada["jugada"]}");
                  jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
                  // print("_duplicar Superpale jugadaAfter: ${jugada["jugada"]}");
                  await addJugada(loteriaMap: mapLoteria, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
                }
                else if(l["duplicarSuperpale"] != '- NO COPIAR -'){
                  // print("duplicarSuperpale: ${l["duplicarSuperpale"]}");
                  mapLoteria = Map<String, dynamic>();
                  loteria = listaLoteria.firstWhere((lote) => lote.id == l["duplicarIdSuperpale"][0]);
                  Loteria loteriaSuperpale = listaLoteria.firstWhere((lote) => lote.id == l["duplicarIdSuperpale"][1]);
                  if(loteria.id > loteriaSuperpale.id){
                    Loteria tmp = loteriaSuperpale;
                    loteriaSuperpale = loteria;
                    loteria = tmp;
                  }

                  // print("loteriaSuperpale show: ${loteriaSuperpale.toJson()}");
                  mapLoteria["id"] = loteria.id;
                  mapLoteria["descripcion"] = loteria.descripcion;
                  mapLoteria["abreviatura"] = loteria.abreviatura;
                  jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
                  jugada["loteriaSuperpale"] = loteriaSuperpale.toJson();
                  await addJugada(loteriaMap: mapLoteria, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
                }
            }
          }
          else if(l["duplicar"] != '- NO COPIAR -'){
            // print('dentro no copiar');
            Map<String, dynamic> mapLoteria = Map<String, dynamic>();
            Loteria loteria = listaLoteria.firstWhere((lote) => lote.id == l["duplicarId"]);
            if(loteria != null){
              if(jugada["sorteo"] != "Super pale"){
                mapLoteria["id"] = loteria.id;
                mapLoteria["descripcion"] = loteria.descripcion;
                mapLoteria["abreviatura"] = loteria.abreviatura;
                jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
                await addJugada(loteriaMap: mapLoteria, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
              }else{
                loteria = listaLoteria.firstWhere((lote) => lote.id == l["id"]);
                if(l["duplicarSuperpale"] == '- NO MOVER -'){
                  mapLoteria["id"] = loteria.id;
                  mapLoteria["descripcion"] = loteria.descripcion;
                  mapLoteria["abreviatura"] = loteria.abreviatura;
                  jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
                  await addJugada(loteriaMap: mapLoteria, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
                }
                else if(l["duplicarSuperpale"] != '- NO COPIAR -'){
                  // print("duplicarSuperpale: ${l["duplicarSuperpale"]}");
                  mapLoteria = Map<String, dynamic>();
                  loteria = listaLoteria.firstWhere((lote) => lote.id == l["duplicarIdSuperpale"][0]);
                  Loteria loteriaSuperpale = listaLoteria.firstWhere((lote) => lote.id == l["duplicarIdSuperpale"][1]);
                  if(loteria.id > loteriaSuperpale.id){
                    Loteria tmp = loteriaSuperpale;
                    loteriaSuperpale = loteria;
                    loteria = tmp;
                  }

                  mapLoteria["id"] = loteria.id;
                  mapLoteria["descripcion"] = loteria.descripcion;
                  mapLoteria["abreviatura"] = loteria.abreviatura;
                  jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
                  jugada["loteriaSuperpale"] = loteriaSuperpale.toJson();
                  await addJugada(loteriaMap: mapLoteria, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
                }
              }
            }

          }
        }
      }
    });
  }


  _cambiarServidor() async {
    var c = await DB.create();
    var tipoUsuario = await c.getValue("tipoUsuario");
    if(tipoUsuario == "Programador"){
      var datosServidor = await Db.getAllServer();

      print("_cambiarServidor: $datosServidor");
      if(datosServidor == null)
        return;

      List<Servidor> listaServidor = datosServidor.map<Servidor>((json) => Servidor.fromMap(json.toJson())).toList();
      String servidorActual = await Db.servidor();
      // print("_cambiarServidor listaServidor: ${listaServidor.length} : servidor: $servidorActual");
      int indexServidor = (listaServidor.length > 0) ? listaServidor.indexWhere((element) => element.descripcion == servidorActual) : -1;
      Servidor servidorSeleccionado = (indexServidor != -1) ? listaServidor[indexServidor] : null;
      print("_cambiarServidor servidorRetornado: $servidorSeleccionado");
      if(servidorSeleccionado == null)
        return;

      var servidor = await _showBottomSheetServidor(listaServidor: listaServidor, servidorSeleccionado: servidorSeleccionado);
      // var servidor = await Principal.seleccionarServidor(context, listaServidor, servidorActual);
        print("_cambiarServidor servidorRetornado: $servidor - $servidorActual");
      if(servidor != null && servidor != servidorActual){
        // LoginService.cambiarServidor(usuario: usuario.usuario, servidor: servidor, scaffoldkey: _scaffoldKey);
        // Usuario usuario = Usuario.fromMap(await Db.getUsuario());
        // usuario.servidor = servidor;
        // await Db.update("Users", usuario.toJson(), usuario.id);
        // await manager.clearInstance(socket);
        await _disconnectSocket();
        futureUsuario = Db.getUsuario();
        await indexPost(true);
        await initSocket();
      }
    }
  }

  // _cambiarServidorSQFlite() async {
  //   print("Holaaaaaaaaaaaaaaaaa");
  //   var c = await DB.create();
  //   var tipoUsuario = await c.getValue("tipoUsuario");
  //   if(tipoUsuario == "Programador"){
  //     var datosServidor = await Db.query("Servers");
  //     if(datosServidor == null)
  //       return;

  //     List<Servidor> listaServidor = datosServidor.map<Servidor>((json) => Servidor.fromMap(json)).toList();
  //     String servidorActual = await Db.servidor();
  //     print("_cambiarServidor listaServidor: ${listaServidor.length} : servidor: $servidorActual");
  //     int indexServidor = (listaServidor.length > 0) ? listaServidor.indexWhere((element) => element.descripcion == servidorActual) : -1;
  //     Servidor servidorSeleccionado = (indexServidor != -1) ? listaServidor[indexServidor] : null;
  //     if(servidorSeleccionado == null)
  //       return;

  //     var servidor = await _showBottomSheetServidor(listaServidor: listaServidor, servidorSeleccionado: servidorSeleccionado);
  //     // var servidor = await Principal.seleccionarServidor(context, listaServidor, servidorActual);
  //       print("_cambiarServidor servidorRetornado: $servidor - $servidorActual");
  //     if(servidor != null && servidor != servidorActual){
  //       // LoginService.cambiarServidor(usuario: usuario.usuario, servidor: servidor, scaffoldkey: _scaffoldKey);
  //       // Usuario usuario = Usuario.fromMap(await Db.getUsuario());
  //       // usuario.servidor = servidor;
  //       // await Db.update("Users", usuario.toJson(), usuario.id);
  //       print("_cambiarServidor entrooooooooooooooooo");
  //       // await manager.clearInstance(socket);
  //       await _disconnectSocket();
  //       futureUsuario = Db.getUsuario();
  //       await indexPost(true);
  //       await initSocket();
  //     }
  //   }
  // }

  _showBottomSheetServidor({List<Servidor> listaServidor, Servidor servidorSeleccionado}) async {
    Servidor _servidor = servidorSeleccionado;
    int indexServidorCargando = -1;
    // int indexServidorToScroll = listaServidor.indexWhere((element) => element.descripcion == _servidor.descripcion);
    // if(indexServidorToScroll != -1)
    //   _scrollController.scrollTo(index: indexServidorToScroll, duration: Duration(seconds: 1));

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
            _back(){
              Navigator.pop(context, _servidor.descripcion);
            }
            servidorChanged(servidor) async {
              setState(() {
                _servidor = servidor;
              });
              Usuario usuario = Usuario.fromMap(await Db.getUsuario());
              var parsed = await LoginService.cambiarServidor(usuario: usuario.usuario, servidor: servidor.descripcion, context: context);
              await Principal.cerrarSesion(context, false);
              await Db.deleteDB();
              var c = await DB.create();
              await c.add("apiKey", parsed["apiKey"]);
              await c.add("idUsuario", parsed["usuario"]["id"]);
              await c.add("administrador", parsed["administrador"]);
              await c.add("tipoUsuario", parsed["tipoUsuario"]);
              await LoginService.guardarDatos(parsed);
            }
        return StatefulBuilder(
          builder: (context, setState) {
            return MyScrollbar(
              child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      children: [
                        Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                              ),
                        Expanded(
                          child: ScrollablePositionedList.builder(
                            itemScrollController: _scrollController,
                            itemCount: listaServidor.length,
                            itemBuilder: (context, index) {
                              return AbsorbPointer(
                                absorbing: _servidor == listaServidor[index],
                                child: ListTile(
                                  trailing: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Visibility(
                                      visible: indexServidorCargando == index,
                                      child: Theme(
                                        data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                                        child: new CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                  leading: Checkbox(
                                    value: _servidor == listaServidor[index], 
                                    onChanged: (value) async {
                                      try {
                                        setState(() => indexServidorCargando = index);
                                        await servidorChanged(listaServidor[index]);
                                        setState(() => indexServidorCargando = -1);
                                        _back();
                                      } on Exception catch (e) {
                                        setState(() => indexServidorCargando = -1);
                                        Utils.showAlertDialog(context: context, content: "${e.toString()}", title: "Error");
                                      }
                                    }
                                  ),
                                  onTap: () async {
                                      try {
                                        setState(() => indexServidorCargando = index);
                                        await servidorChanged(listaServidor[index]);
                                        setState(() => indexServidorCargando = -1);
                                        _back();
                                      } on Exception catch (e) {
                                        setState(() => indexServidorCargando = -1);
                                        Utils.showAlertDialog(context: context, content: "${e.toString()}", title: "Error");
                                      }
                                  },
                                  title: Text("${listaServidor[index].descripcion}"),
                                ),
                              );
                            
                            },
                          )
                          // ListView(
                          //   children: listaServidor.asMap().map((index, value) => MapEntry(
                          //     index,
                          //     AbsorbPointer(
                          //       absorbing: _servidor == listaServidor[index],
                          //       child: ListTile(
                          //         trailing: SizedBox(
                          //           width: 30,
                          //           height: 30,
                          //           child: Visibility(
                          //             visible: indexServidorCargando == index,
                          //             child: Theme(
                          //               data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                          //               child: new CircularProgressIndicator(),
                          //             ),
                          //           ),
                          //         ),
                          //         leading: Checkbox(
                          //           value: _servidor == listaServidor[index], 
                          //           onChanged: (value) async {
                          //             try {
                          //               setState(() => indexServidorCargando = index);
                          //               await servidorChanged(listaServidor[index]);
                          //               setState(() => indexServidorCargando = -1);
                          //               _back();
                          //             } on Exception catch (e) {
                          //               setState(() => indexServidorCargando = -1);
                          //               Utils.showAlertDialog(context: context, content: "${e.toString()}", title: "Error");
                          //             }
                          //           }
                          //         ),
                          //         onTap: () async {
                          //             try {
                          //               setState(() => indexServidorCargando = index);
                          //               await servidorChanged(listaServidor[index]);
                          //               setState(() => indexServidorCargando = -1);
                          //               _back();
                          //             } on Exception catch (e) {
                          //               setState(() => indexServidorCargando = -1);
                          //               Utils.showAlertDialog(context: context, content: "${e.toString()}", title: "Error");
                          //             }
                          //         },
                          //         title: Text("${listaServidor[index].descripcion}"),
                          //       ),
                          //     )
                            
                          //   )).values.toList()
                          // )
                          // ListView.builder(
                          //   itemCount: listaLoteria.length,
                          //   itemBuilder: (context, index){
                          //     print("_showBottomSheetServidor index: $index");
                          //     return AbsorbPointer(
                          //       absorbing: _servidor == listaServidor[index],
                          //       child: ListTile(
                          //         trailing: SizedBox(
                          //           width: 30,
                          //           height: 30,
                          //           child: Visibility(
                          //             visible: indexServidorCargando == index,
                          //             child: Theme(
                          //               data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                          //               child: new CircularProgressIndicator(),
                          //             ),
                          //           ),
                          //         ),
                          //         leading: Checkbox(
                          //           value: _servidor == listaServidor[index], 
                          //           onChanged: (value) async {
                          //             try {
                          //               setState(() => indexServidorCargando = index);
                          //               await servidorChanged(listaServidor[index]);
                          //               setState(() => indexServidorCargando = -1);
                          //               _back();
                          //             } on Exception catch (e) {
                          //               setState(() => indexServidorCargando = -1);
                          //               Utils.showAlertDialog(context: context, content: "${e.toString()}", title: "Error");
                          //             }
                          //           }
                          //         ),
                          //         onTap: () async {
                          //             try {
                          //               setState(() => indexServidorCargando = index);
                          //               await servidorChanged(listaServidor[index]);
                          //               setState(() => indexServidorCargando = -1);
                          //               _back();
                          //             } on Exception catch (e) {
                          //               setState(() => indexServidorCargando = -1);
                          //               Utils.showAlertDialog(context: context, content: "${e.toString()}", title: "Error");
                          //             }
                          //         },
                          //         title: Text("${listaServidor[index].descripcion}"),
                          //       ),
                          //     );
                            
                          //   },
                          // ),
                        ),
                      ],
                    ),
                  ),
            );
          }
        );
        
      
      }
  );
    // if(data != null)
    //   setState((){
    //     _loteria = data;
    //     _filtrar();
    //   });
  }

  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
        //do your stuff
        print('unresume');
    }
  }

_bluetoothScreen([bool isSmallOrMedium = true]) async {
  // var returnedUser = await Navigator.push(context, MaterialPageRoute(builder: (context){
  //        return RecargasDialogAddScreen();
  //      }));
  // showDialog(context: context, builder: (context){
  //   return StatefulBuilder(
  //     builder: (context, setState) {
  //       return RecargasDialogAddScreen();
  //     }
  //   );
  // });
  // return;

  // var returnedUser = await Navigator.push(context, MaterialPageRoute(builder: (context){
  //        return RecargasDialogAddScreen();
  //      }));

  //      return;

  if(isSmallOrMedium){
    Navigator.of(context).pushNamed('/bluetooth');
    return;
  }

  var _formPrinterKey = GlobalKey<FormState>();



  showDialog(

    context: context, 
    builder: (context){
      _init() async {
        var c = await DB.create();
        String printer = await c.getPrinter();
        if(printer != null)
          _txtNombreImpresora.text = printer;
        else
          _txtNombreImpresora.text = "";

        await c.add("printer", _txtNombreImpresora.text);
      }
      _guardarPrinter() async {
        if(!_formPrinterKey.currentState.validate())
          return;

        var c = await DB.create();
        await c.add("printer", _txtNombreImpresora.text);
        Navigator.pop(context);
      }

      _init();

      return MyAlertDialog(
        title: "Configure su impresora",
        description: "Aqui tiene toda la informacion necesaria para configurar su impresora con el sistema.",
        content: Wrap(children: [
          Form(
            key: _formPrinterKey,
            child: MyTextFormField(
              isRequired: true,
              controller: _txtNombreImpresora,
              // type: MyType.normal,
              title: "Nombre impresora",
            ),
          ),
          MySubtitle(title: "Intrucciones"),
          MySubtitle(title: "Java SDK 14. (Descargar e instalar)"),
          MyDescripcon(title: "Debera descargar e instalar Java SDK 14 para la plataforma que desee"),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              children: [
                MyButton(
                  type: MyButtonType.roundedWithOnlyBorder,
                  title: "Windows",
                  medium: 4,
                  function: (){
                    Utils.launchUrl('https://drive.google.com/file/d/1Hkp61twXBSbKfm5BDVaYPGaTrK0V29tP/view?usp=sharing');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: MyButton(
                    type: MyButtonType.roundedWithOnlyBorder,
                    title: "Mac",
                    medium: 4,
                    function: (){
                      Utils.launchUrl('https://drive.google.com/file/d/1U7IZX26fUR7L0OEI6oLK2zNMTbSx5WK7/view?usp=sharing');
                    },
                  ),
                ),
              ],
            ),
          ),
          MySubtitle(title: "App para imprimir. (Descargar e instalar)"),
          MyResizedContainer(
             medium: 1,
            child: MyDescripcon(title: "Esta es la app que permitira la conexion entre el sistema y su equipo.")
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: MyButton(
              type: MyButtonType.roundedWithOnlyBorder,
              title: "Descargar",
              medium: 4,
              function: () async {
                Utils.launchUrl(Utils.URL + '/assets/java/mavenproject1-1.0-jar-with-dependencies.jar');
              },
            ),
          ),
          MySubtitle(title: "Copiar App en la carpeta Startup"),
          MyResizedContainer(
             medium: 1,
            child: MyDescripcon(title: "Para que la App inicie cada vez que se encienda el equipo debe copiar dicha App en carpetas especiales que tiene cada sistema operativo.")
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MySubtitle(title: "1. Windows", fontSize: 16,),
                Wrap(
                  children: [
                    MyDescripcon(title: "• Presionar las teclas:  "),
                    Icon(Icons.window, size: 18),
                    MyDescripcon(title: " +  R", fontSize: 15,),
                  ],
                ),
                Wrap(
                  children: [
                    MyDescripcon(title: "• Escribir el siguiente comando:  "),
                    SelectableText("shell:common startup", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                MyDescripcon(title: "• Presionar Ok."),
                MyDescripcon(title: "• Copiar la App en la carpeta"),
                MySubtitle(title: "2. Mac", fontSize: 16,),
                Wrap(
                  children: [
                    MyDescripcon(title: "• Ir a: "),
                    SelectableText("System Preferences > Accounts > 'username' > Login items", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
                MyDescripcon(title: "• Agregar la App ahi."),
              ],
            ),
          )
           
        ],),
        okFunction: _guardarPrinter,
      );
    }
  );
}

_seleccionarTodasLasJugadas(){
  if(listaJugadas == null)
    return;
  if(listaJugadas.length == 0)
    return;
  List<Jugada> jugadasASeleccionar = [];
  for (var jugada in listaJugadas) {
    if(listaJugadasSeleccionadas.indexWhere((element) => element == jugada) == -1)
      jugadasASeleccionar.add(jugada);
  }

  if(jugadasASeleccionar.length > 0)
    setState(() => listaJugadasSeleccionadas.addAll(jugadasASeleccionar));
}

_copiarJugadas(){
  List<dynamic> loteriasACopiar = [];
  
  if(listaJugadasSeleccionadas.length == 0)
    return;

  Utils.removeDuplicateJugadasFromList(listaJugadasSeleccionadas);
  List<Jugada> listaLoteriasJugadas = Utils.removeDuplicateLoteriasFromList(List.from(listaJugadasSeleccionadas)).cast<Jugada>().toList();
  for (var loteria in listaLoteriasJugadas) {
      List<dynamic> listaLoteriasSuperpaleTmp = [];
      
      //Añadimos la loteria
      Map<String, dynamic> loteriaMap = loteria.loteria.toJson();
      loteriaMap["loteriaSuperpale"] = [];
      if(listaJugadasSeleccionadas.firstWhere((element) => element.loteria.id == loteria.loteria.id && element.idSorteo != 4, orElse: () => null) != null)
        loteriasACopiar.add(loteriaMap);

      //Buscamos los superPale pertenecientes a la loteria de arriba
      List<Jugada> jugadasSuperTmp = listaJugadasSeleccionadas.where((element) => element.loteria.id == loteria.loteria.id && element.idSorteo == 4).toList();
      List<Jugada> jugadasSuper = [];
  print("_copiarJugadas jugadasSuperTmp: ${jugadasSuperTmp.length}");
      if(jugadasSuperTmp.length > 0)
        jugadasSuper = Utils.removeDuplicateLoteriasSuperPaleFromList(jugadasSuperTmp).cast<Jugada>().toList();

  print("_copiarJugadas jugadasSuper: ${jugadasSuperTmp.length}");
      //Insertamos los superPale pertenecientes a la loteria de arriba en la variable listaLoteriasSuperpaleTmp
      for (var loteriaSuper in jugadasSuper) {
        Map<String, dynamic> loteriaSuperpaleMap = loteriaSuper.loteriaSuperPale.toJson();
        listaLoteriasSuperpaleTmp.add(loteriaSuperpaleMap);
      }

      //Si la variable listaLoteriasSuperpaleTmp es mayor que cero entonces eso quiere decir que la loteria de arriba tiene superPale
      //Asi que los insertamos la loteria de arriba y le asignamos sus respectivos superPale y la insertamos en la variable loteriasACopiar
      if(listaLoteriasSuperpaleTmp.length > 0){
        Map<String, dynamic> loteriaMap2 = loteria.loteria.toJson();
        loteriaMap2["loteriaSuperpale"] = listaLoteriasSuperpaleTmp;
        loteriasACopiar.add(loteriaMap2);
      }
      
  }

  print("_copiarJugadas: $loteriasACopiar");
  _duplicar({"loterias" : loteriasACopiar}, true);
  _chanceSeleccionarScreenValue(false);
}

List<PopupMenuEntry<String>> _popupMenuEntries(){
  PopupMenuItem recargaEntry = const PopupMenuItem<String>(
    value: opcionRecargar,
    child: Text("Recargar"),
  );

  PopupMenuItem notificacionesEntry = const PopupMenuItem<String>(
    value: opcionNotificaciones,
    child: Text("Notificaciones"),
  );

  List<PopupMenuEntry> entries = <PopupMenuEntry<String>>[

      const PopupMenuItem(
        value: opcionImpresora,
        child: Text("Impresora")
      ),
      
    ];

  if(_tienePermisoRealizarRecargas)
    entries.insert(0, recargaEntry);

  if(_tienePermisoAdministrador == true || _tienePermisoProgramador == true)
    entries.add(notificacionesEntry);

  return entries;
}

Widget _menuOpcionesWidget(bool screenHeightIsSmall){
  double _iconPaddingVertical = screenHeightIsSmall ? 2.0 :  8.0;
  double _iconPaddingHorizontal = 12;

  return PopupMenuButton(
    child: Padding(
      padding: EdgeInsets.only(right: _iconPaddingHorizontal),
      child: Icon(Icons.more_vert, size: screenHeightIsSmall ? 25 :  26),
    ),
    onSelected: (String value)  {
      if(value == opcionRecargar){
         Navigator.push(context, MaterialPageRoute(builder: (context){
         return RecargasDialogAddScreen();
       }));

      }else if(value == opcionImpresora){
        _bluetoothScreen();
      }
      else if(value == opcionNotificaciones){
        Navigator.of(context).pushNamed('/notificaciones');
      }
    },
    itemBuilder: (context) => _popupMenuEntries(),
  );

}

List<Widget> _appBarActionsWidget(bool screenHeightIsSmall){
  double _iconPaddingVertical = screenHeightIsSmall ? 2.0 :  8.0;
  double _iconPaddingHorizontal = 12;

  return 
  _isSeleccionarScreen
  ?
  <Widget>[
    IconButton(
      tooltip: "Seleccionar todas",
      icon: Icon(Icons.select_all, color: Colors.black),
      onPressed: _seleccionarTodasLasJugadas,
    ),
    IconButton(
      tooltip: "Copiar jugadas",
      icon: Icon(Icons.copy, color: Colors.black),
      onPressed: _copiarJugadas,
    ),
  ]
  :
  <Widget>[
        Container(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: screenHeightIsSmall ? 23 : 26,
              height: screenHeightIsSmall ? 23 : 26,
              child: Visibility(
                visible: _cargando,
                child: new CircularProgressIndicator(color: Theme.of(context).primaryColor,),
              ),
            ),
          ],
        ),
        
        PopupMenuButton(
          child: Padding(
            padding: EdgeInsets.only(top: _iconPaddingVertical, bottom: _iconPaddingVertical, right: _iconPaddingHorizontal, left: _iconPaddingHorizontal),
            child: Icon(Icons.camera_alt, size: screenHeightIsSmall ? 25 :  28),
          ),
          onSelected: (String value) async {
            if(value == "duplicar"){
              try{
                // String codigoQr = await BarcodeScanner.scan();
                // String codigoQr = await scanner.scan();
                String codigoQr = await FlutterBarcodeScanner.scanBarcode(
                                                    "#38B6FF", 
                                                    "Cancel", 
                                                    true,
                                                    ScanMode.QR
                                                    );

                // print("_appBar codigoQr duplicar: $codigoQr");

                setState(() => _cargando = true);
                var datos = await TicketService.duplicar(codigoQr: codigoQr, scaffoldKey: _scaffoldKey);
                setState(() => _cargando = false);
                if(datos.isNotEmpty){
                  _duplicar(datos);
                }
              } on Exception catch(e){
                setState(() => _cargando = false);
              }
            }else if(value == "pagar"){
              try{
                // String codigoQr = await BarcodeScanner.scan();
                // String codigoQr = await scanner.scan();
                String codigoQr = await FlutterBarcodeScanner.scanBarcode(
                                                    "#38B6FF", 
                                                    "Cancel", 
                                                    true,
                                                    ScanMode.QR
                                                    );
                setState(() => _cargando = true);
                var datos = await TicketService.buscarTicketAPagar(codigoQr: codigoQr, scaffoldKey: _scaffoldKey);
                setState(() => _cargando = false);
                Principal.showDialogPagar(context: context, scaffoldKey: _scaffoldKey, mapVenta: datos["venta"]);
              } on Exception catch(e){
                setState(() => _cargando = false);
              }
            }
          },
          itemBuilder: (context) => <PopupMenuEntry<String>>[
            const PopupMenuItem(
              value: "duplicar",
              child: Text("Duplicar"),
            ),
            (_tienePermisoMarcarTicketComoPagado) ?
            const PopupMenuItem(
              value: "pagar",
              child: Text("Pagar")
            )
            :
            SizedBox()
          ],
        ),
        _menuOpcionesWidget(screenHeightIsSmall),
        // IconButton(
        //   icon: Icon(Icons.camera_alt, size: 30),
        //   onPressed: () async {
        //     String codigoQr = await BarcodeScanner.scan();
        //     var datos = await TicketService.duplicar(codigoQr: codigoQr, scaffoldKey: _scaffoldKey);
        //     if(datos.isNotEmpty){
        //       _duplicar(datos);
        //     }
        //   },
        // ),
        // Padding(
        //     padding: EdgeInsets.only(top: _iconPaddingVertical, bottom: _iconPaddingVertical, right: _iconPaddingHorizontal),
        //     child: GestureDetector(child: Icon(Icons.bluetooth, size: screenHeightIsSmall ? 25 :  30), onTap: (){_bluetoothScreen();}),
        // ),
        // Visibility(
        //   visible: _tienePermisoAdministrador || _tienePermisoProgramador,
        //   child: 
          // Visibility(
          //   visible: !_cargando && (_tienePermisoAdministrador == true || _tienePermisoProgramador == true),
          //   child: Padding(
          //     padding: EdgeInsets.only(top: _iconPaddingVertical, bottom: _iconPaddingVertical, right: _iconPaddingHorizontal),
          //     child: GestureDetector(child: Icon(Icons.notifications, size: screenHeightIsSmall ? 25 :  30), onTap: () async {
          //       Navigator.of(context).pushNamed('/notificaciones');
          //       // MyNotification.show(title: "Hola", subtitle: "Esta baina esta fea", content: "Es para probar que las notificaciones se ejecutan bien", route: "/verNotificaciones");
          //     }),
          //   ),
          // ),
        
       
      ];
      
}

AppBar _appBar(bool screenHeightIsSmall){
    
    
    return AppBar(
      elevation: 0,
      // backgroundColor: Utils.colorMaterialCustom,
      // backgroundColor: Colors.transparent,
      // iconTheme: IconThemeData(color: Colors.white),
      // actionsIconTheme: IconThemeData(color: Colors.white),
      leading: _isSeleccionarScreen ? IconButton(icon: Icon(Icons.clear, color: Colors.black,), onPressed: () => _chanceSeleccionarScreenValue(),) : null,
      title: 
      _isSeleccionarScreen
      ?
      Text("${listaJugadasSeleccionadas.length}", style: TextStyle(color: Colors.black))
      :
      screenHeightIsSmall 
        ? 
        Padding(
          padding: EdgeInsets.only(top: 5), 
          child: _bancasScreen()
  //         Row(
  //         children: [
  //           Expanded(child: _bancasScreen()),
  //           Padding(
  //             padding: const EdgeInsets.only(left: 4.0),
  //             child: ValueListenableBuilder<bool>(
  //               valueListenable: _connectionNotify,
  //               builder: (context, value, __) {
  //                 if(value)
  //                   return GestureDetector(child: Icon(Icons.cloud_done, color: Colors.white, size: 16), onTap: () async {
  //                     listaJugadas.forEach((element) {print("PrincipalView Icons.cloud_done: jugada: ${element.jugada} disponible: ${element.stock.monto} ");});
  // //                     var query = await Db.database.rawQuery('SELECT COUNT(*) as stocks FROM STOCKS');
  // //   print("Database.deleteDb after delete stocks: ${query}");
  // //   query = await Db.database.rawQuery('SELECT COUNT(*) as usuarios FROM Users');
  // //   print("Database.deleteDb after delete users: ${query}");
  // //   query = await Db.database.rawQuery('SELECT COUNT(*) as bancas FROM Branches');
  // //   print("Database.deleteDb after delete Branches: ${query}");
  // //  query = await Db.database.rawQuery('SELECT COUNT(*) as sales FROM Sales');
  // //   print("Database.deleteDb after delete sales: ${query}");
  // //   query = await Db.database.rawQuery('SELECT COUNT(*) as salesdetails FROM Salesdetails');
  // //   print("Database.deleteDb after delete Salesdetails: ${query}");
  // //   query = await Db.database.rawQuery('SELECT COUNT(*) as tickets FROM Tickets');
  // //   print("Database.deleteDb after delete tickets: ${query}");

                      

  //                   },);

  //                 return Icon(Icons.cloud_off, color: Colors.white, size: 16);
  //               }
  //             ),
  //           )
  //         ],
  //       ) ,
          // Stack(
          //   children: [
          //     Text('Principal', style: TextStyle(fontSize: 17)),
          //     Positioned(child: Icon(Icons.language, color: Colors.green))
          //   ],
          // )
        ) 
        : 
        _bancasScreen(),
        // Text('Principal'),
//         Row(
//           children: [
//             // Text('Principal', style: TextStyle(color: Colors.black)),
//             Expanded(child: _bancasScreen()),
//             Padding(
//               padding: const EdgeInsets.only(left: 4.0),
//               child: ValueListenableBuilder<bool>(
//                 valueListenable: _connectionNotify,
//                 builder: (context, value, __) {
//                   if(value)
//                     return GestureDetector(child: Icon(Icons.cloud_done, color: Colors.white, size: 18), onTap: () async {
//                       // Banca banca = await getBanca();
//                       // print("PrincipalView cloud_done banca: ${banca.id}");
//                       // var ticket = await Db.getNextTicket(banca.id);
//                       // print("PrincipalView cloud_done ticket: ${ticket}");
//                       // listaJugadas.forEach((element) {print("PrincipalView Icons.cloud_done: jugada: ${element.jugada} disponible: ${element.stock.monto} ");});
// // var query = await Db.database.rawQuery('SELECT COUNT(*) as stocks FROM STOCKS');
// //     print("Database.deleteDb after delete stocks: ${query}");
// //     query = await Db.database.rawQuery('SELECT * FROM Users');
// //     print("Database.deleteDb after delete users: ${query}");
// //     query = await Db.database.rawQuery('SELECT * FROM Branches');
// //     print("Database.deleteDb after delete Branches: ${query}");
// //    query = await Db.database.rawQuery('SELECT COUNT(*) as sales FROM Sales');
// //     print("Database.deleteDb after delete sales: ${query}");
// //     query = await Db.database.rawQuery('SELECT COUNT(*) as salesdetails FROM Salesdetails');
// //     print("Database.deleteDb after delete Salesdetails: ${query}");
// //     query = await Db.database.rawQuery('SELECT COUNT(*) as tickets FROM Tickets');
// //     print("Database.deleteDb after delete tickets: ${query}");


//                       // deleteSubidaYesterdaysSale();

//                       // var query = await Db.database.rawQuery("SELECT * FROM Sales");
//                       // query.forEach((e) => print("PrincipalView cloud sale: $e"));
//                       // query = await Db.database.rawQuery("SELECT * FROM Salesdetails");
//                       // query.forEach((e) => print("PrincipalView cloud salesdetails: idVenta: ${e["idVenta"]}, jugada: ${e["jugada"]}, , monto: ${e["monto"]} created_at: ${e["created_at"]}"));

//                       // print("PrincipalView cloud: $query");

//                       // deleteSubidaYesterdaysSale();

                      
//                     },);

//                   return Icon(Icons.cloud_off, color: Colors.white, size: 18);
//                 }
//               ),
//             )
//           ],
//         ) ,
      
      // leading: SizedBox(),
      // leading: _drawerIsOpen ? SizedBox() :  IconButton(icon: Icon(Icons.menu, color:  Colors.white,), onPressed: (){
      //   _scaffoldKey.currentState.openDrawer();
      // }),
      actions: _appBarActionsWidget(screenHeightIsSmall)
      
      // bottom: TabBar(
      //   // labelPadding: EdgeInsets.all(-20),
      //   // isScrollable: true,
      //   // indicatorWeight: 100,
      //   indicatorColor: Colors.white,
      //   tabs: <Widget>[
      //     Tab(
      //       child: Text('Jugar'),
      //     ),
      //     Tab(
      //       child: Text('Jugadas'),
      //     )
      //   ],
      // ),
    );
  }

Widget _bancasScreen(){
    return
    !_tienePermisoJugarComoCualquierBanca
    ?
    Padding(
      padding: const EdgeInsets.all(0.0),
      child: Text("${_banca != null ? _banca.descripcion : 'Banca'}", softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: Colors.black)),
    )
    :
    StreamBuilder(
      stream: _streamControllerBanca.stream,
      builder: (context, snapshot){

        if(!snapshot.hasData)
          return SizedBox.shrink();
        
        return Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                  hint: Text('...'),
                  isExpanded: true,
                  value: (listaBanca.length > 0) ? (_indexBanca > listaBanca.length) ? listaBanca[0] : listaBanca[_indexBanca] : null,
                  onChanged: (Banca banca) async {
                      int idBancaAnterior = await getIdBanca();
                    setState(() {
                    _indexBanca = listaBanca.indexOf(banca); 
                    _changeSocketBranchRoom(idBancaAnterior);
                    _emitToGetNewIdTicket();
                    indexPost(false);
                    for (var jugada in listaJugadas) {
                      print("jugada before bancaChanged: ${jugada.stock.idBanca}");
                    }
                    for (var jugada in listaJugadas) {
                      jugada.stockEliminado = true;
                      jugada.stock.idBanca = banca.id;
                    }
                    for (var jugada in listaJugadas) {
                      print("jugada after bancaChanged: ${jugada.stock.idBanca}");
                    }
                    });
                    await Realtime.sincronizarTodos(_scaffoldKey, await getIdBanca());
                  },
                  items: listaBanca.map((b){
                    return DropdownMenuItem<Banca>(
                      value: b,
                      child: Text(b.descripcion, textAlign: TextAlign.center, softWrap: true, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.5),),
                    );
                  }).toList(),
                ),
          ),
        
        );
        
      },
    );
                                      
  }

Lotterycolor _getLotteryColor(){
  return _selectedLoterias != null ? _selectedLoterias.length == 1 ? _listaLotteryColor.firstWhere((element) => element.toHex() == _selectedLoterias[0].color, orElse: () => null) : null : null;
}

_getListLotteryColor(){
  List<Color> listaColors = [];

  if(_selectedLoterias != null){
    for(Loteria l in _selectedLoterias){
      // Loteria loteria = l;
      Color _textColor;

      // print("PrincipalView _getListLotteryColor loteria: ${l.color}");

      if(l.color != null){
        var lotterycolor = _listaLotteryColor.firstWhere((element) => element.toHex() == l.color, orElse:() => null,);
        if(lotterycolor != null){
          listaColors.add(lotterycolor.color.withOpacity(0.18));
        }
        // print("PrincipalClass loteriasSeleccionadasToString _textColor: $_textColor lottery: ${l.descripcion} : ${l.color} : listLength${listaLotteryColor.length} data: ${listaLotteryColor.firstWhere((element) => element.toHex() == l.color, orElse:() => null,)}");
      }
    }
  }

  if(listaColors.length == 0){
    listaColors.addAll([Colors.blue.shade100, Colors.blue.shade100]);
  }
  else if(listaColors.length == 1)
    listaColors.add(listaColors[0]);

  return listaColors;
}

Widget _loteriasScreen([bool isSmallOrMedium = true, BuildContext mContext, double width]){
    return Padding(
      padding: EdgeInsets.only(left: _isLargeAndWeb() ? 0 : 0.0, right: 0.0, top: _isLargeAndWeb() ? 5.0 : 0.0),
      child: GestureDetector(
        onTap: () async {
          if(isSmallOrMedium){
          // _showMultiSelect(context);
            List<Loteria> loterias = await showDialog<List<Loteria>>(
                context: context, 
                builder: (context){
                  // return MyMultiselect<Loteria>(
                  //   title: "Agregar loterias",
                  //   items: listaLoteria.map((e) => MyValue<Loteria>(value: e, child: _getLoteriaStream(e, isSmallOrMedium: isSmallOrMedium))).toList(),
                  //   initialSelectedItems: _selectedLoterias.length == 0 ? [] : _selectedLoterias.map((e) => MyValue<Loteria>(value: e, child: e.descripcion)).toList()
                  // );
                  
                  return MyMultiSelectDialog<Loteria>(
                        // height: 400,
                        // controlAffinity: !isSmallOrMedium ? ListTileControlAffinity.trailing : ListTileControlAffinity.leading,
                        showButtonLimpiar: true,
                        showButtonSeleccionarTodos: true,
                        initialSelectedValues: _selectedLoterias != null ? _selectedLoterias : null,
                        items: listaLoteria.map<MyMultiSelectDialogItem<Loteria>>((e) => MyMultiSelectDialogItem<Loteria>(e, _getLoteriaStream(e, isSmallOrMedium: isSmallOrMedium))).toList(),
                      );
                }
              );

              print("_loteriasScreen loterias: $loterias");
              // List<int> listaIdLoteriasSeleccionadosUnicos = [...{...loterias.map((loteria) => loteria.id).toList()}];
              List<int> listaIdLoteriasSeleccionadosUnicos = loterias.map((loteria) => loteria.id).toList().unique();
              setState(() => _selectedLoterias = listaLoteria.where((element) => listaIdLoteriasSeleccionadosUnicos.contains(element.id)).toList());
          }else{
            showMyOverlayEntry(
              context: mContext, 
              onClose: (){
                var values = _myMultiselectKey.currentState.getValues();
                // if(values != null){
                //   setState(() => _selectedLoterias = []);
                //   return;
                // }
                // if(values.length == 0){
                //   setState(() => _selectedLoterias = []);
                //   return;
                // }

                setState(() => _selectedLoterias = values);
                // print("PrincipalView _loteriasScreen showMyOverlayEntry: $values");
              },
              builder: (context, overlay){
                return Container(
                  width: width,
                  child: MyMultiSelectDialog<Loteria>(
                    // height: 400,
                    boxConstraints: BoxConstraints(maxHeight: 400),
                    key: _myMultiselectKey,
                    // controlAffinity: !isSmallOrMedium ? ListTileControlAffinity.trailing : ListTileControlAffinity.leading,
                    type: MyMultiselectType.overlay,
                    initialSelectedValues: _selectedLoterias != null ? _selectedLoterias : null,
                    items: listaLoteria.map<MyMultiSelectDialogItem<Loteria>>((e) => MyMultiSelectDialogItem<Loteria>(e, _getLoteriaStream(e, isSmallOrMedium: isSmallOrMedium))).toList(),
                  ),
                );
              }
            );
          }
        },
          child: Container(
          width: !isSmallOrMedium ? width : MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.058,
          // padding: EdgeInsets.only(top: 13, bottom: 13),
          decoration: BoxDecoration(
            border: 
            _isLargeAndWeb() 
            ?
            Border(bottom: BorderSide(style: BorderStyle.solid, color: Colors.black, width: 1))
            :
            null,
            // Border.all(style: BorderStyle.solid, color: Colors.black, width: 1),
            // borderRadius: BorderRadius.circular(10),
            gradient: _isLargeAndWeb() ? null : LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: _getListLotteryColor(),
            )
          ),
          // child: Center(child: Text(Principal.loteriasSeleccionadasToString(_selectedLoterias), style: TextStyle(color: _colorSegundary),),),
          child: _isLargeAndWeb() 
            ? 
            Align(
              alignment: Alignment.centerLeft, 
              child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Expanded(child: _getSelectedLoteriaStream(isSmallOrMedium)),
              Icon(Icons.arrow_drop_down)
            ],)) 
            : 
            Center(child: _getSelectedLoteriaStream(isSmallOrMedium),),
        ),
      ),
    );
  }

  Widget _jugadaTextField(bool isSmallOrMedium){
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) { 
        print("Event runtimeType is ${event.runtimeType} : ${event.data.keyLabel}");
        if(event.runtimeType.toString() != 'RawKeyUpEvent')
          return;
        // print("PrincipalView _jugadaTextField onChanged ${event.data.keyLabel}");
        if(event.logicalKey == LogicalKeyboardKey.backspace)
          return;

        if(event.data.keyLabel.isEmpty)
          return;

        if(event.data.keyLabel == "/")
          return;
        
        // _txtJugada.text = _txtJugada.text.substring(0, _txtJugada.text.length - 1);
        // if(event.data.keyLabel.indexOf(RegExp("[\+\-\/sS\.]")) != -1)
        if(event.data.keyLabel.indexOf(RegExp("[\+\-sS\.]")) != -1)
          _escribir(event.data.keyLabel);
        else
        // Future.delayed(Duration(milliseconds: 500), (){_escribir(event.data.keyLabel);});
        _escribir(event.data.keyLabel);
        
      },
      child: TextField(
        controller: _txtJugada,
        focusNode: _jugadaFocusNode,
        autofocus: _isLargeAndWeb(),
        enabled: _isLargeAndWeb(),
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          isDense: _isLargeAndWeb() ? false : true,
          // alignLabelWithHint: true,
          border: _isLargeAndWeb() ? null : InputBorder.none,
          hintText: _isLargeAndWeb() ? null : 'Jugada',
          labelText: _isLargeAndWeb() ? 'Jugada' : null,
          fillColor: Colors.transparent,
          // filled: true,
          hintStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        textAlign: _isLargeAndWeb() ? TextAlign.left : TextAlign.center,
        inputFormatters: !_isLargeAndWeb() ? [] : [
          LengthLimitingTextInputFormatter(6),

          // WhitelistingTextInputFormatter.digitsOnly,
          // FilteringTextInputFormatter.digitsOnly
          FilteringTextInputFormatter.allow(RegExp(r'^\d{1,3}(\+|\d[\+\-sS]|\d\d\d|\d)?$'))
        ],
        onSubmitted: (data){
          _cambiarFocusJugadaMonto();
          changeMontoDisponibleFromTxtMontoDisponible();
        }
        // onChanged: (String data){
        //   print("PrincipalView _jugadaTextField onChanged: $data");
        //   // _escribir(data);
        // },
        // expands: false,
      ),
    );
  }

  TextField _montoDisponibleTextField(bool isSmallOrMedium){
    return TextField(
      controller: _txtMontoDisponible,
      enabled: false,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        isDense: _isLargeAndWeb() ? false : true,
        border: _isLargeAndWeb() ? null : InputBorder.none,
        hintText: '0',
        // labelText: _isLargeAndWeb() ? 'Jugada' : null,
        fillColor: Colors.transparent,
        // filled: true,
        hintStyle: TextStyle(fontWeight: FontWeight.bold),
        
      ),
      textAlign: TextAlign.center,
    );
  }

  TextField _montoTextField(bool isSmallOrMedium){
    return TextField(
      controller: _txtMonto,
      focusNode: _montoFocusNode,
      enabled: _isLargeAndWeb(),
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0),
        isDense: _isLargeAndWeb() ? false : true,
        border: _isLargeAndWeb() ? null : InputBorder.none,
        hintText: _isLargeAndWeb() ? null : 'Monto',
        labelText: _isLargeAndWeb() ? 'Monto' : null,
        fillColor: Colors.transparent,
        // filled: true,
        hintStyle: TextStyle(fontWeight: FontWeight.bold)
      ),
      onTap: () => _txtMonto.selection = TextSelection(baseOffset:0, extentOffset:_txtMonto.text.length),
      textAlign: _isLargeAndWeb() ? TextAlign.left : TextAlign.center,
      onSubmitted: (data) async {
        _escribir("ENTER");
        // await addJugada(jugada: Utils.ordenarMenorAMayor(_txtJugada.text), montoDisponible: _txtMontoDisponible.text, monto: _txtMonto.text, selectedLoterias: _selectedLoterias);
      },
    );
  }

  _jugadaMontoScreen(bool isSmallOrMedium){
    return Row(
      children: <Widget>[
      GestureDetector(
        onTap: (){
          // _showMultiSelect(context);
          setState(() => _jugadaOmonto = true);
        },
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Container(
              // duration: Duration(milliseconds: 50),
                width: MediaQuery.of(context).size.width / 3,
                // height: (MediaQuery.of(context).size.height * 0.0688),
                height: (MediaQuery.of(context).size.height * 0.0648),
                // padding: EdgeInsets.only(top: 13, bottom: 13),
                decoration: BoxDecoration(
                  border: Border.all(style: BorderStyle.solid, color: (_jugadaOmonto) ? Theme.of(context).primaryColor : Colors.black.withOpacity(0.5), width: (_jugadaOmonto) ? 3 : 1),
                ),
                child: Center(
                  child: _jugadaTextField(isSmallOrMedium),
                ),
            ),
          ),
      ),
      GestureDetector(
        onTap: (){
          // _showMultiSelect(context);
        },
        child: Container(
          width: (MediaQuery.of(context).size.width / 3) - 16,
          // height: (MediaQuery.of(context).size.height * 0.0688),
          height: (MediaQuery.of(context).size.height * 0.0648),
          // padding: EdgeInsets.only(top: 10.03, bottom: 10.03),
          decoration: BoxDecoration(
            // border: Border.all(style: BorderStyle.solid, color: Colors.black, width: 2),
            border: Border(
              left: BorderSide(color: _jugadaOmonto ? _colorSegundary : Colors.black.withOpacity(0.5), width: 0.5),
              top: BorderSide(color: Colors.black.withOpacity(0.5), width: 1),
              right: BorderSide(color: !_jugadaOmonto ? _colorSegundary : Colors.black.withOpacity(0.5), width: 0.5),
              bottom: BorderSide(color: Colors.black.withOpacity(0.5), width: 1),
            ),
          ),
          child: Center(
            child: _montoDisponibleTextField(isSmallOrMedium)
            
            //  Text(_montoPrueba, style: TextStyle(fontSize: 25))
            // FutureBuilder<String>(
            // future: _montoFuture,
            //   builder: (context, snapshot){
            //     if (snapshot.hasData) {
            //         // setState(() {
            //         //  _cargando = false; 
            //         // });
            //         return Text(snapshot.data, style: TextStyle(fontSize: 25));
            //       } else if (snapshot.hasError) {
            //         return Text("${snapshot.error}", style: TextStyle(fontSize: 25));
            //       }

            //       return Text('', style: TextStyle(fontSize: 25));
            //   },
            // )
            // TextField(
            //   controller: _txtMontoDisponible,
            //   enabled: false,
            //   style: TextStyle(fontSize: 20),
            //   decoration: InputDecoration(
            //     border: InputBorder.none,
            //     hintText: '0',
            //     fillColor: Colors.transparent,
            //     filled: true,
            //     hintStyle: TextStyle(fontWeight: FontWeight.bold)
            //   ),
            //   textAlign: TextAlign.center,
            // ),
          ),
        ),
      ),
      GestureDetector(
        onTap: (){
          // _showMultiSelect(context);
          changeMontoDisponibleFromTxtMontoDisponible();
          setState(() => _jugadaOmonto = false);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 0),
          child: Container(
              width: (MediaQuery.of(context).size.width / 3) + 16,
              // height: (MediaQuery.of(context).size.height * 0.0688),
              height: (MediaQuery.of(context).size.height * 0.0648),
              // padding: EdgeInsets.only(top: 13, bottom: 13),
              decoration: BoxDecoration(
                border: Border.all(style: BorderStyle.solid, color: (!_jugadaOmonto) ? Theme.of(context).primaryColor : Colors.black.withOpacity(0.5), width: (!_jugadaOmonto) ? 3 : 1),
              ),
              child: Center(
                child: _montoTextField(isSmallOrMedium)
              ),
          ),
        ),
      ),
      ],
    );
                                  
  }

  _ckbPrintScreen([bool isSmallOrMedium = true]){
    return Row(
        children: <Widget>[
          // MyCheckbox(
          //   useTapTarget: false,
          //   value: _ckbPrint,
          //   onChanged: _ckbPrintChanged,
          // ),
          SizedBox(
            width: 10,
            height: 8,
            child: Checkbox(
              // useTapTarget: false,
              value: _ckbPrint,
              onChanged: _ckbPrintChanged,
            ),
          ),
          SizedBox(width: 5,),
          GestureDetector(child: Icon(Icons.print,), onTap: (){_ckbPrintChanged(!_ckbPrint);},)
        ],
      );
  }

  _ckbDescuentoScreen([bool isSmallOrMedium = true]){
    return Row(
      children: <Widget>[
        //MyCheckbox
        // MyCheckbox(
        //   useTapTarget: false,
        //   value: _ckbDescuento,
        //   onChanged: (newValue){
        //     setState(() {
        //     _ckbDescuento = newValue; 
        //     });
        //   },
        // ),
        SizedBox(
          width: 10,
          height: 8,
          child: Checkbox(
            // useTapTarget: false,
            value: _ckbDescuento,
            onChanged: _ckbDescuentoChanged,
          ),
        ),
        // Checkbox(
        //   // useTapTarget: false,
        //   value: _ckbDescuento,
        //   onChanged: (newValue){
        //     setState(() {
        //     _ckbDescuento = newValue; 
        //     });
        //   },
        // ),
        SizedBox(width: 5,),
        GestureDetector(child: Text('${_isLargeAndWeb() ? 'Desc.' : 'Des'}', style: TextStyle(fontSize: 12, letterSpacing: _isLargeAndWeb() ? 1 : null, fontWeight: FontWeight.bold)), onTap: (){setState(() => _ckbDescuento = !_ckbDescuento);},)
      ],
    );
                                          
  }

  _copyAndDeleteWidget(){
    return SizedBox.shrink();

    return Expanded(
                                    flex: 1,
                                    
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                IconButton(
                                                  icon: Icon(Icons.copy, color: Colors.blue, size: 38),
                                                  onPressed: () async {
                                                    if(listaVenta.isNotEmpty){
                                                      var resultado = await TicketService.ticket(idTicket: listaVenta[_indexVenta].idTicket, scaffoldKey: _scaffoldKey);
                                                      BluetoothChannel.printTicket(resultado["ticket"], BluetoothChannel.TYPE_COPIA );
                                                    }
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.delete, color: Colors.red, size: 38,),
                                                  onPressed: () async {
                                                    if(listaVenta.isNotEmpty){
                                                      var r = await TicketService.cancelar(codigoBarra: listaVenta[_indexVenta].codigoBarra, scaffoldKey: _scaffoldKey);
                                                      listaVenta.removeAt(_indexVenta);
                                                      _indexVenta = 0;
                                                      _streamControllerVenta.add(true);
                                                      BluetoothChannel.printTicket(r["ticket"], BluetoothChannel.TYPE_CANCELADO);
                                                      Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: r["mensaje"]);
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        StreamBuilder(
                                          stream: _streamControllerVenta.stream,
                                          builder: (context, snapshot){
                                            if(snapshot.hasData){
                                              if(listaVenta.length != 0){
                                                return DropdownButton(
                                                  hint: Text('seleccionar ticket'),
                                                  value: listaVenta[_indexVenta],
                                                  onChanged: (Venta ticket){
                                                    setState(() {
                                                    _indexVenta = listaVenta.indexOf(ticket); 
                                                    });
                                                  },
                                                  items: listaVenta.map((t){
                                                    return DropdownMenuItem(
                                                      value: t,
                                                      child: Text(t.idTicket.toString()),
                                                    );
                                                  }).toList(),
                                                );
                                              }else{
                                                return Padding(
                                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                                  child: DropdownButton(
                                                      hint: Text('Seleccionar ticket'),
                                                      value:  'No hay tickets',
                                                      onChanged: (String banca){
                                                        setState(() {
                                                        
                                                        });
                                                      },
                                                      items: [
                                                        DropdownMenuItem<String>(
                                                          value: "No hay tickets",
                                                          child: Text('No hay tickets',),
                                                        )
                                                      ]
                                                    ),
                                                );
                                              }
                        
                                              return DropdownButton(
                                                  hint: Text('Seleccionar banca'),
                                                  value:  'No hay datos',
                                                  onChanged: (String banca){
                                                    setState(() {
                                                    
                                                    });
                                                  },
                                                  items: [
                                                    DropdownMenuItem<String>(
                                                      value: "No hay datos",
                                                      child: Text('No hay datos',),
                                                    )
                                                  ]
                                                );
                                                
                                            }
                                            else{
                                              return DropdownButton(
                                                  hint: Text('Seleccionar banca'),
                                                  value:  'No hay datos',
                                                  onChanged: (String banca){
                                                    setState(() {
                                                    
                                                    });
                                                  },
                                                  items: [
                                                    DropdownMenuItem<String>(
                                                      value: "No hay datos",
                                                      child: Text('No hay datos',),
                                                    )
                                                  ]
                                                );
                                            }
                                          },
                                        )
                                        ],
                                      ),
                                    )
                                  );
                                
  }

  _bancaAndTimeWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: _bancasScreen(),
        ),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Text(_timeString, style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ],
    );
  }

  _totalDescuentoAndIconWidget(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(child: Text('Tot: ${Utils.toCurrency(_calcularTotal())}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          FutureBuilder(
            future: _calcularDescuento(),
            builder: (context, snapshot){
              return Flexible(child: Text('Des: ${ snapshot.hasData ? snapshot.data : '0'}\$', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),));
            }
          ),
          GestureDetector(
            onTap: (){
              setState(() => _ckbDescuento = !_ckbDescuento);
            },
            child: Container(
              // color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0, right: 5.0, left: 8.0),
                child: _ckbDescuentoScreen()
              ),
            ),
          ),
          
          GestureDetector(
            onTap: (){
              _ckbPrint = true;
              guardar();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              // child: _ckbPrintScreen(),
              
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Icon(Icons.print, size: 18, color: Colors.orange[900])
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              _ckbPrint = false;
              _ckbMessage = true;
              guardar();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              // child: _ckbPrintScreen(),
              
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Icon(Icons.share, size: 18, color: Colors.blue[900])
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              _ckbPrint = false;
              _ckbMessage = false;
              guardar();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              // child: _ckbPrintScreen(),
              
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(10)
                ),
                child: FaIcon(FontAwesomeIcons.whatsapp, size: 18, color: Colors.green[900],)
              ),
            ),
          ),
          // Row(
          //   children: <Widget>[
          //     // MyCheckbox(
          //     //   useTapTarget: false,
          //     //   value: _ckbMessage,
          //     //   onChanged: _ckbMessageChanged,
          //     // ),
          //     SizedBox(
          //       width: 10,
          //       height: 8,
          //       child: Checkbox(
          //         // useTapTarget: false,
          //         value: _ckbMessage,
          //         onChanged: _ckbMessageChanged,
          //       ),
          //     ),
          //     SizedBox(width: 5,),
          //     GestureDetector(child: Icon(Icons.message, color: Colors.blue,), onTap: (){_ckbMessageChanged(!_ckbMessage);},)
          //   ],
          // ),
          
          // Row(
          //   children: <Widget>[
          //     // MyCheckbox(
          //     //   useTapTarget: false,
          //     //   value: _ckbWhatsapp,
          //     //   onChanged: _ckbWhatsappChanged,
          //     // ),
          //     SizedBox(
          //       width: 10,
          //       height: 8,
          //       child: Checkbox(
          //         // useTapTarget: false,
          //         value: _ckbWhatsapp,
          //         onChanged: _ckbWhatsappChanged,
          //       ),
          //     ),
          //     // PreferredSize(
          //     //   preferredSize: Size.fromWidth(5),
          //     //   child: Checkbox(
          //     //     // useTapTarget: false,
          //     //     materialTapTargetSize: MaterialTapTargetSize.padded,
          //     //     value: _ckbWhatsapp,
          //     //     onChanged: _ckbWhatsappChanged,
          //     //     visualDensity: VisualDensity.lerp(VisualDensity.compact, VisualDensity.compact, VisualDensity.minimumDensity),
          //     //   ),
          //     // ),
          //     SizedBox(width: 5,),
          //     GestureDetector(child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, ), onTap: (){ _ckbWhatsappChanged(!_ckbWhatsapp);},)
          //   ],
          // ),
        
                
              
        ],
      ),
    );
                                  
  }


  _myPrincipalScreen([boxConstraints]){
    
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(maxHeight: boxConstraints.maxHeight),
        child: AbsorbPointer(
              absorbing: _cargando,
              child: Column(
                children: <Widget>[
                  
                  // _bancaAndTimeWidget(),
                  
                  _totalDescuentoAndIconWidget(),
                  _loteriasScreen(),
                  // SizedBox(height: 8,),
                  _jugadaMontoScreen(true),
                  // SizedBox(height: 8,),
                  
                  // SizedBox(height: 8,),
                  Expanded(
                    // flex: 3,
                    flex: 3,
                    child: Container(
                      // color: Colors.red,
                      child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                _buildButton(Text('.', style: TextStyle(fontSize: 22, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 4, 5),
                                _buildButton(Text('S', style: TextStyle(fontSize: 22, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 4, 5),
                                _buildButton(Text('D', style: TextStyle(fontSize: 22, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 4, 5),
                                _buildButton(Icon(Icons.backspace, size: ((constraints.maxHeight - 25) / 5).abs(), color: Colors.red[700],), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 4, 5),
                                // SizedBox(
                                //   width: MediaQuery.of(context).size.width / 4,
                                //   height: constraints.maxHeight / 5,
                                //   child: RaisedButton(
                                //     shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: .3)),
                                //     elevation: 0,
                                //     color: Utils.fromHex("#FFEDEBEB"),
                                //     onPressed: (){},
                                //     child: Center(child: Text('', style: TextStyle(fontSize: 23, color: _colorPrimary),)),
                                //   ),
                                // )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                _buildButton(Text('7', style: TextStyle(fontSize: 22, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                _buildButton(Text('8', style: TextStyle(fontSize: 22, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                _buildButton(Text('9', style: TextStyle(fontSize: 22, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                _buildButton(Text('/', style: TextStyle(fontSize: 22, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 4, 5),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                _buildButton(Text('4', style: TextStyle(fontSize: 22, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                _buildButton(Text('5', style: TextStyle(fontSize: 22, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                _buildButton(Text('6', style: TextStyle(fontSize: 22, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                _buildButton(
                                  ValueListenableBuilder(
                                    valueListenable: _connectionNotify, 
                                    builder: (context, value, __){
                                      if(value)
                                        return Text('-', style: TextStyle(fontSize: 22, color: _colorPrimary),);
                                      else
                                        return Icon(Icons.cloud_off, size: 20, color: Theme.of(context).primaryColor);
                                    }
                                  ),
                                  Utils.fromHex("#FFEDEBEB"), 
                                  constraints.maxHeight , 
                                  4, 
                                  5,
                                  value: '-'
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                _buildButton(Text('1', style: TextStyle(fontSize: 22, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                _buildButton(Text('2', style: TextStyle(fontSize: 22, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                _buildButton(Text('3', style: TextStyle(fontSize: 22, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                _buildButton(Text('+', style: TextStyle(fontSize: 22, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 4, 5),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                _buildButton(Text('0', style: TextStyle(fontSize: 22, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 2, 5),
                                _buildButton(Text('ENTER', style: TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 2, 5),
                              ],
                            )
                          ],
                        );
                      }
                    ),
                    ),
                  ),
                  _copyAndDeleteWidget()
                ],
              ),
            )
          ,
      ),
    );
                
              
  }

  void _chanceSeleccionarScreenValue([bool limpiarListJugadasSeleccionadas = true]){
    setState((){
      _isSeleccionarScreen = !_isSeleccionarScreen;
      if(!_isSeleccionarScreen){
        if(limpiarListJugadasSeleccionadas)
          listaJugadasSeleccionadas.clear();
      }
    });
  }

  void _seleccionarJugada(Jugada jugada){
    if(listaJugadasSeleccionadas.firstWhere((element) => element == jugada, orElse: () => null) != null){
      setState((){
        listaJugadasSeleccionadas.remove(jugada);
        if(listaJugadasSeleccionadas.length == 0)
          _chanceSeleccionarScreenValue();
      });

    }else
      setState(() => listaJugadasSeleccionadas.add(jugada));
  }

  _jugadaItemWidget(Jugada data){
    return GestureDetector(
      onLongPress: (){
        if(_isSeleccionarScreen == false){
          _chanceSeleccionarScreenValue();
          _seleccionarJugada(data);
        }else{
          _chanceSeleccionarScreenValue();
          listaJugadasSeleccionadas = [];
        }
      },
      onTap: !_isSeleccionarScreen ? null : () => _seleccionarJugada(data),
      child: Wrap(
        children: [
          MyResizedContainer(
            small: 3.8,
            child: Badge(
              badgeColor: Colors.green,
              position: BadgePosition(top: 0, end: 0),
              showBadge: listaJugadasSeleccionadas.firstWhere((element) => element == data, orElse: () => null) != null,
              badgeContent: Icon(Icons.check, size: 10),
              child: Center(child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0),
                child: Text("${Loteria.getDescripcion(data.loteria, loteriaSuperpale: data.loteriaSuperPale) }", style: TextStyle(fontSize: 16),),
              )),
            ),
          ),
          MyResizedContainer(
            small: 4,
            child: Center(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: Principal.buildRichOrTextAndConvertJugadaToLegible(data.jugada)
            )),
          ),
          MyResizedContainer(
            small: 4,
            child: Center(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: Text("${data.monto}", style: TextStyle(fontSize: 16),),
            )),
          ),
          MyResizedContainer(
            small: 5,
            child: Center(child: IconButton(padding: EdgeInsets.all(0), iconSize: 20, constraints: BoxConstraints(minWidth: 28, minHeight: 28), icon: Icon(Icons.delete), onPressed: (){setState((){listaJugadas.remove(data); _streamControllerJugada.add(listaJugadas);});},)),
          ),
        ],
      ),
    );
  }
  
  _myJugadasScreen(){
    // return Column(
    //             children: <Widget>[
    //               SizedBox(height: 8,),
    //               SizedBox(
    //                 width: MediaQuery.of(context).size.width,
    //                 child: RaisedButton(
    //                   child: Text('Eliminar todas'),
    //                   onPressed: (){
    //                     setState((){
    //                       listaJugadas.clear();
    //                       listaEstadisticaJugada.clear();
    //                     });
    //                   },
    //                 ),
    //               ),
    //               StreamBuilder<List<Jugada>>(
    //                 stream: _streamControllerJugada.stream,
    //                 builder: (context, snapshot){
    //                   if(snapshot.hasData){
    //                   listaJugadas = snapshot.data;

    //                     return _buildTable(listaJugadas);
    //                   }else{
    //                     return _buildTable([]);
    //                   }
                      
    //                 },
    //               ),
    //             ],
    //           );

    return AbsorbPointer(
      absorbing: _cargando,
      child: Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 4, top: 0),
                                  child: MyResizedContainer(
                                    small: 1,
                                    medium: 1,
                                    child: InkWell(
                                      onTap: (){
                                        setState(() => listaJugadas = []);
                                        _streamControllerJugada.add(listaJugadas);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 3),
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
                              Expanded(
                                child: StreamBuilder<List<Jugada>>(
                                  stream: _streamControllerJugada.stream,
                                  builder: (context, snapshot) {
                                    if(snapshot.data == null)
                                      return SizedBox.shrink();
                                    if(snapshot.data.length == 0)
                                      return SizedBox.shrink();
    
                                    return ListView.builder(
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index){
                                        if(index == 0)
                                        return Wrap(
                                          children: [
                                            Wrap(
                                              children: [
                                                MyResizedContainer(
                                                  small: 3.8,
                                                  child: Center(child: Text("Loteria", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),)),
                                                ),
                                                MyResizedContainer(
                                                  small: 4,
                                                  child: Center(child: Text("Jugada", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),)),
                                                ),
                                                MyResizedContainer(
                                                  small: 4,
                                                  child: Center(child: Text("Monto", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),)),
                                                ),
                                                MyResizedContainer(
                                                  small: 5,
                                                  child: Center(child: Text("Borrar", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),)),
                                                ),
                                              ],
                                            ),
                                            _jugadaItemWidget(snapshot.data[index])
                                          
                                            // Wrap(
                                            //   children: [
                                            //     MyResizedContainer(
                                            //       small: 3,
                                            //       child: Center(child: Text("Loteria")),
                                            //     ),
                                            //     MyResizedContainer(
                                            //       small: 3,
                                            //       child: Center(child: Text("Jugada")),
                                            //     ),
                                            //     MyResizedContainer(
                                            //       small: 3,
                                            //       child: Center(child: Text("Monto")),
                                            //     ),
                                            //     MyResizedContainer(
                                            //       small: 3,
                                            //       child: Center(child: Text("Borrar")),
                                            //     ),
                                            //   ],
                                            // ),
                                          
                                          ],
                                        );
                                
                                        return _jugadaItemWidget(snapshot.data[index]);
                                      }
                                    );
                                  }
                                ),
                              )
                            ],
                          ),
    );
                             
  }

  _iconButtonDeletePlay(Jugada jugada, {double size: 18}){
    return InkWell(
      child: Icon(Icons.delete, size: size), 
      onTap: (){
      listaJugadas.remove(jugada);
      _streamControllerJugada.add(listaJugadas);
    },);
  }

  _pagar([bool isSmallOrMedium = true]) async {
    dynamic datos = await Principal.showDialogPagarFormulario(scaffoldKey: _scaffoldKey, context: context, isSmallOrMedium: isSmallOrMedium);
    
    if(isSmallOrMedium){
      _scaffoldKey.currentState.openEndDrawer();
      await Future.delayed(Duration(milliseconds: 300));
    }

    if(datos == null)
      return;

    if(datos.isEmpty)
      return
      await Future.delayed(Duration(milliseconds: 300));

      Principal.showDialogPagar(context: context, scaffoldKey: _scaffoldKey, mapVenta: datos["venta"]);
  }
  
  _showDialogDuplicar([bool isSmallOrMedium = true]) async {
    Map<String, dynamic> datos = await Principal.showDialogDuplicarFormulario(context: context, scaffoldKey: _scaffoldKey, isSmallOrMedium: isSmallOrMedium);
    if(isSmallOrMedium){
      _scaffoldKey.currentState.openEndDrawer();
      await Future.delayed(Duration(milliseconds: 100));
    }
      

    if(datos == null)
      return;

    if(datos.isEmpty)
      return
    print("Principal _showDialogDuplicar: $datos");
    
      await _duplicar(datos);
    // print("prueba alertdialog: $prueba");
  }

  _appBarDuplicarTicket(SearchData searchData) async {
    Map<String, dynamic> datos = await TicketService.duplicar(codigoBarra: searchData.title, context: context);

    if(datos == null)
      return;

    // if(datos.isEmpty)
    //   return
    
      await _duplicar(datos);
    // print("prueba alertdialog: $prueba");
  }

  _directoPaleTripletaScreen(double width, bool isSmallOrMedium){
    if(ScreenSize.isXLarge(width) || ScreenSize.isLarge(width))
      return Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 1.0),
            child: Card(
              
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 7,
              child: MyResizedContainer(
                xlarge: 4.24,
                large: 3.3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    height: 270,
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text("Directo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600])),
                          ),
                        ),
                        Expanded(
                          child: MyTable(
                            type: MyTableType.custom,
                            showColorWhenImpar: true,
                            customRowHeight: 40,
                            customRowPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                            columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
                            rows: listaJugadas != null ?  listaJugadas.where((element) => element.sorteo == 'Directo').toList().map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: Principal.buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
                            delete: (){}
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1.0),
            child: Card(
              
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 7,
              child: MyResizedContainer(
                xlarge: 4,
                large: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    height: 270,
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text("Pale y Tripleta", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600]))
                          ),
                        ),
                        Expanded(
                          child: MyTable(
                            type: MyTableType.custom,
                            showColorWhenImpar: true,
                            customRowHeight: 40,
                            customRowPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                            customWidthOfOneCell: [CustomCellWidth(cellIndex: 1, widthPorcent: 0.43), CustomCellWidth(cellIndex: 3, widthPorcent: 0.10)],
                            columns: ["LOT", "NUM.", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 17))], 
                            rows: listaJugadas != null ?  listaJugadas.where((element) => element.sorteo.toLowerCase().indexOf("pale") != -1 || element.sorteo == 'Tripleta').toList().map<List<dynamic>>((e) => [e, Center(child: Text("${e.loteriaSuperPale == null ? e.loteria.abreviatura : e.loteria.abreviatura + '/' + e.loteriaSuperPale.abreviatura}", style: TextStyle(fontSize: 13))), Center(child: Principal.buildRichOrTextAndConvertJugadaToLegible(e.jugada, isSmallOrMedium: isSmallOrMedium)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e, size: 17)]).toList() : [[]],
                            delete: (){}
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
                            
        ]
      );
  
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 2.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 7,
        child: MyResizedContainer(
          xlarge: 4.19,
          large: 3.2,
          medium: 2.09,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(
              height: 270,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text("Directo-Pale-Tripleta", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[600])),
                    ),
                  ),
                  Expanded(
                    child: MyTable(
                      type: MyTableType.custom,
                      showColorWhenImpar: true,
                      customRowHeight: 40,
                      customRowPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                      columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
                      rows: listaJugadas!= null ?  listaJugadas.where((element) => element.sorteo == 'Directo' || element.sorteo == 'pale' || element.sorteo == 'Tripleta').toList().map<List<dynamic>>((e) => [e, "${e.loteriaSuperPale == null ? e.loteria.abreviatura : e.loteria.abreviatura + '/' + e.loteriaSuperPale.abreviatura}", Center(child: Principal.buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
                      delete: (){}
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
          
  }

  _pick34Screen(double width){
    if(ScreenSize.isXLarge(width))
      return Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
            child: Card(
              
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 7,
              child: MyResizedContainer(
                xlarge: 4.19,
                large: 4.3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    height: 270,
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text("Pick 3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600]))
                          ),
                        ),
                        Expanded(
                          child: MyTable(
                            type: MyTableType.custom,
                            showColorWhenImpar: true,
                            customRowHeight: 40,
                            customRowPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                            columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
                            rows: listaJugadas!= null ?  listaJugadas.where((element) => element.sorteo.toLowerCase().indexOf("pick 3") != -1).toList().map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: Principal.buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
                            delete: (){}
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
            child: Card(
              
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 7,
              child: MyResizedContainer(
                xlarge: 4.19,
                large: 4.3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    height: 270,
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text("Pick 4", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600]))
                          ),
                        ),
                        Expanded(
                          child: MyTable(
                            showColorWhenImpar: true,
                            customRowHeight: 40,
                            customRowPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                            type: MyTableType.custom,
                            customWidthOfOneCell: [CustomCellWidth(cellIndex: 1, widthPorcent: 0.43), CustomCellWidth(cellIndex: 3, widthPorcent: 0.10)],
                            columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
                            rows: listaJugadas!= null ?  listaJugadas.where((element) => element.sorteo.toLowerCase().indexOf("pick 4") != -1).toList().map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: Principal.buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
                            delete: (){}
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );


    
    return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1.0),
            child: Card(
              
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 7,
              child: MyResizedContainer(
                large: 3,
                medium: 2.09,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    height: 270,
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text("Pick 3 y 4", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600]))
                          ),
                        ),
                        Expanded(
                          child: MyTable(
                            showColorWhenImpar: true,
                            customRowHeight: 40,
                            customRowPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                            type: MyTableType.custom,
                            columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
                            rows: listaJugadas!= null ?  listaJugadas.where((element) => element.sorteo.toLowerCase().indexOf("pick") != -1).toList().map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: Principal.buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
                            delete: (){}
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  

  _screenOld(){
    return DefaultTabController(
          length: 2,
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              // For Android.
              // Use [light] for white status bar and [dark] for black status bar.
              statusBarIconBrightness: Brightness.light,
              // For iOS.
              // Use [dark] for white status bar and [light] for black status bar.
              statusBarBrightness: Brightness.light,
              // statusBarColor: Colors.transparent
              statusBarColor: Colors.transparent
            ),
            child: Scaffold(
              key: _scaffoldKey,
            drawer: _drawerWidget(),
            appBar: MediaQuery.of(context).size.height > 630
            ?
            // _appBar(false)
            PreferredSize(
              preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.133),
              child: _appBar(false),
            )
            :
            PreferredSize(
              preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.135),
              child: _appBar(true),
            ),
            body: TabBarView(
              children: <Widget>[
                _myPrincipalScreen(),
                // Center(child: Text("KLkl mi pana")),
                _myJugadasScreen()
              ],
            )
        ),
          ),
      
      );
  }

  _drawerWidget(){
    return MyMobileDrawer(
      scaffoldKey: _scaffoldKey, 
      onTapCambiarServidor: (){
        _cambiarServidor();
        _scaffoldKey.currentState.openEndDrawer();
      },
      onTapDuplicar: _showDialogDuplicar,
      onTapPagar: _pagar,
      onTapCerrarSesion: () async {
        // socket.close();
        // socket.dispose();
        _disconnectSocket();
        await Principal.cerrarSesion(context);
        await stopSocketNoticacionInForeground();
      }
    );
    
    return Drawer(
      child: 
      ListView(
        children: <Widget>[
          ListTile(
            title: FutureBuilder<Map<String, dynamic>>(
              future: futureBanca,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Text('${snapshot.data["descripcion"]}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300));
                }

                return Text('Banca...', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300));
              }
            ),
            subtitle: FutureBuilder<Map<String, dynamic>>(
              future: futureUsuario,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Text('${snapshot.data["servidor"]}');
                }

                return Text('Servidor...', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300));
              }
            ),
            leading: Container(
              width: 30,
              height: 30,
              child:  ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    widthFactor: 0.75,
                    heightFactor: 0.75,
                    child: Image(image: AssetImage('assets/images/loterias_dominicanas_sin_letras.png'), ),
                  ),
                ),
              ),
            ),
            onTap: () async {
              _cambiarServidor();
              _scaffoldKey.currentState.openEndDrawer();

            },
          ),
          Visibility(
            visible: _tienePermisoProgramador || _tienePermisoAdministrador,
            child: FutureBuilder<Pago>(
              future: _futureFactura,
              builder: (context, snapshot) {
                return ListTile(
                  title: Text('Facturas'),
                  leading: Icon(Icons.payment),
                  dense: true,
                  onTap: () async {
                    if(_tienePermisoProgramador)
                      Navigator.of(context).pushNamed("/pagos/servidores");
                    else if(_tienePermisoAdministrador)
                      // Navigator.of(context).pushNamed("/pagos", arguments: Servidor(descripcion: await Db.servidor()));
                      Navigator.of(context).pushNamed("/pagos/ver", arguments: snapshot.data != null ? snapshot.data.id : null);
                                
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                  subtitle: snapshot.data == null ? null : Row(
                    children: [
                      
                      Text("${snapshot.data.fechaDiasGracia != null ? 'Pagar antes del ' + MyDate.dateRangeToNameOrString(DateTimeRange(start: snapshot.data.fechaDiasGracia, end: snapshot.data.fechaDiasGracia)) : 'Tiene factura pendiente'}", style: TextStyle(color: Colors.pink)),
                    ],
                  )
                  // FutureBuilder<int>(
                  //   future: _futureFactura,
                  //   builder: (context, snapshot) {
                  //     return Visibility(
                  //       visible: snapshot.data != null, 
                  //       child: Text("Tiene factura pendiente", style: TextStyle(color: Colors.pink)
                  //     ));
                  //   }
                  // )
                );
              }
            ),
          ),
          
          Visibility(
            visible: _tienePermisoVerDashboard,
            child: ListTile(
              title: Text('Dashboard'),
              leading: Icon(Icons.dashboard),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/dashboard");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          Visibility(
            visible: _tienePermisoVerGeneral,
            child: ListTile(
              title: Text('General'),
              leading: Icon(Icons.widgets_outlined),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/general");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          Visibility(
            visible: _tienePermisoTransacciones,
            child: ListTile(
              title: Text('Transacciones'),
              leading: Icon(Icons.transfer_within_a_station),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/transacciones");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          Visibility(
            visible: _tienePermisoMonitorearTicket,
            child: ListTile(
              title: Text('Monitoreo'),
              leading: Icon(Icons.donut_large),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/monitoreo");
              _scaffoldKey.currentState.openEndDrawer();},
            ),
          ),
          Visibility(
            visible: _tienePermisoManejarResultados,
            child: ListTile(
              title: Text('Registrar premios'),
              leading: Icon(Icons.format_list_numbered),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/registrarPremios");
              _scaffoldKey.currentState.openEndDrawer();},
            ),
          ),
          Visibility(
            visible: _tienePermisoVerReporteJugadas || _tienePermisoVerHistoricoVentas || _tienePermisoVerVentas || _tienePermisoVerVentasPorFecha,
            child: ExpansionTile(
              leading: Icon(Icons.analytics),
              title: Text("Reportes"),
              children: [
                  Visibility(
                  visible: _tienePermisoVerReporteJugadas,
                  child: ListTile(
                    title: Text('Reporte jugadas'),
                    leading: Icon(Icons.receipt_long),
                    dense: true,
                    onTap: (){
                      Navigator.of(context).pushNamed("/reporteJugadas");
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                  ),
                ),
                Visibility(
                  visible: _tienePermisoVerHistoricoVentas,
                  child: ListTile(
                    title: Text('Historico ventas'),
                    leading: Icon(Icons.timeline),
                    dense: true,
                    onTap: (){
                      Navigator.of(context).pushNamed("/historicoVentas");
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                  ),
                ),
                Visibility(
                  visible: _tienePermisoVerVentasPorFecha,
                  child: ListTile(
                    title: Text('Ventas por fecha'),
                    leading: Icon(Icons.event_available),
                    dense: true,
                    onTap: (){
                      Navigator.of(context).pushNamed("/ventasPorFecha");
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                  ),
                ),
                Visibility(
                  visible: _tienePermisoVerVentas,
                  child: ListTile(
                    title: Text('Ventas'),
                    leading: Icon(Icons.insert_chart),
                    dense: true,
                    onTap: (){
                      Navigator.of(context).pushNamed("/ventas");
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                  ),
                ),
              ],
            ),
          ),
          
          
          Visibility(
            visible: _tienePermisoAdministrador || _tienePermisoProgramador,
            child: ListTile(
              title: Text('Pendientes de pago'),
              leading: Icon(Icons.attach_money),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/pendientesPago");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          ListTile(
            title: Text('Duplicar'),
            leading: Icon(Icons.scatter_plot),
            dense: true,
            onTap: _showDialogDuplicar,
          ),
          Visibility(
            visible: _tienePermisoMarcarTicketComoPagado,
            child: ListTile(
              title: Text("Pagar"),
              leading: Icon(Icons.payment),
              dense: true,
              onTap: _pagar,
            ),
          ),
          Visibility(
            visible: _tienePermisoManejarManejarReglas,
            child: ExpansionTile(
              leading: Icon(Icons.block),
              title: Text("Bloqueos"),
              children: [
                  ListTile(
                  title: Text('Por loterias'),
                  leading: Icon(Icons.group_work_outlined),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/bloqueosporloteria");
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
                  ListTile(
                  title: Text('Por jugadas'),
                  leading: Icon(Icons.pin),
                  dense: true,
                  onTap: (){
                    Navigator.of(context).pushNamed("/bloqueosporjugadas");
                    _scaffoldKey.currentState.openEndDrawer();
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: _tienePermisoManejarUsuarios || _tienePermisoVerIniciosDeSesion,
            child: ExpansionTile(
              leading: Icon(Icons.person_outline),
              title: Text("Usuarios"),
              children: [
                  Visibility(
                    visible: _tienePermisoManejarUsuarios,
                    child: ListTile(
                    title: Text('Usuarios'),
                    leading: Icon(Icons.person),
                    dense: true,
                    onTap: (){
                      Navigator.of(context).pushNamed("/usuarios");
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                                            ),
                  ),
                  Visibility(
                    visible: _tienePermisoVerIniciosDeSesion,
                    child: ListTile(
                    title: Text('Sesiones'),
                    leading: Icon(Icons.sync_alt),
                    dense: true,
                    onTap: (){
                      Navigator.of(context).pushNamed("/sesiones");
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                                            ),
                  ),
              ],
            ),
          ),
          Visibility(
            visible: _tienePermisoVerListaDeBalancesDeBancos || _tienePermisoVerListaDeBalancesDeBancass,
            child: ExpansionTile(
              leading: Icon(Icons.six_ft_apart),
              title: Text("Balances"),
              children: [
                Visibility(
                  visible: _tienePermisoVerListaDeBalancesDeBancos,
                  child: ListTile(
                    title: Text('Balance bancos'),
                    leading: Icon(Icons.account_balance_wallet_outlined),
                    dense: true,
                    onTap: (){
                      Navigator.of(context).pushNamed("/balancebancos");
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                  ),
                ),
                Visibility(
                  visible: _tienePermisoVerListaDeBalancesDeBancass,
                  child: ListTile(
                    title: Text('Balance bancas'),
                    leading: Icon(Icons.account_balance_wallet),
                    dense: true,
                    onTap: (){
                      Navigator.of(context).pushNamed("/balanceBancas");
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _tienePermisoProgramador,
            child: ListTile(
              title: Text('Cierres loterias'),
              leading: Icon(Icons.timer_off_rounded),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/cierresloterias");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          Visibility(
            visible: _tienePermisoManejarHorariosDeLoterias,
            child: ListTile(
              title: Text('Horarios loterias'),
              leading: Icon(Icons.timer),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/horariosloterias");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          Visibility(
            visible: _tienePermisoManejarMonedas,
            child: ListTile(
              title: Text('Monedas'),
              leading: Icon(Icons.attach_money_rounded),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/monedas");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          Visibility(
            visible: _tienePermisoManejarEntidadesContables,
            child: ListTile(
              title: Text('Entidades'),
              leading: Icon(Icons.apartment_outlined),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/entidades");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          
          
          Visibility(
            visible: _tienePermisoManejarBancas,
            child: ListTile(
              title: Text('Bancas'),
              leading: Icon(Icons.account_balance),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/bancas");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          Visibility(
            visible: _tienePermisoManejarLoterias,
            child: ListTile(
              title: Text('Loterias'),
              leading: Icon(Icons.group_work_outlined),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/loterias");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          Visibility(
            visible: _tienePermisoManejarManejarGrupos,
            child: ListTile(
              title: Text('Grupos'),
              leading: Icon(Icons.group_work),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/grupos");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          
          Visibility(
            visible: _tienePermisoVerAjustes,
            child: ListTile(
              title: Text('Ajustes'),
              leading: Icon(Icons.settings),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/ajustes");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          ListTile(
            title: Text('Version'),
            dense: true,
            leading: Icon(Icons.assignment),
            onTap: () async {
            Principal.showVersion(context: context);
            },
          ),
          Visibility(
            visible: _tienePermisoProgramador,
            child: ListTile(
              title: Text('Versiones'),
              leading: Icon(Icons.format_list_numbered_outlined),
              dense: true,
              onTap: (){
                Navigator.of(context).pushNamed("/versiones");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),
          ListTile(
            title: Text('Cerrar sesion'),
            dense: true,
            leading: Icon(Icons.clear),
            onTap: () async {
              
              // socket.close();
              // socket.dispose();
              _disconnectSocket();
              await Principal.cerrarSesion(context);
              await stopSocketNoticacionInForeground();
            },
          )
        ],
      ),

    );
            
  }


  @override
  build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return  
      (_cargandoDatosSesionUsuario)
      ?
      SplashScreen()
      :
      // kIsWeb && !isSmallOrMedium
      Utils.showLargeScreen(isSmallOrMedium)
      ?
      myScaffold(
        context: context,
        cargando: false,
        cargandoNotify: null,
        isSliverAppBar: true,
        inicio: true,
        valueNotifyDrawer: valueNotifyDrawer,
        appBarDuplicarTicket: _appBarDuplicarTicket,
        lotteryColor: _getLotteryColor(),
        onTextLoteriasTap: _cambiarServidor,
        onDrawerChanged: (){
          // valueNotifyDrawer.value = !valueNotifyDrawer.value;
        },
        // showDrawerOnSmallOrMedium: true,
        sliverBody: MySliver(
          sliverAppBar: MySliverAppBar(
            lotteryColor: _getLotteryColor(),
            title: Wrap(
              children: [
                // Text("Principal"),
                MyResizedContainer(child: _bancasScreen())
              ],
            ),
            showDivider: false,
            actions: [
              // MySliverButton(
              //   padding: EdgeInsets.all(0),
              //   title: IconButton(
              //   padding: EdgeInsets.all(0),
                  
              //     icon: Icon(Icons.save),
              //     onPressed: () async {
              //       // var channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8999'));
              //       // channel.stream.listen((message) {
              //       //   print("principalView received! from websocket");
              //       //   channel.sink.add(['POS58 Printer', 'hola como estas buen palomo']);
              //       //   channel.sink.close();
              //       // });
              //       var c = await DB.create();
              //       print("PrincipalView Icons.save printer: ${await c.getPrinter()}");
              //     },
              //     tooltip: "Guardar",
              //   ), 
              //   showOnlyOnLarge: true,
              //   onTap: (){}
              // ),
              // MySliverButton(
              //   padding: EdgeInsets.all(0),
              //   title: IconButton(
              //   padding: EdgeInsets.all(0),
              //     icon: Icon(Icons.print_rounded),
              //     onPressed: (){_bluetoothScreen(isSmallOrMedium);},
              //     tooltip: "Configuracion impresora",
              //   ), 
              //   showOnlyOnLarge: true,
              //   onTap: (){}
              // ),
            
            ],
          ), 
          sliver: SliverFillRemaining(
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: MyResizedContainer(
                    xlarge: 1,
                    large: 1,
                    medium: 1,
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0, left: 16.0),
                              child: MyResizedContainer(xlarge: 14, large: 8, medium: 11, child: _ckbPrintScreen(isSmallOrMedium)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 19.0),
                              child: MyResizedContainer(xlarge: 14, large: 8, medium: 11, child: _ckbDescuentoScreen(isSmallOrMedium)),
                            ),
                            MyResizedContainer(
                              xlarge: 4,  
                              builder: (context, width){
                                return Builder(
                                  builder: (context) {
                                    return _loteriasScreen(isSmallOrMedium, context, width);
                                  }
                                );
                              }
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: MyResizedContainer(xlarge: 8, large: 8, medium: 8, child: _jugadaTextField(isSmallOrMedium)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: MyResizedContainer(xlarge: 8, large: 8, medium: 8, child: _montoDisponibleTextField(isSmallOrMedium)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: MyResizedContainer(xlarge: 8, large: 8, medium: 8, child: _montoTextField(isSmallOrMedium)),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, right: 18.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Padding(
                       padding: const EdgeInsets.only(right: 20.0),
                       child: Wrap(
                           children: [
                             Container(
                               padding: EdgeInsets.symmetric(vertical: 5),
                               child: Text("Monto: ", style: TextStyle(fontSize: 20))
                              ),
                             Container(
                               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                               decoration: BoxDecoration(
                                 color: Utils.colorPrimary,
                                 borderRadius: BorderRadius.circular(5)
                               ),
                               child: Text("${listaJugadas != null ? listaJugadas.length > 0 ? Utils.toCurrency(listaJugadas.map((e) => e.monto).reduce((value, element) => value + element)) : Utils.toCurrency('0') : Utils.toCurrency('0')}", style: TextStyle(color: Colors.white, fontSize: 20))
                              ),
                           ],
                         ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 25.0),
                       child: Wrap(
                           children: [
                             Container(
                               padding: EdgeInsets.symmetric(vertical: 5),
                               child: Text("Descuento: ", style: TextStyle(fontSize: 20))
                              ),
                             FutureBuilder<int>(
                               future: _calcularDescuento(),
                               builder: (context, snapshot) {
                                 return Container(
                                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                   decoration: BoxDecoration(
                                     color: Utils.colorPrimary,
                                     borderRadius: BorderRadius.circular(5)
                                   ),
                                   child: Text("${snapshot.hasData ? Utils.toCurrency(snapshot.data) : Utils.toCurrency('0')}", style: TextStyle(color: Colors.white, fontSize: 20))
                                  );
                               }
                             ),
                           ],
                         ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 25.0),
                       child: Wrap(
                           children: [
                             Container(
                               padding: EdgeInsets.symmetric(vertical: 5),
                               child: Text("Total a pagar: ", style: TextStyle(fontSize: 20))
                              ),
                             FutureBuilder<int>(
                               future: _calcularDescuento(),
                               builder: (context, snapshot) {
                                 double totalAPagar = listaJugadas != null ? listaJugadas.length > 0 ? listaJugadas.map((e) => e.monto).reduce((value, element) => value + element) : 0.0 : 0.0;
                                 if(snapshot.hasData)
                                  totalAPagar = totalAPagar - snapshot.data;
        
                                 return Container(
                                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                   decoration: BoxDecoration(
                                     color: Colors.green,
                                     borderRadius: BorderRadius.circular(5)
                                   ),
                                   child: Text("${Utils.toCurrency(totalAPagar)}", style: TextStyle(color: Colors.white, fontSize: 20))
                                  );
                               }
                             ),
                           ],
                         ),
                     ),
                       Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                         child: Wrap(
                           children: [
                             Container(
                               padding: EdgeInsets.symmetric(vertical: 5),
                               child: Text("Jugadas: ", style: TextStyle(fontSize: 20))
                              ),
                             StreamBuilder<List<Jugada>>(
                               stream: _streamControllerJugada.stream,
                               builder: (context, snapshot) {
                                 return Container(
                                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                   decoration: BoxDecoration(
                                     color: Utils.colorPrimary,
                                     borderRadius: BorderRadius.circular(5)
                                   ),
                                   child: Text("${listaJugadas.length}", style: TextStyle(color: Colors.white, fontSize: 20))
                                  );
                               }
                             ),
                           ],
                         ),
                       ),
                    //  RichText(
                    //    text: TextSpan(
                    //      style: TextStyle(color: Colors.black),
                    //      children: [
                    //        TextSpan(
                    //          text: "Monto: "
                    //        ),
                    //        TextSpan(
                    //      style: TextStyle(color: Colors.blue[700],),
                    //          text: "${listaJugadas != null ? listaJugadas.length > 0 ? Utils.toCurrency(listaJugadas.map((e) => e.monto).reduce((value, element) => value + element)) : '0' : '0'}"
                    //        )
                    //      ]
                    //    )
                    //   ),
                    ],
                  ),
                ),
                StreamBuilder<List<Jugada>>(
                  stream: _streamControllerJugada.stream,
                  builder: (context, snapshot) {
                    return MyResizedContainer(
                      xlarge: 1,
                      large: 1,
                      medium: 1,
                      builder: (context, width) {
                        return Wrap(
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 2.0),
                            //   child: Card(
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10.0),
                            //     ),
                            //     elevation: 5,
                            //     child: MyResizedContainer(
                            //       xlarge: 4.19,
                            //       large: 4.3,
                            //       child: Padding(
                            //         padding: const EdgeInsets.symmetric(vertical: 12.0),
                            //         child: Container(
                            //           height: 270,
                            //           child: Column(
                            //             children: [
                            //               Center(
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.only(bottom: 8.0),
                            //                   child: Text("Directo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600])),
                            //                 ),
                            //               ),
                            //               Expanded(
                            //                 child: MyTable(
                            //                   type: MyTableType.custom,
                            //                   columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
                            //                   rows: listaJugadas!= null ?  listaJugadas.where((element) => element.sorteo == 'Directo').toList().map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: Principal.buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
                            //                   delete: (){}
                            //                 ),
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                            //   child: Card(
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10.0),
                            //     ),
                            //     elevation: 5,
                            //     child: MyResizedContainer(
                            //       xlarge: 4.19,
                            //       large: 4.3,
                            //       child: Padding(
                            //         padding: const EdgeInsets.symmetric(vertical: 12.0),
                            //         child: Container(
                            //           height: 270,
                            //           child: Column(
                            //             children: [
                            //               Center(
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.only(bottom: 8.0),
                            //                   child: Text("Pale y Tripleta", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600]))
                            //                 ),
                            //               ),
                            //               Expanded(
                            //                 child: MyTable(
                            //                   type: MyTableType.custom,
                            //                   columns: ["LOT", "NUM.", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 17))], 
                            //                   rows: listaJugadas!= null ?  listaJugadas.where((element) => element.sorteo.toLowerCase().indexOf("pale") != -1 || element.sorteo == 'Tripleta').toList().map<List<dynamic>>((e) => [e, Center(child: Text("${e.loteria.abreviatura}", style: TextStyle(fontSize: 13))), Center(child: Principal.buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e, size: 17)]).toList() : [[]],
                            //                   delete: (){}
                            //                 ),
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                            //   child: Card(
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10.0),
                            //     ),
                            //     elevation: 5,
                            //     child: MyResizedContainer(
                            //       xlarge: 4.19,
                            //       large: 4.3,
                            //       child: Padding(
                            //         padding: const EdgeInsets.symmetric(vertical: 12.0),
                            //         child: Container(
                            //           height: 270,
                            //           child: Column(
                            //             children: [
                            //               Center(
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.only(bottom: 8.0),
                            //                   child: Text("Pick 3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600]))
                            //                 ),
                            //               ),
                            //               Expanded(
                            //                 child: MyTable(
                            //                   type: MyTableType.custom,
                            //                   columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
                            //                   rows: listaJugadas!= null ?  listaJugadas.where((element) => element.sorteo.toLowerCase().indexOf("pick 3") != -1).toList().map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: Principal.buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
                            //                   delete: (){}
                            //                 ),
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                            //   child: Card(
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10.0),
                            //     ),
                            //     elevation: 5,
                            //     child: MyResizedContainer(
                            //       xlarge: 4.19,
                            //       large: 4.3,
                            //       child: Padding(
                            //         padding: const EdgeInsets.symmetric(vertical: 12.0),
                            //         child: Container(
                            //           height: 270,
                            //           child: Column(
                            //             children: [
                            //               Center(
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.only(bottom: 8.0),
                            //                   child: Text("Pick 3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey[600]))
                            //                 ),
                            //               ),
                            //               Expanded(
                            //                 child: MyTable(
                            //                   type: MyTableType.custom,
                            //                   columns: ["LOT", "NUM", "MONT", Center(child: Icon(Icons.delete_outline_outlined, size: 18))], 
                            //                   rows: listaJugadas!= null ?  listaJugadas.where((element) => element.sorteo.toLowerCase().indexOf("pick 4") != -1).toList().map<List<dynamic>>((e) => [e, "${e.loteria.abreviatura}", Center(child: Principal.buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Utils.toCurrency(e.monto)}", _iconButtonDeletePlay(e)]).toList() : [[]],
                            //                   delete: (){}
                            //                 ),
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          
                            _directoPaleTripletaScreen(width, isSmallOrMedium),
                            _pick34Screen(width)
                          ],
                        );
                      }
                    );
                  }
                ),
        
                AbsorbPointer(
                  absorbing: _cargando,
                  child: MyButton(
                    medium: 4.3,
                    cargando: false,
                    type: MyButtonType.roundedWithOnlyBorder,
                    // color: Colors.blue[700],
                    title: _cargando ? SizedBox(width: 14, height: 14, child: CircularProgressIndicator()) : "Crear ticket",
                    function: guardar,
                    
                    cargandoNotify: ValueNotifier<bool>(_cargando),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: MyButton(
                    xlarge: 8,
                    large: 5,
                    medium: 5,
                    cargando: false,
                    type: MyButtonType.roundedWithOnlyBorder,
                    // color: Colors.blue[700],
                    textColor: Colors.pink,
                    title: "Impresora",
                    function: (){_bluetoothScreen(isSmallOrMedium);},
                    cargandoNotify: ValueNotifier<bool>(false),
                  ),
                ),
                Visibility(
                  visible: _tienePermisoMarcarTicketComoPagado,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: MyButton(
                      xlarge: 9,
                      large: 7.5,
                      medium: 6.8,
                      cargando: false,
                      type: MyButtonType.roundedWithOnlyBorder,
                      // color: Colors.blue[700],
                      // textColor: Colors.pink,
                      title: "Pagar",
                      function: (){_pagar(isSmallOrMedium);},
                      cargandoNotify: ValueNotifier<bool>(false),
                    ),
                  ),
                ),
                Visibility(
                  visible: _tienePermisoMarcarTicketComoPagado,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: MyButton(
                      xlarge: 9,
                      large: 7,
                      medium: 6,
                      cargando: false,
                      type: MyButtonType.roundedWithOnlyBorder,
                      // color: Colors.blue[700],
                      // textColor: Colors.pink,
                      title: "Copiar",
                      function: (){_showDialogDuplicar(isSmallOrMedium);},
                      cargandoNotify: ValueNotifier<bool>(false),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: MyButton(
                    xlarge: 9,
                    large: 8,
                    medium: 6,
                    cargando: false,
                    type: MyButtonType.roundedWithOnlyBorder,
                    // color: Colors.blue[700],
                    // textColor: Colors.pink,
                    title: "Ligar",
                    function: (){
                      if(listaJugadas.length >= 2){
                        _showLigarDialog();
                        return;
                      }
                    },
                  ),
                ),
                // MyButton(
                //   title: "Impresora",
                //   function: guardar,
                //   color: Colors.green
                // )
              ],
            ),
          )
        )
      )
      :
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          // For Android.
          // Use [light] for white status bar and [dark] for black status bar.
          statusBarIconBrightness: Brightness.light,
          // For iOS.
          // Use [dark] for white status bar and [light] for black status bar.
          statusBarBrightness: Brightness.light,
          // statusBarColor: Colors.transparent
          statusBarColor: Colors.blue
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
        drawer: _drawerWidget(),
        appBar: 
        
        // _appBar(true)
        PreferredSize(
          preferredSize: Size.fromHeight( MediaQuery.of(context).size.height > 630 ? MediaQuery.of(context).size.height * 0.065 : MediaQuery.of(context).size.height * 0.065),
          child: MediaQuery.of(context).size.height > 630 ? _appBar(false) : _appBar(true)
        )
        // PreferredSize(
        //   preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.133),
        //   child: _appBar(false),
        // )
        
        
        // PreferredSize(
        //   preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.135),
        //   child: _appBar(true),
        // )
        ,
        body: Column(
          children: [
            // Flexible(
            //   flex: 1,
            //   child: _myJugadasScreen()
            // ),
            // Expanded(
            //   flex: 1,
            //   child: LayoutBuilder(
            //     builder: (context, boxConstraint){
            //       return _myPrincipalScreen(boxConstraint);
            //     },
            //   )
            // ),
            Container(
              height: MediaQuery.of(context).size.height / 2.52,
              child: _myJugadasScreen()
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, boxConstraint){
                  return  _myPrincipalScreen(boxConstraint.maxHeight > 85 ? boxConstraint : BoxConstraints(maxHeight: 100));
                },
              )
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height / 2.5,
            //   child: LayoutBuilder(
            //     builder: (context, boxConstraint){
            //       return _myPrincipalScreen(boxConstraint);
            //     },
            //   )
            // ),
          ],
        )
        // TabBarView(
        //   children: <Widget>[
        //     // Center(child: Text("KLkl mi pana")),
        //     _myJugadasScreen()
        //   ],
        // )
        ),
      );
    


  }

void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = Utils.formatDateTime(now);
    setState(() {

      _timeString = formattedDateTime;
    });
    quitarLoteriasCerradas();
  }

  DateTime _convertirHoraCierreLoteriaAHoraCierreCurrentTimeZone(Loteria loteria) {
    var santoDomingo = getLocation('America/Santo_Domingo');
    var fechaActualRd = TZDateTime.now(santoDomingo);
    var fechaLoteriaRD = DateTime.parse(fechaActualRd.year.toString() + "-" + Utils.toDosDigitos(fechaActualRd.month.toString())+ "-" + Utils.toDosDigitos(fechaActualRd.day.toString()) + " ${loteria.horaCierre != null ? loteria.horaCierre : '00:00'}");
    // var fechaFinalRd = TZDateTime.now(santoDomingo);

    
    var currentTimeZoneLocation = getLocation(currentTimeZone);
    // var currentTimeZoneFechaActual = TZDateTime.now(currentTimeZoneLocation);
    // var fechaLoteriaCurrentTimeZone = DateTime.parse(fechaActualRd.year.toString() + "-" + Utils.toDosDigitos(fechaActualRd.month.toString())+ "-" + Utils.toDosDigitos(fechaActualRd.day.toString()) + " ${loteria.horaCierre}");
    var fechaLoteriaCurrentTimeZone = TZDateTime.from(fechaLoteriaRD, currentTimeZoneLocation);

    return fechaLoteriaCurrentTimeZone;
  }

  DateTime _horaCierreLoteriaToCurrentTimeZone(Loteria loteria) {
    if(currentTimeZone == null)
      return DateTime.now();
    var santoDomingo = getLocation('America/Santo_Domingo');
    var fechaActualRd = TZDateTime.now(santoDomingo);
    var fechaLoteriaRD = DateTime.parse(fechaActualRd.year.toString() + "-" + Utils.toDosDigitos(fechaActualRd.month.toString())+ "-" + Utils.toDosDigitos(fechaActualRd.day.toString()) + " ${loteria.horaCierre != null ? loteria.horaCierre : '00:00'}");
    
    int horasASumar = (fechaLoteriaRD.hour - fechaActualRd.hour);
    int minutosASumar = (fechaLoteriaRD.minute - fechaActualRd.minute);
    int segundosARestar = fechaActualRd.second;
    
    var fechaLoteriaConvertidaAFormatoRD;
    fechaLoteriaConvertidaAFormatoRD = fechaActualRd.add(Duration(hours: horasASumar, minutes: minutosASumar));
    fechaLoteriaConvertidaAFormatoRD = fechaLoteriaConvertidaAFormatoRD.subtract(Duration(seconds: segundosARestar));

    var currentTimeZoneLocation = getLocation(currentTimeZone);
    var fechaLoteriaCurrentTimeZone = TZDateTime.from(fechaLoteriaConvertidaAFormatoRD, currentTimeZoneLocation);

    return fechaLoteriaCurrentTimeZone;
  }

  Text _getLoteriaRemainingTime(Loteria loteria) {
    

    //Formato de minutos y segundos
    // DateFormat format = DateFormat("mm:ss");

    var convertirHoraCierreLoteriaAHoraCierreCurrentTimeZone = _horaCierreLoteriaToCurrentTimeZone(loteria);
    if(_tienePermisoJugarMinutosExtras)
      convertirHoraCierreLoteriaAHoraCierreCurrentTimeZone = convertirHoraCierreLoteriaAHoraCierreCurrentTimeZone.add(Duration(minutes: loteria.minutosExtras));

    //Formato de minutos
    DateFormat format = DateFormat("m");
    // int now = DateTime.now().millisecondsSinceEpoch;
    int now = DateTime.now().millisecondsSinceEpoch;
    Duration remaining = Duration(milliseconds: convertirHoraCierreLoteriaAHoraCierreCurrentTimeZone.millisecondsSinceEpoch - now);
    
     
    String dateString = "";
    // print("_getLoteriaRemainingTime: ${remaining.inHours} m:${remaining.inMinutes} s:${remaining.inSeconds}");
    if(remaining.inHours == 0 && remaining.inMinutes > 0 ){
      String formato = format.format(DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds));
      // String formato = format.format(DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds));
    // print("_getLoteriaRemainingTime: ${remaining.inMinutes}");


      // if(remaining.inMinutes > 0)
        return Text("${remaining.inMinutes} minutos restantes", style: TextStyle(fontSize: 13, color: Colors.red, ), softWrap: true, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start);
      // else{
      //   format = DateFormat("ss");
      //   return Text("${remaining.inSeconds} segundos restantes", style: TextStyle(fontSize: 13, color: Colors.red));
      // }
    }
    else if(remaining.inHours == 0 && remaining.inSeconds > 0)
        return Text("${remaining.inSeconds} segundos restantes", style: TextStyle(fontSize: 13, color: Colors.red), softWrap: true, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start);
    else if(remaining.inHours <= 0 && remaining.inSeconds <= 0)
        return Text("Cerrada", style: TextStyle(fontSize: 13, color: Colors.red));
    else{
      format = new DateFormat('hh:mm a');
    // print("Cerrado _getLoteriaRemainingTime: m:${remaining.inMinutes} s:${remaining.inSeconds}");

      // dateString = "${format.format(convertirHoraCierreLoteriaAHoraCierreCurrentTimeZone)}";
      return Text("${format.format(convertirHoraCierreLoteriaAHoraCierreCurrentTimeZone)}", style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.5)));
    }
    dateString = '${remaining.inHours}:${format.format(DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds))}';
    // return dateString;
  }

  StreamBuilder _getLoteriaStream(Loteria loteria, {bool isSmallOrMedium = true}){
    Color _textColor;
    if(loteria.color != null){
     var lotterycolor = _listaLotteryColor.firstWhere((element) => element.toHex() == loteria.color, orElse:() => null,);
     if(lotterycolor != null)
      _textColor = lotterycolor.color;
    }

    return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 1), (i) => i),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        String dateString = "";
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Text("${loteria.descripcion}", style: TextStyle(fontSize: !isSmallOrMedium ? 16 : 17, color: _textColor)),
            _getLoteriaRemainingTime(loteria)
           // Text(dateString, style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.5) ))
          ],
        );
        return ListTile(
          title: Text("${loteria.descripcion}"),
          subtitle: Text(dateString),
        );
        return Container(color: Colors.greenAccent.withOpacity(0.3),
          alignment: Alignment.center,
          child: Text(dateString),);
      });
  }

  StreamBuilder _getSelectedLoteriaStream(bool isSmallOrMedium){
    

    return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 1), (i) => i),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        String dateString = "";
        // print(dateString);
        if(_selectedLoterias == null)
          return Principal.loteriasSeleccionadasToString(_selectedLoterias, _colorSegundary, isSmallOrMedium: isSmallOrMedium, listaLotteryColor: _listaLotteryColor);

        if(_selectedLoterias.length > 1 || _selectedLoterias.length == 0)
          return Principal.loteriasSeleccionadasToString(_selectedLoterias, _colorSegundary, isSmallOrMedium: isSmallOrMedium, listaLotteryColor: _listaLotteryColor);

        return 
        isSmallOrMedium
        ?
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("${_selectedLoterias[0].descripcion}"),
            Principal.loteriasSeleccionadasToString(_selectedLoterias, _colorSegundary, isSmallOrMedium: isSmallOrMedium, listaLotteryColor: _listaLotteryColor),
            // Text(dateString, style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.5) ))
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: _getLoteriaRemainingTime(_selectedLoterias[0]),
            )
          ],
        )
        :
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Text("${_selectedLoterias[0].descripcion}"),
            Principal.loteriasSeleccionadasToString(_selectedLoterias, _colorSegundary, isSmallOrMedium: isSmallOrMedium, listaLotteryColor: _listaLotteryColor),
            // Text(dateString, style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.5) ))
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _getLoteriaRemainingTime(_selectedLoterias[0]),
              ),
            )
          ],
        )
        ;
        // return ListTile(
        //   title: Text("${loteria.descripcion}"),
        //   subtitle: Text(dateString),
        // );
        // return Container(color: Colors.greenAccent.withOpacity(0.3),
        //   alignment: Alignment.center,
        //   child: Text(dateString),);
      });
  }


  void _showMultiSelect(BuildContext context) async {
    // final items = <MultiSelectDialogItem<int>>[
    //   MultiSelectDialogItem(1, 'Dog'),
    //   MultiSelectDialogItem(2, 'Cat'),
    //   MultiSelectDialogItem(3, 'Mouse'),
    // ];

    var initialSelectedValues = (_selectedLoterias != null) ? _selectedLoterias.map((l) => l.id).toSet() : null;

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        // var items = listaLoteria.map((l){
        //       return MultiSelectDialogItem(l.id, l.descripcion);
        //     }).toList();
        //     return MultiSelectDialog(
        //       items: items,
        //       // initialSelectedValues: [1, 3].toSet(),
        //     );
        // return MultiSelectDialog(
        //   items: items,
        //   initialSelectedValues: [1, 3].toSet(),
        // );
        return StreamBuilder(

          stream: _streamControllerLoteria.stream,
          builder: (context, snapshot){
            List<Loteria> lista;
            if(snapshot.hasData){
              lista = snapshot.data;
            }else{
              lista = [];
              lista.add(Loteria(descripcion: 'No hay datos', id: 0));
            }
            var items = lista.map((l){
              return MultiSelectDialogItem(l.id, _getLoteriaStream(l));
            }).toList();
            return MultiSelectDialog(
              items: items,
              // initialSelectedValues: [1, 3].toSet(),
              // initialSelectedValues: initialSelectedValues,
              initialSelectedValues: (_selectedLoterias != null) ? _selectedLoterias.map((l) => l.id).toSet() : null,
            );
          },
        );
      },
    );

    _selectedLoterias = [];
    if(selectedValues != null){
      final selectedValuesMap = selectedValues.toList().asMap();
      for(int c=0; c < selectedValuesMap.length; c++){
        Loteria data = listaLoteria.firstWhere((l) => l.id == selectedValuesMap[c], orElse: () => null);
        if(data != null)
          _selectedLoterias.add(data);
      }
    }
    // print(_selectedLoterias.length);
  }

  

  Widget _buildButton(Widget text_or_icon, var color, double height, int countWidth, int countHeight, {dynamic value}){
    // return SizedBox(
    //     width: MediaQuery.of(context).size.width / countWidth,
    //     height: height / countHeight,
    //     child: RaisedButton(
    //       shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: .3)),
    //       elevation: 0,
    //       color: color,
    //       onPressed: (){
    //         if(text_or_icon is Text){
    //           _escribir(value != null ? value : text_or_icon.data);
    //         }else{
    //           _escribir(value != null ? value : 'backspace');
    //         }
    //       },
    //       child: Center(child: text_or_icon),
    //     ),
    //   );

    return Container(
        width: MediaQuery.of(context).size.width / countWidth,
        height: height / countHeight,
        color: color,
        child: InkWell(
          // shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: .3)),
          // elevation: 0,
          // color: color,
          onTap: (){
            if(text_or_icon is Text){
              _escribir(value != null ? value : text_or_icon.data);
            }else{
              _escribir(value != null ? value : 'backspace');
            }
          },
          child: Center(child: text_or_icon),
        ),
      );
  }

  _cambiarFocusJugadaMonto(){
    // if(_isLargeAndWeb()){
    //   _jugadaOmonto = !_jugadaFocusNode.hasFocus;
    //   if(_jugadaOmonto)
    //     _jugadaFocusNode.requestFocus();
    //   else
    //     _montoFocusNode.requestFocus();

    //     return;
    //   }


    // setState((){
    //   _jugadaOmonto = !_jugadaOmonto;
    // });

    if(_isLargeAndWeb()){
      _jugadaOmonto = !_jugadaFocusNode.hasFocus;
      if(_jugadaOmonto)
        _jugadaFocusNode.requestFocus();
      else{
          _montoFocusNode.requestFocus();
          _txtMonto.selection = TextSelection(baseOffset:0, extentOffset:_txtMonto.text.length);
          return;
        }
      }


    setState((){
      _jugadaOmonto = !_jugadaOmonto;
      print("PrincipalView _cambiarFocusJugadaMonto: $_jugadaOmonto");
    });
  }

  Future<void> _escribir(String caracter) async {
    _jugadaOmonto = _isLargeAndWeb() ? _jugadaFocusNode.hasFocus : _jugadaOmonto;
    if(caracter == '.'){
      if(_txtJugada.text.isEmpty && listaJugadas.length >= 2){
        _showLigarDialog();
        return;
      }
    }
    // if(caracter == 'S'){
    //   if(_txtJugada.text.isEmpty && _selectedLoterias.length == 2)
    //     _showLigarDialog();
    //   return;
    // }
    if(caracter == '/'){
        _seleccionarSiguienteLoteria();
        return;
    }
    if(caracter == 'ENTER'){
      if(_jugadaOmonto){
        setState((){
          changeMontoDisponibleFromTxtMontoDisponible();
          _jugadaOmonto = !_jugadaOmonto;
          _txtMontoPrimerCaracter = true;
        });
      }else{
        if(_txtJugada.text.indexOf(".") != -1){
          _combinarJugadas();
          _cambiarFocusJugadaMonto();
        }
        else{
          // if(kIsWeb){
          //   if(_txtMontoDisponible.text.toLowerCase() != "x"){
          //     if(Utils.toDouble(_txtMontoDisponible.text) < Utils.toDouble(_txtMonto.text)){
          //       Utils.showAlertDialog(title: "Monto insuficiente", context: context, content: "No hay monto suficiente para esta jugada");
          //       return;
          //     }
          //   }
          // }
          List<Jugada> jugadasSinMontoDisponible = await addJugada(jugada: Utils.ordenarMenorAMayor(_txtJugada.text), montoDisponible: _txtMontoDisponible.text, monto: _txtMonto.text, selectedLoterias: _selectedLoterias);
          if(jugadasSinMontoDisponible.length > 0)
            TicketService.showDialogJugadasSinMontoDisponible(context, () async => await Future.delayed(Duration(milliseconds: 0), () => jugadasSinMontoDisponible));
        }
      }
      return;
    }

    if(_txtJugada.text.length == 0 && caracter == '-' && !_isLargeAndWeb()){
      // guardar();
      return;
    }

    if(_jugadaOmonto){
      if(caracter == 'backspace'){
        setState(() => _txtJugada.text = (_txtJugada.text.length > 0) ? _txtJugada.text.substring(0, (_txtJugada.text).length - 1) : _txtJugada.text);
        return;
      }
      else if(_txtJugada.text.length < 6 || (_txtJugada.text.length == 6 && caracter == ".")){
        if(esCaracterEspecial(caracter) == false){
          if(_isLargeAndWeb())
            return;

          _txtJugada.text = _txtJugada.text + caracter;
        }
        else{
          if(caracter == '+'){
            ponerSignoMas();
          }
          if(caracter == '-'){
            ponerSignoMenos();
          }
          if(caracter == 'S' || caracter == 's'){
            ponerSignoS();
          }
          if(caracter == '.'){
            if(esCaracterEspecial(_txtJugada.text) == false)
              ponerPunto();
          }
        }
      }
    }else{
      if(caracter == 'backspace'){
        setState(() => _txtMonto.text = (_txtMonto.text.length > 0) ? _txtMonto.text.substring(0, (_txtMonto.text).length - 1) : _txtMonto.text);
        return;
      }else if(_txtMonto.text.length < 6){
        if(esCaracterEspecial(caracter) == false){
          if(_txtMontoPrimerCaracter){
            _txtMonto.text = caracter;
            setState(() => _txtMontoPrimerCaracter = false);
          }
          else
            _txtMonto.text = _txtMonto.text + caracter;
        }
        else{
          if(caracter == '.'){
            ponerPuntoEnMonto();
          }
          
        }
      }
    }
  }

  bool esCaracterEspecial(String caracter){
    try {
       double.parse(caracter);
       return false;
    } catch (e) {
      return true;
    }
  }

  _combinarJugadas() async {
    List<String> combinacionesJugadas = Utils.generarCombinaciones(_txtJugada.text.substring(0, _txtJugada.text.length - 1));
    // print("Combinaciones retornadas: ${combinacionesJugadas.length}");
    double montoJugada = Utils.toDouble(_txtMonto.text);
    for(int i=0; i < combinacionesJugadas.length; i++){
      // print("Combinaciones retornadas for antes: ${combinacionesJugadas[i]}");
      // for(int il=0; il < _selectedLoterias.length; il++){
      //   double montoDisponible = await getMontoDisponible(Utils.ordenarMenorAMayor(combinacionesJugadas[i]), _selectedLoterias[il], await _selectedBanca());
      //   if(montoDisponible < montoJugada){
      //     Utils.showAlertDialog(context: context,title: "No hay disponibilidad",content: "No hay monto disponible para la jugada ${combinacionesJugadas[i]} en la loteria ${_selectedLoterias[il].descripcion}");
      //     return;
      //   }
      // }

      await addJugada(jugada: Utils.ordenarMenorAMayor((combinacionesJugadas[i])), montoDisponible: montoJugada.toString(), monto: _txtMonto.text, selectedLoterias: _selectedLoterias);
      // print("Combinaciones retornadas for despues: ${combinacionesJugadas[i]}");
    
    }
  }

  _showLigarDialog() async {
    // setState((){
      _ckbLigarPale = true;
      _ckbLigarTripleta = false;
    // });

    _txtLoteriasSeleccionadasParaLigar.text = "";
    _txtMontoLigar.text = "";
    List<Loteria> _selectedLoteriasLigar = [];

    return await showDialog(
      context: context,
      builder: (context){
        String _paleOTripleta = "pale";
        return StatefulBuilder(
          builder: (context, setState) {
            
            

             _changeLoteriasInTextController(){
              String loteriasSeleccionadasParaLigar = "";
              _selectedLoteriasLigar.forEach((element) {
                loteriasSeleccionadasParaLigar += element.descripcion+", "; 
              });
              _txtLoteriasSeleccionadasParaLigar.text = loteriasSeleccionadasParaLigar;
            }
            
            void _showMultiSelectLigar(BuildContext context) async {

              final selectedValues = await showDialog<Set<int>>(
                context: context,
                builder: (BuildContext context) {
                  
                  return StreamBuilder(

                    stream: _streamControllerLoteria.stream,
                    builder: (context, snapshot){
                      List<Loteria> lista;
                      if(snapshot.hasData){
                        lista = snapshot.data;
                      }else{
                        lista = List();
                        lista.add(Loteria(descripcion: 'No hay datos', id: 0));
                      }
                      var items = lista.map((l){
                        return MultiSelectDialogItem(l.id, l.descripcion);
                      }).toList();
                      return MultiSelectDialog(
                        items: items,
                        // initialSelectedValues: [1, 3].toSet(),
                        initialSelectedValues: null,
                      );
                    },
                  );
                },
              );

              _selectedLoteriasLigar = List();
              if(selectedValues != null){
                final selectedValuesMap = selectedValues.toList().asMap();
                for(int c=0; c < selectedValuesMap.length; c++){
                  _selectedLoteriasLigar.add(listaLoteria.firstWhere((l) => l.id == selectedValuesMap[c]));
                }

                // String loteriasSeleccionadasParaLigar = "";
                // _selectedLoteriasLigar.forEach((element) {
                //   loteriasSeleccionadasParaLigar += element.descripcion+", "; 
                // });
                // _txtLoteriasSeleccionadasParaLigar.text = loteriasSeleccionadasParaLigar;
                _changeLoteriasInTextController();
              }
              
            }

           

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              title: Text("Ligar pale y tripleta"),
              content: SingleChildScrollView(
                child: Form(
                  key: _formLigarKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    InkWell(
                      onTap: (){
                        _showMultiSelectLigar(context);
                      },
                      child: TextFormField(
                        controller: _txtLoteriasSeleccionadasParaLigar,
                        enabled: false,
                        style: TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: "Seleccionar loterias",
                            contentPadding: EdgeInsets.all(10),
                            isDense: true,
                            border: new OutlineInputBorder(
                              // borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                          ),
                        ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Monto"),
                      controller: _txtMontoLigar,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // WhitelistingTextInputFormatter.digitsOnly
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (data){
                        if(data.isEmpty)
                          return 'No tiene datos';
              
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    Wrap(children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                       children: [
                          Checkbox(value: _ckbLigarPale, onChanged: (value) => setState(() => _ckbLigarPale = value)),
                          Text("Pale"),
                       ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                       children: [
                          Checkbox(value: _ckbLigarTripleta, onChanged: (value) => setState(() => _ckbLigarTripleta = value)),
                          Text("Tripleta"),
                       ],
                      ),
                      // MyCheckBox(small: 2, title: "Pale", value: _ckbLigarPale, onChanged: (value) => setState(() => _ckbLigarPale = value)),
                      // MyCheckBox(small: 2, title: "Tripleta", value: _ckbLigarTripleta, onChanged: (value) => setState(() => _ckbLigarTripleta = value))
                    ],)
                  ],),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: (){Navigator.pop(context);},
                ),
                FlatButton(
                  child: Text("Ligar"),
                  onPressed: () async {
                    if(_selectedLoteriasLigar.length == 0){
                      Utils.showAlertDialog(context: context, title: "Error", content: "Debe seleccionar al menos una loteria");
                      return;
                    }

                    if(!_formLigarKey.currentState.validate())
                      return;

                    Navigator.pop(context);
                    // Map<String, dynamic> map = {"monto" : Utils.toDouble(_txtMontoLigar.text), "pale" : _ckbLigarPale, "tripleta" : _ckbLigarTripleta,};
                    if(_ckbLigarPale){
                      // Navigator.pop(context);
                      await _ligarDirectosEnPale(_selectedLoteriasLigar, Utils.toDouble(_txtMontoLigar.text));
                      
                    }
                    
                    if(_ckbLigarTripleta){
                      // Navigator.pop(context);
                      await _ligarDirectosEnTripleta(_selectedLoteriasLigar, Utils.toDouble(_txtMontoLigar.text));
                    }
                    
                  },
                ),
              ],
            );
          }
        );
      }
    );
  }

  _ligarDirectosEnPale(List<Loteria> loteriasSeleccionadas, double monto) async {
    ValueNotifier cargandoNotifier = ValueNotifier(true);
    List<String> listaJugadasLigadas = [];
    int idLoteria;
    //Buscamos los directos de las jugadas realizadas 
    var listaJugadaDirectos = listaJugadas.where((e) => e.jugada.length == 2).toList();
    
    //Ordenamos los directos de menor a mayor
    listaJugadaDirectos.sort((a, b) => a.jugada.compareTo(b.jugada));

    //Eliminamos las jugadas duplicadas
    listaJugadaDirectos = Utils.removeDuplicateJugadasFromList(listaJugadaDirectos);
    
    //Validamos de que no existan directos para mas loterias
    // if(listaJugadaDirectos.indexWhere((e) => e.idLoteria != listaJugadaDirectos[0].idLoteria) != -1)
    //   return;

    //Vamos a recorrer dos ciclos
    //En el primer ciclo recorremos todos los numeros
    //En el segundo recorremos todos los numeros que sean mayores que el numero del primer ciclo
    for(int i=0; i < listaJugadaDirectos.length; i++){
      if(i==0)
        idLoteria = listaJugadaDirectos[i].idLoteria;
      //Este segundo for empezara siempre con un directo mayor que el directo del primer ciclo por eso i2 = i + 1
      for(int i2 = i + 1; i2 < listaJugadaDirectos.length; i2++){
        listaJugadasLigadas.add(listaJugadaDirectos[i].jugada + listaJugadaDirectos[i2].jugada);
      }
    }

    //Obtenemos el objeto loteria con el idLoteria obtenido en el for de arriba
    // Loteria loteria = listaLoteria.firstWhere((element) => element.id == idLoteria);
    // List<Loteria> lista = List();
    // if(loteria == null)
    //   return;

    //Agregamos la loteria a la lista
    // lista.add(loteria);

    //Agregamos las jugadas ligadas
    // for(int i=0; i < listaJugadasLigadas.length; i++){
    //   await addJugada(jugada: Utils.ordenarMenorAMayor((listaJugadasLigadas[i])), montoDisponible: monto.toString(), monto: monto.toString(), selectedLoterias: loteriasSeleccionadas, cambiarFocusJugadaMonto: false);
    // }
    await TicketService.showDialogJugadasSinMontoDisponible(
      context, 
      () async {
        List<Jugada> listaJugadasSinMontoDisponible = [];
        for(int i=0; i < listaJugadasLigadas.length; i++){
          List<Jugada> listaJugadasSinMontoDisponibleTmp = await addJugada(jugada: Utils.ordenarMenorAMayor((listaJugadasLigadas[i])), montoDisponible: monto.toString(), monto: monto.toString(), selectedLoterias: loteriasSeleccionadas, cambiarFocusJugadaMonto: false);
          if(listaJugadasSinMontoDisponibleTmp.length > 0)
            listaJugadasSinMontoDisponible.addAll(listaJugadasSinMontoDisponibleTmp);
        }

        if(listaJugadasSinMontoDisponible.length == 0)
          Navigator.pop(context);
        else
          cargandoNotifier.value = false;

        return listaJugadasSinMontoDisponible;
      },
      title: ValueListenableBuilder(
        valueListenable: cargandoNotifier, 
        builder: (context, value, __) => value ? Text('Combinando...', softWrap: true) : Text('Error monto', softWrap: true,)
      ),
      okButton: ValueListenableBuilder(
        valueListenable: cargandoNotifier, 
        builder: (context, value, __) => value ? SizedBox.shrink() : TextButton(onPressed: () => Navigator.pop(context), child: Text("Ok", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)))
      ),
    );
    

  }

  _ligarDirectosEnTripleta(List<Loteria> loteriasSeleccionadas, double monto) async {
    ValueNotifier cargandoNotifier = ValueNotifier(true);
    List<String> listaJugadasLigadas = [];
    int idLoteria;
    //Buscamos los directos de las jugadas realizadas 
    var listaJugadaDirectos = listaJugadas.where((e) => e.jugada.length == 2).toList();
    
    //Validar que haya mas de 3 directos
    if(listaJugadaDirectos.length < 3)
      return;

    //Ordenamos los directos de menor a mayor
    listaJugadaDirectos.sort((a, b) => a.jugada.compareTo(b.jugada));

    //Eliminamos las jugadas duplicadas
    listaJugadaDirectos = Utils.removeDuplicateJugadasFromList(listaJugadaDirectos);
    
    // //Validamos de que no existan directos para mas loterias
    // if(listaJugadaDirectos.indexWhere((e) => e.idLoteria != listaJugadaDirectos[0].idLoteria) != -1)
    //   return;

    //Vamos a recorrer dos ciclos
    //En el primer ciclo recorremos todos los numeros
    //En el segundo recorremos todos los numeros que sean mayores que el numero del primer ciclo
    for(int i=0; i < listaJugadaDirectos.length; i++){
      if(i==0)
        idLoteria = listaJugadaDirectos[i].idLoteria;
      //Este segundo for empezara siempre con un directo mayor que el directo del primer ciclo por eso i2 = i + 1
      for(int i2 = i + 1; i2 < listaJugadaDirectos.length; i2++){
        for(int i3 = i2 + 1; i3 < listaJugadaDirectos.length; i3++)
          listaJugadasLigadas.add(listaJugadaDirectos[i].jugada + listaJugadaDirectos[i2].jugada + listaJugadaDirectos[i3].jugada);
      }
    }

    //Obtenemos el objeto loteria con el idLoteria obtenido en el for de arriba
    // Loteria loteria = listaLoteria.firstWhere((element) => element.id == idLoteria);
    // List<Loteria> lista = List();
    // if(loteria == null)
    //   return;

    //Agregamos la loteria a la lista
    // lista.add(loteria);

    //Agregamos las jugadas ligadas
    // for(int i=0; i < listaJugadasLigadas.length; i++){
    //   await addJugada(jugada: Utils.ordenarMenorAMayor((listaJugadasLigadas[i])), montoDisponible: monto.toString(), monto: monto.toString(), selectedLoterias: loteriasSeleccionadas);
    // }

    await TicketService.showDialogJugadasSinMontoDisponible(
      context, 
      () async {
        List<Jugada> listaJugadasSinMontoDisponible = [];
        for(int i=0; i < listaJugadasLigadas.length; i++){
          List<Jugada> listaJugadasSinMontoDisponibleTmp = await addJugada(jugada: Utils.ordenarMenorAMayor((listaJugadasLigadas[i])), montoDisponible: monto.toString(), monto: monto.toString(), selectedLoterias: loteriasSeleccionadas, cambiarFocusJugadaMonto: false);
          if(listaJugadasSinMontoDisponibleTmp.length > 0)
            listaJugadasSinMontoDisponible.addAll(listaJugadasSinMontoDisponibleTmp);
        }

        if(listaJugadasSinMontoDisponible.length == 0)
          Navigator.pop(context);
        else
          cargandoNotifier.value = false;

        return listaJugadasSinMontoDisponible;
      },
      title: ValueListenableBuilder(
        valueListenable: cargandoNotifier, 
        builder: (context, value, __) => value ? Text('Combinando...') : Text('Error monto', softWrap: true,)
      ),
      okButton: ValueListenableBuilder(
        valueListenable: cargandoNotifier, 
        builder: (context, value, __) => value ? SizedBox.shrink() : TextButton(onPressed: () => Navigator.pop(context), child: Text("Ok", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)))
      ),
    );

  }

   ponerPuntoEnMonto(){
     if(_txtMontoPrimerCaracter){
       _txtMonto.text = '.';
       setState(() => _txtMontoPrimerCaracter = false);
     }
    else{
      if(_txtMonto.text.indexOf('.') == -1){
        _txtMonto.text = _txtMonto.text + '.';
      }
    }
  }

  bool _isLargeAndWeb(){
    return Utils.isSmallOrMedium(MediaQuery.of(context).size.width) == false && kIsWeb;
  }

  ponerSignoMas(){
    if((_txtJugada.text.indexOf('+') != -1 && !_isLargeAndWeb()) || (_txtJugada.text.indexOf('+') == -1 && _isLargeAndWeb()))
      return;


    if(_txtJugada.text.length != 3 && _txtJugada.text.length != 4 && !_isLargeAndWeb())
      return;
    

    if(!_isLargeAndWeb())
      _txtJugada.text = _txtJugada.text + '+';
    // setState(() => _jugadaOmonto = !_jugadaOmonto);
    _cambiarFocusJugadaMonto();
    changeMontoDisponibleFromTxtMontoDisponible();
    
  }

  ponerSignoMenos(){
    if((_txtJugada.text.indexOf('-') != -1 && !_isLargeAndWeb()) || (_txtJugada.text.indexOf('-') == -1 && _isLargeAndWeb()))
      return;

    if(_txtJugada.text.length != 4 && !_isLargeAndWeb())
      return;
    
    if(!_isLargeAndWeb())
      _txtJugada.text = _txtJugada.text + '-';
    // setState(() => _jugadaOmonto = !_jugadaOmonto);
    _cambiarFocusJugadaMonto();
    changeMontoDisponibleFromTxtMontoDisponible();
    
  }

  ponerSignoS(){
    if(_txtJugada.text.indexOf('s') != -1 && !_isLargeAndWeb())
      return;

    if(_txtJugada.text.length != 4 && !_isLargeAndWeb())
      return;
    if(_selectedLoterias.length < 2){
      Utils.showAlertDialog(context: context, title: "Error", content: "Debe seleccionar dos o mas loterias para super pale");
      return;
    }
    
    if(!_isLargeAndWeb())
      _txtJugada.text = _txtJugada.text + 's';
    // setState(() => _jugadaOmonto = !_jugadaOmonto);
    _cambiarFocusJugadaMonto();
    changeMontoDisponibleFromTxtMontoDisponible();
    
  }

  ponerPunto() async {
    if(_txtJugada.text.indexOf('.') != -1)
      return;

    if(_txtJugada.text.length != 2 && _txtJugada.text.length != 4 && _txtJugada.text.length != 6)
      return;
    
    // setState(() => _jugadaOmonto = !_jugadaOmonto);
    _cambiarFocusJugadaMonto();
    await changeMontoDisponibleFromTxtMontoDisponible();
    _txtJugada.text = _txtJugada.text + '.';
  }


  addJugada({String jugada, String montoDisponible, String monto, List<Loteria> selectedLoterias, Map<String, dynamic> loteriaMap, Map<String, dynamic> jugadaMap, bool cambiarFocusJugadaMonto = true}) async {
    if(jugada.length < 2)
      return;

    // if(montoDisponible.isEmpty)
    //   return;

    // if((Utils.toDouble(montoDisponible) == 0 || Utils.toDouble(montoDisponible) < 0) || Utils.toDouble(montoDisponible) < Utils.toDouble(monto)){
    //   if(montoDisponible != 'X' && selectedLoterias.length < 2){
    //     // VALIDAMOS OTRA VEZ EL MONTO DISPONIBLE
    //     var montoDisponibleOtraVez = await getMontoDisponible(Utils.ordenarMenorAMayor(_txtJugada.text), _selectedLoterias[0], await _selectedBanca());
    //     if(Utils.toDouble(monto) > montoDisponibleOtraVez){
    //       _showSnackBar('No hay monto suficiente');
    //         return;
    //     }
    //   }
    // }

    List<Jugada> jugadasSinMontoDisponible = [];
    

    if(Utils.toDouble(monto) == 0){
      _showSnackBar('La cantidad a jugar debe ser mayor que cero');
        return;
    }
    
      


    if(loteriaMap == null){
      if(selectedLoterias.length == 0){
        _showSnackBar('Debe seleccionar una loteria');
          return;
      }
    }

    if(loteriaMap != null){
      insertarJugadaDuplicar(loteriaMap, jugadaMap);
    }
    else if(selectedLoterias.length == 1){

      // VALIDAMOS EL MONTO DISPONIBLE
      MontoDisponible montoDisponible;
      // if(!kIsWeb){
        montoDisponible = await getMontoDisponible(Utils.ordenarMenorAMayor(jugada), selectedLoterias[0], await _selectedBanca());
        if(Utils.toDouble(monto) > montoDisponible.monto){
          // _showSnackBar('No hay monto suficiente para la jugada $jugada en la loteria ${selectedLoterias[0].descripcion}');
          jugadasSinMontoDisponible.add(Jugada(jugada: jugada, loteria: selectedLoterias[0], stock: montoDisponible.stock));
          return jugadasSinMontoDisponible;
            // return;
        }
      // }

      await insertarJugada(jugada: jugada, loteria: selectedLoterias[0], monto: monto, stock: montoDisponible.stock);
      _streamControllerJugada.add(listaJugadas);
      _txtJugada.text = '';
      _txtMontoDisponible.text = '';
      
      // setState(() => _jugadaOmonto = true);
    }
    else if(selectedLoterias.length >= 2 && Utils.esSuperpale(jugada)){
     

      var banca = await _selectedBanca();
      //Ordenamos las loterias seleccionadas de menor a mayor basedo en su id
      selectedLoterias.sort((a, b) => a.id.compareTo(b.id));

      // VALIDAMOS DE QUE HAYA MONTO DISPONIBLE
      List<Jugada> listaLoteriasSuperpaleConStock = [];
      for(int i=0; i < selectedLoterias.length; i++){
        for(int i2=i + 1 ; i2 < selectedLoterias.length; i2++){
          MontoDisponible montoDisponible;
          // if(!kIsWeb){
            montoDisponible = await getMontoDisponible(Utils.ordenarMenorAMayor(jugada), selectedLoterias[i], banca, loteriaSuperpale: selectedLoterias[i2]);
            if(Utils.toDouble(monto) > montoDisponible.monto){
              // _showSnackBar('No hay monto suficiente para el super pale $jugada en las loterias ${selectedLoterias[i].descripcion}/${selectedLoterias[i2].descripcion}');
              jugadasSinMontoDisponible.add(Jugada(jugada: jugada, loteria: selectedLoterias[i], loteriaSuperPale: selectedLoterias[i2]));
              continue;
            }
          // }
          listaLoteriasSuperpaleConStock.add(Jugada(stock: montoDisponible.stock, loteria: selectedLoterias[i], loteriaSuperPale: selectedLoterias[i2]));
        }
      }

      // INSERTAMOS LOS SUPER PALE
      for(int i=0; i < selectedLoterias.length; i++){
        for(int i2=i + 1 ; i2 < selectedLoterias.length; i2++){
          Jugada jugadaConStock = listaLoteriasSuperpaleConStock.firstWhere((element) => element.loteria.id == selectedLoterias[i].id && element.loteriaSuperPale.id == selectedLoterias[i2].id, orElse: () => null);
          if(jugadaConStock != null)
            await insertarJugadaSuperpale(jugada: jugada, loteria: selectedLoterias[i], loteriaSuperpale: selectedLoterias[i2], monto: monto, stock: jugadaConStock.stock);
        }
      }
      _streamControllerJugada.add(listaJugadas);
      _txtJugada.text = '';
      _txtMontoDisponible.text = '';
    }
    else{

      // OBTENEMOS LA BANCA
      var banca = await _selectedBanca();

      // VALIDAMOS LOS MONTOS DISPONIBLES
      List<Jugada> listaLoteriaConStock = [];
      for (var l in selectedLoterias) {
        MontoDisponible montoDisponible;
        // if(!kIsWeb){
          montoDisponible = await getMontoDisponible(Utils.ordenarMenorAMayor(jugada), l, banca);
          if(Utils.toDouble(monto) > montoDisponible.monto){
            // _showSnackBar('No hay monto suficiente para la jugada $jugada en la loteria ${l.descripcion}');
            jugadasSinMontoDisponible.add(Jugada(jugada: jugada, loteria: l));
            continue;
          }
        // }
        listaLoteriaConStock.add(Jugada(stock: montoDisponible.stock, loteria: l));
      }

      // INSERTAMOS LAS LOTERIAS
      for (var l in selectedLoterias) {
        Jugada loteriaConStock = listaLoteriaConStock.firstWhere((element) => element.loteria.id == l.id, orElse: () => null);
        if(loteriaConStock != null)
          await insertarJugada(jugada: jugada, loteria: l, monto: monto, stock: loteriaConStock.stock);
      }

      _streamControllerJugada.add(listaJugadas);
      _txtJugada.text = '';
      _txtMontoDisponible.text = '';

    }

          
    // setState(() => _jugadaOmonto = !_jugadaOmonto);
    if(cambiarFocusJugadaMonto)
      _cambiarFocusJugadaMonto();


    return jugadasSinMontoDisponible;

  }


  hayJugadasSuciasNuevo() async {
    Banca banca = await _selectedBanca();
    

    for(int i=0; i < listaEstadisticaJugada.length; i++){
      // var query = await  Db.database.query('Blocksdirty' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idMoneda" = ?', whereArgs: [banca.id, listaEstadisticaJugada[i].idLoteria, listaEstadisticaJugada[i].idSorteo, banca.idMoneda], orderBy: '"id" desc' );
      // if(query.isEmpty)
      //   query = await  Db.database.query('Blocksdirtygenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idMoneda" = ?', whereArgs: [listaEstadisticaJugada[i].idLoteria, listaEstadisticaJugada[i].idSorteo, banca.idMoneda], orderBy: '"id" desc' );
      int cantidad = await Db.getBlocksdirtyCantidad(idBanca: banca.id, idLoteria: listaEstadisticaJugada[i].idLoteria, idSorteo: listaEstadisticaJugada[i].idSorteo, idMoneda: banca.idMoneda);
      if(cantidad == null)
        cantidad = await Db.getBlocksdirtygeneralCantidad(idLoteria: listaEstadisticaJugada[i].idLoteria, idSorteo: listaEstadisticaJugada[i].idSorteo, idMoneda: banca.idMoneda);
        
      // if(query.isNotEmpty){
      //   if(listaEstadisticaJugada[i].cantidad > query.first["cantidad"]){
      //     Utils.showAlertDialog(context: context, title: "Jugadas sucias", content: "Hay jugadas sucias en la loteria ${listaEstadisticaJugada[i].descripcion}, comuniquese con el administrador o esta banca sera monitoreada y si se encuentran jugadas sucias pues se tomaran medidas severas contra usted.");
      //     return true;
      //   }
      // }
      if(cantidad != null){
        if(listaEstadisticaJugada[i].cantidad > cantidad){
          Utils.showAlertDialog(context: context, title: "Jugadas sucias", content: "Hay jugadas sucias en la loteria ${listaEstadisticaJugada[i].descripcion}, comuniquese con el administrador o esta banca sera monitoreada y si se encuentran jugadas sucias pues se tomaran medidas severas contra usted.");
          return true;
        }
      }
    }
    
    return false;
  }

  hayJugadasSucias({String jugada, Loteria loteria, Loteria loteriaSuperpale}) async {
    Banca banca = await _selectedBanca();
    Draws sorteo = await SorteoService.getSorteo(jugada) ;
    if(sorteo == null)
      return;

    // var query = await  Db.database.query('Blocksdirty' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, sorteo.id, banca.idMoneda], orderBy: '"id" desc' );
    // if(query.isEmpty)
    //   query = await  Db.database.query('Blocksdirtygenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idMoneda" = ?', whereArgs: [loteria.id, sorteo.id, banca.idMoneda], orderBy: '"id" desc' );
    
    int cantidad = await Db.getBlocksdirtyCantidad(idBanca: banca.id, idLoteria: loteria.id, idSorteo: sorteo.id, idMoneda: banca.idMoneda);
    if(cantidad == null)
      cantidad = await Db.getBlocksdirtygeneralCantidad(idLoteria: loteria.id, idSorteo: sorteo.id, idMoneda: banca.idMoneda);

    if(cantidad == null)
      return false;

    if(sorteo.descripcion == "Directo"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 2 && e.idLoteria == loteria.id).length;
      // if(tamanoJugadas >= query.first["cantidad"])
      //   return true;
      if(tamanoJugadas >= cantidad)
        return true;

    }
    if(sorteo.descripcion == "Pale"){
      int tamanoJugadas = listaJugadas.where((e) => Utils.toInt(e.jugada) != 0 && e.idLoteria == loteria.id).length;
      if(tamanoJugadas >= cantidad)
        return true;
    }
    if(sorteo.descripcion == "Tripleta"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 6 && e.idLoteria == loteria.id).length;
      if(tamanoJugadas >= cantidad)
        return true;
    }
    if(sorteo.descripcion == "Pick 3 Straight"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 3 && e.idLoteria == loteria.id).length;
      if(tamanoJugadas >= cantidad)
        return true;
    }
    if(sorteo.descripcion == "Pick 3 Box"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 4 && e.jugada.indexOf("+") != -1 && e.idLoteria == loteria.id).length;
      if(tamanoJugadas >= cantidad)
        return true;
    }
    if(sorteo.descripcion == "Pick 4 Box"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 5 && e.jugada.indexOf("+") != -1 && e.idLoteria == loteria.id).length;
      if(tamanoJugadas >= cantidad)
        return true;
    }
    if(sorteo.descripcion == "Pick 4 Straight"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 5 && e.jugada.indexOf("-") != -1 && e.idLoteria == loteria.id).length;
      if(tamanoJugadas >= cantidad)
        return true;
    }
    if(sorteo.descripcion == "Super pale"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 5 && e.jugada.indexOf("s") != -1 && e.idLoteria == loteria.id && e.idLoteriaSuperpale == loteriaSuperpale.id).length;
      if(tamanoJugadas >= cantidad)
        return true;
    }

    return false;
  }

  insertarJugada({String jugada, Loteria loteria, String monto, Stock stock}) async {

    
    
    int idx = (listaJugadas.isEmpty == false) ? listaJugadas.indexWhere((j) => j.jugada == jugada && j.idLoteria == loteria.id) : -1;
      if(idx != -1){
        print("PrincipalView insertarJugada entroooooooooooooo");
        await showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Jugada existe'),
              content: Text('La jugada ${jugada} existe en la loteria ${loteria.descripcion} desea agregar?'),
              actions: <Widget>[
                FlatButton(child: Text("Cancelar"), onPressed: (){
                Navigator.of(context).pop();
                },),
                FlatButton(child: Text("Agregar"), onPressed: (){
                    Navigator.of(context).pop();
                    listaJugadas[idx].monto += Utils.toDouble(monto);
                    listaJugadas[idx].stock = stock;
                    _streamControllerJugada.add(listaJugadas);
                    _txtJugada.text = '';
                    _txtMontoDisponible.text = '';
                  // });
                  },
                )
              ],
            );
          }
        );
      }else{
        Draws _sorteo = await SorteoService.getSorteo(jugada);
        listaJugadas.insert(0, Jugada(
          jugada: jugada,
          idLoteria: loteria.id,
          monto: Utils.redondear(Utils.toDouble(monto), 2),
          descripcion: loteria.descripcion,
          loteria: loteria,
          idBanca: 0,
          idSorteo: _sorteo.id,
          sorteo: _sorteo.descripcion,
          stock: stock
        ));
        await addOrUpdateEstadisticaJugada(jugada: jugada, loteria: loteria, sorteo: _sorteo);
      }
  }

  insertarJugadaSuperpale({String jugada, Loteria loteria, Loteria loteriaSuperpale, String monto, Stock stock}) async {
     
      if(loteria.id > loteriaSuperpale.id){
        Loteria tmp = loteriaSuperpale;
        loteriaSuperpale = loteria;
        loteria = tmp;
      }

      int idx = (listaJugadas.isEmpty == false) ? listaJugadas.indexWhere((j) => j.jugada == jugada && j.idLoteria == loteria.id && j.idLoteriaSuperpale == loteriaSuperpale.id) : -1;
      if(idx != -1){
        await showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Jugada existe'),
              content: Text('La jugada ${jugada} existe en la loteria Super pale(${loteria.descripcion}/${loteriaSuperpale.descripcion}) desea agregar?'),
              actions: <Widget>[
                FlatButton(child: Text("Cancelar"), onPressed: (){
                Navigator.of(context).pop();
                },),
                FlatButton(child: Text("Agregar"), onPressed: (){
                    Navigator.of(context).pop();
                    listaJugadas[idx].monto += Utils.toDouble(monto);
                    listaJugadas[idx].stock = stock;
                    _streamControllerJugada.add(listaJugadas);
                    _txtJugada.text = '';
                    _txtMontoDisponible.text = '';
                  // });
                  },
                )
              ],
            );
          }
        );
      }else{
        Draws _sorteo = await SorteoService.getSorteo(jugada);
        listaJugadas.insert(0, Jugada(
          jugada: jugada,
          idLoteria: loteria.id,
          idLoteriaSuperpale: loteriaSuperpale.id,
          monto: Utils.redondear(Utils.toDouble(monto), 2),
          descripcion: loteria.descripcion,
          descripcionSuperpale: loteriaSuperpale.descripcion,
          abreviatura: loteria.abreviatura,
          abreviaturaSuperpale: loteriaSuperpale.abreviatura,
          loteria: loteria,
          loteriaSuperPale: loteriaSuperpale,
          idBanca: 0,
          idSorteo: _sorteo.id,
          sorteo: _sorteo.descripcion,
          stock: stock
        ));

        await addOrUpdateEstadisticaJugada(jugada: jugada, loteria: loteria, sorteo: _sorteo);
      }
  }

  insertarJugadaDuplicar(Map<String, dynamic> loteriaMap, Map<String, dynamic> jugada) async {
    if(jugada["idSorteo"] != 4){
      // double montoDisponibleOtraVez = await getMontoDisponible(Utils.ordenarMenorAMayor(jugada["jugada"]), Loteria.fromMap(loteriaMap), await _selectedBanca());
      MontoDisponible montoDisponible;

      // if(!kIsWeb){
        montoDisponible = await getMontoDisponible(Utils.ordenarMenorAMayor(jugada["jugada"]), Loteria.fromMap(loteriaMap), await _selectedBanca());
        double montoDisponibleOtraVez = montoDisponible.monto;
        if(Utils.toDouble(jugada["monto"]) > montoDisponibleOtraVez){
          _showSnackBar('No hay monto suficiente para la jugada ${jugada["jugada"]} en la loteria ${Loteria.fromMap(loteriaMap).descripcion}');
            return;
        }
      // }


      int idx = (listaJugadas.isEmpty == false) ? listaJugadas.indexWhere((j) => j.jugada == jugada["jugada"] && j.idLoteria == loteriaMap["id"]) : -1;
      if(idx != -1){
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Jugada existe'),
              content: Text('La jugada ${jugada["jugada"]} existe en la loteria ${loteriaMap["descripcion"]} desea agregar?'),
              actions: <Widget>[
                FlatButton(child: Text("Cancelar"), onPressed: (){
                Navigator.of(context).pop();
                },),
                FlatButton(child: Text("Agregar"), onPressed: (){
                    Navigator.of(context).pop();
                    listaJugadas[idx].monto += Utils.toDouble(jugada["monto"]);
                    listaJugadas[idx].stock = montoDisponible.stock;
                    _streamControllerJugada.add(listaJugadas);
                    _txtJugada.text = '';
                    _txtMontoDisponible.text = '';
                  // });
                  },
                )
              ],
            );
          }
        );
      }else{

        Draws _sorteo = await SorteoService.getSorteo(jugada["jugada"]);
        listaJugadas.add(Jugada(
          jugada: jugada["jugada"],
          idLoteria: loteriaMap["id"],
          loteria: Loteria.fromMap(loteriaMap),
          monto: Utils.redondear(Utils.toDouble(jugada["monto"]), 2),
          descripcion: loteriaMap["descripcion"],
          idBanca: 0,
          idSorteo: _sorteo.id,
          sorteo: _sorteo.descripcion,
          stock: montoDisponible.stock
        ));
        await addOrUpdateEstadisticaJugada(jugada: jugada["jugada"], loteria: Loteria.fromMap(loteriaMap), sorteo: _sorteo);
        _streamControllerJugada.add(listaJugadas);

        _txtJugada.text = '';
        _txtMontoDisponible.text = '';
      }
    }
    else{
       Loteria loteria = Loteria.fromMap(loteriaMap);
      Loteria loteriaSuperpale = Loteria.fromMap(jugada["loteriaSuperpale"]);
      if(loteria.id > loteriaSuperpale.id){
        Loteria tmp = loteriaSuperpale;
        loteriaSuperpale = loteria;
        loteria = tmp;
      }

      MontoDisponible montoDisponible = await getMontoDisponible(Utils.ordenarMenorAMayor(jugada["jugada"]), loteria, await _selectedBanca(), loteriaSuperpale: loteriaSuperpale);
      double montoDisponibleOtraVez = montoDisponible.monto;
      if(Utils.toDouble(jugada["monto"]) > montoDisponibleOtraVez){
        _showSnackBar('No hay monto suficiente para el super pale ${jugada["jugada"]} en las loterias ${loteria.descripcion}/${loteriaSuperpale.descripcion}');
          return;
      }


      int idx = (listaJugadas.isEmpty == false) ? listaJugadas.indexWhere((j) => j.jugada == jugada["jugada"] && j.idLoteria == loteria.id && j.idLoteriaSuperpale == loteriaSuperpale.id) : -1;
      if(idx != -1){
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Jugada existe'),
              content: Text('La jugada ${jugada["jugada"]} existe en la loteria Super pale(${loteria.descripcion}/${loteriaSuperpale.descripcion}) desea agregar?'),
              actions: <Widget>[
                FlatButton(child: Text("Cancelar"), onPressed: (){
                Navigator.of(context).pop();
                },),
                FlatButton(child: Text("Agregar"), onPressed: (){
                    Navigator.of(context).pop();
                    listaJugadas[idx].monto += Utils.toDouble(jugada["monto"]);
                    listaJugadas[idx].stock = montoDisponible.stock;
                    _streamControllerJugada.add(listaJugadas);
                    _txtJugada.text = '';
                    _txtMontoDisponible.text = '';
                  // });
                  },
                )
              ],
            );
          }
        );
      }else{
        Draws _sorteo = await SorteoService.getSorteo(jugada["jugada"]);
        var j = Jugada(
          jugada: jugada["jugada"],
          idLoteria: loteria.id,
          idLoteriaSuperpale: loteriaSuperpale.id,
          monto: Utils.redondear(Utils.toDouble(jugada["monto"]), 2),
          descripcion: loteria.descripcion,
          descripcionSuperpale: loteriaSuperpale.descripcion,
          abreviatura: loteria.abreviatura,
          abreviaturaSuperpale: loteriaSuperpale.abreviatura,
          loteria: loteria,
          loteriaSuperPale: loteriaSuperpale,
          idBanca: 0,
          idSorteo: _sorteo.id,
          sorteo: _sorteo.descripcion,
          stock: montoDisponible.stock
        );
        await addOrUpdateEstadisticaJugada(jugada: jugada["jugada"], loteria: loteria, sorteo: _sorteo);
        listaJugadas.add(j);
        _streamControllerJugada.add(listaJugadas);

        _txtJugada.text = '';
        _txtMontoDisponible.text = '';
      }
    }
      
  }

  addOrUpdateEstadisticaJugada({String jugada, Loteria loteria, Draws sorteo}) async {
    int idxEstadistica = listaEstadisticaJugada.indexWhere((element) => element.idLoteria == loteria.id && element.idSorteo == sorteo.id);
    if(idxEstadistica != -1){
      listaEstadisticaJugada[idxEstadistica].cantidad++;
    }else{
      listaEstadisticaJugada.add(
        EstadisticaJugada(
          idLoteria: loteria.id,
          descripcion: loteria.descripcion,
          descripcionSorteo: sorteo.descripcion,
          idSorteo: sorteo.id,
          cantidad: 1
        )
      );
    }
  }
  removeEstadisticaJugada({String jugada, int idLoteria}) async {
    Draws sorteo = await SorteoService.getSorteo(jugada);
    int idxEstadistica = listaEstadisticaJugada.indexWhere((element) => element.idLoteria == idLoteria && element.idSorteo == sorteo.id);
    if(idxEstadistica != -1){
      listaEstadisticaJugada[idxEstadistica].cantidad--;
      if(listaEstadisticaJugada[idxEstadistica].cantidad <= 0)
        listaEstadisticaJugada.removeAt(idxEstadistica);
    }
  }

  addJugadaViejo(){
    if(_txtJugada.text.length < 2)
      return;

    if(_txtMontoDisponible.text.isEmpty)
      return;

    if((Utils.toDouble(_txtMontoDisponible.text) == 0 || Utils.toDouble(_txtMontoDisponible.text) < 0) || Utils.toDouble(_txtMontoDisponible.text) < Utils.toDouble(_txtMonto.text)){
      if(_txtMontoDisponible.text != 'X' && _selectedLoterias.length < 2){
        if(Utils.toDouble(_txtMonto.text) > Utils.toDouble(_txtMontoDisponible.text)){
          _showSnackBar('No hay monto suficiente');
            return;
        }
      }
    }

    if(Utils.toDouble(_txtMonto.text) == 0){
      _showSnackBar('La cantidad a jugar debe ser mayor que cero');
        return;
    }
    

    if(_selectedLoterias.length == 0){
      _showSnackBar('Debe seleccionar una loteria');
        return;
    }

    if(_selectedLoterias.length == 1){
      int idx = (listaJugadas.isEmpty == false) ? listaJugadas.indexWhere((j) => j.jugada == _txtJugada.text && j.idLoteria == _selectedLoterias[0].id) : -1;
      if(idx != -1){
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Jugada existe'),
              content: Text('La jugada ${_txtJugada.text} existe en la loteria ${_selectedLoterias[0].descripcion} desea agregar?'),
              actions: <Widget>[
                FlatButton(child: Text("Cancelar"), onPressed: (){
                Navigator.of(context).pop();
                },),
                FlatButton(child: Text("Agregar"), onPressed: (){
                    Navigator.of(context).pop();
                    listaJugadas[idx].monto += Utils.toDouble(_txtMonto.text);
                    _streamControllerJugada.add(listaJugadas);
                    _txtJugada.text = '';
                    _txtMontoDisponible.text = '';
                  // });
                  },
                )
              ],
            );
          }
        );
      }else{
        listaJugadas.add(Jugada(
          jugada: _txtJugada.text,
          idLoteria: _selectedLoterias[0].id,
          monto: Utils.redondear(Utils.toDouble(_txtMonto.text), 2),
          descripcion: _selectedLoterias[0].descripcion,
          idBanca: 11
        ));
        _streamControllerJugada.add(listaJugadas);

        _txtJugada.text = '';
        _txtMontoDisponible.text = '';
      }

      
      // setState(() => _jugadaOmonto = true);
    }
    else{
      _selectedLoterias.forEach((l){
        int idx = (listaJugadas.isEmpty == false) ? listaJugadas.indexWhere((j) => j.jugada == _txtJugada.text && j.idLoteria == l.id) : -1;
        if(idx != -1){
          showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text('Jugada existe'),
                content: Text('La jugada ${_txtJugada.text} existe en la loteria ${l.descripcion} desea agregar?'),
                actions: <Widget>[
                  FlatButton(child: Text("Cancelar"), onPressed: (){
                  Navigator.of(context).pop();
                  },),
                  FlatButton(child: Text("Agregar"), onPressed: (){
                      Navigator.of(context).pop();
                      listaJugadas[idx].monto += Utils.redondear(Utils.toDouble(_txtMonto.text), 2);
                    // });
                    },
                  )
                ],
              );
            }
          );
        }
        else{
          listaJugadas.add(Jugada(
            jugada: _txtJugada.text,
            idLoteria: l.id,
            monto: Utils.redondear(Utils.toDouble(_txtMonto.text), 2),
            descripcion: l.descripcion,
            idBanca: 11
          ));
        }
        
      });

      _streamControllerJugada.add(listaJugadas);
      _txtJugada.text = '';
      _txtMontoDisponible.text = '';

    }

          
    // setState(() => _jugadaOmonto = !_jugadaOmonto);
    _cambiarFocusJugadaMonto();

  }

  _showSnackBar(String content){
    Utils.showAlertDialog(context: context, content: content, title: "Error");
    // _scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text(content),
    //     action: SnackBarAction(label: 'CERRAR', onPressed: () => _scaffoldKey.currentState.hideCurrentSnackBar(),),
    //   ));
  }

  _seleccionarPrimeraLoteria({bool quitarSoloLoteriasCerradas = false}){
    if(listaLoteria == null)
      return;

    if(listaLoteria.length == 0)
      return;

    if(_selectedLoterias != null){
      if(_selectedLoterias.length > 0){
        if(quitarSoloLoteriasCerradas){
          List<Loteria> listaLoteriaToRemove = [];
          for (var loteria in _selectedLoterias) {
            var idx = listaLoteria.indexWhere((element) => element.id == loteria.id);
            if(idx == -1){
              // _selectedLoterias.removeWhere((element) => element.id == loteria.id);
              var loteriaToRemove = _selectedLoterias.firstWhere((element) => element.id == loteria.id, orElse: () => null);
              if(loteriaToRemove!= null)
                listaLoteriaToRemove.add(loteriaToRemove);
            }else{
              var indexSelectedLoteria = _selectedLoterias.indexWhere((element) => element.id == loteria.id);
              if(indexSelectedLoteria != -1)
                _selectedLoterias[indexSelectedLoteria] = listaLoteria[idx];
            }
          }

          for (var loteria in listaLoteriaToRemove) {
            _selectedLoterias.removeWhere((element) => element.id == loteria.id);
          }

          if(_selectedLoterias.length == 0)
            _selectedLoterias.add(listaLoteria[0]);

          return;
        }
      }
    }
    _selectedLoterias = [];
    // final selectedValuesMap = listaLoteria.asMap();
    _selectedLoterias.add(listaLoteria[0]);
  }

  _seleccionarSiguienteLoteria(){
    if(listaLoteria == null)
      return;

    if(listaLoteria.length == 0)
      return;

    //Validamos que solo haya una loteria seleccionada
    if(_selectedLoterias.length > 1)
      return;

    //Si no hay ninguna loteria seleccionada pues seleccionamos la primera
    if(_selectedLoterias.length == 0){
      setState(() => _seleccionarPrimeraLoteria());
      return;
    }
      
    int idx = listaLoteria.indexWhere((element) => element.id == _selectedLoterias[0].id);
    if(idx != -1){
      //Si es la ultima loteria pues entonces seleccionamos la primera
      if(listaLoteria.length == idx + 1){
        _seleccionarPrimeraLoteria();
        return;
      }

      setState(() {
        _selectedLoterias = [];
      // final selectedValuesMap = listaLoteria.asMap();
      _selectedLoterias.add(listaLoteria[idx + 1]);
      });

    }
  }

_seleccionarBancaPertenecienteAUsuario() async {
  var bancaMap = await Db.getBanca();
  Banca banca = (bancaMap != null) ? Banca.fromMap(bancaMap) : null;
  // print("_seleccionarBancaPertenecienteAUsuario bancaMap: ${bancaMap}");
  if(banca != null){
    int idx = listaBanca.indexWhere((b) => b.id == banca.id);
    setState(() {
      _indexBanca = (idx != -1) ? idx : 0;
      _emitToGetNewIdTicket();
      _emitToGetVentasDelDia();
    });
  }else{
    setState(() {
      _indexBanca = 0;
      _emitToGetNewIdTicket();
      _emitToGetVentasDelDia();
    });
  }

  // print('seleccionarBancaPerteneciente: $_indexBanca : ${banca.descripcion} : ${listaBanca.length}');
}

_selectedBanca() async {
  Usuario usuario = Usuario.fromMap(await Db.getUsuario());

  if(await Db.existePermiso("Jugar como cualquier banca")){
    return listaBanca[_indexBanca];
  }else{
    return Banca.fromMap(await Db.getBanca());
  }
}

  Widget _buildTable(List<Jugada> jugadas){
   var tam = jugadas.length;
   List<TableRow> rows;
   if(tam == 0){
     rows = <TableRow>[
          
        ];
   }else{
     rows = jugadas.map((j)
          => TableRow(
            children: [
              Center(child: Text(Utils.esSuperpale(j.jugada) ? "SP(${j.abreviatura}/${j.abreviaturaSuperpale})" : j.descripcion, style: TextStyle(fontSize: Utils.esSuperpale(j.jugada) ? 14 : 16))),
              Center(child: Principal.buildRichOrTextAndConvertJugadaToLegible(j.jugada)),
              Center(child: Text(j.monto.toString(), style: TextStyle(fontSize: 16))),
              Center(child: IconButton(icon: Icon(Icons.delete, size: 28,), onPressed: () async {
                setState((){
                  listaJugadas.remove(j);
                  _streamControllerJugada.add(listaJugadas);
                  // await removeEstadisticaJugada(jugada: j.jugada, idLoteria: j.idLoteria);
                });
                  await removeEstadisticaJugada(jugada: j.jugada, idLoteria: j.idLoteria);
              },)),
            ],
          )
        
        ).toList();
        
    rows.insert(0, 
              TableRow(
                children: [
                  // buildContainer(Colors.blue, 50.0),
                  // buildContainer(Colors.red, 50.0),
                  // buildContainer(Colors.blue, 50.0),
                  Center(child: Text('Loteria', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                  Center(child: Text('Jugada', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),
                  Center(child: Text('Monto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),
                  Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),
                ]
              )
              );
        
   }

  return Flexible(
      child: ListView(
      children: <Widget>[
        Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: <int, TableColumnWidth>{0 : FractionColumnWidth(.35)},
            children: rows,
           ),
      ],
    ),
  );
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: 
     SingleChildScrollView(
       scrollDirection: Axis.vertical,
       child: Container(
         child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: <int, TableColumnWidth>{0 : FractionColumnWidth(.35)},
          children: rows,
         ),
       ),
     )
  //    DataTable(
  //      columnSpacing: 4,
  //      onSelectAll: null,
       
  //     columns: [
  //       DataColumn(label: Text('Loteria', style: TextStyle( fontWeight: FontWeight.bold),)),
  //       DataColumn(
  //         label: Text('Jugada', style: TextStyle( fontWeight: FontWeight.bold)), 
  //       ),
  //       DataColumn(
  //         label: Text('Monto', style: TextStyle( fontWeight: FontWeight.bold)), 
  //         // numeric: true
          
  //       ),
  //       DataColumn(
  //         label: Text('Eliminar', style: TextStyle( fontWeight: FontWeight.bold)), 
  //       ),
  //     ],
  //     rows: rows,
  // ),
   );
 }

 
 _calcularTotal(){
   double total = 0;
   listaJugadas.forEach((j){
     total += j.monto;
   });

   return Utils.redondear(total, 2);
 }

 Future<int> _calcularDescuento() async {
   if(_ckbDescuento == false)
    return 0;
   Banca banca = await getBanca();
   double descuentoTmp = (_calcularTotal() / banca.deCada);
   int descuento = descuentoTmp.toInt() * banca.descontar.toInt();
   return descuento;
 }

 changeMontoDisponibleFromTxtMontoDisponible() async {
   if(_txtJugada.text.isEmpty){
     _txtMontoDisponible.text = "0";
     return;
   }

   double montoDisponible = 0;
   if(_selectedLoterias.length == 1){
     montoDisponible = (await getMontoDisponible(Utils.ordenarMenorAMayor(_txtJugada.text), _selectedLoterias[0], await _selectedBanca())).monto;
     setState(() {
      _txtMontoDisponible.text =  montoDisponible.toString();
     });
   }else if(_selectedLoterias.length > 1){
     if(_selectedLoterias.length == 2 && _txtJugada.text.toString().substring(_txtJugada.text.length - 1) == "s"){
       montoDisponible = (await getMontoDisponible(Utils.ordenarMenorAMayor(_txtJugada.text), _selectedLoterias[0], await _selectedBanca(), loteriaSuperpale: _selectedLoterias[1])).monto;
        setState(() {
          _txtMontoDisponible.text =  montoDisponible.toString();
        });
     }else{
        setState(() {
        _txtMontoDisponible.text = "X";
      });
     }
     
   }else{
     _showSnackBar("Debe seleccionar una loteria");
   }
 }
 

 Future<MontoDisponible> getMontoDisponible(String jugada, Loteria loteria, Banca banca, {Loteria loteriaSuperpale, bool retornarStock = false}) async {
    
    // var montoDisponible;

    // if(kIsWeb){
    //   try {
    //     _txtMontoDisponible.text = "0";
    //     var data = await TicketService.montoDisponible(context: context, jugada: jugada, idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale != null ? loteriaSuperpale.id : 0);
    //     print("PrincipalView getMontoDisponible: $data");
    //     return MontoDisponible(monto: Utils.toDouble(data["monto"]));
    //   } on Exception catch (e) {
    //     // TODO
    //     print("PrincipalView getMontoDisponible error: ${e.toString()}");
    //     return MontoDisponible(monto: 0);

    //   }
    // }
    
    if(socket == null){
      Utils.showAlertDialog(context: context, content: "No hay conexion, verifique por favor", title: "Error");
      return MontoDisponible(monto: 0);
    }
    if(!socket.connected){
      Utils.showAlertDialog(context: context, content: "No hay conexion, verifique por favor", title: "Error");
      return MontoDisponible(monto: 0);
    }

    

    int idDia = getIdDia();
    int idSorteo = await SorteoService.getIdSorteo(jugada, loteria);
    String jugadaConSigno = jugada;

    MontoDisponible montoDisponible = await Db.getMontoDisponible(jugada, loteria, banca, loteriaSuperpale: loteriaSuperpale, retornarStock: retornarStock);

  
    int idx = -1;
    if(idSorteo == 4)
      idx = listaJugadas.indexWhere((j) => j.idLoteria == loteria.id && j.idLoteriaSuperpale == loteriaSuperpale.id && j.jugada == jugadaConSigno);
    else
      idx = listaJugadas.indexWhere((j) => j.idLoteria == loteria.id && j.jugada == jugadaConSigno);
      // _selectedLoterias[0].id
    // double montoDisponibleFinal = montoDisponible.toDouble();
    
    double montoDisponibleFinal = Utils.toDouble(montoDisponible.monto.toString());
    if(idx != -1){
      montoDisponibleFinal = montoDisponibleFinal - listaJugadas[idx].monto;
    }

    // if(stockToReturn != null)
    //   stockToReturn.monto = montoDisponibleFinal;
    // else
    //   stockToReturn = Stock(monto: montoDisponibleFinal);

    montoDisponible.monto = montoDisponibleFinal;

    // return MontoDisponible(monto: montoDisponibleFinal, stock: stockToReturn);
    return montoDisponible;

 }

//  Future<MontoDisponible> getMontoDisponibleSQFlite(String jugada, Loteria loteria, Banca banca, {Loteria loteriaSuperpale, bool retornarStock = false}) async {
    
//     var montoDisponible;

//     if(kIsWeb){
//       try {
//         _txtMontoDisponible.text = "0";
//         var data = await TicketService.montoDisponible(context: context, jugada: jugada, idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale != null ? loteriaSuperpale.id : 0);
//         print("PrincipalView getMontoDisponible: $data");
//         return MontoDisponible(monto: Utils.toDouble(data["monto"]));
//       } on Exception catch (e) {
//         // TODO
//         print("PrincipalView getMontoDisponible error: ${e.toString()}");
//         return MontoDisponible(monto: 0);

//       }
//     }
    
//     if(socket == null){
//       Utils.showAlertDialog(context: context, content: "No hay conexion, verifique por favor", title: "Error");
//       return MontoDisponible(monto: 0);
//     }
//     if(!socket.connected){
//       Utils.showAlertDialog(context: context, content: "No hay conexion, verifique por favor", title: "Error");
//       return MontoDisponible(monto: 0);
//     }

    

//     int idDia = getIdDia();
//     int idSorteo = await getIdSorteo(jugada, loteria);
//     String jugadaConSigno = jugada;
//     jugada = await esSorteoPickQuitarUltimoCaracter(jugada, idSorteo);
//     print("PrincipalView getMontoDisponible banca moneda: ${banca.descripcion}");
//     Stock stockToReturn;

//     if(idSorteo != 4){
//       List<Map<String, dynamic>> query = await Db.database.query('Stocks' , where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, 0, banca.idMoneda]);

//       if(query.isEmpty != true){
//         montoDisponible = query.first['monto'];
//         stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: query.first['esBloqueoJugada']);
//       } 
      
//       if(montoDisponible != null){
//         query = await Db.database.query('Stocks' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "ignorarDemasBloqueos" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, 1, 1, banca.idMoneda]);
//         if(query.isEmpty != true){
//           montoDisponible = query.first['monto'];
//           stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: query.first['esBloqueoJugada']);
//         }else{
          
//           //Ahora nos aseguramos de que el bloqueo general existe y el valor de ignorarDemasBloqueos sea = 1
//           query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
//           if(query.isEmpty != true){
//             var first = query.first;
//             if(first["ignorarDemasBloqueos"] == 1){
//               montoDisponible = first["monto"];
//               stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
//             }
//           }
//         }
//       }


//       //AQUI ES CUANDO EXISTE BLOQUEO GENERAL EN STOCKS
//       if(montoDisponible == null){
//           query = await Db.database.query('Stocks' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda]);
//         if(query.isEmpty != true){
//           //SI IGNORARDEMASBLOQUEOS ES FALSE ENTONCES VAMOS A VERIFICAR SI EXISTEN BLOQUEOS POR BANCAS YA SEAN DE JUGADAS PARA RETORNAR ESTOS BLOQUEOS
//           var stock = query.first;
//           if(stock["ignorarDemasBloqueos"] == 0){
//             query = await Db.database.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
//             if(query.isEmpty != true){
//               montoDisponible = query.first["monto"];
//               stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);
//             }else{
//               query = await Db.database.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
//               if(query.isEmpty != true){
//                 montoDisponible = query.first["monto"];
//                 stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'],);
//               }
//               else{
//                 montoDisponible = stock["monto"];
//                 stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
//               }
//             }
//           }else{
//             montoDisponible = stock["monto"];
//             stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
//           }
//         }
//       }

      

//       if(montoDisponible == null){
//         query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
//         if(query.isEmpty != true){
//           var blocksplaysgenerals = query.first;
//           if(blocksplaysgenerals["ignorarDemasBloqueos"] == 0){
//             montoDisponible = null;
//           }else{
//             montoDisponible = blocksplaysgenerals["monto"];
//             stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
//           }
//         }

// // query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ?', whereArgs: [1], orderBy: '"id" desc' );
//         // print("Monto disponible blocksplaysgenrals: $query");

//         if(montoDisponible == null){
//           query = await Db.database.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
//           if(query.isEmpty != true){
//             montoDisponible = query.first["monto"];
//             stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);
//           }else{
//             query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
//             if(query.isEmpty != true){
//               montoDisponible = query.first["monto"];
//               stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
//             }
//           }

//           if(montoDisponible == null){
//             query = await Db.database.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
//             if(query.isEmpty != true){
//               montoDisponible = query.first["monto"];
//               stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral']);
//             }
//           }

//           if(montoDisponible == null){
//             query = await Db.database.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda]);
//             if(query.isEmpty != true){
//               montoDisponible = query.first["monto"];
//               stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda);
//             }
//           }

//           // print('montoDisponiblePrueba idSorteo: lot: $loteria.id sor: $idSorteo dia: $idDia res:${blocksgenerals.indexWhere((b) => b.idLoteria == loteria.id && b.idDia == idDia && b.idSorteo == idSorteo)} prueba:${Blocksgenerals.blocksgeneralsToJson(blocksgenerals.where((b) => b.idLoteria == loteria.id && b.idSorteo == idSorteo).toList())}');
//         }
//       }
//     }else{
//       // MONTO SUPER PALE
//       // Debo ordenar de menor a mayor los idloteria y idloteriaSuperpale, 
//       // el idLoteria tendra el numero menor y el idLoteriaSuper tendra el numero mayor

//       if(loteria.id > loteriaSuperpale.id){
//         Loteria tmp = loteriaSuperpale;
//         loteriaSuperpale = loteria;
//         loteria = tmp;
//       }
//       List<Map<String, dynamic>> query = await Db.database.query('Stocks' , where: '"idBanca" = ? and "idLoteria" = ? and "idLoteriaSuperpale" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, loteriaSuperpale.id, idSorteo, jugada, 0, banca.idMoneda]);
      
//       print("getMontoDisponible super pale: $query");

//       if(query.isEmpty != true){
//         montoDisponible = query.first['monto'];
//         stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: query.first['esBloqueoJugada']);
//       }
        
      
//       if(montoDisponible != null){
//         query = await Db.database.query('Stocks' ,where: '"idLoteria" = ? and "idLoteriaSuperpale" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "ignorarDemasBloqueos" = ? and "idMoneda" = ?', whereArgs: [loteria.id, loteriaSuperpale.id, idSorteo, jugada, 1, 1, banca.idMoneda]);
//         if(query.isEmpty != true){
//           montoDisponible = query.first['monto'];
//           stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: query.first['esBloqueoJugada']);
//         }else{
          
//           //Ahora nos aseguramos de que el bloqueo general existe y el valor de ignorarDemasBloqueos sea = 1
//           query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
//           if(query.isEmpty != true){
//             var first = query.first;
//             if(first["ignorarDemasBloqueos"] == 1){
//               montoDisponible = first["monto"];
//               stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
//             }
//           }
//         }
//       }


//       //AQUI ES CUANDO EXISTE BLOQUEO GENERAL EN STOCKS
//       if(montoDisponible == null){
//           query = await Db.database.query('Stocks' ,where: '"idLoteria" = ? and "idLoteriaSuperpale" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, loteriaSuperpale.id, idSorteo, jugada, banca.idMoneda]);
//         if(query.isEmpty != true){
//           //SI IGNORARDEMASBLOQUEOS ES FALSE ENTONCES VAMOS A VERIFICAR SI EXISTEN BLOQUEOS POR BANCAS YA SEAN DE JUGADAS PARA RETORNAR ESTOS BLOQUEOS
//           var stock = query.first;
//           if(stock["ignorarDemasBloqueos"] == 0){
//             query = await Db.database.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
//             if(query.isEmpty != true){
//               montoDisponible = query.first["monto"];
//               stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);
//             }else{
//               query = await Db.database.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
//               if(query.isEmpty != true){
//                 montoDisponible = query.first["monto"];
//                 stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral']);
//               }
//               else{
//                 montoDisponible = stock["monto"];
//                 stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
//               }
//             }
//           }else{
//             montoDisponible = stock["monto"];
//             stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
//           }
//         }
//       }

      

//       if(montoDisponible == null){
//         query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
//         if(query.isEmpty != true){
//           var blocksplaysgenerals = query.first;
//           if(blocksplaysgenerals["ignorarDemasBloqueos"] == 0){
//             montoDisponible = null;
//           }else{
//             montoDisponible = blocksplaysgenerals["monto"];
//             stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
//           }
//         }

//         if(montoDisponible == null){
//           query = await Db.database.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
//           if(query.isEmpty != true){
//             montoDisponible = query.first["monto"];
//             stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);
//           }else{
//             query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
//             if(query.isEmpty != true){
//               montoDisponible = query.first["monto"];
//               stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
//             }
//           }

//           if(montoDisponible == null){
//             query = await Db.database.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
//             if(query.isEmpty != true){
//               montoDisponible = query.first["monto"];
//               stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral']);
//             }
//           }

//           if(montoDisponible == null){
//             query = await Db.database.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda]);
//             if(query.isEmpty != true){
//               montoDisponible = query.first["monto"];
//               stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda);
//             }
//           }

//           // print('montoDisponiblePrueba idSorteo: lot: $loteria.id sor: $idSorteo dia: $idDia res:${blocksgenerals.indexWhere((b) => b.idLoteria == loteria.id && b.idDia == idDia && b.idSorteo == idSorteo)} prueba:${Blocksgenerals.blocksgeneralsToJson(blocksgenerals.where((b) => b.idLoteria == loteria.id && b.idSorteo == idSorteo).toList())}');
//         }
//       }
//     }

//     // setState(() {
//     //  _txtMontoDisponible.text = montoDisponible.toString(); 
//     // });
//     // print('montoDisponiblePrueba idSorteo: $montoDisponible');

  
//     int idx = -1;
//     if(idSorteo == 4)
//       idx = listaJugadas.indexWhere((j) => j.idLoteria == loteria.id && j.idLoteriaSuperpale == loteriaSuperpale.id && j.jugada == jugadaConSigno);
//     else
//       idx = listaJugadas.indexWhere((j) => j.idLoteria == loteria.id && j.jugada == jugadaConSigno);
//       // _selectedLoterias[0].id
//     // double montoDisponibleFinal = montoDisponible.toDouble();
    
//     double montoDisponibleFinal = Utils.toDouble(montoDisponible.toString());
//     if(idx != -1){
//       print("encontrado: ${listaJugadas[idx].monto}");
//       montoDisponibleFinal = montoDisponibleFinal - listaJugadas[idx].monto;
//       print("encontrado y restado: ${montoDisponibleFinal}");
//     }

//     if(stockToReturn != null)
//       stockToReturn.monto = montoDisponibleFinal;
//     else
//       stockToReturn = Stock(monto: montoDisponibleFinal);

//     print("principalView getMontoDisponible: ${stockToReturn.toJson()}");
//     return MontoDisponible(monto: montoDisponibleFinal, stock: stockToReturn);
   
//  }

 Future<double> getMontoDisponibleViejo(String jugada, Loteria loteria, Banca banca) async {
    var c = await DB.create();
    List<dynamic> listaDynamicStocks = await c.getList("stocks");
    List<dynamic> listaDynamicBlocksgenerals = await c.getList("blocksgenerals");
    List<dynamic> listaDynamicBlockslotteries = await c.getList("blockslotteries");
    List<dynamic> listaDynamicBlocksplays = await c.getList("blocksplays");
    List<dynamic> listaDynamicBlocksplaysgenerals = await c.getList("blocksplaysgenerals");
    List<dynamic> listaDynamicDraws = await c.getList("draws");
    
    List<Stock> stocks = (listaDynamicStocks.length == 0) ? null : listaDynamicStocks;
    List<Blocksgenerals> blocksgenerals = (listaDynamicBlocksgenerals.length == 0) ? null : listaDynamicBlocksgenerals;
    List<Blockslotteries> blockslotteries = (listaDynamicBlockslotteries.length == 0) ? null : listaDynamicBlockslotteries;
    List<Blocksplays> blocksplays = (listaDynamicBlocksplays.length == 0) ? null : listaDynamicBlocksplays;
    //ordenamos la lista para siempre tomar el bloqueo mas reciente
    if(blocksplays != null)
      blocksplays.sort((a, b) => b.id.compareTo(a.id));
    List<Blocksplaysgenerals> blocksplaysgenerals = (listaDynamicBlocksplaysgenerals.length == 0) ? null : listaDynamicBlocksplaysgenerals;
    if(blocksplaysgenerals != null)
      blocksplaysgenerals.sort((a, b) => b.id.compareTo(a.id));


    
    
    List<Draws> draws = (listaDynamicDraws.length == 0) ? null : listaDynamicDraws;

    double montoDisponible = 0;
    // print('stock: ${stocks[stocks.indexWhere((s) => s.jugada == jugada)].monto}');
    // return;
    
    int idDia = getIdDia();
    int idSorteo = await SorteoService.getIdSorteo(jugada, loteria);

    jugada = await SorteoService.esSorteoPickQuitarUltimoCaracter(jugada, idSorteo);
    int idx = -1;

    if(stocks != null)
      idx = stocks.indexWhere((s) => s.idBanca == banca.id && s.idLoteria == loteria.id && s.jugada == jugada && s.idSorteo == idSorteo && s.esGeneral == 0 && s.idMoneda == banca.idMoneda);
    
    if(idx != -1){
    // print('stock: ${idBanca} - $idLoteria - $jugada - $idSorteo - $idx');

      int idxIgnorarDemasBloqueos = stocks.indexWhere((s) => s.idLoteria == loteria.id && s.jugada == jugada && s.idSorteo == idSorteo && s.esGeneral == 1 && s.ignorarDemasBloqueos == 1 && s.idMoneda == banca.idMoneda);
      if(idxIgnorarDemasBloqueos != -1){
        montoDisponible = stocks[idxIgnorarDemasBloqueos].monto;
      }else{

        //Ahora nos aseguramos de que el bloqueo general existe y el valor de ignorarDemasBloqueos sea = 1
        int idxBlocksGenerals = blocksplaysgenerals.indexWhere((b) => b.idLoteria == loteria.id && b.jugada == jugada && b.idSorteo == idSorteo && b.status == 1 && b.idMoneda == banca.idMoneda);
        if(idxBlocksGenerals != -1){
          if(blocksplaysgenerals[idxBlocksGenerals].ignorarDemasBloqueos == 1)
          montoDisponible = blocksplaysgenerals[idxBlocksGenerals].monto;
        }else{
          montoDisponible = stocks[idx].monto;
        }
      }
    }


    //AQUI ES CUANDO EXISTE BLOQUEO GENERAL EN STOCKS
    if(idx == -1){
      if(stocks != null)
        idx = stocks.indexWhere((s) => s.idLoteria == loteria.id && s.jugada == jugada && s.idSorteo == idSorteo && s.esGeneral == 1 && s.idMoneda == banca.idMoneda);
      if(idx != -1){
        //SI IGNORARDEMASBLOQUEOS ES FALSE ENTONCES VAMOS A VERIFICAR SI EXISTEN BLOQUEOS POR BANCAS YA SEAN DE JUGADAS PARA RETORNAR ESTOS BLOQUEOS
        if(stocks[idx].ignorarDemasBloqueos == 0){
          int idxBlocksplays = -1;
          if(blocksplays != null)
            idxBlocksplays = blocksplays.indexWhere((b) => b.idBanca == banca.id && b.idLoteria == loteria.id && b.jugada == jugada && b.idSorteo == idSorteo && b.status == 1 && b.idMoneda == banca.idMoneda);
          if(idxBlocksplays != -1){
            montoDisponible = blocksplays[idxBlocksplays].monto;
          }else{
            montoDisponible = stocks[idx].monto;
          }
        }else{
          montoDisponible = stocks[idx].monto;
        }
      }
    }

    

    if(idx == -1){

      if(blocksplaysgenerals != null)
        idx = blocksplaysgenerals.indexWhere((b) => b.idLoteria == loteria.id && b.jugada == jugada && b.idSorteo == idSorteo && b.status == 1 && b.idMoneda == banca.idMoneda);
      if(idx != -1){
        if(blocksplaysgenerals[idx].ignorarDemasBloqueos == 0){
          idx = -1;
        }else{
          montoDisponible = blocksplaysgenerals[idx].monto;
        }
      }

      if(idx == -1){
        if(blocksplays != null)
          idx = blocksplays.indexWhere((b) => b.idBanca == banca.id && b.idLoteria == loteria.id && b.jugada == jugada && b.idSorteo == idSorteo && b.status == 1 && b.idMoneda == banca.idMoneda);
        if(idx != -1){
          montoDisponible = blocksplays[idx].monto;
        }

        if(idx == -1){
          if(blockslotteries != null)
            idx = blockslotteries.indexWhere((b) => b.idBanca == banca.id && b.idLoteria == loteria.id && b.idDia == idDia && b.idSorteo == idSorteo && b.idMoneda == banca.idMoneda);
          if(idx != -1){
             montoDisponible = blockslotteries[idx].monto;
          }
        }



        if(idx == -1){
          idx = blocksgenerals.indexWhere((b) => b.idLoteria == loteria.id && b.idDia == idDia && b.idSorteo == idSorteo && b.idMoneda == banca.idMoneda);
          if(idx != -1){
            montoDisponible = blocksgenerals[idx].monto;
          }
        }


        
      }
    }

    // setState(() {
    //  _txtMontoDisponible.text = montoDisponible.toString(); 
    // });
    // print('montoDisponiblePrueba idSorteo: $montoDisponible');

    return montoDisponible;
   
 }

  int getIdDia(){
    DateTime fecha = DateTime.now();
    //para wday se usa este return (fecha.weekday == 7) ? 0 : fecha.weekday;
    //La propiedad weekday de la clase DateTime, empieza con el valor 1 que es lunes y termina con el valor 7 que es domingo
    //Entonces en la tabla Days en mi base de datos los dias empiezan desde el lunes id == 1 y terminan con el domingo id == 7
    //asi que La propiedad weekday es igual a los id de los dias de mi tabla Days, por eso cuando quiero el idDia de hoy pues simplemente
    //retorno La propiedad 
    return fecha.weekday;
  }
 

 
//  getIdSorteoSQFlite(String jugada, Loteria loteria) async {
//    int idSorteo = 0;

//    if(jugada.length == 2)
//     idSorteo = 1;
//   else if(jugada.length == 3){
//     // idSorteo = draws[draws.indexWhere((d) => d.descripcion == 'Pick 3 Straight')].id;
//     var query = await Db.database.query('Draws', columns: ['id'], where:'"descripcion" = ?', whereArgs: ['Pick 3 Straight']);
//     idSorteo = (query.isEmpty != true) ? query.first['id'] : 0;
//   }
//   else if(jugada.length == 4){
//     if(jugada.indexOf("+") != -1){
//       var query = await Db.database.query('Draws', columns: ['id'], where:'"descripcion" = ?', whereArgs: ['Pick 3 Box']);
//       idSorteo = (query.isEmpty != true) ? query.first['id'] : 0;
//     }else{
//       idSorteo = 2;
//       // List<Draws> sorteosLoteriaSeleccionada = loteria.sorteos;
//       // if(sorteosLoteriaSeleccionada.indexWhere((s) => s.descripcion == 'Super pale') != -1){
//       //   idSorteo = 4;
//       // }else{
//       //   idSorteo = 2;
//       // }
//     }
//   }
//   else if(jugada.length == 5){
//     if(jugada.indexOf("+") != -1){
//       var query = await Db.database.query('Draws', columns: ['id'], where:'"descripcion" = ?', whereArgs: ['Pick 4 Box']);
//       idSorteo = (query.isEmpty != true) ? query.first['id'] : 0;
//     }
//     else if(jugada.indexOf("-") != -1){
//        var query = await Db.database.query('Draws', columns: ['id'], where:'"descripcion" = ?', whereArgs: ['Pick 4 Straight']);
//         idSorteo = (query.isEmpty != true) ? query.first['id'] : 0;
//     }
//     else if(jugada.indexOf("s") != -1){
//        var query = await Db.database.query('Draws', columns: ['id'], where:'"descripcion" = ?', whereArgs: ['Super pale']);
//         idSorteo = (query.isEmpty != true) ? query.first['id'] : 0;
//     }
//   }
//   else if(jugada.length == 6)
//     idSorteo = 3;

//   return idSorteo;
//  }

 
//  getSorteoSQFlite(String jugada) async {
   

//     Draws sorteo;

//    if(jugada.length == 2){
//      if(kIsWeb)
//       return Draws(1, 'Directo', 2, 1, 1, null);

//      var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Directo']);
//     //  var query = await Db.draw('Directo');
//      sorteo = (query.isEmpty != true) ? Draws.fromMap(query) : null;
//    }
//   else if(jugada.length == 3){
//     if(kIsWeb)
//       return Draws(1, 'Pick 3 Straight', 2, 1, 1, null);

//     // idSorteo = draws[draws.indexWhere((d) => d.descripcion == 'Pick 3 Straight')].id;
//     var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Pick 3 Straight']);
//     sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
//   }
//   else if(jugada.length == 4){
//     if(jugada.indexOf("+") != -1){
//        if(kIsWeb)
//         return Draws(1, 'Pick 3 Box', 2, 1, 1, null);

//       var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Pick 3 Box']);
//       sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
//     }else{
//       if(kIsWeb)
//         return Draws(1, 'Pale', 2, 1, 1, null);

//       var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Pale']);
//       sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
//       // List<Draws> sorteosLoteriaSeleccionada = loteria.sorteos;
//       // if(sorteosLoteriaSeleccionada.indexWhere((s) => s.descripcion == 'Super pale') != -1){
//       //   idSorteo = 4;
//       // }else{
//       //   idSorteo = 2;
//       // }
//     }
//   }
//   else if(jugada.length == 5){
//     if(jugada.indexOf("+") != -1){
//       if(kIsWeb)
//         return Draws(1, 'Pick 4 Box', 2, 1, 1, null);

//       var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Pick 4 Box']);
//       sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
//     }
//     else if(jugada.indexOf("-") != -1){
//       if(kIsWeb)
//         return Draws(1, 'Pick 4 Straight', 2, 1, 1, null);

//       var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Pick 4 Straight']);
//       sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
//     }
//     else if(jugada.indexOf("s") != -1){
//       if(kIsWeb)
//         return Draws(1, 'Super pale', 2, 1, 1, null);

//       var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Super pale']);
//       sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
//     }
//   }
//   else if(jugada.length == 6){
//     if(kIsWeb)
//         return Draws(1, 'Tripleta', 2, 1, 1, null);

//     var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Tripleta']);
//     sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
//   }

//   return sorteo;
//  }



// Future<String> esSorteoPickQuitarUltimoCaracterSQFLite(String jugada, idSorteo) async {
//   var query = await Db.database.query('Draws', columns: ['descripcion'], where:'"id" = ?', whereArgs: [idSorteo]);
//   String sorteo = (query.isEmpty != true) ? query.first['descripcion'] : '';
//   if(sorteo == 'Pick 3 Box' || sorteo == 'Pick 4 Straight' || sorteo == 'Pick 4 Box' || sorteo == 'Super pale'){
//     jugada = jugada.substring(0, jugada.length - 1);
//   }
//   return jugada;
// }




Future quitarLoteriasCerradas()
{
  try {
      for(Loteria l in listaLoteria) {
      
      DateTime fechaLoteria = _horaCierreLoteriaToCurrentTimeZone(l);
      DateTime now = DateTime.now();

      if(now.isAfter(fechaLoteria)){
        if(!_tienePermisoJugarFueraDeHorario){
          if(_tienePermisoJugarMinutosExtras){
            var fechaLoteriaMinutosExtras = fechaLoteria.add(Duration(minutes: l.minutosExtras));
            if(now.isAfter(fechaLoteriaMinutosExtras)){
              setState(() {
                listaLoteria.remove(l);
                _seleccionarPrimeraLoteria(quitarSoloLoteriasCerradas: true);
              });

            }
          }
          else{
            setState(() {
                listaLoteria.remove(l);
                 _seleccionarPrimeraLoteria(quitarSoloLoteriasCerradas: true);
              // _seleccionarPrimeraLoteria(quitarSoloLoteriasCerradas: true);
              });

          }
        }
      }
      // print("Detroit: ${now.toString()}");
    }

    _streamControllerLoteria.add(listaLoteria);
  } catch (e) {
  }
  
}



Future quitarLoteriasCerradasViejo()
{
  try {
      listaLoteria.forEach((l) {
      // print("quitarloteriasCerradas: ${l.descripcion}");
      var santoDomingo = getLocation('America/Santo_Domingo');
      var fechaActualRd = TZDateTime.now(santoDomingo);
      var fechaLoteria = DateTime.parse(fechaActualRd.year.toString() + "-" + Utils.toDosDigitos(fechaActualRd.month.toString())+ "-" + Utils.toDosDigitos(fechaActualRd.day.toString()) + " ${l.horaCierre}");
      var fechaFinalRd = TZDateTime.now(santoDomingo);
      // print("principalview quitarLoteriasCerradas ${fechaFinalRd.hour} : ${fechaFinalRd.minute}");
      if(fechaFinalRd.isAfter(fechaLoteria)){
        if(!_tienePermisoJugarFueraDeHorario){
          if(_tienePermisoJugarMinutosExtras){
            var fechaLoteriaMinutosExtras = fechaLoteria.add(Duration(minutes: l.minutosExtras));
            if(fechaFinalRd.isAfter(fechaLoteriaMinutosExtras)){
              setState(() {
                listaLoteria.remove(l);
              _seleccionarPrimeraLoteria();
              });

            }
          }
          else{
            setState(() {
                listaLoteria.remove(l);
              _seleccionarPrimeraLoteria();
              });

          }
        }
      }
      // print("Detroit: ${now.toString()}");
    });
  } catch (e) {
  }
  
}

Future<List<Loteria>> quitarLoterasNoPertenecenABanca(List<Loteria> loterias) async {
  List<Loteria> loteriasPertenecientesABanca = [];
  Banca banca = await getBanca();

  if(banca == null)
    return [];

  if(banca.loterias == null)
    return [];

  for (var loteria in loterias) {
    if(banca.loterias.indexWhere((element) => element.id == loteria.id) == -1)
      continue;

     loteriasPertenecientesABanca.add(loteria); 
  }

  return loteriasPertenecientesABanca;  
}

quitarLoteriasProvenientesDelSocketQueEstenCerradas(var parsed, {List<Loteria> loterias}) async {
  // List<Loteria> listaLoteriaEvent = parsed['lotteries'].map<Loteria>((json) => Loteria.fromMap(json)).toList();
  List<Loteria> listaLoteriaEvent = await quitarLoterasNoPertenecenABanca(loterias != null ? loterias : parsed['lotteries'].map<Loteria>((json) => Loteria.fromMap(json)).toList());
  List<int> listaIdloteriasAEliminar = [];

  if(parsed != null)
    listaLoteriaTmp = parsed['lotteries'].map<Loteria>((json) => Loteria.fromMap(json)).toList();

   listaLoteriaEvent.forEach((l) async {

    DateTime fechaLoteria = _horaCierreLoteriaToCurrentTimeZone(l);
    DateTime now = DateTime.now();

    if(now.isAfter(fechaLoteria)){
      if(!_tienePermisoJugarFueraDeHorario){
        if(_tienePermisoJugarMinutosExtras){
          var fechaLoteriaMinutosExtras = fechaLoteria.add(Duration(minutes: l.minutosExtras));
          if(now.isAfter(fechaLoteriaMinutosExtras)){
            // listaLoteriaEvent.remove(l);
            listaIdloteriasAEliminar.add(l.id);
          }
        }
        else{
          // listaLoteriaEvent.remove(l);
          listaIdloteriasAEliminar.add(l.id);
        }
      }
    }
  });

  listaIdloteriasAEliminar.forEach((l){
    var _index = listaLoteriaEvent.indexWhere((lo) => lo.id == l);
    if(_index != -1){
      setState(() => listaLoteriaEvent.removeAt(_index));
    }

  });


  
  setState((){
    listaLoteria = listaLoteriaEvent;
    _streamControllerLoteria.add(listaLoteriaEvent);
    _seleccionarPrimeraLoteria(quitarSoloLoteriasCerradas: true);
  });
}


 

}




