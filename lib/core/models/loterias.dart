
import 'package:loterias/core/models/draws.dart';

class Loteria {
  int id;
  String descripcion;
  String abreviatura;
  String primera;
  String segunda;
  String tercera;
  String pick3;
  String pick4;
  int status;
  List<Draws> sorteos;
  List<Loteria> loteriaSuperpale;
  String horaCierre;
  int minutosExtras;

  Loteria({this.id, this.descripcion, this.abreviatura, this.status, this.sorteos, this.horaCierre, this.minutosExtras, this.loteriaSuperpale});

  Loteria.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        abreviatura = snapshot['abreviatura'] ?? '',
        primera = snapshot['primera'] ?? '',
        segunda = snapshot['segunda'] ?? '',
        tercera = snapshot['tercera'] ?? '',
        pick3 = snapshot['pick3'] ?? '',
        pick4 = snapshot['pick4'] ?? '',
        status = snapshot['status'] ?? 1,
        sorteos = sorteosToMap(snapshot['sorteos']) ?? List(),
        loteriaSuperpale = loteriaSuperpaleToMap(snapshot['loteriaSuperpale']) ?? List(),
        horaCierre= snapshot['horaCierre'] ?? '',
        minutosExtras = snapshot['minutosExtras'] ?? 0
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

  static List<Loteria> loteriaSuperpaleToMap(List<dynamic> loterias){
    if(loterias != null)
      return loterias.map((data) => Loteria.fromMap(data)).toList();
    else
      return List<Loteria>();
  }

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "abreviatura": abreviatura,
      "status": status,
      "primera": primera,
      "segunda": segunda,
      "tercera": tercera,
      "pick3": pick3,
      "pick4": pick4,
      "horaCierre": horaCierre,
      "minutosExtras": minutosExtras,
    };
  }
}