
class Venta {
  BigInt id;
  BigInt idTicket;
  int status;

  Venta({this.id, this.idTicket, this.status});

  Venta.fromMap(Map snapshot) :
        id = BigInt.from(snapshot['id']) ?? BigInt.from(0),
        idTicket = BigInt.from(snapshot['idTicket']) ?? BigInt.from(0),
        status = snapshot['status'] ?? 1;

  toJson() {
    return {
      "id": id,
      "idTicket": idTicket,
      "status": status,
    };
  }
}