import 'package:loterias/core/classes/databasesingleton.dart';

import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/loterias.dart';

class SorteoService{
  static getSorteo(String jugada, [var sqfliteTransaction]) async {
    Draws sorteo;

   if(jugada.length == 2){
     var query = await Db.draw('Directo', sqfliteTransaction);
     sorteo = (query != null) ? Draws.fromMap(query) : null;
   }
  else if(jugada.length == 3){
    var query = await Db.draw('Pick 3 Straight', sqfliteTransaction);
    sorteo = (query != null) ? Draws.fromMap(query) : null;
  }
  else if(jugada.length == 4){
    if(jugada.indexOf("+") != -1){
      var query = await Db.draw('Pick 3 Box', sqfliteTransaction);
      sorteo = (query != null) ? Draws.fromMap(query) : null;
    }else{
      var query = await Db.draw('Pale', sqfliteTransaction);
      sorteo = (query != null) ? Draws.fromMap(query) : null;
    }
  }
  else if(jugada.length == 5){
    if(jugada.indexOf("+") != -1){
      var query = await Db.draw('Pick 4 Box', sqfliteTransaction);
      sorteo = (query != null) ? Draws.fromMap(query) : null;
    }
    else if(jugada.indexOf("-") != -1){
      var query = await Db.draw('Pick 4 Straight', sqfliteTransaction);
      sorteo = (query != null) ? Draws.fromMap(query) : null;
    }
    else if(jugada.indexOf("s") != -1){
      var query = await Db.draw('Super pale', sqfliteTransaction);
      sorteo = (query != null) ? Draws.fromMap(query) : null;
    }
  }
  else if(jugada.length == 6){
      var query = await Db.draw('Tripleta', sqfliteTransaction);
    sorteo = (query != null) ? Draws.fromMap(query) : null;
  }

  return sorteo;
 }

static Future<int> getIdSorteo(String jugada, [Loteria loteria, sqfliteTransaction]) async {
   int idSorteo = 0;

   if(jugada.length == 2)
    idSorteo = 1;
  else if(jugada.length == 3){
    var query = await Db.draw('Pick 3 Straight', sqfliteTransaction);
    idSorteo = (query != null) ? query['id'] : 0;
  }
  else if(jugada.length == 4){
    if(jugada.indexOf("+") != -1){
      var query = await Db.draw('Pick 3 Box', sqfliteTransaction);
      idSorteo = (query != null) ? query['id'] : 0;
    }else{
      idSorteo = 2;
    }
  }
  else if(jugada.length == 5){
    if(jugada.indexOf("+") != -1){
      var query = await Db.draw('Pick 4 Box', sqfliteTransaction);
      idSorteo = (query != null) ? query['id'] : 0;
    }
    else if(jugada.indexOf("-") != -1){
      var query = await Db.draw('Pick 4 Straight', sqfliteTransaction);
      idSorteo = (query != null) ? query['id'] : 0;
    }
    else if(jugada.indexOf("s") != -1){
      var query = await Db.draw('Super pale', sqfliteTransaction);
      idSorteo = (query != null) ? query['id'] : 0;
    }
  }
  else if(jugada.length == 6)
    idSorteo = 3;

  return idSorteo;
 }

  static Future<String> esSorteoPickQuitarUltimoCaracter(String jugada, idSorteo, [var sqfliteTransaction]) async {
    // var query = await Db.database.query('Draws', columns: ['descripcion'], where:'"id" = ?', whereArgs: [idSorteo]);
    var query = await Db.drawById(idSorteo, sqfliteTransaction);
    String sorteo = (query != null) ? query['descripcion'] : '';
    if(sorteo == 'Pick 3 Box' || sorteo == 'Pick 4 Straight' || sorteo == 'Pick 4 Box' || sorteo == 'Super pale'){
      jugada = jugada.substring(0, jugada.length - 1);
    }
    return jugada;
  }

}