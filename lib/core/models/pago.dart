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
   double precioPorBanca;
   double descuento;
   double cargo;
   DateTime fechaDiaPago;
   DateTime fechaDiasGracia;
   DateTime fechaPagado;
   String nota;
   List<Pagodetalle> detalles;
   int detallesCount;

  Pago({this.id, this.servidor, this.usuario, this.descuento, this.cargo, this.total, this.precioPorBanca, this.cliente, this.fechaDiaPago, this.fechaDiasGracia, this.fechaPagado, this.nota, this.detalles});

Pago.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        servidor = snapshot['servidor'] != null ? Servidor.fromMap(Utils.parsedToJsonOrNot(snapshot['servidor'])) : null,
        usuario = snapshot['usuario'] != null ? Usuario.fromMap(Utils.parsedToJsonOrNot(snapshot['usuario'])) : null,
        total = Utils.toDouble(snapshot['total']) ?? 0,
        precioPorBanca = Utils.toDouble(snapshot['precioPorBanca']) ?? 0,
        cliente = snapshot['cliente'] ?? '',
        fechaDiaPago = snapshot['fechaDiaPago'] != null ? DateTime.parse(snapshot['fechaDiaPago']) : null,
        fechaDiasGracia = snapshot['fechaDiasGracia'] != null ? DateTime.parse(snapshot['fechaDiasGracia']) : null,
        fechaPagado = snapshot['fechaPagado'] != null ? DateTime.parse(snapshot['fechaPagado']) : null,
        descuento = Utils.toDouble(snapshot['descuento']) ?? 0,
        cargo = Utils.toDouble(snapshot['cargo']) ?? 0,
        nota = snapshot['nota'] ?? '',
        detalles = detallesToMap(snapshot['detalles']) ?? [],
        detallesCount = Utils.toInt(snapshot['detallesCount']) ?? 0
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
      "fechaDiaPago": fechaDiaPago != null ? fechaDiaPago.toString() : null,
      "fechaDiasGracia": fechaDiasGracia != null ? fechaDiasGracia.toString() : null,
      "fechaPagado": fechaPagado != null ? fechaPagado.toString() : null,
      "descuento": descuento,
      "cargo": cargo,
      "total": total,
      "precioPorBanca": precioPorBanca,
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