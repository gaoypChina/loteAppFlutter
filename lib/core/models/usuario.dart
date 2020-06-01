import 'package:loterias/core/models/permiso.dart';

class Usuario {
  int id;
  String usuario;
  String servidor;
  int status;
  List<Permiso> permisos;

  Usuario({this.id, this.usuario, this.servidor, this.status});

  Usuario.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        usuario = snapshot['usuario'] ?? '',
        servidor = snapshot['servidor'] ?? '',
        status = snapshot['status'] ?? 1
        // permisos = permisosToMap(snapshot['permisos']) ?? List()
        ;

// List permisosToJson() {

//     List jsonList = List();
//     permisos.map((u)=>
//       jsonList.add(u.toJson())
//     ).toList();
//     return jsonList;
//   }

//   static List<Permiso> permisosToMap(List<dynamic> permisos){
//     return permisos.map((data) => Permiso.fromMap(data)).toList();
//   }

  toJson() {
    return {
      "id": id,
      "usuario": usuario,
      "servidor": servidor,
      "status": status,
    };
  }
}