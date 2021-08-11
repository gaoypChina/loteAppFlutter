

class Stock{
   int id;
   int idBanca;
   int idLoteria;
   int idLoteriaSuperpale;
   int idSorteo;
   String jugada;
   double montoInicial;
   double monto;
   DateTime created_at;
   int esBloqueoJugada;
   int esGeneral;
   int ignorarDemasBloqueos;
   int idMoneda;
   int descontarDelBloqueoGeneral;

  Stock({this.id, this.idBanca, this.idLoteria, this.idLoteriaSuperpale, this.idSorteo, this.jugada, this.montoInicial, this.monto, this.created_at, this.esBloqueoJugada, this.esGeneral, this.ignorarDemasBloqueos, this.idMoneda, this.descontarDelBloqueoGeneral});

Stock.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        idBanca = snapshot['idBanca'] ?? 0,
        idLoteria = snapshot['idLoteria'] ?? 0,
        idLoteriaSuperpale = snapshot['idLoteriaSuperpale'] ?? 0,
        idSorteo = snapshot['idSorteo'] ?? 0,
        jugada = snapshot['jugada'] ?? '',
        montoInicial = double.parse(snapshot['montoInicial'].toString()) ?? 0,
        monto = double.parse(snapshot['monto'].toString()) ?? 0,
        created_at = DateTime.parse(snapshot['created_at']) ?? null,
        esBloqueoJugada =  snapshot['esBloqueoJugada'] ?? 0,
        esGeneral = snapshot['esGeneral'] ?? 0,
        ignorarDemasBloqueos =  snapshot['ignorarDemasBloqueos'] != null ? snapshot['ignorarDemasBloqueos'] is bool ? snapshot['ignorarDemasBloqueos'] == true ? 1 : 0 : snapshot['ignorarDemasBloqueos'] : 0,
        descontarDelBloqueoGeneral =  snapshot['descontarDelBloqueoGeneral'] != null ? snapshot['descontarDelBloqueoGeneral'] is bool ? snapshot['descontarDelBloqueoGeneral'] == true ? 1 : 0 : snapshot['descontarDelBloqueoGeneral'] : 0,
        idMoneda = snapshot['idMoneda'] ?? 0
        ;

  static List<Stock> fromMapList(var parsed) => parsed != null ? parsed.map<Stock>((json) => Stock.fromMap(json)).toList() : [];

  toJson() {
    return {
      "id": id,
      "idBanca": idBanca,
      "idLoteria": idLoteria,
      "idLoteriaSuperpale": idLoteriaSuperpale,
      "idSorteo": idSorteo,
      "jugada": jugada,
      "montoInicial": montoInicial,
      "monto": monto,
      "created_at": created_at.toString(),
      "esBloqueoJugada": esBloqueoJugada,
      "esGeneral": esGeneral,
      "ignorarDemasBloqueos": ignorarDemasBloqueos,
      "idMoneda": idMoneda,
      "descontarDelBloqueoGeneral": descontarDelBloqueoGeneral,
    };
  }

  static List stocksToJson(List<Stock> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build