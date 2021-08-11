

class Blockslotteries{
   int id;
   int idBanca;
   int idDia;
   int idLoteria;
   int idSorteo;
   double monto;
   DateTime created_at;
   int idMoneda;
   int descontarDelBloqueoGeneral;

  Blockslotteries(this.id, this.idBanca, this.idDia, this.idLoteria, this.idSorteo, this.monto, this.created_at, this.idMoneda, this.descontarDelBloqueoGeneral);

Blockslotteries.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        idBanca = snapshot['idBanca'] ?? 0,
        idDia = snapshot['idDia'] ?? 0,
        idLoteria = snapshot['idLoteria'] ?? 0,
        idSorteo = snapshot['idSorteo'] ?? 0,
        monto = double.parse(snapshot['monto'].toString()) ?? 0,
        created_at = DateTime.parse(snapshot['created_at']) ?? null,
        idMoneda = snapshot['idMoneda'] ?? 0,
        descontarDelBloqueoGeneral =  snapshot['descontarDelBloqueoGeneral'] != null ? snapshot['descontarDelBloqueoGeneral'] is bool ? snapshot['descontarDelBloqueoGeneral'] == true ? 1 : 0 : snapshot['descontarDelBloqueoGeneral'] : 0
        ;

  toJson() {
    return {
      "id": id,
      "idBanca": idBanca,
      "idDia": idDia,
      "idLoteria": idLoteria,
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