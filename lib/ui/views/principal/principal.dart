import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:adhara_socket_io/options.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/services/bluetoothchannel.dart';
import 'package:loterias/core/services/loginservice.dart';
import 'package:loterias/core/services/sharechannel.dart';
import 'package:loterias/core/services/ticketservice.dart';
import 'package:loterias/ui/login/login.dart';
import 'package:barcode_scan/barcode_scan.dart';



import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
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
import 'package:timezone/timezone.dart' as tz;




class PrincipalApp extends StatefulWidget {
  @override
  _PrincipalAppState createState() => _PrincipalAppState();
}
  

 

 


class _PrincipalAppState extends State<PrincipalApp> with WidgetsBindingObserver{
  List<String> _listaMensajes = List();
  static int _socketContadorErrores = 0;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _jugadaOmonto = true;
  // var listaBanca = List<String>.generate(10, (i) => "Banca $i");
  List<Banca> listaBanca = List<Banca>.generate(1, (i) => Banca(descripcion: 'No hay bancas', id: 0));
  List<Loteria> listaLoteria = List<Loteria>.generate(1, (i) => Loteria(descripcion: 'No hay bancas', id: 0));
  List<Venta> listaVenta = List<Venta>.generate(1, (i) => Venta(idTicket: BigInt.from(0), id: BigInt.from(0)));
  List<Jugada> listaJugadas = List<Jugada>();

Future<String> _montoFuture;
String _montoPrueba = '0';
  String _idVenta = null;
  int _indexBanca = 0;
  int _indexVenta = 0;
  String _timeString;
  bool _cargando = false;
  bool _ckbDescuento = false;
  bool _ckbPrint = true;
  bool _ckbMessage = false;
  bool _ckbWhatsapp = false;
  bool _drawerIsOpen = false;
  bool _tienePermisoJugarComoCualquierBanca = false;
  bool _tienePermisoManejarResultados = false;
  bool _tienePermisoMarcarTicketComoPagado = false;
  bool _tienePermisoMonitorearTicket = false;
  bool _tienePermisoVerDashboard = false;
  bool _tienePermisoVerVentas = false;
  bool _tienePermisoVerHistoricoVentas = false;
  bool _tienePermisoVerListaDeBalancesDeBancass = false;
  bool _tienePermisoTransacciones = false;
  bool _tienePermisoAdministrador = false;
  StreamController<bool> _streamControllerBanca;
  StreamController<List<Loteria>> _streamControllerLoteria;
  StreamController<bool> _streamControllerVenta;
  StreamController<List<Jugada>> _streamControllerJugada;
  var _txtJugada = TextEditingController();
  var _txtMontoDisponible = TextEditingController();
  var _txtMonto = TextEditingController();
  bool _txtMontoPrimerCaracter = true;
  List<Loteria> _selectedLoterias;
  Timer _timer;

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
SocketIOManager manager;
SocketIO socket;

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
      var datos = await TicketService.indexPost(idUsuario: await Db.idUsuario(), idBanca: await getIdBanca(), scaffoldKey: _scaffoldKey);
      
      setState((){
        _cargando = false;
        _idVenta = datos['idVenta'];
        listaBanca = datos["bancas"];
        listaVenta = datos["ventas"];
        _streamControllerBanca.add(true);
        _streamControllerVenta.add(true);
        listaLoteria = datos['loterias'];
        _streamControllerLoteria.add(datos['loterias']);
        _seleccionarPrimeraLoteria();
        (seleccionarBancaPertenecienteAUsuario) ? _seleccionarBancaPertenecienteAUsuario() : null;
      });
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
  }

  

  guardar() async{
    if(_ckbPrint){
      if(await Utils.exiseImpresora() == false){
        _showSnackBar("Debe registrar una impresora");
        return;
      }

      if(!(await BluetoothChannel.turnOn())){
        return;
      }
    }

    try{
      setState(() => _cargando = true);
      var datos = await TicketService.guardar(idVenta: _idVenta, compartido:  !_ckbPrint,descuentomonto: await _calcularDescuento(), hayDescuento: _ckbDescuento, total: _calcularTotal(), loterias: Principal.loteriaToJson(_selectedLoterias), jugadas: Principal.jugadaToJson(listaJugadas), idUsuario: await Db.idUsuario(), idBanca: await getIdBanca(), scaffoldKey: _scaffoldKey);
      
      setState((){
         
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
        (_ckbPrint) ? BluetoothChannel.printTicket(datos['venta'], BluetoothChannel.TYPE_ORIGINAL) : ShareChannel.shareHtmlImageToSmsWhatsapp(html: datos["img"], codigoQr: datos["venta"]["codigoQr"], sms_o_whatsapp: _ckbMessage);
      
      });
    } on Exception catch(e){
      setState(() => _cargando = false);
    }
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

     http.post(Utils.URL +"/api/principal/montodisponible", body: json.encode(map2), headers: header ).then((http.Response resp){
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

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
    ]);
    _requestPermisionChannel();
    _getPermisos();
    _getUsuarioYBanca();
    _timeString = Utils.formatDateTime(DateTime.now());
    _streamControllerBanca = BehaviorSubject();
    _streamControllerLoteria = BehaviorSubject();
    _streamControllerVenta = BehaviorSubject();
    _streamControllerJugada = BehaviorSubject();
    _streamControllerJugada.add(listaJugadas);
    
    
      print('timerrrr: $_timeString');
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    
    
    focusNode = FocusNode();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    indexPost(true);
    //_montoFuture = fetchMonto();
    initSocket();
    
    futureBanca = Db.getBanca();
    futureUsuario = Db.getUsuario();
  // platform.setMethodCallHandler(this._saludos);

  }

  _getUsuarioYBanca() async {
    _usuario = Usuario.fromMap(await Db.getUsuario());
    _banca = Banca.fromMap(await Db.getBanca());
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
    _timer.cancel();
    focusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _streamControllerBanca.close();
    _streamControllerVenta.close();
    _streamControllerLoteria.close();
    print("dispose desconectar socket");
    print("Desconectando socket desde dispose de la ventana principal");
    await manager.clearInstance(socket);
    
  }

  static const stream =
      const EventChannel('flutter.bluetooh.stream');

  StreamSubscription _timerSubscription = null;

  _getPermisos() async {
    bool permiso = await Db.existePermiso("Jugar como cualquier banca");
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

    if(permisoAccesoAlSistema == false)
      Principal.cerrarSesion(context);

    setState((){
      _tienePermisoJugarComoCualquierBanca = permiso;
      _tienePermisoAdministrador = permisoAdministrador;
      _tienePermisoManejarResultados = permisoManejarResultados;
      _tienePermisoMarcarTicketComoPagado = permisoMarcarTicketComoPagado;
      _tienePermisoMonitorearTicket = permisoMonitorearTicket;
      _tienePermisoVerDashboard = permisoVerDashboard;
      _tienePermisoVerVentas = permisoVerVentas;
      _tienePermisoVerHistoricoVentas = permisoVerHistoricoVentas;
      _tienePermisoTransacciones = permisoTransacciones;
      _tienePermisoVerListaDeBalancesDeBancass = permisoVerListaDeBalancesDeBancas;
    });
  }

  Future _desconectarYConectarNuevamente() async {
    print("_desconectarYConectarNuevamente desconectar socket y conectar");
    await manager.clearInstance(socket);
    _socketContadorErrores = 0;
    initSocket();
  }

  initSocket() async {
    var builder = new JWTBuilder();
    var token = builder
      // ..issuer = 'https://api.foobar.com'
      // ..expiresAt = new DateTime.now().add(new Duration(minutes: 1))
      ..setClaim('data', {'id': 836, 'username' : "john.doe"})
      ..getToken(); // returns token without signature

    var signer = new JWTHmacSha256Signer('quierocomerpopola');
    var signedToken = builder.getSignedToken(signer);
    print(signedToken); // prints encoded JWT
    var stringToken = signedToken.toString();

  // Utils.showAlertDialog(context: context, title: "Principal initSocket", content: "Before start socket");
    
    // _listaMensajes.add("Before initSocket ${DateTime.now().hour}:${DateTime.now().minute}");
    manager = SocketIOManager();
    socket = await manager.createInstance(SocketOptions(
                    //Socket IO server URI
                      // 'http://pruebass.ml:3000',
                      // 'http://192.168.43.63:3000',
                      // '10.0.0.11:3000',
                      Utils.URL_SOCKET,
                      nameSpace: "/",
                      //Query params - can be used for authentication
                      // query: {
                      //   "query": 'auth_token=${signedToken}'
                      // },
                      query: {
                        "auth_token": '${signedToken.toString()}',
                        "room" : await Db.servidor()
                      },

                      //Enable or disable platform channel logging
                      enableLogging: true,
                      // transports: [Transports.WEB_SOCKET/*, Transports.POLLING*/] //Enable required transport
        ));       //TODO change the port  accordingly
    socket.onConnect((data) async {
      print("connected...");
      print(data);
      socket.emit("message", ["Hello world!"]);
      await Realtime.sincronizarTodos(_scaffoldKey);
      await _getPermisos();
      _socketContadorErrores = 0;
    // _listaMensajes.add("initSocket onConnect ${DateTime.now().hour}:${DateTime.now().minute}");

    });
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
      await Realtime.addBlocksplaysgeneralsDatosNuevos(parsed['blocksplaysgenerals'], (parsed['action'] == 'delete') ? true : false);
    });
    socket.on("versions:App\\Events\\VersionsEvent", (data) async {   //sample event
      var parsed = data.cast<String, dynamic>();
      await Principal.version(context: _scaffoldKey.currentContext, version: parsed["version"]);
    });
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
    socket.on("error", (data){   //sample event
      print("onError: $data");
    // _listaMensajes.add("initSocket OnError ${DateTime.now().hour}:${DateTime.now().minute}");

  // Utils.showAlertDialog(context: context, title: "Principal initSocket error", content: "onError start socket");

      // print(data);
    });
    socket.onConnectError((er) async {
      _socketContadorErrores++;
      if(_socketContadorErrores == 4)
        await _desconectarYConectarNuevamente();
      print("onConnectError: $er");
    _listaMensajes.add("initSocket onConnectError ${DateTime.now().hour}:${DateTime.now().minute}");

  // Utils.showAlertDialog(context: context, title: "Principal initSocket", content: "onConnectError start socket");

    });
    socket.onError((e) => print(e));
    socket.connect();
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
    loteriasAduplicar.forEach((l) async {
      for(Map<String, dynamic> jugada in datos["jugadas"]){
        if(l["id"] == jugada["idLoteria"]){
          if(l["duplicar"] == '- NO MOVER -'){
            jugada["jugada"] = await Utils.esSorteoPickAgregarUltimoSigno(jugada["jugada"], jugada["sorteo"]);
            await addJugada(loteriaMap: l, jugada: jugada["jugada"], montoDisponible: 'X', monto: jugada["monto"]);
          }
          else if(l["duplicar"] != '- NO COPIAR -'){
            print('dentro no copiar');
            Map<String, dynamic> mapLoteria = Map<String, dynamic>();
            Loteria loteria = listaLoteria.firstWhere((lote) => lote.id == l["duplicarId"]);
            if(loteria != null){
              mapLoteria["id"] = loteria.id;
              mapLoteria["descripcion"] = loteria.descripcion;
              jugada["jugada"] = await Utils.esSorteoPickAgregarUltimoCaracter(jugada["jugada"], jugada["sorteo"]);
              await addJugada(loteriaMap: mapLoteria, jugada: jugada["jugada"], montoDisponible: 'X', monto: jugada["monto"]);
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
      var servidor = await Principal.seleccionarServidor(context, listaServidor, servidorActual);
      if(servidor != null && servidor != servidorActual){
        // LoginService.cambiarServidor(usuario: usuario.usuario, servidor: servidor, scaffoldkey: _scaffoldKey);
        // Usuario usuario = Usuario.fromMap(await Db.getUsuario());
        // usuario.servidor = servidor;
        // await Db.update("Users", usuario.toJson(), usuario.id);
        await manager.clearInstance(socket);
        futureUsuario = Db.getUsuario();
        await indexPost(true);
        await initSocket();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
        //do your stuff
        print('unresume');
    }
  }

  
  @override
  build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // backgroundColor: Colors.white,
        primarySwatch: Utils.colorMaterialCustom,
        accentColor: Colors.pink,
        // accentColor: Utils.fromHex("#F0807F")
      ),
      home: DefaultTabController(
          length: 2,
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
                  ListTile(
                    title: Text('Pendientes de pago'),
                    leading: Icon(Icons.attach_money),
                    dense: true,
                    onTap: (){
                      Navigator.of(context).pushNamed("/pendientesPago");
                      _scaffoldKey.currentState.openEndDrawer();
                    },
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
                    },
                  )
                ],
              ),

            ),
          ),
          appBar: AppBar(
            title: Text('Principal'),
            // leading: SizedBox(),
            // leading: _drawerIsOpen ? SizedBox() :  IconButton(icon: Icon(Icons.menu, color:  Colors.white,), onPressed: _manageDrawer),
            actions: <Widget>[
              Container(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 30,
                    height: 30,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.camera_alt, size: 30),
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
              IconButton(
                icon: Icon(Icons.bluetooth, size: 30,),
                onPressed: () async{
                  Navigator.of(context).pushNamed('/bluetooth');
                },
              ),
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
          ),
          body: TabBarView(
            children: <Widget>[
              LayoutBuilder(
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
                                              value:  listaBanca[_indexBanca],
                                              onChanged: (Banca banca){
                                                setState(() {
                                                _indexBanca = listaBanca.indexOf(banca); 
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
                                    child: Center(child: Text(Principal.loteriasSeleccionadasToString(_selectedLoterias), style: TextStyle(color: _colorSegundary),),),
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 10,),
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
                              SizedBox(height: 10,),
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
                                  Row(
                                    children: <Widget>[
                                      //MyCheckbox
                                      MyCheckbox(
                                        useTapTarget: false,
                                        value: _ckbDescuento,
                                        onChanged: (newValue){
                                          setState(() {
                                          _ckbDescuento = newValue; 
                                          });
                                        },
                                      ),
                                      SizedBox(width: 5,),
                                      GestureDetector(child: Text('Des', style: TextStyle(fontSize: 12)), onTap: (){setState(() => _ckbDescuento = !_ckbDescuento);},)
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      MyCheckbox(
                                        useTapTarget: false,
                                        value: _ckbPrint,
                                        onChanged: _ckbPrintChanged,
                                      ),
                                      SizedBox(width: 5,),
                                      GestureDetector(child: Icon(Icons.print,), onTap: (){_ckbPrintChanged(!_ckbPrint);},)
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      MyCheckbox(
                                        useTapTarget: false,
                                        value: _ckbMessage,
                                        onChanged: _ckbMessageChanged,
                                      ),
                                      SizedBox(width: 5,),
                                      GestureDetector(child: Icon(Icons.message, color: Colors.blue,), onTap: (){_ckbMessageChanged(!_ckbMessage);},)
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      MyCheckbox(
                                        useTapTarget: false,
                                        value: _ckbWhatsapp,
                                        onChanged: _ckbWhatsappChanged,
                                      ),
                                      SizedBox(width: 5,),
                                      GestureDetector(child: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green, ), onTap: (){ _ckbWhatsappChanged(!_ckbWhatsapp);},)
                                    ],
                                  ),
                                
                                        
                                      
                                ],
                              ),
                              
                              SizedBox(height: 10,),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  // color: Colors.red,
                                  child: LayoutBuilder(
                                  builder: (BuildContext context, BoxConstraints constraints) {
                                    return Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            _buildButton(Text('.', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight - 22, 4, 5),
                                            _buildButton(Text('D', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight - 22, 4, 5),
                                            _buildButton(Text('Q', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight - 22, 4, 5),
                                            _buildButton(Icon(Icons.backspace, size: ((constraints.maxHeight - 25) / 5), color: _colorPrimary,), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight - 22, 4, 5),
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
                                            _buildButton(Text('7', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight - 22, 4, 5),
                                            _buildButton(Text('8', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight - 22, 4, 5),
                                            _buildButton(Text('9', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight - 22, 4, 5),
                                            _buildButton(Text('/', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight - 22, 4, 5),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            _buildButton(Text('4', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight - 22, 4, 5),
                                            _buildButton(Text('5', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight - 22, 4, 5),
                                            _buildButton(Text('6', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight - 22, 4, 5),
                                            _buildButton(Text('-', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight - 22, 4, 5),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            _buildButton(Text('1', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight - 22, 4, 5),
                                            _buildButton(Text('2', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight - 22, 4, 5),
                                            _buildButton(Text('3', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight - 22, 4, 5),
                                            _buildButton(Text('+', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight - 22, 4, 5),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            _buildButton(Text('0', style: TextStyle(fontSize: 20, color: Colors.black),), Utils.fromHex("#FFF7F6F6"), constraints.maxHeight - 22, 2, 5),
                                            _buildButton(Text('ENTER', style: TextStyle(fontSize: 20, color: _colorPrimary),), Utils.fromHex("#FFEDEBEB"), constraints.maxHeight - 22, 2, 5),
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
                                  alignment: Alignment.topCenter,
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
                                                  BluetoothChannel.printTicket(resultado["ticket"], BluetoothChannel.TYPE_COPIA);
                                                }
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete, color: Colors.red, size: 38,),
                                              onPressed: () async {
                                                if(listaVenta.isNotEmpty){
                                                  var r = await TicketService.cancelar(codigoBarra: listaVenta[_indexVenta].codigoBarra);
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
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      child: Text('Eliminar todas'),
                      onPressed: (){
                        setState(() => listaJugadas.clear());
                      },
                    ),
                  ),
                  StreamBuilder(
                    stream: _streamControllerJugada.stream,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                      listaJugadas = snapshot.data;

                        return _buildTable(listaJugadas);
                      }else{
                        return _buildTable(List());
                      }
                      
                    },
                  ),
                ],
              ),
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
              return MultiSelectDialogItem(l.id, l.descripcion);
            }).toList();
            return MultiSelectDialog(
              items: items,
              // initialSelectedValues: [1, 3].toSet(),
              initialSelectedValues: initialSelectedValues,
            );
          },
        );
      },
    );

    _selectedLoterias = List();
    if(selectedValues != null){
      final selectedValuesMap = selectedValues.toList().asMap();
      for(int c=0; c < selectedValuesMap.length; c++){
        _selectedLoterias.add(listaLoteria.firstWhere((l) => l.id == selectedValuesMap[c]));
      }
    }
    print(_selectedLoterias.length);
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

  void _escribir(String caracter){
    if(caracter == 'ENTER'){
      if(_jugadaOmonto){
        setState((){
            // _montoFuture = fetchMonto();
            montoDisponible();
          _jugadaOmonto = !_jugadaOmonto;
          _txtMontoPrimerCaracter = true;
          });
      }else{
        addJugada(jugada: Utils.ordenarMenorAMayor(_txtJugada.text), montoDisponible: _txtMontoDisponible.text, monto: _txtMonto.text, selectedLoterias: _selectedLoterias);
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
      }else if(_txtJugada.text.length < 6){
        if(esCaracterEspecial(caracter) == false)
          _txtJugada.text = _txtJugada.text + caracter;
        else{
          if(caracter == '+'){
            ponerSignoMas();
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

   ponerPuntoEnMonto(){
    if(_txtMonto.text.indexOf('.') == -1){
      _txtMonto.text = _txtMonto.text + '.';
    }
  }

  ponerSignoMas(){
    if(_txtJugada.text.indexOf('+') != -1)
      return;

    if(_txtJugada.text.length != 3 && _txtJugada.text.length != 4)
      return;
    
    _txtJugada.text = _txtJugada.text + '+';
    setState(() => _jugadaOmonto = !_jugadaOmonto);
    montoDisponible();
    
  }


  addJugada({String jugada, String montoDisponible, String monto, List<Loteria> selectedLoterias, Map<String, dynamic> loteriaMap}) async {
    if(jugada.length < 2)
      return;

    if(montoDisponible.isEmpty)
      return;

    if((Utils.toDouble(montoDisponible) == 0 || Utils.toDouble(montoDisponible) < 0) || Utils.toDouble(montoDisponible) < Utils.toDouble(monto)){
      if(montoDisponible != 'X' && selectedLoterias.length < 2){
        if(Utils.toDouble(monto) > Utils.toDouble(montoDisponible)){
          _showSnackBar('No hay monto suficiente');
            return;
        }
      }
    }

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
      int idx = (listaJugadas.isEmpty == false) ? listaJugadas.indexWhere((j) => j.jugada == jugada && j.idLoteria == loteriaMap["id"]) : -1;
      if(idx != -1){
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Jugada existe'),
              content: Text('La jugada ${jugada} existe en la loteria ${loteriaMap["descripcion"]} desea agregar?'),
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
        listaJugadas.add(Jugada(
          jugada: jugada,
          idLoteria: loteriaMap["id"],
          monto: Utils.redondear(Utils.toDouble(monto), 2),
          descripcion: loteriaMap["descripcion"],
          idBanca: 0
        ));
        _streamControllerJugada.add(listaJugadas);

        _txtJugada.text = '';
        _txtMontoDisponible.text = '';
      }

    }
    else if(selectedLoterias.length == 1){
      int idx = (listaJugadas.isEmpty == false) ? listaJugadas.indexWhere((j) => j.jugada == jugada && j.idLoteria == selectedLoterias[0].id) : -1;
      if(idx != -1){
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Jugada existe'),
              content: Text('La jugada ${jugada} existe en la loteria ${selectedLoterias[0].descripcion} desea agregar?'),
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
        listaJugadas.add(Jugada(
          jugada: jugada,
          idLoteria: selectedLoterias[0].id,
          monto: Utils.redondear(Utils.toDouble(monto), 2),
          descripcion: selectedLoterias[0].descripcion,
          idBanca: 0
        ));
        _streamControllerJugada.add(listaJugadas);

        _txtJugada.text = '';
        _txtMontoDisponible.text = '';
      }

      
      // setState(() => _jugadaOmonto = true);
    }
    else{
      selectedLoterias.forEach((l){
        int idx = (listaJugadas.isEmpty == false) ? listaJugadas.indexWhere((j) => j.jugada == jugada && j.idLoteria == l.id) : -1;
        if(idx != -1){
          showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text('Jugada existe'),
                content: Text('La jugada ${jugada} existe en la loteria ${l.descripcion} desea agregar?'),
                actions: <Widget>[
                  FlatButton(child: Text("Cancelar"), onPressed: (){
                  Navigator.of(context).pop();
                  },),
                  FlatButton(child: Text("Agregar"), onPressed: (){
                      Navigator.of(context).pop();
                      listaJugadas[idx].monto += Utils.redondear(Utils.toDouble(monto), 2);
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
            jugada: jugada,
            idLoteria: l.id,
            monto: Utils.redondear(Utils.toDouble(monto), 2),
            descripcion: l.descripcion,
            idBanca: 0
          ));
        }
        
      });

      _streamControllerJugada.add(listaJugadas);
      _txtJugada.text = '';
      _txtMontoDisponible.text = '';

    }

          
    setState(() => _jugadaOmonto = !_jugadaOmonto);

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

_seleccionarBancaPertenecienteAUsuario() async {
  var bancaMap = await Db.getBanca();
  Banca banca = (bancaMap != null) ? Banca.fromMap(bancaMap) : null;
  if(banca != null){
    int idx = listaBanca.indexWhere((b) => b.id == banca.id);
    print('_seleccionarBancaPertenecienteAUsuario idx: $idx : ${listaBanca.length}');
    setState(() => _indexBanca = (idx != -1) ? idx : 0);
  }else{
    setState(() =>_indexBanca = 0);
  }

  print('seleccionarBancaPerteneciente: $_indexBanca : ${banca.descripcion} : ${listaBanca.length}');
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
              Center(child: Text(j.descripcion, style: TextStyle(fontSize: 16))),
              Center(child: _buildRichOrTextAndConvertJugadaToLegible(j.jugada)),
              Center(child: Text(j.monto.toString(), style: TextStyle(fontSize: 16))),
              Center(child: IconButton(icon: Icon(Icons.delete, size: 28,), onPressed: (){
                setState((){
                  listaJugadas.remove(j);
                  _streamControllerJugada.add(listaJugadas);
                });
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

 montoDisponible() async {
   double montoDisponible = 0;
   if(_selectedLoterias.length == 1){
     montoDisponible = await getMontoDisponible(Utils.ordenarMenorAMayor(_txtJugada.text), _selectedLoterias[0], await _selectedBanca());
     setState(() {
      _txtMontoDisponible.text =  montoDisponible.toString();
     });
   }else if(_selectedLoterias.length > 1){
     setState(() {
      _txtMontoDisponible.text = "X";
     });
   }else{
     _showSnackBar("Debe seleccionar una loteria");
   }
 }

 Future<double> getMontoDisponible(String jugada, Loteria loteria, Banca banca) async {
    
    var montoDisponible = null;
    
    
    int idDia = getIdDia();
    int idSorteo = await getIdSorteo(jugada, loteria);
    jugada = await esSorteoPickQuitarUltimoCaracter(jugada, idSorteo);

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

    // setState(() {
    //  _txtMontoDisponible.text = montoDisponible.toString(); 
    // });
    // print('montoDisponiblePrueba idSorteo: $montoDisponible');

    int idx = listaJugadas.indexWhere((j) => j.idLoteria == _selectedLoterias[0].id && j.jugada == _txtJugada.text);
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
      List<Draws> sorteosLoteriaSeleccionada = loteria.sorteos;
      if(sorteosLoteriaSeleccionada.indexWhere((s) => s.descripcion == 'Super pale') != -1){
        idSorteo = 4;
      }else{
        idSorteo = 2;
      }
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
  }
  else if(jugada.length == 6)
    idSorteo = 3;

  return idSorteo;
 }

Future<String> esSorteoPickQuitarUltimoCaracter(String jugada, idSorteo) async {
  var query = await Db.database.query('Draws', columns: ['descripcion'], where:'"id" = ?', whereArgs: [idSorteo]);
  String sorteo = (query.isEmpty != true) ? query.first['descripcion'] : '';
  if(sorteo == 'Pick 3 Box' || sorteo == 'Pick 4 Straight' || sorteo == 'Pick 4 Box'){
    jugada = jugada.substring(0, jugada.length - 1);
  }
  return jugada;
}

 
Future quitarLoteriasCerradas()
{
  try {
      listaLoteria.forEach((l) async {
      // print("quitarloteriasCerradas: ${l.descripcion}");
      var santoDomingo = tz.getLocation('America/Santo_Domingo');
      var fechaActualRd = tz.TZDateTime.now(santoDomingo);
      var fechaLoteria = DateTime.parse(fechaActualRd.year.toString() + "-" + Utils.toDosDigitos(fechaActualRd.month.toString())+ "-" + Utils.toDosDigitos(fechaActualRd.day.toString()) + " ${l.horaCierre}");
      var fechaFinalRd = tz.TZDateTime.now(santoDomingo);
      if(fechaFinalRd.isAfter(fechaLoteria)){
        if(!await Db.existePermiso("Jugar fuera de horario")){
          if(await Db.existePermiso("Jugar minutos extras")){
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
    print("dentro foreach loterias socket");
    var santoDomingo = tz.getLocation('America/Santo_Domingo');
    var fechaActualRd = tz.TZDateTime.now(santoDomingo);
    var fechaLoteria = DateTime.parse(fechaActualRd.year.toString() + "-" + Utils.toDosDigitos(fechaActualRd.month.toString())+ "-" + Utils.toDosDigitos(fechaActualRd.day.toString()) + " ${l.horaCierre}");
    var fechaFinalRd = tz.TZDateTime.now(santoDomingo);
    if(fechaFinalRd.isAfter(fechaLoteria)){
      if(!await Db.existePermiso("Jugar fuera de horario")){
        if(await Db.existePermiso("Jugar minutos extras")){
          var fechaLoteriaMinutosExtras = fechaLoteria.add(Duration(minutes: l.minutosExtras));
          if(fechaFinalRd.isAfter(fechaLoteriaMinutosExtras)){
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
  
  setState((){
    listaLoteria = listaLoteriaEvent;
    _streamControllerLoteria.add(listaLoteriaEvent);
    _seleccionarPrimeraLoteria();
  });
}


 

}




