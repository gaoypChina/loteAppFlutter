import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/servidores.dart';

class Pago{
   int id;
   Servidor servidor;
   String cliente;
   double total;
   double descuento;
   DateTime fechaHasta;
   DateTime fechaPagado;
   String nota;

  Pago({this.id, this.servidor, this.descuento, this.total, this.cliente, this.fechaHasta, this.fechaPagado, this.nota});

Pago.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        servidor = snapshot['servidor'] != null ? Servidor.fromMap(Utils.parsedToJsonOrNot(snapshot['servidor'])) : null,
        total = Utils.toDouble(snapshot['total']) ?? 0,
        cliente = snapshot['cliente'] ?? '',
        fechaHasta = snapshot['fechaHasta'] != null ? DateTime.parse(snapshot['fechaHasta']) : null,
        fechaPagado = snapshot['fechaPagado'] != null ? DateTime.parse(snapshot['fechaPagado']) : null,
        descuento = Utils.toDouble(snapshot['descuento']) ?? 0,
        nota = snapshot['nota'] ?? ''
        ;

  toJson() {
    return {
      "id": id,
      "servidor": servidor != null ? servidor.toJson() : null,
      "fechaHasta": fechaHasta != null ? fechaHasta.toString() : null,
      "fechaPagado": fechaPagado != null ? fechaPagado.toString() : null,
      "descuento": descuento,
      "total": total,
      "nota": nota,
    };
  }

  static List PagoToJson(List<Pago> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}