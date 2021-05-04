import 'package:loterias/core/classes/cross_platform_database/cross_platform_db.dart';
import 'package:loterias/core/classes/moor_database.dart';
import 'package:moor/moor_web.dart';
getMoorWebConstructor(){
  return WebDatabase('app', logStatements: true);
}

class WebMoor implements CrossDB{
  // @override
  // getMoorCrossConstructor() {
  //   // TODO: implement getMoorCrossConstructor
  //   return WebDatabase('app', logStatements: true);
  // }
  AppDatabase db;
  static final WebMoor _singleton = WebMoor._internal();

  factory WebMoor() {
    return _singleton;
  }

  // Db._internal();
  WebMoor._internal(){
    db = AppDatabase(WebDatabase('app', logStatements: true));
  }

  @override
  openConnection() {
    // TODO: implement getMoorCrossConstructor
    // WebDatabase('app', logStatements: true);
    var w = WebMoor();
    // return AppDatabase(WebDatabase('app', logStatements: true));
    return w.db;
  }

  @override
  String getPlatform() {
    // TODO: implement getPlatform
    return "Web";
  }

  @override
  insert(String table, Map<String, dynamic> dataToMap) {
    // TODO: implement insert
    switch (table) {
      case "":
        
        break;
      default:
    }
  }

  @override
  deleteDB() {
    // TODO: implement deleteDB
    throw UnimplementedError("WebDatabase Uninplemented deleteDB");
  }

  @override
  Future<Map<String, dynamic>> ajustes() {
    // TODO: implement ajustes
    throw UnimplementedError("WebDatabase Uninplemented ajustes");
  }

  @override
  Future delete(String table, id) {
      // TODO: implement delete
      throw UnimplementedError("WebDatabase Uninplemented delete");
    }
  
    @override
    Future<bool> existePermiso(String permiso) {
      // TODO: implement existePermiso
      throw UnimplementedError("WebDatabase Uninplemented existePermiso");
    }
  
    @override
    Future<Map<String, dynamic>> getBanca() {
      // TODO: implement getBanca
      throw UnimplementedError("WebDatabase Uninplemented getBanca");
    }
  
    @override
    Future<Map<String, dynamic>> getUsuario() {
      // TODO: implement getUsuario
      throw UnimplementedError("WebDatabase Uninplemented getUsuario");
    }
  
    @override
    Future<int> idBanca() {
      // TODO: implement idBanca
      throw UnimplementedError("WebDatabase Uninplemented idBanca");
    }
  
    @override
    Future<int> idUsuario() {
      // TODO: implement idUsuario
      throw UnimplementedError("WebDatabase Uninplemented idUsuario");
    }
  
    @override
    Future<List<Map<String, dynamic>>> query(String table) {
      // TODO: implement query
      throw UnimplementedError("WebDatabase Uninplemented query");
    }
  
    @override
    Future<String> servidor() {
      // TODO: implement servidor
      throw UnimplementedError("WebDatabase Uninplemented servidor");
    }
  
    @override
    Future<String> tipoFormatoTicket() {
      // TODO: implement tipoFormatoTicket
      throw UnimplementedError("WebDatabase Uninplemented tipoFormatoTicket");
    }
  
    @override
    Future update(String table, Map<String, dynamic> dataToMap, id) {
    // TODO: implement update
    throw UnimplementedError("WebDatabase Uninplemented update");
  }

}

CrossDB getDB() => WebMoor();

