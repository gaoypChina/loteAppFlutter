
import 'package:loterias/core/classes/utils.dart';

class GraficaVentas {
  String dia;
  double total;
  double neto;
  double premios;


  GraficaVentas({this.dia, this.total, this.neto, this.premios});

  GraficaVentas.fromMap(Map snapshot) :
        dia = snapshot['dia'] ?? '',
        total = Utils.toDouble(snapshot['total'].toString()) ?? 0,
        neto = Utils.toDouble(snapshot['neto'].toString()) ?? 0,
        premios = Utils.toDouble(snapshot['premios'].toString()) ?? 0
        ;

  toJson() {
    return {
      "dia": dia,
      "total": total,
      "neto": neto,
      "premios": premios,
    };
  }
}