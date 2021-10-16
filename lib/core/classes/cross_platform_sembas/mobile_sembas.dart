import 'package:loterias/core/classes/cross_platform_sembas/cross_platform_sembas.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/blocksgenerals.dart';
import 'package:loterias/core/models/blockslotteries.dart';
import 'package:loterias/core/models/blocksplays.dart';
import 'package:loterias/core/models/blocksplaysgenerals.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/stocks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class MobileSembas implements CrossSembas {
  static MobileSembas _instance;
static var _dir;
static var _dbPath;
static Database _db;
static StoreRef _store;
// get the application documents directory
static final MobileSembas _singleton = MobileSembas._internal();



//  static final DB _singleton = DB._internal();
   MobileSembas._internal(){

 }

  factory MobileSembas() {
  
    return _singleton;
  }

 

  MobileSembas._create(){
    // if(_instance == null){
    //   _instance = DB._internal();
    // }
   _store = StoreRef.main();
    
  }

  @override
  Future create() async {
    // print("create() (public factory)");
 
    if(_singleton == null){
      // _instance = MobileSembas._internal();
        _dir = await getApplicationDocumentsDirectory();
      // make sure it exists
      await _dir.create(recursive: true);
      // build the database path
       _dbPath = _dir.path + 'my_database.db';
      // open the database
      _db = await databaseFactoryIo.openDatabase(_dbPath);
    }
    else if(_db == null){
      //  _instance = DB._internal();
        _dir = await getApplicationDocumentsDirectory();
      // make sure it exists
      await _dir.create(recursive: true);
      // build the database path
       _dbPath = _dir.path + 'my_database.db';
      // open the database
      _db = await databaseFactoryIo.openDatabase(_dbPath);
    }

    // Call the private constructor
    var component = MobileSembas._create();

    // Do initialization that requires async
    //await component._complexAsyncInit();
    

    // Return the fully initialized object
    return component;
  }

  @override
  add(String key, var value) async {
    await _store.record(key).put(_db, value);
  }

  @override
  getValue(String key) async {
    try {
      var data = await _store.record(key).get(_db) as dynamic;
      if(data != null)
        return data;
      else
        return null;
    } catch (e) {
      return null;
    }
  }

  @override
  delete(String key) async {
    return (_db != null) ? await _store.record(key).delete(_db) : false;
  }

  @override
  addList(String key, List<dynamic> s) async{
    await _store.record(key).put(_db, s);
  }

  @override
  getList(String key) async{
     List<dynamic> lista = await _store.record(key).get(_db) as List<dynamic>;
     if(lista == null){
       return List();
     }
     if(lista.length == 0)
      return List();
      
     if(key == 'stocks')
      return lista.map((s) => Stock.fromMap(s)).toList();
     else if(key == 'blocksgenerals')
      return lista.map((s) => Blocksgenerals.fromMap(s)).toList();
     else if(key == 'blockslotteries')
      return lista.map((s) => Blockslotteries.fromMap(s)).toList();
     else if(key == 'blocksplays')
      return lista.map((s) => Blocksplays.fromMap(s)).toList();
     else if(key == 'blocksplaysgenerals')
      return lista.map((s) => Blocksplaysgenerals.fromMap(s)).toList();
     else if(key == 'draws')
      return lista.map((s) => Draws.fromMap(s)).toList();
    else
      return lista;
  }

  @override
  getListWithoutConvert(String key) async{
     List<dynamic> lista = await _store.record(key).get(_db) as List<dynamic>;
     if(lista == null){
       return List();
     }
     if(lista.length == 0)
      return List();
      
    //  if(key == 'stocks')
    //   return lista.map((s) => Stock.fromMap(s)).toList();
    //  else if(key == 'blocksgenerals')
    //   return lista.map((s) => Blocksgenerals.fromMap(s)).toList();
    //  else if(key == 'blockslotteries')
    //   return lista.map((s) => Blockslotteries.fromMap(s)).toList();
    //  else if(key == 'blocksplays')
    //   return lista.map((s) => Blocksplays.fromMap(s)).toList();
    //  else if(key == 'blocksplaysgenerals')
    //   return lista.map((s) => Blocksplaysgenerals.fromMap(s)).toList();
    //  else if(key == 'draws')
    //   return lista.map((s) => Draws.fromMap(s)).toList();
    // else
      return lista;
  }

  @override
  addListStock(List<dynamic> s) async{
    await _store.record('stocks').put(_db, s);
  }

  @override
  getListStock() async{
    var lista = await _store.record('stocks').get(_db) as List<dynamic>;
    return lista.map((s) => Stock.fromMap(s)).toList();
  }

  @override
  getIdUsuario() async {
    try {
      int id = await _store.record("idUsuario").get(_db) as dynamic;
      return id;
    } catch (e) {
      return null;
    }
  }

  @override
  getIdBanca() async {
    try {
      Banca b = Banca.fromMap(await _store.record("banca").get(_db) as dynamic);
      return b.id;
    } catch (e) {
      return null;
    }
  }

  @override
  getPrinter() async {
    try {
      var printer = await _store.record("printer").get(_db) as dynamic;
      return printer;
    } catch (e) {
      return null;
    }
  }

  @override
  getPlantForm() {
    // TODO: implement getPlantForm
    print("Mobile Platform Sembas");
    // throw UnimplementedError();
  }

  
}

CrossSembas getSembas() => MobileSembas();
