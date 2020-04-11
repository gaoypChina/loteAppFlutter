
import 'package:loterias/core/models/draws.dart';

class Loteria {
  int id;
  String descripcion;
  String primera;
  String segunda;
  String tercera;
  String pick3;
  String pick4;
  int status;
  List<Draws> sorteos;

  Loteria({this.id, this.descripcion, this.status, this.sorteos});

  Loteria.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        primera = snapshot['primera'] ?? '',
        segunda = snapshot['segunda'] ?? '',
        tercera = snapshot['tercera'] ?? '',
        pick3 = snapshot['pick3'] ?? '',
        pick4 = snapshot['pick4'] ?? '',
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
    if(sorteos != null)
      return sorteos.map((data) => Draws.fromMap(data)).toList();
    else
      return List<Draws>();
  }

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "status": status,
      "primera": primera,
      "segunda": segunda,
      "tercera": tercera,
      "pick3": pick3,
      "pick4": pick4,
    };
  }
}