

import 'package:loterias/core/classes/utils.dart';

class Permiso{
   int id;
   String descripcion;
   int status;
   DateTime created_at;
   bool seleccionado;
   bool esPermisoRol;
   int idTipo;

  Permiso(this.id, this.descripcion, this.status, this.created_at, this.seleccionado, this.idTipo);

Permiso.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        status = Utils.toInt(snapshot['status']) ?? 0,
        idTipo = Utils.toInt(snapshot['idTipo']) ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null,
        seleccionado = snapshot['seleccionado']?? false,
        esPermisoRol = snapshot['esPermisoRol']?? false

        ;

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "status": status,
      "idTipo": idTipo,
      "created_at": created_at.toString(),
    };
  }

  static List permisoToJson(List<Permiso> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build