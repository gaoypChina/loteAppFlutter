
// import 'cross_platform_db_stub.dart'
    import 'package:loterias/core/classes/cross_platform_database/cross_platform_db_stub.dart'

if (dart.library.io) 'local_db.dart'
    if (dart.library.js) 'web_db.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/montodisponible.dart';

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

  Future deleteAllPermission();
  Future deleteAllUser();

  Future<List<Server>> getAllServer();

  factory CrossDB() => getDB();
  
}