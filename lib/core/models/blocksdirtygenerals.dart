

import 'package:loterias/core/classes/utils.dart';

class Blocksdirtygenerals{
   int id;
   int idLoteria;
   int idSorteo;
   int cantidad;
   DateTime created_at;
   int idMoneda;

  Blocksdirtygenerals(this.id, this.idLoteria, this.idSorteo, this.cantidad, this.created_at, this.idMoneda);

Blocksdirtygenerals.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? Utils.toInt(snapshot['id']) : 0,
        idLoteria = snapshot['idLoteria'] != null ? Utils.toInt(snapshot['idLoteria']) : 0,
        idSorteo = snapshot['idSorteo'] != null ? Utils.toInt(snapshot['idSorteo']) : 0,
        cantidad = snapshot['cantidad'] != null ? Utils.toInt(snapshot['cantidad']) : 0,
        created_at = DateTime.parse(snapshot['created_at']) ?? null,
        idMoneda = snapshot['idMoneda'] != null ? Utils.toInt(snapshot['idMoneda']) : 0
        ;

  toJson() {
    return {
      "id": id,
      "idLoteria": idLoteria,
      "idSorteo": idSorteo,
      "cantidad": cantidad,
      "created_at": created_at.toString(),
      "idMoneda": idMoneda,
    };
  }

  static List blocksdirtygeneralsToJson(List<Blocksdirtygenerals> lista) {
    List jsonList = List();
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build