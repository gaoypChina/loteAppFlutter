
import 'package:loterias/core/models/draws.dart';

class Loteria {
  int id;
  String descripcion;
  int status;
  List<Draws> sorteos;

  Loteria({this.id, this.descripcion, this.status, this.sorteos});

  Loteria.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        status = snapshot['status'] ?? 1,
        sorteos = sorteosToMap(snapshot['sorteos']) ?? List()
        ;

List sorteosToJson() {

    List jsonList = List();
    sorteos.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

  static List<Draws> sorteosToMap(List<dynamic> sorteos){
    return sorteos.map((data) => Draws.fromMap(data)).toList();
  }

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "status": status,
    };
  }
}