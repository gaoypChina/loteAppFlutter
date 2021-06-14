class Ticket {
  int id;
  String codigoBarra;
  int usado;
  String uuid;
  int idBanca;

  Ticket({this.id, this.codigoBarra, this.uuid, this.idBanca});

  Ticket.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        codigoBarra = snapshot['codigoBarra'] ?? '',
        usado = snapshot['usado'] ?? null,
        uuid = (snapshot['uuid'] != null) ? snapshot["uuid"] : '',
        idBanca = snapshot['idBanca'] ?? 1
        // permisos = permisosToMap(snapshot['permisos']) ?? List()
        ;


  toJson() {
    return {
      "id": id,
      "codigoBarra": codigoBarra,
      "usado": usado,
      "uuid" : uuid,
      "idBanca": idBanca,
    };
  }
}