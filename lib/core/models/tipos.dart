

import 'package:loterias/core/classes/utils.dart';

class Tipo{
   int id;
   String descripcion;
   String renglon;
   int status;
   DateTime created_at;

  Tipo(this.id, this.descripcion, this.renglon, this.status, this.created_at);

Tipo.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        renglon = snapshot['renglon'] ?? '',
        status = Utils.toInt(snapshot['status']) ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null
        ;

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "renglon": renglon,
      "status": status,
      "created_at": created_at.toString(),
    };
  }

  static List tipoToJson(List<Tipo> lista) {
    List jsonList = List();
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build