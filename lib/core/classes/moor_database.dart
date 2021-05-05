import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:moor/moor.dart';
// import 'package:moor/moor_web.dart';
import 'package:loterias/core/models/draws.dart' as DrawsModel;
import 'package:loterias/core/models/stocks.dart' as StockModel;
import 'package:loterias/core/models/blocksgenerals.dart' as BlocksgeneralsModel;
import 'package:loterias/core/models/blockslotteries.dart' as BlockslotteriesModel;
import 'package:loterias/core/models/blocksplays.dart' as BlocksplaysModel;
import 'package:loterias/core/models/blocksplaysgenerals.dart' as BlocksplaysgeneralsModel;
import 'package:loterias/core/models/blocksdirtygenerals.dart' as BlocksdirtygeneralsModel;
import 'package:loterias/core/models/blocksdirty.dart' as BlocksdirtyModel;


part 'moor_database.g.dart';


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
  IntColumn get status => integer()();
  // BoolColumn get status => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Users extends Table{
  IntColumn get id => integer()();
  TextColumn get usuario => text()();
  TextColumn get servidor => text()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get status => integer()();
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
  IntColumn get imprimirNombreBanca => integer()();TextColumn get servidor => text()();
  // BoolColumn get status => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Branchs extends Table{
  IntColumn get id => integer()();
  IntColumn get idMoneda => integer()();
  TextColumn get descripcion => text()();
  TextColumn get codigo => text()();
  TextColumn get moneda => text()();
  TextColumn get monedaAbreviatura => text()();
  TextColumn get monedaColor => text()();
  RealColumn get descontar => real()();
  RealColumn get deCada => real()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get status => integer()();
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

class Stocks extends Table{
  IntColumn get id => integer()();
  IntColumn get idBanca => integer()();
  IntColumn get idLoteria => integer()();
  IntColumn get idLoteriaSuperpale => integer()();
  IntColumn get idSorteo => integer()();
  TextColumn get jugada => text()();
  RealColumn get montoInicial => real()();
  RealColumn get monto => real()();
  DateTimeColumn get created_at => dateTime().nullable()();
  IntColumn get esBloqueoJugada => integer()();
  IntColumn get esGeneral => integer()();
  IntColumn get ignorarDemasBloqueos => integer()();
  IntColumn get idMoneda => integer()();

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

@UseMoor(tables: [Tasks, Permissions, Users, Settings, Branchs, Servers, Stocks, Blocksgenerals, Blockslotteries, Blocksplays, Blocksplaysgenerals, Draws, Blocksdirtys, Blocksdirtygenerals])
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
    List<Permission> listPermission = permisos.map((e) => Permission(descripcion: e.descripcion, status: e.status, id: e.id, created_at: e.created_at)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(permissions, listPermission));
  }
  Future deleteAllPermission() => customStatement("delete from permissions");
  Future<bool> existePermiso(String permiso) async {
    var p = await ((select(permissions)..where((p) => p.descripcion.equals(permiso))).getSingle());
    // print("moor_Database existePermiso: ${p.toJson()}");
    return p != null;
  }

  Future insertBranch(Branch branch) => into(branchs).insert(branch);
  Future updateBranch(Branch branch) => update(branchs).replace(branch);
  Future deleteBranch(Branch branch) => delete(branchs).delete(branch);
  Future deleteAllBranches() => customStatement("delete from branches");
  Future<Map<String, dynamic>> getBanca() async => (await ((select(branchs)..limit(1)).getSingle())).toJson();
  Future<int> getIdBanca() async {
    Branch e = await ((select(branchs)..limit(1)).getSingle());
    return (e != null) ? e.id : 0;
  }
  Future<int> idBanca() async {
    Branch e = await ((select(branchs)..limit(1)).getSingle());
    return (e != null) ? e.id : 0;
  }

  Future insertUser(User user) => into(users).insert(user);
  Future updateUser(User user) => update(users).replace(user);
  Future deleteUser(User user) => delete(users).delete(user);
  Future deleteAllUser() => customStatement("delete from users");
  Future<Map<String, dynamic>> getUsuario() async => (await ((select(users)..limit(1)).getSingle())).toJson();
  Future<int> getIdUsuario() async {
    User e = await ((select(users)..limit(1)).getSingle());
    return (e != null) ? e.id : 0;
  }
  Future<int> idUsuario() async {
    User e = await ((select(users)..limit(1)).getSingle());
    return (e != null) ? e.id : 0;
  }

  Future insertSetting(Setting setting) => into(settings).insert(setting);
  Future updateSetting(Setting setting) => update(settings).replace(setting);
  Future deleteSetting(Setting setting) => delete(settings).delete(setting);
  Future deleteAllSetting() => customStatement("delete from settings");
  Future<Map<String, dynamic>> getSetting() async => (await ((select(settings)..limit(1)).getSingle())).toJson();

  Future<List<Server>> getAllServer() => select(servers).get();
  Future insertServer(Server element) => into(servers).insert(element);
  Future updateServer(Server element) => update(servers).replace(element);
  Future deleteServer(Server element) => delete(servers).delete(element);
  Future<void> insertListServer(List<Servidor> permisos) async {
    List<Server> listServer = permisos.map((e) => Server(descripcion: e.descripcion, id: e.id, pordefecto: e.pordefecto)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(servers, listServer));
  }
  Future<String> servidor() async {
    User e = await ((select(users)..limit(1)).getSingle());
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
    List<Stock> listElement = elements.map((e) => Stock(id: e.id, idBanca: e.idBanca, idLoteria: e.idLoteria, idLoteriaSuperpale: e.idLoteriaSuperpale, idSorteo: e.idSorteo, jugada: e.jugada, montoInicial: e.montoInicial, monto: e.monto, created_at: e.created_at, esBloqueoJugada: e.esBloqueoJugada, esGeneral: e.esGeneral, ignorarDemasBloqueos: e.ignorarDemasBloqueos, idMoneda: e.idMoneda,)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(stocks, listElement));
  }
  Future<double> getStockMonto({int idBanca, @required int idLoteria, @required int idSorteo, @required String jugada, @required int esGeneral, @required int idMoneda, int ignorarDemasBloqueos, int idLoteriaSuperpale}) async {
    String query = "";
    if(idBanca != null)
      query += " and idBanca = $idBanca";
    if(ignorarDemasBloqueos != null)
      query += " and ignorarDemasBloqueos = $ignorarDemasBloqueos";
    if(idLoteriaSuperpale != null)
      query += " and idLoteriaSuperpale = $idLoteriaSuperpale";

    QueryRow data = await customSelect("select monto from stocks where idLoteria = $idLoteria and idSorteo = $idSorteo and jugada = $jugada and esGeneral = $esGeneral and idMoneda = $idMoneda $query order by id desc limit 1", readsFrom: {stocks}).getSingle();
    return (data == null) ? null : data.readDouble("monto");
    // Stock e = await ((select(stocks)..where((e) => e.idBanca.equals(idBanca) & e.idLoteria.equals(idLoteria) & e.idSorteo.equals(idSorteo) & e.jugada.equals(jugada) & e.esGeneral.equals(esGeneral) & e.idMoneda.equals(idMoneda))
    //   ..orderBy([
    //     (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)
    //   ])
    // ).getSingle());
    // return (e != null) ? e.monto : null;
  }
  Future<Map<String, dynamic>> getStockMontoAndIgnorarDemasBloqueos({int idBanca, @required int idLoteria, @required int idSorteo, @required String jugada, @required int esGeneral, @required int idMoneda, int ignorarDemasBloqueos, int idLoteriaSuperpale}) async {
    String query = "";
    if(idBanca != null)
      query += " and idBanca = $idBanca";
    if(ignorarDemasBloqueos != null)
      query += " and ignorarDemasBloqueos = $ignorarDemasBloqueos";
    if(idLoteriaSuperpale != null)
      query += " and idLoteriaSuperpale = $idLoteriaSuperpale";

    QueryRow data = await customSelect("select monto, ignorarDemasBloqueos from stocks where idLoteria = $idLoteria and idSorteo = $idSorteo and jugada = $jugada and esGeneral = $esGeneral and idMoneda = $idMoneda $query order by id desc limit 1", readsFrom: {stocks}).getSingle();
    return (data == null) ? null : {
      "monto" : data.readDouble("monto"),
      "ignorarDemasBloqueos" : data.readInt("ignorarDemasBloqueos"),
    };
  }
  // Future<int> idDraw(String descripcion) async {
  //   Draw e = await ((select(draws)..where((e) => e.descripcion.equals(descripcion))..limit(1)).getSingle());
  //   return (e != null) ? e.id : 0;
  // }

  Future insertOrReplaceBlocksgeneral(Blocksgeneral element) => into(blocksgenerals).insert(element, mode: InsertMode.insertOrReplace);
  Future updateBlocksgeneral(Blocksgeneral element) => update(blocksgenerals).replace(element);
  Future deleteBlocksgeneral(Blocksgeneral element) => delete(blocksgenerals).delete(element);
  Future<void> insertListBlocksgeneral(List<BlocksgeneralsModel.Blocksgenerals> elements) async {
    List<Blocksgeneral> listElement = elements.map((e) => Blocksgeneral(id: e.id, idDia: e.idDia, idLoteria: e.idLoteria, idSorteo: e.idSorteo, monto: e.monto, created_at: e.created_at, idMoneda: e.idMoneda,)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(blocksgenerals, listElement));
  }
  Future<double> getBlocksgeneralMonto({@required int idLoteria, @required int idSorteo, @required int idDia, @required int idMoneda}) async {
    QueryRow data = await customSelect("select monto from blocksgenerals where idLoteria = $idLoteria and idSorteo = $idSorteo and idDia = $idDia and idMoneda = $idMoneda order by id desc limit 1", readsFrom: {blocksgenerals}).getSingle();
    return (data == null) ? null : data.readDouble("monto");
  }

  Future insertOrReplaceBlockslotterie(Blockslotterie element) => into(blockslotteries).insert(element, mode: InsertMode.insertOrReplace);
  Future updateBlockslotterie(Blockslotterie element) => update(blockslotteries).replace(element);
  Future deleteBlockslotterie(Blockslotterie element) => delete(blockslotteries).delete(element);
  Future<void> insertListBlockslotterie(List<BlockslotteriesModel.Blockslotteries> elements) async {
    List<Blockslotterie> listElement = elements.map((e) => Blockslotterie(id: e.id, idBanca: e.idBanca, idDia: e.idDia, idLoteria: e.idLoteria, idSorteo: e.idSorteo, monto: e.monto, created_at: e.created_at, idMoneda: e.idMoneda,)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(blockslotteries, listElement));
  }
  Future<double> getBlockslotterieMonto({@required int idBanca, @required int idLoteria, @required int idSorteo, @required int idDia, @required int idMoneda}) async {
    QueryRow data = await customSelect("select monto from blockslotteries where idBanca = $idBanca and idLoteria = $idLoteria and idSorteo = $idSorteo and idDia = $idDia and idMoneda = $idMoneda order by id desc limit 1", readsFrom: {blockslotteries}).getSingle();
    return (data == null) ? null : data.readDouble("monto");
  }

  Future insertOrReplaceBlocksplay(Blocksplay element) => into(blocksplays).insert(element, mode: InsertMode.insertOrReplace);
  Future updateBlocksplay(Blocksplay element) => update(blocksplays).replace(element);
  Future deleteBlocksplay(Blocksplay element) => delete(blocksplays).delete(element);
  Future<void> insertListBlocksplay(List<BlocksplaysModel.Blocksplays> elements) async {
    List<Blocksplay> listElement = elements.map((e) => Blocksplay(id: e.id, idBanca: e.idBanca, idLoteria: e.idLoteria, idSorteo: e.idSorteo, jugada: e.jugada, montoInicial: e.montoInicial, monto: e.monto, created_at: e.created_at, status: e.status, fechaDesde: e.fechaDesde, fechaHasta: e.fechaHasta, ignorarDemasBloqueos: e.ignorarDemasBloqueos, idMoneda: e.idMoneda,)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(blocksplays, listElement));
  }
  Future<double> getBlocksplayMonto({@required int idBanca, @required int idLoteria, @required int idSorteo, @required String jugada, @required int idMoneda, int status = 1}) async {
    QueryRow data = await customSelect("select monto from blocksplays where idBanca = $idBanca and idLoteria = $idLoteria and idSorteo = $idSorteo and jugada = $jugada and idMoneda = $idMoneda and status = $status order by id desc limit 1", readsFrom: {blocksplays}).getSingle();
    return (data == null) ? null : data.readDouble("monto");
  }

  Future insertOrReplaceBlocksplaysgeneral(Blocksplaysgeneral element) => into(blocksplaysgenerals).insert(element, mode: InsertMode.insertOrReplace);
  Future updateBlocksplaysgeneral(Blocksplaysgeneral element) => update(blocksplaysgenerals).replace(element);
  Future deleteBlocksplaysgeneral(Blocksplaysgeneral element) => delete(blocksplaysgenerals).delete(element);
  Future<void> insertListBlocksplaysgeneral(List<BlocksplaysgeneralsModel.Blocksplaysgenerals> elements) async {
    List<Blocksplaysgeneral> listElement = elements.map((e) => Blocksplaysgeneral(id: e.id, idLoteria: e.idLoteria, idSorteo: e.idSorteo, jugada: e.jugada, montoInicial: e.montoInicial, monto: e.monto, created_at: e.created_at, status: e.status, fechaDesde: e.fechaDesde, fechaHasta: e.fechaHasta, ignorarDemasBloqueos: e.ignorarDemasBloqueos, idMoneda: e.idMoneda,)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(blocksplaysgenerals, listElement));
  }
  Future<Map<String, dynamic>> getBlockplaysgeneralMontoAndIgnorarDemasBloqueos({@required int idLoteria, @required int idSorteo, @required String jugada, @required int idMoneda, int status = 1}) async {
    QueryRow data = await customSelect("select monto, ignorarDemasBloqueos from blocksplaysgenerals where idLoteria = $idLoteria and idSorteo = $idSorteo and jugada = $jugada and idMoneda = $idMoneda and status = $status order by id desc limit 1", readsFrom: {blocksplaysgenerals}).getSingle();
    return (data == null) ? null : {
      "monto" : data.readDouble("monto"),
      "ignorarDemasBloqueos" : data.readInt("ignorarDemasBloqueos"),
    };
  }
  Future<double> getBlockplaysgeneralMonto({@required int idLoteria, @required int idSorteo, @required String jugada, @required int idMoneda, int status = 1}) async {
    QueryRow data = await customSelect("select monto from blocksplaysgenerals where idLoteria = $idLoteria and idSorteo = $idSorteo and jugada = $jugada and idMoneda = $idMoneda and status = $status order by id desc limit 1", readsFrom: {blocksplaysgenerals}).getSingle();
    return (data == null) ? null : data.readDouble("monto");
  }

  Future insertDraw(Draw element) => into(draws).insert(element);
  Future updateDraw(Draw element) => update(draws).replace(element);
  Future deleteDraw(Draw element) => delete(draws).delete(element);
  Future<void> insertListDraw(List<Draw> elements) async {
    List<Draw> listElement = elements.map((e) => Draw(descripcion: e.descripcion, bolos: e.bolos, cantidadNumeros: e.cantidadNumeros, status: e.status, id: e.id, created_at: e.created_at)).toList();
    return await batch((b) => b.insertAllOnConflictUpdate(draws, listElement));
  }
  Future<int> idDraw(String descripcion) async {
    Draw e = await ((select(draws)..where((e) => e.descripcion.equals(descripcion))..limit(1)).getSingle());
    return (e != null) ? e.id : 0;
  }
  Future<Map<String, dynamic>> draw(String descripcion) async {
    Draw e = await ((select(draws)..where((e) => e.descripcion.equals(descripcion))..limit(1)).getSingle());
    return (e != null) ? e.toJson() : null;
  }
  Future<Map<String, dynamic>> drawById(int id) async {
    Draw e = await ((select(draws)..where((e) => e.id.equals(id))..limit(1)).getSingle());
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
    ).getSingle());
    return (e != null) ? e.cantidad : null;
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
    ).getSingle());
    return (e != null) ? e.cantidad : null;
  }

}

