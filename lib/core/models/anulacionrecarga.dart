

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/usuario.dart';

class AnulacionRecarga{
   int id;
   Usuario usuario;
   DateTime created_at;


  AnulacionRecarga({this.id, this.usuario, this.created_at});

  AnulacionRecarga.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? Utils.toInt(snapshot['id']) : 0,
        usuario = snapshot['usuario'] != null ? Usuario.fromMap(snapshot["usuario"]) : null,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null
        ;

  toJson() {
    return {
      "id": id,
      "usuario": usuario,
      "created_at": created_at.toString(),
    };
  }

}
