import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/cross_platform_database/cross_platform_db.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/drift_database.dart' as drift;
import 'package:loterias/core/classes/principal.dart';
import 'package:loterias/core/models/blocksdirty.dart';
import 'package:loterias/core/models/blocksdirtygenerals.dart';
import 'package:loterias/core/models/blocksgenerals.dart';
import 'package:loterias/core/models/blockslotteries.dart';
import 'package:loterias/core/models/blocksplays.dart';
import 'package:loterias/core/models/blocksplaysgenerals.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/montodisponible.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/sale.dart';
import 'package:loterias/core/models/salesdetails.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/models/stocks.dart';
import 'package:loterias/core/models/ticket.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/services/montodisponiblemovilservice.dart';
import 'package:loterias/core/services/sorteoservice.dart';
import 'package:sqflite/sqflite.dart';

import '../utils.dart';

class MobileDB implements CrossDB{
  var database;
  // @override
  // QueryExecutor getMoorCrossConstructor() {
  //   // TODO: implement getMoorCrossConstructor
  //   return FlutterQueryExecutor.inDatabaseFolder(path: "db.sqlite", logStatements: true);
  // }

//   @override
//   LazyDatabase openConnection() {
//   // the LazyDatabase util lets us find the right location for the file async.
//   return LazyDatabase(() async {
//     // put the database file, called db.sqlite here, into the documents folder
//     // for your app.
//     final dbFolder = await getApplicationDocumentsDirectory();
//     final file = File(p.join(dbFolder.path, 'db.sqlite'));
//     return VmDatabase(file);
//   });
// }
  @override
  openConnection() async {
  // return FlutterQueryExecutor.inDatabaseFolder(path: "db.sqlite", logStatements: true);
  await DBSqflite.create();
  await DBSqflite.open();
  database = DBSqflite.database;
  return DBSqflite;
}

@override
  deleteDB() async {
  // return FlutterQueryExecutor.inDatabaseFolder(path: "db.sqlite", logStatements: true);
  await DBSqflite.deleteDB();
  return DBSqflite;
}

  @override
  String getPlatform() {
    // TODO: implement getPlatform
    return "Mobile";
  }

  @override
  Future<Map<String, dynamic>> ajustes() {
    // TODO: implement ajustes
    return DBSqflite.ajustes();
  }

  @override
  Future delete(String table, [id]) {
    if(id == null)
      return DBSqflite.database.delete(table);
      
    return DBSqflite.delete(table, id);
  }
  
  @override
  Future<bool> existePermiso(String permiso, [var transaction]) {
    // TODO: implement existePermiso
    return DBSqflite.existePermiso(permiso, transaction);
  }
  
  @override
  Future<Map<String, dynamic>> getBanca() {
    // TODO: implement getBanca
    return DBSqflite.getBanca();
  }
  
  @override
  Future<Map<String, dynamic>> getUsuario([var transaction]) {
    // TODO: implement getUsuario
    return DBSqflite.getUsuario(transaction);
  }
  
  @override
  Future<int> idBanca([var transaction]) {
    // TODO: implement idBanca
    return DBSqflite.idBanca(transaction);
  }
  
  @override
  Future<int> idUsuario() {
    // TODO: implement idUsuario
    return DBSqflite.idUsuario();
  }
  
  @override
  Future<void> insert(String table, Map<String, dynamic> dataToMap, [var transaction]) {
    // TODO: implement insert
    return DBSqflite.insert(table, dataToMap, transaction);
  }
  
  @override
  Future<List<Map<String, dynamic>>> query(String table) {
    // TODO: implement query
    return DBSqflite.query(table);
  }
  
  @override
  Future<String> servidor([var transaction]) {
    // TODO: implement servidor
    return DBSqflite.servidor(transaction);
  }
  
  @override
  Future<String> tipoFormatoTicket() {
    // TODO: implement tipoFormatoTicket
    return DBSqflite.tipoFormatoTicket();
  }
  
  @override
  Future update(String table, Map<String, dynamic> dataToMap, id, [var transaccion]) {
  // TODO: implement update
    return DBSqflite.update(table, dataToMap, id, transaccion);
  }

  @override
  Future<bool> existePermisos(List<String> permiso, [var transaction]) {
    // TODO: implement existePermisos
    return DBSqflite.existePermisos(permiso, transaction);
  }

  @override
  Future<Map<String, dynamic>> getLastRow(String table, [var transaction]) {
    // TODO: implement getLastRow
    return DBSqflite.getLastRow(table, transaction);
  }

  @override
  Future<bool> existeLoteria(int id, [var transaction]) {
    // TODO: implement existeLoteria
    return DBSqflite.existeLoteria(id, transaction);
  }

  @override
  Future<Map<String, dynamic>> getNextTicket(int idBanca, String servidor, [var transaction]) {
    // TODO: implement getLastRow
    return DBSqflite.getNextTicket(idBanca, servidor, transaction);
  }

  @override
  Future<Map<String, dynamic>> queryBy(String table, String by, dynamic value, [var transaction]) {
    // TODO: implement getLastRow
    return DBSqflite.queryBy(table, by, value, transaction);
  }

  @override
  Future<List<Map<String, dynamic>>> queryListBy(String table, String by, dynamic value, [var transaction]) {
    // TODO: implement getLastRow
    return DBSqflite.queryListBy(table, by, value, transaction);
  }

  @override
  Future<Map<String, dynamic>> getSaleNoSubida([var transaction]) {
    // TODO: implement getLastRow
    return DBSqflite.getSaleNoSubida(transaction);
  }

  @override
  Future<int> idGrupo() {
    // TODO: implement idGrupo
    return DBSqflite.idGrupo();
  }

  @override
  Future<void> sincronizarTodosDataBatch(parsed) async {
    // TODO: implement sincronizarTodosDataBatch
      Batch batch = DBSqflite.database.batch();
    

       if(parsed['stocks'] != null){
        print('dentro stocks: ${parsed['stocks']}');

          List<Stock> lista = parsed['stocks'].map<Stock>((json) => Stock.fromMap(json)).toList();
          print('Realtime sincronizarTodosDataBatch length stocks: ${lista.length}');
          for(Stock s in lista){
            // batch.insert("Stocks", s.toJson());
            batch.rawInsert(
              "insert or replace into Stocks(id, idBanca, idLoteria, idLoteriaSuperpale, idSorteo, jugada, montoInicial, monto, created_at, esBloqueoJugada, esGeneral, ignorarDemasBloqueos, idMoneda, descontarDelBloqueoGeneral) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
                                                    [s.id, s.idBanca, s.idLoteria, s.idLoteriaSuperpale, s.idSorteo, s.jugada, s.montoInicial, s.monto, s.created_at.toString(), s.esBloqueoJugada, s.esGeneral, s.ignorarDemasBloqueos, s.idMoneda, s.descontarDelBloqueoGeneral]);
          }
       }

        if(parsed['blocksgenerals'] != null){
          List<Blocksgenerals> listBlocksgenerals = parsed['blocksgenerals'].map<Blocksgenerals>((json) => Blocksgenerals.fromMap(json)).toList();
          print('Realtime sincronizarTodosDataBatch length blocksgenerals: ${listBlocksgenerals.length}');
          for(Blocksgenerals b in listBlocksgenerals){
            // batch.insert("Blocksgenerals", b.toJson());
            batch.rawInsert(
              "insert or replace into Blocksgenerals(id, idDia, idLoteria, idLoteriaSuperpale, idSorteo, monto, created_at, idMoneda) values(?, ?, ?, ?, ?, ?, ?, ?)", 
                                                        [b.id, b.idDia, b.idLoteria, b.idLoteriaSuperpale, b.idSorteo, b.monto, b.created_at.toString(), b.idMoneda]);
          }
        }

        if(parsed['blockslotteries'] != null){
          List<Blockslotteries> listBlockslotteries = parsed['blockslotteries'].map<Blockslotteries>((json) => Blockslotteries.fromMap(json)).toList();
          print('Realtime sincronizarTodosDataBatch length blockslotteries: ${listBlockslotteries.length}');
          for(Blockslotteries b in listBlockslotteries){
            //  batch.insert("Blockslotteries", b.toJson());
             batch.rawInsert(
              "insert or replace into Blockslotteries(id, idBanca, idDia, idLoteria, idLoteriaSuperpale, idSorteo, monto, created_at, idMoneda, descontarDelBloqueoGeneral) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
                                                        [b.id, b.idBanca, b.idDia, b.idLoteria, b.idLoteriaSuperpale, b.idSorteo, b.monto, b.created_at.toString(), b.idMoneda, b.descontarDelBloqueoGeneral]);
          }
        }

        if(parsed['blocksplays'] != null){
          List<Blocksplays> listBlocksplays = parsed['blocksplays'].map<Blocksplays>((json) => Blocksplays.fromMap(json)).toList();
          print('Realtime sincronizarTodosDataBatch length blocksplays: ${listBlocksplays.length}');
          for(Blocksplays b in listBlocksplays){
            // batch.insert("Blocksplays", b.toJson());
            batch.rawInsert(
              "insert or replace into Blocksplays(id, idBanca, idLoteria, idSorteo, jugada, montoInicial, monto, fechaDesde, fechaHasta, created_at, ignorarDemasBloqueos, status, idMoneda, descontarDelBloqueoGeneral) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
                                                    [b.id, b.idBanca, b.idLoteria, b.idSorteo, b.jugada, b.montoInicial, b.monto, b.fechaDesde.toString(), b.fechaHasta.toString(), b.created_at.toString(), b.ignorarDemasBloqueos, b.status, b.idMoneda, b.descontarDelBloqueoGeneral]);
          }
        }

        if(parsed['blocksplaysgenerals'] != null){
          List<Blocksplaysgenerals> listBlocksplaysgenerals = parsed['blocksplaysgenerals'].map<Blocksplaysgenerals>((json) => Blocksplaysgenerals.fromMap(json)).toList();
          print('Realtime sincronizarTodosDataBatch length blocksplaysgenerals: ${listBlocksplaysgenerals.length}');
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
  }

  @override
  Future<Map<String, dynamic>> drawById(int id, [var sqfliteTransaction]) async {
    // TODO: implement drawById
    var db = sqfliteTransaction == null ? DBSqflite.database : sqfliteTransaction; 
    List<Map<String, Object>> data = await db.query("Draws", where: '"id" = ?', whereArgs: [id]);
    return data.isNotEmpty ? data.first : null;
    // return data.
  }

  @override
  Future<List> guardarVentaV2({Banca banca, List<Jugada> jugadas, socket, List<Loteria> listaLoteria, bool compartido, int descuentoMonto, currentTimeZone, bool tienePermisoJugarFueraDeHorario, bool tienePermisoJugarMinutosExtras, bool tienePermisoJugarSinDisponibilidad}) async {
    // TODO: implement guardarVentaV2
    // print("Realtime guardarventa before: ${Db.database.transaction}");
    Sale sale;
    List<Salesdetails> listSalesdetails = [];
    Usuario usuario;
    String codigoBarra = "${banca.id}${Utils.dateTimeToMilisenconds(DateTime.now())}";
    List<int> listaIdLoteria = [];
    List<int> listaIdLoteriaSuperPale = [];
    print("Realtime guardarVenta before date");
    // DateTime date = await NTP.now(timeout: Duration(seconds: 2));
    DateTime date = DateTime.now();
    await DBSqflite.database.transaction((tx) async {
    // Batch batch = tx.batch();
    usuario = Usuario.fromMap(await getUsuario(tx));
    // var ticketMap = await Db.getNextTicket(banca.id, await Db.servidor(tx), tx);
    Ticket ticket = Ticket();
    double total = 0;
    print("Realtime guardarVenta after ticket");

      
    print("Realtime guardarVenta banca.status = ${banca.status}");
    print("Realtime guardarVenta usuario = ${usuario}");
    if(!socket.connected)
      throw Exception("No esta conectado a internet.");
    print("Realtime guardarVenta after sockets");
    
    if(banca.status != 1)
      throw Exception("Esta banca esta desactivada");

    if(usuario.status != 1)
      throw Exception("Este usuario esta desactivado: ${usuario.status}");

    print("Realtime guardarVenta before permisos");

    if(await existePermisos(["Vender tickets", "Acceso al sistema"], tx) == false)
      throw Exception("No tiene permiso para realizar esta accion vender y acceso");
    print("Realtime guardarVenta after permisos");

    if(await idBanca(tx) != banca.id){
        if(await existePermiso("Jugar como cualquier banca", tx) == false)
          throw Exception("No tiene permiso para realizar para jugar como cualquier banca");
    }

    print("Realtime guardarVenta after bancas");


    // VALIDACION HORAR APERTURA Y CIERRE DE LA BANCA
    // DateTime hoyHoraAperturaBanca = banca.dias.firstWhere((element) => element.id == Utils.getIdDiaActual()).horaApertura;
    // DateTime hoyHoraCierreBanca = banca.dias.firstWhere((element) => element.id == Utils.getIdDiaActual()).horaCierre;
    // if(date.isBefore(hoyHoraAperturaBanca))
    //     throw Exception("La banca no ha abierto");
    // if(date.isAfter(hoyHoraCierreBanca))
    //     throw Exception("La banca ha cerrado: ${hoyHoraCierreBanca.toString()} | ${date.toString()}");

    total = jugadas.map((e) => e.monto).toList().reduce((value, element) => value + element);
    // VALIDACION LIMITE VENTA BANCA
    if((banca.ventasDelDia + total) > banca.limiteVenta)
        throw Exception("A excedido el limite de ventas de la banca: ${banca.limiteVenta}");

    // CREACION CODIGO BARRA
    codigoBarra = "${banca.id}${Utils.dateTimeToMilisenconds(DateTime.now())}";

    List<Jugada> listaLoteriasJugadas = Utils.removeDuplicateLoteriasFromList(List.from(jugadas)).cast<Jugada>().toList();
    List<Jugada> listaLoteriasSuperPaleJugadas = Utils.removeDuplicateLoteriasSuperPaleFromList(List.from(jugadas)).cast<Jugada>().toList();
    listaLoteriasJugadas.forEach((element) {print("Realtime guardar venta loteria: ${element.idLoteria}");});
    listaLoteriasSuperPaleJugadas.forEach((element) {print("Realtime guardar venta loteriaSuper: ${element.idLoteriaSuperpale}");});

    // VALIDACION LOTERIA PERTENECE A BANCA
    for (var jugada in listaLoteriasJugadas) {
      if(banca.loterias.indexWhere((element) => element.id == jugada.idLoteria) == -1)
        throw Exception("La loteria ${jugada.loteria.descripcion} no pertenece a esta banca");

      listaIdLoteria.add(jugada.idLoteria);

      // Loteria loteria = listaLoteria.firstWhere((element) => element.id == jugada.loteria.id, orElse: () => null);
      // if(loteria == null)
      //   throw Exception("La loteria ${jugada.loteria.descripcion} ha cerrado");

      // print("Realtime guardarVenta apertura: ${loteria.horaApertura} horaCierre: ${loteria.horaCierre}");
      // if(date.isBefore(Utils.horaLoteriaToCurrentTimeZone(loteria.horaApertura, date)))
      //   throw Exception("La loteria ${loteria.descripcion} no ha abierto");
      // if(date.isAfter(Utils.horaLoteriaToCurrentTimeZone(loteria.horaCierre, date))){
      //   if(!tienePermisoJugarFueraDeHorario){
      //     if(tienePermisoJugarMinutosExtras){
      //       var datePlusExtraMinutes = date.add(Duration(minutes: loteria.minutosExtras));
      //       if(date.isAfter(datePlusExtraMinutes))
      //         throw Exception("La loteria ${loteria.descripcion} ha cerrado");
      //     }
      //     else
      //       throw Exception("La loteria ${loteria.descripcion} ha cerrado");
      //   }
      // }
    }
    

    // VALIDACION LOTERIA SUPERPALE PERTENECE A BANCA
    for (var jugada in listaLoteriasSuperPaleJugadas) {
      print("Realtime guardarVenta validacion superpale: ${jugada.idLoteriaSuperpale} null: ${jugada.loteriaSuperPale == null}");
      if(banca.loterias.indexWhere((element) => element.id == jugada.idLoteriaSuperpale) == -1)
        throw Exception("La loteria ${jugada.loteriaSuperPale.descripcion} no pertenece a esta banca");

      listaIdLoteriaSuperPale.add(jugada.idLoteriaSuperpale);
      
      // Loteria loteriaSuperPale = listaLoteria.firstWhere((element) => element.id == jugada.loteriaSuperPale.id, orElse: () => null);
      // if(loteriaSuperPale == null)
      //   throw Exception("La loteria ${jugada.loteriaSuperPale.descripcion} ha cerrado");

      // if(date.isBefore(Utils.horaLoteriaToCurrentTimeZone(loteriaSuperPale.horaApertura, date)))
      //   throw Exception("La loteria ${loteriaSuperPale.descripcion} aun no ha abierto");
      // if(date.isAfter(Utils.horaLoteriaToCurrentTimeZone(loteriaSuperPale.horaCierre, date))){
      //   if(!tienePermisoJugarFueraDeHorario){
      //     if(tienePermisoJugarMinutosExtras){
      //       var datePlusExtraMinutes = date.add(Duration(minutes: loteriaSuperPale.minutosExtras));
      //       if(date.isAfter(datePlusExtraMinutes))
      //         throw Exception("La loteria ${loteriaSuperPale.descripcion} ha cerrado");
      //     }
      //     else
      //       throw Exception("La loteria ${loteriaSuperPale.descripcion} ha cerrado");
      //   }
      // }
      
      
    }

    /**************** AHORA DEBO INVESTIGAR COMO OBTENER EL NUMERO DE TICKET, ESTOY INVESTIGANDO LARAVEL CACHE A VER COMO SE COMUNICA CON REDIS */


    // print("Realtime guardarVenta before insert sales idTicket: ${ticket.id.toInt()}");
    // await Db.insert('Sales', Sale(compartido: compartido ? 1 : 0, servidor: await Db.servidor(tx), idUsuario: usuario.id, idBanca: banca.id, total: total, subTotal: 0, descuentoMonto: descuentoMonto, hayDescuento: descuentoMonto > 0 ? 1 : 0, idTicket: ticket.id, created_at: date).toJson(), tx);
    // var saleMap = await Db.queryBy("Sales", "idTicket", ticket.id.toInt(), tx);
    // print("Realtime guardarVenta after insert sales saleMap: ${saleMap}");
    sale = Sale(compartido: compartido ? 1 : 0, servidor: await servidor(tx), idUsuario: usuario.id, idBanca: banca.id, total: total, subTotal: 0, descuentoMonto: descuentoMonto, hayDescuento: descuentoMonto > 0 ? 1 : 0, idTicket: ticket.id, created_at: date);
    if(sale == null)
      throw Exception("Hubo un error al realizar la venta, la venta es nula");

    sale.ticket = ticket;
    sale.banca = banca;
    sale.usuario = usuario;

    for (Jugada jugada in jugadas) {      
      // await Future(() async {
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

        if(jugada.stockEliminado){
          print("Realtime guardarVenta validarMonto con getMontoDisponible");
          // if(jugada.monto > (await getMontoDisponible(jugada.jugada, jugada.loteria, banca, loteriaSuperpale: jugada.loteriaSuperPale, sqfliteTransaction: tx)).monto){
          if(jugada.monto > (await MontoDisponibleMovilService.obtener(jugada.jugada, jugada.loteria, banca, jugada.loteriaSuperPale, sqfliteTransaction: tx)).monto){
            throw Exception("No hay monto disponible para la jugada ${jugada.jugada} en la loteria ${jugada.loteria.descripcion}");
          }
        }else{
          print("Realtime guardarVenta validarMonto normal");
          if(jugada.monto > jugada.stock.monto){
            throw Exception("No hay monto disponible para la jugada ${jugada.jugada} en la loteria ${jugada.loteria.descripcion}");
          }
        }
        
        var salesdetails = Salesdetails(idVenta: sale.id, idTicket: sale.ticket.id, idLoteria: loteria.id, idSorteo: jugada.idSorteo, sorteoDescripcion: jugada.sorteo, jugada: jugada.jugada, monto: jugada.monto, premio: jugada.premio, comision: 0, idStock: 0, idLoteriaSuperpale: loteriaSuperPale != null ? loteriaSuperPale.id : null, created_at: date, updated_at: date, status: 0, loteria: loteria, loteriaSuperPale: loteriaSuperPale, sorteo: Draws(jugada.idSorteo, jugada.sorteo, null, null, null, null));
        // await Db.insert('Salesdetails', salesdetails.toJson(), tx);
        listSalesdetails.add(salesdetails);
        print("Realtime guardarVenta for jugadas: ${listSalesdetails.length}");
      // });
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

    // ticket.usado = 1;
    // await Db.update("Tickets", ticket.toJson(), ticket.id.toInt(), tx);
    // var ticketParaVerificarCampoUsado = await Db.queryBy("Tickets", "id", ticket.id.toInt(), tx);
    // print("Realtime guardarVenta ticket: ${ticket.toJson()}");
    // print("Realtime guardarVenta ticketMap: ${ticketParaVerificarCampoUsado}");

    if(!socket.connected)
      throw Exception("No esta conectado a internet.");

    // socket.emit("ticket", await Utils.createJwt({"servidor" : await Db.servidor(tx), "idBanca" : banca.id, "uuid" : await CrossDeviceInfo.getUIID(), "createNew" : true}));
    // socket.emit("guardarVenta", await Utils.createJwt({"servidor" : await Db.servidor(tx), "usuario" : usuario.toJson(), "sale" : sale.toJson(), "salesdetails" : Salesdetails.salesdetailsToJson(listSalesdetails)}));

    // batch.commit(noResult: false, continueOnError: false);
    // tx.commit();
  });
    print("Realtime guardarventa after transaction: ${sale.banca != null ? sale.banca.toJson() : null}");
    // socket.emit("ticket", await Utils.createJwt({"servidor" : await Db.servidor(), "idBanca" : banca.id, "uuid" : await CrossDeviceInfo.getUIID(), "createNew" : true}));
    // socket.emit("guardarVenta", await Utils.createJwt({"servidor" : await Db.servidor(), "usuario" : usuario.toJson(), "sale" : sale.toJsonFull(), "salesdetails" : Salesdetails.salesdetailsToJson(listSalesdetails)}));
    // socket.emit("guardarVenta", await Utils.createJwt({"servidor" : await Db.servidor(), "usuario" : usuario.toJson(), "sale" : sale.toJsonFull(), "salesdetails" : Salesdetails.salesdetailsToJson(listSalesdetails)}));
    return [sale, listSalesdetails, usuario, codigoBarra, listaIdLoteria, listaIdLoteriaSuperPale];
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> obtenerMontoDeTablaStock({@required int idLoteria, @required int idSorteo, @required String jugada, @required int idMoneda, int esGeneral = 0, int ignorarDemasBloqueos, int idLoteriaSuperpale, int idBanca, sqfliteTransaction}) async {
    var db = obtenerBaseDeDatos(sqfliteTransaction);
    String queryIdBancaYIdLoteriaSuperpale = concatenarIdBancaIdLoteriaSuperpaleEIgnorarDemasBloqueosSiNoSonNulosAlQuery(idBanca, idLoteriaSuperpale, ignorarDemasBloqueos);
    return await db.query('Stocks' , 
      where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "idMoneda" = ?' + queryIdBancaYIdLoteriaSuperpale, 
      whereArgs: [idLoteria, idSorteo, jugada, esGeneral, idMoneda]
    );
  }

  concatenarIdBancaIdLoteriaSuperpaleEIgnorarDemasBloqueosSiNoSonNulosAlQuery(int idBanca, int idLoteriaSuperpale, int ignorarDemasBloqueos){
    String query = '';
    query += concatenarIdBancaAlQuery(idBanca);
    query += concatenarIdLoteriaSuperpaleAlQuery(idLoteriaSuperpale);
    query += concatenarIgnorarDemasBloqueosAlQuery(ignorarDemasBloqueos);
    return query;
  }

  String concatenarIdBancaAlQuery(int idBanca){
    return idBanca != null ? ' and "idBanca" = $idBanca' : '';
  }

  String concatenarIdLoteriaSuperpaleAlQuery(int idLoteriaSuperpale){
    return idLoteriaSuperpale != null ? ' and "idLoteriaSuperpale" = $idLoteriaSuperpale' : '';
  }

  String concatenarIgnorarDemasBloqueosAlQuery(int ignorarDemasBloqueos){
    return ignorarDemasBloqueos != null ? ' and "ignorarDemasBloqueos" = $ignorarDemasBloqueos' : '';
  }

  @override
  Future<List<Map<String, dynamic>>> obtenerMontoDeTablaBlocksplaysgenerals({@required int idLoteria, @required int idSorteo, @required String jugada, @required int idMoneda, sqfliteTransaction}) async {
    var db = obtenerBaseDeDatos(sqfliteTransaction);
    return await db.query('Blocksplaysgenerals' ,
      // where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" like ? and "status" = 1 and "idMoneda" = ?', 
      // whereArgs: [idLoteria, idSorteo, '%$jugada%', idMoneda], 
      where: "idLoteria = ? and idSorteo = ? and ${Utils.generarQueryJugada(jugada, idSorteo)} and status = 1 and idMoneda = ?", 
      whereArgs: [idLoteria, idSorteo, idMoneda], 
      orderBy: '"id" desc' 
    );
  }

   String generarQueryJugada(String jugada, int idSorteo){
    if(Draws.esIdPaleTripletaOSuperpale(idSorteo))
      return generarQueryJugadaPaleTripletaOSuperpale(jugada, idSorteo);
    else
      return "jugada like '%${concatenarComasAlInicioYFin(jugada)}%'";
  }

  String generarQueryJugadaPaleTripletaOSuperpale(String jugada, int idSorteo){
    if(Draws.esIdPaleOSuperpale(idSorteo))
      return generarQueryPaleOSuperpale(jugada);
    else
      return generarQueryTripleta(jugada);
  }

  String generarQueryPaleOSuperpale(String jugada){
    String primerParDeNumeros = Utils.getPrimerParDeNumeros(jugada);
    String segundoParDeNumeros = Utils.getSegundoParDeNumeros(jugada);
    return "(jugada like '%${concatenarComasAlInicioYFin(jugada)}%' or jugada like '%${concatenarComasAlInicioYFin(primerParDeNumeros)}%' or jugada like '%${concatenarComasAlInicioYFin(segundoParDeNumeros)}%')";
  }

  String generarQueryTripleta(String jugada){
    String primerParDeNumeros = Utils.getPrimerParDeNumeros(jugada);
    String segundoParDeNumeros = Utils.getSegundoParDeNumeros(jugada);
    String tercerParDeNumeros = Utils.getTercerParDeNumeros(jugada);
    return "(jugada like '%${concatenarComasAlInicioYFin(jugada)}%' or jugada like '%${concatenarComasAlInicioYFin(primerParDeNumeros)}%' or jugada like '%${concatenarComasAlInicioYFin(segundoParDeNumeros)}%' or jugada like '%${concatenarComasAlInicioYFin(tercerParDeNumeros)}%')";
  }

  String concatenarComasAlInicioYFin(String jugada){
    return ",${jugada},";
  }


  @override
  Future<List<Map<String, dynamic>>> obtenerMontoDeTablaGenerals({@required int idLoteria, @required int idSorteo, @required int idDia, @required int idMoneda, int idLoteriaSuperpale, sqfliteTransaction}) async {
    var db = obtenerBaseDeDatos(sqfliteTransaction);
    String queryIdLoteriaSuperpale = concatenarIdLoteriaSuperpaleOIdLoteriaSuperpaleNuloAlQuery(idLoteriaSuperpale);
    return await db.query('Blocksgenerals' , 
      where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?' + queryIdLoteriaSuperpale, 
      whereArgs: [idLoteria, idSorteo, idDia, idMoneda], 
      orderBy: ordernarPorIdLoteriaSuperpaleNulo()
    );
  }

  @override
  Future<List<Map<String, dynamic>>> obtenerMontoDeTablaBlocksplays({@required int idBanca, @required int idLoteria, @required int idSorteo, @required String jugada, @required int idMoneda, sqfliteTransaction}) async {
    var db = obtenerBaseDeDatos(sqfliteTransaction);
    return await db.query('Blocksplays' ,
      // where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', 
      // whereArgs: [idBanca, idLoteria, idSorteo, jugada, idMoneda], 
      where: "idBanca = ? and idLoteria = ? and idSorteo = ? and ${Utils.generarQueryJugada(jugada, idSorteo)} and status = 1 and idMoneda = ?", 
      whereArgs: [idBanca, idLoteria, idSorteo, idMoneda], 
      orderBy: '"id" desc' 
    );
  }

  @override
  Future<List<Map<String, dynamic>>> obtenerMontoDeTablaBlockslotteries({@required int idBanca, @required int idLoteria, @required int idSorteo, @required int idDia, @required int idMoneda, int idLoteriaSuperpale, sqfliteTransaction}) async {
    var db = obtenerBaseDeDatos(sqfliteTransaction);
    return await db.query('Blockslotteries' ,
      where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?' + concatenarIdLoteriaSuperpaleOIdLoteriaSuperpaleNuloAlQuery(idLoteriaSuperpale), 
      whereArgs: [idBanca, idLoteria, idSorteo, idDia, idMoneda], 
      orderBy: ordernarPorIdLoteriaSuperpaleNulo()
    );
  }

  String concatenarIdLoteriaSuperpaleOIdLoteriaSuperpaleNuloAlQuery(int idLoteriaSuperpale){
    return idLoteriaSuperpale != null ? ' and ("idLoteriaSuperpale" = ${idLoteriaSuperpale} OR "idLoteriaSuperpale" is NULL)' : '';
  }

  String ordernarPorIdLoteriaSuperpaleNulo(){
    return '"idLoteriaSuperpale" is NULL';
  }

  obtenerBaseDeDatos([sqfliteTransaction]){
    return sqfliteTransaction == null ? DBSqflite.database : sqfliteTransaction;
  }

  @override
  Future<MontoDisponible> getMontoDisponible(String jugada, Loteria loteria, Banca banca, {Loteria loteriaSuperpale, bool retornarStock = false, var sqfliteTransaction}) async {
    // TODO: implement getMontoDisponible
    var db = sqfliteTransaction == null ? DBSqflite.database : sqfliteTransaction;
    var montoDisponible;

    
    int idDia = Utils.getIdDia();
    int idSorteo = await SorteoService.getIdSorteo(jugada, loteria, sqfliteTransaction);
    String jugadaConSigno = jugada;
    jugada = await SorteoService.esSorteoPickQuitarUltimoCaracter(jugada, idSorteo, sqfliteTransaction);
    print("PrincipalView getMontoDisponible banca moneda: ${banca.descripcion}");
    Stock stockToReturn;
    String querySuperPale = '';
    String querySuperPaleBlocksgeneralsBlockslotteries = '';
    String orderBySuperpaleTablasBlocksgeneralsBlockslotteries;

    if(idSorteo == 4){
      if(loteria.id > loteriaSuperpale.id){
        Loteria tmp = loteriaSuperpale;
        loteriaSuperpale = loteria;
        loteria = tmp;
      }

        querySuperPale += ' and "idLoteriaSuperpale" = ${loteriaSuperpale.id}';
        querySuperPaleBlocksgeneralsBlockslotteries += ' and ("idLoteriaSuperpale" = ${loteriaSuperpale.id} OR "idLoteriaSuperpale" is NULL)';
        orderBySuperpaleTablasBlocksgeneralsBlockslotteries = '"idLoteriaSuperpale" is NULL';
    }

    List<Map<String, dynamic>> query = await db.query('Stocks' , where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "idMoneda" = ?' + querySuperPale, whereArgs: [banca.id, loteria.id, idSorteo, jugada, 0, banca.idMoneda]);

    if(query.isEmpty != true){
      montoDisponible = query.first['monto'];
      stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: query.first['esBloqueoJugada']);
    }

    if(montoDisponible != null){
      List dataStocks = await db.query('Stocks' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "idMoneda" = ?' + querySuperPale, whereArgs: [loteria.id, idSorteo, jugada, 1, banca.idMoneda]);
      if(dataStocks.indexWhere((element) => element["ignorarDemasBloqueos"] == 1) != -1){
        query = [dataStocks[dataStocks.indexWhere((element) => element["ignorarDemasBloqueos"] == 1)]];
        montoDisponible = query.first['monto'];
        stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: query.first['esBloqueoJugada']);
      }else{

        //Ahora nos aseguramos de que el bloqueo general existe y el valor de ignorarDemasBloqueos sea = 1
        List dataBlocksplaysgenerals = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            print("mobile_db getMontoDisponible: ${dataBlocksplaysgenerals}");
        if(dataBlocksplaysgenerals.indexWhere((element) => element["ignorarDemasBloqueos"] == 1) != -1){
          query = [dataBlocksplaysgenerals[dataBlocksplaysgenerals.indexWhere((element) => element["ignorarDemasBloqueos"] == 1)]];
          var first = query.first;
          montoDisponible = first["monto"];
          stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
        }else{
            print("mobile_db getMontoDisponible: ${stockToReturn.descontarDelBloqueoGeneral}");
          if(stockToReturn.descontarDelBloqueoGeneral == 1){
            //Verificamos si datos general de la tabla STOCKS
            if(dataStocks.isNotEmpty){
              //Si el bloqueo general STOCKS < bloqueoBanca pues retornamos el bloqueo STOCK, de lo contrario se retornara el bloqueo banca
            print("mobile_db getMontoDisponible dataStocks.isNotEmpty: $dataStocks");
              if(dataStocks.first["monto"] < montoDisponible){
                montoDisponible = Utils.toDouble(dataStocks.first["monto"]);
                stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: dataStocks.first["esBloqueoJugada"]);
              }
            }
            else if(dataBlocksplaysgenerals.isNotEmpty){
              //Si el bloqueo general Blocksplaysgenerals < bloqueoBanca pues retornamos el bloqueo STOCK, de lo contrario se retornara el bloqueo banca
              if(dataBlocksplaysgenerals.first["monto"] < montoDisponible){
                montoDisponible = Utils.toDouble(dataBlocksplaysgenerals.first["monto"]);
                stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
              }
            }else{
              List dataBlocksgenerals = await db.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?' + querySuperPaleBlocksgeneralsBlockslotteries, whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda], orderBy: orderBySuperpaleTablasBlocksgeneralsBlockslotteries);
              if(dataBlocksgenerals.isNotEmpty){
                if(dataBlocksgenerals.first["monto"] < montoDisponible){
              print("mobile_db getMontoDisponible else: $dataBlocksgenerals");
                  montoDisponible = Utils.toDouble(dataBlocksgenerals.first["monto"]);
                  stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 0);
                }
              }
            }
          }
        }
      }
    }


    //AQUI ES CUANDO EXISTE BLOQUEO GENERAL EN STOCKS
    if(montoDisponible == null){
        query = await db.query('Stocks' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = 1 and "idMoneda" = ?' + querySuperPale, whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda]);
      if(query.isEmpty != true){
        //SI IGNORARDEMASBLOQUEOS ES FALSE ENTONCES VAMOS A VERIFICAR SI EXISTEN BLOQUEOS POR BANCAS YA SEAN DE JUGADAS PARA RETORNAR ESTOS BLOQUEOS
        var stock = query.first;
        if(stock["ignorarDemasBloqueos"] == 0){
          query = await db.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          if(query.isEmpty != true){
            montoDisponible = query.first["monto"];
            stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);
            if(query.first['descontarDelBloqueoGeneral'] == 1){
              //Si el monto del stockGeneral < monto blocksplays entonces vamos a retornar el stockGeneral
              if(stock['monto'] < query.first['monto']){
                montoDisponible = stock["monto"];
                stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
              }
            }

          }else{
            query = await db.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?' + querySuperPaleBlocksgeneralsBlockslotteries, whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda], orderBy: orderBySuperpaleTablasBlocksgeneralsBlockslotteries);
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
              stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'],);

              if(query.first['descontarDelBloqueoGeneral'] == 1){
                if(stock['monto'] < query.first['monto']){
                  montoDisponible = stock["monto"];
                  stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
                }
              }

            }
            else{
              montoDisponible = stock["monto"];
              stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
            }
          }
        }else{
          montoDisponible = stock["monto"];
          stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
        }
      }
    }



    if(montoDisponible == null){
      query = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
      if(query.isEmpty != true){
        var blocksplaysgenerals = query.first;
        if(blocksplaysgenerals["ignorarDemasBloqueos"] == 0){
          montoDisponible = null;
        }else{
          montoDisponible = blocksplaysgenerals["monto"];
          stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
        }
      }

// query = await Db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ?', whereArgs: [1], orderBy: '"id" desc' );
      // print("Monto disponible blocksplaysgenrals: $query");

      if(montoDisponible == null){
        query = await db.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
        if(query.isEmpty != true){
          montoDisponible = query.first["monto"];
          stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);

          if(query.first['descontarDelBloqueoGeneral'] == 1){
            List dataBlocksplaysgenerals = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            if(dataBlocksplaysgenerals.isNotEmpty){
              //Si el bloqueo general Blocksplaysgenerals < bloqueoBanca pues retornamos el bloqueo STOCK, de lo contrario se retornara el bloqueo banca
              if(dataBlocksplaysgenerals.first["monto"] < montoDisponible){
                montoDisponible = dataBlocksplaysgenerals.first["monto"];
                stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
              }
            }else{
              List dataBlocksgenerals = await db.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?' + querySuperPaleBlocksgeneralsBlockslotteries, whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda], orderBy: orderBySuperpaleTablasBlocksgeneralsBlockslotteries);
              if(dataBlocksgenerals.isNotEmpty){
                if(dataBlocksgenerals.first["monto"] < montoDisponible){
                  montoDisponible = dataBlocksgenerals.first["monto"];
                  stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
                }
              }
            }
          }

        }else{
          query = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          if(query.isEmpty != true){
            montoDisponible = query.first["monto"];
            stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
          }
        }

        if(montoDisponible == null){
          query = await db.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?' + querySuperPaleBlocksgeneralsBlockslotteries, whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda], orderBy: orderBySuperpaleTablasBlocksgeneralsBlockslotteries);
          if(query.isEmpty != true){
            montoDisponible = query.first["monto"];
            stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral']);

            if(query.first['descontarDelBloqueoGeneral'] == 1){
              List dataBlocksplaysgenerals = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
              if(dataBlocksplaysgenerals.isNotEmpty){
                //Si el bloqueo general Blocksplaysgenerals < bloqueoBanca pues retornamos el bloqueo STOCK, de lo contrario se retornara el bloqueo banca
                if(dataBlocksplaysgenerals.first["monto"] < montoDisponible){
                  montoDisponible = dataBlocksplaysgenerals.first["monto"];
                  stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
                }
              }else{
                List dataBlocksgenerals = await db.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?' + querySuperPaleBlocksgeneralsBlockslotteries, whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda], orderBy: orderBySuperpaleTablasBlocksgeneralsBlockslotteries);
                if(dataBlocksgenerals.isNotEmpty){
                  if(dataBlocksgenerals.first["monto"] < montoDisponible){
                    montoDisponible = dataBlocksgenerals.first["monto"];
                    stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
                  }
                }
              }
            }

          }
        }

        if(montoDisponible == null){
          query = await db.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?' + querySuperPaleBlocksgeneralsBlockslotteries, whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda], orderBy: orderBySuperpaleTablasBlocksgeneralsBlockslotteries);
                // print("Mobile_db getMontoDisponible dataBlocksgenerals query: $querySuperPaleBlocksgeneralsBlockslotteries");
                // print("Mobile_db getMontoDisponible dataBlocksgenerals orderBy: $orderBySuperpaleTablasBlocksgeneralsBlockslotteries");
                print("Mobile_db getMontoDisponible dataBlocksgenerals: ${query.length} $query");
          if(query.isEmpty != true){
            montoDisponible = query.first["monto"];
            stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda);
          }
        }

        // print('montoDisponiblePrueba idSorteo: lot: $loteria.id sor: $idSorteo dia: $idDia res:${blocksgenerals.indexWhere((b) => b.idLoteria == loteria.id && b.idDia == idDia && b.idSorteo == idSorteo)} prueba:${Blocksgenerals.blocksgeneralsToJson(blocksgenerals.where((b) => b.idLoteria == loteria.id && b.idSorteo == idSorteo).toList())}');
      }
    }



    double montoDisponibleFinal = Utils.toDouble(montoDisponible.toString());

    if(stockToReturn != null) {
      stockToReturn.monto = montoDisponibleFinal;
      if(idSorteo == 4)
        stockToReturn.idLoteriaSuperpale = loteriaSuperpale.id;
    } else
      stockToReturn = Stock(monto: montoDisponibleFinal);

    print("principalView getMontoDisponible: ${stockToReturn.toJson()}");
    return MontoDisponible(monto: montoDisponibleFinal, stock: stockToReturn);
   
  }

  Future<MontoDisponible> getMontoDisponibleViejo_descontarDelBloqueoGeneral_falto_superPale(String jugada, Loteria loteria, Banca banca, {Loteria loteriaSuperpale, bool retornarStock = false, var sqfliteTransaction}) async {
    // TODO: implement getMontoDisponible
    var db = sqfliteTransaction == null ? DBSqflite.database : sqfliteTransaction;
    var montoDisponible;


    int idDia = Utils.getIdDia();
    int idSorteo = await SorteoService.getIdSorteo(jugada, loteria, sqfliteTransaction);
    String jugadaConSigno = jugada;
    jugada = await SorteoService.esSorteoPickQuitarUltimoCaracter(jugada, idSorteo, sqfliteTransaction);
    print("PrincipalView getMontoDisponible banca moneda: ${banca.descripcion}");
    Stock stockToReturn;

    if(idSorteo != 4){
      List<Map<String, dynamic>> query = await db.query('Stocks' , where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, 0, banca.idMoneda]);

      if(query.isEmpty != true){
        montoDisponible = query.first['monto'];
        stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: query.first['esBloqueoJugada']);
      }

      if(montoDisponible != null){
        List dataStocks = await db.query('Stocks' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, 1, banca.idMoneda]);
        if(dataStocks.indexWhere((element) => element["ignorarDemasBloqueos"] == 1) != -1){
          query = [dataStocks[dataStocks.indexWhere((element) => element["ignorarDemasBloqueos"] == 1)]];
          montoDisponible = query.first['monto'];
          stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: query.first['esBloqueoJugada']);
        }else{

          //Ahora nos aseguramos de que el bloqueo general existe y el valor de ignorarDemasBloqueos sea = 1
          List dataBlocksplaysgenerals = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          print("mobile_db getMontoDisponible: ${dataBlocksplaysgenerals}");
          if(dataBlocksplaysgenerals.indexWhere((element) => element["ignorarDemasBloqueos"] == 1) != -1){
            query = [dataBlocksplaysgenerals[dataBlocksplaysgenerals.indexWhere((element) => element["ignorarDemasBloqueos"] == 1)]];
            var first = query.first;
            montoDisponible = first["monto"];
            stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
          }else{
            print("mobile_db getMontoDisponible: ${stockToReturn.descontarDelBloqueoGeneral}");
            if(stockToReturn.descontarDelBloqueoGeneral == 1){
              //Verificamos si datos general de la tabla STOCKS
              if(dataStocks.isNotEmpty){
                //Si el bloqueo general STOCKS < bloqueoBanca pues retornamos el bloqueo STOCK, de lo contrario se retornara el bloqueo banca
                print("mobile_db getMontoDisponible dataStocks.isNotEmpty: $dataStocks");
                if(dataStocks.first["monto"] < montoDisponible){
                  montoDisponible = Utils.toDouble(dataStocks.first["monto"]);
                  stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: dataStocks.first["esBloqueoJugada"]);
                }
              }
              else if(dataBlocksplaysgenerals.isNotEmpty){
                //Si el bloqueo general Blocksplaysgenerals < bloqueoBanca pues retornamos el bloqueo STOCK, de lo contrario se retornara el bloqueo banca
                if(dataBlocksplaysgenerals.first["monto"] < montoDisponible){
                  montoDisponible = Utils.toDouble(dataBlocksplaysgenerals.first["monto"]);
                  stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
                }
              }else{
                List dataBlocksgenerals = await db.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda]);
                if(dataBlocksgenerals.isNotEmpty){
                  if(dataBlocksgenerals.first["monto"] < montoDisponible){
                    print("mobile_db getMontoDisponible else: $dataBlocksgenerals");
                    montoDisponible = Utils.toDouble(dataBlocksgenerals.first["monto"]);
                    stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 0);
                  }
                }
              }
            }
          }
        }
      }


      //AQUI ES CUANDO EXISTE BLOQUEO GENERAL EN STOCKS
      if(montoDisponible == null){
        query = await db.query('Stocks' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda]);
        if(query.isEmpty != true){
          //SI IGNORARDEMASBLOQUEOS ES FALSE ENTONCES VAMOS A VERIFICAR SI EXISTEN BLOQUEOS POR BANCAS YA SEAN DE JUGADAS PARA RETORNAR ESTOS BLOQUEOS
          var stock = query.first;
          if(stock["ignorarDemasBloqueos"] == 0){
            query = await db.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
              stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);
              if(query.first['descontarDelBloqueoGeneral'] == 1){
                //Si el monto del stockGeneral < monto blocksplays entonces vamos a retornar el stockGeneral
                if(stock['monto'] < query.first['monto']){
                  montoDisponible = stock["monto"];
                  stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
                }
              }

            }else{
              query = await db.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
              if(query.isEmpty != true){
                montoDisponible = query.first["monto"];
                stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'],);

                if(query.first['descontarDelBloqueoGeneral'] == 1){
                  if(stock['monto'] < query.first['monto']){
                    montoDisponible = stock["monto"];
                    stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
                  }
                }

              }
              else{
                montoDisponible = stock["monto"];
                stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
              }
            }
          }else{
            montoDisponible = stock["monto"];
            stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
          }
        }
      }



      if(montoDisponible == null){
        query = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
        if(query.isEmpty != true){
          var blocksplaysgenerals = query.first;
          if(blocksplaysgenerals["ignorarDemasBloqueos"] == 0){
            montoDisponible = null;
          }else{
            montoDisponible = blocksplaysgenerals["monto"];
            stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
          }
        }

// query = await Db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ?', whereArgs: [1], orderBy: '"id" desc' );
        // print("Monto disponible blocksplaysgenrals: $query");

        if(montoDisponible == null){
          query = await db.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          if(query.isEmpty != true){
            montoDisponible = query.first["monto"];
            stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);

            if(query.first['descontarDelBloqueoGeneral'] == 1){
              List dataBlocksplaysgenerals = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
              if(dataBlocksplaysgenerals.isNotEmpty){
                //Si el bloqueo general Blocksplaysgenerals < bloqueoBanca pues retornamos el bloqueo STOCK, de lo contrario se retornara el bloqueo banca
                if(dataBlocksplaysgenerals.first["monto"] < montoDisponible){
                  montoDisponible = dataBlocksplaysgenerals.first["monto"];
                  stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
                }
              }else{
                List dataBlocksgenerals = await db.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda]);
                if(dataBlocksgenerals.isNotEmpty){
                  if(dataBlocksgenerals.first["monto"] < montoDisponible){
                    montoDisponible = dataBlocksgenerals.first["monto"];
                    stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
                  }
                }
              }
            }

          }else{
            query = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
              stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
            }
          }

          if(montoDisponible == null){
            query = await db.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
              stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral']);

              if(query.first['descontarDelBloqueoGeneral'] == 1){
                List dataBlocksplaysgenerals = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
                if(dataBlocksplaysgenerals.isNotEmpty){
                  //Si el bloqueo general Blocksplaysgenerals < bloqueoBanca pues retornamos el bloqueo STOCK, de lo contrario se retornara el bloqueo banca
                  if(dataBlocksplaysgenerals.first["monto"] < montoDisponible){
                    montoDisponible = dataBlocksplaysgenerals.first["monto"];
                    stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
                  }
                }else{
                  List dataBlocksgenerals = await db.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda]);
                  if(dataBlocksgenerals.isNotEmpty){
                    if(dataBlocksgenerals.first["monto"] < montoDisponible){
                      montoDisponible = dataBlocksgenerals.first["monto"];
                      stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
                    }
                  }
                }
              }

            }
          }

          if(montoDisponible == null){
            query = await db.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda]);
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
              stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda);
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
      List<Map<String, dynamic>> query = await db.query('Stocks' , where: '"idBanca" = ? and "idLoteria" = ? and "idLoteriaSuperpale" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, loteriaSuperpale.id, idSorteo, jugada, 0, banca.idMoneda]);

      print("getMontoDisponible super pale: $query");

      if(query.isEmpty != true){
        montoDisponible = query.first['monto'];
        stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: query.first['esBloqueoJugada']);
      }


      if(montoDisponible != null){
        // query = await db.query('Stocks' ,where: '"idLoteria" = ? and "idLoteriaSuperpale" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "ignorarDemasBloqueos" = ? and "idMoneda" = ?', whereArgs: [loteria.id, loteriaSuperpale.id, idSorteo, jugada, 1, 1, banca.idMoneda]);
        List dataStocks = await db.query('Stocks' ,where: '"idLoteria" = ? and "idLoteriaSuperpale" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "idMoneda" = ?', whereArgs: [loteria.id, loteriaSuperpale.id, idSorteo, jugada, 1, banca.idMoneda]);
        // if(query.isEmpty != true){
        if(dataStocks.indexWhere((element) => element["ignorarDemasBloqueos"] == 1) != -1){
          query = [dataStocks[dataStocks.indexWhere((element) => element["ignorarDemasBloqueos"] == 1)]];
          montoDisponible = query.first['monto'];
          stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: query.first['esBloqueoJugada']);
        }else{

          //Ahora nos aseguramos de que el bloqueo general existe y el valor de ignorarDemasBloqueos sea = 1
          // query = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          // if(query.isEmpty != true){
          List dataBlocksplaysgenerals = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          print("mobile_db getMontoDisponible: ${dataBlocksplaysgenerals}");
          if(dataBlocksplaysgenerals.indexWhere((element) => element["ignorarDemasBloqueos"] == 1) != -1){
            query = [dataBlocksplaysgenerals[dataBlocksplaysgenerals.indexWhere((element) => element["ignorarDemasBloqueos"] == 1)]];
            var first = query.first;
            if(first["ignorarDemasBloqueos"] == 1){
              montoDisponible = first["monto"];
              stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
            }
          }else{
            if(stockToReturn.descontarDelBloqueoGeneral == 1){
              //Verificamos si datos general de la tabla STOCKS
              if(dataStocks.isNotEmpty){
                //Si el bloqueo general STOCKS < bloqueoBanca pues retornamos el bloqueo STOCK, de lo contrario se retornara el bloqueo banca
                print("mobile_db getMontoDisponible dataStocks.isNotEmpty: $dataStocks");
                if(dataStocks.first["monto"] < montoDisponible){
                  montoDisponible = Utils.toDouble(dataStocks.first["monto"]);
                  stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: dataStocks.first["esBloqueoJugada"]);
                }
              }
              else if(dataBlocksplaysgenerals.isNotEmpty){
                //Si el bloqueo general Blocksplaysgenerals < bloqueoBanca pues retornamos el bloqueo STOCK, de lo contrario se retornara el bloqueo banca
                if(dataBlocksplaysgenerals.first["monto"] < montoDisponible){
                  montoDisponible = Utils.toDouble(dataBlocksplaysgenerals.first["monto"]);
                  stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
                }
              }else{
                List dataBlocksgenerals = await db.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda]);
                if(dataBlocksgenerals.isNotEmpty){
                  if(dataBlocksgenerals.first["monto"] < montoDisponible){
                    print("mobile_db getMontoDisponible else: $dataBlocksgenerals");
                    montoDisponible = Utils.toDouble(dataBlocksgenerals.first["monto"]);
                    stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 0);
                  }
                }
              }
            }
          }
        }
      }


      //AQUI ES CUANDO EXISTE BLOQUEO GENERAL EN STOCKS
      if(montoDisponible == null){
        query = await db.query('Stocks' ,where: '"idLoteria" = ? and "idLoteriaSuperpale" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, loteriaSuperpale.id, idSorteo, jugada, banca.idMoneda]);
        if(query.isEmpty != true){
          //SI IGNORARDEMASBLOQUEOS ES FALSE ENTONCES VAMOS A VERIFICAR SI EXISTEN BLOQUEOS POR BANCAS YA SEAN DE JUGADAS PARA RETORNAR ESTOS BLOQUEOS
          var stock = query.first;
          if(stock["ignorarDemasBloqueos"] == 0){
            query = await db.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
              stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);
            }else{
              query = await db.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
              if(query.isEmpty != true){
                montoDisponible = query.first["monto"];
                stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral']);
              }
              else{
                montoDisponible = stock["monto"];
                stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
              }
            }
          }else{
            montoDisponible = stock["monto"];
            stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
          }
        }
      }



      if(montoDisponible == null){
        query = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
        if(query.isEmpty != true){
          var blocksplaysgenerals = query.first;
          if(blocksplaysgenerals["ignorarDemasBloqueos"] == 0){
            montoDisponible = null;
          }else{
            montoDisponible = blocksplaysgenerals["monto"];
            stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
          }
        }

        if(montoDisponible == null){
          query = await db.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          if(query.isEmpty != true){
            montoDisponible = query.first["monto"];
            stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);
          }else{
            query = await db.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
              stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
            }
          }

          if(montoDisponible == null){
            query = await db.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
              stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query.first['descontarDelBloqueoGeneral']);
            }
          }

          if(montoDisponible == null){
            query = await db.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda]);
            if(query.isEmpty != true){
              montoDisponible = query.first["monto"];
              stockToReturn = Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda);
            }
          }

          // print('montoDisponiblePrueba idSorteo: lot: $loteria.id sor: $idSorteo dia: $idDia res:${blocksgenerals.indexWhere((b) => b.idLoteria == loteria.id && b.idDia == idDia && b.idSorteo == idSorteo)} prueba:${Blocksgenerals.blocksgeneralsToJson(blocksgenerals.where((b) => b.idLoteria == loteria.id && b.idSorteo == idSorteo).toList())}');
        }
      }
    }

    double montoDisponibleFinal = Utils.toDouble(montoDisponible.toString());

    if(stockToReturn != null)
      stockToReturn.monto = montoDisponibleFinal;
    else
      stockToReturn = Stock(monto: montoDisponibleFinal);

    print("principalView getMontoDisponible: ${stockToReturn.toJson()}");
    return MontoDisponible(monto: montoDisponibleFinal, stock: stockToReturn);

  }


  @override
  Future<Map<String, dynamic>> draw(String descripcion, [var sqfliteTransaction]) async {
    // TODO: implement draw
    var db = sqfliteTransaction == null ? DBSqflite.database : sqfliteTransaction; 
    List<Map<String, Object>> data = await db.query("Draws", where: '"descripcion" = ?', whereArgs: [descripcion]);
    return data.isNotEmpty ? data.first : null;
  }

  @override
  Future deleteAllBranches() {
    // TODO: implement deleteAllBranches
    return DBSqflite.database.rawQuery("DELETE FROM Branches");
    throw UnimplementedError();
  }

  @override
  Future insertBranch(drift.Branch branch) {
    // TODO: implement insertBranch
    return insert("Branches", branch.toJson());
    throw UnimplementedError();
  }

  @override
  Future deleteAllPermission() {
    // TODO: implement deleteAllPermission
    return DBSqflite.database.rawQuery("DELETE FROM Permissions");
    throw UnimplementedError();
  }

  @override
  Future deleteAllUser() {
    // TODO: implement deleteAllUser
    return DBSqflite.database.rawQuery("DELETE FROM Permissions");
    throw UnimplementedError();
  }

  @override
  Future<List<drift.Server>> getAllServer() async {
    // TODO: implement getAllServer
    try {
      var data = await DBSqflite.database.query("Servers");
      return data.map<drift.Server>((e) => drift.Server(id: e["id"], descripcion: e["descripcion"], pordefecto: e["pordefecto"], created_at: e["created_at"] )).toList();
    } on Exception catch (e) {
      // TODO
      return [];
    }
  }

  @override
  Future<int> getBlocksdirtyCantidad({int idBanca, int idLoteria, int idSorteo, int idMoneda}) async {
    // TODO: implement getBlocksdirtyCantidad
    try {
      var query = await DBSqflite.database.query('Blocksdirty' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idMoneda" = ?', whereArgs: [idBanca, idLoteria, idSorteo, idMoneda], orderBy: '"id" desc' );
      return query.isNotEmpty ? query.first["cantidad"] : null;
    } on Exception catch (e) {
      // TODO
      return null;
    }
    
  }

  @override
  Future<int> getBlocksdirtygeneralCantidad({int idLoteria, int idSorteo, int idMoneda}) async {
    // TODO: implement getBlocksdirtygeneralCantidad
    try {
      var query  = await DBSqflite.database.query('Blocksdirtygenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idMoneda" = ?', whereArgs: [idLoteria, idSorteo, idMoneda], orderBy: '"id" desc' );
      return query.isNotEmpty ? query.first["cantidad"] : null;
    } on Exception catch (e) {
      // TODO
      return null;
    }
  }

  @override
  Future insertUser(drift.User user) {
    // TODO: implement insertUser
    return insert("Users", user.toJson());
  }

  @override
  Future<void> insertListLoteria(List<Loteria> loterias) async {
    // TODO: implement insertListLoteria
    var batch = DBSqflite.database.batch();
    for(Loteria l in loterias){
        await batch.insert('Lotteries', {"id":l.id, "descripcion" : l.descripcion, "abreviatura" : l.abreviatura, "status" : l.status}, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    batch.commit(noResult: true);
  }

  @override
  Future<void> insertListDay(List<Dia> dias) async {
    // TODO: implement insertListDay
    var batch = DBSqflite.database.batch();
    for(Dia d in dias){
      await batch.insert('Days', d.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    batch.commit(noResult: true);
  }

  @override
  Future insertSetting(drift.Setting setting) async {
    // TODO: implement insertSetting
    await insert("Settings", setting.toJson());
  }

  @override
  Future<void> insertListPermission(List<Permiso> permisos) async {
    // TODO: implement insertListPermission
    var batch = DBSqflite.database.batch();
    for(Permiso p in permisos){
      await batch.insert('Permissions', p.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    batch.commit(noResult: true);
  }

  @override
  Future<void> insertListServer(List<Servidor> servidores) async {
    // TODO: implement insertListServer
    var batch = DBSqflite.database.batch();
    for(Servidor s in servidores){
      await batch.insert('Servers', s.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    batch.commit(noResult: true);
  }

  @override
  Future insertOrDeleteStocks(List<Stock> elements, bool delete) {
    // TODO: implement insertOrDeleteStocks
    elements.forEach((s) async {
      List<Map<String, dynamic>> query = await DBSqflite.database.query('Stocks' , where: '"id" = ?', whereArgs: [s.id]);
      if(query.isEmpty == false){
        print("Realtime addStocks parsed actualizar: ${s.toJson()}");

        if(delete)
          await DBSqflite.delete('Stocks', s.id);
        else
          await update('Stocks', s.toJson(), s.id);
      }else{
        print("Realtime addStocks parsed insertart: ${s.toJson()}");
        if(delete)
          await DBSqflite.delete('Stocks', s.id);
        else
          await insert('Stocks', s.toJson());
      }
    });
  }

  @override
  Future insertOrDeleteBlocksgenerals(List<Blocksgenerals> elements, bool delete) {
    // TODO: implement insertOrDeleteBlocksgenerals
    elements.forEach((s) async {
      List<Map<String, dynamic>> query = await DBSqflite.database.query('Blocksgenerals' , where: '"id" = ?', whereArgs: [s.id]);
      if(query.isEmpty == false){
        print('query dentro y eliminar:$delete');
        if(delete)
          await DBSqflite.delete('Blocksgenerals', s.id);
        else
          await update('Blocksgenerals', s.toJson(), s.id);
      }else{
        if(delete)
          await DBSqflite.delete('Blocksgenerals', s.id);
        else
          await insert('Blocksgenerals', s.toJson());
      }
    });
  }

  @override
  Future insertOrDeleteBlockslotteries(List<Blockslotteries> elements, bool delete) {
    // TODO: implement insertOrDeleteBlockslotteries
    elements.forEach((s) async {
      List<Map<String, dynamic>> query = await DBSqflite.database.query('Blockslotteries' , where: '"id" = ?', whereArgs: [s.id]);
      print("PrincipalClass addBlockslotteriesDatosNuevos: ${s.toJson()}");
      if(query.isEmpty == false){
        if(delete)
          await DBSqflite.delete('Blockslotteries', s.id);
        else
          await update('Blockslotteries', s.toJson(), s.id);
      }else{
        if(delete)
          await DBSqflite.delete('Blockslotteries', s.id);
        else
          await insert('Blockslotteries', s.toJson());
      }
    });
  }

  @override
  Future insertOrDeleteBlocksplays(List<Blocksplays> elements, bool delete) {
    // TODO: implement insertOrDeleteBlocksplays
    elements.forEach((s) async {
      List<Map<String, dynamic>> query = await DBSqflite.database.query('Blocksplays' , where: '"id" = ?', whereArgs: [s.id]);
      if(query.isEmpty == false){
        if(delete)
          await DBSqflite.delete('Blocksplays', s.id);
        else
          await update('Blocksplays', s.toJson(), s.id);
      }else{
        if(delete)
          await DBSqflite.delete('Blocksplays', s.id);
        else
          await insert('Blocksplays', s.toJson());
      }
    });
  }

  @override
  Future deleteAllSetting() {
    // TODO: implement deleteAllSetting
    return DBSqflite.database.rawQuery("DELETE FROM Settings");
  }

  @override
  Future insertOrDeleteBlocksplaysgenerals(List<Blocksplaysgenerals> elements, bool delete) {
    // TODO: implement insertOrDeleteBlocksplaysgenerals
    elements.forEach((s) async {
      List<Map<String, dynamic>> query = await DBSqflite.database.query('Blocksplaysgenerals' , where: '"id" = ?', whereArgs: [s.id]);
      if(query.isEmpty == false){
        print('mobile_db Blocksplaysgenerals existe, eliminar: $delete');
        if(delete)
          await DBSqflite.delete('Blocksplaysgenerals', s.id);
        else
          await update('Blocksplaysgenerals', s.toJson(), s.id);
      }else{
        if(delete)
          await DBSqflite.delete('Blocksplaysgenerals', s.id);
        else
          await insert('Blocksplaysgenerals', s.toJson());
      }
    });
  }

  @override
  Future insertOrDeleteBlocksdirtygenerals(List<Blocksdirtygenerals> elements, bool delete) {
    // TODO: implement insertOrDeleteBlocksdirtygenerals
    elements.forEach((s) async {
      List<Map<String, dynamic>> query = await DBSqflite.database.query('Blocksdirtygenerals' , where: '"id" = ?', whereArgs: [s.id]);
      if(query.isEmpty == false){
        print('mobile_db insertOrDeleteBlocksdirtygenerals query dentro y eliminar:$delete');
        if(delete)
          await DBSqflite.delete('Blocksdirtygenerals', s.id);
        else
          await update('Blocksdirtygenerals', s.toJson(), s.id);
      }else{
        if(delete)
          await DBSqflite.delete('Blocksdirtygenerals', s.id);
        else
          await insert('Blocksdirtygenerals', s.toJson());
      }
    });
  }

  @override
  Future insertOrDeleteBlocksdirtys(List<Blocksdirty> elements, bool delete) {
    // TODO: implement insertOrDeleteBlocksdirtys
    elements.forEach((s) async {
      List<Map<String, dynamic>> query = await DBSqflite.database.query('Blocksdirty' , where: '"id" = ?', whereArgs: [s.id]);
      if(query.isEmpty == false){
        print('mobile_db insertOrDeleteBlocksdirtys: query dentro y eliminar:$delete');
        if(delete)
          await DBSqflite.delete('Blocksdirty', s.id);
        else
          await update('Blocksdirty', s.toJson(), s.id);
      }else{
        if(delete)
          await DBSqflite.delete('Blocksdirty', s.id);
        else
          await insert('Blocksdirty', s.toJson());
      }
    });
  }
  
  @override
  Future<List<Draws>> draws(List<String> descripciones, [sqfliteTransaction]) async {
    // TODO: implement draws
    if(descripciones.length == 0)
      return [];
    String descripcionesSeparadasPorComa = descripciones.join(",");
    var sorteosMap = await DBSqflite.database.rawQuery("SELECT * FROM Draws where descripcion in($descripcionesSeparadasPorComa)");
    return sorteosMap.length > 0 ? sorteosMap.map((e) => Draws.fromMap(e)) : [];
  }
  

}


CrossDB getDB() => MobileDB();