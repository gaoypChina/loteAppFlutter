

import 'package:loterias/core/classes/utils.dart';

class Blocksplays{
   int id;
   int idBanca;
   int idLoteria;
   int idSorteo;
   String jugada;
   double montoInicial;
   double monto;
   DateTime fechaDesde;
   DateTime fechaHasta;
   DateTime created_at;
   int ignorarDemasBloqueos;
   int status;
   int idMoneda;
   int descontarDelBloqueoGeneral;

  Blocksplays(this.id, this.idBanca, this.idLoteria, this.idSorteo, this.jugada, this.montoInicial, this.monto, this.created_at, this.fechaDesde, this.fechaHasta, this.ignorarDemasBloqueos, this.status, this.idMoneda, this.descontarDelBloqueoGeneral);

Blocksplays.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? Utils.toInt(snapshot['id']) : 0,
        idBanca = snapshot['idBanca'] != null ? Utils.toInt(snapshot['idBanca']) : 0,
        idLoteria = snapshot['idLoteria'] != null ? Utils.toInt(snapshot['idLoteria']) : 0,
        idSorteo = snapshot['idSorteo'] != null ? Utils.toInt(snapshot['idSorteo']) : 0,
        jugada = snapshot['jugada'] ?? '',
        montoInicial = double.parse(snapshot['montoInicial'].toString()) ?? 0,
        monto = double.parse(snapshot['monto'].toString()) ?? 0,
        fechaDesde = snapshot['fechaDesde'] != null ? DateTime.parse(snapshot['fechaDesde']) : DateTime.now(),
        fechaHasta = snapshot['fechaHasta'] != null ? DateTime.parse(snapshot['fechaHasta']) : DateTime.now(),
        created_at = snapshot['created_at'] != null ? DateTime.parse(snapshot['created_at']) : DateTime.now(),
        ignorarDemasBloqueos = snapshot['ignorarDemasBloqueos'] != null ? Utils.toInt(snapshot['ignorarDemasBloqueos']) : 0,
        status = snapshot['status'] != null ? Utils.toInt(snapshot['status']) : 0,
        idMoneda = snapshot['idMoneda'] != null ? Utils.toInt(snapshot['idMoneda']) : 0,
        descontarDelBloqueoGeneral =  Utils.toInt(snapshot['descontarDelBloqueoGeneral'])
        ;

  static List<Blocksplays> fromMapList(var parsed) => parsed != null ? parsed.map<Blocksplays>((json) => Blocksplays.fromMap(json)).toList() : [];
  
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
      "fechaDesde": fechaDesde.toString(),
      "fechaHasta": fechaHasta.toString(),
      "ignorarDemasBloqueos": ignorarDemasBloqueos,
      "status": status,
      "idMoneda": idMoneda,
      "descontarDelBloqueoGeneral": descontarDelBloqueoGeneral,
    };
  }

  static List blocksplaysToJson(List<Blocksplays> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build