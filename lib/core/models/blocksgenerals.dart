

import 'package:loterias/core/classes/utils.dart';

class Blocksgenerals{
   int id;
   int idDia;
   int idLoteria;
   int idSorteo;
   double monto;
   DateTime created_at;
   int idMoneda;
   int idLoteriaSuperpale;

  Blocksgenerals(this.id, this.idDia, this.idLoteria, this.idLoteriaSuperpale, this.idSorteo, this.monto, this.created_at, this.idMoneda);

Blocksgenerals.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? Utils.toInt(snapshot['id']) : 0,
        idDia = snapshot['idDia'] != null ? Utils.toInt(snapshot['idDia']) : 0,
        idLoteria = snapshot['idLoteria'] != null ? Utils.toInt(snapshot['idLoteria']) : 0,
        idLoteriaSuperpale = Utils.toInt(snapshot['idLoteriaSuperpale'], returnNullIfNotInt: true),
        idSorteo = snapshot['idSorteo'] != null ? Utils.toInt(snapshot['idSorteo']) : 0,
        monto = double.parse(snapshot['monto'].toString()) ?? 0,
        created_at = snapshot['created_at'] != null ? DateTime.parse(snapshot['created_at']) : DateTime.now(),
        idMoneda = snapshot['idMoneda'] != null ? Utils.toInt(snapshot['idMoneda']) : 0
        ;

  static List<Blocksgenerals> fromMapList(var parsed) => parsed != null ? parsed.map<Blocksgenerals>((json) => Blocksgenerals.fromMap(json)).toList() : [];


  toJson() {
    return {
      "id": id,
      "idDia": idDia,
      "idLoteria": idLoteria,
      "idLoteriaSuperpale": idLoteriaSuperpale,
      "idSorteo": idSorteo,
      "monto": monto,
      "created_at": created_at.toString(),
      "idMoneda": idMoneda,
    };
  }

  static List blocksgeneralsToJson(List<Blocksgenerals> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build