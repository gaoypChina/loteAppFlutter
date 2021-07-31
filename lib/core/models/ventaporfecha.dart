
import 'package:loterias/core/classes/utils.dart';

class VentaPorFecha {
  double ventas;
  double premios;
  double comisiones;
  double descuentoMonto;
  double neto;
  DateTime created_at;


  VentaPorFecha({this.neto, this.premios, this.ventas, this.comisiones, this.descuentoMonto, this.created_at});

  VentaPorFecha.fromMap(Map snapshot) :
        ventas = Utils.toDouble(snapshot['ventas'].toString()) ?? 0,
        premios = Utils.toDouble(snapshot['premios'].toString()) ?? 0,
        comisiones = Utils.toDouble(snapshot['comisiones'].toString()) ?? 0,
        descuentoMonto = Utils.toDouble(snapshot['descuentoMonto'].toString()) ?? 0,
        neto = Utils.toDouble(snapshot['neto'].toString()) ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null
        ;

  toJson() {
    return {
      "neto": neto,
      "comisiones": comisiones,
      "descuentoMonto": descuentoMonto,
      "ventas": ventas,
      "premios": premios,
      "created_at": (created_at != null) ? created_at.toString() : null,
    };
  }
}