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
    var database = WebMoor();
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
    var database = WebMoor();
    return database.db.deleteAllTables();
  }

  @override
  Future<Map<String, dynamic>> ajustes() {
    // TODO: implement ajustes
    var database = WebMoor();
    return database.db.getSetting();
    throw UnimplementedError("WebDatabase Uninplemented ajustes");
  }

  @override
  Future delete(String table, [id]) {
      // TODO: implement delete
    var database = WebMoor();
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
    
    // throw UnimplementedError("WebDatabase Uninplemented delete");
  }
  
    @override
    Future<bool> existePermiso(String permiso) {
      // TODO: implement existePermiso
      var database = WebMoor();
      return database.db.existePermiso(permiso);
      throw UnimplementedError("WebDatabase Uninplemented existePermiso");
    }
  
    @override
    Future<Map<String, dynamic>> getBanca() {
      // TODO: implement getBanca
      var database = WebMoor();
      return database.db.getBanca();
      throw UnimplementedError("WebDatabase Uninplemented getBanca");
    }
  
    @override
    Future<Map<String, dynamic>> getUsuario() {
      // TODO: implement getUsuario
      var database = WebMoor();
      return database.db.getUsuario();
      throw UnimplementedError("WebDatabase Uninplemented getUsuario");
    }
  
    @override
    Future<int> idBanca() {
      // TODO: implement idBanca
      var database = WebMoor();
      return database.db.idBanca();
      throw UnimplementedError("WebDatabase Uninplemented idBanca");
    }
  
    @override
    Future<int> idUsuario() {
      // TODO: implement idUsuario
       var database = WebMoor();
      return database.db.idUsuario();
      throw UnimplementedError("WebDatabase Uninplemented idUsuario");
    }
    @override
    Future<int> idGrupo() {
      // TODO: implement idGrupo
       var database = WebMoor();
      return database.db.idGrupo();
      throw UnimplementedError("WebDatabase Uninplemented idGrupo");
    }
  
    @override
    Future<List<Map<String, dynamic>>> query(String table) async {
      // TODO: implement query
      // throw UnimplementedError("WebDatabase Uninplemented query");
    var database = WebMoor();

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
      var database = WebMoor();
      return database.db.servidor();
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

  @override
  Future<bool> existePermisos(List<String> permiso) {
    // TODO: implement existePermisos
    throw UnimplementedError("WebDatabase Uninplemented existePermisos");
  }

  @override
  Future<Map<String, dynamic>> getLastRow(String table) {
    // TODO: implement getLastRow
    throw UnimplementedError("WebDatabase Uninplemented getLastRow");
  }

  @override
  Future<bool> existeLoteria(int id) {
    // TODO: implement existeLoteria
    throw UnimplementedError("WebDatabase Uninplemented existeLoteria");
  }

  @override
  Future<Map<String, dynamic>> getNextTicket(int idBanca, String servidor) {
    // TODO: implement getNextTicket
    throw UnimplementedError("WebDatabase Uninplemented getNextTicket");
  }

  @override
  Future<Map<String, dynamic>> queryBy(String table, String by, value) {
    // TODO: implement queryBy
    throw UnimplementedError("WebDatabase Uninplemented queryBy");
  }

  @override
  Future<List<Map<String, dynamic>>> queryListBy(String table, String by, value) {
    // TODO: implement queryBy
    throw UnimplementedError("WebDatabase Uninplemented queryListBy");
  }

  @override
  Future<Map<String, dynamic>> getSaleNoSubida() {
    // TODO: implement getSaleNoSubida
    throw UnimplementedError("WebDatabase Uninplemented getSaleNoSubida");
  }

}

CrossDB getDB() => WebMoor();

