

class Dia{
   int id;
   String descripcion;
   int wday;
   DateTime created_at;

  Dia(this.id, this.descripcion, this.wday, this.created_at);

Dia.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        wday = snapshot['wday'] ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null
        ;

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "wday": wday,
      "created_at": created_at.toString(),
    };
  }

  static List diaToJson(List<Dia> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build