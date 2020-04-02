

class Stock{
   int id;
   int idBanca;
   int idLoteria;
   int idSorteo;
   String jugada;
   double montoInicial;
   double monto;
   DateTime created_at;
   int esBloqueoJugada;
   int esGeneral;
   int ignorarDemasBloqueos;
   int idMoneda;

  Stock(this.id, this.idBanca, this.idLoteria, this.idSorteo, this.jugada, this.montoInicial, this.monto, this.created_at, this.esBloqueoJugada, this.esGeneral, this.ignorarDemasBloqueos, this.idMoneda);

Stock.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        idBanca = snapshot['idBanca'] ?? 0,
        idLoteria = snapshot['idLoteria'] ?? 0,
        idSorteo = snapshot['idSorteo'] ?? 0,
        jugada = snapshot['jugada'] ?? '',
        montoInicial = double.parse(snapshot['montoInicial'].toString()) ?? 0,
        monto = double.parse(snapshot['monto'].toString()) ?? 0,
        created_at = DateTime.parse(snapshot['created_at']) ?? null,
        esBloqueoJugada =  snapshot['esBloqueoJugada'] ?? 0,
        esGeneral = snapshot['esGeneral'] ?? 0,
        ignorarDemasBloqueos = snapshot['ignorarDemasBloqueos'] ?? 0,
        idMoneda = snapshot['idMoneda'] ?? 0
        ;

  toJson() {
    return {
      "id": id,
      "idBanca": idBanca,
      "idLoteria": idLoteria,
      "idSorteo": idSorteo,
      "jugada": jugada,
      "montoInicial": montoInicial,
      "monto": monto,
      "created_at": created_at.toString(),
      "esBloqueoJugada": esBloqueoJugada,
      "esGeneral": esGeneral,
      "ignorarDemasBloqueos": ignorarDemasBloqueos,
      "idMoneda": idMoneda,
    };
  }

  static List stocksToJson(List<Stock> lista) {
    List jsonList = List();
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build