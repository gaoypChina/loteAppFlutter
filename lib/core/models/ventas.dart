
class Venta {
  int id;
  int idTicket;
  int status;

  Venta({this.id, this.idTicket, this.status});

  Venta.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        idTicket = snapshot['idTicket'] ?? 0,
        status = snapshot['status'] ?? 1;

  toJson() {
    return {
      "id": id,
      "idTicket": idTicket,
      "status": status,
    };
  }
}