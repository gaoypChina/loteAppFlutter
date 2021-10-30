import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/pago.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/models/tipos.dart';

class Pagodetalle{
   int id;
   int idPago;
   Pago pago;
   int idTipo;
   Tipo tipo;
   String cliente;
   int diasUsados;
   double precioPorDia;
   DateTime fechaHasta;
   DateTime fechaPagado;
   String nota;

  Pagodetalle({this.id, this.idPago, this.pago, this.idTipo, this.tipo, this.precioPorDia, this.diasUsados, this.cliente, this.fechaHasta, this.fechaPagado, this.nota});

Pagodetalle.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        idPago = Utils.toInt(snapshot['idPago']) ?? 0,
        pago = snapshot['pago'] != null ? Pago.fromMap(Utils.parsedToJsonOrNot(snapshot['pago'])) : null,
        idTipo = Utils.toInt(snapshot['idTipo']) ?? 0,
        tipo = snapshot['tipo'] != null ? Tipo.fromMap(Utils.parsedToJsonOrNot(snapshot['tipo'])) : null,
        diasUsados = Utils.toInt(snapshot['diasUsados']) ?? 0,
        cliente = snapshot['cliente'] ?? '',
        fechaHasta = snapshot['fechaHasta'] != null ? DateTime.parse(snapshot['fechaHasta']) : null,
        fechaPagado = snapshot['fechaPagado'] != null ? DateTime.parse(snapshot['fechaPagado']) : null,
        precioPorDia = Utils.toDouble(snapshot['precioPorDia']) ?? 0,
        nota = snapshot['nota'] ?? ''
        ;

  toJson() {
    return {
      "id": id,
      "idPago": idPago,
      "pago": pago != null ? pago.toJson() : null,
      "idTipo": idTipo,
      "tipo": tipo != null ? tipo.toJson() : null,
      "fechaHasta": fechaHasta != null ? fechaHasta.toString() : null,
      "fechaPagado": fechaPagado != null ? fechaPagado.toString() : null,
      "precioPorDia": precioPorDia,
      "diasUsados": diasUsados,
      "nota": nota,
    };
  }

  static List PagodetalleToJson(List<Pagodetalle> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}