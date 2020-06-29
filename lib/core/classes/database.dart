import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Db{

  static String _path;
  static Database database;
  static Future create() async {
    var databasesPath = await getDatabasesPath();
    _path = join(databasesPath, 'demo.db');
    await deleteDatabase(_path);
  }

  static Future open() async {
    
    // bool exists = await databaseFactory.databaseExists(_path);
    // if(exists){
    //   database = await openDatabase(_path);
    //   return;
    // }
      
      
    // open the database
     database = await openDatabase(_path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute('CREATE TABLE Stocks (id INTEGER PRIMARY KEY, idBanca INTEGER, idLoteria INTEGER, idSorteo INTEGER, jugada TEXT, montoInicial NUMBERIC, monto NUMERIC, created_at TEXT, esBloqueoJugada INTEGER, esGeneral INTEGER, ignorarDemasBloqueos INTEGER, idMoneda INTEGER)');
      await db.execute('CREATE TABLE Blocksgenerals (id INTEGER PRIMARY KEY, idDia INTEGER, idLoteria INTEGER, idSorteo INTEGER, monto NUMERIC, created_at TEXT, idMoneda INTEGER)');
      await db.execute('CREATE TABLE Blockslotteries (id INTEGER PRIMARY KEY, idBanca INTEGER, idDia INTEGER, idLoteria INTEGER, idSorteo INTEGER, monto NUMERIC, created_at TEXT, idMoneda INTEGER)');
      await db.execute('CREATE TABLE Blocksplays (id INTEGER PRIMARY KEY, idBanca INTEGER, idLoteria INTEGER, idSorteo INTEGER, jugada TEXT, montoInicial NUMBERIC, monto NUMERIC, fechaDesde TEXT, fechaHasta TEXT, created_at TEXT, ignorarDemasBloqueos INTEGER, status INTEGER, idMoneda INTEGER)');
      await db.execute('CREATE TABLE Blocksplaysgenerals (id INTEGER PRIMARY KEY, idLoteria INTEGER, idSorteo INTEGER, jugada TEXT, montoInicial NUMBERIC, monto NUMERIC, fechaDesde TEXT, fechaHasta TEXT, created_at TEXT, ignorarDemasBloqueos INTEGER, status INTEGER, idMoneda INTEGER)');
      await db.execute('CREATE TABLE Draws (id INTEGER PRIMARY KEY, descripcion TEXT, bolos INTEGER, cantidadNumeros INTEGER, status INTEGER, created_at TEXT)');
      await db.execute('CREATE TABLE Permissions (id INTEGER PRIMARY KEY, descripcion TEXT, status INTEGER, created_at TEXT)');
      await db.execute('CREATE TABLE Users (id INTEGER PRIMARY KEY, nombres TEXT, email TEXT, usuario TEXT, servidor TEXT, status INTEGER, created_at TEXT)');
      await db.execute('CREATE TABLE Branches (id INTEGER PRIMARY KEY, codigo TEXT, descripcion TEXT, dueno TEXT, idUsuario INTEGER, limiteVenta NUMERIC, descontar NUMERIC, deCada NUMERIC, minutosCancelarTicket NUMERIC, piepagina1 TEXT, piepagina2 TEXT, piepagina3 TEXT, piepagina4 TEXT, idMoneda INTEGER, moneda TEXT, monedaAbreviatura TEXT, monedaColor TEXT, status INTEGER, created_at TEXT)');
      await db.execute('CREATE TABLE Servers (id INTEGER PRIMARY KEY, descripcion TEXT, pordefecto INTEGER)');

    });
  }

  static insert(String table, Map<String, dynamic> dataToMap) async {
    await database.insert(
      table,
      dataToMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static update(String table, Map<String, dynamic> dataToMap, id) async {
    await database.update(
      table,
      dataToMap,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static delete(String table, id) async {
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

  static Future<String> servidor() async {
      var query = await database.query('Users');
      if(query.isEmpty){
        return null;
      }else{
        return query.first["servidor"];
      }
  }

  static Future<int> idBanca() async {
      var query = await database.query('Branches');
      if(query.isEmpty){
        return null;
      }else{
        return query.first["id"];
      }
  }

  static Future<Map<String, dynamic>> getUsuario() async {
      var query = await database.query('Users');
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

  static Future<bool> existePermiso(String permiso) async {
      var query = await database.query('Permissions', where: '"descripcion" = ?', whereArgs: [permiso]);
      if(query.isEmpty){
        return false;
      }else{
        return true;
      }
  }

  static Future deleteDB() async {
      await deleteDatabase(_path);
  }

}