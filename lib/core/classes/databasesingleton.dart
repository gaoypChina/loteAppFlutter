

library singleton;
import 'package:loterias/core/classes/cross_platform_database/cross_platform_db.dart';
var Db = (new DatabaseSingleton()).db;

class DatabaseSingleton {
  static final DatabaseSingleton _singleton = DatabaseSingleton._internal();
  dynamic db;

  factory DatabaseSingleton() {
    return _singleton;
  }

  // Db._internal();
  DatabaseSingleton._internal(){
    db = CrossDB();
    print("DatabaseSIngleton null: ${db == null}");
  }
}