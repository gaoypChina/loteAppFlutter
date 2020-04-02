

class Permiso{
   int id;
   String descripcion;
   int status;
   DateTime created_at;

  Permiso(this.id, this.descripcion, this.status, this.created_at);

Permiso.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        status = snapshot['status'] ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null
        ;

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "status": status,
      "created_at": created_at.toString(),
    };
  }

  static List permisoToJson(List<Permiso> lista) {
    List jsonList = List();
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build