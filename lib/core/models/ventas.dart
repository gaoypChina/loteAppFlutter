
import 'package:loterias/core/classes/utils.dart';

class Venta {
  BigInt id;
  BigInt idTicket;
  double total;
  int status;
  String codigoBarra;

  Venta({this.id, this.idTicket, this.total, this.status, this.codigoBarra});

  Venta.fromMap(Map snapshot) :
        id = BigInt.from(snapshot['id']) ?? BigInt.from(0),
        idTicket = BigInt.from(snapshot['idTicket']) ?? BigInt.from(0),
        total = Utils.toDouble(snapshot['total'].toString()) ?? 0,
        status = snapshot['status'] ?? 1,
        codigoBarra = snapshot['codigoBarra'] ?? 1
        ;

  toJson() {
    return {
      "id": id,
      "idTicket": idTicket,
      "total": total,
      "status": status,
      "codigoBarra": codigoBarra,
    };
  }
}