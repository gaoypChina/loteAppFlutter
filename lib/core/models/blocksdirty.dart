

import 'package:loterias/core/classes/utils.dart';

class Blocksdirty{
   int id;
   int idBanca;
   int idLoteria;
   int idSorteo;
   int cantidad;
   DateTime created_at;
   int idMoneda;

  Blocksdirty(this.id, this.idBanca, this.idLoteria, this.idSorteo, this.cantidad, this.created_at, this.idMoneda);

Blocksdirty.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        idBanca = snapshot['idBanca'] ?? 0,
        idLoteria = snapshot['idLoteria'] ?? 0,
        idSorteo = snapshot['idSorteo'] ?? 0,
        cantidad = Utils.toInt(snapshot['cantidad'].toString()) ?? 0,
        created_at = DateTime.parse(snapshot['created_at']) ?? null,
        idMoneda = snapshot['idMoneda'] ?? 0
        ;

  toJson() {
    return {
      "id": id,
      "idBanca": idBanca,
      "idLoteria": idLoteria,
      "idSorteo": idSorteo,
      "cantidad": cantidad,
      "created_at": created_at.toString(),
      "idMoneda": idMoneda,
    };
  }

  static List blocksdirtyToJson(List<Blocksdirty> lista) {
    List jsonList = List();
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build