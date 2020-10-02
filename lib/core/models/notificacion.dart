

class Notificacion{
   int id;
   String titulo;
   String subtitulo;
   String contenido;
   int estado;
   DateTime created_at;

  Notificacion({this.id, this.titulo, this.subtitulo, this.contenido, this.estado, this.created_at});

Notificacion.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        titulo = snapshot['titulo'] ?? '',
        subtitulo = snapshot['subtitulo'] ?? '',
        contenido = snapshot['contenido'] ?? '',
        estado = snapshot['estado'] ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null
        ;

  toJson() {
    return {
      "id": id,
      "titulo": titulo,
      "subtitulo": subtitulo,
      "contenido": contenido,
      "estado": estado,
      "created_at": created_at.toString(),
    };
  }

  static List NotificacionToJson(List<Notificacion> lista) {
    List jsonList = List();
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build