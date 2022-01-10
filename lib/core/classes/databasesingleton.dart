

library singleton;
import 'package:loterias/core/classes/cross_platform_database/cross_platform_db.dart';

import 'drift_database.dart';
// AppDatabase Db = (new DatabaseSingleton()).db;
CrossDB Db = (new DatabaseSingleton()).db;

class DatabaseSingleton {
  static final DatabaseSingleton _singleton = DatabaseSingleton._internal();
  dynamic db;

  factory DatabaseSingleton() {
    return _singleton;
  }

  // Db._internal();
  DatabaseSingleton._internal(){
    db = CrossDB().openConnection();
    print("DatabaseSIngleton null: ${db == null}");
  }
}