
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';

class Grupo {
  int id;
  String descripcion;
  String codigo;
  int status;
  List<Banca> bancas;

  Grupo({this.id, this.descripcion, this.codigo, this.status = 1, this.bancas});

  Grupo.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        codigo = snapshot['codigo'] ?? '',
        status = Utils.toInt(snapshot['status']) ?? 1,
        bancas = (snapshot["bancas"] != null) ? bancasToMap(Utils.parsedToJsonOrNot(snapshot["bancas"])) : []
        ;

  static List<Banca> bancasToMap(bancas){
          if(bancas != null && bancas.length > 0)
            return bancas.map<Banca>((data) => Banca.fromMap(data)).toList();
          else
            return [];
        }

  static Grupo get getGrupoNinguno => Grupo(id: 0, descripcion: 'Ninguno'); 

  static List<Grupo> fromMapList(parsed){
    return parsed != null ? parsed.map<Grupo>((json) => Grupo.fromMap(json)).toList() : [];
  }

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "codigo": codigo,
      "status": status,
    };
  }
}