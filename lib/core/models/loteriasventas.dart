

import 'package:loterias/core/classes/utils.dart';

class LoteriasVentas{
   int id;
   double ventas;
   double premios;
   String descripcion;

  LoteriasVentas({this.id, this.ventas, this.premios, this.descripcion});

LoteriasVentas.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        ventas = Utils.toDouble(snapshot['ventas'].toString()) ?? 0,
        premios = Utils.toDouble(snapshot['premios'].toString()) ?? 0,
        descripcion = snapshot['descripcion'] ?? ''
        ;

  toJson() {
    return {
      "id": id,
      "ventas": ventas,
      "premios": premios,
      "descripcion": descripcion,
    };
  }

}

// flutter packages pub run build_runner build