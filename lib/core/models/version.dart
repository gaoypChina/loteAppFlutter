import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/permiso.dart';

class Version {
  int id;
  String version;
  String version2;
  String version3;
  String enlace;
  bool urgente;
  int status;

  Version({this.id, this.version, this.version2, this.version3, this.urgente = false, this.status = 1, this.enlace});

  Version.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        version = snapshot['version'] ?? null,
        version2 = snapshot['version2'] ?? null,
        version3 = snapshot['version3'] ?? null,
        enlace = snapshot['enlace'] ?? null,
        urgente = snapshot['urgente'] == 1,
        status = snapshot['status'] ?? 1
        ;


  toJson() {
    return {
      "id": (id != null) ? id : null,
      "version": version,
      "version2": version2,
      "version3": version3,
      "enlace": enlace,
      "status": status,
      "urgente": urgente,
    };
  }
}