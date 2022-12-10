import 'package:drift/web.dart';
import 'package:loterias/core/classes/cross_platform_database/cross_platform_db.dart';
import 'package:loterias/core/classes/drift_database.dart';
import 'package:loterias/core/models/blocksdirty.dart';
import 'package:loterias/core/models/blocksdirtygenerals.dart';
import 'package:loterias/core/models/blocksgenerals.dart';
import 'package:loterias/core/models/blockslotteries.dart';
import 'package:loterias/core/models/blocksplays.dart';
import 'package:loterias/core/models/blocksplaysgenerals.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/montodisponible.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/models/stocks.dart' as StockModel;
import 'package:loterias/core/models/blocksgenerals.dart' as BlocksgeneralsModel;
import 'package:loterias/core/models/blockslotteries.dart' as BlockslotteriesModel;
import 'package:loterias/core/models/blocksplays.dart' as BlocksplaysModel;
import 'package:loterias/core/models/blocksplaysgenerals.dart' as BlocksplaysgeneralsModel;
import 'package:loterias/core/models/blocksdirtygenerals.dart' as BlocksdirtygeneralsModel;
import 'package:loterias/core/models/blocksdirty.dart' as BlocksdirtyModel;
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
        return obtenerBaseDeDatos().insertUser(User.fromJson(dataToMap));
        break;
      case "Permissions":
        return obtenerBaseDeDatos().insertPermission(Permission(id: dataToMap["id"], descripcion: dataToMap["descripcion"], status: dataToMap["status"], created_at: DateTime.parse(dataToMap["created_at"])));
        break;
      case "Settings":
        return obtenerBaseDeDatos().insertSetting(Setting.fromJson(dataToMap));
        break;
      case "Servers":
        return obtenerBaseDeDatos().insertServer(Server.fromJson(dataToMap));
        break;
      default:
        return null;
    }
  }

  @override
  deleteDB() {
    // TODO: implement deleteDB
    var database = WebDrift();
    return obtenerBaseDeDatos().deleteAllTables();
  }

  @override
  Future<Map<String, dynamic>> ajustes() {
    // TODO: implement ajustes
    var database = WebDrift();
    return obtenerBaseDeDatos().getSetting();
    throw UnimplementedError("WebDatabase Uninplemented ajustes");
  }

  @override
  Future delete(String table, [id]) {
      // TODO: implement delete
    var database = WebDrift();
    switch (table) {
      case "Users":
        return obtenerBaseDeDatos().deleteAllUser();
        break;
      case "Permissions":
        return obtenerBaseDeDatos().deleteAllPermission();
        break;
      case "Settings":
        return obtenerBaseDeDatos().deleteAllSetting();
        break;
      case "Branches":
        return obtenerBaseDeDatos().deleteAllBranches();
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
      return obtenerBaseDeDatos().existePermiso(permiso);
      throw UnimplementedError("WebDatabase Uninplemented existePermiso");
    }
  
    @override
    Future<Map<String, dynamic>> getBanca() {
      // TODO: implement getBanca
      var database = WebDrift();
      return obtenerBaseDeDatos().getBanca();
      throw UnimplementedError("WebDatabase Uninplemented getBanca");
    }
  
    @override
    Future<Map<String, dynamic>> getUsuario() {
      // TODO: implement getUsuario
      var database = WebDrift();
      return obtenerBaseDeDatos().getUsuario();
      throw UnimplementedError("WebDatabase Uninplemented getUsuario");
    }
  
    @override
    Future<int> idBanca() {
      // TODO: implement idBanca
      var database = WebDrift();
      return obtenerBaseDeDatos().idBanca();
      throw UnimplementedError("WebDatabase Uninplemented idBanca");
    }
  
    @override
    Future<int> idUsuario() {
      // TODO: implement idUsuario
       var database = WebDrift();
      return obtenerBaseDeDatos().idUsuario();
      throw UnimplementedError("WebDatabase Uninplemented idUsuario");
    }
    @override
    Future<int> idGrupo() {
      // TODO: implement idGrupo
       var database = WebDrift();
      return obtenerBaseDeDatos().idGrupo();
      throw UnimplementedError("WebDatabase Uninplemented idGrupo");
    }
  
    @override
    Future<List<Map<String, dynamic>>> query(String table) async {
      // TODO: implement query
      // throw UnimplementedError("WebDatabase Uninplemented query");
    var database = WebDrift();

      switch (table) {
      // case "Users":
      //   return obtenerBaseDeDatos().insertUser(User.fromJson(dataToMap));
      //   break;
      // case "Permissions":
      //   return obtenerBaseDeDatos().insertPermission(Permission(id: dataToMap["id"], descripcion: dataToMap["descripcion"], status: dataToMap["status"], created_at: DateTime.parse(dataToMap["created_at"])));
      //   break;
      // case "Settings":
      //   return obtenerBaseDeDatos().insertSetting(Setting.fromJson(dataToMap));
      //   break;
      case "Servers":
        return (await obtenerBaseDeDatos().getAllServer()).map<Map<String, dynamic>>((e) => {"descripcion" : e.descripcion, "id" : e.id, "pordefecto" : e.pordefecto}).toList();
        break;
      default:
        return null;
    }
    }
  
    @override
    Future<String> servidor() {
      // TODO: implement servidor
      var database = WebDrift();
      return obtenerBaseDeDatos().servidor();
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
    return obtenerBaseDeDatos().sincronizarTodosDataBatch(parsed);
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> drawById(int id, [var sqfliteTransaction]) {
    // TODO: implement drawById
    var database = WebDrift();
    return obtenerBaseDeDatos().drawById(id);
    throw UnimplementedError();
  }

  @override
  Future<List> guardarVentaV2({Banca banca, List<Jugada> jugadas, socket, List<Loteria> listaLoteria, bool compartido, int descuentoMonto, currentTimeZone, bool tienePermisoJugarFueraDeHorario, bool tienePermisoJugarMinutosExtras, bool tienePermisoJugarSinDisponibilidad, sqfliteTransaction}) {
    // TODO: implement guardarVentaV2
    var database = WebDrift();
    return obtenerBaseDeDatos().guardarVentaV2(banca: banca, jugadas: jugadas, socket: socket, listaLoteria: listaLoteria, compartido: compartido, descuentoMonto: descuentoMonto, currentTimeZone: currentTimeZone, tienePermisoJugarFueraDeHorario: tienePermisoJugarFueraDeHorario, tienePermisoJugarMinutosExtras: tienePermisoJugarMinutosExtras, tienePermisoJugarSinDisponibilidad: tienePermisoJugarSinDisponibilidad);
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> draw(String descripcion, [var sqfliteTransaction]) {
    // TODO: implement draw
    var database = WebDrift();
    return obtenerBaseDeDatos().draw(descripcion);
    throw UnimplementedError();
  }

  @override
  Future<MontoDisponible> getMontoDisponible(String jugada, Loteria loteria, Banca banca, {Loteria loteriaSuperpale, bool retornarStock = false}) {
    // TODO: implement getMontoDisponible
    var database = WebDrift();
    return obtenerBaseDeDatos().getMontoDisponible(jugada, loteria,banca, loteriaSuperpale: loteriaSuperpale, retornarStock: retornarStock );
    throw UnimplementedError();
  }

  @override
  Future deleteAllBranches() {
    // TODO: implement deleteAllBranches
    var database = WebDrift();
    return obtenerBaseDeDatos().deleteAllBranches();
    throw UnimplementedError();
  }

  @override
  Future insertBranch(Branch branch) {
    // TODO: implement insertBranch
    var database = WebDrift();
    return obtenerBaseDeDatos().insertBranch(branch);
    throw UnimplementedError();
  }

  @override
  Future deleteAllPermission() {
    // TODO: implement deleteAllPermission
    var database = WebDrift();
    return obtenerBaseDeDatos().deleteAllPermission();
    throw UnimplementedError();
  }

  @override
  Future deleteAllUser() {
    // TODO: implement deleteAllUser
    var database = WebDrift();
    return obtenerBaseDeDatos().deleteAllUser();
    throw UnimplementedError();
  }

  @override
  Future<List<Server>> getAllServer() {
    // TODO: implement deleteAllUser
    var database = WebDrift();
    return obtenerBaseDeDatos().getAllServer();
    throw UnimplementedError();
  }

  @override
  Future<int> getBlocksdirtyCantidad({int idBanca, int idLoteria, int idSorteo, int idMoneda}) {
    // TODO: implement getBlocksdirtyCantidad
    var database = WebDrift();
    return obtenerBaseDeDatos().getBlocksdirtyCantidad(idBanca: idBanca, idLoteria: idLoteria, idSorteo: idSorteo, idMoneda: idMoneda);
  }

  @override
  Future<int> getBlocksdirtygeneralCantidad({int idLoteria, int idSorteo, int idMoneda}) {
    // TODO: implement getBlocksdirtygeneralCantidad
    var database = WebDrift();
    return obtenerBaseDeDatos().getBlocksdirtygeneralCantidad(idLoteria: idLoteria, idSorteo: idSorteo, idMoneda: idMoneda);
  }

  @override
  Future insertUser(User user) {
    // TODO: implement insertUser
    var database = WebDrift();
    return obtenerBaseDeDatos().insertUser(user);
  }

  @override
  Future<void> insertListLoteria(List<Loteria> loterias) async {
    // TODO: implement insertListLoteria
    var database = WebDrift();
    await obtenerBaseDeDatos().insertListLoteria(loterias);
  }

  @override
  Future<void> insertListDay(List<Dia> dias) async {
    // TODO: implement insertListDay
    var database = WebDrift();
    await obtenerBaseDeDatos().insertListDay(dias);
  }

  @override
  Future insertSetting(Setting setting) async {
    // TODO: implement insertSetting
    var database = WebDrift();
    await obtenerBaseDeDatos().insertSetting(setting);
  }

  @override
  Future<void> insertListPermission(List<Permiso> permisos) async {
    // TODO: implement insertListPermission
    var database = WebDrift();
    await obtenerBaseDeDatos().insertListPermission(permisos);
  }

  @override
  Future<void> insertListServer(List<Servidor> servidores) async {
    // TODO: implement insertListServer
    var database = WebDrift();
    await obtenerBaseDeDatos().insertListServer(servidores);
  }

  @override
  Future insertOrDeleteStocks(List<StockModel.Stock> elements, bool delete) async {
    // TODO: implement insertOrDeleteStocks
    var database = WebDrift();
    await obtenerBaseDeDatos().insertOrDeleteStocks(elements, delete);
  }

  @override
  Future insertOrDeleteBlocksgenerals(List<BlocksgeneralsModel.Blocksgenerals> elements, bool delete) async {
    // TODO: implement insertOrDeleteBlocksgenerals
    var database = WebDrift();
    await obtenerBaseDeDatos().insertOrDeleteBlocksgenerals(elements, delete);
  }

  @override
  Future insertOrDeleteBlockslotteries(List<BlockslotteriesModel.Blockslotteries> elements, bool delete) async {
    // TODO: implement insertOrDeleteBlockslotteries
    var database = WebDrift();
    await obtenerBaseDeDatos().insertOrDeleteBlockslotteries(elements, delete);
  }

  @override
  Future insertOrDeleteBlocksplays(List<BlocksplaysModel.Blocksplays> elements, bool delete) async {
    // TODO: implement insertOrDeleteBlocksplays
    var database = WebDrift();
    await obtenerBaseDeDatos().insertOrDeleteBlocksplays(elements, delete);
  }

  @override
  Future insertOrDeleteBlocksplaysgenerals(List<BlocksplaysgeneralsModel.Blocksplaysgenerals> elements, bool delete) async {
    // TODO: implement insertOrDeleteBlocksplaysgenerals
    var database = WebDrift();
    await obtenerBaseDeDatos().insertOrDeleteBlocksplaysgenerals(elements, delete);
  }

  @override
  Future deleteAllSetting() {
    // TODO: implement deleteAllSetting
    var database = WebDrift();
    return obtenerBaseDeDatos().deleteAllSetting();
  }

  @override
  Future insertOrDeleteBlocksdirtygenerals(List<BlocksdirtygeneralsModel.Blocksdirtygenerals> elements, bool delete) async {
    // TODO: implement insertOrDeleteBlocksdirtygenerals
    var database = WebDrift();
    await obtenerBaseDeDatos().insertOrDeleteBlocksdirtygenerals(elements, delete);
  }

  @override
  Future insertOrDeleteBlocksdirtys(List<BlocksdirtyModel.Blocksdirty> elements, bool delete) async {
    await obtenerBaseDeDatos().insertOrDeleteBlocksdirtys(elements, delete);
  }
  
  @override
  Future<List<Map<String, dynamic>>> obtenerMontoDeTablaBlockslotteries({int idBanca, int idLoteria, int idSorteo, int idDia, int idMoneda, int idLoteriaSuperpale, sqfliteTransaction}) {
    return obtenerBaseDeDatos().obtenerMontoDeTablaBlockslotteries(idBanca: idBanca, idLoteria: idLoteria, idSorteo: idSorteo, idDia: idDia, idMoneda: idMoneda, idLoteriaSuperpale: idLoteriaSuperpale, sqfliteTransaction: sqfliteTransaction);
  }
  
  @override
  Future<List<Map<String, dynamic>>> obtenerMontoDeTablaBlocksplays({int idBanca, int idLoteria, int idSorteo, String jugada, int idMoneda, sqfliteTransaction}) {
    return obtenerBaseDeDatos().obtenerMontoDeTablaBlocksplays(idBanca: idBanca, idLoteria: idLoteria, idSorteo: idSorteo, jugada: jugada, idMoneda: idMoneda, sqfliteTransaction: sqfliteTransaction);
  }
  
  @override
  Future<List<Map<String, dynamic>>> obtenerMontoDeTablaBlocksplaysgenerals({int idLoteria, int idSorteo, String jugada, int idMoneda, sqfliteTransaction}) {
    return obtenerBaseDeDatos().obtenerMontoDeTablaBlocksplaysgenerals(idLoteria: idLoteria, idSorteo: idSorteo, jugada: jugada, idMoneda: idMoneda, sqfliteTransaction: sqfliteTransaction);
  }
  
  @override
  Future<List<Map<String, dynamic>>> obtenerMontoDeTablaGenerals({int idLoteria, int idSorteo, int idDia, int idMoneda, int idLoteriaSuperpale, sqfliteTransaction}) {
    return obtenerBaseDeDatos().obtenerMontoDeTablaGenerals(idLoteria: idLoteria, idSorteo: idSorteo, idDia: idDia, idMoneda: idMoneda, idLoteriaSuperpale: idLoteriaSuperpale, sqfliteTransaction: sqfliteTransaction);
  }
  
  @override
  Future<List<Map<String, dynamic>>> obtenerMontoDeTablaStock({int idLoteria, int idSorteo, String jugada, int idMoneda, int esGeneral = 0, int ignorarDemasBloqueos, int idLoteriaSuperpale, int idBanca, sqfliteTransaction}) {
    return obtenerBaseDeDatos().obtenerMontoDeTablaStock(idLoteria: idLoteria, idSorteo: idSorteo, jugada: jugada, idMoneda: idMoneda, esGeneral: esGeneral, ignorarDemasBloqueos: ignorarDemasBloqueos, idLoteriaSuperpale: idLoteriaSuperpale, idBanca: idBanca, sqfliteTransaction: sqfliteTransaction);
  }

  AppDatabase obtenerBaseDeDatos(){
    return WebDrift().db;
  }

}

CrossDB getDB() => WebDrift();

