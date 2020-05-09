import 'dart:async';

import 'package:flutter/services.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';

class BluetoothChannel{
  static const String TYPE_ORIGINAL = "ORIGINAL";
  static const String TYPE_COPIA = "COPIA";
  static const String TYPE_CANCELADO = "CANCELADO";
  static const String TYPE_PAGADO = "PAGADO";
  static const int TYPE_ALIGN_CENTER = 1;
  static const int TYPE_ALIGN_LEFT = 0;
  static const String TYPE_CMD_ALIGN = "ALIGN";
  static const String TYPE_CMD_PRINT_TEXT = "PRINT";
  static const String TYPE_CMD_PRINT_QR = "QR";
  static const _methodChannel = const MethodChannel('flutter.loterias');
  static const channel = const EventChannel('flutter.bluetooh.stream');
  static StreamSubscription _subscription;
  static bool _escaneando = false;
  static Stream _stream;

  static const channelConnect = const EventChannel('flutter.bluetooh.connect');
  static Stream _streamConnect;
  static bool _connectado = false;

  static Stream scan() {
    if(_escaneando){
      return _stream;
    }
     _stream = channel.receiveBroadcastStream("hola");
     return _stream;
  }

  static connect(String address){
    if(_connectado){
      return;
    }

    
     _subscription = channelConnect.receiveBroadcastStream(address).listen(
      (onData){
        _connectado = true;
        print("Listen OnData: $onData");
      },
      onError: (error){
        _connectado = false;
        print("Listen Error: $error");
      }
    );
  }



  static disconnect(){
    if(_subscription != null){
      _subscription.cancel();
      _connectado = false;
    }
  }

  static printTicket(Map<String, dynamic> map, String type) async {
    var c = await DB.create();
    var printer = await c.getValue("printer");
    if(_connectado){
      return;
    }

    
     _subscription = channelConnect.receiveBroadcastStream(printer["address"]).listen(
      (onData) async {
        print("Listen OnData: $onData");
        _connectado = true;
        final bool result = await _methodChannel.invokeMethod("printText", {"data" : generateMapTicket(map, type)});
        disconnect();
        print("Listen OnData print: $result");
      },
      onError: (error){
        _connectado = false;
        print("Listen Error: $error");
      }
    );
  }

  static quickPrint() async {
    try{
      final bool result = await _methodChannel.invokeMethod("quickPrinter");
      print("quickPrint flutter: $result");
    }on PlatformException catch(e){
      print("quickPrint platformexception: ${e.toString()}");
    }
  }

  static printCuadre(Map<String, dynamic> map) async {
    var c = await DB.create();
    var printer = await c.getValue("printer");
    if(_connectado){
      return;
    }

    
     _subscription = channelConnect.receiveBroadcastStream(printer["address"]).listen(
      (onData) async {
        print("Listen OnData: $onData");
        _connectado = true;
        final bool result = await _methodChannel.invokeMethod("printText", {"data" : generateCuadre(map)});
        disconnect();
        print("Listen OnData print: $result");
      },
      onError: (error){
        _connectado = false;
        print("Listen Error: $error");
      }
    );
  }

  static printText({String content, int nWidthTimes = 1, normalOPrueba = true}) async {
    var c = await DB.create();
    var printer = await c.getValue("printer");
    if(_connectado){
      return;
    }

    
     _subscription = channelConnect.receiveBroadcastStream(printer["address"]).listen(
      (onData) async {
        print("Listen OnData: $onData");
        _connectado = true;
        var map = Map<int, dynamic>();
        map[map.length] = (normalOPrueba) ? _getMap(content, nWidthTimes) : _getMapPrueba(content, nWidthTimes);
        final bool result = await _methodChannel.invokeMethod("printText", {"data" : map});
        // if(normalOPrueba){
        //   map[map.length] = _getMap(content, nWidthTimes);
        //   final bool result = await _methodChannel.invokeMethod("printText", {"data" : map});
        // }else{
        //   map[map.length] = _getMapPrueba(content, nWidthTimes);
        //   final bool result = await _methodChannel.invokeMethod("printText", {"data" : map});
        // }
        disconnect();
        print("Listen OnData print: $result");
      },
      onError: (error){
        _connectado = false;
        print("Listen Error: $error");
      }
    );
  }

  static Future<bool> turnOn() async {
    bool result = false;
    try{
      bool r = await _methodChannel.invokeMethod("turnOnBluetooth");
      result = r;
    } on PlatformException catch(e){
      print("Flutter error activando bluetooth: ${e.toString()}");
    }

    return result;
  }

  static Map<int, dynamic> generateCuadre(Map<String, dynamic> mapCuadre){
    Map<int, dynamic> map = Map<int, dynamic>();
    map[map.length] = _getMapAlign(TYPE_ALIGN_CENTER);
    map[map.length] = _getMap("Cuadre\n", 1);
    map[map.length] = _getMap("${mapCuadre["banca"]["descripcion"]}\n", 1);
    map[map.length] = _getMapAlign(TYPE_ALIGN_LEFT);
    map[map.length] = _getMap("Balance hasta la fecha: ${mapCuadre["balanceHastaLaFecha"]}\n");
    map[map.length] = _getMap("Tickets pendientes: ${mapCuadre["pendientes"]}\n");
    map[map.length] = _getMap("Tickets perdedores: ${mapCuadre["perdedores"]}\n");
    map[map.length] = _getMap("Tickets ganadores:  ${mapCuadre["ganadores"]}\n");
    map[map.length] = _getMap("Total:              ${mapCuadre["total"]}\n");
    map[map.length] = _getMap("Ventas:             ${mapCuadre["ventas"]}\n");
    map[map.length] = _getMap("Comisiones:         ${mapCuadre["comisiones"]}\n");
    map[map.length] = _getMap("descuentos:         ${mapCuadre["descuentos"]}\n");
    map[map.length] = _getMap("premios:            ${mapCuadre["premios"]}\n");
    map[map.length] = _getMap("neto:               ${mapCuadre["neto"]}\n");
    map[map.length] = _getMap("Balance mas ventas: ${mapCuadre["balanceActual"]}\n\n\n\n\n");
    print("bluetooth channel cuadure: ${map.toString()}");
    return map;
  }

  static Map<int, dynamic> generateMapTicket(Map<String, dynamic> mapVenta, String typeTicket){
    List listMapToPrint = List();
    print("generateMapTicket: ${mapVenta.toString()}");
    Map<int, dynamic> map = Map<int, dynamic>();
    map[map.length] = _getMapAlign(TYPE_ALIGN_CENTER);
    map[map.length] = _getMap("${mapVenta["banca"]["descripcion"]}\n", 1);
    map[map.length] = _printTicketHeader(typeTicket);
    map[map.length] = _getMap("${mapVenta["fecha"]}\n");
    map[map.length] = _getMap("Ticket:" + Utils.toSecuencia(mapVenta["banca"]["codigo"], BigInt.from(mapVenta["idTicket"])) + "\n");
    map[map.length] = _getMap("Fecha: ${mapVenta["fecha"]}\n");
    if(typeTicket == TYPE_ORIGINAL || typeTicket == TYPE_PAGADO)
      map[map.length] = _getMap("${mapVenta["codigoBarra"]}\n", 1);
    
    double total = 0;
    for(Map<String, dynamic> loteria in mapVenta["loterias"]){
      bool primerCicloJugadas = true;
      int contadorCicleJugadas = 0;
      double totalPorLoteria = 0;
      
      
      List jugadas = _getJugadasPertenecienteALoteria(jugadas: mapVenta["jugadas"], idLoteria: loteria["id"], type: typeTicket);
      if(jugadas.isEmpty)
        continue;

      map[map.length] = _getMap("---------------\n", 1);
      map[map.length] = _getMap("${loteria["descripcion"]}\n");
      map[map.length] = _getMap("---------------\n", 1);
      
      for(Map<String, dynamic> jugada in jugadas){
          if(loteria["id"] != jugada["idLoteria"])
            continue;

        total += Utils.toDouble(jugada["monto"].toString());
        totalPorLoteria += Utils.toDouble(jugada["monto"].toString());

        map[map.length] = _getMapAlign(TYPE_ALIGN_LEFT);
        if(primerCicloJugadas){
          map[map.length] = _getMap("JUGADA   MONTO  JUGADA   MONTO\n");
          primerCicloJugadas = false;
        }
        if(((contadorCicleJugadas + 1) % 2) == 0){ //PAR
          map[map.length] = _getMap("                 ${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
          map[map.length] = _getMap("                          ${jugada["monto"]}\n");
        }else{
          map[map.length] = _getMap(Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"]));
          map[map.length] = _getMap("          ${jugada["monto"]}" + siEsUltimaJugadaDarSaltoDeLinea(contadorCicleJugadas, jugadas.length));
        }

        contadorCicleJugadas++;
      }

      map[map.length] = _getMapAlign(1);
      int loteriasLength = (typeTicket == TYPE_PAGADO) ? mapVenta["loterias"].length - 1 : mapVenta["loterias"].length;
      if(loteriasLength > 1)
        map[map.length] = _getMap("\n total: $totalPorLoteria \n\n\n");
      }

      if(mapVenta["hayDescuento"] == 1){
        map[map.length] = _getMap("subTotal: ${mapVenta["total"]}\n");
        map[map.length] = _getMap("descuento: ${mapVenta["descuentoMonto"]}\n");
        total -= Utils.toDouble(mapVenta["descuentoMonto"].toString());
      }

      String saltoLineaTotal = "\n";
      if((typeTicket != TYPE_ORIGINAL && typeTicket != TYPE_PAGADO) || mapVenta["banca"]["imprimirCodigoQr"] == 0)
        saltoLineaTotal += "\n\n";
      
      map[map.length] = _getMap("- TOTAL: $total$saltoLineaTotal");
    
      if(typeTicket == TYPE_CANCELADO)
        map[map.length] = _getMap("** CANCELADO **\n\n\n", 1);
      
      if(typeTicket == TYPE_ORIGINAL){
        Map<String, dynamic> banca = mapVenta["banca"];
        print("bluetoothchannel generateticket banca: ${banca.toString()}");
        if(banca["piepagina1"] != null){
          print("Dentro pie de pagina 1 desde bluetoothchannel: ${banca["piepagina1"]}");
          map[map.length] = _getMap("${banca["piepagina1"]}\n");
        }
        if(banca["piepagina2"] != null)
          map[map.length] = _getMap("${banca["piepagina2"]}\n");
        if(banca["piepagina3"] != null)
          map[map.length] = _getMap("${banca["piepagina3"]}\n");
        if(banca["piepagina4"] != null)
          map[map.length] = _getMap("${banca["piepagina4"]}\n");
        if(banca["imprimirCodigoQr"] == 1)
          map[map.length] = _getMapQR(mapVenta["codigoQr"]);
        
        map[map.length] = _getMap("\n\n\n");
      }else{
        map[map.length] = _getMap("\n\n\n");
      }

    return map;
    // print("printicket: ${map.length}");
    // for(Map<String, dynamic> map in mapVenta["jugadas"]){
    //   print("Jugada: ${map["jugada"]}");
    // }
  }

  static Map<String, dynamic> _getMap(String text, [int nWidthTimes = 0, String type = TYPE_CMD_PRINT_TEXT]){
    return {"text" : text, "nWidthTimes" : nWidthTimes, "type" : type};
  }

  static Map<String, dynamic> _getMapPrueba(String text, [int nWidthTimes = 0, String type = TYPE_CMD_PRINT_TEXT]){
    return {"text" : text, "nWidthTimes" : nWidthTimes, "type" : "prueba"};
  }

  static Map<String, dynamic> _getMapAlign(int align){
    return {"text" : align, "type" : TYPE_CMD_ALIGN};
  }

  static Map<String, dynamic> _getMapQR(String qr){
    return {"text" : qr, "type" : TYPE_CMD_PRINT_QR};
  }

  static Map<String, dynamic> _printTicketHeader(String type) {
    switch(type){
        case TYPE_ORIGINAL:
          return  _getMap("** $TYPE_ORIGINAL **\n", 1);
          break;
        case TYPE_PAGADO:
          return  _getMap("** $TYPE_ORIGINAL **\n", 1);
          break;
        case TYPE_COPIA:
          return _getMap("** $TYPE_COPIA **\n", 1);
          break;
        default:
          return _getMap("** $TYPE_CANCELADO **\n", 1);
    }
  }

  static String siEsUltimaJugadaDarSaltoDeLinea(contadorCicloJugadas, cantidadJugadas){
    String saltoLinea = "";
    if((contadorCicloJugadas + 1) == cantidadJugadas)
        saltoLinea = "\n";
    
    return saltoLinea;
  }


  static List _getJugadasPertenecienteALoteria({int idLoteria, List jugadas, String type = TYPE_ORIGINAL}){
    if(type == TYPE_PAGADO)
      return jugadas.where((j) => j["idLoteria"] == idLoteria && j["status"] == 0).toList();
    else
      return jugadas.where((j) => j["idLoteria"] == idLoteria).toList();
  }
  
}