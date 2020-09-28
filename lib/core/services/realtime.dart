import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/principal.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/blocksdirty.dart';
import 'package:loterias/core/models/blocksdirtygenerals.dart';
import 'package:loterias/core/models/blocksgenerals.dart';
import 'package:loterias/core/models/blockslotteries.dart';
import 'package:loterias/core/models/blocksplays.dart';
import 'package:loterias/core/models/blocksplaysgenerals.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/stocks.dart';
import 'package:loterias/core/models/usuario.dart';
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
    
    final response = await http.post(Utils.URL +"/api/realtime/todos", body: json.encode(map2), headers: header );
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

        await batch.commit(noResult: true);
        print("RealtimeServer todosPrueba batch listo");
  }

  static usuario({BuildContext context, Map<String, dynamic> usuario}) async {
    int idUsuario = await Db.idUsuario();
    if(idUsuario != usuario["id"])
      return;
    else if(usuario["status"] != 1)
      await Principal.cerrarSesion(context);
    else{
      await Db.database.delete("Permissions");
      await Db.database.delete("Users");

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
}