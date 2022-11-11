
import 'package:loterias/core/classes/utils.dart';

class Venta {
  BigInt id;
  BigInt idTicket;
  double total;
  double premios;
  int status;
  String codigoBarra;
  DateTime created_at;
  String usuario;
  String usuarioCancelacion;
  DateTime fechaCancelacion;
  double montoAPagar;
  double montoPagado;
  String descripcion;


  Venta({this.id, this.idTicket, this.total, this.status, this.codigoBarra, this.usuario, this.descripcion});

  Venta.fromMap(Map snapshot) :
        id = Utils.toBigInt(snapshot['id']),
        idTicket = Utils.toBigInt(snapshot['idTicket']),
        total = Utils.toDouble(snapshot['total']),
        premios = Utils.toDouble(snapshot['premios']),
        status = Utils.toInt(snapshot['status']),
        codigoBarra = snapshot['codigoBarra'] ?? '1',
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null,
        usuario = (snapshot['usuario'] != null) ? snapshot['usuario'] : null,
        usuarioCancelacion = (snapshot['usuarioCancelacion'] != null) ? snapshot['usuarioCancelacion'] : null,
        fechaCancelacion = (snapshot['fechaCancelacion'] != null) ? DateTime.parse(snapshot['fechaCancelacion']) : null,
        montoAPagar = Utils.toDouble(snapshot['montoAPagar']),
        montoPagado = Utils.toDouble(snapshot['montoPagado']),
        descripcion = (snapshot['descripcion'] != null) ? snapshot['descripcion'] : ''
        ;

  toJson() {
    return {
      "id": id,
      "idTicket": idTicket,
      "total": total,
      "status": status,
      "codigoBarra": codigoBarra,
      "premios": premios,
      "created_at": (created_at != null) ? created_at.toString() : null,
      "fechaCancelacion": (fechaCancelacion != null) ? fechaCancelacion.toString() : null,
      "usuarioCancelacion": usuarioCancelacion,
    };
  }
}