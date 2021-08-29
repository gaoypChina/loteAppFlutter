

import 'package:loterias/core/classes/utils.dart';

class Blocksplaysgenerals{
   int id;
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

  Blocksplaysgenerals(this.id, this.idLoteria, this.idSorteo, this.jugada, this.montoInicial, this.monto, this.created_at, this.fechaDesde, this.fechaHasta, this.ignorarDemasBloqueos, this.status, this.idMoneda);

Blocksplaysgenerals.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? Utils.toInt(snapshot['id']) : 0,
        idLoteria = snapshot['idLoteria'] != null ? Utils.toInt(snapshot['idLoteria']) : 0,
        idSorteo = snapshot['idSorteo'] != null ? Utils.toInt(snapshot['idSorteo']) : 0,
        jugada = snapshot['jugada'] ?? '',
        montoInicial = double.parse(snapshot['montoInicial'].toString()) ?? 0,
        monto = double.parse(snapshot['monto'].toString()) ?? 0,
        fechaDesde = DateTime.parse(snapshot['fechaDesde']) ?? null,
        fechaHasta = DateTime.parse(snapshot['fechaHasta']) ?? null,
        created_at = DateTime.parse(snapshot['created_at']) ?? null,
        ignorarDemasBloqueos = snapshot['ignorarDemasBloqueos'] != null ? Utils.toInt(snapshot['ignorarDemasBloqueos']) : 0,
        status = snapshot['status'] != null ? Utils.toInt(snapshot['status']) : 0,
        idMoneda = snapshot['idMoneda'] != null ? Utils.toInt(snapshot['idMoneda']) : 0
        ;

  static List<Blocksplaysgenerals> fromMapList(var parsed) => parsed != null ? parsed.map<Blocksplaysgenerals>((json) => Blocksplaysgenerals.fromMap(json)).toList() : [];

  toJson() {
    return {
      "id": id,
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
    };
  }

  static List blocksplaysgeneralsToJson(List<Blocksplaysgenerals> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build