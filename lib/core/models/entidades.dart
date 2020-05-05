

class Entidad{
   int id;
   String nombre;
   String renglon;
   int status;
   int idTipo;
   int idMoneda;
   DateTime created_at;

  Entidad({this.id, this.nombre, this.renglon, this.status, this.idTipo, this.idMoneda, this.created_at});

Entidad.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        nombre = snapshot['nombre'] ?? '',
        renglon = snapshot['renglon'] ?? '',
        status = snapshot['status'] ?? 0,
        idTipo = snapshot['idTipo'] ?? 0,
        idMoneda = snapshot['idMoneda'] ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null
        ;

  toJson() {
    return {
      "id": id,
      "nombre": nombre,
      "renglon": renglon,
      "status": status,
      "idTipo": idTipo,
      "idMoneda": idMoneda,
      "created_at": created_at.toString(),
    };
  }

  static List entidadToJson(List<Entidad> lista) {
    List jsonList = List();
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build