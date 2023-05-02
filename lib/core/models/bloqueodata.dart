

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bloqueo.dart';
import 'package:loterias/core/models/draws.dart';

class BloqueoData{
   Draws sorteo;
   List<Bloqueo> bloqueos;

  BloqueoData({this.bloqueos, this.sorteo});

  BloqueoData.fromMap(Map snapshot) :
        bloqueos = Bloqueo.fromMapList(snapshot['bloqueos']),
        sorteo = snapshot['sorteo'] != null ? Draws.fromMap(snapshot['sorteo']) : null
        ;

  static List<BloqueoData> fromMapList(var parsed) => parsed != null ? parsed.map<BloqueoData>((json) => BloqueoData.fromMap(json)).toList() : [];

  toJson() {
    return {
      "bloqueos": bloqueos,
      "sorteo": sorteo,
    };
  }

  static List BloqueoDataToJson(List<BloqueoData> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build