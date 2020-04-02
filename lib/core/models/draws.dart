

class Draws{
   int id;
   String descripcion;
   int bolos;
   int cantidadNumeros;
   int status;
   DateTime created_at;

  Draws(this.id, this.descripcion, this.bolos, this.cantidadNumeros, this.status, this.created_at);

Draws.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        bolos = snapshot['bolos'] ?? 0,
        cantidadNumeros = snapshot['cantidadNumeros'] ?? 0,
        status = snapshot['status'] ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null
        ;

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "bolos": bolos,
      "cantidadNumeros": cantidadNumeros,
      "status": status,
      "created_at": created_at.toString(),
    };
  }

  static List drawsToJson(List<Draws> lista) {
    List jsonList = List();
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build