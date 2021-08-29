

import 'package:loterias/core/classes/utils.dart';

class Moneda{
   int id;
   String descripcion;
   String abreviatura;
   String color;
   int pordefecto;
   DateTime created_at;

  Moneda(this.id, this.descripcion, this.abreviatura, this.color, this.pordefecto, this.created_at);

Moneda.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        abreviatura = snapshot['abreviatura'] ?? '',
        color = snapshot['color'] ?? '',
        pordefecto = Utils.toInt(snapshot['pordefecto']) ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null
        ;

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "abreviatura": abreviatura,
      "color": color,
      "pordefecto": pordefecto,
      "created_at": created_at.toString(),
    };
  }

  static List monedaToJson(List<Moneda> lista) {
    List jsonList = List();
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build