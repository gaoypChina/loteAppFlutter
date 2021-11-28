import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:loterias/core/classes/cross_platform_database/cross_platform_db.dart';
import 'package:loterias/core/classes/drift_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class LocalDrift implements CrossDB{
  // @override
  // getMoorCrossConstructor() {
  //   // TODO: implement getMoorCrossConstructor
  //   return LocalDatabase('app', logStatements: true);
  // }
  AppDatabase db;
  static final LocalDrift _singleton = LocalDrift._internal();

  factory LocalDrift() {
    return _singleton;
  }

  // Db._internal();
  LocalDrift._internal(){
    // db = AppDatabase(LocalDatabase('app', logStatements: true));
    final dbTmp = LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
    db = AppDatabase(dbTmp);
  }

  @override
  openConnection() {
    var w = LocalDrift();
    return w.db;
  }

  @override
  String getPlatform() {
    return "Local";
  }

  @override
  insert(String table, Map<String, dynamic> dataToMap) {
    // TODO: implement insert
    var database = LocalDrift();
    switch (table) {
      case "Users":
        return database.db.insertUser(User.fromJson(dataToMap));
        break;
      case "Permissions":
        return database.db.insertPermission(Permission(id: dataToMap["id"], descripcion: dataToMap["descripcion"], status: dataToMap["status"], created_at: DateTime.parse(dataToMap["created_at"])));
        break;
      case "Settings":
        return database.db.insertSetting(Setting.fromJson(dataToMap));
        break;
      case "Servers":
        return database.db.insertServer(Server.fromJson(dataToMap));
        break;
      default:
        return null;
    }
  }

  @override
  deleteDB() {
    // TODO: implement deleteDB
    var database = LocalDrift();
    return database.db.deleteAllTables();
  }

  @override
  Future<Map<String, dynamic>> ajustes() {
    // TODO: implement ajustes
    var database = LocalDrift();
    return database.db.getSetting();
  }

  @override
  Future delete(String table, [id]) {
      // TODO: implement delete
    var database = LocalDrift();
    switch (table) {
      case "Users":
        return database.db.deleteAllUser();
        break;
      case "Permissions":
        return database.db.deleteAllPermission();
        break;
      case "Settings":
        return database.db.deleteAllSetting();
        break;
      case "Branches":
        return database.db.deleteAllBranches();
        break;
      default:
        return null;
    }
    
  }
  
    @override
    Future<bool> existePermiso(String permiso) {
      // TODO: implement existePermiso
      var database = LocalDrift();
      return database.db.existePermiso(permiso);
      throw UnimplementedError("LocalDatabase Uninplemented existePermiso");
    }
  
    @override
    Future<Map<String, dynamic>> getBanca() {
      // TODO: implement getBanca
      var database = LocalDrift();
      return database.db.getBanca();
      throw UnimplementedError("LocalDatabase Uninplemented getBanca");
    }
  
    @override
    Future<Map<String, dynamic>> getUsuario() {
      // TODO: implement getUsuario
      var database = LocalDrift();
      return database.db.getUsuario();
      throw UnimplementedError("LocalDatabase Uninplemented getUsuario");
    }
  
    @override
    Future<int> idBanca() {
      // TODO: implement idBanca
      var database = LocalDrift();
      return database.db.idBanca();
      throw UnimplementedError("LocalDatabase Uninplemented idBanca");
    }
  
    @override
    Future<int> idUsuario() {
      // TODO: implement idUsuario
       var database = LocalDrift();
      return database.db.idUsuario();
      throw UnimplementedError("LocalDatabase Uninplemented idUsuario");
    }
    @override
    Future<int> idGrupo() {
      // TODO: implement idGrupo
       var database = LocalDrift();
      return database.db.idGrupo();
      throw UnimplementedError("LocalDatabase Uninplemented idGrupo");
    }
  
    @override
    Future<List<Map<String, dynamic>>> query(String table) async {
      // TODO: implement query
      // throw UnimplementedError("LocalDatabase Uninplemented query");
    var database = LocalDrift();

      switch (table) {
      // case "Users":
      //   return database.db.insertUser(User.fromJson(dataToMap));
      //   break;
      // case "Permissions":
      //   return database.db.insertPermission(Permission(id: dataToMap["id"], descripcion: dataToMap["descripcion"], status: dataToMap["status"], created_at: DateTime.parse(dataToMap["created_at"])));
      //   break;
      // case "Settings":
      //   return database.db.insertSetting(Setting.fromJson(dataToMap));
      //   break;
      case "Servers":
        return (await database.db.getAllServer()).map<Map<String, dynamic>>((e) => {"descripcion" : e.descripcion, "id" : e.id, "pordefecto" : e.pordefecto}).toList();
        break;
      default:
        return null;
    }
    }
  
    @override
    Future<String> servidor() {
      // TODO: implement servidor
      var database = LocalDrift();
      return database.db.servidor();
      throw UnimplementedError("LocalDatabase Uninplemented servidor");
    }
  
    @override
    Future<String> tipoFormatoTicket() {
      // TODO: implement tipoFormatoTicket
      throw UnimplementedError("LocalDatabase Uninplemented tipoFormatoTicket");
    }
  
    @override
    Future update(String table, Map<String, dynamic> dataToMap, id) {
    // TODO: implement update
    throw UnimplementedError("LocalDatabase Uninplemented update");
  }

  @override
  Future<bool> existePermisos(List<String> permiso) {
    // TODO: implement existePermisos
    throw UnimplementedError("LocalDatabase Uninplemented existePermisos");
  }

  @override
  Future<Map<String, dynamic>> getLastRow(String table) {
    // TODO: implement getLastRow
    throw UnimplementedError("LocalDatabase Uninplemented getLastRow");
  }

  @override
  Future<bool> existeLoteria(int id) {
    // TODO: implement existeLoteria
    throw UnimplementedError("LocalDatabase Uninplemented existeLoteria");
  }

  @override
  Future<Map<String, dynamic>> getNextTicket(int idBanca, String servidor) {
    // TODO: implement getNextTicket
    throw UnimplementedError("LocalDatabase Uninplemented getNextTicket");
  }

  @override
  Future<Map<String, dynamic>> queryBy(String table, String by, value) {
    // TODO: implement queryBy
    throw UnimplementedError("LocalDatabase Uninplemented queryBy");
  }

  @override
  Future<List<Map<String, dynamic>>> queryListBy(String table, String by, value) {
    // TODO: implement queryBy
    throw UnimplementedError("LocalDatabase Uninplemented queryListBy");
  }

  @override
  Future<Map<String, dynamic>> getSaleNoSubida() {
    // TODO: implement getSaleNoSubida
    throw UnimplementedError("LocalDatabase Uninplemented getSaleNoSubida");
  }

  @override
  Future<void> sincronizarTodosDataBatch(parsed) {
    // TODO: implement sincronizarTodosDataBatch
     var database = LocalDrift();
    return database.db.sincronizarTodosDataBatch(parsed);
    throw UnimplementedError();
  }

}

CrossDB getDB() => LocalDrift();

