import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/pagodetalle.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/models/usuario.dart';

class Pago{
   int id;
   Servidor servidor;
   Usuario usuario;
   String cliente;
   double total;
   double descuento;
   DateTime fechaHasta;
   DateTime fechaPagado;
   String nota;
   List<Pagodetalle> detalles;

  Pago({this.id, this.servidor, this.usuario, this.descuento, this.total, this.cliente, this.fechaHasta, this.fechaPagado, this.nota, this.detalles});

Pago.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        servidor = snapshot['servidor'] != null ? Servidor.fromMap(Utils.parsedToJsonOrNot(snapshot['servidor'])) : null,
        usuario = snapshot['usuario'] != null ? Usuario.fromMap(Utils.parsedToJsonOrNot(snapshot['usuario'])) : null,
        total = Utils.toDouble(snapshot['total']) ?? 0,
        cliente = snapshot['cliente'] ?? '',
        fechaHasta = snapshot['fechaHasta'] != null ? DateTime.parse(snapshot['fechaHasta']) : null,
        fechaPagado = snapshot['fechaPagado'] != null ? DateTime.parse(snapshot['fechaPagado']) : null,
        descuento = Utils.toDouble(snapshot['descuento']) ?? 0,
        nota = snapshot['nota'] ?? '',
        detalles = detallesToMap(snapshot['detalles']) ?? []
        ;

   static List<Pagodetalle> detallesToMap(List<dynamic> detalles){
    if(detalles != null)
      return detalles.map((data) => Pagodetalle.fromMap(data)).toList();
    else
      return [];
  }

  toJson() {
    return {
      "id": id,
      "servidor": servidor != null ? servidor.toJson() : null,
      "usuario": usuario != null ? usuario.toJson() : null,
      "fechaHasta": fechaHasta != null ? fechaHasta.toString() : null,
      "fechaPagado": fechaPagado != null ? fechaPagado.toString() : null,
      "descuento": descuento,
      "total": total,
      "nota": nota,
      "detalles": Pagodetalle.pagodetalleToJson(detalles),
    };
  }

  static List pagoToJson(List<Pago> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}