
// import 'cross_platform_db_stub.dart'
    import 'package:loterias/core/classes/cross_platform_database/cross_platform_db_stub.dart'

if (dart.library.io) 'local_db.dart'
    if (dart.library.js) 'web_db.dart';

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
  factory CrossDB() => getDB();
  
}