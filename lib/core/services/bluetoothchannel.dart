import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/cmd.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/sale.dart';
import 'package:loterias/core/models/salesdetails.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class BluetoothChannel{
  static const String TYPE_ORIGINAL = "ORIGINAL";
  static const String TYPE_COPIA = "COPIA";
  static const String TYPE_CANCELADO = "CANCELADO";
  static const String TYPE_PAGADA_ONLY_MARK = "PAGADO_SOLO_MARCAR";
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
  static Ajuste _ajustes;

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

    print("BluetoothChannel printTicket ajustes: ${await Db.ajustes()}");
    _ajustes = Ajuste.fromMap(await Db.ajustes());
    Map<int, dynamic> generatedCuadre = _ajustes.descripcionTipoFormatoTicket == "Formato de ticket 2" ? generateMapTicketOtroFormato(map, type) : generateMapTicket(map, type);


    if(kIsWeb){
      // var channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8999'));
      // channel.stream.listen((message) {
      //   print("principalView received! from websocket: ${generatedCuadre.length}");
      //   List<String> generatedCuadreToWeb = [printer];
      //   for (int i = 0; i < generatedCuadre.length; i++) {
      //     print("BluetoothChannel printCuadre web: ${generatedCuadre[i]["cmd"]} : ${generatedCuadre[i]["text"]}");
      //     // if(generatedCuadre[i]["cmd"] == CMD.h1)
      //     //   generatedCuadreToWeb.add(CMD.h1Web);
      //     // if(generatedCuadre[i]["cmd"] == CMD.h2)
      //     //   generatedCuadreToWeb.add(CMD.h2Web);
      //     // if(generatedCuadre[i]["cmd"] == CMD.center)
      //     //   generatedCuadreToWeb.add(CMD.centerWeb);
      //     String cmdWeb = CMD.cmdToWeb(generatedCuadre[i]["cmd"]);
      //     if(cmdWeb != null)
      //       generatedCuadreToWeb.add(cmdWeb);

      //     generatedCuadreToWeb.add(generatedCuadre[i]["text"]);
      //   }


      //   channel.sink.add(generatedCuadreToWeb);
      //   channel.sink.close();
      // });
      _printWeb(printer, generatedCuadre);
    }else{
      _subscription = channelConnect.receiveBroadcastStream(printer["address"]).listen(
        (onData) async {
          print("Listen OnData: $onData");
          _connectado = true;
          final bool result = await _methodChannel.invokeMethod("printText", {"data" : generatedCuadre});
          disconnect();
          print("Listen OnData print: $result");
        },
        onError: (error){
          _connectado = false;
          print("Listen Error: $error");
        }
      );
    }     
     
  }

  static Future<void> printTicketV2({@required Sale sale, @required List<Salesdetails> salesdetails, @required String type}) async {
    var c = await DB.create();
    var printer = await c.getValue("printer");
    if(_connectado){
      return;
    }

    print("BluetoothChannel printTicket ajustes: ${await Db.ajustes()}");
    _ajustes = Ajuste.fromMap(await Db.ajustes());
    Map<int, dynamic> generatedCuadre = _ajustes.descripcionTipoFormatoTicket == "Formato de ticket 2" ? generateMapTicketOtroFormatoV2(sale, salesdetails, type) : generateMapTicketV2(sale, salesdetails, type);
    if(kIsWeb)
      _printWeb(printer, generatedCuadre);
    else{
      _subscription = channelConnect.receiveBroadcastStream(printer["address"]).listen(
        (onData) async {
          print("Listen OnData: $onData");
          _connectado = true;
          final bool result = await _methodChannel.invokeMethod("printText", {"data" : generatedCuadre});
          // final bool result = await _methodChannel.invokeMethod("printText", {"data" : generateMapTicketV2(sale, salesdetails, type)});
          disconnect();
          print("Listen OnData print: $result");
        },
        onError: (error){
          _connectado = false;
          print("Listen Error: $error");
        }
      );
    }
  }

  static _printWeb(var printer, Map<int, dynamic> generatedCuadre){
    var channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8999'));
    channel.stream.listen((message) {
      print("principalView received! from websocket: ${generatedCuadre.length}");
      List<String> generatedCuadreToWeb = [printer];
      for (int i = 0; i < generatedCuadre.length; i++) {
        print("BluetoothChannel printCuadre web: ${generatedCuadre[i]["cmd"]} : ${generatedCuadre[i]["text"]}");
        // if(generatedCuadre[i]["cmd"] == CMD.h1)
        //   generatedCuadreToWeb.add(CMD.h1Web);
        // if(generatedCuadre[i]["cmd"] == CMD.h2)
        //   generatedCuadreToWeb.add(CMD.h2Web);
        // if(generatedCuadre[i]["cmd"] == CMD.center)
        //   generatedCuadreToWeb.add(CMD.centerWeb);
        String cmdWeb = CMD.cmdToWeb(generatedCuadre[i]["cmd"]);
        if(cmdWeb != null)
          generatedCuadreToWeb.add(cmdWeb);

        generatedCuadreToWeb.add(generatedCuadre[i]["text"]);
      }

      generatedCuadreToWeb.add("\n\n\n\n");
      generatedCuadreToWeb.add("CUT_PAPER");

      channel.sink.add(generatedCuadreToWeb);
      channel.sink.close();
    });
  }
  
  static quickPrint() async {
    try{
      final bool result = await _methodChannel.invokeMethod("quickPrinter");
      print("quickPrint flutter: $result");
    }on PlatformException catch(e){
      print("quickPrint platformexception: ${e.toString()}");
    }
  }

  static printCuadre({@required Map<String, dynamic> map, bool imprimirNumerosGanadores = false, bool imprimirTotalesPorLoteria, bool imprimirTicketsGanadores, bool imprimirReporteResumido}) async {
    var c = await DB.create();
    var printer = await c.getValue("printer");
    if(_connectado){
      return;
    }

    Map<int, dynamic> generatedCuadre = generateCuadre(mapCuadre: map, imprimirNumerosGanadores: imprimirNumerosGanadores, imprimirTotalesPorLoteria: imprimirTotalesPorLoteria, imprimirTicketsGanadores: imprimirTicketsGanadores, imprimirReporteResumido: imprimirReporteResumido);

    if(kIsWeb){
      // var channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8999'));
      // channel.stream.listen((message) {
      //   print("principalView received! from websocket: ${generatedCuadre.length}");
      //   List<String> generatedCuadreToWeb = [printer];
      //   for (int i = 0; i < generatedCuadre.length; i++) {
      //     print("BluetoothChannel printCuadre web: ${generatedCuadre[i]["cmd"]}");
      //     // if(generatedCuadre[i]["cmd"] == CMD.h1)
      //     //   generatedCuadreToWeb.add(CMD.h1Web);
      //     // if(generatedCuadre[i]["cmd"] == CMD.h2)
      //     //   generatedCuadreToWeb.add(CMD.h2Web);
      //     // if(generatedCuadre[i]["cmd"] == CMD.center)
      //     //   generatedCuadreToWeb.add(CMD.centerWeb);
      //     String cmdWeb = CMD.cmdToWeb(generatedCuadre[i]["cmd"]);
      //     if(cmdWeb != null)
      //       generatedCuadreToWeb.add(cmdWeb);

      //     generatedCuadreToWeb.add(generatedCuadre[i]["text"]);
      //   }


        
      //   channel.sink.add(generatedCuadreToWeb);
      //   channel.sink.close();
      // });
      _printWeb(printer, generatedCuadre);
    }else{
      _subscription = channelConnect.receiveBroadcastStream(printer["address"]).listen(
        (onData) async {
          print("Listen OnData: $onData");
          _connectado = true;
          final bool result = await _methodChannel.invokeMethod("printText", {"data" : generatedCuadre});
          disconnect();
          print("Listen OnData print: $result");

          // generateCuadre(map);
        },
        onError: (error){
          _connectado = false;
          print("Listen Error: $error");
        }
      );
    }

    
     
  }
  static Future<void> printNumerosGanadores({List<Loteria> loterias}) async {
    var c = await DB.create();
    var printer = await c.getValue("printer");
    if(_connectado){
      return;
    }

    Map<int, dynamic> generatedNumerosGanadores = generateNumerosGanadores(loterias);
    // return;
    if(kIsWeb){
      _printWeb(printer, generatedNumerosGanadores);
    }else{
      _subscription = channelConnect.receiveBroadcastStream(printer["address"]).listen(
        (onData) async {
          print("Listen OnData: $onData");
          _connectado = true;
          final bool result = await _methodChannel.invokeMethod("printText", {"data" : generatedNumerosGanadores});
          disconnect();
          print("Listen OnData print: $result");

          // generateCuadre(map);
        },
        onError: (error){
          _connectado = false;
          print("Listen Error: $error");
        }
      );
    }

    
     
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
        map[map.length] = _getMapNuevo(cmd: CMD.center);
        map[map.length] = (normalOPrueba) ? _getMapNuevo(text: content) : _getMapNuevo(text: content);
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

  static printTextCmd({String content, int nWidthTimes = 1, cmd: CMD.h1}) async {
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
        map[map.length] = _getMapNuevo(text: content, cmd: cmd );
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

static printTextCmdMap({String content, map, cmd: CMD.h1}) async {
    var c = await DB.create();
    var printer = await c.getValue("printer");
    if(_connectado){
      return;
    }

    
     _subscription = channelConnect.receiveBroadcastStream(printer["address"]).listen(
      (onData) async {
        print("Listen OnData: $onData");
        _connectado = true;
        // var map = Map<int, dynamic>();
        // map[map.length] = _getMapNuevo(text: content, cmd: cmd );
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

  static Map<int, dynamic> generateCuadre({@required Map<String, dynamic> mapCuadre, bool imprimirNumerosGanadores = false, bool imprimirTotalesPorLoteria, bool imprimirTicketsGanadores, bool imprimirReporteResumido}){
    Map<int, dynamic> map = Map<int, dynamic>();
    map[map.length] = _getMapNuevo(cmd: CMD.center);
    map[map.length] = _getMapNuevo(text:"Cuadre\n", cmd: CMD.h1);
    if(mapCuadre["fechaInicial"] != null && mapCuadre["fechaFinal"] != null){
      print("generateCuadre FechaInicial: ${mapCuadre['fechaInicial']} ");
      print("generateCuadre FechaFinal: ${mapCuadre['fechaFinal']} ");
      String fechas = MyDate.datesToString(DateTime.parse(mapCuadre["fechaInicial"]), DateTime.parse(mapCuadre["fechaFinal"]), true);
      map[map.length] = _getMapNuevo(text:"$fechas\n", cmd: CMD.h2);
    }else{
      map[map.length] = _getMapNuevo(text:"${mapCuadre["fecha"]}\n", cmd: CMD.h1);
    }

    map[map.length] = _getMapNuevo(text:"${mapCuadre["banca"]["descripcion"]}\n", cmd: CMD.h1);
    map[map.length] = _getMapNuevo(cmd: CMD.left);

    if(imprimirReporteResumido){
      map[map.length] = _getMapNuevo(text:"En fondo:         ${mapCuadre["balanceHastaLaFecha"]}\n");
      map[map.length] = _getMapNuevo(text:"Vendido:          ${Utils.toCurrency(mapCuadre["ventas"], true)}\n");
      map[map.length] = _getMapNuevo(text:"Recargado:        ${Utils.toCurrency(mapCuadre["recargas"], true)}\n");
      map[map.length] = _getMapNuevo(text:"Porciento:        ${Utils.toCurrency(mapCuadre["comisiones"], true)}\n");
      map[map.length] = _getMapNuevo(text:"Descontado:       ${Utils.toCurrency(mapCuadre["descuentos"], true)}\n");
      map[map.length] = _getMapNuevo(text:"Sacado:           ${Utils.toCurrency(mapCuadre["premios"], true)}\n");
      map[map.length] = _getMapNuevo(text:"Total:            ${Utils.toCurrency(mapCuadre["neto"], true)}\n");
      map[map.length] = _getMapNuevo(text:"En fondo + total: ${Utils.toCurrency(mapCuadre["balanceActual"], true)}\n\n");
    }else{
      map[map.length] = _getMapNuevo(text:"Balance hasta la fecha: ${mapCuadre["balanceHastaLaFecha"]}\n");
      map[map.length] = _getMapNuevo(text:"Tickets pendientes: ${mapCuadre["pendientes"]}\n");
      map[map.length] = _getMapNuevo(text:"Tickets perdedores: ${mapCuadre["perdedores"]}\n");
      map[map.length] = _getMapNuevo(text:"Tickets ganadores:  ${mapCuadre["ganadores"]}\n");
      map[map.length] = _getMapNuevo(text:"Total:              ${mapCuadre["total"]}\n");
      map[map.length] = _getMapNuevo(text:"Ventas:             ${Utils.toCurrency(mapCuadre["ventas"], true)}\n");
      map[map.length] = _getMapNuevo(text:"Recargas:           ${Utils.toCurrency(mapCuadre["recargas"], true)}\n");
      map[map.length] = _getMapNuevo(text:"Comisiones:         ${Utils.toCurrency(mapCuadre["comisiones"], true)}\n");
      map[map.length] = _getMapNuevo(text:"descuentos:         ${Utils.toCurrency(mapCuadre["descuentos"], true)}\n");
      map[map.length] = _getMapNuevo(text:"premios:            ${Utils.toCurrency(mapCuadre["premios"], true)}\n");
      map[map.length] = _getMapNuevo(text:"neto:               ${Utils.toCurrency(mapCuadre["neto"], true)}\n");
      map[map.length] = _getMapNuevo(text:"Balance mas ventas: ${Utils.toCurrency(mapCuadre["balanceActual"], true)}\n\n");
    }
    
    
    print("bluetooth channel cuadure: ${map.toString()}");
    
    
    
    
    /****************** NUMEROS GANADORES ************************/
    String espacioPrimera = "        ";
    String espacioSegunda = "            ";
    String espacioTercera = "                ";
    String espacioPick3 = "                    ";
    String espacioPick4 = "                        ";
    String espacioTotal = "                           ";
    int espaciosYaAgregados = 0; 
    String textoAImprimir = "";

    if(imprimirNumerosGanadores){
      map[map.length] = _getMapNuevo(cmd: CMD.center);
    map[map.length] = _getMapNuevo(text: "Numeros Ganadores\n\n");
    map[map.length] = _getMapNuevo(cmd: CMD.left);

    map[map.length] = _getMapNuevo(text:"LOTERIA 1RA 2DA 3RA PI3 PI4\n", cmd: CMD.p);
    espacioPrimera = "        ";
    espacioSegunda = "            ";
    espacioTercera = "                ";
    espacioPick3 = "                    ";
    espacioPick4 = "                        ";
    espacioTotal = "                           ";
    espaciosYaAgregados = 0; 
    textoAImprimir = "";
    List<Loteria> listaLoteria = mapCuadre["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList();
    for(int i=0; i < listaLoteria.length; i++){
      Loteria element = listaLoteria[i];
      espaciosYaAgregados = 0; 
      textoAImprimir = "";
      map[map.length] = _getMapNuevo(text: element.abreviatura, cmd: CMD.p);
      espaciosYaAgregados = element.abreviatura.length;

      if(element.primera == null){
        textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioPrimera.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados);
        map[map.length] = _getMapNuevo(text: textoAImprimir);
        espaciosYaAgregados += textoAImprimir.length;
      }
      else{
        textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioPrimera.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados) + element.primera;
        map[map.length] = _getMapNuevo(text: textoAImprimir, cmd: CMD.p);
        espaciosYaAgregados += textoAImprimir.length;
      }

      if(element.segunda == null){
        textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioSegunda.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados);
        map[map.length] = _getMapNuevo(text: textoAImprimir);
        espaciosYaAgregados += textoAImprimir.length;
      }
      else{
        textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioSegunda.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados) + element.segunda;
        map[map.length] = _getMapNuevo(text: textoAImprimir, cmd: CMD.p);
        espaciosYaAgregados += textoAImprimir.length;
      }

      if(element.tercera == null){
        textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioTercera.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados);
        map[map.length] = _getMapNuevo(text: textoAImprimir);
        espaciosYaAgregados += textoAImprimir.length;
      }
      else{
        textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioTercera.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados) + element.tercera;
        map[map.length] = _getMapNuevo(text: textoAImprimir, cmd: CMD.p);
        espaciosYaAgregados += textoAImprimir.length;
      }

      if(element.pick3 == null){
        textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioPick3.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados);
        map[map.length] = _getMapNuevo(text: textoAImprimir);
        espaciosYaAgregados += textoAImprimir.length;
      }
      else{
        textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioPick3.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados) + element.pick3;
        map[map.length] = _getMapNuevo(text: textoAImprimir, cmd: CMD.p);
        espaciosYaAgregados += textoAImprimir.length;
      }

      if(element.pick4 == null){
        textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioPick4.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados);
        map[map.length] = _getMapNuevo(text: textoAImprimir);
        espaciosYaAgregados += textoAImprimir.length;
      }
      else{
        textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioPick4.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados) + element.pick4;
        map[map.length] = _getMapNuevo(text: textoAImprimir, cmd: CMD.p);
        espaciosYaAgregados += textoAImprimir.length;
      }

      
      map[map.length] = _getMapNuevo(text:"\n");
      print("bluetoothChannel generateCuadre Loteria abreviatura: ${element.abreviatura} 1ra: ${element.primera} 2da: ${element.segunda} 3ra: ${element.tercera}");
    }

    }


    /****************** TOTALES POR LOTERIA ************************/
    // map[map.length] = _getMapNuevo(cmd: CMD.center);
    if(imprimirTotalesPorLoteria){
      map[map.length] = _getMapNuevo(text:"\n\n");
      map[map.length] = _getMapNuevo(cmd: CMD.center);
      map[map.length] = _getMapNuevo(text: "Totales por loteria\n\n");
      map[map.length] = _getMapNuevo(cmd: CMD.left);
      map[map.length] = _getMapNuevo(text:"LOTERIA VENT.  COM.  PREM.  NETO\n", cmd: CMD.p);
      String espacioHastaVenta = "        ";
      String espacioHastaComision = espacioHastaVenta + "       ";
      String espacioHastaPremio = espacioHastaComision + "      ";
      String espacioHastaNeto = espacioHastaPremio + "       ";
      espacioTotal = "                                  ";
      espaciosYaAgregados = 0; 
      textoAImprimir = "";
      List lista = List.from(mapCuadre["loterias"]);
      for(int i=0; i < lista.length; i++){
        Map<String, dynamic> element = lista[i];
        espaciosYaAgregados = 0; 
        textoAImprimir = "";
        map[map.length] = _getMapNuevo(text: element["abreviatura"], cmd: CMD.p);
        espaciosYaAgregados = element["abreviatura"].toString().length;

        if(element["ventas"] == null){
          textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioHastaVenta.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados);
          map[map.length] = _getMapNuevo(text: textoAImprimir);
          espaciosYaAgregados += textoAImprimir.length;
        }
        else{
          textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioHastaVenta.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados) + Utils.toCurrency(element["ventas"]);
          map[map.length] = _getMapNuevo(text: textoAImprimir, cmd: CMD.p);
          espaciosYaAgregados += textoAImprimir.length;
        }

        if(element["comisiones"] == null){
          textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioHastaComision.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados);
          map[map.length] = _getMapNuevo(text: textoAImprimir);
          espaciosYaAgregados += textoAImprimir.length;
        }
        else{
          textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioHastaComision.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados) + Utils.toCurrency(element["comisiones"]);
          map[map.length] = _getMapNuevo(text: textoAImprimir, cmd: CMD.p);
          espaciosYaAgregados += textoAImprimir.length;
        }

        if(element["premios"] == null){
          textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioHastaPremio.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados);
          map[map.length] = _getMapNuevo(text: textoAImprimir);
          espaciosYaAgregados += textoAImprimir.length;
        }
        else{
          textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioHastaPremio.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados) + Utils.toCurrency(element["premios"]);
          map[map.length] = _getMapNuevo(text: textoAImprimir, cmd: CMD.p);
          espaciosYaAgregados += textoAImprimir.length;
        }

        if(element["neto"] == null){
          textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioHastaNeto.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados);
          map[map.length] = _getMapNuevo(text: textoAImprimir);
          espaciosYaAgregados += textoAImprimir.length;
        }
        else{
          textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioHastaNeto.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados) + Utils.toCurrency(element["neto"]);
          map[map.length] = _getMapNuevo(text: textoAImprimir, cmd: CMD.p);
          espaciosYaAgregados += textoAImprimir.length;
        }
        
        map[map.length] = _getMapNuevo(text:"\n");
        // print("bluetoothChannel generateCuadre Loteria abreviatura: ${element.abreviatura} 1ra: ${element.primera} 2da: ${element.segunda} 3ra: ${element.tercera}");
      }
    }

    /****************** TICKETS GANADORES ************************/
    // map[map.length] = _getMapNuevo(cmd: CMD.center);
    if(imprimirTicketsGanadores){
      map[map.length] = _getMapNuevo(text:"\n\n");
      map[map.length] = _getMapNuevo(cmd: CMD.center);
      map[map.length] = _getMapNuevo(text: "Tickets ganadores\n\n");
      map[map.length] = _getMapNuevo(cmd: CMD.left);
      map[map.length] = _getMapNuevo(text:"# TICKET  A PAGAR  FECHA\n", cmd: CMD.p);
      String espacioHastaAPagar = "          ";
      String espacioHastaFecha = espacioHastaAPagar + "         ";
      espacioTotal = "                        ";
      espaciosYaAgregados = 0; 
      textoAImprimir = "";
      List listaTicketGanadores = List.from(mapCuadre["ticketsGanadores"]);
      for(int i=0; i < listaTicketGanadores.length; i++){
        Map<String, dynamic> element = listaTicketGanadores[i];
        espaciosYaAgregados = 0; 
        textoAImprimir = "";
        map[map.length] = _getMapNuevo(text: Utils.toSecuencia("", BigInt.from(element["idTicket"]), false), cmd: CMD.p);
        espaciosYaAgregados =  Utils.toSecuencia("", BigInt.from(element["idTicket"]), false).length;

        
        if(element["montoAPagar"] == null){
          textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioHastaAPagar.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados);
          map[map.length] = _getMapNuevo(text: textoAImprimir);
          espaciosYaAgregados += textoAImprimir.length;
        }
        else{
          textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioHastaAPagar.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados) + Utils.toCurrency(element["montoAPagar"]);
          map[map.length] = _getMapNuevo(text: textoAImprimir, cmd: CMD.p);
          espaciosYaAgregados += textoAImprimir.length;
        }

        if(element["fecha"] == null){
          textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioHastaFecha.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados);
          map[map.length] = _getMapNuevo(text: textoAImprimir);
          espaciosYaAgregados += textoAImprimir.length;
        }
        else{
          textoAImprimir = Utils.quitarEspaciosAUnString(tamanoString: espacioHastaFecha.length, cantidadDeCaracteresAQuitar: espaciosYaAgregados) + element["fecha"];
          map[map.length] = _getMapNuevo(text: textoAImprimir, cmd: CMD.p);
          espaciosYaAgregados += textoAImprimir.length;
        }
        
        map[map.length] = _getMapNuevo(text:"\n");
        // print("bluetoothChannel generateCuadre Loteria abreviatura: ${element.abreviatura} 1ra: ${element.primera} 2da: ${element.segunda} 3ra: ${element.tercera}");
      }
    }

    map[map.length] = _getMapNuevo(text:"\n\n");

    return map;
  }

  static Map<int, dynamic> generateNumerosGanadores(List<Loteria> loterias){
    Map<int, dynamic> map = Map<int, dynamic>();
    String espaciosEnBlancoOcupadosEnPrimera = "        ";
    String espaciosEnBlancoOcupadosEnSegunda = "            ";
    String espaciosEnBlancoOcupadosEnTercera = "                ";
    String espaciosEnBlancoOcupadosEnPick3 = "                    ";
    String espaciosEnBlancoOcupadosEnPick4 = "                        ";
    String espacioTotal = "                           ";
    int cantidadDeCaracteresYaAgregados = 0; 
    String textoAImprimir = "";

    map[map.length] = _getMapNuevo(cmd: CMD.center);
    map[map.length] = _getMapNuevo(text: "Numeros Ganadores\n\n");
    map[map.length] = _getMapNuevo(cmd: CMD.left);

    map[map.length] = _getMapNuevo(text:"LOTERIA 1RA 2DA 3RA PI3 PI4\n", cmd: CMD.p);
    cantidadDeCaracteresYaAgregados = 0; 
    textoAImprimir = "";
    for(int i=0; i < loterias.length; i++){
      Loteria element = loterias[i];
      cantidadDeCaracteresYaAgregados = 0; 
      textoAImprimir = "";
      map[map.length] = _getMapNuevo(text: obtenerAbreviaturaLoteriaCon6CaracteresMaximo(element), cmd: CMD.p);
      cantidadDeCaracteresYaAgregados = obtenerAbreviaturaLoteriaCon6CaracteresMaximo(element).length;

      cantidadDeCaracteresYaAgregados = anadirCaracteresAImprimirDelPrimerPremio(element, map, textoAImprimir, espaciosEnBlancoOcupadosEnPrimera, cantidadDeCaracteresYaAgregados);
      cantidadDeCaracteresYaAgregados = anadirCaracteresAImprimirDelSegundoPremio(element, map, textoAImprimir, espaciosEnBlancoOcupadosEnSegunda, cantidadDeCaracteresYaAgregados);
      cantidadDeCaracteresYaAgregados = anadirCaracteresAImprimirDelTercerPremio(element, map, textoAImprimir, espaciosEnBlancoOcupadosEnTercera, cantidadDeCaracteresYaAgregados);
      cantidadDeCaracteresYaAgregados = anadirCaracteresAImprimirDelPremioPick3(element, map, textoAImprimir, espaciosEnBlancoOcupadosEnPick3, cantidadDeCaracteresYaAgregados);
      cantidadDeCaracteresYaAgregados = anadirCaracteresAImprimirDelPremioPick4(element, map, textoAImprimir, espaciosEnBlancoOcupadosEnPick4, cantidadDeCaracteresYaAgregados);
      
      map[map.length] = _getMapNuevo(text:"\n");
      print("bluetoothChannel generateCuadre Loteria abreviatura: ${element.abreviatura} 1ra: ${element.primera} 2da: ${element.segunda} 3ra: ${element.tercera} caracteresOcupados: $cantidadDeCaracteresYaAgregados");
    }
      map[map.length] = _getMapNuevo(text:"\n\n\n");

    return map;
  }

  static String obtenerAbreviaturaLoteriaCon6CaracteresMaximo(Loteria loteria){
    if(loteria.abreviatura == null)
      return '';

    return loteria.abreviatura.length < 7 ? loteria.abreviatura : loteria.abreviatura.substring(0, 6);
  }

  static int anadirCaracteresAImprimirDelPrimerPremio(Loteria loteria, Map<int, dynamic> ticketYaGenerado, String textoAImprimir, String espaciosEnBlancoOcupadosPorElPrimerPremio, int cantidadDeCaracteresYaAgregados){
    textoAImprimir = Utils.sustituirEspaciosEnBlancoPorCaracteresDados(cantidadDeEspaciosEnBlanco: espaciosEnBlancoOcupadosPorElPrimerPremio.length, cantidadDeCaracteresASustituir: cantidadDeCaracteresYaAgregados);
    if(loteria.primera != null)
      textoAImprimir += loteria.primera;
    ticketYaGenerado[ticketYaGenerado.length] = _getMapNuevo(text: textoAImprimir, cmd: loteria.primera != null ? CMD.p : CMD.h2);
    cantidadDeCaracteresYaAgregados += textoAImprimir.length;
    return cantidadDeCaracteresYaAgregados;
  }

  static int anadirCaracteresAImprimirDelSegundoPremio(Loteria loteria, Map<int, dynamic> ticketYaGenerado, String textoAImprimir, String espaciosEnBlancoOcupadosPorSegundoPremio, int cantidadDeCaracteresYaAgregados){
    textoAImprimir = Utils.sustituirEspaciosEnBlancoPorCaracteresDados(cantidadDeEspaciosEnBlanco: espaciosEnBlancoOcupadosPorSegundoPremio.length, cantidadDeCaracteresASustituir: cantidadDeCaracteresYaAgregados);
    if(loteria.segunda != null)
      textoAImprimir += loteria.segunda;
    ticketYaGenerado[ticketYaGenerado.length] = _getMapNuevo(text: textoAImprimir, cmd: loteria.segunda != null ? CMD.p : CMD.h2);
    cantidadDeCaracteresYaAgregados += textoAImprimir.length;
    return cantidadDeCaracteresYaAgregados;
  }

  static int anadirCaracteresAImprimirDelTercerPremio(Loteria loteria, Map<int, dynamic> ticketYaGenerado, String textoAImprimir, String espaciosEnBlancoOcupadosPorElTercerPremio, int cantidadDeCaracteresYaAgregados){
    textoAImprimir = Utils.sustituirEspaciosEnBlancoPorCaracteresDados(cantidadDeEspaciosEnBlanco: espaciosEnBlancoOcupadosPorElTercerPremio.length, cantidadDeCaracteresASustituir: cantidadDeCaracteresYaAgregados);
    if(loteria.tercera != null)
      textoAImprimir += loteria.tercera;
    ticketYaGenerado[ticketYaGenerado.length] = _getMapNuevo(text: textoAImprimir, cmd: loteria.tercera != null ? CMD.p : CMD.h2);
    cantidadDeCaracteresYaAgregados += textoAImprimir.length;
    return cantidadDeCaracteresYaAgregados;
  }

  static int anadirCaracteresAImprimirDelPremioPick3(Loteria loteria, Map<int, dynamic> ticketYaGenerado, String textoAImprimir, String espaciosEnBlancoOcupadosPorElPremioPick3, int cantidadDeCaracteresYaAgregados){
    textoAImprimir = Utils.sustituirEspaciosEnBlancoPorCaracteresDados(cantidadDeEspaciosEnBlanco: espaciosEnBlancoOcupadosPorElPremioPick3.length, cantidadDeCaracteresASustituir: cantidadDeCaracteresYaAgregados);
    if(loteria.pick3 != null)
      textoAImprimir += loteria.pick3;
    ticketYaGenerado[ticketYaGenerado.length] = _getMapNuevo(text: textoAImprimir, cmd: loteria.pick3 != null ? CMD.p : CMD.h2);
    cantidadDeCaracteresYaAgregados += textoAImprimir.length;
    return cantidadDeCaracteresYaAgregados;
  }

  static int anadirCaracteresAImprimirDelPremioPick4(Loteria loteria, Map<int, dynamic> ticketYaGenerado, String textoAImprimir, String espaciosEnBlancoOcupadosPorElPremioPick4, int cantidadDeCaracteresYaAgregados){
    textoAImprimir = Utils.sustituirEspaciosEnBlancoPorCaracteresDados(cantidadDeEspaciosEnBlanco: espaciosEnBlancoOcupadosPorElPremioPick4.length, cantidadDeCaracteresASustituir: cantidadDeCaracteresYaAgregados);
    if(loteria.pick4 != null)
      textoAImprimir += loteria.pick4;
    ticketYaGenerado[ticketYaGenerado.length] = _getMapNuevo(text: textoAImprimir, cmd: loteria.pick4 != null ? CMD.p : CMD.h2);
    cantidadDeCaracteresYaAgregados += textoAImprimir.length;
    return cantidadDeCaracteresYaAgregados;
  }

  static quitarOPonerEspaciosJugada({primeraJugadaEnLaFila, montoAnterior = '', espaciosDePrimerMontoA2daJugada}){
        
            // console.log("Dentro else quitarEspacioJugada");
            
            return quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosDePrimerMontoA2daJugada, montoAnterior);
        

        // return '';
      }

      static quitarOPonerEspaciosMonto({primerMontoEnLaFila, jugadaAnterior = '', espaciosDeJugadaAMonto = ''}){
        var espaciosUtlimaJugada = "                     "; //21 espacios
        // if(primerMontoEnLaFila){
            return quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosDeJugadaAMonto, jugadaAnterior);
        // }else{
            return quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosDeJugadaAMonto, jugadaAnterior);
        // }
            
        return '';
      }

  static quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(tamano, String jugadaOMonto){
        // print("tamano: $tamano - ${tamano.length} | jugadaOMonto: $jugadaOMonto - ${jugadaOMonto.length}");
        // print("tamanoFinal: ${tamano.substring(0, tamano.length - jugadaOMonto.length)} - ${tamano.substring(0, tamano.length - jugadaOMonto.length).length}");
        var espaciosAQuitarAlTamano = tamano.length - jugadaOMonto.length;
        if(espaciosAQuitarAlTamano < 0)
          return "";
        else
          return tamano.substring(0, tamano.length - jugadaOMonto.length);
      }

  static Map<int, dynamic> generateMapTicket(Map<String, dynamic> mapVenta, String typeTicket){
    List listMapToPrint = [];
    
    

    print("generateMapTicket: ${mapVenta.toString()}");
    Map<int, dynamic> map = Map<int, dynamic>();
    map[map.length] = _getMapNuevo(cmd: CMD.center);
    if(_ajustes.imprimirNombreConsorcio == 1)
      map[map.length] = _getMapNuevo(text:"${_ajustes.consorcio}\n\n", cmd: CMD.h1);
    if(_ajustes.imprimirNombreBanca == 1)
      map[map.length] = _getMapNuevo(text:"${mapVenta["banca"]["descripcion"]}\n", cmd: CMD.h1);
      

    map[map.length] = _printTicketHeader(typeTicket);
    // var fecha = DateTime.parse(mapVenta["created_at"]);
    //${DateFormat('EEEE').format(fecha)} 
    // map[map.length] = _getMapNuevo(text:"${mapVenta["created_at"]}\n", cmd: CMD.p);
    map[map.length] = _getMapNuevo(text:"Ticket:" + Utils.toSecuencia(mapVenta["banca"]["codigo"], BigInt.from(mapVenta["idTicket"])) + "\n", cmd: CMD.p);
    map[map.length] = _getMapNuevo(text:"Fecha: ${mapVenta["fecha"]}\n", cmd: CMD.p);
    if(typeTicket == TYPE_ORIGINAL || typeTicket == TYPE_PAGADO)
      map[map.length] = _getMapNuevo(text:"${mapVenta["codigoBarra"]}\n", cmd: CMD.h1);
    
    double total = 0;
    for(Map<String, dynamic> loteria in mapVenta["loterias"]){
      bool primerCicloJugadas = true;
      int contadorCicleJugadas = 0;
      double totalPorLoteria = 0;
      
      
      List jugadas = _getJugadasPertenecienteALoteria(jugadas: mapVenta["jugadas"], idLoteria: loteria["id"], type: typeTicket);
      if(jugadas.isNotEmpty){
        // totalPorLoteria += Utils.toDouble(jugada["monto"].toString());
        map[map.length] = _getMapNuevo(cmd: CMD.center);
        map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
        map[map.length] = _getMapNuevo(text:"${loteria["descripcion"]}: ${Utils.toPrintCurrency(_getTotalPertenecienteALoteria(jugadas), true, false)}\n");
        map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
        
        for(int contador=0; contador < jugadas.length; contador++){
          Map<String, dynamic> jugada = jugadas[contador];
          String espaciosPrimerMonto = "         ";
          String espaciosSegundaJugada = "       ";
          String espaciosSegundoMonto = "         ";
            if(loteria["id"] != jugada["idLoteria"])
              continue;

          total += Utils.toDouble(jugada["monto"].toString());
          totalPorLoteria += Utils.toDouble(jugada["monto"].toString());

          map[map.length] = _getMapNuevo(cmd: CMD.left);
          if(primerCicloJugadas){
            map[map.length] = _getMapNuevo(text:"JUGADA   MONTO  JUGADA   MONTO\n");
            primerCicloJugadas = false;
          }
          if(((contadorCicleJugadas + 1) % 2) == 0){ //PAR
            String jugadaAnterior = Utils.agregarSignoYletrasParaImprimir(jugadas[contador - 1]["jugada"].toString(), jugadas[contador - 1]["sorteo"]);
            String montoAnterior = Utils.toPrintCurrency(jugadas[contador - 1]["monto"].toString());
            espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaAnterior) + montoAnterior;
            
            espaciosSegundaJugada = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundaJugada, montoAnterior);
            espaciosSegundoMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundoMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
            // map[map.length] = _getMapNuevo(text:"                ${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
            // map[map.length] = _getMapNuevo(text:"                         ${jugada["monto"]}\n");
            map[map.length] = _getMapNuevo(text:"$espaciosSegundaJugada${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
            map[map.length] = _getMapNuevo(text:"$espaciosSegundoMonto${Utils.toPrintCurrency(jugada["monto"])}\n");
          }else{
            espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
            map[map.length] = _getMapNuevo(text:Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"]));
            map[map.length] = _getMapNuevo(text:"$espaciosPrimerMonto${Utils.toPrintCurrency(jugada["monto"])}" + siEsUltimaJugadaDarSaltoDeLinea(contadorCicleJugadas, jugadas.length));
          }

          contadorCicleJugadas++;
        }

        // map[map.length] = _getMapNuevo(cmd: CMD.center);
        // int loteriasLength = (typeTicket == TYPE_PAGADO) ? mapVenta["loterias"].length - 1 : mapVenta["loterias"].length;
        // if(loteriasLength > 1)
        //   map[map.length] = _getMapNuevo(text:"\n total: $totalPorLoteria \n");
        
        }

        print("loteriaSuperpale: $loteria");
        // continue;
        
        if(loteria["loteriaSuperpale"] == null)
          continue;
          
        for(Map<String, dynamic> ls in loteria["loteriaSuperpale"]){
          jugadas = _getJugadasSuperpalePertenecienteALoteria(jugadas: mapVenta["jugadas"], idLoteria: loteria["id"], idLoteriaSuperpale: ls["id"], type: typeTicket);
          if(jugadas.isNotEmpty){
            primerCicloJugadas = true;
            contadorCicleJugadas = 0;
            totalPorLoteria = 0;
            
            map[map.length] = _getMapNuevo(cmd: CMD.center);
            map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
            map[map.length] = _getMapNuevo(text:"Super pale (${loteria["descripcion"]}/${ls["descripcion"]}): ${Utils.toPrintCurrency(_getTotalPertenecienteALoteria(jugadas), true, false)}\n", cmd: CMD.p);
            // map[map.length] = _getMapNuevo(text:"Super pale", );
            // map[map.length] = _getMapNuevo(text:"(${loteria["descripcion"]}/${ls["descripcion"]})", cmd: CMD.p);
            // map[map.length] = _getMapNuevo(text:")", cmd: CMD.h1);
            map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
            
            for(int contador=0; contador < jugadas.length; contador++){
              Map<String, dynamic> jugada = jugadas[contador];
              String espaciosPrimerMonto = "         ";
              String espaciosSegundaJugada = "       ";
              String espaciosSegundoMonto = "         ";
                if(loteria["id"] != jugada["idLoteria"])
                  continue;

              total += Utils.toDouble(jugada["monto"].toString());
              totalPorLoteria += Utils.toDouble(jugada["monto"].toString());

              map[map.length] = _getMapNuevo(cmd: CMD.left);
              if(primerCicloJugadas){
                map[map.length] = _getMapNuevo(text:"JUGADA   MONTO  JUGADA   MONTO\n");
                primerCicloJugadas = false;
              }
              if(((contadorCicleJugadas + 1) % 2) == 0){ //PAR
                String jugadaAnterior = Utils.agregarSignoYletrasParaImprimir(jugadas[contador - 1]["jugada"].toString(), jugadas[contador - 1]["sorteo"]);
                String montoAnterior = Utils.toPrintCurrency(jugadas[contador - 1]["monto"].toString());
                espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaAnterior) + montoAnterior;
                
                espaciosSegundaJugada = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundaJugada, montoAnterior);
                espaciosSegundoMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundoMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
                // map[map.length] = _getMapNuevo(text:"                ${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
                // map[map.length] = _getMapNuevo(text:"                         ${jugada["monto"]}\n");
                map[map.length] = _getMapNuevo(text:"$espaciosSegundaJugada${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
                map[map.length] = _getMapNuevo(text:"$espaciosSegundoMonto${Utils.toPrintCurrency(jugada["monto"])}\n");
              }else{
                espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
                map[map.length] = _getMapNuevo(text:Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"]));
                map[map.length] = _getMapNuevo(text:"$espaciosPrimerMonto${Utils.toPrintCurrency(jugada["monto"])}" + siEsUltimaJugadaDarSaltoDeLinea(contadorCicleJugadas, jugadas.length));
              }

              contadorCicleJugadas++;
            }

            // map[map.length] = _getMapNuevo(cmd: CMD.center);
            // int loteriasLength = (typeTicket == TYPE_PAGADO) ? mapVenta["loterias"].length - 1 : mapVenta["loterias"].length;
            // if(loteriasLength > 1)
            //   map[map.length] = _getMapNuevo(text:"\n total: $totalPorLoteria \n");

            }
        }
      
      
      }
        

      map[map.length] = _getMapNuevo(cmd: CMD.center);
      if(mapVenta["hayDescuento"] == 1){
        map[map.length] = _getMapNuevo(text:"subTotal: ${mapVenta["total"]}\n");
        map[map.length] = _getMapNuevo(text:"descuento: ${mapVenta["descuentoMonto"]}\n");
        total -= Utils.toDouble(mapVenta["descuentoMonto"].toString());
      }

      String saltoLineaTotal = "\n";
      if((typeTicket != TYPE_ORIGINAL && typeTicket != TYPE_PAGADO) || mapVenta["banca"]["imprimirCodigoQr"] == 0)
        saltoLineaTotal += "\n\n";
      
      map[map.length] = _getMapNuevo(text:"TOTAL: ${Utils.toPrintCurrency(total, true, false)}$saltoLineaTotal", cmd: CMD.h1);
    
      if(typeTicket == TYPE_CANCELADO)
        map[map.length] = _getMapNuevo(text:"** CANCELADO **\n\n\n", cmd: CMD.h1);
      else if(typeTicket == TYPE_PAGADA_ONLY_MARK)
        map[map.length] = _getMapNuevo(text:"** PAGADO **\n\n\n", cmd: CMD.h1);
      
      if(typeTicket == TYPE_ORIGINAL){
        Map<String, dynamic> banca = mapVenta["banca"];
        print("bluetoothchannel generateticket banca: ${banca.toString()}");
        if(banca["piepagina1"] != null){
          print("Dentro pie de pagina 1 desde bluetoothchannel: ${banca["piepagina1"]}");
          map[map.length] = _getMapNuevo(text:"${banca["piepagina1"]}\n", cmd: CMD.p);
        }
        if(banca["piepagina2"] != null)
          map[map.length] = _getMapNuevo(text:"${banca["piepagina2"]}\n", cmd: CMD.p);
        if(banca["piepagina3"] != null)
          map[map.length] = _getMapNuevo(text:"${banca["piepagina3"]}\n", cmd: CMD.p);
        if(banca["piepagina4"] != null)
          map[map.length] = _getMapNuevo(text:"${banca["piepagina4"]}\n", cmd: CMD.p);
        if(banca["imprimirCodigoQr"] == 1)
          map[map.length] = _getMapNuevo(text:mapVenta["codigoQr"], cmd: CMD.qr);
        
        map[map.length] = _getMapNuevo(text:"\n\n\n");
      }else{
        map[map.length] = _getMapNuevo(text:"\n\n\n");
      }

    return map;
    // print("printicket: ${map.length}");
    // for(Map<String, dynamic> map in mapVenta["jugadas"]){
    //   print("Jugada: ${map["jugada"]}");
    // }
  }

  static Map<int, dynamic> generateMapTicketOtroFormato(Map<String, dynamic> mapVenta, String typeTicket){
    
    
    // Venta venta = Venta.fromMap(mapVenta);
    print("generateMapTicket: ${mapVenta.toString()}");
    Map<int, dynamic> map = Map<int, dynamic>();
    map[map.length] = _getMapNuevo(cmd: CMD.textBoldOn);
    map[map.length] = _getMapNuevo(cmd: CMD.center);
    String headerJugadas = "";
    String contentJugadas = "";
    if(_ajustes.imprimirNombreConsorcio == 1)
      map[map.length] = _getMapNuevo(text:"${(_ajustes.consorcio != null) ? _ajustes.consorcio.toUpperCase() : ''}\n\n", cmd: CMD.h1);
    if(_ajustes.imprimirNombreBanca == 1)
      map[map.length] = _getMapNuevo(text:"${mapVenta["banca"]["descripcion"]}\n", cmd: CMD.h1);
    // map[map.length] = _getMapNuevo(text:"${mapVenta["banca"]["descripcion"]}\n", cmd: CMD.h1);
    // map[map.length] = _printTicketHeader(typeTicket);

    // var fecha = DateTime.parse(mapVenta["created_at"]);
    //${DateFormat('EEEE').format(fecha)} 
    // map[map.length] = _getMapNuevo(text:"${mapVenta["created_at"]}\n", cmd: CMD.p);
    map[map.length] = _getMapNuevo(text:"TICKET:" + Utils.toSecuencia(mapVenta["banca"]["codigo"], BigInt.from(mapVenta["idTicket"])) + "\n", cmd: CMD.p);
    map[map.length] = _getMapNuevo(text:"FECHA: ${mapVenta["fecha"]}\n", cmd: CMD.p);
    // if(typeTicket == TYPE_ORIGINAL || typeTicket == TYPE_PAGADO)
    //   map[map.length] = _getMapNuevo(text:"${mapVenta["codigoBarra"]}\n", cmd: CMD.h1);
    
    double total = 0;
     map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
     map[map.length] = _getMapNuevo(text:"TP JUGADA MONTO\n", cmd: CMD.h1);
    for(Map<String, dynamic> loteria in mapVenta["loterias"]){
      bool primerCicloJugadas = true;
      int contadorCicleJugadas = 0;
      double totalPorLoteria = 0;
      
      
      List jugadas = _getJugadasPertenecienteALoteria(jugadas: mapVenta["jugadas"], idLoteria: loteria["id"], type: typeTicket);
      if(jugadas.isNotEmpty){
        // totalPorLoteria += Utils.toDouble(jugada["monto"].toString());
        map[map.length] = _getMapNuevo(cmd: CMD.center);
        map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
        // map[map.length] = _getMapNuevo(text:"${loteria["descripcion"]}: ${_getTotalPertenecienteALoteria(jugadas)}\n", cmd: CMD.h1);
        map[map.length] = _getMapNuevo(text:"${loteria["descripcion"]}\n", cmd: CMD.h1);
        map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);

        for(int contador=0; contador < jugadas.length; contador++){
          Map<String, dynamic> jugada = jugadas[contador];
          String espaciosPrimerMonto = "       ";
          String espaciosJugada = "   ";
            if(loteria["id"] != jugada["idLoteria"])
              continue;

          total += Utils.toDouble(jugada["monto"].toString());
          totalPorLoteria += Utils.toDouble(jugada["monto"].toString());

          // map[map.length] = _getMapNuevo(cmd: CMD.left);
          if(primerCicloJugadas){
            // map[map.length] = _getMapNuevo(text:"TP JUGADA MONTO\n", cmd: CMD.h1);
            // headerJugadas = "TP JUGADA MONTO";
            primerCicloJugadas = false;
          }
          // if(((contadorCicleJugadas + 1) % 2) == 0){ //PAR
          //   String jugadaAnterior = Utils.agregarSignoYletrasParaImprimir(jugadas[contador - 1]["jugada"].toString(), jugadas[contador - 1]["sorteo"]);
          //   String montoAnterior = jugadas[contador - 1]["monto"].toString();
          //   espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaAnterior) + montoAnterior;
            
          //   espaciosSegundaJugada = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundaJugada, montoAnterior);
          //   espaciosSegundoMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundoMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
          //   // map[map.length] = _getMapNuevo(text:"                ${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
          //   // map[map.length] = _getMapNuevo(text:"                         ${jugada["monto"]}\n");
          //   map[map.length] = _getMapNuevo(text:"$espaciosSegundaJugada${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
          //   map[map.length] = _getMapNuevo(text:"$espaciosSegundoMonto${jugada["monto"]}\n");
          // }else{
            // espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
            String sorteo = Utils.sorteoToDosLetras(jugada["sorteo"]);
            String jugadaString = quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosJugada, sorteo) + Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"], true);
            String monto = "${Utils.toPrintCurrency(jugada["monto"])}";
            // contentJugadas += "$sorteo$jugadaString";
            // print("ContentJugadasSay: ${contentJugadas.length}");
            // contentJugadas += quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])) + monto + siEsUltimaJugadaDarSaltoDeLinea(contadorCicleJugadas, jugadas.length) + quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado("     ", monto);
            map[map.length] = _getMapNuevo(text: sorteo, cmd: CMD.h1);
            // map[map.length] = _getMapNuevo(text: quitarOPonerEspaciosJugada(espaciosDePrimerMontoA2daJugada: espaciosJugada, montoAnterior: sorteo) + jugadaString, cmd: CMD.h1);
            map[map.length] = _getMapNuevo(text: jugadaString, cmd: CMD.h1);
            // map[map.length] = _getMapNuevo(text: _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosJugada, sorteo) + jugadaString, cmd: CMD.h1);
            // map[map.length] = _getMapNuevo(text: _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaString + sorteo) + monto, cmd: CMD.h1);
            // map[map.length] = _getMapNuevo(text: quitarOPonerEspaciosMonto(espaciosDeJugadaAMonto: espaciosPrimerMonto, jugadaAnterior: jugadaString) + monto + siEsUltimaJugadaDarSaltoDeLinea(contadorCicleJugadas, jugadas.length), cmd: CMD.h1);
            map[map.length] = _getMapNuevo(text: quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"], true)) + monto + quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado("     ", monto) + "\n", cmd: CMD.h1);
          // }
          // 
          // print("Espacios quitado al espacioMonto: ${quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaString).length}");

          contadorCicleJugadas++;
        }

        // map[map.length] = _getMapNuevo(cmd: CMD.center);
        // int loteriasLength = (typeTicket == TYPE_PAGADO) ? mapVenta["loterias"].length - 1 : mapVenta["loterias"].length;
        // if(loteriasLength > 1)
        //   map[map.length] = _getMapNuevo(text:"\n total: $totalPorLoteria \n");
        
        }

        print("HeaderJugadas : ${headerJugadas}");
        print("ContentJugadas: ${contentJugadas}");

        // return {};

        print("loteriaSuperpale: $loteria");
        // continue;
        
        if(loteria["loteriaSuperpale"] == null)
          continue;
          
        for(Map<String, dynamic> ls in loteria["loteriaSuperpale"]){
          jugadas = _getJugadasSuperpalePertenecienteALoteria(jugadas: mapVenta["jugadas"], idLoteria: loteria["id"], idLoteriaSuperpale: ls["id"], type: typeTicket);
          if(jugadas.isNotEmpty){
            primerCicloJugadas = true;
            contadorCicleJugadas = 0;
            totalPorLoteria = 0;
            
            map[map.length] = _getMapNuevo(cmd: CMD.center);
            map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
            map[map.length] = _getMapNuevo(text:"Super pale (${loteria["descripcion"]}/${ls["descripcion"]})\n", cmd: CMD.h1);
            // map[map.length] = _getMapNuevo(text:"Super pale", );
            // map[map.length] = _getMapNuevo(text:"(${loteria["descripcion"]}/${ls["descripcion"]})", cmd: CMD.p);
            // map[map.length] = _getMapNuevo(text:")", cmd: CMD.h1);
            map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
            
            for(int contador=0; contador < jugadas.length; contador++){
              Map<String, dynamic> jugada = jugadas[contador];
              String espaciosSegundaJugada = "       ";
              String espaciosSegundoMonto = "         ";

              String espaciosPrimerMonto = "       ";
              String espaciosJugada = "   ";
                if(loteria["id"] != jugada["idLoteria"])
                  continue;

              total += Utils.toDouble(jugada["monto"].toString());
              totalPorLoteria += Utils.toDouble(jugada["monto"].toString());

              map[map.length] = _getMapNuevo(cmd: CMD.left);
              if(primerCicloJugadas){
                // map[map.length] = _getMapNuevo(text:"JUGADA   MONTO  JUGADA   MONTO\n");
                primerCicloJugadas = false;
              }
              // if(((contadorCicleJugadas + 1) % 2) == 0){ //PAR
              //   String jugadaAnterior = Utils.agregarSignoYletrasParaImprimir(jugadas[contador - 1]["jugada"].toString(), jugadas[contador - 1]["sorteo"]);
              //   String montoAnterior = jugadas[contador - 1]["monto"].toString();
              //   espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaAnterior) + montoAnterior;
                
              //   espaciosSegundaJugada = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundaJugada, montoAnterior);
              //   espaciosSegundoMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundoMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
              //   // map[map.length] = _getMapNuevo(text:"                ${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
              //   // map[map.length] = _getMapNuevo(text:"                         ${jugada["monto"]}\n");
              //   map[map.length] = _getMapNuevo(text:"$espaciosSegundaJugada${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
              //   map[map.length] = _getMapNuevo(text:"$espaciosSegundoMonto${jugada["monto"]}\n");
              // }else{
                // espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
                // map[map.length] = _getMapNuevo(text:Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"]));
                // map[map.length] = _getMapNuevo(text:"$espaciosPrimerMonto${jugada["monto"]}" + siEsUltimaJugadaDarSaltoDeLinea(contadorCicleJugadas, jugadas.length));
              
                  String sorteo = Utils.sorteoToDosLetras(jugada["sorteo"]);
                  String jugadaString = quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosJugada, sorteo) + Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"], true);
                  String monto = "${Utils.toPrintCurrency(jugada["monto"])}";
                  map[map.length] = _getMapNuevo(text: sorteo, cmd: CMD.h1);
                  map[map.length] = _getMapNuevo(text: jugadaString, cmd: CMD.h1);
                  map[map.length] = _getMapNuevo(text: quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"], true)) + monto + quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado("     ", monto) + "\n", cmd: CMD.h1);
              // }

              contadorCicleJugadas++;
            }

            // map[map.length] = _getMapNuevo(cmd: CMD.center);
            // int loteriasLength = (typeTicket == TYPE_PAGADO) ? mapVenta["loterias"].length - 1 : mapVenta["loterias"].length;
            // if(loteriasLength > 1)
            //   map[map.length] = _getMapNuevo(text:"\n total: $totalPorLoteria \n");

            }
        }
      
      
      }
        

      map[map.length] = _getMapNuevo(cmd: CMD.center);
      if(mapVenta["hayDescuento"] == 1){
        map[map.length] = _getMapNuevo(text:"subTotal: ${mapVenta["total"]}\n");
        map[map.length] = _getMapNuevo(text:"descuento: ${mapVenta["descuentoMonto"]}\n");
        total -= Utils.toDouble(mapVenta["descuentoMonto"].toString());
      }

      
      
      map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
      map[map.length] = _getMapNuevo(text:"TOTAL: ${Utils.toPrintCurrency(total, true, false)}\n", cmd: CMD.h1);
      map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
    
      if(typeTicket == TYPE_CANCELADO)
        map[map.length] = _getMapNuevo(text:"** CANCELADO **\n\n\n", cmd: CMD.h1);
      else if(typeTicket == TYPE_PAGADA_ONLY_MARK)
        map[map.length] = _getMapNuevo(text:"** PAGADO **\n\n\n", cmd: CMD.h1);

      if((typeTicket != TYPE_ORIGINAL && typeTicket != TYPE_PAGADO) || mapVenta["banca"]["imprimirCodigoQr"] == 0)
        map[map.length] = _getMapNuevo(text:"\n\n", cmd: CMD.h1);
      
      if(typeTicket == TYPE_ORIGINAL || typeTicket == TYPE_PAGADO){
        Map<String, dynamic> banca = mapVenta["banca"];
        print("bluetoothchannel generateticket banca: ${banca.toString()}");
        if(banca["piepagina1"] != null){
          print("Dentro pie de pagina 1 desde bluetoothchannel: ${banca["piepagina1"]}");
          map[map.length] = _getMapNuevo(text:"${banca["piepagina1"]}\n", cmd: CMD.p);
        }
        if(banca["piepagina2"] != null)
          map[map.length] = _getMapNuevo(text:"${banca["piepagina2"]}\n", cmd: CMD.p);
        if(banca["piepagina3"] != null)
          map[map.length] = _getMapNuevo(text:"${banca["piepagina3"]}\n", cmd: CMD.p);
        if(banca["piepagina4"] != null)
          map[map.length] = _getMapNuevo(text:"${banca["piepagina4"]}\n", cmd: CMD.p);
        if(banca["imprimirCodigoQr"] == 1){
          map[map.length] = _getMapNuevo(text:"${mapVenta["codigoBarra"]}\n", cmd: CMD.h1);
          map[map.length] = _getMapNuevo(text:mapVenta["codigoQr"], cmd: CMD.qr);
        }else
          map[map.length] = _getMapNuevo(text:"${mapVenta["codigoBarra"]}\n", cmd: CMD.h1);
        
        map[map.length] = _getMapNuevo(text:"\n\n\n");
      }else{
        map[map.length] = _getMapNuevo(text:"\n\n\n");
      }

    return map;
    // print("printicket: ${map.length}");
    // for(Map<String, dynamic> map in mapVenta["jugadas"]){
    //   print("Jugada: ${map["jugada"]}");
    // }
  }

  static Map<int, dynamic> generateMapTicketV2(Sale sale, List<Salesdetails> listSalesdetails, String typeTicket){
    List listMapToPrint = [];
    
    

    Map<int, dynamic> map = Map<int, dynamic>();
    map[map.length] = _getMapNuevo(cmd: CMD.center);
    if(_ajustes.imprimirNombreConsorcio == 1)
      map[map.length] = _getMapNuevo(text:"${_ajustes.consorcio}\n\n", cmd: CMD.h1);
    if(_ajustes.imprimirNombreBanca == 1)
      map[map.length] = _getMapNuevo(text:"${sale.banca.descripcion}\n", cmd: CMD.h1);
      

    map[map.length] = _printTicketHeader(typeTicket);
    // var fecha = DateTime.parse(mapVenta["created_at"]);
    //${DateFormat('EEEE').format(fecha)} 
    // map[map.length] = _getMapNuevo(text:"${mapVenta["created_at"]}\n", cmd: CMD.p);
    map[map.length] = _getMapNuevo(text:"Ticket:" + Utils.toSecuencia(sale.banca.codigo, sale.idTicket) + "\n", cmd: CMD.p);
    // map[map.length] = _getMapNuevo(text:"Fecha: ${sale.created_at.toString()}\n", cmd: CMD.p);
    // map[map.length] = _getMapNuevo(text:"Fecha: ${DateFormat('EEE, MMM d yyy hh:mm a', 'es').format(sale.created_at)}\n", cmd: CMD.p);
    map[map.length] = _getMapNuevo(text:"FECHA: ${DateFormat('EEE', 'Es').format(sale.created_at).toUpperCase()} ${DateFormat('d/MM/yyyy').add_jm().format(sale.created_at)}\n", cmd: CMD.p);
    if(typeTicket == TYPE_ORIGINAL || typeTicket == TYPE_PAGADO)
      map[map.length] = _getMapNuevo(text:"${sale.ticket.codigoBarra}\n", cmd: CMD.h1);
    
    double total = 0;
    List<Salesdetails> listaLoteriasJugadas = Utils.removeDuplicateLoteriasFromList(List.from(listSalesdetails)).cast<Salesdetails>().toList();
    for(var salesdetailsLoteria in listaLoteriasJugadas){
      Loteria loteria = salesdetailsLoteria.loteria;
      List<Salesdetails> jugadas = listSalesdetails.where((element) => element.loteria.id == loteria.id && (element.idLoteriaSuperpale == 0 || element.idLoteriaSuperpale == null)).toList();
      bool primerCicloJugadas = true;
      int contadorCicleJugadas = 0;
      double totalPorLoteria = 0;
      
      
      if(jugadas.isNotEmpty){
        // totalPorLoteria += Utils.toDouble(jugada["monto"].toString());
        map[map.length] = _getMapNuevo(cmd: CMD.center);
        map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
        map[map.length] = _getMapNuevo(text:"${loteria.descripcion}: ${Utils.toPrintCurrency(jugadas.map((e) => e.monto).toList().reduce((value, element) => value + element), true, false)}\n");
        map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
        
        for(int contador=0; contador < jugadas.length; contador++){
          Salesdetails jugada = jugadas[contador];
          String espaciosPrimerMonto = "         ";
          String espaciosSegundaJugada = "       ";
          String espaciosSegundoMonto = "         ";
            if(loteria.id != jugada.idLoteria)
              continue;

          total += Utils.toDouble(jugada.monto.toString());
          totalPorLoteria += Utils.toDouble(jugada.monto.toString());

          map[map.length] = _getMapNuevo(cmd: CMD.left);
          if(primerCicloJugadas){
            map[map.length] = _getMapNuevo(text:"JUGADA   MONTO  JUGADA   MONTO\n");
            primerCicloJugadas = false;
          }
          if(((contadorCicleJugadas + 1) % 2) == 0){ //PAR
            String jugadaAnterior = Utils.agregarSignoYletrasParaImprimir(jugadas[contador - 1].jugada.toString(), jugadas[contador - 1].sorteoDescripcion);
            String montoAnterior = Utils.toPrintCurrency(jugadas[contador - 1].monto.toString());
            espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaAnterior) + montoAnterior;
            
            espaciosSegundaJugada = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundaJugada, montoAnterior);
            espaciosSegundoMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundoMonto, Utils.agregarSignoYletrasParaImprimir(jugada.jugada.toString(), jugada.sorteoDescripcion));
            // map[map.length] = _getMapNuevo(text:"                ${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
            // map[map.length] = _getMapNuevo(text:"                         ${jugada["monto"]}\n");
            map[map.length] = _getMapNuevo(text:"$espaciosSegundaJugada${Utils.agregarSignoYletrasParaImprimir(jugada.jugada, jugada.sorteoDescripcion)}");
            map[map.length] = _getMapNuevo(text:"$espaciosSegundoMonto${Utils.toPrintCurrency(jugada.monto)}\n");
          }else{
            espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada.jugada.toString(), jugada.sorteoDescripcion));
            map[map.length] = _getMapNuevo(text:Utils.agregarSignoYletrasParaImprimir(jugada.jugada, jugada.sorteoDescripcion));
            map[map.length] = _getMapNuevo(text:"$espaciosPrimerMonto${Utils.toPrintCurrency(jugada.monto)}" + siEsUltimaJugadaDarSaltoDeLinea(contadorCicleJugadas, jugadas.length));
          }

          contadorCicleJugadas++;
        }

        // map[map.length] = _getMapNuevo(cmd: CMD.center);
        // int loteriasLength = (typeTicket == TYPE_PAGADO) ? mapVenta["loterias"].length - 1 : mapVenta["loterias"].length;
        // if(loteriasLength > 1)
        //   map[map.length] = _getMapNuevo(text:"\n total: $totalPorLoteria \n");
        
        }

        // continue;

        // Buscamos todas las jugadas de tipo SuperPale que tenga esta loteria usada arriba y nos aseguramos de que los idLoteriaSuperPale sean de diferentes loterias
        // y no sea nulos
        // List<Salesdetails> listaLoteriasSuperPaleJugadas = Utils.removeDuplicateLoteriasSuperPaleFromList(List.from(jugadas)).cast<Salesdetails>().toList();
        // List<Salesdetails> jugadasSuper = listSalesdetails.where((element) => element.loteria.id == loteria.id && (element.idSorteo == 4)).toList();
        List<Salesdetails> jugadasSuper = Utils.removeDuplicateLoteriasSuperPaleFromList(listSalesdetails, loteria.id).cast<Salesdetails>().toList();
        for(Salesdetails salesdetailLoteriaSuperPale in jugadasSuper){
          Loteria loteria = salesdetailLoteriaSuperPale.loteria;
          Loteria ls = salesdetailLoteriaSuperPale.loteriaSuperPale;
          jugadas = listSalesdetails.where((element) => element.idLoteria == salesdetailLoteriaSuperPale.loteria.id && element.idLoteriaSuperpale == salesdetailLoteriaSuperPale.idLoteriaSuperpale).toList();
          if(jugadas.isNotEmpty){
            primerCicloJugadas = true;
            contadorCicleJugadas = 0;
            totalPorLoteria = 0;
            
            map[map.length] = _getMapNuevo(cmd: CMD.center);
            map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
            // map[map.length] = _getMapNuevo(text:"Super pale (${loteria.descripcion}/${ls.descripcion}): ${Utils.toPrintCurrency(_getTotalPertenecienteALoteria(jugadas), true, false)}\n", cmd: CMD.p);
            map[map.length] = _getMapNuevo(text:"Super pale (${loteria.descripcion}/${ls.descripcion}): ${Utils.toPrintCurrency(jugadas.map((e) => e.monto).toList().reduce((value, element) => value + element), true, false)}\n", cmd: CMD.p);
            // map[map.length] = _getMapNuevo(text:"Super pale", );
            // map[map.length] = _getMapNuevo(text:"(${loteria["descripcion"]}/${ls["descripcion"]})", cmd: CMD.p);
            // map[map.length] = _getMapNuevo(text:")", cmd: CMD.h1);
            map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
            
            for(int contador=0; contador < jugadas.length; contador++){
              Salesdetails jugada = jugadas[contador];
              String espaciosPrimerMonto = "         ";
              String espaciosSegundaJugada = "       ";
              String espaciosSegundoMonto = "         ";
                if(loteria.id != jugada.idLoteria)
                  continue;

              total += Utils.toDouble(jugada.monto.toString());
              totalPorLoteria += Utils.toDouble(jugada.monto.toString());

              map[map.length] = _getMapNuevo(cmd: CMD.left);
              if(primerCicloJugadas){
                map[map.length] = _getMapNuevo(text:"JUGADA   MONTO  JUGADA   MONTO\n");
                primerCicloJugadas = false;
              }
              if(((contadorCicleJugadas + 1) % 2) == 0){ //PAR
                String jugadaAnterior = Utils.agregarSignoYletrasParaImprimir(jugadas[contador - 1].jugada.toString(), jugadas[contador - 1].sorteoDescripcion);
                String montoAnterior = Utils.toPrintCurrency(jugadas[contador - 1].monto.toString());
                espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaAnterior) + montoAnterior;
                
                espaciosSegundaJugada = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundaJugada, montoAnterior);
                espaciosSegundoMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundoMonto, Utils.agregarSignoYletrasParaImprimir(jugada.jugada.toString(), jugada.sorteoDescripcion));
                // map[map.length] = _getMapNuevo(text:"                ${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
                // map[map.length] = _getMapNuevo(text:"                         ${jugada["monto"]}\n");
                map[map.length] = _getMapNuevo(text:"$espaciosSegundaJugada${Utils.agregarSignoYletrasParaImprimir(jugada.jugada, jugada.sorteoDescripcion)}");
                map[map.length] = _getMapNuevo(text:"$espaciosSegundoMonto${Utils.toPrintCurrency(jugada.monto)}\n");
              }else{
                espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada.jugada.toString(), jugada.sorteoDescripcion));
                map[map.length] = _getMapNuevo(text:Utils.agregarSignoYletrasParaImprimir(jugada.jugada, jugada.sorteoDescripcion));
                map[map.length] = _getMapNuevo(text:"$espaciosPrimerMonto${Utils.toPrintCurrency(jugada.monto)}" + siEsUltimaJugadaDarSaltoDeLinea(contadorCicleJugadas, jugadas.length));
              }

              contadorCicleJugadas++;
            }

            // map[map.length] = _getMapNuevo(cmd: CMD.center);
            // int loteriasLength = (typeTicket == TYPE_PAGADO) ? mapVenta["loterias"].length - 1 : mapVenta["loterias"].length;
            // if(loteriasLength > 1)
            //   map[map.length] = _getMapNuevo(text:"\n total: $totalPorLoteria \n");

            }
        }
      
      
      }
        

      map[map.length] = _getMapNuevo(cmd: CMD.center);
      if(sale.hayDescuento == 1){
        map[map.length] = _getMapNuevo(text:"subTotal: ${sale.total}\n");
        map[map.length] = _getMapNuevo(text:"descuento: ${sale.descuentoMonto}\n");
        total -= Utils.toDouble(sale.descuentoMonto.toString());
      }

      String saltoLineaTotal = "\n";
      if((typeTicket != TYPE_ORIGINAL && typeTicket != TYPE_PAGADO) || sale.banca.imprimirCodigoQr == 0)
        saltoLineaTotal += "\n\n";
      
      map[map.length] = _getMapNuevo(text:"TOTAL: ${Utils.toPrintCurrency(total, true, false)}$saltoLineaTotal", cmd: CMD.h1);
    
      if(typeTicket == TYPE_CANCELADO)
        map[map.length] = _getMapNuevo(text:"** CANCELADO **\n\n\n", cmd: CMD.h1);
      else if(typeTicket == TYPE_PAGADA_ONLY_MARK)
        map[map.length] = _getMapNuevo(text:"** PAGADO **\n\n\n", cmd: CMD.h1);
      
      if(typeTicket == TYPE_ORIGINAL){
        Banca banca = sale.banca;
        print("bluetoothchannel generateticket banca: ${banca.toString()}");
        if(banca.piepagina1 != null){
          print("Dentro pie de pagina 1 desde bluetoothchannel: ${banca.piepagina1}");
          if(banca.piepagina1.isNotEmpty)
            map[map.length] = _getMapNuevo(text:"${banca.piepagina1}\n", cmd: CMD.p);
        }
        if(banca.piepagina2 != null){
          if(banca.piepagina2.isNotEmpty)
            map[map.length] = _getMapNuevo(text:"${banca.piepagina2}\n", cmd: CMD.p);
        }
        if(banca.piepagina3 != null){
          if(banca.piepagina3.isNotEmpty)
          map[map.length] = _getMapNuevo(text:"${banca.piepagina3}\n", cmd: CMD.p);
        }
        if(banca.piepagina4 != null){
          if(banca.piepagina4.isNotEmpty)
            map[map.length] = _getMapNuevo(text:"${banca.piepagina4}\n", cmd: CMD.p);
        }
        if(banca.imprimirCodigoQr == 1  && !kIsWeb)
          map[map.length] = _getMapNuevo(text: Utils.toBase64(sale.ticket.codigoBarra), cmd: CMD.qr);
        
        map[map.length] = _getMapNuevo(text:"\n\n\n");
      }else{
        map[map.length] = _getMapNuevo(text:"\n\n\n");
      }

    if(kIsWeb)
      map[map.length] = _getMapNuevo(text:"\n\n", cmd: CMD.h1);

    return map;
    // print("printicket: ${map.length}");
    // for(Map<String, dynamic> map in mapVenta["jugadas"]){
    //   print("Jugada: ${map["jugada"]}");
    // }
  }

static Map<int, dynamic> generateMapTicketOtroFormatoV2(Sale sale, List<Salesdetails> listSalesdetails, String typeTicket){
    
    
    // Venta venta = Venta.fromMap(mapVenta);
    Map<int, dynamic> map = Map<int, dynamic>();
    map[map.length] = _getMapNuevo(cmd: CMD.textBoldOn);
    map[map.length] = _getMapNuevo(cmd: CMD.center);
    String headerJugadas = "";
    String contentJugadas = "";
    if(_ajustes.imprimirNombreConsorcio == 1)
      map[map.length] = _getMapNuevo(text:"${(_ajustes.consorcio != null) ? _ajustes.consorcio.toUpperCase() : ''}\n\n", cmd: CMD.h1);
    if(_ajustes.imprimirNombreBanca == 1)
      map[map.length] = _getMapNuevo(text:"${sale.banca.descripcion}\n", cmd: CMD.h1);
    // map[map.length] = _getMapNuevo(text:"${mapVenta["banca"]["descripcion"]}\n", cmd: CMD.h1);
    // map[map.length] = _printTicketHeader(typeTicket);

    // var fecha = DateTime.parse(mapVenta["created_at"]);
    //${DateFormat('EEEE').format(fecha)} 
    // map[map.length] = _getMapNuevo(text:"${mapVenta["created_at"]}\n", cmd: CMD.p);
    map[map.length] = _getMapNuevo(text:"TICKET:" + Utils.toSecuencia(sale.banca.codigo, sale.idTicket) + "\n", cmd: CMD.p);
    // map[map.length] = _getMapNuevo(text:"FECHA: ${DateFormat('EEE, MMM d yyy hh:mm a', 'es').format(sale.created_at)}\n", cmd: CMD.p);
    map[map.length] = _getMapNuevo(text:"FECHA: ${DateFormat('EEE', 'Es').format(sale.created_at).toUpperCase()} ${DateFormat('d/MM/yyyy').add_jm().format(sale.created_at)}\n", cmd: CMD.p);
    // if(typeTicket == TYPE_ORIGINAL || typeTicket == TYPE_PAGADO)
    //   map[map.length] = _getMapNuevo(text:"${mapVenta["codigoBarra"]}\n", cmd: CMD.h1);
    
    double total = 0;
     map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
     map[map.length] = _getMapNuevo(text:"TP JUGADA MONTO\n", cmd: CMD.h1);
    List<Salesdetails> listaLoteriasJugadas = Utils.removeDuplicateLoteriasFromList(List.from(listSalesdetails)).cast<Salesdetails>().toList();
    for(var salesdetailsLoteria in listaLoteriasJugadas){
      Loteria loteria = salesdetailsLoteria.loteria;
      List<Salesdetails> jugadas = listSalesdetails.where((element) => element.loteria.id == loteria.id && (element.idLoteriaSuperpale == 0 || element.idLoteriaSuperpale == null)).toList();
      bool primerCicloJugadas = true;
      int contadorCicleJugadas = 0;
      double totalPorLoteria = 0;
      
      
      if(jugadas.isNotEmpty){
        // totalPorLoteria += Utils.toDouble(jugada["monto"].toString());
        map[map.length] = _getMapNuevo(cmd: CMD.center);
        map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
        // map[map.length] = _getMapNuevo(text:"${loteria["descripcion"]}: ${_getTotalPertenecienteALoteria(jugadas)}\n", cmd: CMD.h1);
        map[map.length] = _getMapNuevo(text:"${loteria.descripcion}\n", cmd: CMD.h1);
        map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);

        for(int contador=0; contador < jugadas.length; contador++){
          Salesdetails jugada = jugadas[contador];
          String espaciosPrimerMonto = "       ";
          String espaciosJugada = "   ";
            if(loteria.id != jugada.idLoteria)
              continue;

          total += Utils.toDouble(jugada.monto.toString());
          totalPorLoteria += Utils.toDouble(jugada.monto.toString());

          // map[map.length] = _getMapNuevo(cmd: CMD.left);
          if(primerCicloJugadas){
            // map[map.length] = _getMapNuevo(text:"TP JUGADA MONTO\n", cmd: CMD.h1);
            // headerJugadas = "TP JUGADA MONTO";
            primerCicloJugadas = false;
          }
          // if(((contadorCicleJugadas + 1) % 2) == 0){ //PAR
          //   String jugadaAnterior = Utils.agregarSignoYletrasParaImprimir(jugadas[contador - 1]["jugada"].toString(), jugadas[contador - 1]["sorteo"]);
          //   String montoAnterior = jugadas[contador - 1]["monto"].toString();
          //   espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaAnterior) + montoAnterior;
            
          //   espaciosSegundaJugada = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundaJugada, montoAnterior);
          //   espaciosSegundoMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundoMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
          //   // map[map.length] = _getMapNuevo(text:"                ${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
          //   // map[map.length] = _getMapNuevo(text:"                         ${jugada["monto"]}\n");
          //   map[map.length] = _getMapNuevo(text:"$espaciosSegundaJugada${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
          //   map[map.length] = _getMapNuevo(text:"$espaciosSegundoMonto${jugada["monto"]}\n");
          // }else{
            // espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
            String sorteo = Utils.sorteoToDosLetras(jugada.sorteoDescripcion);
            String jugadaString = quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosJugada, sorteo) + Utils.agregarSignoYletrasParaImprimir(jugada.jugada, jugada.sorteoDescripcion, true);
            String monto = "${Utils.toPrintCurrency(jugada.monto)}";
            // contentJugadas += "$sorteo$jugadaString";
            // print("ContentJugadasSay: ${contentJugadas.length}");
            // contentJugadas += quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])) + monto + siEsUltimaJugadaDarSaltoDeLinea(contadorCicleJugadas, jugadas.length) + quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado("     ", monto);
            map[map.length] = _getMapNuevo(text: sorteo, cmd: CMD.h1);
            // map[map.length] = _getMapNuevo(text: quitarOPonerEspaciosJugada(espaciosDePrimerMontoA2daJugada: espaciosJugada, montoAnterior: sorteo) + jugadaString, cmd: CMD.h1);
            map[map.length] = _getMapNuevo(text: jugadaString, cmd: CMD.h1);
            // map[map.length] = _getMapNuevo(text: _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosJugada, sorteo) + jugadaString, cmd: CMD.h1);
            // map[map.length] = _getMapNuevo(text: _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaString + sorteo) + monto, cmd: CMD.h1);
            // map[map.length] = _getMapNuevo(text: quitarOPonerEspaciosMonto(espaciosDeJugadaAMonto: espaciosPrimerMonto, jugadaAnterior: jugadaString) + monto + siEsUltimaJugadaDarSaltoDeLinea(contadorCicleJugadas, jugadas.length), cmd: CMD.h1);
            map[map.length] = _getMapNuevo(text: quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada.jugada, jugada.sorteoDescripcion, true)) + monto + quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado("     ", monto) + "\n", cmd: CMD.h1);
          // }
          // 
          // print("Espacios quitado al espacioMonto: ${quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaString).length}");

          contadorCicleJugadas++;
        }

        // map[map.length] = _getMapNuevo(cmd: CMD.center);
        // int loteriasLength = (typeTicket == TYPE_PAGADO) ? mapVenta["loterias"].length - 1 : mapVenta["loterias"].length;
        // if(loteriasLength > 1)
        //   map[map.length] = _getMapNuevo(text:"\n total: $totalPorLoteria \n");
        
        }

        // continue;
        
        // List<Salesdetails> listaLoteriasSuperPaleJugadas = Utils.removeDuplicateLoteriasSuperPaleFromList(List.from(jugadas)).cast<Salesdetails>().toList();
        // List<Salesdetails> jugadasSuper = listSalesdetails.where((element) => element.loteria.id == loteria.id && (element.idSorteo == 4)).toList();
        List<Salesdetails> jugadasSuper = Utils.removeDuplicateLoteriasSuperPaleFromList(listSalesdetails, loteria.id).cast<Salesdetails>().toList();
        
        for(Salesdetails salesdetailLoteriaSuperPale in jugadasSuper){
          Loteria loteria = salesdetailLoteriaSuperPale.loteria;
          Loteria ls = salesdetailLoteriaSuperPale.loteriaSuperPale;
          jugadas = listSalesdetails.where((element) => element.idLoteria == salesdetailLoteriaSuperPale.loteria.id && element.idLoteriaSuperpale == salesdetailLoteriaSuperPale.idLoteriaSuperpale).toList();

          if(jugadas.isNotEmpty){
            primerCicloJugadas = true;
            contadorCicleJugadas = 0;
            totalPorLoteria = 0;
            
            map[map.length] = _getMapNuevo(cmd: CMD.center);
            map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
            map[map.length] = _getMapNuevo(text:"Super pale (${loteria.descripcion}/${ls.descripcion})\n", cmd: CMD.h1);
            // map[map.length] = _getMapNuevo(text:"Super pale", );
            // map[map.length] = _getMapNuevo(text:"(${loteria["descripcion"]}/${ls["descripcion"]})", cmd: CMD.p);
            // map[map.length] = _getMapNuevo(text:")", cmd: CMD.h1);
            map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
            
            for(int contador=0; contador < jugadas.length; contador++){
              Salesdetails jugada = jugadas[contador];
              String espaciosSegundaJugada = "       ";
              String espaciosSegundoMonto = "         ";

              String espaciosPrimerMonto = "       ";
              String espaciosJugada = "   ";
                if(loteria.id != jugada.idLoteria)
                  continue;

              total += Utils.toDouble(jugada.monto.toString());
              totalPorLoteria += Utils.toDouble(jugada.monto.toString());

              map[map.length] = _getMapNuevo(cmd: CMD.left);
              if(primerCicloJugadas){
                // map[map.length] = _getMapNuevo(text:"JUGADA   MONTO  JUGADA   MONTO\n");
                primerCicloJugadas = false;
              }
              // if(((contadorCicleJugadas + 1) % 2) == 0){ //PAR
              //   String jugadaAnterior = Utils.agregarSignoYletrasParaImprimir(jugadas[contador - 1]["jugada"].toString(), jugadas[contador - 1]["sorteo"]);
              //   String montoAnterior = jugadas[contador - 1]["monto"].toString();
              //   espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaAnterior) + montoAnterior;
                
              //   espaciosSegundaJugada = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundaJugada, montoAnterior);
              //   espaciosSegundoMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundoMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
              //   // map[map.length] = _getMapNuevo(text:"                ${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
              //   // map[map.length] = _getMapNuevo(text:"                         ${jugada["monto"]}\n");
              //   map[map.length] = _getMapNuevo(text:"$espaciosSegundaJugada${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
              //   map[map.length] = _getMapNuevo(text:"$espaciosSegundoMonto${jugada["monto"]}\n");
              // }else{
                // espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
                // map[map.length] = _getMapNuevo(text:Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"]));
                // map[map.length] = _getMapNuevo(text:"$espaciosPrimerMonto${jugada["monto"]}" + siEsUltimaJugadaDarSaltoDeLinea(contadorCicleJugadas, jugadas.length));
              
                  String sorteo = Utils.sorteoToDosLetras(jugada.sorteoDescripcion);
                  String jugadaString = quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosJugada, sorteo) + Utils.agregarSignoYletrasParaImprimir(jugada.jugada, jugada.sorteoDescripcion, true);
                  String monto = "${Utils.toPrintCurrency(jugada.monto)}";
                  map[map.length] = _getMapNuevo(text: sorteo, cmd: CMD.h1);
                  map[map.length] = _getMapNuevo(text: jugadaString, cmd: CMD.h1);
                  map[map.length] = _getMapNuevo(text: quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada.jugada, jugada.sorteoDescripcion, true)) + monto + quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado("     ", monto) + "\n", cmd: CMD.h1);
              // }

              contadorCicleJugadas++;
            }

            // map[map.length] = _getMapNuevo(cmd: CMD.center);
            // int loteriasLength = (typeTicket == TYPE_PAGADO) ? mapVenta["loterias"].length - 1 : mapVenta["loterias"].length;
            // if(loteriasLength > 1)
            //   map[map.length] = _getMapNuevo(text:"\n total: $totalPorLoteria \n");

            }
        }
      
      
      }
        

      map[map.length] = _getMapNuevo(cmd: CMD.center);
      if(sale.hayDescuento == 1){
        map[map.length] = _getMapNuevo(text:"subTotal: ${sale.total}\n");
        map[map.length] = _getMapNuevo(text:"descuento: ${sale.descuentoMonto}\n");
        total -= Utils.toDouble(sale.descuentoMonto.toString());
      }

      
      
      map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
      map[map.length] = _getMapNuevo(text:"TOTAL: ${Utils.toPrintCurrency(total, true, false)}\n", cmd: CMD.h1);
      map[map.length] = _getMapNuevo(text:"---------------\n", cmd: CMD.h1);
    
      if(typeTicket == TYPE_CANCELADO)
        map[map.length] = _getMapNuevo(text:"** CANCELADO **\n\n\n", cmd: CMD.h1);
      if(typeTicket == TYPE_PAGADA_ONLY_MARK)
        map[map.length] = _getMapNuevo(text:"** PAGADO **\n\n\n", cmd: CMD.h1);

      if((typeTicket != TYPE_ORIGINAL && typeTicket != TYPE_PAGADO) || sale.banca.imprimirCodigoQr == 0)
        map[map.length] = _getMapNuevo(text:"\n\n", cmd: CMD.h1);
      
      if(typeTicket == TYPE_ORIGINAL || typeTicket == TYPE_PAGADO){
        Banca banca = sale.banca;
        if(banca.piepagina1 != null){
          print("Dentro pie de pagina 1 desde bluetoothchannel: ${banca.piepagina1}");
          if(banca.piepagina1.isNotEmpty)
            map[map.length] = _getMapNuevo(text:"${banca.piepagina1}\n", cmd: CMD.p);
        }
        if(banca.piepagina2 != null){
          if(banca.piepagina2.isNotEmpty)
            map[map.length] = _getMapNuevo(text:"${banca.piepagina2}\n", cmd: CMD.p);
        }
        if(banca.piepagina3 != null){
          if(banca.piepagina3.isNotEmpty)
            map[map.length] = _getMapNuevo(text:"${banca.piepagina3}\n", cmd: CMD.p);
        }
        if(banca.piepagina4 != null){
          if(banca.piepagina4.isNotEmpty)
            map[map.length] = _getMapNuevo(text:"${banca.piepagina4}\n", cmd: CMD.p);
        }if(banca.imprimirCodigoQr == 1 && !kIsWeb){
          map[map.length] = _getMapNuevo(text:"${sale.ticket.codigoBarra}\n", cmd: CMD.h1);
          map[map.length] = _getMapNuevo(text: Utils.toBase64(sale.ticket.codigoBarra), cmd: CMD.qr);
        }else
          map[map.length] = _getMapNuevo(text:"${sale.ticket.codigoBarra}\n", cmd: CMD.h1);
        
        map[map.length] = _getMapNuevo(text:"\n\n\n");
      }else{
        map[map.length] = _getMapNuevo(text:"\n\n\n");
      }

    if(kIsWeb)
      map[map.length] = _getMapNuevo(text:"\n\n", cmd: CMD.h1);

    return map;
    // print("printicket: ${map.length}");
    // for(Map<String, dynamic> map in mapVenta["jugadas"]){
    //   print("Jugada: ${map["jugada"]}");
    // }
  }


  static _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(String tamano, String jugadaOMonto){
    // print("tamano: $tamano - ${tamano.length} | jugadaOMonto: $jugadaOMonto - ${jugadaOMonto.length}");
    // print("tamanoFinal: ${tamano.substring(0, tamano.length - jugadaOMonto.length)} - ${tamano.substring(0, tamano.length - jugadaOMonto.length).length}");
    var espaciosAQuitarAlTamano = tamano.length - jugadaOMonto.length;
    if(espaciosAQuitarAlTamano < 0)
      return "";
    else
      return tamano.substring(0, espaciosAQuitarAlTamano);
  }
  
  static Map<String, dynamic> _getMapNuevo({String text = '', cmd = CMD.h2}){
    return {"text" : text, "cmd" : cmd};
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
          return  _getMapNuevo(text: "** $TYPE_ORIGINAL **\n", cmd: CMD.h1);
          break;
        case TYPE_PAGADO:
          return  _getMapNuevo(text: "** $TYPE_ORIGINAL **\n", cmd: CMD.h1);
          break;
        case TYPE_COPIA:
          return _getMapNuevo(text: "** $TYPE_COPIA **\n", cmd: CMD.h1);
          break;
        case TYPE_PAGADA_ONLY_MARK:
          return _getMapNuevo(text: "** PAGADO **\n", cmd: CMD.h1);
          break;
        default:
          return _getMapNuevo(text: "** $TYPE_CANCELADO **\n", cmd: CMD.h1);
    }
  }

  static String siEsUltimaJugadaDarSaltoDeLinea(contadorCicloJugadas, cantidadJugadas){
    String saltoLinea = "";
    if((contadorCicloJugadas + 1) == cantidadJugadas)
        saltoLinea = "\n";
    
    return saltoLinea;
  }


  static _getTotalPertenecienteALoteria(List jugadas){
    return jugadas
    .map<double>((e) => Utils.toDouble(e["monto"].toString()))
    .reduce((value, element) => value + element);
  }

  static List _getJugadasPertenecienteALoteria({int idLoteria, List jugadas, String type = TYPE_ORIGINAL}){
    if(type == TYPE_PAGADO)
      return jugadas.where((j) => j["idLoteria"] == idLoteria && j["sorteo"] != "Super pale" && j["status"] == 0).toList();
    else
      return jugadas.where((j) => j["idLoteria"] == idLoteria && j["sorteo"] != "Super pale").toList();
  }

  static List _getJugadasSuperpalePertenecienteALoteria({int idLoteria, int idLoteriaSuperpale, List jugadas, String type = TYPE_ORIGINAL}){
    if(type == TYPE_PAGADO)
      return jugadas.where((j) => j["idLoteria"] == idLoteria && j["idLoteriaSuperpale"] == idLoteriaSuperpale && j["sorteo"] == "Super pale" && j["status"] == 0).toList();
    else
      return jugadas.where((j) => j["idLoteria"] == idLoteria && j["idLoteriaSuperpale"] == idLoteriaSuperpale && j["sorteo"] == "Super pale").toList();
  }
  
}