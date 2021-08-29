
import 'package:loterias/core/classes/utils.dart';

class Grupo {
  int id;
  String descripcion;
  String codigo;
  int status;

  Grupo({this.id, this.descripcion, this.codigo, this.status = 1});

  Grupo.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        codigo = snapshot['codigo'] ?? '',
        status = Utils.toInt(snapshot['status']) ?? 1
        ;

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "codigo": codigo,
      "status": status,
    };
  }
}