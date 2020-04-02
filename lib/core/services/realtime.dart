import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/blocksgenerals.dart';
import 'package:loterias/core/models/blockslotteries.dart';
import 'package:loterias/core/models/blocksplays.dart';
import 'package:loterias/core/models/blocksplaysgenerals.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/stocks.dart';

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
      // if (_isWorkingBlocksgenerals != null) {
      //   await _isWorkingBlocksgenerals; // wait for future complete
      //   return addBlocksgeneralsDatosNuevos(parsed, eliminar);
      // }

      // lock
      // var completer = new Completer<Null>();
      // _isWorkingBlocksgenerals = completer.future;

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

   

   static sincronizarTodos() async{
    var map = new Map<String, dynamic>();
    var map2 = new Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map2["datos"] =map;
    
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
      
      var parsed = json.decode(response.body).cast<String, dynamic>();
        
        // await c.add("maximoIdRealtime", parsed['maximoIdRealtime']);

        print('fuera stocks: ${parsed['stocks']}');
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
        


        
        // await c.addList("stocks", parsed['stocks']);
        // await c.addList("blocksgenerals", parsed['blocksgenerals']);
        // await c.addList("blockslotteries", parsed['blockslotteries']);
        // await c.addList("blocksplays", parsed['blocksplays']);
        // await c.addList("blocksplaysgenerals", parsed['blocksplaysgenerals']);
        // await c.addList("draws", parsed['draws']);

        // print('stocks insertar: ${parsed['draws']}');
    }
  }

  static hello(){
    print('hola');
  }

  all(){

  }
}