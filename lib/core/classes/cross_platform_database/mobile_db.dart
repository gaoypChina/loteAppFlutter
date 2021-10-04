import 'dart:io';

import 'package:loterias/core/classes/cross_platform_database/cross_platform_db.dart';
import 'package:loterias/core/classes/database.dart';

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
  

}


CrossDB getDB() => MobileDB();