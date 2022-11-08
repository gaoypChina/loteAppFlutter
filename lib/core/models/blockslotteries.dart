

import 'package:loterias/core/classes/utils.dart';

class Blockslotteries{
   int id;
   int idBanca;
   int idDia;
   int idLoteria;
   int idLoteriaSuperpale;
   int idSorteo;
   double monto;
   DateTime created_at;
   int idMoneda;
   int descontarDelBloqueoGeneral;

  Blockslotteries(this.id, this.idBanca, this.idDia, this.idLoteria, this.idSorteo, this.monto, this.created_at, this.idMoneda, this.descontarDelBloqueoGeneral);

Blockslotteries.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? Utils.toInt(snapshot['id']) : 0,
        idBanca = snapshot['idBanca'] != null ? Utils.toInt(snapshot['idBanca']) : 0,
        idDia = snapshot['idDia'] != null ? Utils.toInt(snapshot['idDia']) : 0,
        idLoteria = snapshot['idLoteria'] != null ? Utils.toInt(snapshot['idLoteria']) : 0,
        idLoteriaSuperpale = Utils.toInt(snapshot['idLoteriaSuperpale'], returnNullIfNotInt: true),
        idSorteo = snapshot['idSorteo'] != null ? Utils.toInt(snapshot['idSorteo']) : 0,
        monto = double.parse(snapshot['monto'].toString()) ?? 0,
        created_at = snapshot['created_at'] != null ? DateTime.parse(snapshot['created_at']) : DateTime.now(),
        idMoneda = snapshot['idMoneda'] != null ? Utils.toInt(snapshot['idMoneda']) : 0,
        descontarDelBloqueoGeneral =  Utils.toInt(snapshot['descontarDelBloqueoGeneral'])
        ;

  static List<Blockslotteries> fromMapList(var parsed) => parsed != null ? parsed.map<Blockslotteries>((json) => Blockslotteries.fromMap(json)).toList() : [];

  
  toJson() {
    return {
      "id": id,
      "idBanca": idBanca,
      "idDia": idDia,
      "idLoteria": idLoteria,
      "idLoteriaSuperpale": idLoteriaSuperpale,
      "idSorteo": idSorteo,
      "monto": monto,
      "created_at": created_at.toString(),
      "idMoneda": idMoneda,
      "descontarDelBloqueoGeneral": descontarDelBloqueoGeneral,
    };
  }

  static List blockslotteriesToJson(List<Blockslotteries> lista) {
    List jsonList =[];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build