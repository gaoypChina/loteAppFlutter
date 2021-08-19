// import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBSqflite{

  static String _path;
  static Database database;
  static Future create() async {
    var databasesPath = await getDatabasesPath();
    _path = join(databasesPath, 'demo.db');
    // await deleteDatabase(_path);
  }

  static Future open() async {
    
    // bool exists = await databaseFactory.databaseExists(_path);
    // if(exists){
    //   database = await openDatabase(_path);
    //   return;
    // }

    const migrationScripts = [
      [],
      [],
      [],
      [
        'ALTER TABLE Stocks ADD COLUMN descontarDelBloqueoGeneral INTEGER',
        'ALTER TABLE Blockslotteries ADD COLUMN descontarDelBloqueoGeneral INTEGER',
        'ALTER TABLE Blocksplays ADD COLUMN descontarDelBloqueoGeneral INTEGER',
        'ALTER TABLE Sales ADD COLUMN servidor TEXT',
      ],
    ]; // Migration sql scripts, containing an array of statements per migration
      
      
    // open the database
     database = await openDatabase(_path, version: migrationScripts.length,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute('CREATE TABLE Stocks (id INTEGER PRIMARY KEY, idBanca INTEGER, idLoteria INTEGER, idLoteriaSuperpale INTEGER, idSorteo INTEGER, jugada TEXT, montoInicial NUMERIC, monto NUMERIC, created_at TEXT, esBloqueoJugada INTEGER, esGeneral INTEGER, ignorarDemasBloqueos INTEGER, idMoneda INTEGER, descontarDelBloqueoGeneral INTEGER)');
      await db.execute('CREATE TABLE Blocksgenerals (id INTEGER PRIMARY KEY, idDia INTEGER, idLoteria INTEGER, idSorteo INTEGER, monto NUMERIC, created_at TEXT, idMoneda INTEGER)');
      await db.execute('CREATE TABLE Blockslotteries (id INTEGER PRIMARY KEY, idBanca INTEGER, idDia INTEGER, idLoteria INTEGER, idSorteo INTEGER, monto NUMERIC, created_at TEXT, idMoneda INTEGER, descontarDelBloqueoGeneral INTEGER)');
      await db.execute('CREATE TABLE Blocksplays (id INTEGER PRIMARY KEY, idBanca INTEGER, idLoteria INTEGER, idSorteo INTEGER, jugada TEXT, montoInicial NUMERIC, monto NUMERIC, fechaDesde TEXT, fechaHasta TEXT, created_at TEXT, ignorarDemasBloqueos INTEGER, status INTEGER, idMoneda INTEGER, descontarDelBloqueoGeneral INTEGER)');
      await db.execute('CREATE TABLE Blocksplaysgenerals (id INTEGER PRIMARY KEY, idLoteria INTEGER, idSorteo INTEGER, jugada TEXT, montoInicial NUMERIC, monto NUMERIC, fechaDesde TEXT, fechaHasta TEXT, created_at TEXT, ignorarDemasBloqueos INTEGER, status INTEGER, idMoneda INTEGER)');
      await db.execute('CREATE TABLE Draws (id INTEGER PRIMARY KEY, descripcion TEXT, bolos INTEGER, cantidadNumeros INTEGER, status INTEGER, created_at TEXT)');
      await db.execute('CREATE TABLE Permissions (id INTEGER PRIMARY KEY, descripcion TEXT, status INTEGER, idTipo, created_at TEXT)');
      await db.execute('CREATE TABLE Users (id INTEGER PRIMARY KEY, nombres TEXT, email TEXT, usuario TEXT, servidor TEXT, status INTEGER, created_at TEXT, idGrupo INTEGER)');
      await db.execute('CREATE TABLE Branches (id INTEGER PRIMARY KEY, codigo TEXT, descripcion TEXT, dueno TEXT, idUsuario INTEGER, limiteVenta NUMERIC, descontar NUMERIC, deCada NUMERIC, minutosCancelarTicket NUMERIC, piepagina1 TEXT, piepagina2 TEXT, piepagina3 TEXT, piepagina4 TEXT, idMoneda INTEGER, moneda TEXT, monedaAbreviatura TEXT, monedaColor TEXT, status INTEGER, created_at TEXT, ventasDelDia INTEGER)');
      await db.execute('CREATE TABLE Servers (id INTEGER PRIMARY KEY, descripcion TEXT, pordefecto INTEGER)');
      await db.execute('CREATE TABLE Blocksdirty (id INTEGER PRIMARY KEY, idBanca INTEGER, idLoteria INTEGER, idSorteo INTEGER, cantidad INTEGER, created_at TEXT, idMoneda INTEGER)');
      await db.execute('CREATE TABLE Blocksdirtygenerals (id INTEGER PRIMARY KEY, idLoteria INTEGER, idSorteo INTEGER, cantidad INTEGER, created_at TEXT, idMoneda INTEGER)');
      await db.execute('CREATE TABLE Settings (id INTEGER PRIMARY KEY, consorcio TEXT, imprimirNombreConsorcio INTEGER, idTipoFormatoTicket INTEGER, descripcionTipoFormatoTicket Text, cancelarTicketWhatsapp INTEGER, imprimirNombreBanca INTEGER, pagarTicketEnCualquierBanca INTEGER)');
      await db.execute('CREATE TABLE Tickets (id INTEGER PRIMARY KEY, codigoBarra TEXT, uuid TEXT, idBanca INTEGER, usado INTEGER)');
      await db.execute('CREATE TABLE Lotteries (id INTEGER PRIMARY KEY, descripcion TEXT, abreviatura TEXT, status INTEGER)');
      await db.execute('CREATE TABLE Days (id INTEGER PRIMARY KEY, descripcion TEXT, created_at TEXT, wday INTEGER, horaApertura TEXT, horaCierre TEXT)');
      await db.execute('CREATE TABLE Sales (id INTEGER PRIMARY KEY, compartido INTEGER, idUsuario INTEGER, idBanca INTEGER, total NUMERIC, subtotal NUMERIC, descuentoMonto NUMERIC, hayDescuento INTEGER, idTicket INTEGER, created_at TEXT, updated_at TEXT, status INTEGER, subido INTEGER, servidor TEXT)');
      await db.execute('CREATE TABLE Salesdetails (id INTEGER PRIMARY KEY, idVenta INTEGER, idLoteria INTEGER, idSorteo INTEGER, sorteoDescripcion TEXT, jugada TEXT, monto NUMERIC, premio NUMERIC, comision NUMERIC, idStock INTEGER, idLoteriaSuperpale INTEGER, created_at TEXT, updated_at TEXT, status INTEGER, subido INTEGER)');
    },
    onUpgrade: (Database db, int oldVersion, int newVersion) async {
          print("onUpgrade oldVersion-newVersion: $oldVersion-$newVersion");
        for (var i = oldVersion - 1; i <= newVersion - 1; i++) {
          print("Databaae.dart version: $i");
          for (var scripts in migrationScripts[i]) {
            print("Database.dart onUpgrade script: $scripts");
            await db.execute(scripts);
          }
        }  
      }
    );
  }

  static Future<void> insert(String table, Map<String, dynamic> dataToMap, [var transaction]) async {
    await 
    transaction == null 
    ?
    database.insert(
      table,
      dataToMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
    :
    transaction.insert(
      table,
      dataToMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static update(String table, Map<String, dynamic> dataToMap, id, [var transaction]) async {
    transaction == null
    ?
    await database.update(
      table,
      dataToMap,
      where: "id = ?",
      whereArgs: [id],
    )
    :
    await transaction.update(
      table,
      dataToMap,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static delete(String table, [id]) async {
    if(id == null)
      return await database.delete(table);
      
    await database.delete(
      table,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
      return await database.query(table);
    }

  static Future<int> idUsuario() async {
      var query = await database.query('Users');
      if(query.isEmpty){
        return null;
      }else{
        return query.first["id"];
      }
  }

  static Future<String> servidor([var transaction]) async {
      var query = transaction == null ? await database.query('Users') : await transaction.query('Users');;
      if(query.isEmpty){
        return null;
      }else{
        return query.first["servidor"];
      }
  }

  static Future<int> idBanca([var transaction]) async {
      var query = transaction == null ? await database.query('Branches') : await transaction.query('Branches');
      if(query.isEmpty){
        return null;
      }else{
        return query.first["id"];
      }
  }

  static Future<Map<String, dynamic>> getUsuario([var transaction]) async {
      var query = transaction == null ? await database.query('Users') : await transaction.query('Users');
      if(query.isEmpty){
        return null;
      }else{
        return query.first;
      }
  }

  static Future<Map<String, dynamic>> getBanca() async {
      var query = await database.query('Branches');
      if(query.isEmpty){
        return null;
      }else{
        return query.first;
      }
  }

  static Future<bool> existePermiso(String permiso, [var transaction]) async {
      var query = transaction == null 
        ? 
        await database.query('Permissions', where: '"descripcion" = ?', whereArgs: [permiso]) 
        : 
        await transaction.query('Permissions', where: '"descripcion" = ?', whereArgs: [permiso]);
      if(query.isEmpty){
        return false;
      }else{
        return true;
      }
  }

  static Future<bool> existePermisos(List<String> permiso, [var transaction]) async {
      String select = 'SELECT id from Permissions  WHERE descripcion IN (\'' +(permiso.join('\',\'')).toString() +'\')';
      var query = transaction == null
      ?
      await database.rawQuery(select)
      :
      await transaction.rawQuery(select);
      if(query.isEmpty){
        return false;
      }else{
        return query.length == permiso.length;
      }
  }

  static Future<bool> existeLoteria(int id, [var transaction]) async {
      var query = transaction == null 
        ? 
        await database.query('Lotteries', where: '"id" = ?', whereArgs: [id]) 
        : 
        await transaction.query('Lotteries', where: '"id" = ?', whereArgs: [id]);
      if(query.isEmpty){
        return false;
      }else{
        return true;
      }
  }

  static Future deleteDB() async {
    var query = await database.rawQuery('SELECT COUNT(*) as stocks FROM STOCKS');
    print("Database.deleteDb before delete stocks: ${query}");
    query = await database.rawQuery('SELECT * FROM Users');
    print("Database.deleteDb before delete users: ${query}");
    query = await database.rawQuery('SELECT * FROM Branches');
    print("Database.deleteDb before delete Branches: ${query}");
    query = await database.rawQuery('SELECT COUNT(*) as sales FROM Sales');
    print("Database.deleteDb before delete sales: ${query}");
    query = await database.rawQuery('SELECT COUNT(*) as salesdetails FROM Salesdetails');
    print("Database.deleteDb before delete Salesdetails: ${query}");
    query = await database.rawQuery('SELECT COUNT(*) as tickets FROM Tickets');
    print("Database.deleteDb before delete Tickets: ${query}");
    
    var batch = database.batch();
    batch.rawQuery("DELETE FROM Stocks");
    batch.rawQuery("DELETE FROM Blocksgenerals");
    batch.rawQuery("DELETE FROM Blockslotteries");
    batch.rawQuery("DELETE FROM Blocksplays");
    batch.rawQuery("DELETE FROM Blocksplaysgenerals");
    batch.rawQuery("DELETE FROM Draws");
    batch.rawQuery("DELETE FROM Permissions");
    batch.rawQuery("DELETE FROM Users");
    batch.rawQuery("DELETE FROM Branches");
    batch.rawQuery("DELETE FROM Servers");
    batch.rawQuery("DELETE FROM Blocksdirty");
    batch.rawQuery("DELETE FROM Blocksdirtygenerals");
    batch.rawQuery("DELETE FROM Settings");
    batch.rawQuery("DELETE FROM Lotteries");
    batch.rawQuery("DELETE FROM Days");
    await batch.commit(noResult: true);
    query = await database.rawQuery('SELECT COUNT(*) as stocks FROM STOCKS');
    print("Database.deleteDb after delete stocks: ${query}");
    query = await database.rawQuery('SELECT * FROM Users');
    print("Database.deleteDb after delete users: ${query}");
    query = await database.rawQuery('SELECT * FROM Branches');
    print("Database.deleteDb after delete Branches: ${query}");
   query = await database.rawQuery('SELECT COUNT(*) as sales FROM Sales');
    print("Database.deleteDb after delete sales: ${query}");
    query = await database.rawQuery('SELECT COUNT(*) as salesdetails FROM Salesdetails');
    print("Database.deleteDb after delete Salesdetails: ${query}");
    query = await database.rawQuery('SELECT COUNT(*) as tickets FROM Tickets');
    print("Database.deleteDb after delete tickets: ${query}");
      // await deleteDatabase(_path);
  }

  static Future<Map<String, dynamic>> ajustes() async {
      var query = await database.query('Settings');
      if(query.isEmpty){
        return null;
      }else{
        return query.first;
      }
  }

  static Future<String> tipoFormatoTicket() async {
      var query = await database.query('Settings');
      if(query.isEmpty){
        return null;
      }else{
        return query.first["tipoFormatoTicket"];
      }
  }

  static Future<Map<String, dynamic>> getLastRow(String table, [var transaction]) async {
      var query = transaction == null ? await database.rawQuery('SELECT * FROM ' + table + ' ORDER BY ID DESC LIMIT 1') : await transaction.rawQuery('SELECT * FROM ' + table + ' ORDER BY ID DESC LIMIT 1');
      if(query.isEmpty){
        return null;
      }else{
        return query.first;
      }
  }

  static Future<Map<String, dynamic>> getNextTicket(int idBanca, [var transaction]) async {
      String queryStatemet = 'SELECT * FROM Tickets WHERE usado = 0 AND idBanca = $idBanca ORDER BY ID ASC LIMIT 1';
      var query = transaction == null ? await database.rawQuery(queryStatemet) : await transaction.rawQuery(queryStatemet);
      if(query.isEmpty){
        return null;
      }else{
        return query.first;
      }
  }

  static Future<Map<String, dynamic>> queryBy(String table, String by, value, [var transaction]) async {
      var query = transaction == null 
        ? 
        await database.query(table, where: '"$by" = ?', whereArgs: [value]) 
        : 
        await transaction.query(table, where: '"$by" = ?', whereArgs: [value]);

      if(query.isEmpty){
        return null;
      }else{
        return query.first;
      }
  }

  static Future<List<Map<String, dynamic>>> queryListBy(String table, String by, value, [var transaction]) async {
      var query = transaction == null 
        ? 
        await database.query(table, where: '"$by" = ?', whereArgs: [value]) 
        : 
        await transaction.query(table, where: '"$by" = ?', whereArgs: [value]);

      return query;
  }

  static Future<Map<String, dynamic>> getSaleNoSubida([var transaction]) async {
      String queryStatemet = 'SELECT * FROM Sales WHERE subido != 1 ORDER BY ID ASC LIMIT 1';
      // String queryStatemet = 'SELECT * FROM Sales WHERE subido == ORDER BY ID ASC LIMIT 1';

      // Verificamos de que la base de datos este abierta
      if(transaction == null){
        if(!database.isOpen) 
          return null;
      }
      var query = transaction == null ? await database.rawQuery(queryStatemet) : await transaction.rawQuery(queryStatemet);
      if(query.isEmpty){
        return null;
      }else{
        return query.first;
      }
  }

  static Future<int> idGrupo() async {
      var query = await database.query('Users');
      if(query.isEmpty){
        return null;
      }else{
        return query.first["idGrupo"];
      }
  }

}