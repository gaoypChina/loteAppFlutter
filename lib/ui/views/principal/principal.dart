import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:loterias/core/classes/cross_device_info.dart';
import 'package:loterias/core/classes/cross_platform_timezone/cross_platform_timezone.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/mynotification.dart';
import 'package:loterias/core/classes/mysocket.dart';
import 'package:loterias/core/classes/ticketimage.dart';
import 'package:loterias/core/models/estadisticajugada.dart';
import 'package:loterias/core/models/notificacion.dart';
import 'package:loterias/core/models/sale.dart';
import 'package:loterias/core/models/salesdetails.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/models/ticket.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/services/bluetoothchannel.dart';
import 'package:loterias/core/services/loginservice.dart';
import 'package:loterias/core/services/notificationservice.dart';
import 'package:loterias/core/services/sharechannel.dart';
import 'package:loterias/core/services/ticketservice.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:loterias/ui/splashscreen.dart';
import 'package:loterias/ui/views/prueba/pruebaticketimage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart' show kIsWeb;




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
import 'package:timezone/timezone.dart';

class PrincipalApp extends StatefulWidget {
  final bool callThisScreenFromLogin;
  PrincipalApp({Key key, this.callThisScreenFromLogin = false}) : super(key: key);
  @override
  _PrincipalAppState createState() => _PrincipalAppState();
}

class _PrincipalAppState extends State<PrincipalApp> with WidgetsBindingObserver{
  IO.Socket socket;
  var _scrollController = ItemScrollController();
  List<String> _listaMensajes = List();
  static int _socketContadorErrores = 0;
  static int _socketNotificacionContadorErrores = 0;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formLigarKey = GlobalKey<FormState>();
  bool _jugadaOmonto = true;
  // var listaBanca = List<String>.generate(10, (i) => "Banca $i");
  List<Banca> listaBanca = List<Banca>.generate(1, (i) => Banca(descripcion: 'No hay bancas', id: 0));
  List<Loteria> listaLoteria = List<Loteria>.generate(1, (i) => Loteria(descripcion: 'No hay bancas', id: 0));
  List<Venta> listaVenta = List<Venta>.generate(1, (i) => Venta(idTicket: BigInt.from(0), id: BigInt.from(0)));
  List<Jugada> listaJugadas = List<Jugada>();
  List<EstadisticaJugada> listaEstadisticaJugada = List<EstadisticaJugada>();

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
  bool _tienePermisoJugarFueraDeHorario = false;
  bool _tienePermisoJugarMinutosExtras = false;
  bool _tienePermisoJugarComoCualquierBanca = false;
  bool _tienePermisoManejarResultados = false;
  bool _tienePermisoMarcarTicketComoPagado = false;
  bool _tienePermisoMonitorearTicket = false;
  bool _tienePermisoVerDashboard = false;
  bool _tienePermisoVerVentas = false;
  bool _tienePermisoVerHistoricoVentas = false;
  bool _tienePermisoVerListaDeBalancesDeBancass = false;
  bool _tienePermisoVerReporteJugadas = false;
  bool _tienePermisoTransacciones = false;
  bool _tienePermisoVerAjustes = false;
  static bool _tienePermisoAdministrador = false;
  static bool _tienePermisoProgramador = false;
  StreamController<bool> _streamControllerBanca;
  StreamController<List<Loteria>> _streamControllerLoteria;
  StreamController<bool> _streamControllerVenta;
  StreamController<List<Jugada>> _streamControllerJugada;
  var _txtJugada = TextEditingController();
  var _txtMontoDisponible = TextEditingController();
  var _txtMonto = TextEditingController(); 
  var _txtMontoLigar = TextEditingController(); 
  var _txtLoteriasSeleccionadasParaLigar = TextEditingController(); 
  bool _txtMontoPrimerCaracter = true;
  List<Loteria> _selectedLoterias;
  Timer _timer;
  Timer _timerSaveVentaNoSubidas;

  static const platform = const MethodChannel('flutter.loterias');
  Usuario _usuario;
  Banca _banca;
  Future<Map<String, dynamic>> futureBanca;
  Future<Map<String, dynamic>> futureUsuario;


  
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

Future<bool> _requestPermisionChannel() async {
    bool batteryLevel;
    try {
      final bool result = await platform.invokeMethod('requestPermissions');
      batteryLevel = result;
    } on PlatformException catch (e) {
      throw Exception("Failed to get battery level: '${e.message}'.");
    }

    print('requestPermission channel: $batteryLevel');
    return batteryLevel;
  }


  getIdBanca() async {
    print("Principal views getIdBanca: ${await Db.existePermiso("Jugar como cualquier banca")} : ${listaBanca.length}");
    if(await Db.existePermiso("Jugar como cualquier banca"))
      return listaBanca[_indexBanca].id;
    else
      return await Db.idBanca();
  }

  Future<Banca> getBanca() async {
    if(await Db.existePermiso("Jugar como cualquier banca"))
      return listaBanca[_indexBanca];
    else
      return Banca.fromMap(await Db.getBanca());
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
        print("indexPost listaBanca: ${listaBanca.length}");
        listaVenta = datos["ventas"];
        _streamControllerBanca.add(true);
        _streamControllerVenta.add(true);
        listaLoteria = datos['loterias'];
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
      _showSnackBar("No hay jugadas realizadas");
      return;
    }

    if(_ckbPrint){
      if(await Utils.exiseImpresora() == false){
        _showSnackBar("Debe registrar una impresora");
        return;
      }

      if(!(await BluetoothChannel.turnOn())){
        return;
      }
    }

    if(await hayJugadasSuciasNuevo()){
      sendNotificationJugadasSucias();
      return;
    }

    _guardarLocal();
    return;

    try{
      setState(() => _cargando = true);
      var datos = await TicketService.guardar(idVenta: _idVenta, compartido:  !_ckbPrint,descuentomonto: await _calcularDescuento(), hayDescuento: _ckbDescuento, total: _calcularTotal(), loterias: Principal.loteriaToJson(_selectedLoterias), jugadas: Principal.jugadaToJson(listaJugadas), idUsuario: await Db.idUsuario(), idBanca: await getIdBanca(), scaffoldKey: _scaffoldKey);
      
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
      
      });
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
  }


  _guardarLocal() async {
    try {
      var listaDatos = await Realtime.guardarVenta(banca: await getBanca(), jugadas: listaJugadas, socket: socket, listaLoteria: listaLoteria, compartido: !_ckbPrint, descuentoMonto: await _calcularDescuento(), tienePermisoJugarFueraDeHorario: _tienePermisoJugarFueraDeHorario, tienePermisoJugarMinutosExtras: _tienePermisoJugarMinutosExtras);
      var ticketImage = await TicketImage.create(listaDatos[0], listaDatos[1]);
      print("Principal _guardarLocal jugadas: ${listaDatos[1].length}");
      ShareChannel.shareHtmlImageToSmsWhatsapp(base64image: ticketImage, codigoQr: listaDatos[0].ticket.codigoBarra, sms_o_whatsapp: _ckbMessage);
      Navigator.push(context, MaterialPageRoute(builder: (context) => PruebaTicketImage(image: ticketImage,)));
    } on Exception catch (e) {
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
        print("sendNotification for: ${listaEstadisticaJugada[i].descripcionSorteo}");
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

      print("sendNotification contenido: $contenido");

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
        print('futuro: ${resp.body}');
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
    print("PrincipalScreen inside function seGuardaronLosDatosDeLaSesion: $seGuardaronLosDatosDeLaSesion");
    if(seGuardaronLosDatosDeLaSesion == false){
      await Principal.cerrarSesion(context);
      await stopSocketNoticacionInForeground();
      setState(() => _cargandoDatosSesionUsuario = false);
    }else{
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
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
    ]);
    if(widget.callThisScreenFromLogin){
      _getCurrentTimeZone();
      if(kIsWeb == false)
        _requestPermisionChannel();

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
      print("PrincipalScreen before _getDatosSessionUsuaro");
      _getDatosSessionUsuario().then((value){
      print("PrincipalScreen _getDatosSessionUsuaro inside then function");
       if(value == false)
        return;
        
        _getCurrentTimeZone();
        if(kIsWeb == false)
          _requestPermisionChannel();
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
    
    
      print('timerrrr: $_timeString');
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
      if(!kIsWeb)
        _timerSaveVentaNoSubidas = Timer.periodic(Duration(seconds: 5), (Timer t) => _emitToSaveTicketsNoSubidos());
    
    
    focusNode = FocusNode();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    //_montoFuture = fetchMonto();
    
  // platform.setMethodCallHandler(this._saludos);

  }

  _initMobileFunction(){

  }

  _getUsuarioYBanca() async {
    var usuario = await Db.getUsuario();
    var banca = await Db.getBanca();
    print("PrincipalScreen _getUsuarioYBanca: ${usuario}");
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
      print("PrincipalScreen _getUsuarioYBanca null: ${usuario}");
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
    print("dispose desconectar socket");
    print("Desconectando socket desde dispose de la ventana principal");
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
    bool permisoVerDashboard = await Db.existePermiso("Ver Dashboard");
    bool permisoVerVentas = await Db.existePermiso("Ver ventas");
    bool permisoVerHistoricoVentas = await Db.existePermiso("Ver historico ventas");
    bool permisoAccesoAlSistema = await Db.existePermiso("Acceso al sistema");
    bool permisoVerListaDeBalancesDeBancas = await Db.existePermiso("Ver lista de balances de bancas");
    bool permisoTransacciones = await Db.existePermiso("Manejar transacciones");
    bool permisoAdministrador  = await (await DB.create()).getValue("administrador");
    bool permisoProgramador  = (await (await DB.create()).getValue("tipoUsuario")) == "Programador";
    bool permisoVerReporteJugadas  = await Db.existePermiso("Ver reporte jugadas");
    bool permisoVerAjustes  = await Db.existePermiso("Ver ajustes");
    print("_getPermisos tipoUsuario: ${(await (await DB.create()).getValue("tipoUsuario"))}");
    print("_getPermisos tiene permiso ver ajustes: $permisoVerAjustes");
    if(permisoAccesoAlSistema == false){
      Principal.cerrarSesion(context);
      await stopSocketNoticacionInForeground();
    }

    setState((){
      _tienePermisoJugarComoCualquierBanca = permiso;
      _tienePermisoJugarFueraDeHorario = permisoJugarFueraDeHorario;
      _tienePermisoJugarMinutosExtras = permisoJugarMinutosExtras;
      _tienePermisoProgramador = permisoProgramador;
      _tienePermisoAdministrador = permisoAdministrador;
      _tienePermisoManejarResultados = permisoManejarResultados;
      _tienePermisoMarcarTicketComoPagado = permisoMarcarTicketComoPagado;
      _tienePermisoMonitorearTicket = permisoMonitorearTicket;
      _tienePermisoVerDashboard = permisoVerDashboard;
      _tienePermisoVerVentas = permisoVerVentas;
      _tienePermisoVerHistoricoVentas = permisoVerHistoricoVentas;
      _tienePermisoTransacciones = permisoTransacciones;
      _tienePermisoVerListaDeBalancesDeBancass = permisoVerListaDeBalancesDeBancas;
      _tienePermisoVerReporteJugadas = permisoVerReporteJugadas;
      _tienePermisoVerAjustes = permisoVerAjustes;
      // initSocketNoticacionInForeground();
    });
  }

  Future _desconectarYConectarNuevamente() async {
    print("_desconectarYConectarNuevamente desconectar socket y conectar");
    // await manager.clearInstance(socket);
    await _disconnectSocket();
    _socketContadorErrores = 0;
    initSocket();
  }

  static Future _desconectarYConectarNuevamenteSocketNotificacion() async {
    print("_desconectarYConectarNuevamente desconectar socket y conectar");
    await manager.clearInstance(socketNotificaciones);
    _socketNotificacionContadorErrores = 0;
    initSocketNoticacion();
  }

  _disconnectSocket(){
    if(socket == null)
      return;
      
    socket.dispose();
    socket = null;
  }

  _updateBranchesList(Map<String, dynamic> parsed) async {
    print("Dentro principal view _updateBranchesList 1:");
    if(parsed["branch"] == null)
      return;
    print("Dentro principal view _updateBranchesList paso parsed != null _administrador: $_tienePermisoJugarComoCualquierBanca");
    
    print("Dentro principal view _updateBranchesList 2");

      try {
        Banca banca = Banca.fromMap(parsed["branch"]);
        if(_tienePermisoJugarComoCualquierBanca){
          int idx = listaBanca.indexWhere((element) => element.id == banca.id);
          print("Dentro principal view _updateBranchesList 3: $idx");
          print("Dentro principal view _updateBranchesList 4 la primera pertenece: ${banca.loterias.indexWhere((element) => element.descripcion == "La Primera") == -1}");

          if(idx != -1 && idx == _indexBanca)
            listaBanca[idx] = banca;
        }
        

        if(await Db.idBanca() == banca.id){
          await Db.delete("Branches");
          await Db.insert('Branches', banca.toJson());
        }
        
      } catch (e) {
        print("Principal view _updateBranchesList error: $e");
      }
  }

  _emitToGetNewIdTicket() async {
    var idBanca = await getIdBanca();
    print("_emitToGetNewIdTicket idBanca: ${listaBanca.length}");
    if(idBanca != null)
      socket.emit("ticket", await Utils.createJwt({"servidor" : await Db.servidor(), "idBanca" : idBanca, "uuid" : await CrossDeviceInfo.getUIID(), "createNew" : false}));
  }

  _emitToSaveTicketsNoSubidos() async {
    if(kIsWeb)
      return;

    if(socket == null)
      return;

    if(!socket.connected)
      return;

    var saleMap = await Db.getSaleNoSubida();
    // var saleMapAll = await Db.query("Sales");

    print("_emitToSaveTicketsNoSubidos before validate, saleMap: ${saleMap}");
    // print("_emitToSaveTicketsNoSubidos before validate, saleMapAll: ${saleMapAll}");
    Sale sale = saleMap != null ? Sale.fromMap(saleMap) : null;
    if(sale == null)
      return;

    if(sale.subido != 0)
      return;

    var ticketMap = await Db.queryBy("Tickets", "id", sale.idTicket.toInt());
    Ticket ticket = Ticket.fromMap(ticketMap);
    sale.ticket = ticket;

    var salesdetailsListMap = await Db.queryListBy("Salesdetails", "idVenta", sale.id.toInt());
    List<Salesdetails> salesdetails = salesdetailsListMap.map<Salesdetails>((e) => Salesdetails.fromMap(e)).toList();
    print("_emitToSaveTicketsNoSubidos idBanca: ${ticketMap}");
    
    // return;

    socket.emit("guardarVenta", await Utils.createJwt({"servidor" : await Db.servidor(), "usuario" : await Db.getUsuario(), "sale" : sale.toJsonFull(), "salesdetails" : Salesdetails.salesdetailsToJson(salesdetails)}));
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

    socket = IO.io(Utils.URL_SOCKET, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'extraHeaders': {'foo': 'bar'}, // optional
      'query': 'auth_token='+signedToken +'&room=' + "${await Db.servidor()}"
      // 'query': 'auth_token='+"hola" +'&room=' + "valentin"
    });
    socket.on('connect', (_) async {
     print("connected...");
      // print(data);
      // socket.emit("message", ["Hello world!"]);
      _emitToGetNewIdTicket();
      await Realtime.sincronizarTodos(_scaffoldKey);
      await _getPermisos();
      _socketContadorErrores = 0;
    });

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
    if(kIsWeb == false){
      socket.on("realtime-stock:App\\Events\\RealtimeStockEvent", (data) async {   //sample event
        // var parsed = data.cast<String, dynamic>();
        var parsed = await compute(Utils.parseDatosDynamic, data);
        await Realtime.addStocks(parsed['stocks'], (parsed['action'] == 'delete') ? true : false);
      });
      socket.on("blocksgenerals:App\\Events\\BlocksgeneralsEvent", (data) async {   //sample event
        var parsed = data.cast<String, dynamic>();
        await Realtime.addBlocksgeneralsDatosNuevos(parsed['blocksgenerals'], (parsed['action'] == 'delete') ? true : false);
      });
      socket.on("blockslotteries:App\\Events\\BlockslotteriesEvent", (data) async {   //sample event
        var parsed = data.cast<String, dynamic>();
        await Realtime.addBlockslotteriesDatosNuevos(parsed['blockslotteries'], (parsed['action'] == 'delete') ? true : false);
      });
      socket.on("blocksplays:App\\Events\\BlocksplaysEvent", (data) async {   //sample event
        var parsed = data.cast<String, dynamic>();
        await Realtime.addBlocksplaysDatosNuevos(parsed['blocksplays'], (parsed['action'] == 'delete') ? true : false);
      });
      socket.on("blocksplaysgenerals:App\\Events\\BlocksplaysgeneralsEvent", (data) async {   //sample event
        var parsed = data.cast<String, dynamic>();
        print("BlocksplaysgeneralsEvent: $parsed");
        await Realtime.addBlocksplaysgeneralsDatosNuevos(parsed['blocksplaysgenerals'], (parsed['action'] == 'delete') ? true : false);
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

      socket.on("ticket", (data){
        print("Socket ticket from server before: $data");
        Realtime.createTicketIfNotExists(data);
        print("Socket ticket from server after: $data");
      });
      socket.on("recibirVenta", (data){
        print("Socket ticket from server before: $data");
        Realtime.setVentaToSubido(data);
        print("Socket ticket from server after: $data");
      });
    }
    
    socket.on("users:App\\Events\\UsersEvent", (data) async {   //sample event
      // var parsed = data.cast<String, dynamic>();
      var parsed = await compute(Utils.parseDatosDynamic, data);
      await Realtime.usuario(context: _scaffoldKey.currentContext, usuario: parsed["user"]);
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
    socket.on("error", (data){   //sample event
      print("onError: $data");
    });
    socket.on('connect_error', (data) => print(data));
    socket.on('error', (data) => print("errr: ${data}"));
    socket.onDisconnect((data) => print("onDisconnect principalview: ${data}"));
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
    print("_showIntentNotificationIfExists ${notificacion.toJson()}");
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

  _duplicar(Map<String, dynamic> datos) async {
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
              print("duplicarSuperpale ${l["duplicarSuperpale"]}");
              await addJugada(loteriaMap: l, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
            }else{
              Map<String, dynamic> mapLoteria = Map<String, dynamic>();
              Loteria loteria = listaLoteria.firstWhere((lote) => lote.id == l["id"]);
              if(l["duplicarSuperpale"] == '- NO MOVER -'){
                  mapLoteria["id"] = loteria.id;
                  mapLoteria["descripcion"] = loteria.descripcion;
                  mapLoteria["abreviatura"] = loteria.abreviatura;
                  print("_duplicar Superpale jugadaBefore: ${jugada["jugada"]}");
                  jugada["jugada"] = await Utils.esSorteoPickOSuperpaleAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
                  print("_duplicar Superpale jugadaAfter: ${jugada["jugada"]}");
                  await addJugada(loteriaMap: mapLoteria, jugada: jugada["jugada"], jugadaMap: jugada, montoDisponible: 'X', monto: jugada["monto"]);
                }
                else if(l["duplicarSuperpale"] != '- NO COPIAR -'){
                  print("duplicarSuperpale: ${l["duplicarSuperpale"]}");
                  mapLoteria = Map<String, dynamic>();
                  loteria = listaLoteria.firstWhere((lote) => lote.id == l["duplicarIdSuperpale"][0]);
                  Loteria loteriaSuperpale = listaLoteria.firstWhere((lote) => lote.id == l["duplicarIdSuperpale"][1]);
                  if(loteria.id > loteriaSuperpale.id){
                    Loteria tmp = loteriaSuperpale;
                    loteriaSuperpale = loteria;
                    loteria = tmp;
                  }

                  print("loteriaSuperpale show: ${loteriaSuperpale.toJson()}");
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
                  print("duplicarSuperpale: ${l["duplicarSuperpale"]}");
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
    print("Holaaaaaaaaaaaaaaaaa");
    var c = await DB.create();
    var tipoUsuario = await c.getValue("tipoUsuario");
    if(tipoUsuario == "Programador"){
      var datosServidor = await Db.query("Servers");
      if(datosServidor == null)
        return;

      List<Servidor> listaServidor = datosServidor.map<Servidor>((json) => Servidor.fromMap(json)).toList();
      String servidorActual = await Db.servidor();
      print("_cambiarServidor listaServidor: ${listaServidor.length} : servidor: $servidorActual");
      int indexServidor = (listaServidor.length > 0) ? listaServidor.indexWhere((element) => element.descripcion == servidorActual) : -1;
      Servidor servidorSeleccionado = (indexServidor != -1) ? listaServidor[indexServidor] : null;
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
        print("_cambiarServidor entrooooooooooooooooo");
        // await manager.clearInstance(socket);
        await _disconnectSocket();
        futureUsuario = Db.getUsuario();
        await indexPost(true);
        await initSocket();
      }
    }
  }

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
              print("Principal.dar drawer cambiar: ${parsed["apiKey"]}");
              await Principal.cerrarSesion(context, false);
              await Db.deleteDB();
              var c = await DB.create();
              await c.add("apiKey", parsed["apiKey"]);
              await c.add("idUsuario", parsed["usuario"]["id"]);
              await c.add("administrador", parsed["administrador"]);
              await c.add("tipoUsuario", parsed["tipoUsuario"]);
              await LoginService.guardarDatos(parsed);
              print("Principal.dar drawer cambiar: ${await c.getValue("apiKey")}");
            }
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
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

AppBar _appBar(bool screenHeightIsSmall){
    double _iconPaddingVertical = screenHeightIsSmall ? 2.0 :  8.0;
    double _iconPaddingHorizontal = 12;
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      title: screenHeightIsSmall ? Padding(padding: EdgeInsets.only(top: 5), child: Text('Principal', style: TextStyle(fontSize: 17))) : Text('Principal'),
      // leading: SizedBox(),
      // leading: _drawerIsOpen ? SizedBox() :  IconButton(icon: Icon(Icons.menu, color:  Colors.white,), onPressed: (){
      //   _scaffoldKey.currentState.openDrawer();
      // }),
      actions: <Widget>[
        Container(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: screenHeightIsSmall ? 23 : 30,
              height: screenHeightIsSmall ? 23 : 30,
              child: Visibility(
                visible: _cargando,
                child: Theme(
                  data: Theme.of(context).copyWith(accentColor: Colors.white),
                  child: new CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
        
        PopupMenuButton(
          child: Padding(
            padding: EdgeInsets.only(top: _iconPaddingVertical, bottom: _iconPaddingVertical, right: _iconPaddingHorizontal, left: _iconPaddingHorizontal),
            child: Icon(Icons.camera_alt, size: screenHeightIsSmall ? 25 :  30),
          ),
          onSelected: (String value) async {
            if(value == "duplicar"){
              try{
                String codigoQr = await BarcodeScanner.scan();
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
                String codigoQr = await BarcodeScanner.scan();
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
        Padding(
            padding: EdgeInsets.only(top: _iconPaddingVertical, bottom: _iconPaddingVertical, right: _iconPaddingHorizontal),
            child: GestureDetector(child: Icon(Icons.bluetooth, size: screenHeightIsSmall ? 25 :  30), onTap: (){Navigator.of(context).pushNamed('/bluetooth');}),
        ),
        // Visibility(
        //   visible: _tienePermisoAdministrador || _tienePermisoProgramador,
        //   child: 
          Visibility(
            visible: !_cargando && (_tienePermisoAdministrador == true || _tienePermisoProgramador == true),
            child: Padding(
              padding: EdgeInsets.only(top: _iconPaddingVertical, bottom: _iconPaddingVertical, right: _iconPaddingHorizontal),
              child: GestureDetector(child: Icon(Icons.notifications, size: screenHeightIsSmall ? 25 :  30), onTap: () async {
                Navigator.of(context).pushNamed('/notificaciones');
                // MyNotification.show(title: "Hola", subtitle: "Esta baina esta fea", content: "Es para probar que las notificaciones se ejecutan bien", route: "/verNotificaciones");
              }),
            ),
          ),
        // )
        // IconButton(
        //   icon: Icon(Icons.bluetooth, size: screenHeightIsSmall ? 23 : 30,),
        //   onPressed: () async{
        //     // print("Screensize: ${MediaQuery.of(context).size.height}");
        //     Navigator.of(context).pushNamed('/bluetooth');
        //   },
        // ),
        // IconButton(
        //   icon: Icon(Icons.message, size: 30,),
        //   onPressed: () async{
        //     showDialog(
        //       context: context,
        //       builder: (context){
        //         return AlertDialog(
        //           title: Text("Errores socket"),
        //           content: ListView.builder(
        //             itemCount: _listaMensajes.length,
        //             itemBuilder: (context, idx){
        //               return ListTile(
        //                 title: Text(_listaMensajes[idx]),
        //               );
        //             },
        //           ),
        //         );
        //       }
        //     );
        //   },
        // )
      ],
      bottom: TabBar(
        // labelPadding: EdgeInsets.all(-20),
        // isScrollable: true,
        // indicatorWeight: 100,
        indicatorColor: Colors.white,
        tabs: <Widget>[
          Tab(
            child: Text('Jugar'),
          ),
          Tab(
            child: Text('Jugadas'),
          )
        ],
      ),
    );
  }

  _myPrincipalScreen(){
    
    return LayoutBuilder(
                builder:(context, BoxConstraints boxConstraints){ 
                  return ListView(
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(maxHeight: (boxConstraints.maxHeight > 300) ? boxConstraints.maxHeight : 500),
                        child: AbsorbPointer(
                          absorbing: _cargando,
                          child: Column(
                            children: <Widget>[
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  !_tienePermisoJugarComoCualquierBanca
                                  ?
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("${_banca != null ? _banca.descripcion : 'Banca'}"),
                                  )
                                  :
                                  StreamBuilder(
                                    stream: _streamControllerBanca.stream,
                                    builder: (context, snapshot){
                                      
                                      if(snapshot.hasData){
                                        return Padding(
                                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                        child: DropdownButton(
                                              hint: Text('sel. banca'),
                                              // isExpanded: true,
                                              value: (listaBanca.length > 0) ? (_indexBanca > listaBanca.length) ? listaBanca[0] : listaBanca[_indexBanca] : null,
                                              onChanged: (Banca banca){
                                                setState(() {
                                                _indexBanca = listaBanca.indexOf(banca); 
                                                _emitToGetNewIdTicket();
                                                indexPost(false);
                                                });
                                              },
                                              items: listaBanca.map((b){
                                                return DropdownMenuItem<Banca>(
                                                  value: b,
                                                  child: Text(b.descripcion, textAlign: TextAlign.center,),
                                                );
                                              }).toList(),
                                            ),
                                      
                                      );
                                      }else{
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                          child: DropdownButton(
                                              hint: Text('Sin datos...'),
                                              value:  'Sin datos',
                                              onChanged: (String banca){
                                                setState(() {
                                                
                                                });
                                              },
                                              items: [
                                                DropdownMenuItem<String>(
                                                  value: "Sin datos",
                                                  child: Text('Sin datos',),
                                                )
                                              ]
                                            ),
                                        );
                                        
                                      }
                                        
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                        child: DropdownButton(
                                              hint: Text('Seleccionar banca'),
                                              value:  listaBanca[_indexBanca],
                                              onChanged: (Banca banca){
                                                setState(() {
                                                _indexBanca = listaBanca.indexOf(banca); 
                                                });
                                              },
                                              items: listaBanca.map((b){
                                                return DropdownMenuItem<Banca>(
                                                  value: b,
                                                  child: Text(b.descripcion, textAlign: TextAlign.center,),
                                                );
                                              }).toList(),
                                            ),
                                      
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Text(_timeString, style: TextStyle(fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              //   child: GestureDetector(
                              //     onTap: (){
                              //       _showMultiSelect(context);
                              //     },
                              //       child: Container(
                              //       width: MediaQuery.of(context).size.width,
                              //       padding: EdgeInsets.only(top: 13, bottom: 13),
                              //       decoration: BoxDecoration(
                              //         border: Border.all(style: BorderStyle.solid, color: Colors.black, width: 1),
                              //       ),
                              //       child: Center(child: Text(Principal.loteriasSeleccionadasToString(_selectedLoterias), style: TextStyle(color: _colorSegundary),),),
                              //     ),
                              //   ),
                              // ),

                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: GestureDetector(
                                  onTap: (){
                                    _showMultiSelect(context);
                                  },
                                    child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height * 0.058,
                                    // padding: EdgeInsets.only(top: 13, bottom: 13),
                                    decoration: BoxDecoration(
                                      border: Border.all(style: BorderStyle.solid, color: Colors.black, width: 1),
                                    ),
                                    // child: Center(child: Text(Principal.loteriasSeleccionadasToString(_selectedLoterias), style: TextStyle(color: _colorSegundary),),),
                                    child: Center(child: _getSelectedLoteriaStream(),),
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 8,),
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: (){
                                      // _showMultiSelect(context);
                                      setState(() => _jugadaOmonto = true);
                                    },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Container(
                                          // duration: Duration(milliseconds: 50),
                                            width: MediaQuery.of(context).size.width / 3,
                                            height: (MediaQuery.of(context).size.height * 0.0688),
                                            // padding: EdgeInsets.only(top: 13, bottom: 13),
                                            decoration: BoxDecoration(
                                              border: Border.all(style: BorderStyle.solid, color: (_jugadaOmonto) ? _colorSegundary : Colors.black, width: (_jugadaOmonto) ? 3 : 1),
                                            ),
                                            child: Center(
                                              child: TextField(
                                                controller: _txtJugada,
                                                enabled: false,
                                                style: TextStyle(fontSize: 20, color: Colors.black),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(0),
                                                  isDense: true,
                                                  alignLabelWithHint: true,
                                                  border: InputBorder.none,
                                                  hintText: 'Jugada',
                                                  fillColor: Colors.transparent,
                                                  // filled: true,
                                                  hintStyle: TextStyle(fontWeight: FontWeight.bold)
                                                ),
                                                textAlign: TextAlign.center,
                                                // expands: false,
                                              ),
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
                                      height: (MediaQuery.of(context).size.height * 0.0688),
                                      // padding: EdgeInsets.only(top: 10.03, bottom: 10.03),
                                      decoration: BoxDecoration(
                                        border: Border.all(style: BorderStyle.solid, color: Colors.black, width: 1),
                                      ),
                                      child: Center(
                                        child: 
                                        TextField(
                                          controller: _txtMontoDisponible,
                                          enabled: false,
                                          style: TextStyle(fontSize: 20),
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(0),
                                            isDense: true,
                                            border: InputBorder.none,
                                            hintText: '0',
                                            fillColor: Colors.transparent,
                                            filled: true,
                                            hintStyle: TextStyle(fontWeight: FontWeight.bold)
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
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
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Container(
                                          width: MediaQuery.of(context).size.width / 3,
                                          height: (MediaQuery.of(context).size.height * 0.0688),
                                          // padding: EdgeInsets.only(top: 13, bottom: 13),
                                          decoration: BoxDecoration(
                                            border: Border.all(style: BorderStyle.solid, color: (!_jugadaOmonto) ? _colorSegundary : Colors.black, width: (!_jugadaOmonto) ? 3 : 1),
                                          ),
                                          child: Center(
                                            child: TextField(
                                              controller: _txtMonto,
                                              enabled: false,
                                              style: TextStyle(fontSize: 20),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.all(0),
                                                isDense: true,
                                                border: InputBorder.none,
                                                hintText: 'Monto',
                                                fillColor: Colors.transparent,
                                                filled: true,
                                                hintStyle: TextStyle(fontWeight: FontWeight.bold)
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Flexible(child: Text('Tot: ${_calcularTotal()}\$', style: TextStyle(fontSize: 12))),
                                  FutureBuilder(
                                    future: _calcularDescuento(),
                                    builder: (context, snapshot){
                                      if(snapshot.hasData){
                                        return Flexible(child: Text('Des: ${snapshot.data}\$', style: TextStyle(fontSize: 12),));
                                      }
                                      return Flexible(child: Text('Des: 0\$', style: TextStyle(fontSize: 12),));
                                    }
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() => _ckbDescuento = !_ckbDescuento);
                                    },
                                    child: Container(
                                      // color: Colors.red,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 5.0, left: 8.0),
                                        child: Row(
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
                                            GestureDetector(child: Text('Des', style: TextStyle(fontSize: 12)), onTap: (){setState(() => _ckbDescuento = !_ckbDescuento);},)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  GestureDetector(
                                    onTap: (){

                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 5.0, left: 8.0),
                                      child: Row(
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
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      // MyCheckbox(
                                      //   useTapTarget: false,
                                      //   value: _ckbMessage,
                                      //   onChanged: _ckbMessageChanged,
                                      // ),
                                      SizedBox(
                                        width: 10,
                                        height: 8,
                                        child: Checkbox(
                                          // useTapTarget: false,
                                          value: _ckbMessage,
                                          onChanged: _ckbMessageChanged,
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      GestureDetector(child: Icon(Icons.message, color: Colors.blue,), onTap: (){_ckbMessageChanged(!_ckbMessage);},)
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      // MyCheckbox(
                                      //   useTapTarget: false,
                                      //   value: _ckbWhatsapp,
                                      //   onChanged: _ckbWhatsappChanged,
                                      // ),
                                      SizedBox(
                                        width: 10,
                                        height: 8,
                                        child: Checkbox(
                                          // useTapTarget: false,
                                          value: _ckbWhatsapp,
                                          onChanged: _ckbWhatsappChanged,
                                        ),
                                      ),
                                      // PreferredSize(
                                      //   preferredSize: Size.fromWidth(5),
                                      //   child: Checkbox(
                                      //     // useTapTarget: false,
                                      //     materialTapTargetSize: MaterialTapTargetSize.padded,
                                      //     value: _ckbWhatsapp,
                                      //     onChanged: _ckbWhatsappChanged,
                                      //     visualDensity: VisualDensity.lerp(VisualDensity.compact, VisualDensity.compact, VisualDensity.minimumDensity),
                                      //   ),
                                      // ),
                                      SizedBox(width: 5,),
                                      GestureDetector(child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, ), onTap: (){ _ckbWhatsappChanged(!_ckbWhatsapp);},)
                                    ],
                                  ),
                                
                                        
                                      
                                ],
                              ),
                              
                              SizedBox(height: 8,),
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
                                            _buildButton(Text('.', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 4, 5),
                                            _buildButton(Text('S', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 4, 5),
                                            _buildButton(Text('D', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 4, 5),
                                            _buildButton(Icon(Icons.backspace, size: ((constraints.maxHeight - 25) / 5), color: _colorPrimary,), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 4, 5),
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
                                            _buildButton(Text('7', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                            _buildButton(Text('8', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                            _buildButton(Text('9', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                            _buildButton(Text('/', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 4, 5),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            _buildButton(Text('4', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                            _buildButton(Text('5', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                            _buildButton(Text('6', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                            _buildButton(Text('-', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 4, 5),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            _buildButton(Text('1', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                            _buildButton(Text('2', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                            _buildButton(Text('3', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 4, 5),
                                            _buildButton(Text('+', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 4, 5),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            _buildButton(Text('0', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight , 2, 5),
                                            _buildButton(Text('ENTER', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight , 2, 5),
                                          ],
                                        )
                                      ],
                                    );
                                  }
                                ),
                                ),
                              ),
                              Expanded(
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
                                              icon: Icon(Icons.print, color: Colors.blue, size: 38),
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
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              );
              
  }
  
  _myJugadasScreen(){
    return Column(
                children: <Widget>[
                  SizedBox(height: 8,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      child: Text('Eliminar todas'),
                      onPressed: (){
                        setState((){
                          listaJugadas.clear();
                          listaEstadisticaJugada.clear();
                        });
                      },
                    ),
                  ),
                  StreamBuilder<List<Jugada>>(
                    stream: _streamControllerJugada.stream,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                      listaJugadas = snapshot.data;

                        return _buildTable(listaJugadas);
                      }else{
                        return _buildTable([]);
                      }
                      
                    },
                  ),
                ],
              );
            
  }
  @override
  build(BuildContext context) {
    return  
      (_cargandoDatosSesionUsuario)
      ?
      SplashScreen()
      :
      DefaultTabController(
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
            drawer: SafeArea(
              child: Drawer(
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
                    ListTile(
                      title: Text('Screen size test'),
                      leading: Icon(Icons.dashboard),
                      dense: true,
                      onTap: (){
                        Navigator.of(context).pushNamed("/screensizetest");
                        _scaffoldKey.currentState.openEndDrawer();
                      },
                    ),
                    ListTile(
                      title: Text('Bancas'),
                      leading: Icon(Icons.dashboard),
                      dense: true,
                      onTap: (){
                        Navigator.of(context).pushNamed("/bancas");
                        _scaffoldKey.currentState.openEndDrawer();
                      },
                    ),
                    ListTile(
                      title: Text('Loterias'),
                      leading: Icon(Icons.dashboard),
                      dense: true,
                      onTap: (){
                        Navigator.of(context).pushNamed("/loterias");
                        _scaffoldKey.currentState.openEndDrawer();
                      },
                    ),
                    ListTile(
                      title: Text('Usuarios'),
                      leading: Icon(Icons.dashboard),
                      dense: true,
                      onTap: (){
                        Navigator.of(context).pushNamed("/usuarios");
                        _scaffoldKey.currentState.openEndDrawer();
                      },
                    ),
                    ListTile(
                      title: Text('Grupos'),
                      leading: Icon(Icons.dashboard),
                      dense: true,
                      onTap: (){
                        Navigator.of(context).pushNamed("/grupos");
                        _scaffoldKey.currentState.openEndDrawer();
                      },
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
                    Visibility(
                      visible: _tienePermisoVerListaDeBalancesDeBancass,
                      child: ListTile(
                        title: Text('Balance bancas'),
                        leading: Icon(Icons.account_balance),
                        dense: true,
                        onTap: (){
                          Navigator.of(context).pushNamed("/balanceBancas");
                          _scaffoldKey.currentState.openEndDrawer();
                        },
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
                      onTap: () async {
                        Map<String, dynamic> datos = await Principal.showDialogDuplicarFormulario(context: context, scaffoldKey: _scaffoldKey);
                        _scaffoldKey.currentState.openEndDrawer();
                        if(datos.isNotEmpty){
                          await _duplicar(datos);
                        }
                        // print("prueba alertdialog: $prueba");
                      },
                    ),
                    Visibility(
                      visible: _tienePermisoMarcarTicketComoPagado,
                      child: ListTile(
                        title: Text("Pagar"),
                        leading: Icon(Icons.payment),
                        dense: true,
                        onTap: () async {
                          dynamic datos = await Principal.showDialogPagarFormulario(scaffoldKey: _scaffoldKey, context: context);
                          _scaffoldKey.currentState.openEndDrawer();
                          if(datos.isNotEmpty){
                            print("Heyyyyyyyyyyyyyyy: ${datos["venta"]["montoAPagar"]}");
                            Principal.showDialogPagar(context: context, scaffoldKey: _scaffoldKey, mapVenta: datos["venta"]);
                          }
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
                    ListTile(
                      title: Text('Cerrar sesion'),
                      dense: true,
                      leading: Icon(Icons.clear),
                      onTap: () async {
                        
                        Principal.cerrarSesion(context);
                        await stopSocketNoticacionInForeground();
                      },
                    )
                  ],
                ),

              ),
            ),
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
            ),
        ),
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
    print("_convertirHoraCierreLoteria currentTImeZone: $currentTimeZone");
    print("hora actual currentTimeZone: ${fechaLoteriaCurrentTimeZone.toString()} santoDomingo: ${fechaLoteriaRD.toString()}");

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
        return Text("${remaining.inMinutes} minutos restantes", style: TextStyle(fontSize: 12, color: Colors.red));
      // else{
      //   format = DateFormat("ss");
      //   return Text("${remaining.inSeconds} segundos restantes", style: TextStyle(fontSize: 12, color: Colors.red));
      // }
    }
    else if(remaining.inHours == 0 && remaining.inSeconds > 0)
        return Text("${remaining.inSeconds} segundos restantes", style: TextStyle(fontSize: 12, color: Colors.red));
    else if(remaining.inHours <= 0 && remaining.inSeconds <= 0)
        return Text("Cerrada", style: TextStyle(fontSize: 12, color: Colors.red));
    else{
      format = new DateFormat('hh:mm a');
    // print("Cerrado _getLoteriaRemainingTime: m:${remaining.inMinutes} s:${remaining.inSeconds}");

      // dateString = "${format.format(convertirHoraCierreLoteriaAHoraCierreCurrentTimeZone)}";
      return Text("${format.format(convertirHoraCierreLoteriaAHoraCierreCurrentTimeZone)}", style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.5)));
    }
    dateString = '${remaining.inHours}:${format.format(DateTime.fromMillisecondsSinceEpoch(remaining.inMilliseconds))}';
    // return dateString;
  }

  StreamBuilder _getLoteriaStream(Loteria loteria){
    

    return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 1), (i) => i),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        String dateString = "";
        print(dateString);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${loteria.descripcion}"),
            // Text(dateString, style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.5) ))
            _getLoteriaRemainingTime(loteria)
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

  StreamBuilder _getSelectedLoteriaStream(){
    

    return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 1), (i) => i),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        String dateString = "";
        print(dateString);
        if(_selectedLoterias == null)
          return Text(Principal.loteriasSeleccionadasToString(_selectedLoterias), style: TextStyle(color: _colorSegundary),);

        if(_selectedLoterias.length > 1 || _selectedLoterias.length == 0)
          return Text(Principal.loteriasSeleccionadasToString(_selectedLoterias), style: TextStyle(color: _colorSegundary),);

        return Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("${_selectedLoterias[0].descripcion}"),
            Text(Principal.loteriasSeleccionadasToString(_selectedLoterias), style: TextStyle(color: _colorSegundary),),
            // Text(dateString, style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.5) ))
            _getLoteriaRemainingTime(_selectedLoterias[0])
          ],
        );
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
              lista = List();
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

    _selectedLoterias = List();
    if(selectedValues != null){
      final selectedValuesMap = selectedValues.toList().asMap();
      for(int c=0; c < selectedValuesMap.length; c++){
        print("Principal selectedLoterias: ${ selectedValuesMap[c]}");
        print("Principal selectedLoterias: ${ listaLoteria.firstWhere((l) => l.id == selectedValuesMap[c], orElse: () => null)}");
        Loteria data = listaLoteria.firstWhere((l) => l.id == selectedValuesMap[c], orElse: () => null);
        if(data != null)
          _selectedLoterias.add(data);
      }
    }
    // print(_selectedLoterias.length);
  }

  

  SizedBox _buildButton(Widget text_or_icon, var color, double height, int countWidth, int countHeight){
    return SizedBox(
        width: MediaQuery.of(context).size.width / countWidth,
        height: height / countHeight,
        child: RaisedButton(
          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: .3)),
          elevation: 0,
          color: color,
          onPressed: (){
            if(text_or_icon is Text){
              print('es tipo: ${text_or_icon.data}');
              _escribir(text_or_icon.data);
            }else{
              print('Nooo es tipo');
              _escribir('backspace');
            }
          },
          child: Center(child: text_or_icon),
        ),
      );
  }

  Future<void> _escribir(String caracter) async {
    print("Hey: $caracter");
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
          setState(() => _jugadaOmonto = !_jugadaOmonto);
        }
        else{
          addJugada(jugada: Utils.ordenarMenorAMayor(_txtJugada.text), montoDisponible: _txtMontoDisponible.text, monto: _txtMonto.text, selectedLoterias: _selectedLoterias);
        }
      }
      return;
    }

    if(_txtJugada.text.length == 0 && caracter == '-'){
      guardar();
      return;
    }

    if(_jugadaOmonto){
      if(caracter == 'backspace'){
        setState(() => _txtJugada.text = (_txtJugada.text.length > 0) ? _txtJugada.text.substring(0, (_txtJugada.text).length - 1) : _txtJugada.text);
        return;
      }
      else if(_txtJugada.text.length < 6 || (_txtJugada.text.length == 6 && caracter == ".")){
        if(esCaracterEspecial(caracter) == false)
          _txtJugada.text = _txtJugada.text + caracter;
        else{
          if(caracter == '+'){
            ponerSignoMas();
          }
          if(caracter == '-'){
            ponerSignoMenos();
          }
          if(caracter == 'S'){
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

  _combinarJugadas(){
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

      addJugada(jugada: Utils.ordenarMenorAMayor((combinacionesJugadas[i])), montoDisponible: montoJugada.toString(), monto: _txtMonto.text, selectedLoterias: _selectedLoterias);
      // print("Combinaciones retornadas for despues: ${combinacionesJugadas[i]}");
    
    }
  }

  _showLigarDialog() async {
    setState((){
      _ckbLigarPale = true;
      _ckbLigarTripleta = false;
    });

    _txtLoteriasSeleccionadasParaLigar.text = "";
    _txtMontoLigar.text = "";
    List<Loteria> _selectedLoteriasLigar = List();

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
              title: Text("Ligar pale y tripleta"),
              content: Container(
                height: 180,
                child: Form(
                  key: _formLigarKey,
                  child: Column(children: <Widget>[
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
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      validator: (data){
                        if(data.isEmpty)
                          return 'No tiene datos';

                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(children: <Widget>[
                        //   MyCheckbox(
                        //   useTapTarget: false,
                        //   value: _ckbLigarPale,
                        //   onChanged: (newValue){
                        //     setState(() {
                        //     _ckbLigarPale = newValue; 
                        //     });
                        //   },
                        // ),
                        SizedBox(
                          width: 10,
                          height: 8,
                          child: Checkbox(
                            // useTapTarget: false,
                            value: _ckbLigarPale,
                            onChanged: (newValue){
                              setState(() {
                              _ckbLigarPale = newValue; 
                              });
                            },
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
                        GestureDetector(child: Text('Pale', ), onTap: (){setState(() => _ckbLigarPale = !_ckbLigarPale);},)
                        ],),
                        Row(children: <Widget>[
                        //   MyCheckbox(
                        //   useTapTarget: false,
                        //   value: _ckbLigarTripleta,
                        //   onChanged: (newValue){
                        //     setState(() {
                        //     _ckbLigarTripleta = newValue; 
                        //     });
                        //   },
                        // ),
                        SizedBox(
                          width: 10,
                          height: 8,
                          child: Checkbox(
                            // useTapTarget: false,
                            value: _ckbLigarTripleta,
                            onChanged: (newValue){
                              setState(() {
                              _ckbLigarTripleta = newValue; 
                              });
                            },
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
                        GestureDetector(child: Text('Tripleta', ), onTap: (){setState(() => _ckbLigarTripleta = !_ckbLigarTripleta);},)
                        ],)
                        
                      ],
                    ),
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
                  onPressed: (){
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
                      _ligarDirectosEnPale(_selectedLoteriasLigar, Utils.toDouble(_txtMontoLigar.text));
                      
                    }
                    
                    if(_ckbLigarTripleta){
                      // Navigator.pop(context);
                      _ligarDirectosEnTripleta(_selectedLoteriasLigar, Utils.toDouble(_txtMontoLigar.text));
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

  _ligarDirectosEnPale(List<Loteria> loteriasSeleccionadas, double monto){
    var listaJugadasLigadas = List<String>();
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
    print("dentro _ligarPale");

    //Obtenemos el objeto loteria con el idLoteria obtenido en el for de arriba
    // Loteria loteria = listaLoteria.firstWhere((element) => element.id == idLoteria);
    // List<Loteria> lista = List();
    // if(loteria == null)
    //   return;

    //Agregamos la loteria a la lista
    // lista.add(loteria);

    //Agregamos las jugadas ligadas
    for(int i=0; i < listaJugadasLigadas.length; i++){
      addJugada(jugada: Utils.ordenarMenorAMayor((listaJugadasLigadas[i])), montoDisponible: monto.toString(), monto: monto.toString(), selectedLoterias: loteriasSeleccionadas);
    }

  }

  _ligarDirectosEnTripleta(List<Loteria> loteriasSeleccionadas, double monto){
    var listaJugadasLigadas = List<String>();
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
    print("dentro _ligarTripleta");

    //Obtenemos el objeto loteria con el idLoteria obtenido en el for de arriba
    // Loteria loteria = listaLoteria.firstWhere((element) => element.id == idLoteria);
    // List<Loteria> lista = List();
    // if(loteria == null)
    //   return;

    //Agregamos la loteria a la lista
    // lista.add(loteria);

    //Agregamos las jugadas ligadas
    for(int i=0; i < listaJugadasLigadas.length; i++){
      addJugada(jugada: Utils.ordenarMenorAMayor((listaJugadasLigadas[i])), montoDisponible: monto.toString(), monto: monto.toString(), selectedLoterias: loteriasSeleccionadas);
    }

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

  ponerSignoMas(){
    if(_txtJugada.text.indexOf('+') != -1)
      return;

    if(_txtJugada.text.length != 3 && _txtJugada.text.length != 4)
      return;
    
    _txtJugada.text = _txtJugada.text + '+';
    setState(() => _jugadaOmonto = !_jugadaOmonto);
    changeMontoDisponibleFromTxtMontoDisponible();
    
  }

  ponerSignoMenos(){
    if(_txtJugada.text.indexOf('-') != -1)
      return;

    if(_txtJugada.text.length != 4)
      return;
    
    _txtJugada.text = _txtJugada.text + '-';
    setState(() => _jugadaOmonto = !_jugadaOmonto);
    changeMontoDisponibleFromTxtMontoDisponible();
    
  }

  ponerSignoS(){
    if(_txtJugada.text.indexOf('s') != -1)
      return;

    if(_txtJugada.text.length != 4)
      return;
    if(_selectedLoterias.length < 2){
      Utils.showSnackBar(content: "Debe seleccionar dos o mas loterias para super pale", scaffoldKey: _scaffoldKey);
      return;
    }
    
    _txtJugada.text = _txtJugada.text + 's';
    setState(() => _jugadaOmonto = !_jugadaOmonto);
    changeMontoDisponibleFromTxtMontoDisponible();
    
  }

  ponerPunto() async {
    if(_txtJugada.text.indexOf('.') != -1)
      return;

    if(_txtJugada.text.length != 2 && _txtJugada.text.length != 4 && _txtJugada.text.length != 6)
      return;
    
    setState(() => _jugadaOmonto = !_jugadaOmonto);
    await changeMontoDisponibleFromTxtMontoDisponible();
    _txtJugada.text = _txtJugada.text + '.';
  }


  addJugada({String jugada, String montoDisponible, String monto, List<Loteria> selectedLoterias, Map<String, dynamic> loteriaMap, Map<String, dynamic> jugadaMap}) async {
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
      double montoDisponibleOtraVez = await getMontoDisponible(Utils.ordenarMenorAMayor(jugada), _selectedLoterias[0], await _selectedBanca());
      if(Utils.toDouble(monto) > montoDisponibleOtraVez){
        _showSnackBar('No hay monto suficiente');
          return;
      }

      insertarJugada(jugada: jugada, loteria: selectedLoterias[0], monto: monto);
      _streamControllerJugada.add(listaJugadas);
      _txtJugada.text = '';
      _txtMontoDisponible.text = '';
      
      // setState(() => _jugadaOmonto = true);
    }
    else if(_selectedLoterias.length >= 2 && Utils.esSuperpale(jugada)){
     

      var banca = await _selectedBanca();
      //Ordenamos las loterias seleccionadas de menor a mayor basedo en su id
      _selectedLoterias.sort((a, b) => a.id.compareTo(b.id));

      // VALIDAMOS DE QUE HAYA MONTO DISPONIBLE
      for(int i=0; i < _selectedLoterias.length; i++){
        for(int i2=i + 1 ; i2 < _selectedLoterias.length; i2++){
          double montoDisponibleOtraVez = await getMontoDisponible(Utils.ordenarMenorAMayor(jugada), _selectedLoterias[i], banca, _selectedLoterias[i2]);
          if(Utils.toDouble(monto) > montoDisponibleOtraVez){
            _showSnackBar('No hay monto suficiente');
              return;
          }
        }
      }

      // INSERTAMOS LOS SUPER PALE
      for(int i=0; i < _selectedLoterias.length; i++){
        for(int i2=i + 1 ; i2 < _selectedLoterias.length; i2++){
          insertarJugadaSuperpale(jugada: jugada, loteria: _selectedLoterias[i], loteriaSuperpale: _selectedLoterias[i2], monto: monto);
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
      for (var l in selectedLoterias) {
        double montoDisponibleOtraVez = await getMontoDisponible(Utils.ordenarMenorAMayor(jugada), l, banca);
        if(Utils.toDouble(monto) > montoDisponibleOtraVez){
          _showSnackBar('No hay monto suficiente');
            return;
        }
      }

      // INSERTAMOS LAS LOTERIAS
      for (var l in selectedLoterias) {
        insertarJugada(jugada: jugada, loteria: l, monto: monto);
      }

      _streamControllerJugada.add(listaJugadas);
      _txtJugada.text = '';
      _txtMontoDisponible.text = '';

    }

          
    setState(() => _jugadaOmonto = !_jugadaOmonto);

  }


  hayJugadasSuciasNuevo() async {
    Banca banca = await _selectedBanca();
    

    for(int i=0; i < listaEstadisticaJugada.length; i++){
      var query = await  Db.database.query('Blocksdirty' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idMoneda" = ?', whereArgs: [banca.id, listaEstadisticaJugada[i].idLoteria, listaEstadisticaJugada[i].idSorteo, banca.idMoneda], orderBy: '"id" desc' );
      if(query.isEmpty)
        query = await  Db.database.query('Blocksdirtygenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idMoneda" = ?', whereArgs: [listaEstadisticaJugada[i].idLoteria, listaEstadisticaJugada[i].idSorteo, banca.idMoneda], orderBy: '"id" desc' );
      print("hayJugadasSuciasNuevo query: $query");
      print("hayJugadasSuciasNuevo estadisticaJugada: ${listaEstadisticaJugada[i].toJson()}");
      if(query.isNotEmpty){
        if(listaEstadisticaJugada[i].cantidad > query.first["cantidad"]){
          Utils.showAlertDialog(context: context, title: "Jugadas sucias", content: "Hay jugadas sucias en la loteria ${listaEstadisticaJugada[i].descripcion}, comuniquese con el administrador o esta banca sera monitoreada y si se encuentran jugadas sucias pues se tomaran medidas severas contra usted.");
          return true;
        }
      }
    }
    
    return false;
  }

  hayJugadasSucias({String jugada, Loteria loteria, Loteria loteriaSuperpale}) async {
    Banca banca = await _selectedBanca();
    Draws sorteo = await getSorteo(jugada) ;
    if(sorteo == null)
      return;

    var query = await  Db.database.query('Blocksdirty' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, sorteo.id, banca.idMoneda], orderBy: '"id" desc' );
    if(query.isEmpty)
      query = await  Db.database.query('Blocksdirtygenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idMoneda" = ?', whereArgs: [loteria.id, sorteo.id, banca.idMoneda], orderBy: '"id" desc' );
    
    if(query.isEmpty)
      return false;

    print("hayJugadasSucias query: ${sorteo.id}");
    if(sorteo.descripcion == "Directo"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 2 && e.idLoteria == loteria.id).length;
      if(tamanoJugadas >= query.first["cantidad"])
        return true;

      print("hayJugadasSucias tam: $tamanoJugadas");
    }
    if(sorteo.descripcion == "Pale"){
      int tamanoJugadas = listaJugadas.where((e) => Utils.toInt(e.jugada) != 0 && e.idLoteria == loteria.id).length;
      if(tamanoJugadas >= query.first["cantidad"])
        return true;
    }
    if(sorteo.descripcion == "Tripleta"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 6 && e.idLoteria == loteria.id).length;
      if(tamanoJugadas >= query.first["cantidad"])
        return true;
    }
    if(sorteo.descripcion == "Pick 3 Straight"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 3 && e.idLoteria == loteria.id).length;
      if(tamanoJugadas >= query.first["cantidad"])
        return true;
    }
    if(sorteo.descripcion == "Pick 3 Box"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 4 && e.jugada.indexOf("+") != -1 && e.idLoteria == loteria.id).length;
      if(tamanoJugadas >= query.first["cantidad"])
        return true;
    }
    if(sorteo.descripcion == "Pick 4 Box"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 5 && e.jugada.indexOf("+") != -1 && e.idLoteria == loteria.id).length;
      if(tamanoJugadas >= query.first["cantidad"])
        return true;
    }
    if(sorteo.descripcion == "Pick 4 Straight"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 5 && e.jugada.indexOf("-") != -1 && e.idLoteria == loteria.id).length;
      if(tamanoJugadas >= query.first["cantidad"])
        return true;
    }
    if(sorteo.descripcion == "Super pale"){
      int tamanoJugadas = listaJugadas.where((e) => e.jugada.length == 5 && e.jugada.indexOf("s") != -1 && e.idLoteria == loteria.id && e.idLoteriaSuperpale == loteriaSuperpale.id).length;
      if(tamanoJugadas >= query.first["cantidad"])
        return true;
    }

    return false;
  }

  insertarJugada({String jugada, Loteria loteria, String monto}) async {

    
    
    int idx = (listaJugadas.isEmpty == false) ? listaJugadas.indexWhere((j) => j.jugada == jugada && j.idLoteria == loteria.id) : -1;
      if(idx != -1){
        showDialog(
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
        Draws _sorteo = await getSorteo(jugada);
        listaJugadas.add(Jugada(
          jugada: jugada,
          idLoteria: loteria.id,
          monto: Utils.redondear(Utils.toDouble(monto), 2),
          descripcion: loteria.descripcion,
          loteria: loteria,
          idBanca: 0,
          idSorteo: _sorteo.id,
          sorteo: _sorteo.descripcion
        ));
        await addOrUpdateEstadisticaJugada(jugada: jugada, loteria: loteria, sorteo: _sorteo);
      }
  }

  insertarJugadaSuperpale({String jugada, Loteria loteria, Loteria loteriaSuperpale, String monto}) async {
     
      if(loteria.id > loteriaSuperpale.id){
        Loteria tmp = loteriaSuperpale;
        loteriaSuperpale = loteria;
        loteria = tmp;
      }

      int idx = (listaJugadas.isEmpty == false) ? listaJugadas.indexWhere((j) => j.jugada == jugada && j.idLoteria == loteria.id && j.idLoteriaSuperpale == loteriaSuperpale.id) : -1;
      if(idx != -1){
        showDialog(
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
        Draws _sorteo = await getSorteo(jugada);
        listaJugadas.add(Jugada(
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
          sorteo: _sorteo.descripcion
        ));

        await addOrUpdateEstadisticaJugada(jugada: jugada, loteria: loteria, sorteo: _sorteo);
      }
  }

  insertarJugadaDuplicar(Map<String, dynamic> loteriaMap, Map<String, dynamic> jugada) async {
    if(jugada["idSorteo"] != 4){
      double montoDisponibleOtraVez = await getMontoDisponible(Utils.ordenarMenorAMayor(jugada["jugada"]), Loteria.fromMap(loteriaMap), await _selectedBanca());
      if(Utils.toDouble(jugada["monto"]) > montoDisponibleOtraVez){
        _showSnackBar('No hay monto suficiente');
          return;
      }

      print("insertarJugadaDuplicar jugada: ${jugada}");

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

        Draws _sorteo = await getSorteo(jugada["jugada"]);
        listaJugadas.add(Jugada(
          jugada: jugada["jugada"],
          idLoteria: loteriaMap["id"],
          loteria: Loteria.fromMap(loteriaMap),
          monto: Utils.redondear(Utils.toDouble(jugada["monto"]), 2),
          descripcion: loteriaMap["descripcion"],
          idBanca: 0,
          idSorteo: _sorteo.id,
          sorteo: _sorteo.descripcion
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

      double montoDisponibleOtraVez = await getMontoDisponible(Utils.ordenarMenorAMayor(jugada["jugada"]), loteria, await _selectedBanca(), loteriaSuperpale);
      if(Utils.toDouble(jugada["monto"]) > montoDisponibleOtraVez){
        _showSnackBar('No hay monto suficiente');
          return;
      }

      print("insertarJugadaDuplicar jugadaSuperpale: ${jugada["jugada"]}");
      print("insertarJugadaDuplicar superpale: ${loteriaSuperpale.toJson()}");
      print("insertarJugadaDuplicar normal: ${loteria.toJson()}");

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
        Draws _sorteo = await getSorteo(jugada["jugada"]);
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
          sorteo: _sorteo.descripcion
        );
        await addOrUpdateEstadisticaJugada(jugada: jugada["jugada"], loteria: loteria, sorteo: _sorteo);
        print("insertarJugadaDuplicar superpale jugada: ${j.toJson()}");
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
    Draws sorteo = await getSorteo(jugada);
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

          
    setState(() => _jugadaOmonto = !_jugadaOmonto);

  }

  _showSnackBar(String content){
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(content),
        action: SnackBarAction(label: 'CERRAR', onPressed: () => _scaffoldKey.currentState.hideCurrentSnackBar(),),
      ));
  }

  _seleccionarPrimeraLoteria(){
    if(listaLoteria == null)
      return;

    if(listaLoteria.length == 0)
      return;

    _selectedLoterias = List();
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
        _selectedLoterias = List();
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
    print('_seleccionarBancaPertenecienteAUsuario idx: $idx : ${listaBanca.length}');
    setState(() {
      _indexBanca = (idx != -1) ? idx : 0;
      _emitToGetNewIdTicket();
    });
  }else{
    setState(() {
      _indexBanca = 0;
      print("_seleccionarBancaPertenecienteAUsuario listaBanca: ${listaBanca.length}");
      _emitToGetNewIdTicket();
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
              Center(child: _buildRichOrTextAndConvertJugadaToLegible(j.jugada)),
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

 _buildRichOrTextAndConvertJugadaToLegible(String jugada){
   if(jugada.length == 4 && jugada.indexOf('+') == -1 && jugada.indexOf('-') == -1){
     return Text(jugada.substring(0, 2) + '-' + jugada.substring(2, 4), style: TextStyle(fontSize: 16));
   }
   else if(jugada.length == 3){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.substring(0, 3)),
           TextSpan(text: 'S', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
   else if(jugada.length == 4 && jugada.indexOf('+') != -1){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.substring(0, 3)),
           TextSpan(text: 'B', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
   else if(jugada.length == 5 && jugada.indexOf('+') != -1){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.substring(0, 4)),
           TextSpan(text: 'B', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
   else if(jugada.length == 5 && jugada.indexOf('-') != -1){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.substring(0, 4)),
           TextSpan(text: 'S', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
  else if(jugada.length == 6){
     return Text(jugada.substring(0, 2) + '-' + jugada.substring(2, 4) + '-' + jugada.substring(4, 6), style: TextStyle(fontSize: 16));
  }

   return Text(jugada, style: TextStyle(fontSize: 16));
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
     montoDisponible = await getMontoDisponible(Utils.ordenarMenorAMayor(_txtJugada.text), _selectedLoterias[0], await _selectedBanca());
     setState(() {
      _txtMontoDisponible.text =  montoDisponible.toString();
     });
   }else if(_selectedLoterias.length > 1){
     if(_selectedLoterias.length == 2 && _txtJugada.text.toString().substring(_txtJugada.text.length - 1) == "s"){
       montoDisponible = await getMontoDisponible(Utils.ordenarMenorAMayor(_txtJugada.text), _selectedLoterias[0], await _selectedBanca(), _selectedLoterias[1]);
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
 

 Future<double> getMontoDisponible(String jugada, Loteria loteria, Banca banca, [Loteria loteriaSuperpale]) async {
    
    var montoDisponible = null;
    
    if(socket == null){
      Utils.showAlertDialog(context: context, content: "No hay conexion, verifique por favor", title: "Error");
      return 0;
    }
    if(!socket.connected){
      Utils.showAlertDialog(context: context, content: "No hay conexion, verifique por favor", title: "Error");
      return 0;
    }

    int idDia = getIdDia();
    int idSorteo = await getIdSorteo(jugada, loteria);
    String jugadaConSigno = jugada;
    jugada = await esSorteoPickQuitarUltimoCaracter(jugada, idSorteo);

    if(idSorteo != 4){
      List<Map<String, dynamic>> query = await Db.database.query('Stocks' , where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, 0, banca.idMoneda]);

      if(query.isEmpty != true)
        montoDisponible = query.first['monto'];
        
      
      if(montoDisponible != null){
        query = await Db.database.query('Stocks' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "ignorarDemasBloqueos" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, 1, 1, banca.idMoneda]);
        if(query.isEmpty != true){
          montoDisponible = query.first['monto'];
        }else{
          
          //Ahora nos aseguramos de que el bloqueo general existe y el valor de ignorarDemasBloqueos sea = 1
          query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          if(query.isEmpty != true){
            var first = query.first;
            if(first["ignorarDemasBloqueos"] == 1)
              montoDisponible = first["monto"];
          }
        }
      }


      //AQUI ES CUANDO EXISTE BLOQUEO GENERAL EN STOCKS
      if(montoDisponible == null){
          query = await Db.database.query('Stocks' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda]);
        if(query.isEmpty != true){
          //SI IGNORARDEMASBLOQUEOS ES FALSE ENTONCES VAMOS A VERIFICAR SI EXISTEN BLOQUEOS POR BANCAS YA SEAN DE JUGADAS PARA RETORNAR ESTOS BLOQUEOS
          var stock = query.first;
          if(stock["ignorarDemasBloqueos"] == 0){
            query = await Db.database.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
            }else{
              query = await Db.database.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
              if(query.isEmpty != true){
                montoDisponible = query.first["monto"];
              }
              else
                montoDisponible = stock["monto"];
            }
          }else{
            montoDisponible = stock["monto"];
          }
        }
      }

      

      if(montoDisponible == null){
        query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
        if(query.isEmpty != true){
          var blocksplaysgenerals = query.first;
          if(blocksplaysgenerals["ignorarDemasBloqueos"] == 0){
            montoDisponible = null;
          }else{
            montoDisponible = blocksplaysgenerals["monto"];
          }
        }

// query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ?', whereArgs: [1], orderBy: '"id" desc' );
        // print("Monto disponible blocksplaysgenrals: $query");

        if(montoDisponible == null){
          query = await Db.database.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          if(query.isEmpty != true){
            montoDisponible = query.first["monto"];
          }else{
            query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            if(query.isEmpty != true)
              montoDisponible = query.first["monto"];
          }

          if(montoDisponible == null){
            query = await Db.database.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
            }
          }

          if(montoDisponible == null){
            query = await Db.database.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda]);
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
            }
          }

          // print('montoDisponiblePrueba idSorteo: lot: $loteria.id sor: $idSorteo dia: $idDia res:${blocksgenerals.indexWhere((b) => b.idLoteria == loteria.id && b.idDia == idDia && b.idSorteo == idSorteo)} prueba:${Blocksgenerals.blocksgeneralsToJson(blocksgenerals.where((b) => b.idLoteria == loteria.id && b.idSorteo == idSorteo).toList())}');
        }
      }
    }else{
      // MONTO SUPER PALE
      // Debo ordenar de menor a mayor los idloteria y idloteriaSuperpale, 
      // el idLoteria tendra el numero menor y el idLoteriaSuper tendra el numero mayor

      if(loteria.id > loteriaSuperpale.id){
        Loteria tmp = loteriaSuperpale;
        loteriaSuperpale = loteria;
        loteria = tmp;
      }
      List<Map<String, dynamic>> query = await Db.database.query('Stocks' , where: '"idBanca" = ? and "idLoteria" = ? and "idLoteriaSuperpale" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, loteriaSuperpale.id, idSorteo, jugada, 0, banca.idMoneda]);
      
      print("getMontoDisponible super pale: $query");

      if(query.isEmpty != true)
        montoDisponible = query.first['monto'];
        
      
      if(montoDisponible != null){
        query = await Db.database.query('Stocks' ,where: '"idLoteria" = ? and "idLoteriaSuperpale" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "ignorarDemasBloqueos" = ? and "idMoneda" = ?', whereArgs: [loteria.id, loteriaSuperpale.id, idSorteo, jugada, 1, 1, banca.idMoneda]);
        if(query.isEmpty != true){
          montoDisponible = query.first['monto'];
        }else{
          
          //Ahora nos aseguramos de que el bloqueo general existe y el valor de ignorarDemasBloqueos sea = 1
          query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          if(query.isEmpty != true){
            var first = query.first;
            if(first["ignorarDemasBloqueos"] == 1)
              montoDisponible = first["monto"];
          }
        }
      }


      //AQUI ES CUANDO EXISTE BLOQUEO GENERAL EN STOCKS
      if(montoDisponible == null){
          query = await Db.database.query('Stocks' ,where: '"idLoteria" = ? and "idLoteriaSuperpale" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, loteriaSuperpale.id, idSorteo, jugada, banca.idMoneda]);
        if(query.isEmpty != true){
          //SI IGNORARDEMASBLOQUEOS ES FALSE ENTONCES VAMOS A VERIFICAR SI EXISTEN BLOQUEOS POR BANCAS YA SEAN DE JUGADAS PARA RETORNAR ESTOS BLOQUEOS
          var stock = query.first;
          if(stock["ignorarDemasBloqueos"] == 0){
            query = await Db.database.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
            }else{
              query = await Db.database.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
              if(query.isEmpty != true){
                montoDisponible = query.first["monto"];
              }
              else
                montoDisponible = stock["monto"];
            }
          }else{
            montoDisponible = stock["monto"];
          }
        }
      }

      

      if(montoDisponible == null){
        query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
        if(query.isEmpty != true){
          var blocksplaysgenerals = query.first;
          if(blocksplaysgenerals["ignorarDemasBloqueos"] == 0){
            montoDisponible = null;
          }else{
            montoDisponible = blocksplaysgenerals["monto"];
          }
        }

        if(montoDisponible == null){
          query = await Db.database.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          if(query.isEmpty != true){
            montoDisponible = query.first["monto"];
          }else{
            query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            if(query.isEmpty != true)
              montoDisponible = query.first["monto"];
          }

          if(montoDisponible == null){
            query = await Db.database.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
            }
          }

          if(montoDisponible == null){
            query = await Db.database.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda]);
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
            }
          }

          // print('montoDisponiblePrueba idSorteo: lot: $loteria.id sor: $idSorteo dia: $idDia res:${blocksgenerals.indexWhere((b) => b.idLoteria == loteria.id && b.idDia == idDia && b.idSorteo == idSorteo)} prueba:${Blocksgenerals.blocksgeneralsToJson(blocksgenerals.where((b) => b.idLoteria == loteria.id && b.idSorteo == idSorteo).toList())}');
        }
      }
    }

    // setState(() {
    //  _txtMontoDisponible.text = montoDisponible.toString(); 
    // });
    // print('montoDisponiblePrueba idSorteo: $montoDisponible');

  
    int idx = -1;
    if(idSorteo == 4)
      idx = listaJugadas.indexWhere((j) => j.idLoteria == loteria.id && j.idLoteriaSuperpale == loteriaSuperpale.id && j.jugada == jugadaConSigno);
    else
      idx = listaJugadas.indexWhere((j) => j.idLoteria == loteria.id && j.jugada == jugadaConSigno);
      // _selectedLoterias[0].id
    // double montoDisponibleFinal = montoDisponible.toDouble();
    
    double montoDisponibleFinal = Utils.toDouble(montoDisponible.toString());
    if(idx != -1){
      print("encontrado: ${listaJugadas[idx].monto}");
      montoDisponibleFinal = montoDisponibleFinal - listaJugadas[idx].monto;
      print("encontrado y restado: ${montoDisponibleFinal}");
    }

    return montoDisponibleFinal;
   
 }

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
    int idSorteo = getIdSorteo(jugada, loteria);

    jugada = await esSorteoPickQuitarUltimoCaracter(jugada, idSorteo);
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

    print('montoDisponiblePrueba idSorteo: lot: $loteria.id sor: $idSorteo dia: $idDia res:${blocksgenerals.indexWhere((b) => b.idLoteria == loteria.id && b.idDia == idDia && b.idSorteo == idSorteo)} prueba:${Blocksgenerals.blocksgeneralsToJson(blocksgenerals.where((b) => b.idLoteria == loteria.id && b.idSorteo == idSorteo).toList())}');

        
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
 

 getIdSorteo(String jugada, Loteria loteria) async {
   int idSorteo = 0;

   if(jugada.length == 2)
    idSorteo = 1;
  else if(jugada.length == 3){
    // idSorteo = draws[draws.indexWhere((d) => d.descripcion == 'Pick 3 Straight')].id;
    var query = await Db.database.query('Draws', columns: ['id'], where:'"descripcion" = ?', whereArgs: ['Pick 3 Straight']);
    idSorteo = (query.isEmpty != true) ? query.first['id'] : 0;
  }
  else if(jugada.length == 4){
    if(jugada.indexOf("+") != -1){
      var query = await Db.database.query('Draws', columns: ['id'], where:'"descripcion" = ?', whereArgs: ['Pick 3 Box']);
      idSorteo = (query.isEmpty != true) ? query.first['id'] : 0;
    }else{
      idSorteo = 2;
      // List<Draws> sorteosLoteriaSeleccionada = loteria.sorteos;
      // if(sorteosLoteriaSeleccionada.indexWhere((s) => s.descripcion == 'Super pale') != -1){
      //   idSorteo = 4;
      // }else{
      //   idSorteo = 2;
      // }
    }
  }
  else if(jugada.length == 5){
    if(jugada.indexOf("+") != -1){
      var query = await Db.database.query('Draws', columns: ['id'], where:'"descripcion" = ?', whereArgs: ['Pick 4 Box']);
      idSorteo = (query.isEmpty != true) ? query.first['id'] : 0;
    }
    else if(jugada.indexOf("-") != -1){
       var query = await Db.database.query('Draws', columns: ['id'], where:'"descripcion" = ?', whereArgs: ['Pick 4 Straight']);
        idSorteo = (query.isEmpty != true) ? query.first['id'] : 0;
    }
    else if(jugada.indexOf("s") != -1){
       var query = await Db.database.query('Draws', columns: ['id'], where:'"descripcion" = ?', whereArgs: ['Super pale']);
        idSorteo = (query.isEmpty != true) ? query.first['id'] : 0;
    }
  }
  else if(jugada.length == 6)
    idSorteo = 3;

  return idSorteo;
 }

 getSorteo(String jugada) async {
    Draws sorteo;

   if(jugada.length == 2){
     var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Directo']);
     sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
   }
  else if(jugada.length == 3){
    // idSorteo = draws[draws.indexWhere((d) => d.descripcion == 'Pick 3 Straight')].id;
    var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Pick 3 Straight']);
    sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
  }
  else if(jugada.length == 4){
    if(jugada.indexOf("+") != -1){
      var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Pick 3 Box']);
      sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
    }else{
      var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Pale']);
      sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
      // List<Draws> sorteosLoteriaSeleccionada = loteria.sorteos;
      // if(sorteosLoteriaSeleccionada.indexWhere((s) => s.descripcion == 'Super pale') != -1){
      //   idSorteo = 4;
      // }else{
      //   idSorteo = 2;
      // }
    }
  }
  else if(jugada.length == 5){
    if(jugada.indexOf("+") != -1){
      var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Pick 4 Box']);
      sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
    }
    else if(jugada.indexOf("-") != -1){
      var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Pick 4 Straight']);
      sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
    }
    else if(jugada.indexOf("s") != -1){
      var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Super pale']);
      sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
    }
  }
  else if(jugada.length == 6){
    var query = await Db.database.query('Draws', columns: ['id', 'descripcion'], where:'"descripcion" = ?', whereArgs: ['Tripleta']);
    sorteo = (query.isEmpty != true) ? Draws.fromMap(query.first) : null;
  }

  return sorteo;
 }

Future<String> esSorteoPickQuitarUltimoCaracter(String jugada, idSorteo) async {
  var query = await Db.database.query('Draws', columns: ['descripcion'], where:'"id" = ?', whereArgs: [idSorteo]);
  String sorteo = (query.isEmpty != true) ? query.first['descripcion'] : '';
  if(sorteo == 'Pick 3 Box' || sorteo == 'Pick 4 Straight' || sorteo == 'Pick 4 Box' || sorteo == 'Super pale'){
    jugada = jugada.substring(0, jugada.length - 1);
  }
  return jugada;
}




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

quitarLoteriasProvenientesDelSocketQueEstenCerradas(var parsed) async {
  List<Loteria> listaLoteriaEvent = parsed['lotteries'].map<Loteria>((json) => Loteria.fromMap(json)).toList();
  List<int> listaIdloteriasAEliminar = List();
   listaLoteriaEvent.forEach((l) async {
    print("dentro foreach loterias: ${l.descripcion}");

    DateTime fechaLoteria = _horaCierreLoteriaToCurrentTimeZone(l);
    DateTime now = DateTime.now();

    if(now.isAfter(fechaLoteria)){
      if(!_tienePermisoJugarFueraDeHorario){
      print("dentro foreach loterias eliminar: ${l.descripcion}");
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
      print("listaIdloteriasAEliminar: ${listaLoteriaEvent[_index]}");
    }

  });

  print("listaIdloteriasAEliminar: ${listaIdloteriasAEliminar}");

  
  setState((){
    listaLoteria = listaLoteriaEvent;
    _streamControllerLoteria.add(listaLoteriaEvent);
    _seleccionarPrimeraLoteria();
  });
}


 

}




