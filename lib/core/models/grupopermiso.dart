import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/permiso.dart';

class Grupopermiso {
  int id;
  String descripcion;
  List<Permiso> permisos;

  Grupopermiso({this.id, this.descripcion, this.permisos});

  Grupopermiso.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        permisos = permisosToMap(snapshot['permisos'] is String ? Utils.parseDatos(snapshot["permisos"]) :snapshot['permisos']) ?? []
        ;

  List permisosToJson() {

    List jsonList = [];
    if(permisos != null)
      permisos.map((u)=>
        jsonList.add(u.toJson())
      ).toList();
    return jsonList;
  }

  static List<Permiso> permisosToMap(List<dynamic> permisos){
    if(permisos != null)
      return permisos.map((data) => Permiso.fromMap(data)).toList();
    else
      return [];
  }


  toJson() {
    return {
      "id": (id != null) ? id : null,
      "descripcion": descripcion,
    };
  }
}