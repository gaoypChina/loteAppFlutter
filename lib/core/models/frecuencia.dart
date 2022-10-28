

import 'package:loterias/core/classes/utils.dart';

class Frecuencia{
   int id;
   String descripcion;
   String observacion;
   DateTime created_at;

  Frecuencia(this.id, this.descripcion, this.observacion, this.created_at);

Frecuencia.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        observacion = snapshot['observacion'] ?? '',
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null
        ;

  static List<Frecuencia> fromMapList(parsed){
    return parsed != null ? parsed.map<Frecuencia>((json) => Frecuencia.fromMap(json)).toList() : [];
  }

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "observacion": observacion,
      "created_at": created_at.toString(),
    };
  }

  static List frecuenciasToJson(List<Frecuencia> lista) {
    List jsonList = [];
    if(lista == null)
      return jsonList;
      
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build