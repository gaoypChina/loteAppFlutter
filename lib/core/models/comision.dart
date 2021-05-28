

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/loterias.dart';

class Comision{
   int id;
   int idBanca;
   int idLoteria;
   Loteria loteria;
   double directo;
   double pale;
   double tripleta;
   double superPale;
   double pick3Straight;
   double pick3Box;
   double pick4Straight;
   double pick4Box;
   DateTime created_at;

  Comision(this.id, this.idBanca, this.idLoteria, this.loteria, this.directo, this.pale, this.tripleta, this.superPale, this.pick3Straight, this.pick3Box, this.pick4Straight, this.pick4Box, this.created_at,);

Comision.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        idBanca = snapshot['idBanca'] ?? 0,
        idLoteria = snapshot['idLoteria'] ?? 0,
        loteria = snapshot['loteria'] != null ? Loteria.fromMap(Utils.parsedToJsonOrNot(snapshot['loteria'])) : null,
        directo = double.tryParse(snapshot['directo'].toString()) ?? 0,
        pale = double.tryParse(snapshot['pale'].toString()) ?? 0,
        tripleta = double.tryParse(snapshot['tripleta'].toString()) ?? 0,
        superPale = double.tryParse(snapshot['superPale'].toString()) ?? 0,
        pick3Straight = double.tryParse(snapshot['pick3Straight'].toString()) ?? 0,
        pick3Box = double.tryParse(snapshot['pick3Box'].toString()) ?? 0,
        pick4Straight = double.tryParse(snapshot['pick4Straight'].toString()) ?? 0,
        pick4Box = double.tryParse(snapshot['pick4Box'].toString()) ?? 0,
        created_at = DateTime.parse(snapshot['created_at']) ?? null
        ;

  toJson() {
    return {
      "id": id,
      "idBanca": idBanca,
      "idLoteria": idLoteria,
      "loteria": loteria != null ? loteria.toJson() : null,
      "directo": directo,
      "pale": pale,
      "tripleta": tripleta,
      "superPale": superPale,
      "pick3Straight": pick3Straight,
      "pick3Box": pick3Box,
      "pick4Straight": pick4Straight,
      "pick4Box": pick4Box,
      "created_at": created_at.toString(),
    };
  }

  static List comisionesToJson(List<Comision> lista) {
    List jsonList = [];
    if(lista == null)
      return jsonList;

    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build