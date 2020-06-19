class Servidor{
   int id;
   String descripcion;
   int pordefecto;

  Servidor(this.id, this.descripcion, this.pordefecto);

Servidor.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        pordefecto = snapshot['pordefecto'] ?? 0
        ;

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "pordefecto": pordefecto,
    };
  }

  static List servidorToJson(List<Servidor> lista) {
    List jsonList = List();
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}