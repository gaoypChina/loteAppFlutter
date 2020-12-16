import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/cmd.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/loterias.dart';

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

        // generateCuadre(map);
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
    map[map.length] = _getMapNuevo(cmd: CMD.center);
    map[map.length] = _getMapNuevo(text:"${mapCuadre["fecha"]}\n", cmd: CMD.h1);
    map[map.length] = _getMapNuevo(text:"Cuadre\n", cmd: CMD.h1);
    map[map.length] = _getMapNuevo(text:"${mapCuadre["banca"]["descripcion"]}\n", cmd: CMD.h1);
    map[map.length] = _getMapNuevo(cmd: CMD.left);
    map[map.length] = _getMapNuevo(text:"Balance hasta la fecha: ${mapCuadre["balanceHastaLaFecha"]}\n");
    map[map.length] = _getMapNuevo(text:"Tickets pendientes: ${mapCuadre["pendientes"]}\n");
    map[map.length] = _getMapNuevo(text:"Tickets perdedores: ${mapCuadre["perdedores"]}\n");
    map[map.length] = _getMapNuevo(text:"Tickets ganadores:  ${mapCuadre["ganadores"]}\n");
    map[map.length] = _getMapNuevo(text:"Total:              ${mapCuadre["total"]}\n");
    map[map.length] = _getMapNuevo(text:"Ventas:             ${mapCuadre["ventas"]}\n");
    map[map.length] = _getMapNuevo(text:"Comisiones:         ${mapCuadre["comisiones"]}\n");
    map[map.length] = _getMapNuevo(text:"descuentos:         ${mapCuadre["descuentos"]}\n");
    map[map.length] = _getMapNuevo(text:"premios:            ${mapCuadre["premios"]}\n");
    map[map.length] = _getMapNuevo(text:"neto:               ${mapCuadre["neto"]}\n");
    map[map.length] = _getMapNuevo(text:"Balance mas ventas: ${mapCuadre["balanceActual"]}\n\n");
    print("bluetooth channel cuadure: ${map.toString()}");
    
    
    
    
    /****************** NUMEROS GANADORES ************************/
    map[map.length] = _getMapNuevo(cmd: CMD.center);
    map[map.length] = _getMapNuevo(text: "Numeros Ganadores\n\n");
    map[map.length] = _getMapNuevo(cmd: CMD.left);

    map[map.length] = _getMapNuevo(text:"LOTERIA 1RA 2DA 3RA PI3 PI4\n", cmd: CMD.p);
    String espacioPrimera = "        ";
    String espacioSegunda = "            ";
    String espacioTercera = "                ";
    String espacioPick3 = "                    ";
    String espacioPick4 = "                        ";
    String espacioTotal = "                           ";
    int espaciosYaAgregados = 0; 
    String textoAImprimir = "";
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


    /****************** TOTALES POR LOTERIA ************************/
    // map[map.length] = _getMapNuevo(cmd: CMD.center);
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

    /****************** TICKETS GANADORES ************************/
    // map[map.length] = _getMapNuevo(cmd: CMD.center);
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

    map[map.length] = _getMapNuevo(text:"\n\n");

    return map;
  }

  static Map<int, dynamic> generateMapTicket(Map<String, dynamic> mapVenta, String typeTicket){
    List listMapToPrint = List();
    
    

    print("generateMapTicket: ${mapVenta.toString()}");
    Map<int, dynamic> map = Map<int, dynamic>();
    map[map.length] = _getMapNuevo(cmd: CMD.center);
    map[map.length] = _getMapNuevo(text:"${mapVenta["banca"]["descripcion"]}\n", cmd: CMD.h1);
    map[map.length] = _printTicketHeader(typeTicket);
    // var fecha = DateTime.parse(mapVenta["created_at"]);
    //${DateFormat('EEEE').format(fecha)} 
    map[map.length] = _getMapNuevo(text:"${mapVenta["created_at"]}\n", cmd: CMD.p);
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
        map[map.length] = _getMapNuevo(text:"${loteria["descripcion"]}: ${_getTotalPertenecienteALoteria(jugadas)}\n");
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
            String montoAnterior = jugadas[contador - 1]["monto"].toString();
            espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaAnterior) + montoAnterior;
            
            espaciosSegundaJugada = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundaJugada, montoAnterior);
            espaciosSegundoMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundoMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
            // map[map.length] = _getMapNuevo(text:"                ${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
            // map[map.length] = _getMapNuevo(text:"                         ${jugada["monto"]}\n");
            map[map.length] = _getMapNuevo(text:"$espaciosSegundaJugada${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
            map[map.length] = _getMapNuevo(text:"$espaciosSegundoMonto${jugada["monto"]}\n");
          }else{
            espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
            map[map.length] = _getMapNuevo(text:Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"]));
            map[map.length] = _getMapNuevo(text:"$espaciosPrimerMonto${jugada["monto"]}" + siEsUltimaJugadaDarSaltoDeLinea(contadorCicleJugadas, jugadas.length));
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
            map[map.length] = _getMapNuevo(text:"Super pale (${loteria["descripcion"]}/${ls["descripcion"]}): ${_getTotalPertenecienteALoteria(jugadas)}\n", cmd: CMD.p);
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
                String montoAnterior = jugadas[contador - 1]["monto"].toString();
                espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, jugadaAnterior) + montoAnterior;
                
                espaciosSegundaJugada = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundaJugada, montoAnterior);
                espaciosSegundoMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosSegundoMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
                // map[map.length] = _getMapNuevo(text:"                ${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
                // map[map.length] = _getMapNuevo(text:"                         ${jugada["monto"]}\n");
                map[map.length] = _getMapNuevo(text:"$espaciosSegundaJugada${Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"])}");
                map[map.length] = _getMapNuevo(text:"$espaciosSegundoMonto${jugada["monto"]}\n");
              }else{
                espaciosPrimerMonto = _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(espaciosPrimerMonto, Utils.agregarSignoYletrasParaImprimir(jugada["jugada"].toString(), jugada["sorteo"]));
                map[map.length] = _getMapNuevo(text:Utils.agregarSignoYletrasParaImprimir(jugada["jugada"], jugada["sorteo"]));
                map[map.length] = _getMapNuevo(text:"$espaciosPrimerMonto${jugada["monto"]}" + siEsUltimaJugadaDarSaltoDeLinea(contadorCicleJugadas, jugadas.length));
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
      
      map[map.length] = _getMapNuevo(text:"-TOTAL: $total-$saltoLineaTotal", cmd: CMD.h1);
    
      if(typeTicket == TYPE_CANCELADO)
        map[map.length] = _getMapNuevo(text:"** CANCELADO **\n\n\n", cmd: CMD.h1);
      
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

  static _quitarEspaciosDeAcuerdoAlTamanoDeLaJugadaOMontoDado(String tamano, String jugadaOMonto){
    // print("tamano: $tamano - ${tamano.length} | jugadaOMonto: $jugadaOMonto - ${jugadaOMonto.length}");
    // print("tamanoFinal: ${tamano.substring(0, tamano.length - jugadaOMonto.length)} - ${tamano.substring(0, tamano.length - jugadaOMonto.length).length}");
    return tamano.substring(0, tamano.length - jugadaOMonto.length);
  }
  static Map<int, dynamic> generateMapTicketViejo(Map<String, dynamic> mapVenta, String typeTicket){
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
          map[map.length] = _getMap("${banca["piepagina2"]}\n",);
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

  static Map<String, dynamic> _getMapNuevo({String text = '', cmd = CMD.h2}){
    return {"text" : text, "cmd" : cmd};
  }

  static Map<String, dynamic> _getMap(String text, [int nWidthTimes = 0, String type = TYPE_CMD_PRINT_TEXT, String cmd = CMD.h2]){
    return {"text" : text, "nWidthTimes" : nWidthTimes, "type" : type, "cmd" : cmd};
  }

  static Map<String, dynamic> _getMapPrueba(String text, [int nWidthTimes = 0, String type = TYPE_CMD_PRINT_TEXT, String cmd = CMD.h2]){
    return {"text" : text, "nWidthTimes" : nWidthTimes, "type" : "prueba", "cmd" : cmd};
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