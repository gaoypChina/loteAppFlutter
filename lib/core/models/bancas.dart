
import 'package:loterias/core/classes/utils.dart';

class Banca {
  int id;
  String descripcion;
  String codigo;
  int status;
  int idMoneda;
  String moneda;
  String monedaAbreviatura;
  String monedaColor;
  double descontar;
  double deCada;

  Banca({this.id, this.descripcion, this.codigo, this.status, this.idMoneda, this.moneda, this.monedaAbreviatura, this.monedaColor, this.descontar, this.deCada});

  Banca.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        codigo = snapshot['codigo'] ?? '',
        status = snapshot['status'] ?? 1,
        idMoneda = snapshot['idMoneda'] ?? 1,
        moneda = snapshot['moneda'] ?? '',
        monedaAbreviatura = snapshot['monedaAbreviatura'] ?? '',
        monedaColor = snapshot['monedaColor'] ?? '',
        descontar = Utils.toDouble(snapshot['descontar'].toString()) ?? 0.0,
        deCada = Utils.toDouble(snapshot['deCada'].toString()) ?? 0.0
        ;

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "codigo": codigo,
      "status": status,
      "idMoneda": idMoneda,
      "moneda": moneda,
      "monedaAbreviatura": monedaAbreviatura,
      "monedaColor": monedaColor,
      "descontar": descontar,
      "deCada": deCada,
    };
  }
}