
class Venta {
  BigInt id;
  BigInt idTicket;
  int status;
  String codigoBarra;

  Venta({this.id, this.idTicket, this.status, this.codigoBarra});

  Venta.fromMap(Map snapshot) :
        id = BigInt.from(snapshot['id']) ?? BigInt.from(0),
        idTicket = BigInt.from(snapshot['idTicket']) ?? BigInt.from(0),
        status = snapshot['status'] ?? 1,
        codigoBarra = snapshot['codigoBarra'] ?? 1
        ;

  toJson() {
    return {
      "id": id,
      "idTicket": idTicket,
      "status": status,
      "codigoBarra": codigoBarra,
    };
  }
}