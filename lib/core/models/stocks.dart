

import 'package:loterias/core/classes/utils.dart';

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

  Stock({this.id, this.idBanca, this.idLoteria, this.idLoteriaSuperpale, this.idSorteo, this.jugada, this.montoInicial, this.monto, this.created_at, this.esBloqueoJugada = 0, this.esGeneral, this.ignorarDemasBloqueos, this.idMoneda, this.descontarDelBloqueoGeneral});

Stock.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        idBanca = Utils.toInt(snapshot['idBanca']) ?? 0,
        idLoteria = Utils.toInt(snapshot['idLoteria']) ?? 0,
        idLoteriaSuperpale = Utils.toInt(snapshot['idLoteriaSuperpale']) ?? 0,
        idSorteo = Utils.toInt(snapshot['idSorteo']) ?? 0,
        jugada = snapshot['jugada'] ?? '',
        montoInicial = double.parse(snapshot['montoInicial'].toString()) ?? 0,
        monto = double.parse(snapshot['monto'].toString()) ?? 0,
        created_at = snapshot['created_at'] != null ? DateTime.parse(snapshot['created_at']) : DateTime.now(),
        esBloqueoJugada =  Utils.toInt(snapshot['esBloqueoJugada']),
        esGeneral = Utils.toInt(snapshot['esGeneral']) ?? 0,
        ignorarDemasBloqueos = Utils.toInt(snapshot['ignorarDemasBloqueos']),
        descontarDelBloqueoGeneral =  Utils.toInt(snapshot['descontarDelBloqueoGeneral']),
        idMoneda = Utils.toInt(snapshot['idMoneda']) ?? 0
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