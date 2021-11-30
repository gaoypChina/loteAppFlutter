import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/montodisponible.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/sale.dart';
import 'package:loterias/core/models/salesdetails.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:drift/drift.dart';
// import 'package:moor/moor_web.dart';
import 'package:loterias/core/models/draws.dart' as DrawsModel;
import 'package:loterias/core/models/stocks.dart' as StockModel;
import 'package:loterias/core/models/blocksgenerals.dart' as BlocksgeneralsModel;
import 'package:loterias/core/models/blockslotteries.dart' as BlockslotteriesModel;
import 'package:loterias/core/models/blocksplays.dart' as BlocksplaysModel;
import 'package:loterias/core/models/blocksplaysgenerals.dart' as BlocksplaysgeneralsModel;
import 'package:loterias/core/models/blocksdirtygenerals.dart' as BlocksdirtygeneralsModel;
import 'package:loterias/core/models/blocksdirty.dart' as BlocksdirtyModel;
import 'package:loterias/core/models/ticket.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/services/sorteoservice.dart';


part 'drift_database.g.dart';


class Tasks extends Table{
  IntColumn get id => integer()();
  TextColumn get name => text()();
  DateTimeColumn get created_at => dateTime().nullable()();
  BoolColumn get status => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Permissions extends Table{
  IntColumn get id => integer()();
  TextColumn get descripcion => text()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get idTipo => integer()();
  IntColumn get status => integer()();
  // BoolColumn get status => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Days extends Table{
  IntColumn get id => integer()();
  TextColumn get descripcion => text()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get wday => integer()();
  DateTimeColumn get horaApertura => dateTime()();
  DateTimeColumn get horaCierre => dateTime()();
  // BoolColumn get status => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Users extends Table{
  IntColumn get id => integer()();
  TextColumn get nombres => text()();
  TextColumn get email => text()();
  TextColumn get usuario => text()();
  TextColumn get servidor => text()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get status => integer()();
  IntColumn get idGrupo => integer().nullable()();
  // BoolColumn get status => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Settings extends Table{
  IntColumn get id => integer()();
  TextColumn get consorcio => text()();
  IntColumn get idTipoFormatoTicket => integer()();
  IntColumn get imprimirNombreConsorcio => integer()();
  TextColumn get descripcionTipoFormatoTicket => text()();
  IntColumn get cancelarTicketWhatsapp => integer()();
  IntColumn get imprimirNombreBanca => integer()();
  IntColumn get pagarTicketEnCualquierBanca => integer()();
  // BoolColumn get status => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Branchs extends Table{
  IntColumn get id => integer()();
  TextColumn get descripcion => text()();
  TextColumn get codigo => text()();
  TextColumn get dueno => text()();
  IntColumn get idUsuario => integer()();
  RealColumn get limiteVenta => real()();
  RealColumn get descontar => real()();
  RealColumn get deCada => real()();
  IntColumn get minutosCancelarTicket => integer()();
  TextColumn get piepagina1 => text()();
  TextColumn get piepagina2 => text()();
  TextColumn get piepagina3 => text()();
  TextColumn get piepagina4 => text()();
  IntColumn get idMoneda => integer()();
  TextColumn get moneda => text()();
  TextColumn get monedaAbreviatura => text()();
  TextColumn get monedaColor => text()();
  IntColumn get status => integer()();
  DateTimeColumn get created_at => dateTime().nullable()();
  RealColumn get ventasDelDia => real()();
  // BoolColumn get status => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Servers extends Table{
  IntColumn get id => integer()();
  TextColumn get descripcion => text()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get pordefecto => integer()();
  // BoolColumn get status => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Lotteries extends Table{
  IntColumn get id => integer()();
  TextColumn get descripcion => text()();
  TextColumn get abreviatura => text()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get status => integer()();
  // BoolColumn get status => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Stocks extends Table{
  IntColumn get id => integer()();
  IntColumn get idBanca => integer()();
  IntColumn get idLoteria => integer()();
  IntColumn get idLoteriaSuperpale => integer().nullable()();
  IntColumn get idSorteo => integer()();
  TextColumn get jugada => text()();
  RealColumn get montoInicial => real()();
  RealColumn get monto => real()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get esBloqueoJugada => integer()();
  IntColumn get esGeneral => integer()();
  IntColumn get ignorarDemasBloqueos => integer()();
  IntColumn get idMoneda => integer()();
  IntColumn get descontarDelBloqueoGeneral => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Blocksgenerals extends Table{
  IntColumn get id => integer()();
  IntColumn get idDia => integer()();
  IntColumn get idLoteria => integer()();
  IntColumn get idSorteo => integer()();
  RealColumn get monto => real()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get idMoneda => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Blockslotteries extends Table{
  IntColumn get id => integer()();
  IntColumn get idBanca => integer()();
  IntColumn get idDia => integer()();
  IntColumn get idLoteria => integer()();
  IntColumn get idSorteo => integer()();
  RealColumn get monto => real()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get idMoneda => integer()();
  IntColumn get descontarDelBloqueoGeneral => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Blocksplays extends Table{
  IntColumn get id => integer()();
  IntColumn get idBanca => integer()();
  IntColumn get idLoteria => integer()();
  IntColumn get idSorteo => integer()();
  TextColumn get jugada => text()();
  RealColumn get monto => real()();
  RealColumn get montoInicial => real()();
  DateTimeColumn get created_at => dateTime().nullable()();
  DateTimeColumn get fechaDesde => dateTime().nullable()();
  DateTimeColumn get fechaHasta => dateTime().nullable()();
  IntColumn get ignorarDemasBloqueos => integer()();
  IntColumn get status => integer()();
  IntColumn get idMoneda => integer()();
  IntColumn get descontarDelBloqueoGeneral => integer()();

  @override
  Set<Column> get primaryKey => {id};
}


class Blocksplaysgenerals extends Table{
  IntColumn get id => integer()();
  IntColumn get idLoteria => integer()();
  IntColumn get idSorteo => integer()();
  TextColumn get jugada => text()();
  RealColumn get monto => real()();
  RealColumn get montoInicial => real()();
  DateTimeColumn get created_at => dateTime().nullable()();
  DateTimeColumn get fechaDesde => dateTime().nullable()();
  DateTimeColumn get fechaHasta => dateTime().nullable()();
  IntColumn get ignorarDemasBloqueos => integer()();
  IntColumn get status => integer()();
  IntColumn get idMoneda => integer()();

  @override
  Set<Column> get primaryKey => {id};
}


class Draws extends Table{
  IntColumn get id => integer()();
  TextColumn get descripcion => text()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get bolos => integer()();
  IntColumn get cantidadNumeros => integer()();
  IntColumn get status => integer()();
  // BoolColumn get status => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}


class Blocksdirtys extends Table{
  IntColumn get id => integer()();
  IntColumn get idBanca => integer()();
  IntColumn get idLoteria => integer()();
  IntColumn get idSorteo => integer()();
  IntColumn get cantidad => integer()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get idMoneda => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class Blocksdirtygenerals extends Table{
  IntColumn get id => integer()();
  IntColumn get idLoteria => integer()();
  IntColumn get idSorteo => integer()();
  IntColumn get cantidad => integer()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get idMoneda => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Tasks, Permissions, Days, Lotteries, Users, Settings, Branchs, Servers, Stocks, Blocksgenerals, Blockslotteries, Blocksplays, Blocksplaysgenerals, Draws, Blocksdirtys, Blocksdirtygenerals])
class AppDatabase extends _$AppDatabase{
  // AppDatabase() : super(WebDatabase('app', logStatements: true));
  AppDatabase(QueryExecutor e) : super(e);

  @override
  // TODO: implement schemaVersion
  int get schemaVersion => 1;

  Future<List<Task>> getAllTasks() => select(tasks).get();
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();
  Future insertTask(Task task) => into(tasks).insert(task);
  Future updateTask(Task task) => update(tasks).replace(task);
  Future deleteTask(Task task) => delete(tasks).delete(task);
  Future<void> insertListTask(List<Task> listTask) {
    return batch((b) => b.insertAllOnConflictUpdate(tasks, listTask));
  }

  Future insertPermission(Permission permission) => into(permissions).insert(permission);
  Future<void> insertListPermission(List<Permiso> permisos) async {
    List<Permission> listPermission = permisos.map((e) => Permission(descripcion: e.descripcion, status: e.status, id: e.id, created_at: e.created_at, idTipo: e.idTipo)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(permissions, listPermission));
  }
  Future deleteAllPermission() => customStatement("delete from permissions");
  Future<bool> existePermiso(String permiso) async {
    var p = await ((select(permissions)..where((p) => p.descripcion.equals(permiso))).getSingleOrNull());
    // print("moor_Database existePermiso: ${p.toJson()}");
    return p != null;
  }
  Future<bool> existePermisos(List<String> permisos) async {
    // var p = await ((select(permissions)..where((p) => p.descripcion.equals(permiso))).getSingleOrNull());
    var data = await customSelect('SELECT id from Permissions  WHERE descripcion IN (\'' +(permisos.join('\',\'')).toString() +'\')').get();
    // print("moor_Database existePermiso: ${p.toJson()}");
    return data != null ? data.length == permisos.length : false;
  }

  Future insertDay(Day day) => into(days).insert(day);
  Future<void> insertListDay(List<Dia> dias) async {
    List<Day> list = dias.map((e) => Day(id: e.id, descripcion: e.descripcion, horaApertura: e.horaApertura, horaCierre: e.horaCierre, wday: e.wday, created_at: e.created_at)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(days, list));
  }
  Future deleteAllDays() => customStatement("delete from days");
  

  Future insertBranch(Branch branch) => into(branchs).insert(branch);
  Future updateBranch(Branch branch) => update(branchs).replace(branch);
  Future deleteBranch(Branch branch) => delete(branchs).delete(branch);
  Future deleteAllBranches() => customStatement("delete from branches");
  Future<Map<String, dynamic>> getBanca() async {
    var map = (await ((select(branchs)..limit(1)).getSingleOrNull()));
    return map != null ? map.toJson() : null;
  }
  Future<int> getIdBanca() async {
    Branch e = await ((select(branchs)..limit(1)).getSingleOrNull());
    return (e != null) ? e.id : 0;
  }
  Future<int> idBanca() async {
    Branch e = await ((select(branchs)..limit(1)).getSingleOrNull());
    return (e != null) ? e.id : 0;
  }

  Future insertUser(User user) => into(users).insert(user);
  Future updateUser(User user) => update(users).replace(user);
  Future deleteUser(User user) => delete(users).delete(user);
  Future deleteAllUser() => customStatement("delete from users");
  Future<Map<String, dynamic>> getUsuario() async {
    var map = (await ((select(users)..limit(1)).getSingleOrNull()));
    return map != null ? map.toJson() : null;
  }
  Future<int> getIdUsuario() async {
    User e = await ((select(users)..limit(1)).getSingleOrNull());
    return (e != null) ? e.id : 0;
  }
  Future<int> idUsuario() async {
    User e = await ((select(users)..limit(1)).getSingleOrNull());
    return (e != null) ? e.id : 0;
  }
  Future<int> idGrupo() async {
    User e = await ((select(users)..limit(1)).getSingleOrNull());
    return (e != null) ? e.idGrupo : 0;
  }

  Future insertLotterie(Lotterie lotterie) => into(lotteries).insert(lotterie);
  Future updateLotterie(Lotterie lotterie) => update(lotteries).replace(lotterie);
  Future deleteLotterie(Lotterie lotterie) => delete(lotteries).delete(lotterie);
  Future deleteAllLotterie() => customStatement("delete from lotteries");
  Future<void> insertListLoteria(List<Loteria> loterias) async {
    List<Lotterie> list = loterias.map((e) => Lotterie(id: e.id, descripcion: e.descripcion, status: e.status, abreviatura: e.abreviatura)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(lotteries, list));
  }
  

  Future insertSetting(Setting setting) => into(settings).insert(setting);
  Future updateSetting(Setting setting) => update(settings).replace(setting);
  Future deleteSetting(Setting setting) => delete(settings).delete(setting);
  Future deleteAllSetting() => customStatement("delete from settings");
  Future<Map<String, dynamic>> getSetting() async {
    var map = (await ((select(settings)..limit(1)).getSingleOrNull()));
    return map != null ? map.toJson() : null;
  }
  Future<Map<String, dynamic>> ajustes() async {
    var map = (await ((select(settings)..limit(1)).getSingleOrNull()));
    return map != null ? map.toJson() : null;
  }

  Future<List<Server>> getAllServer() => select(servers).get();
  Future insertServer(Server element) => into(servers).insert(element);
  Future updateServer(Server element) => update(servers).replace(element);
  Future deleteServer(Server element) => delete(servers).delete(element);
  Future<void> insertListServer(List<Servidor> permisos) async {
    List<Server> listServer = permisos.map((e) => Server(descripcion: e.descripcion, id: e.id, pordefecto: e.pordefecto)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(servers, listServer));
  }
  Future<String> servidor() async {
    User e = await ((select(users)..limit(1)).getSingleOrNull());
    return (e != null) ? e.servidor : null;
  }

  
  Future<void> deleteAllTables() async {
    // return await batch((b) => b.insertAllOnConflictUpdate(servers, listServer));
    await batch((b) {
      b.customStatement("delete from users", []);
      b.customStatement("delete from settings", []);
      b.customStatement("delete from branchs", []);
      b.customStatement("delete from permissions", []);
      b.customStatement("delete from servers", []);
      b.customStatement("delete from stocks", []);
      b.customStatement("delete from blocksgenerals", []);
      b.customStatement("delete from blockslotteries", []);
      b.customStatement("delete from blocksplays", []);
      b.customStatement("delete from blocksplaysgenerals", []);
      b.customStatement("delete from draws", []);
      b.customStatement("delete from blocksdirtys", []);
      b.customStatement("delete from blocksdirtygenerals", []);
    });
  }

  Future<void> insertAllBlocks(Map<String, dynamic> elements) async {
    List<Stock> listElementStock = List();
    List<Blocksgeneral> listElementBlocksgeneral = List();
    List<Blockslotterie> listElementBlockslotterie = List();
    List<Blocksplay> listElementBlocksplay = List();
    List<Blocksplaysgeneral> listElementBlocksplaysgeneral = List();
    List<Draw> listElementDraw = List();
    List<Blocksdirtygeneral> listElementBlocksdirtygeneral = List();
    List<Blocksdirty> listElementBlocksdirty = List();

    if(elements["stocks"] != null)
      listElementStock = elements["stocks"].map<Stock>((e){
        e = StockModel.Stock.fromMap(e);
        return Stock(id: e.id, idBanca: e.idBanca, idLoteria: e.idLoteria, idLoteriaSuperpale: e.idLoteriaSuperpale, idSorteo: e.idSorteo, jugada: e.jugada, montoInicial: e.montoInicial, monto: e.monto, created_at: e.created_at, esBloqueoJugada: e.esBloqueoJugada, esGeneral: e.esGeneral, ignorarDemasBloqueos: e.ignorarDemasBloqueos, idMoneda: e.idMoneda,);
      }).toList();
    if(elements['blocksgenerals'] != null)
      listElementBlocksgeneral = elements['blocksgenerals'].map<Blocksgeneral>((e) {
        e = BlocksgeneralsModel.Blocksgenerals.fromMap(e);
        return Blocksgeneral(id: e.id, idDia: e.idDia, idLoteria: e.idLoteria, idSorteo: e.idSorteo, monto: e.monto, created_at: e.created_at, idMoneda: e.idMoneda,);
      }).toList();
    if(elements['blockslotteries'] != null)
      listElementBlockslotterie = elements['blockslotteries'].map<Blockslotterie>((e) {
        e = BlockslotteriesModel.Blockslotteries.fromMap(e);
        return Blockslotterie(id: e.id, idBanca: e.idBanca, idDia: e.idDia, idLoteria: e.idLoteria, idSorteo: e.idSorteo, monto: e.monto, created_at: e.created_at, idMoneda: e.idMoneda,);
      }).toList();
    if(elements['blocksplays'] != null)
      listElementBlocksplay = elements['blocksplays'].map<Blocksplay>((e) {
        e = BlocksplaysModel.Blocksplays.fromMap(e);
        return Blocksplay(id: e.id, idBanca: e.idBanca, idLoteria: e.idLoteria, idSorteo: e.idSorteo, jugada: e.jugada, montoInicial: e.montoInicial, monto: e.monto, created_at: e.created_at, status: e.status, fechaDesde: e.fechaDesde, fechaHasta: e.fechaHasta, ignorarDemasBloqueos: e.ignorarDemasBloqueos, idMoneda: e.idMoneda,);
      }).toList();
    if(elements['blocksplaysgenerals'] != null)
      listElementBlocksplaysgeneral = elements['blocksplaysgenerals'].map<Blocksplaysgeneral>((e){
        e = BlocksplaysgeneralsModel.Blocksplaysgenerals.fromMap(e);
        return Blocksplaysgeneral(id: e.id, idLoteria: e.idLoteria, idSorteo: e.idSorteo, jugada: e.jugada, montoInicial: e.montoInicial, monto: e.monto, created_at: e.created_at, status: e.status, fechaDesde: e.fechaDesde, fechaHasta: e.fechaHasta, ignorarDemasBloqueos: e.ignorarDemasBloqueos, idMoneda: e.idMoneda,);
      }).toList();
    if(elements['draws'] != null)
      listElementDraw = elements['draws'].map<Draw>((e) {
        e = DrawsModel.Draws.fromMap(e);
        return Draw(descripcion: e.descripcion, bolos: e.bolos, cantidadNumeros: e.cantidadNumeros, status: e.status, id: e.id, created_at: e.created_at);
      }).toList();
    if(elements['blocksdirtygenerals'] != null)
      listElementBlocksdirtygeneral = elements['blocksdirtygenerals'].map<Blocksdirtygeneral>((e) {
        e = BlocksdirtygeneralsModel.Blocksdirtygenerals.fromMap(e);
        return Blocksdirtygeneral(id: e.id, idLoteria: e.idLoteria, idSorteo: e.idSorteo, cantidad: e.cantidad, created_at: e.created_at, idMoneda: e.idMoneda,);
      }).toList();
    if(elements['blocksdirty'] != null)
      listElementBlocksdirty = elements['blocksdirty'].map<Blocksdirty>((e) {
        e = BlocksdirtyModel.Blocksdirty.fromMap(e);
        return Blocksdirty(id: e.id, idBanca: e.idBanca, idLoteria: e.idLoteria, idSorteo: e.idSorteo, cantidad: e.cantidad, created_at: e.created_at, idMoneda: e.idMoneda,);
      }).toList();
      
    return await batch((b){
      if(listElementStock.length > 0)
        b.insertAllOnConflictUpdate(stocks, listElementStock);
      if(listElementBlocksgeneral.length > 0)
        b.insertAllOnConflictUpdate(blocksgenerals, listElementBlocksgeneral);
      if(listElementBlockslotterie.length > 0)
        b.insertAllOnConflictUpdate(blockslotteries, listElementBlockslotterie);
      if(listElementBlocksplay.length > 0)
        b.insertAllOnConflictUpdate(blocksplays, listElementBlocksplay);
      if(listElementBlocksplaysgeneral.length > 0)
        b.insertAllOnConflictUpdate(blocksplaysgenerals, listElementBlocksplaysgeneral);
      if(listElementDraw.length > 0)
        b.insertAllOnConflictUpdate(draws, listElementDraw);
      if(listElementBlocksdirtygeneral.length > 0)
        b.insertAllOnConflictUpdate(blocksdirtygenerals, listElementBlocksdirtygeneral);
      if(listElementBlocksdirty.length > 0)
        b.insertAllOnConflictUpdate(blocksdirtys, listElementBlocksdirty);
    });
  }


  Future insertOrReplaceStock(Stock element) => into(stocks).insert(element, mode: InsertMode.insertOrReplace);
  Future updateStock(Stock element) => update(stocks).replace(element);
  Future deleteStock(Stock element) => delete(stocks).delete(element);
  Future<void> insertListStock(List<StockModel.Stock> elements) async {
    List<Stock> listElement = elements.map((e) => Stock(id: e.id, idBanca: e.idBanca, idLoteria: e.idLoteria, idLoteriaSuperpale: e.idLoteriaSuperpale, idSorteo: e.idSorteo, jugada: e.jugada, montoInicial: e.montoInicial, monto: e.monto, created_at: e.created_at, esBloqueoJugada: e.esBloqueoJugada, esGeneral: e.esGeneral, ignorarDemasBloqueos: e.ignorarDemasBloqueos, idMoneda: e.idMoneda, descontarDelBloqueoGeneral: e.descontarDelBloqueoGeneral)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(stocks, listElement));
  }
  Future<Map<String, dynamic>> getStockMonto({int idBanca, @required int idLoteria, @required int idSorteo, @required String jugada, @required int esGeneral, @required int idMoneda, int ignorarDemasBloqueos, int idLoteriaSuperpale}) async {
    String query = "";
    if(idBanca != null)
      query += " and id_banca = $idBanca";
    if(ignorarDemasBloqueos != null)
      query += " and ignorar_demas_bloqueos = $ignorarDemasBloqueos";
    if(idLoteriaSuperpale != null)
      query += " and id_Loteria_Superpale = $idLoteriaSuperpale";

    String allQuery = "select monto, ignorar_demas_bloqueos as ignorarDemasBloqueos from stocks where id_loteria = $idLoteria and id_sorteo = $idSorteo and jugada = '$jugada' and es_general = $esGeneral and id_moneda = $idMoneda $query order by id desc limit 1";

    QueryRow data = await customSelect(allQuery, readsFrom: {stocks}).getSingleOrNull();
    return (data == null) ? null : data.data;
    // Stock e = await ((select(stocks)..where((e) => e.idBanca.equals(idBanca) & e.idLoteria.equals(idLoteria) & e.idSorteo.equals(idSorteo) & e.jugada.equals(jugada) & e.esGeneral.equals(esGeneral) & e.idMoneda.equals(idMoneda))
    //   ..orderBy([
    //     (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)
    //   ])
    // ).getSingleOrNull());
    // return (e != null) ? e.monto : null;
  }
  Future<Map<String, dynamic>> getStockMontoAndIgnorarDemasBloqueos({int idBanca, @required int idLoteria, @required int idSorteo, @required String jugada, @required int esGeneral, @required int idMoneda, int ignorarDemasBloqueos, int idLoteriaSuperpale}) async {
    String query = "";
    if(idBanca != null)
      query += " and id_Banca = $idBanca";
    if(ignorarDemasBloqueos != null)
      query += " and ignorar_Demas_Bloqueos = $ignorarDemasBloqueos";
    if(idLoteriaSuperpale != null)
      query += " and idLoteriaSuperpale = $idLoteriaSuperpale";

    QueryRow data = await customSelect("select monto, ignorar_demas_bloqueos as ignorarDemasBloqueos from stocks where id_Loteria = $idLoteria and id_Sorteo = $idSorteo and jugada = '$jugada' and es_General = $esGeneral and id_Moneda = $idMoneda $query order by id desc limit 1", readsFrom: {stocks}).getSingleOrNull();
    return (data == null) ? null : {
      "monto" : data.read<double>("monto"),
      "ignorarDemasBloqueos" : data.read<int>("ignorarDemasBloqueos"),
    };
  }
  Future insertOrDeleteStocks(List<StockModel.Stock> elements, bool delete) async {
    List<Stock> list = elements.map<Stock>((e) => Stock(
            id: e.id, 
            idBanca: e.idBanca,
            idLoteria: e.idLoteria,
            idLoteriaSuperpale: e.idLoteriaSuperpale,
            idSorteo: e.idSorteo,
            jugada: e.jugada,
            montoInicial: e.montoInicial,
            monto: e.monto,
            created_at: e.created_at,
            esBloqueoJugada: e.esBloqueoJugada,
            esGeneral: e.esGeneral,
            ignorarDemasBloqueos: e.ignorarDemasBloqueos,
            idMoneda: e.idMoneda,
            descontarDelBloqueoGeneral: e.descontarDelBloqueoGeneral,
          )).toList();
   await batch((batch){
      if(!delete)
        batch.insertAll(stocks, list, mode: InsertMode.insertOrReplace);
      else{
        // for (var item in list) () => batch.delete(stocks, item);
        for (var item in list) {
          batch.delete(stocks, item);
        }
      }
   });
  }
  // Future<int> idDraw(String descripcion) async {
  //   Draw e = await ((select(draws)..where((e) => e.descripcion.equals(descripcion))..limit(1)).getSingleOrNull());
  //   return (e != null) ? e.id : 0;
  // }

  Future insertOrReplaceBlocksgeneral(Blocksgeneral element) => into(blocksgenerals).insert(element, mode: InsertMode.insertOrReplace);
  Future updateBlocksgeneral(Blocksgeneral element) => update(blocksgenerals).replace(element);
  Future deleteBlocksgeneral(Blocksgeneral element) => delete(blocksgenerals).delete(element);
  Future<void> insertListBlocksgeneral(List<BlocksgeneralsModel.Blocksgenerals> elements) async {
    List<Blocksgeneral> listElement = elements.map((e) => Blocksgeneral(id: e.id, idDia: e.idDia, idLoteria: e.idLoteria, idSorteo: e.idSorteo, monto: e.monto, created_at: e.created_at, idMoneda: e.idMoneda,)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(blocksgenerals, listElement));
  }
  Future<Map<String, dynamic>> getBlocksgeneralMonto({@required int idLoteria, @required int idSorteo, @required int idDia, @required int idMoneda}) async {
    QueryRow data = await customSelect("select * from blocksgenerals where id_Loteria = $idLoteria and id_Sorteo = $idSorteo and id_Dia = $idDia and id_Moneda = $idMoneda order by id desc limit 1", readsFrom: {blocksgenerals}).getSingleOrNull();
    return (data == null) ? null : data.data;
  }
  Future insertOrDeleteBlocksgenerals(List<BlocksgeneralsModel.Blocksgenerals> elements, bool delete) async {
    List<Blocksgeneral> list = elements.map<Blocksgeneral>((e) => Blocksgeneral(
            id: e.id, 
            idDia: e.idDia, 
            idLoteria: e.idLoteria, 
            idSorteo: e.idSorteo, 
            monto: e.monto, 
            created_at: e.created_at, 
            idMoneda: e.idMoneda, 
          )).toList();


    await batch((batch){
      if(!delete)
        batch.insertAll(blocksgenerals, list, mode: InsertMode.insertOrReplace);
      else{
        // for (var item in list) () => batch.delete(blocksgenerals, item);
        for (var item in list) {
          batch.delete(blocksgenerals, item);
        }
      }
   });
  }

  Future insertOrReplaceBlockslotterie(Blockslotterie element) => into(blockslotteries).insert(element, mode: InsertMode.insertOrReplace);
  Future updateBlockslotterie(Blockslotterie element) => update(blockslotteries).replace(element);
  Future deleteBlockslotterie(Blockslotterie element) => delete(blockslotteries).delete(element);
  Future<void> insertListBlockslotterie(List<BlockslotteriesModel.Blockslotteries> elements) async {
    List<Blockslotterie> listElement = elements.map((e) => Blockslotterie(id: e.id, idBanca: e.idBanca, idDia: e.idDia, idLoteria: e.idLoteria, idSorteo: e.idSorteo, monto: e.monto, created_at: e.created_at, idMoneda: e.idMoneda, descontarDelBloqueoGeneral: e.descontarDelBloqueoGeneral)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(blockslotteries, listElement));
  }
  Future<Map<String, dynamic>> getBlockslotterieMonto({@required int idBanca, @required int idLoteria, @required int idSorteo, @required int idDia, @required int idMoneda}) async {
    QueryRow data = await customSelect("select * from blockslotteries where id_Banca = $idBanca and id_Loteria = $idLoteria and id_Sorteo = $idSorteo and id_Dia = $idDia and id_Moneda = $idMoneda order by id desc limit 1", readsFrom: {blockslotteries}).getSingleOrNull();
    return (data == null) ? null : data.data;
  }
  Future insertOrDeleteBlockslotteries(List<BlockslotteriesModel.Blockslotteries> elements, bool delete) async {
    List<Blockslotterie> list = elements.map<Blockslotterie>((e) => Blockslotterie(
            id: e.id, 
            idBanca: e.idBanca, 
            idDia: e.idDia, 
            idLoteria: e.idLoteria, 
            idSorteo: e.idSorteo, 
            monto: e.monto, 
            created_at: e.created_at, 
            idMoneda: e.idMoneda, 
            descontarDelBloqueoGeneral: e.descontarDelBloqueoGeneral, 
          )).toList();
   await batch((batch){
      if(!delete)
        batch.insertAll(blockslotteries, list, mode: InsertMode.insertOrReplace);
      else{
        // for (var item in list) () => batch.delete(blockslotteries, item);
        for (var item in list) {
          batch.delete(blockslotteries, item);
        }
      }
   });
  }


  Future insertOrReplaceBlocksplay(Blocksplay element) => into(blocksplays).insert(element, mode: InsertMode.insertOrReplace);
  Future updateBlocksplay(Blocksplay element) => update(blocksplays).replace(element);
  Future deleteBlocksplay(Blocksplay element) => delete(blocksplays).delete(element);
  Future<void> insertListBlocksplay(List<BlocksplaysModel.Blocksplays> elements) async {
    List<Blocksplay> listElement = elements.map((e) => Blocksplay(id: e.id, idBanca: e.idBanca, idLoteria: e.idLoteria, idSorteo: e.idSorteo, jugada: e.jugada, montoInicial: e.montoInicial, monto: e.monto, created_at: e.created_at, status: e.status, fechaDesde: e.fechaDesde, fechaHasta: e.fechaHasta, ignorarDemasBloqueos: e.ignorarDemasBloqueos, idMoneda: e.idMoneda, descontarDelBloqueoGeneral: e.descontarDelBloqueoGeneral)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(blocksplays, listElement));
  }
  Future<Map<String, dynamic>> getBlocksplayMonto({@required int idBanca, @required int idLoteria, @required int idSorteo, @required String jugada, @required int idMoneda, int status = 1}) async {
    QueryRow data = await customSelect("select * from blocksplays where id_Banca = $idBanca and id_Loteria = $idLoteria and id_Sorteo = $idSorteo and jugada = '$jugada' and id_Moneda = $idMoneda and status = $status order by id desc limit 1", readsFrom: {blocksplays}).getSingleOrNull();
    return (data == null) ? null : data.data;
  }
  Future insertOrDeleteBlocksplays(List<BlocksplaysModel.Blocksplays> elements, bool delete) async {
    List<Blocksplay> list = elements.map<Blocksplay>((e) => Blocksplay(
            id: e.id, 
            idBanca: e.idBanca, 
            idLoteria: e.idLoteria, 
            idSorteo: e.idSorteo, 
            jugada: e.jugada, 
            montoInicial: e.montoInicial, 
            monto: e.monto, 
            fechaDesde: e.fechaDesde, 
            fechaHasta: e.fechaHasta, 
            created_at: e.created_at, 
            ignorarDemasBloqueos: e.ignorarDemasBloqueos, 
            status: e.status, 
            idMoneda: e.idMoneda, 
            descontarDelBloqueoGeneral: e.descontarDelBloqueoGeneral, 
          )).toList();
    print("drift_database insertOrDeleteBlocksplays: ${list.length}");
   await batch((batch){
      if(!delete)
        batch.insertAll(blocksplays, list, mode: InsertMode.insertOrReplace);
      else{
        // for (var item in list) () => batch.delete(blocksplays, item);
        for (var item in list) {
          batch.delete(blocksplays, item);
        }
      }
   });
  }

  Future insertOrReplaceBlocksplaysgeneral(Blocksplaysgeneral element) => into(blocksplaysgenerals).insert(element, mode: InsertMode.insertOrReplace);
  Future updateBlocksplaysgeneral(Blocksplaysgeneral element) => update(blocksplaysgenerals).replace(element);
  Future deleteBlocksplaysgeneral(Blocksplaysgeneral element) => delete(blocksplaysgenerals).delete(element);
  Future<void> insertListBlocksplaysgeneral(List<BlocksplaysgeneralsModel.Blocksplaysgenerals> elements) async {
    List<Blocksplaysgeneral> listElement = elements.map((e) => Blocksplaysgeneral(id: e.id, idLoteria: e.idLoteria, idSorteo: e.idSorteo, jugada: e.jugada, montoInicial: e.montoInicial, monto: e.monto, created_at: e.created_at, status: e.status, fechaDesde: e.fechaDesde, fechaHasta: e.fechaHasta, ignorarDemasBloqueos: e.ignorarDemasBloqueos, idMoneda: e.idMoneda,)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(blocksplaysgenerals, listElement));
  }
  Future<Map<String, dynamic>> getBlocksplaysgeneralMontoAndIgnorarDemasBloqueos({@required int idLoteria, @required int idSorteo, @required String jugada, @required int idMoneda, int status = 1}) async {
    QueryRow data = await customSelect("select * from blocksplaysgenerals where id_Loteria = $idLoteria and id_Sorteo = $idSorteo and jugada = '$jugada' and id_Moneda = $idMoneda and status = $status order by id desc limit 1", readsFrom: {blocksplaysgenerals}).getSingleOrNull();
    return (data == null) ? null : {
      "monto" : data.read<double>("monto"),
      "ignorarDemasBloqueos" : data.read<int>("ignorarDemasBloqueos"),
    };
  }
  Future<Map<String, dynamic>> getBlocksplaysgeneralMonto({@required int idLoteria, @required int idSorteo, @required String jugada, @required int idMoneda, int status = 1}) async {
    QueryRow data = await customSelect("select monto, ignorar_demas_bloqueos as ignorarDemasBloqueos from blocksplaysgenerals where id_Loteria = $idLoteria and id_Sorteo = $idSorteo and jugada = '$jugada' and id_Moneda = $idMoneda and status = $status order by id desc limit 1", readsFrom: {blocksplaysgenerals}).getSingleOrNull();
    return (data == null) ? null : data.data;
  }
  Future insertOrDeleteBlocksplaysgenerals(List<BlocksplaysgeneralsModel.Blocksplaysgenerals> elements, bool delete) async {
    List<Blocksplaysgeneral> list = elements.map<Blocksplaysgeneral>((e) => Blocksplaysgeneral(
            id: e.id, 
            idLoteria: e.idLoteria, 
            idSorteo: e.idSorteo, 
            jugada: e.jugada, 
            montoInicial: e.montoInicial, 
            monto: e.monto, 
            fechaDesde: e.fechaDesde, 
            fechaHasta: e.fechaHasta, 
            created_at: e.created_at, 
            ignorarDemasBloqueos: e.ignorarDemasBloqueos, 
            status: e.status, 
            idMoneda: e.idMoneda, 
          )).toList();
   await batch((batch){
      if(!delete)
        batch.insertAll(blocksplaysgenerals, list, mode: InsertMode.insertOrReplace);
      else{
        // for (var item in list) () => batch.delete(blocksplaysgenerals, item);
        for (var item in list) {
          batch.delete(blocksplaysgenerals, item);
        }
      }
   });
  }

  Future insertDraw(Draw element) => into(draws).insert(element);
  Future updateDraw(Draw element) => update(draws).replace(element);
  Future deleteDraw(Draw element) => delete(draws).delete(element);
  Future<void> insertListDraw(List<Draw> elements) async {
    List<Draw> listElement = elements.map((e) => Draw(descripcion: e.descripcion, bolos: e.bolos, cantidadNumeros: e.cantidadNumeros, status: e.status, id: e.id, created_at: e.created_at)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(draws, listElement));
  }
  Future<int> idDraw(String descripcion) async {
    Draw e = await ((select(draws)..where((e) => e.descripcion.equals(descripcion))..limit(1)).getSingleOrNull());
    return (e != null) ? e.id : 0;
  }
  Future<Map<String, dynamic>> draw(String descripcion) async {
    Draw e = await ((select(draws)..where((e) => e.descripcion.equals(descripcion))..limit(1)).getSingleOrNull());
    return (e != null) ? e.toJson() : null;
  }
  Future<Map<String, dynamic>> drawById(int id) async {
    Draw e = await ((select(draws)..where((e) => e.id.equals(id))..limit(1)).getSingleOrNull());
    return (e != null) ? e.toJson() : null;
  }

  Future insertOrReplaceBlocksdirty(Blocksdirty element) => into(blocksdirtys).insert(element, mode: InsertMode.insertOrReplace);
  Future updateBlocksdirty(Blocksdirty element) => update(blocksdirtys).replace(element);
  Future deleteBlocksdirty(Blocksdirty element) => delete(blocksdirtys).delete(element);
  Future<void> insertListBlocksdirty(List<BlocksdirtyModel.Blocksdirty> elements) async {
    List<Blocksdirty> listElement = elements.map((e) => Blocksdirty(id: e.id, idBanca: e.idBanca, idLoteria: e.idLoteria, idSorteo: e.idSorteo, cantidad: e.cantidad, created_at: e.created_at, idMoneda: e.idMoneda,)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(blocksdirtys, listElement));
  }
  Future<int> getBlocksdirtyCantidad({@required int idBanca, @required int idLoteria, @required int idSorteo, @required int idMoneda}) async {
    Blocksdirty e = await ((select(blocksdirtys)..where((e) => e.idBanca.equals(idBanca) & e.idLoteria.equals(idLoteria) & e.idSorteo.equals(idSorteo) & e.idMoneda.equals(idMoneda))
      ..orderBy([
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)
      ])
    ).getSingleOrNull());
    return (e != null) ? e.cantidad : null;
  }
  Future insertOrDeleteBlocksdirtys(List<BlocksdirtyModel.Blocksdirty> elements, bool delete) async {
    List<Blocksdirty> list = elements.map<Blocksdirty>((e) => Blocksdirty(
            id: e.id, 
            idBanca: e.idBanca, 
            idLoteria: e.idLoteria, 
            idSorteo: e.idSorteo, 
            cantidad: e.cantidad, 
            created_at: e.created_at, 
            idMoneda: e.idMoneda, 
          )).toList();
   await batch((batch){
      if(!delete)
        batch.insertAll(blocksdirtys, list, mode: InsertMode.insertOrReplace);
      else{
        // for (var item in list) () => batch.delete(blocksdirtys, item);
        for (var item in list) {
          batch.delete(blocksdirtys, item);
        }
      }
   });
  }

  Future insertOrReplaceBlocksdirtygeneral(Blocksdirtygeneral element) => into(blocksdirtygenerals).insert(element, mode: InsertMode.insertOrReplace);
  Future updateBlocksdirtygeneral(Blocksdirtygeneral element) => update(blocksdirtygenerals).replace(element);
  Future deleteBlocksdirtygeneral(Blocksdirtygeneral element) => delete(blocksdirtygenerals).delete(element);
  Future<void> insertListBlocksdirtygeneral(List<BlocksdirtygeneralsModel.Blocksdirtygenerals> elements) async {
    List<Blocksdirtygeneral> listElement = elements.map((e) => Blocksdirtygeneral(id: e.id, idLoteria: e.idLoteria, idSorteo: e.idSorteo, cantidad: e.cantidad, created_at: e.created_at, idMoneda: e.idMoneda,)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(blocksdirtygenerals, listElement));
  }
  Future<int> getBlocksdirtygeneralCantidad({@required int idLoteria, @required int idSorteo, @required int idMoneda}) async {
    Blocksdirtygeneral e = await ((select(blocksdirtygenerals)..where((e) => e.idLoteria.equals(idLoteria) & e.idSorteo.equals(idSorteo) & e.idMoneda.equals(idMoneda))
      ..orderBy([
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)
      ])
    ).getSingleOrNull());
    return (e != null) ? e.cantidad : null;
  }
  Future insertOrDeleteBlocksdirtygenerals(List<BlocksdirtygeneralsModel.Blocksdirtygenerals> elements, bool delete) async {
    List<Blocksdirtygeneral> list = elements.map<Blocksdirtygeneral>((e) => Blocksdirtygeneral(
            id: e.id, 
            idLoteria: e.idLoteria, 
            idSorteo: e.idSorteo, 
            cantidad: e.cantidad, 
            created_at: e.created_at, 
            idMoneda: e.idMoneda, 
          )).toList();
   await batch((batch){
      if(!delete)
        batch.insertAll(blocksdirtygenerals, list, mode: InsertMode.insertOrReplace);
      else{
        // for (var item in list) () => batch.delete(blocksdirtygenerals, item);
        for (var item in list) {
          batch.delete(blocksdirtygenerals, item);
        }
      }
   });
  }


  Future sincronizarTodosDataBatch(var parsed) async {
    await batch((batch){
      if(parsed['stocks'] != null){
        print('dentro stocks: ${parsed['stocks']}');

          List<Stock> lista = parsed['stocks'].map<Stock>((json) => Stock(
            id: Utils.toInt(json["id"]), 
            idBanca: Utils.toInt(json["idBanca"]),
            idLoteria: Utils.toInt(json["idLoteria"]),
            idLoteriaSuperpale: Utils.toInt(json["idLoteriaSuperpale"], returnNullIfNotInt: true),
            idSorteo: Utils.toInt(json["idSorteo"]),
            jugada: json["jugada"],
            montoInicial: Utils.toDouble(json["montoInicial"]),
            monto: Utils.toDouble(json["monto"]),
            created_at: MyDate.toDateTime(json["created_at"]),
            esBloqueoJugada: Utils.toInt(json["esBloqueoJugada"]),
            esGeneral: Utils.toInt(json["esGeneral"]),
            ignorarDemasBloqueos: Utils.toInt(json["ignorarDemasBloqueos"]),
            idMoneda: Utils.toInt(json["idMoneda"]),
            descontarDelBloqueoGeneral: Utils.toInt(json["descontarDelBloqueoGeneral"]),
          )).toList();
          print('Realtime sincronizarTodosDataBatch length stocks: ${lista.length}');
          // for(Stock s in lista){
          //   // batch.insert("Stocks", s.toJson());
          //   batch.rawInsert(
          //     "insert or replace into Stocks(id, idBanca, idLoteria, idLoteriaSuperpale, idSorteo, jugada, montoInicial, monto, created_at, esBloqueoJugada, esGeneral, ignorarDemasBloqueos, idMoneda) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
          //                                           [s.id, s.idBanca, s.idLoteria, s.idLoteriaSuperpale, s.idSorteo, s.jugada, s.montoInicial, s.monto, s.created_at.toString(), s.esBloqueoJugada, s.esGeneral, s.ignorarDemasBloqueos, s.idMoneda]);
          // }
          batch.insertAll(stocks, lista, mode: InsertMode.replace);
       }

        if(parsed['blocksgenerals'] != null){
          List<Blocksgeneral> listBlocksgenerals = parsed['blocksgenerals'].map<Blocksgeneral>((json) => Blocksgeneral(
            id: Utils.toInt(json["id"]), 
            idDia: Utils.toInt(json["idDia"]), 
            idLoteria: Utils.toInt(json["idLoteria"]), 
            idSorteo: Utils.toInt(json["idSorteo"]), 
            monto: Utils.toDouble(json["monto"]), 
            created_at: MyDate.toDateTime(json["created_at"]), 
            idMoneda: Utils.toInt(json["idMoneda"]), 
          )).toList();
          print('Realtime sincronizarTodosDataBatch length blocksgenerals: ${listBlocksgenerals.length}');
          // for(Blocksgenerals b in listBlocksgenerals){
          //   // batch.insert("Blocksgenerals", b.toJson());
          //   batch.rawInsert(
          //     "insert or replace into Blocksgenerals(id, idDia, idLoteria, idSorteo, monto, created_at, idMoneda) values(?, ?, ?, ?, ?, ?, ?)", 
          //                                               [b.id, b.idDia, b.idLoteria, b.idSorteo, b.monto, b.created_at.toString(), b.idMoneda]);
          // }
          batch.insertAll(blocksgenerals, listBlocksgenerals, mode: InsertMode.replace);
        }

        if(parsed['blockslotteries'] != null){
          List<Blockslotterie> listBlockslotteries = parsed['blockslotteries'].map<Blockslotterie>((json) => Blockslotterie(
            id: Utils.toInt(json["id"]), 
            idBanca: Utils.toInt(json["idBanca"]), 
            idDia: Utils.toInt(json["idDia"]), 
            idLoteria: Utils.toInt(json["idLoteria"]), 
            idSorteo: Utils.toInt(json["idSorteo"]), 
            monto: Utils.toDouble(json["monto"]), 
            created_at: MyDate.toDateTime(json["created_at"]), 
            idMoneda: Utils.toInt(json["idMoneda"]), 
            descontarDelBloqueoGeneral: Utils.toInt(json["descontarDelBloqueoGeneral"]), 
          )).toList();
          print('Realtime sincronizarTodosDataBatch length blockslotteries: ${listBlockslotteries.length}');
          // for(Blockslotteries b in listBlockslotteries){
          //   //  batch.insert("Blockslotteries", b.toJson());
          //    batch.rawInsert(
          //     "insert or replace into Blockslotteries(id, idBanca, idDia, idLoteria, idSorteo, monto, created_at, idMoneda) values(?, ?, ?, ?, ?, ?, ?, ?)", 
          //                                               [b.id, b.idBanca, b.idDia, b.idLoteria, b.idSorteo, b.monto, b.created_at.toString(), b.idMoneda]);
          // }
          batch.insertAll(blockslotteries, listBlockslotteries, mode: InsertMode.replace);
        }

        if(parsed['blocksplays'] != null){
          List<Blocksplay> listBlocksplays = parsed['blocksplays'].map<Blocksplay>((json) => Blocksplay(
            id: Utils.toInt(json["id"]), 
            idBanca: Utils.toInt(json["idBanca"]), 
            idLoteria: Utils.toInt(json["idLoteria"]), 
            idSorteo: Utils.toInt(json["idSorteo"]), 
            jugada: json["jugada"], 
            montoInicial: Utils.toDouble(json["montoInicial"]), 
            monto: Utils.toDouble(json["monto"]), 
            fechaDesde: MyDate.toDateTime(json["fechaDesde"]), 
            fechaHasta: MyDate.toDateTime(json["fechaHasta"]), 
            created_at: MyDate.toDateTime(json["created_at"]), 
            ignorarDemasBloqueos: Utils.toInt(json["ignorarDemasBloqueos"]), 
            status: Utils.toInt(json["status"]), 
            idMoneda: Utils.toInt(json["idMoneda"]), 
            descontarDelBloqueoGeneral: Utils.toInt(json["descontarDelBloqueoGeneral"]), 
          )).toList();
          print('Realtime sincronizarTodosDataBatch length blocksplays: ${listBlocksplays.length}');
          // for(Blocksplays b in listBlocksplays){
          //   // batch.insert("Blocksplays", b.toJson());
          //   batch.rawInsert(
          //     "insert or replace into Blocksplays(id, idBanca, idLoteria, idSorteo, jugada, montoInicial, monto, fechaDesde, fechaHasta, created_at, ignorarDemasBloqueos, status, idMoneda) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
          //                                           [b.id, b.idBanca, b.idLoteria, b.idSorteo, b.jugada, b.montoInicial, b.monto, b.fechaDesde.toString(), b.fechaHasta.toString(), b.created_at.toString(), b.ignorarDemasBloqueos, b.status, b.idMoneda]);
          // }
          batch.insertAll(blocksplays, listBlocksplays, mode: InsertMode.replace);
        }

        if(parsed['blocksplaysgenerals'] != null){
          List<Blocksplaysgeneral> listBlocksplaysgenerals = parsed['blocksplaysgenerals'].map<Blocksplaysgeneral>((json) => Blocksplaysgeneral(
            id: Utils.toInt(json["id"]), 
            idLoteria: Utils.toInt(json["idLoteria"]), 
            idSorteo: Utils.toInt(json["idSorteo"]), 
            jugada: json["jugada"], 
            montoInicial: Utils.toDouble(json["montoInicial"]), 
            monto: Utils.toDouble(json["monto"]), 
            fechaDesde: MyDate.toDateTime(json["fechaDesde"]), 
            fechaHasta: MyDate.toDateTime(json["fechaHasta"]), 
            created_at: MyDate.toDateTime(json["created_at"]), 
            ignorarDemasBloqueos: Utils.toInt(json["ignorarDemasBloqueos"]), 
            status: Utils.toInt(json["status"]), 
            idMoneda: Utils.toInt(json["idMoneda"]), 
          )).toList();
          print('Realtime sincronizarTodosDataBatch length blocksplaysgenerals: ${listBlocksplaysgenerals.length}');
          // for(Blocksplaysgenerals b in listBlocksplaysgenerals){
          //   // batch.insert("Blocksplaysgenerals", b.toJson());
          //   batch.rawInsert(
          //     "insert or replace into Blocksplaysgenerals(id, idLoteria, idSorteo, jugada, montoInicial, monto, fechaDesde, fechaHasta, created_at, ignorarDemasBloqueos, status, idMoneda) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", 
          //                                                 [b.id, b.idLoteria, b.idSorteo, b.jugada, b.montoInicial, b.monto, b.fechaDesde.toString(), b.fechaHasta.toString(), b.created_at.toString(), b.ignorarDemasBloqueos, b.status, b.idMoneda]);
          // }
          batch.insertAll(blocksplaysgenerals, listBlocksplaysgenerals, mode: InsertMode.replace);
        }

        if(parsed['draws'] != null){
          List<Draw> listDraws = parsed['draws'].map<Draw>((json) => Draw(
            id: Utils.toInt(json["id"]), 
            descripcion: json["descripcion"], 
            bolos: Utils.toInt(json["bolos"]), 
            cantidadNumeros: Utils.toInt(json["cantidadNumeros"]), 
            status: Utils.toInt(json["status"]), 
            created_at: MyDate.toDateTime(json["created_at"]), 
          )).toList();
          // for(Draws b in listDraws){
          //   // batch.insert("Draws", b.toJson());
          //   batch.rawInsert(
          //     "insert or replace into Draws(id, descripcion, bolos, cantidadNumeros, status, created_at) values(?, ?, ?, ?, ?, ?)", 
          //                                             [b.id, b.descripcion, b.bolos, b.cantidadNumeros, b.status, b.created_at.toString()]);
          // }
          batch.insertAll(draws, listDraws, mode: InsertMode.replace);
        }

        if(parsed['blocksdirtygenerals'] != null){
          List<Blocksdirtygeneral> listBlocksdirtygenerals = parsed['blocksdirtygenerals'].map<Blocksdirtygeneral>((json) => Blocksdirtygeneral(
            id: Utils.toInt(json["id"]), 
            idLoteria: Utils.toInt(json["idLoteria"]), 
            idSorteo: Utils.toInt(json["idSorteo"]), 
            cantidad: Utils.toInt(json["cantidad"]), 
            created_at: MyDate.toDateTime(json["created_at"]), 
            idMoneda: Utils.toInt(json["idMoneda"]), 
          )).toList();
          // for(Blocksdirtygenerals b in listBlocksdirtygenerals){
          //   // batch.insert("Blocksgenerals", b.toJson());
          //   batch.rawInsert(
          //     "insert or replace into Blocksdirtygenerals(id, idLoteria, idSorteo, cantidad, created_at, idMoneda) values(?, ?, ?, ?, ?, ?)", 
          //                                               [b.id, b.idLoteria, b.idSorteo, b.cantidad, b.created_at.toString(), b.idMoneda]);
          // }
          batch.insertAll(blocksdirtygenerals, listBlocksdirtygenerals, mode: InsertMode.replace);
        }

        if(parsed['blocksdirty'] != null){
          List<Blocksdirty> listBlocksdirty = parsed['blocksdirty'].map<Blocksdirty>((json) => Blocksdirty(
            id: Utils.toInt(json["id"]), 
            idBanca: Utils.toInt(json["idBanca"]), 
            idLoteria: Utils.toInt(json["idLoteria"]), 
            idSorteo: Utils.toInt(json["idSorteo"]), 
            cantidad: Utils.toInt(json["cantidad"]), 
            created_at: MyDate.toDateTime(json["created_at"]), 
            idMoneda: Utils.toInt(json["idMoneda"]), 
          )).toList();
          // for(Blocksdirty b in listBlocksdirty){
          //   // batch.insert("Blocksgenerals", b.toJson());
          //   batch.rawInsert(
          //     "insert or replace into Blocksdirty(id, idBanca, idLoteria, idSorteo, cantidad, created_at, idMoneda) values(?, ?, ?, ?, ?, ?, ?)", 
          //                                               [b.id, b.idBanca, b.idLoteria, b.idSorteo, b.cantidad, b.created_at.toString(), b.idMoneda]);
          // }
          batch.insertAll(blocksdirtygenerals, listBlocksdirty, mode: InsertMode.replace);
        }
    });
  }

  Future<void> deleteDB() async {
    // TODO: implement deleteDB
    await deleteAllTables();
  }

  guardarVentaV2({Banca banca, List<Jugada> jugadas, socket, List<Loteria> listaLoteria, bool compartido, int descuentoMonto, currentTimeZone, bool tienePermisoJugarFueraDeHorario, bool tienePermisoJugarMinutosExtras, bool tienePermisoJugarSinDisponibilidad}) async {
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
    await transaction(() async {
    // Batch batch = tx.batch();
    usuario = Usuario.fromMap(await getUsuario());
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

    if(await existePermisos(["Vender tickets", "Acceso al sistema"]) == false)
      throw Exception("No tiene permiso para realizar esta accion vender y acceso");
    print("Realtime guardarVenta after permisos");

    if(await idBanca() != banca.id){
        if(await existePermiso("Jugar como cualquier banca") == false)
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
    sale = Sale(compartido: compartido ? 1 : 0, servidor: await servidor(), idUsuario: usuario.id, idBanca: banca.id, total: total, subTotal: 0, descuentoMonto: descuentoMonto, hayDescuento: descuentoMonto > 0 ? 1 : 0, idTicket: ticket.id, created_at: date);
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
          if(jugada.monto > (await getMontoDisponible(jugada.jugada, jugada.loteria, banca, loteriaSuperpale: jugada.loteriaSuperPale)).monto){
            throw Exception("No hay monto disponible para la jugada ${jugada.jugada} en la loteria ${jugada.loteria.descripcion}");
          }
        }else{
          print("Realtime guardarVenta validarMonto normal");
          if(jugada.monto > jugada.stock.monto){
            throw Exception("No hay monto disponible para la jugada ${jugada.jugada} en la loteria ${jugada.loteria.descripcion}");
          }
        }
        
        var salesdetails = Salesdetails(idVenta: sale.id, idTicket: sale.ticket.id, idLoteria: loteria.id, idSorteo: jugada.idSorteo, sorteoDescripcion: jugada.sorteo, jugada: jugada.jugada, monto: jugada.monto, premio: jugada.premio, comision: 0, idStock: 0, idLoteriaSuperpale: loteriaSuperPale != null ? loteriaSuperPale.id : null, created_at: date, updated_at: date, status: 0, loteria: loteria, loteriaSuperPale: loteriaSuperPale, sorteo: DrawsModel.Draws(jugada.idSorteo, jugada.sorteo, null, null, null, null));
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
  }

  Future<MontoDisponible> getMontoDisponible(String jugada, Loteria loteria, Banca banca, {Loteria loteriaSuperpale, bool retornarStock = false}) async {

    var montoDisponible;

    int idDia = Utils.getIdDia();
    int idSorteo = await SorteoService.getIdSorteo(jugada, loteria);
    String jugadaConSigno = jugada;
    jugada = await SorteoService.esSorteoPickQuitarUltimoCaracter(jugada, idSorteo);
    print("PrincipalView getMontoDisponible banca moneda: ${banca.descripcion}");
    StockModel.Stock stockToReturn;

    if(idSorteo != 4){
      Map<String, dynamic> query = await getStockMonto(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda);

      if(query != null){
        montoDisponible = query['monto'];
        stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query['descontarDelBloqueoGeneral'], esBloqueoJugada: query['esBloqueoJugada']);
      }

      if(montoDisponible != null){
        // query = await Db.database.query('Stocks' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "ignorarDemasBloqueos" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, 1, 1, banca.idMoneda]);
        query = await getStockMonto(idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda);
        if(query != null){
          montoDisponible = query['monto'];
          stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: query['esBloqueoJugada']);
        }else{

          //Ahora nos aseguramos de que el bloqueo general existe y el valor de ignorarDemasBloqueos sea = 1
          // query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          query = await getBlocksplaysgeneralMonto(idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, status: 1, idMoneda: banca.idMoneda);
          if(query != null){
            var first = query;
            if(first["ignorarDemasBloqueos"] == 1){
              montoDisponible = first["monto"];
              stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
            }
          }
        }
      }


      //AQUI ES CUANDO EXISTE BLOQUEO GENERAL EN STOCKS
      if(montoDisponible == null){
        // query = await Db.database.query('Stocks' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda]);
        query = await getStockMonto(idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, idMoneda: banca.idMoneda);
        if(query != null){
          //SI IGNORARDEMASBLOQUEOS ES FALSE ENTONCES VAMOS A VERIFICAR SI EXISTEN BLOQUEOS POR BANCAS YA SEAN DE JUGADAS PARA RETORNAR ESTOS BLOQUEOS
          var stock = query;
          if(stock["ignorarDemasBloqueos"] == 0){
            // query = await Db.database.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            query = await getBlocksplayMonto(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, status: 1, idMoneda: banca.idMoneda);
            if(query != null){
              montoDisponible = query["monto"];
              stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);
            }else{
              // query = await Db.database.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
              query = await getBlockslotterieMonto(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, idDia: idDia, idMoneda: banca.idMoneda);
              if(query != null){
                montoDisponible = query["monto"];
                stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query['descontarDelBloqueoGeneral'],);
              }
              else{
                montoDisponible = stock["monto"];
                stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
              }
            }
          }else{
            montoDisponible = stock["monto"];
            stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
          }
        }
      }



      if(montoDisponible == null){
        // query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
        query = await getBlocksplaysgeneralMonto(idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, status: 1, idMoneda: banca.idMoneda);
        if(query != null){
          var blocksplaysgenerals = query;
          if(blocksplaysgenerals["ignorarDemasBloqueos"] == 0){
            montoDisponible = null;
          }else{
            montoDisponible = blocksplaysgenerals["monto"];
            stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
          }
        }

// query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ?', whereArgs: [1], orderBy: '"id" desc' );
        // print("Monto disponible blocksplaysgenrals: $query");

        if(montoDisponible == null){
          // query = await Db.database.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          query = await getBlocksplayMonto(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, status: 1, idMoneda: banca.idMoneda);
          if(query != null){
            montoDisponible = query["monto"];
            stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);
          }else{
            // query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            query = await getBlocksplaysgeneralMonto(idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, status: 1, idMoneda: banca.idMoneda);
            if(query != null){
              montoDisponible = query["monto"];
              stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
            }
          }

          if(montoDisponible == null){
            // query = await Db.database.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
            query = await getBlockslotterieMonto(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, idDia: idDia, idMoneda: banca.idMoneda);
            if(query != null){
              montoDisponible = query["monto"];
              stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query['descontarDelBloqueoGeneral']);
            }
          }

          if(montoDisponible == null){
            // query = await Db.database.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda]);
            query = await getBlocksgeneralMonto(idLoteria: loteria.id, idSorteo: idSorteo, idDia: idDia, idMoneda: banca.idMoneda);
            if(query != null){
              montoDisponible = query["monto"];
              stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda);
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
      // List<Map<String, dynamic>> query = await Db.database.query('Stocks' , where: '"idBanca" = ? and "idLoteria" = ? and "idLoteriaSuperpale" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, loteriaSuperpale.id, idSorteo, jugada, 0, banca.idMoneda]);
      Map<String, dynamic> query = await getStockMonto(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda);

      print("getMontoDisponible super pale: $query");

      if(query != null){
        montoDisponible = query['monto'];
        stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query['descontarDelBloqueoGeneral'], esBloqueoJugada: query['esBloqueoJugada']);
      }


      if(montoDisponible != null){
        // query = await Db.database.query('Stocks' ,where: '"idLoteria" = ? and "idLoteriaSuperpale" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = ? and "ignorarDemasBloqueos" = ? and "idMoneda" = ?', whereArgs: [loteria.id, loteriaSuperpale.id, idSorteo, jugada, 1, 1, banca.idMoneda]);
        query = await getStockMonto(idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda);
        if(query != null){
          montoDisponible = query['monto'];
          stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: query['esBloqueoJugada']);
        }else{

          //Ahora nos aseguramos de que el bloqueo general existe y el valor de ignorarDemasBloqueos sea = 1
          // query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          query = await getBlocksplaysgeneralMonto(idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, status: 1, idMoneda: banca.idMoneda);
          if(query != null){
            var first = query;
            if(first["ignorarDemasBloqueos"] == 1){
              montoDisponible = first["monto"];
              stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
            }
          }
        }
      }


      //AQUI ES CUANDO EXISTE BLOQUEO GENERAL EN STOCKS
      if(montoDisponible == null){
        // query = await Db.database.query('Stocks' ,where: '"idLoteria" = ? and "idLoteriaSuperpale" = ? and "idSorteo" = ? and "jugada" = ? and "esGeneral" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, loteriaSuperpale.id, idSorteo, jugada, banca.idMoneda]);
        query = await getStockMonto(idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, idMoneda: banca.idMoneda);
        if(query != null){
          //SI IGNORARDEMASBLOQUEOS ES FALSE ENTONCES VAMOS A VERIFICAR SI EXISTEN BLOQUEOS POR BANCAS YA SEAN DE JUGADAS PARA RETORNAR ESTOS BLOQUEOS
          var stock = query;
          if(stock["ignorarDemasBloqueos"] == 0){
            // query = await Db.database.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            query = await getBlocksplayMonto(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, status: 1, idMoneda: banca.idMoneda);
            if(query != null){
              montoDisponible = query["monto"];
              stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);
            }else{
              // query = await Db.database.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
              query = await getBlockslotterieMonto(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, idDia: idDia, idMoneda: banca.idMoneda);
              if(query != null){
                montoDisponible = query["monto"];
                stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query['descontarDelBloqueoGeneral']);
              }
              else{
                montoDisponible = stock["monto"];
                stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
              }
            }
          }else{
            montoDisponible = stock["monto"];
            stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: stock["esBloqueoJugada"]);
          }
        }
      }



      if(montoDisponible == null){
        // query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
        query = await getBlocksplaysgeneralMonto(idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, status: 1, idMoneda: banca.idMoneda);
        if(query != null){
          var blocksplaysgenerals = query;
          if(blocksplaysgenerals["ignorarDemasBloqueos"] == 0){
            montoDisponible = null;
          }else{
            montoDisponible = blocksplaysgenerals["monto"];
            stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 1, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
          }
        }

        if(montoDisponible == null){
          // query = await Db.database.query('Blocksplays' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
          query = await getBlocksplayMonto(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, status: 1, idMoneda: banca.idMoneda);
          if(query != null){
            montoDisponible = query["monto"];
            stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query['descontarDelBloqueoGeneral'], esBloqueoJugada: 1);
          }else{
            // query = await Db.database.query('Blocksplaysgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "jugada" = ? and "status" = 1 and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, jugada, banca.idMoneda], orderBy: '"id" desc' );
            query = await getBlocksplaysgeneralMonto(idLoteria: loteria.id, idSorteo: idSorteo, jugada: jugada, status: 1, idMoneda: banca.idMoneda);
            if(query != null){
              montoDisponible = query["monto"];
              stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda, esBloqueoJugada: 1);
            }
          }

          if(montoDisponible == null){
            // query = await Db.database.query('Blockslotteries' ,where: '"idBanca" = ? and "idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [banca.id, loteria.id, idSorteo, idDia, banca.idMoneda]);
            query = await getBlockslotterieMonto(idBanca: banca.id, idLoteria: loteria.id, idSorteo: idSorteo, idDia: idDia, idMoneda: banca.idMoneda);
            if(query != null){
              montoDisponible = query["monto"];
              stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 0, idMoneda: banca.idMoneda, descontarDelBloqueoGeneral: query['descontarDelBloqueoGeneral']);
            }
          }

          if(montoDisponible == null){
            // query = await Db.database.query('Blocksgenerals' ,where: '"idLoteria" = ? and "idSorteo" = ? and "idDia" = ? and "idMoneda" = ?', whereArgs: [loteria.id, idSorteo, idDia, banca.idMoneda]);
            query = await getBlocksgeneralMonto(idLoteria: loteria.id, idSorteo: idSorteo, idDia: idDia, idMoneda: banca.idMoneda);
            if(query != null){
              montoDisponible = query["monto"];
              stockToReturn = StockModel.Stock(idBanca: banca.id, idLoteria: loteria.id, idLoteriaSuperpale: loteriaSuperpale.id, idSorteo: idSorteo, jugada: jugada, esGeneral: 1, ignorarDemasBloqueos: 0, idMoneda: banca.idMoneda);
            }
          }

          // print('montoDisponiblePrueba idSorteo: lot: $loteria.id sor: $idSorteo dia: $idDia res:${blocksgenerals.indexWhere((b) => b.idLoteria == loteria.id && b.idDia == idDia && b.idSorteo == idSorteo)} prueba:${Blocksgenerals.blocksgeneralsToJson(blocksgenerals.where((b) => b.idLoteria == loteria.id && b.idSorteo == idSorteo).toList())}');
        }
      }
    }

    // setState(() {
    //  _txtMontoDisponible.text = montoDisponible.toString();
    // });
    // print('montoDisponiblePrueba idSorteo: $montoDisponible');




    double montoDisponibleFinal = Utils.toDouble(montoDisponible.toString());

    if(stockToReturn != null)
      stockToReturn.monto = montoDisponibleFinal;
    else
      stockToReturn = StockModel.Stock(monto: montoDisponibleFinal);

    print("principalView getMontoDisponible: ${stockToReturn.toJson()}");
    return MontoDisponible(monto: montoDisponibleFinal, stock: stockToReturn);

  }


}

