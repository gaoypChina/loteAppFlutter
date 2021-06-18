import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/cross_device_info.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/principal.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/blocksdirty.dart';
import 'package:loterias/core/models/blocksdirtygenerals.dart';
import 'package:loterias/core/models/blocksgenerals.dart';
import 'package:loterias/core/models/blockslotteries.dart';
import 'package:loterias/core/models/blocksplays.dart';
import 'package:loterias/core/models/blocksplaysgenerals.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/sale.dart';
import 'package:loterias/core/models/salesdetails.dart';
import 'package:loterias/core/models/stocks.dart';
import 'package:loterias/core/models/ticket.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:ntp/ntp.dart';
import 'package:sqflite/sqflite.dart';

class Realtime{

   static Map<String, String> header = {
      // 'Content-type': 'application/json',
      HttpHeaders.contentTypeHeader: 'application/json',
      'Accept': 'application/json',
    };

    

    
    

    
    

    //https://stackoverflow.com/questions/42071051/dart-how-to-manage-concurrency-in-async-function
    static Future<Null> _isWorkingStock = null;
    static Future<Null> _isWorkingBlocksgenerals = null;


    static addStocks(var parsed, bool eliminar) async {
      // if (_isWorkingStock != null) {
      //   await _isWorkingStock; // wait for future complete
      //   return addStocks(parsed);
      // }

       // lock
      var completer = new Completer<Null>();
      _isWorkingStock = completer.future;

      if(parsed == null)
        return;
      List<Stock> stocks = parsed.map<Stock>((json) => Stock.fromMap(json)).toList();
      if(stocks.length == 0)
        return;
        
        stocks.forEach((s) async {
          List<Map<String, dynamic>> query = await Db.database.query('Stocks' , where: '"id" = ?', whereArgs: [s.id]);
          if(query.isEmpty == false){
            if(eliminar)
              await Db.delete('Stocks', s.id);
            else
              await Db.update('Stocks', s.toJson(), s.id);
          }else{
            if(eliminar)
              await Db.delete('Stocks', s.id);
            else
              await Db.insert('Stocks', s.toJson());
          }
        });
        
        // unlock
        // completer.complete();
        // _isWorkingStock = null;

        return true;
    }

    static addBlocksgeneralsDatosNuevos(var parsed, bool eliminar) async {
      if(parsed == null)
        return;
      List<Blocksgenerals> blocksgenerals = parsed.map<Blocksgenerals>((json) => Blocksgenerals.fromMap(json)).toList();
      if(blocksgenerals.length == 0)
        return;
        
        blocksgenerals.forEach((s) async {
         List<Map<String, dynamic>> query = await Db.database.query('Blocksgenerals' , where: '"id" = ?', whereArgs: [s.id]);
          if(query.isEmpty == false){
            print('query dentro y eliminar:$eliminar');
            if(eliminar)
              await Db.delete('Blocksgenerals', s.id);
            else
              await Db.update('Blocksgenerals', s.toJson(), s.id);
          }else{
            if(eliminar)
              await Db.delete('Blocksgenerals', s.id);
            else
              await Db.insert('Blocksgenerals', s.toJson());
          }
        });

         // unlock
        // completer.complete();
        // _isWorkingStock = null;

        return true;
    }

     static addBlockslotteriesDatosNuevos(var parsed, bool eliminar) async {
      if(parsed == null)
        return;
      List<Blockslotteries> blockslotteries = parsed.map<Blockslotteries>((json) => Blockslotteries.fromMap(json)).toList();
      if(blockslotteries.length == 0)
        return;

        blockslotteries.forEach((s) async {
          List<Map<String, dynamic>> query = await Db.database.query('Blockslotteries' , where: '"id" = ?', whereArgs: [s.id]);
          if(query.isEmpty == false){
            if(eliminar)
              await Db.delete('Blockslotteries', s.id);
            else
              await Db.update('Blockslotteries', s.toJson(), s.id);
          }else{
            if(eliminar)
              await Db.delete('Blockslotteries', s.id);
            else
              await Db.insert('Blockslotteries', s.toJson());
          }
        });
       
    }


    static addBlocksplaysDatosNuevos(var parsed, bool eliminar) async {
      if(parsed == null)
        return;
      List<Blocksplays> blocksplays = parsed.map<Blocksplays>((json) => Blocksplays.fromMap(json)).toList();
      if(blocksplays.length == 0)
        return;
        
        blocksplays.forEach((s) async {
         List<Map<String, dynamic>> query = await Db.database.query('Blocksplays' , where: '"id" = ?', whereArgs: [s.id]);
          if(query.isEmpty == false){
            if(eliminar)
              await Db.delete('Blocksplays', s.id);
            else
              await Db.update('Blocksplays', s.toJson(), s.id);
          }else{
            if(eliminar)
              await Db.delete('Blocksplays', s.id);
            else
              await Db.insert('Blocksplays', s.toJson());
          }
        });
        
    }


    static addBlocksplaysgeneralsDatosNuevos(var parsed, bool eliminar) async {
      if(parsed == null)
        return;
      List<Blocksplaysgenerals> blocksplaysgenerals = parsed.map<Blocksplaysgenerals>((json) => Blocksplaysgenerals.fromMap(json)).toList();
      if(blocksplaysgenerals.length == 0)
        return;
        blocksplaysgenerals.forEach((s) async {
          List<Map<String, dynamic>> query = await Db.database.query('Blocksplaysgenerals' , where: '"id" = ?', whereArgs: [s.id]);
          if(query.isEmpty == false){
            print('Blocksplaysgenerals existe, eliminar: $eliminar');
            if(eliminar)
              await Db.delete('Blocksplaysgenerals', s.id);
            else
              await Db.update('Blocksplaysgenerals', s.toJson(), s.id);
          }else{
            if(eliminar)
              await Db.delete('Blocksplaysgenerals', s.id);
            else
              await Db.insert('Blocksplaysgenerals', s.toJson());
          }
        });
       
    }

   

   static sincronizarTodos(GlobalKey<ScaffoldState> _scaffoldKey) async{
    var map = new Map<String, dynamic>();
    var map2 = new Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    map2["datos"] =jwt;
    
    final response = await http.post(Uri.parse(Utils.URL +"/api/realtime/todos"), body: json.encode(map2), headers: header );
    int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      //  print('sincronizarTodos error: ${response.body}');
      throw Exception('Failed to load post');
    } else {
      // Si esta respuesta no fue OK, lanza un error.
       //var parsed = json.decode(response.body).cast<String, dynamic>();
       //print('sincronizarTodos: ${parsed}');
      // insertarDatos(response.body, true);
      // stockBox.
      
      // var parsed = json.decode(response.body).cast<String, dynamic>();
      var parsed = await compute(Utils.parseDatos, response.body);
        
        // await c.add("maximoIdRealtime", parsed['maximoIdRealtime']);

        print('fuera stocks version: ${parsed['version']}');
      
      // if(parsed["version"] != null){
      //   await Principal.version(context: _scaffoldKey.currentContext, version: parsed["version"]);
      // }
      // if(parsed["usuario"] != null){
      //   await usuario(context: _scaffoldKey.currentContext, usuario: parsed["usuario"]);
      // }

      //  if(parsed['stocks'] != null){
      //   print('dentro stocks: ${parsed['stocks']}');

      //     List<Stock> lista = parsed['stocks'].map<Stock>((json) => Stock.fromMap(json)).toList();
      //     for(Stock s in lista){
      //       await Db.insert("Stocks", s.toJson());
      //     }
      //  }

      //   if(parsed['blocksgenerals'] != null){
      //     List<Blocksgenerals> listBlocksgenerals = parsed['blocksgenerals'].map<Blocksgenerals>((json) => Blocksgenerals.fromMap(json)).toList();
      //     for(Blocksgenerals b in listBlocksgenerals){
      //       await Db.insert("Blocksgenerals", b.toJson());
      //     }
      //   }

      //   if(parsed['blockslotteries'] != null){
      //     List<Blockslotteries> listBlockslotteries = parsed['blockslotteries'].map<Blockslotteries>((json) => Blockslotteries.fromMap(json)).toList();
      //     for(Blockslotteries b in listBlockslotteries){
      //       await Db.insert("Blockslotteries", b.toJson());
      //     }
      //   }

      //   if(parsed['blocksplays'] != null){
      //     List<Blocksplays> listBlocksplays = parsed['blocksplays'].map<Blocksplays>((json) => Blocksplays.fromMap(json)).toList();
      //     for(Blocksplays b in listBlocksplays){
      //       await Db.insert("Blocksplays", b.toJson());
      //     }
      //   }

      //   if(parsed['blocksplaysgenerals'] != null){
      //     List<Blocksplaysgenerals> listBlocksplaysgenerals = parsed['blocksplaysgenerals'].map<Blocksplaysgenerals>((json) => Blocksplaysgenerals.fromMap(json)).toList();
      //     for(Blocksplaysgenerals b in listBlocksplaysgenerals){
      //       await Db.insert("Blocksplaysgenerals", b.toJson());
      //     }
      //   }

      //   if(parsed['draws'] != null){
      //     List<Draws> listDraws = parsed['draws'].map<Draws>((json) => Draws.fromMap(json)).toList();
      //     for(Draws b in listDraws){
      //       await Db.insert("Draws", b.toJson());
      //     }
      //   }
        


        await Realtime.sincronizarTodosDataBatch(_scaffoldKey, parsed);
        

        // print('stocks insertar: ${parsed['draws']}');
    }
  }

  static sincronizarTodosData(_scaffoldKey, var parsed) async {
    if(parsed["version"] != null){
        await Principal.version(context: _scaffoldKey.currentContext, version: parsed["version"]);
      }
      if(parsed["usuario"] != null){
        await usuario(context: _scaffoldKey.currentContext, usuario: parsed["usuario"]);
      }

       if(parsed['stocks'] != null){
        print('dentro stocks: ${parsed['stocks']}');

          List<Stock> lista = parsed['stocks'].map<Stock>((json) => Stock.fromMap(json)).toList();
          for(Stock s in lista){
            await Db.insert("Stocks", s.toJson());
          }
       }

        if(parsed['blocksgenerals'] != null){
          List<Blocksgenerals> listBlocksgenerals = parsed['blocksgenerals'].map<Blocksgenerals>((json) => Blocksgenerals.fromMap(json)).toList();
          for(Blocksgenerals b in listBlocksgenerals){
            await Db.insert("Blocksgenerals", b.toJson());
          }
        }

        if(parsed['blockslotteries'] != null){
          List<Blockslotteries> listBlockslotteries = parsed['blockslotteries'].map<Blockslotteries>((json) => Blockslotteries.fromMap(json)).toList();
          for(Blockslotteries b in listBlockslotteries){
            await Db.insert("Blockslotteries", b.toJson());
          }
        }

        if(parsed['blocksplays'] != null){
          List<Blocksplays> listBlocksplays = parsed['blocksplays'].map<Blocksplays>((json) => Blocksplays.fromMap(json)).toList();
          for(Blocksplays b in listBlocksplays){
            await Db.insert("Blocksplays", b.toJson());
          }
        }

        if(parsed['blocksplaysgenerals'] != null){
          List<Blocksplaysgenerals> listBlocksplaysgenerals = parsed['blocksplaysgenerals'].map<Blocksplaysgenerals>((json) => Blocksplaysgenerals.fromMap(json)).toList();
          for(Blocksplaysgenerals b in listBlocksplaysgenerals){
            await Db.insert("Blocksplaysgenerals", b.toJson());
          }
        }

        if(parsed['draws'] != null){
          List<Draws> listDraws = parsed['draws'].map<Draws>((json) => Draws.fromMap(json)).toList();
          for(Draws b in listDraws){
            await Db.insert("Draws", b.toJson());
          }
        }
  }
  static sincronizarTodosDataBatch(_scaffoldKey, var parsed) async {
    if(kIsWeb)
      return;
      
    Batch batch = Db.database.batch();
    if(parsed["version"] != null){
        await Principal.version(context: _scaffoldKey.currentContext, version: parsed["version"]);
      }
      if(parsed["usuario"] != null){
        await usuario(context: _scaffoldKey.currentContext, usuario: parsed["usuario"]);
      }

       if(parsed['stocks'] != null){
        print('dentro stocks: ${parsed['stocks']}');

          List<Stock> lista = parsed['stocks'].map<Stock>((json) => Stock.fromMap(json)).toList();
          for(Stock s in lista){
            // batch.insert("Stocks", s.toJson());
            batch.rawInsert(
              "insert or replace into Stocks(id, idBanca, idLoteria, idLoteriaSuperpale, idSorteo, jugada, montoInicial, monto, created_at, esBloqueoJugada, esGeneral, ignorarDemasBloqueos, idMoneda) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
                                                    [s.id, s.idBanca, s.idLoteria, s.idLoteriaSuperpale, s.idSorteo, s.jugada, s.montoInicial, s.monto, s.created_at.toString(), s.esBloqueoJugada, s.esGeneral, s.ignorarDemasBloqueos, s.idMoneda]);
          }
       }

        if(parsed['blocksgenerals'] != null){
          List<Blocksgenerals> listBlocksgenerals = parsed['blocksgenerals'].map<Blocksgenerals>((json) => Blocksgenerals.fromMap(json)).toList();
          for(Blocksgenerals b in listBlocksgenerals){
            // batch.insert("Blocksgenerals", b.toJson());
            batch.rawInsert(
              "insert or replace into Blocksgenerals(id, idDia, idLoteria, idSorteo, monto, created_at, idMoneda) values(?, ?, ?, ?, ?, ?, ?)", 
                                                        [b.id, b.idDia, b.idLoteria, b.idSorteo, b.monto, b.created_at.toString(), b.idMoneda]);
          }
        }

        if(parsed['blockslotteries'] != null){
          List<Blockslotteries> listBlockslotteries = parsed['blockslotteries'].map<Blockslotteries>((json) => Blockslotteries.fromMap(json)).toList();
          for(Blockslotteries b in listBlockslotteries){
            //  batch.insert("Blockslotteries", b.toJson());
             batch.rawInsert(
              "insert or replace into Blockslotteries(id, idBanca, idDia, idLoteria, idSorteo, monto, created_at, idMoneda) values(?, ?, ?, ?, ?, ?, ?, ?)", 
                                                        [b.id, b.idBanca, b.idDia, b.idLoteria, b.idSorteo, b.monto, b.created_at.toString(), b.idMoneda]);
          }
        }

        if(parsed['blocksplays'] != null){
          List<Blocksplays> listBlocksplays = parsed['blocksplays'].map<Blocksplays>((json) => Blocksplays.fromMap(json)).toList();
          for(Blocksplays b in listBlocksplays){
            // batch.insert("Blocksplays", b.toJson());
            batch.rawInsert(
              "insert or replace into Blocksplays(id, idBanca, idLoteria, idSorteo, jugada, montoInicial, monto, fechaDesde, fechaHasta, created_at, ignorarDemasBloqueos, status, idMoneda) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
                                                    [b.id, b.idBanca, b.idLoteria, b.idSorteo, b.jugada, b.montoInicial, b.monto, b.fechaDesde.toString(), b.fechaHasta.toString(), b.created_at.toString(), b.ignorarDemasBloqueos, b.status, b.idMoneda]);
          }
        }

        if(parsed['blocksplaysgenerals'] != null){
          List<Blocksplaysgenerals> listBlocksplaysgenerals = parsed['blocksplaysgenerals'].map<Blocksplaysgenerals>((json) => Blocksplaysgenerals.fromMap(json)).toList();
          for(Blocksplaysgenerals b in listBlocksplaysgenerals){
            // batch.insert("Blocksplaysgenerals", b.toJson());
            batch.rawInsert(
              "insert or replace into Blocksplaysgenerals(id, idLoteria, idSorteo, jugada, montoInicial, monto, fechaDesde, fechaHasta, created_at, ignorarDemasBloqueos, status, idMoneda) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
                                                          [b.id, b.idLoteria, b.idSorteo, b.jugada, b.montoInicial, b.monto, b.fechaDesde.toString(), b.fechaHasta.toString(), b.created_at.toString(), b.ignorarDemasBloqueos, b.status, b.idMoneda]);
          }
        }

        if(parsed['draws'] != null){
          List<Draws> listDraws = parsed['draws'].map<Draws>((json) => Draws.fromMap(json)).toList();
          for(Draws b in listDraws){
            // batch.insert("Draws", b.toJson());
            batch.rawInsert(
              "insert or replace into Draws(id, descripcion, bolos, cantidadNumeros, status, created_at) values(?, ?, ?, ?, ?, ?)", 
                                                      [b.id, b.descripcion, b.bolos, b.cantidadNumeros, b.status, b.created_at.toString()]);
          }
        }

        if(parsed['blocksdirtygenerals'] != null){
          List<Blocksdirtygenerals> listBlocksdirtygenerals = parsed['blocksdirtygenerals'].map<Blocksdirtygenerals>((json) => Blocksdirtygenerals.fromMap(json)).toList();
          for(Blocksdirtygenerals b in listBlocksdirtygenerals){
            // batch.insert("Blocksgenerals", b.toJson());
            batch.rawInsert(
              "insert or replace into Blocksdirtygenerals(id, idLoteria, idSorteo, cantidad, created_at, idMoneda) values(?, ?, ?, ?, ?, ?)", 
                                                        [b.id, b.idLoteria, b.idSorteo, b.cantidad, b.created_at.toString(), b.idMoneda]);
          }
        }

        if(parsed['blocksdirty'] != null){
          List<Blocksdirty> listBlocksdirty = parsed['blocksdirty'].map<Blocksdirty>((json) => Blocksdirty.fromMap(json)).toList();
          for(Blocksdirty b in listBlocksdirty){
            // batch.insert("Blocksgenerals", b.toJson());
            batch.rawInsert(
              "insert or replace into Blocksdirty(id, idBanca, idLoteria, idSorteo, cantidad, created_at, idMoneda) values(?, ?, ?, ?, ?, ?, ?)", 
                                                        [b.id, b.idBanca, b.idLoteria, b.idSorteo, b.cantidad, b.created_at.toString(), b.idMoneda]);
          }
        }

        await batch.commit(noResult: true);
        print("RealtimeServer todosPrueba batch listo");
  }

  static guardarVenta({Banca banca, List<Jugada> jugadas, socket, List<Loteria> listaLoteria, bool compartido, int descuentoMonto, currentTimeZone, bool tienePermisoJugarFueraDeHorario, bool tienePermisoJugarMinutosExtras}) async {
    print("Realtime guardarventa before: ${Db.database.transaction}");
    Sale sale;
    List<Salesdetails> listSalesdetails = [];
    await Db.database.transaction((tx) async {
    // Batch batch = tx.batch();
    DateTime date = await NTP.now();
    Usuario usuario = Usuario.fromMap(await Db.getUsuario(tx));
    Ticket ticket = Ticket.fromMap(await Db.getNextTicket(tx));
    double total = 0;
        
    print("Realtime guardarVenta banca.status = ${banca.status}");
    print("Realtime guardarVenta usuario = ${usuario}");
    if(banca.status != 1)
      throw Exception("Esta banca esta desactivada");

    if(usuario.status != 1)
      throw Exception("Este usuario esta desactivado: ${usuario.status}");

    if(await Db.existePermisos(["Vender tickets", "Acceso al sistema"], tx) == false)
      throw Exception("No tiene permiso para realizar esta accion vender y acceso");

    if(await Db.idBanca(tx) != banca.id){
        if(await Db.existePermiso("Jugar como cualquier banca") == false)
          throw Exception("No tiene permiso para realizar para jugar como cualquier banca");
    }

    // socket.emit("idTicket", 1234567);

    // VALIDACION HORAR APERTURA Y CIERRE DE LA BANCA
    DateTime hoyHoraAperturaBanca = banca.dias.firstWhere((element) => element.id == Utils.getIdDiaActual()).horaApertura;
    DateTime hoyHoraCierreBanca = banca.dias.firstWhere((element) => element.id == Utils.getIdDiaActual()).horaCierre;
    if(date.isBefore(hoyHoraAperturaBanca))
        throw Exception("La banca no ha abierto");
    if(date.isAfter(hoyHoraCierreBanca))
        throw Exception("La banca ha cerrado");

    total = jugadas.map((e) => e.monto).toList().reduce((value, element) => value + element);
    // VALIDACION LIMITE VENTA BANCA
    if(total > banca.limiteVenta)
        throw Exception("A excedido el limite de ventas de la banca: ${banca.limiteVenta}");

    // CREACION CODIGO BARRA
    ticket.codigoBarra = "${banca.id}${Utils.dateTimeToMilisenconds(DateTime.now())}";

    List<Jugada> listaLoteriasJugadas = Utils.removeDuplicateLoteriasFromList(List.from(jugadas)).cast<Jugada>().toList();
    List<Jugada> listaLoteriasSuperPaleJugadas = Utils.removeDuplicateLoteriasSuperPaleFromList(List.from(jugadas)).cast<Jugada>().toList();
    listaLoteriasJugadas.forEach((element) {print("Realtime guardar venta loteria: ${element.idLoteria}");});
    listaLoteriasSuperPaleJugadas.forEach((element) {print("Realtime guardar venta loteriaSuper: ${element.idLoteriaSuperpale}");});

    // VALIDACION LOTERIA PERTENECE A BANCA
    for (var jugada in listaLoteriasJugadas) {
      if(banca.loterias.indexWhere((element) => element.id == jugada.idLoteria) == -1)
        throw Exception("La loteria ${jugada.loteria.descripcion} no pertenece a esta banca");

      Loteria loteria = listaLoteria.firstWhere((element) => element.id == jugada.loteria.id, orElse: () => null);
      print("Realtime guardarVenta apertura: ${loteria.horaApertura} horaCierre: ${loteria.horaCierre}");
      if(date.isBefore(Utils.horaLoteriaToCurrentTimeZone(loteria.horaApertura, date)))
        throw Exception("La loteria ${loteria.descripcion} no ha abierto");
      if(date.isAfter(Utils.horaLoteriaToCurrentTimeZone(loteria.horaCierre, date))){
        if(!tienePermisoJugarFueraDeHorario){
          if(tienePermisoJugarMinutosExtras){
            var datePlusExtraMinutes = date.add(Duration(minutes: loteria.minutosExtras));
            if(date.isAfter(datePlusExtraMinutes))
              throw Exception("La loteria ${loteria.descripcion} ha cerrado");
          }
          else
            throw Exception("La loteria ${loteria.descripcion} ha cerrado");
        }
      }
    }
    

    // VALIDACION LOTERIA SUPERPALE PERTENECE A BANCA
    for (var jugada in listaLoteriasSuperPaleJugadas) {
      print("Realtime guardarVenta validacion superpale: ${jugada.idLoteriaSuperpale} null: ${jugada.loteriaSuperPale == null}");
      if(banca.loterias.indexWhere((element) => element.id == jugada.idLoteriaSuperpale) == -1)
        throw Exception("La loteria ${jugada.loteriaSuperPale.descripcion} no pertenece a esta banca");
      
      Loteria loteriaSuperPale = listaLoteria.firstWhere((element) => element.id == jugada.loteriaSuperPale.id, orElse: () => null);
      if(date.isBefore(Utils.horaLoteriaToCurrentTimeZone(loteriaSuperPale.horaApertura, date)))
        throw Exception("La loteria ${loteriaSuperPale.descripcion} aun no ha abierto");
      if(date.isAfter(Utils.horaLoteriaToCurrentTimeZone(loteriaSuperPale.horaCierre, date))){
        if(!tienePermisoJugarFueraDeHorario){
          if(tienePermisoJugarMinutosExtras){
            var datePlusExtraMinutes = date.add(Duration(minutes: loteriaSuperPale.minutosExtras));
            if(date.isAfter(datePlusExtraMinutes))
              throw Exception("La loteria ${loteriaSuperPale.descripcion} ha cerrado");
          }
          else
            throw Exception("La loteria ${loteriaSuperPale.descripcion} ha cerrado");
        }
      }
      
      
    }

    /**************** AHORA DEBO INVESTIGAR COMO OBTENER EL NUMERO DE TICKET, ESTOY INVESTIGANDO LARAVEL CACHE A VER COMO SE COMUNICA CON REDIS */


    print("Realtime guardarVenta before insert sales idTicket: ${ticket.id.toInt()}");
    await Db.insert('Sales', Sale(compartido: compartido ? 1 : 0, idUsuario: usuario.id, idBanca: banca.id, total: total, subTotal: 0, descuentoMonto: descuentoMonto, hayDescuento: descuentoMonto > 0 ? 1 : 0, idTicket: ticket.id, created_at: DateTime.now()).toJson(), tx);
    var saleMap = await Db.queryBy("Sales", "idTicket", ticket.id.toInt(), tx);
    print("Realtime guardarVenta after insert sales saleMap: ${saleMap}");
    sale = saleMap != null ? Sale.fromMap(saleMap) : null;
    if(sale == null)
      throw Exception("Hubo un error al realizar la venta, la venta es nula");

    sale.ticket = ticket;
    sale.banca = banca;
    sale.usuario = usuario;

    for (Jugada jugada in jugadas) {      
      await Future(() async {
        // int id = int.parse(oi.findElements("ID").first.text);
        // String name = oi.findElements("NAME").first.text;

        //  DatabaseHelper.insertElement(
        //   tx,
        //   id: id,
        //   name: name,
        //  );
        String id = "";
        
        Loteria loteria = listaLoteria.firstWhere((element) => element.id == jugada.loteria.id, orElse: () => null);
        Loteria loteriaSuperPale;
        if(loteria.sorteos.indexWhere((element) => element.id == jugada.idSorteo) == -1)
          throw Exception("El sorteo ${jugada.sorteo} no pertenece a la loteria ${jugada.loteria.descripcion}");
        if(jugada.idSorteo == 4){
          loteriaSuperPale = listaLoteria.firstWhere((element) => element.id == jugada.loteriaSuperPale.id, orElse: () => null);
          if(loteriaSuperPale.sorteos.indexWhere((element) => element.id == jugada.idSorteo) == -1)
            throw Exception("El sorteo ${jugada.sorteo} no pertenece a la loteria ${jugada.loteriaSuperPale.descripcion}");
        }
        
        var salesdetails = Salesdetails(idVenta: sale.id, idLoteria: loteria.id, idSorteo: jugada.idSorteo, jugada: jugada.jugada, monto: jugada.monto, premio: jugada.premio, comision: 0, idStock: 0, idLoteriaSuperpale: loteriaSuperPale != null ? loteriaSuperPale.id : null, created_at: date, updated_at: date, status: 0, loteria: loteria, loteriaSuperPale: loteriaSuperPale, sorteo: Draws(jugada.idSorteo, jugada.sorteo, null, null, null, null));
        await Db.insert('Salesdetails', salesdetails.toJson(), tx);
        listSalesdetails.add(salesdetails);
        print("Realtime guardarVenta for jugadas: ${listSalesdetails.length}");
      });
    }

    // VALIDAR SI LA LOTERIA EXISTE EN LA LISTA LOTERIA, SI NO EXISTE, ESO QUIERE DECIR O QUE HA CERRADO O QUE SE HAN REGISTRADO PREMIOS
    for (var jugada in listaLoteriasJugadas) {
      if(listaLoteria.indexWhere((element) => element.id == jugada.loteria.id) == -1)
        throw Exception("La loteria ${jugada.loteria.descripcion} ha cerrado o se han registrado premios");
    }

    // VALIDACION LOTERIA SUPERPALE PERTENECE A BANCA
    for (var jugada in listaLoteriasSuperPaleJugadas) {
      if(listaLoteria.indexWhere((element) => element.id == jugada.loteriaSuperPale.id) == -1)
        throw Exception("La loteria ${jugada.loteriaSuperPale.descripcion} ha cerrado o se han registrado premios");
    }

    ticket.usado = 1;
    await Db.update("Tickets", ticket.toJson(), ticket.id.toInt(), tx);

    socket.emit("ticket", await Utils.createJwt({"servidor" : await Db.servidor(tx), "idBanca" : banca.id, "uuid" : await CrossDeviceInfo.getUIID(), "createNew" : true}));
    // batch.commit(noResult: false, continueOnError: false);
    // tx.commit();
  });
    print("Realtime guardarventa after transaction: ${listSalesdetails.length}");
    return [sale, listSalesdetails];
  }
  
  static usuario({BuildContext context, Map<String, dynamic> usuario}) async {
    int idUsuario = await Db.idUsuario();
    if(idUsuario != usuario["id"])
      return;
    else if(usuario["status"] != 1)
      await Principal.cerrarSesion(context);
    else{
      await Db.delete("Permissions");
      await Db.delete("Users");

      List<Permiso> permisos = usuario['permisos'].map<Permiso>((json) => Permiso.fromMap(json)).toList();
      Usuario u = Usuario.fromMap(usuario);


      // var datos = await Db.query("Permissions");
      // print("Realtime:Usuario permisosExistentes: ${datos.toString()}");
      
      await Db.insert('Users', u.toJson());
      for(Permiso p in permisos){
        print("Permiso: ${p.toJson()}");
        await Db.insert('Permissions', p.toJson());
      }

      print("Realtime:Usuario existePermiso: ${await Db.existePermiso("Jugar como cualquier banca")}");
    }
  }
  

  static ajustes(Map<String, dynamic> parsed) async {
    print("Realtime AJustes SettingsEvent data: $parsed");
      try {
        if(parsed["settings"] != null){
            Ajuste a = Ajuste.fromMap(parsed["settings"]);
            await Db.database.delete("Settings");
            await Db.insert("Settings", {
              "id" : a.id, 
              "consorcio" : a.consorcio,
              "idTipoFormatoTicket" : a.tipoFormatoTicket.id,
              "imprimirNombreConsorcio" : a.imprimirNombreConsorcio,
              "descripcionTipoFormatoTicket" : a.tipoFormatoTicket.descripcion,
              "imprimirNombreBanca" : a.imprimirNombreBanca,
              "cancelarTicketWhatsapp" : a.cancelarTicketWhatsapp,
            });
        
          print("RealTime ajustes, se guardaron correctamente");
        }
      } on Exception catch (e) {
        print("Error RealTime.ajustes: ${e.toString()}");
      }
  }

  static hello(){
    print('hola');
  }

  all(){

  }

  static addBlocksdirtygeneralsDatosNuevos(var parsed, bool eliminar) async {
      if(parsed == null)
        return;
      List<Blocksdirtygenerals> blocksdirtygenerals = parsed.map<Blocksdirtygenerals>((json) => Blocksdirtygenerals.fromMap(json)).toList();
      if(blocksdirtygenerals.length == 0)
        return;
        
        blocksdirtygenerals.forEach((s) async {
         List<Map<String, dynamic>> query = await Db.database.query('Blocksdirtygenerals' , where: '"id" = ?', whereArgs: [s.id]);
          if(query.isEmpty == false){
            print('query dentro y eliminar:$eliminar');
            if(eliminar)
              await Db.delete('Blocksdirtygenerals', s.id);
            else
              await Db.update('Blocksdirtygenerals', s.toJson(), s.id);
          }else{
            if(eliminar)
              await Db.delete('Blocksdirtygenerals', s.id);
            else
              await Db.insert('Blocksdirtygenerals', s.toJson());
          }
        });

        return true;
    }
  static addBlocksdirtyDatosNuevos(var parsed, bool eliminar) async {
      if(parsed == null)
        return;
      List<Blocksdirty> blocksdirty = parsed.map<Blocksdirty>((json) => Blocksdirty.fromMap(json)).toList();
      if(blocksdirty.length == 0)
        return;
        
        blocksdirty.forEach((s) async {
         List<Map<String, dynamic>> query = await Db.database.query('Blocksdirty' , where: '"id" = ?', whereArgs: [s.id]);
          if(query.isEmpty == false){
            print('query dentro y eliminar:$eliminar');
            if(eliminar)
              await Db.delete('Blocksdirty', s.id);
            else
              await Db.update('Blocksdirty', s.toJson(), s.id);
          }else{
            if(eliminar)
              await Db.delete('Blocksdirty', s.id);
            else
              await Db.insert('Blocksdirty', s.toJson());
          }
        });

        return true;
    }

    static createTicketIfNotExists(var parsed) async {
      var ticketMap = await Db.getLastRow("Tickets"); 
      Ticket ticketDB = ticketMap != null ? Ticket.fromMap(ticketMap) : null;
      Ticket ticketParsed = parsed != null ? Ticket.fromMap(parsed) : null;
      if(ticketParsed.id == BigInt.zero)
        return;

      print("Realtime createTicketIfNotExists: ${ticketParsed.toJson()}");
      if(ticketDB != null){
        if(ticketDB.id != ticketParsed.id)
          Db.insert("Tickets", ticketParsed.toJson());
      }else
        Db.insert("Tickets", ticketParsed.toJson());
    }
}