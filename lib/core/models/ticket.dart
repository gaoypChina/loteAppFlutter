class Ticket {
  BigInt id;
  String codigoBarra;
  int usado;
  String uuid;
  int idBanca;
  String servidor;

  Ticket({this.id, this.codigoBarra, this.uuid, this.idBanca, this.servidor});

  Ticket.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? BigInt.from(snapshot['id']) : BigInt.zero,
        codigoBarra = snapshot['codigoBarra'] ?? '',
        usado = snapshot['usado'] ?? 0,
        uuid = (snapshot['uuid'] != null) ? snapshot["uuid"] : '',
        idBanca = snapshot['idBanca'] ?? -1,
        servidor = snapshot['servidor'] ?? null
        // permisos = permisosToMap(snapshot['permisos']) ?? List()
        ;


  toJson() {
    return {
      "id": id != null ? id.toInt() : 0,
      "codigoBarra": codigoBarra,
      "usado": usado,
      "uuid" : uuid,
      "idBanca": idBanca,
      "servidor": servidor,
    };
  }
}