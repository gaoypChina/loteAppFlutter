import 'package:drift/web.dart';
import 'package:loterias/core/classes/cross_platform_database/cross_platform_db.dart';
import 'package:loterias/core/classes/drift_database.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/montodisponible.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/models/stocks.dart' as stockModel;
getMoorWebConstructor(){
  return WebDatabase('app', logStatements: true);
}

class WebDrift implements CrossDB{
  // @override
  // getMoorCrossConstructor() {
  //   // TODO: implement getMoorCrossConstructor
  //   return WebDatabase('app', logStatements: true);
  // }
  AppDatabase db;
  static final WebDrift _singleton = WebDrift._internal();

  factory WebDrift() {
    return _singleton;
  }

  // Db._internal();
  WebDrift._internal(){
    db = AppDatabase(WebDatabase('app', logStatements: true));
  }

  @override
  openConnection() {
    // TODO: implement getMoorCrossConstructor
    // WebDatabase('app', logStatements: true);
    var w = WebDrift();
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
    var database = WebDrift();
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
    var database = WebDrift();
    return database.db.deleteAllTables();
  }

  @override
  Future<Map<String, dynamic>> ajustes() {
    // TODO: implement ajustes
    var database = WebDrift();
    return database.db.getSetting();
    throw UnimplementedError("WebDatabase Uninplemented ajustes");
  }

  @override
  Future delete(String table, [id]) {
      // TODO: implement delete
    var database = WebDrift();
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
      var database = WebDrift();
      return database.db.existePermiso(permiso);
      throw UnimplementedError("WebDatabase Uninplemented existePermiso");
    }
  
    @override
    Future<Map<String, dynamic>> getBanca() {
      // TODO: implement getBanca
      var database = WebDrift();
      return database.db.getBanca();
      throw UnimplementedError("WebDatabase Uninplemented getBanca");
    }
  
    @override
    Future<Map<String, dynamic>> getUsuario() {
      // TODO: implement getUsuario
      var database = WebDrift();
      return database.db.getUsuario();
      throw UnimplementedError("WebDatabase Uninplemented getUsuario");
    }
  
    @override
    Future<int> idBanca() {
      // TODO: implement idBanca
      var database = WebDrift();
      return database.db.idBanca();
      throw UnimplementedError("WebDatabase Uninplemented idBanca");
    }
  
    @override
    Future<int> idUsuario() {
      // TODO: implement idUsuario
       var database = WebDrift();
      return database.db.idUsuario();
      throw UnimplementedError("WebDatabase Uninplemented idUsuario");
    }
    @override
    Future<int> idGrupo() {
      // TODO: implement idGrupo
       var database = WebDrift();
      return database.db.idGrupo();
      throw UnimplementedError("WebDatabase Uninplemented idGrupo");
    }
  
    @override
    Future<List<Map<String, dynamic>>> query(String table) async {
      // TODO: implement query
      // throw UnimplementedError("WebDatabase Uninplemented query");
    var database = WebDrift();

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
      var database = WebDrift();
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

  @override
  Future<void> sincronizarTodosDataBatch(parsed) {
    // TODO: implement sincronizarTodosDataBatch
    var database = WebDrift();
    return database.db.sincronizarTodosDataBatch(parsed);
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> drawById(int id, [var sqfliteTransaction]) {
    // TODO: implement drawById
    var database = WebDrift();
    return database.db.drawById(id);
    throw UnimplementedError();
  }

  @override
  Future<List> guardarVentaV2({Banca banca, List<Jugada> jugadas, socket, List<Loteria> listaLoteria, bool compartido, int descuentoMonto, currentTimeZone, bool tienePermisoJugarFueraDeHorario, bool tienePermisoJugarMinutosExtras, bool tienePermisoJugarSinDisponibilidad, sqfliteTransaction}) {
    // TODO: implement guardarVentaV2
    var database = WebDrift();
    return database.db.guardarVentaV2(banca: banca, jugadas: jugadas, socket: socket, listaLoteria: listaLoteria, compartido: compartido, descuentoMonto: descuentoMonto, currentTimeZone: currentTimeZone, tienePermisoJugarFueraDeHorario: tienePermisoJugarFueraDeHorario, tienePermisoJugarMinutosExtras: tienePermisoJugarMinutosExtras, tienePermisoJugarSinDisponibilidad: tienePermisoJugarSinDisponibilidad);
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> draw(String descripcion, [var sqfliteTransaction]) {
    // TODO: implement draw
    var database = WebDrift();
    return database.db.draw(descripcion);
    throw UnimplementedError();
  }

  @override
  Future<MontoDisponible> getMontoDisponible(String jugada, Loteria loteria, Banca banca, {Loteria loteriaSuperpale, bool retornarStock = false}) {
    // TODO: implement getMontoDisponible
    var database = WebDrift();
    return database.db.getMontoDisponible(jugada, loteria,banca, loteriaSuperpale: loteriaSuperpale, retornarStock: retornarStock );
    throw UnimplementedError();
  }

  @override
  Future deleteAllBranches() {
    // TODO: implement deleteAllBranches
    var database = WebDrift();
    return database.db.deleteAllBranches();
    throw UnimplementedError();
  }

  @override
  Future insertBranch(Branch branch) {
    // TODO: implement insertBranch
    var database = WebDrift();
    return database.db.insertBranch(branch);
    throw UnimplementedError();
  }

  @override
  Future deleteAllPermission() {
    // TODO: implement deleteAllPermission
    var database = WebDrift();
    return database.db.deleteAllPermission();
    throw UnimplementedError();
  }

  @override
  Future deleteAllUser() {
    // TODO: implement deleteAllUser
    var database = WebDrift();
    return database.db.deleteAllUser();
    throw UnimplementedError();
  }

  @override
  Future<List<Server>> getAllServer() {
    // TODO: implement deleteAllUser
    var database = WebDrift();
    return database.db.getAllServer();
    throw UnimplementedError();
  }

  @override
  Future<int> getBlocksdirtyCantidad({int idBanca, int idLoteria, int idSorteo, int idMoneda}) {
    // TODO: implement getBlocksdirtyCantidad
    var database = WebDrift();
    return database.db.getBlocksdirtyCantidad(idBanca: idBanca, idLoteria: idLoteria, idSorteo: idSorteo, idMoneda: idMoneda);
  }

  @override
  Future<int> getBlocksdirtygeneralCantidad({int idLoteria, int idSorteo, int idMoneda}) {
    // TODO: implement getBlocksdirtygeneralCantidad
    var database = WebDrift();
    return database.db.getBlocksdirtygeneralCantidad(idLoteria: idLoteria, idSorteo: idSorteo, idMoneda: idMoneda);
  }

  @override
  Future insertUser(User user) {
    // TODO: implement insertUser
    var database = WebDrift();
    return database.db.insertUser(user);
  }

  @override
  Future<void> insertListLoteria(List<Loteria> loterias) async {
    // TODO: implement insertListLoteria
    var database = WebDrift();
    await database.db.insertListLoteria(loterias);
  }

  @override
  Future<void> insertListDay(List<Dia> dias) async {
    // TODO: implement insertListDay
    var database = WebDrift();
    await database.db.insertListDay(dias);
  }

  @override
  Future insertSetting(Setting setting) async {
    // TODO: implement insertSetting
    var database = WebDrift();
    await database.db.insertSetting(setting);
  }

  @override
  Future<void> insertListPermission(List<Permiso> permisos) async {
    // TODO: implement insertListPermission
    var database = WebDrift();
    await database.db.insertListPermission(permisos);
  }

  @override
  Future<void> insertListServer(List<Servidor> servidores) async {
    // TODO: implement insertListServer
    var database = WebDrift();
    await database.db.insertListServer(servidores);
  }

  @override
  Future insertOrDeleteStocks(List<stockModel.Stock> elements, bool delete) async {
    // TODO: implement insertOrDeleteStocks
    var database = WebDrift();
    await database.db.insertOrDeleteStocks(elements, delete);
  }

}

CrossDB getDB() => WebDrift();

