

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/loterias.dart';

class Cierreloteria{
   int id;
   Loteria loteria;
   int idLoteria;
   DateTime date;

  Cierreloteria({this.id, this.loteria, this.idLoteria, this.date});

Cierreloteria.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        date = (snapshot['date'] != null) ? DateTime.parse(snapshot['date']) : null,
        idLoteria = Utils.toInt(snapshot['idLoteria'], returnNullIfNotInt: true),
        loteria = snapshot['loteria'] != null ? Loteria.fromMap(Utils.parsedToJsonOrNot(snapshot['loteria'])) : null
        ;

  toJson() {
    return {
      "id": id,
      "loteria": loteria != null ? loteria.toJson() : null,
      "date": date != null ? Utils.dateTimeToDate(date, null) : null,
      "idLoteria": idLoteria,
    };
  }

  static List cierreloteriaToJson(List<Cierreloteria> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build