

import 'package:loterias/core/classes/utils.dart';

class EstadisticaJugada{
   int id;
   int idLoteria;
   int idSorteo;
   int cantidad;
   String descripcion;
   String descripcionSorteo;

  EstadisticaJugada({this.id, this.idLoteria, this.idSorteo, this.cantidad, this.descripcion, this.descripcionSorteo});

EstadisticaJugada.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        idLoteria = snapshot['idLoteria'] ?? 0,
        idSorteo = snapshot['idSorteo'] ?? 0,
        cantidad = Utils.toInt(snapshot['cantidad'].toString()) ?? 0
        ;

  toJson() {
    return {
      "id": id,
      "idLoteria": idLoteria,
      "idSorteo": idSorteo,
      "cantidad": cantidad,
    };
  }

  static List EstadisticaJugadaToJson(List<EstadisticaJugada> lista) {
    List jsonList = List();
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build