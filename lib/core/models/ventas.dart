
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


  Venta({this.id, this.idTicket, this.total, this.status, this.codigoBarra, this.usuario});

  Venta.fromMap(Map snapshot) :
        id = BigInt.from(snapshot['id']) ?? BigInt.from(0),
        idTicket = BigInt.from(snapshot['idTicket']) ?? BigInt.from(0),
        total = Utils.toDouble(snapshot['total'].toString()) ?? 0,
        premios = Utils.toDouble(snapshot['premios'].toString()) ?? 0,
        status = Utils.toInt(snapshot['status']) ?? 1,
        codigoBarra = snapshot['codigoBarra'] ?? 1,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null,
        usuario = (snapshot['usuario'] != null) ? snapshot['usuario'] : null,
        usuarioCancelacion = (snapshot['usuarioCancelacion'] != null) ? snapshot['usuarioCancelacion'] : null,
        fechaCancelacion = (snapshot['fechaCancelacion'] != null) ? DateTime.parse(snapshot['fechaCancelacion']) : null,
        montoAPagar = Utils.toDouble(snapshot['montoAPagar'].toString()) ?? 0,
        montoPagado = Utils.toDouble(snapshot['montoPagado'].toString()) ?? 0
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