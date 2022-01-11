
// import 'cross_platform_db_stub.dart'
    import 'package:flutter/material.dart';
import 'package:loterias/core/classes/cross_platform_database/cross_platform_db_stub.dart'

if (dart.library.io) 'local_db.dart'
    if (dart.library.js) 'web_db.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/montodisponible.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/models/stocks.dart' as StockModel;
import 'package:loterias/core/models/blocksgenerals.dart' as BlocksgeneralsModel;
import 'package:loterias/core/models/blockslotteries.dart' as BlockslotteriesModel;
import 'package:loterias/core/models/blocksplays.dart' as BlocksplaysModel;
import 'package:loterias/core/models/blocksplaysgenerals.dart' as BlocksplaysgeneralsModel;

import '../drift_database.dart';

abstract class CrossDB {
  // QueryExecutor getMoorCrossConstructor();
  dynamic openConnection();
  String getPlatform();
  Future<void> insert(String table, Map<String, dynamic> dataToMap);
  Future update(String table, Map<String, dynamic> dataToMap, id);
  Future delete(String table, [id]);
  Future<List<Map<String, dynamic>>> query(String table);
  Future<int> idUsuario();
  Future<String> servidor();
  Future<int> idBanca();
  Future<Map<String, dynamic>> getUsuario();
  Future<Map<String, dynamic>> getBanca();
  Future<bool> existePermiso(String permiso);
  Future<bool> existePermisos(List<String> permiso);
  Future<bool> existeLoteria(int id);
  Future deleteDB();
  Future<Map<String, dynamic>> ajustes();
  Future<Map<String, dynamic>> getLastRow(String table);
  Future<Map<String, dynamic>> getNextTicket(int idBanca, String servidor);
  Future<Map<String, dynamic>> queryBy(String table, String by, dynamic value);
  Future<List<Map<String, dynamic>>> queryListBy(String table, String by, dynamic value);
  Future<Map<String, dynamic>> getSaleNoSubida();
  Future<int> idGrupo();

  Future<String> tipoFormatoTicket();
  Future<void> sincronizarTodosDataBatch(var parsed);

  Future<Map<String, dynamic>> drawById(int id, [var sqfliteTransaction]);
  Future<Map<String, dynamic>> draw(String descripcion, [var sqfliteTransaction]);
  Future<List> guardarVentaV2({Banca banca, List<Jugada> jugadas, socket, List<Loteria> listaLoteria, bool compartido, int descuentoMonto, currentTimeZone, bool tienePermisoJugarFueraDeHorario, bool tienePermisoJugarMinutosExtras, bool tienePermisoJugarSinDisponibilidad});
  Future<MontoDisponible> getMontoDisponible(String jugada, Loteria loteria, Banca banca, {Loteria loteriaSuperpale, bool retornarStock = false, });
  
  Future insertBranch(Branch branch);
  Future deleteAllBranches();

  Future<void> insertListPermission(List<Permiso> permisos);
  Future deleteAllPermission();

  Future insertUser(User user);
  Future deleteAllUser();

  Future<int> getBlocksdirtyCantidad({@required int idBanca, @required int idLoteria, @required int idSorteo, @required int idMoneda});
  Future<int> getBlocksdirtygeneralCantidad({@required int idLoteria, @required int idSorteo, @required int idMoneda});

  Future<void> insertListLoteria(List<Loteria> loterias);

  Future<void> insertListDay(List<Dia> dias);
  Future insertSetting(Setting setting);

  Future<List<Server>> getAllServer();
  Future<void> insertListServer(List<Servidor> servidores);

  Future insertOrDeleteStocks(List<StockModel.Stock> elements, bool delete);
  Future insertOrDeleteBlocksgenerals(List<BlocksgeneralsModel.Blocksgenerals> elements, bool delete);
  Future insertOrDeleteBlockslotteries(List<BlockslotteriesModel.Blockslotteries> elements, bool delete);
  Future insertOrDeleteBlocksplays(List<BlocksplaysModel.Blocksplays> elements, bool delete);
  Future insertOrDeleteBlocksplaysgenerals(List<BlocksplaysgeneralsModel.Blocksplaysgenerals> elements, bool delete);

  Future deleteAllSetting();

  factory CrossDB() => getDB();
  
}