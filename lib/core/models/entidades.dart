

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/models/tipos.dart';

class Entidad{
   int id;
   String nombre;
   String renglon;
   int status;
   int idTipo;
   int idMoneda;
   DateTime created_at;
   Moneda moneda;
   Tipo tipo;

  Entidad({this.id, this.nombre, this.renglon, this.status, this.idTipo, this.idMoneda, this.created_at, this.moneda, this.tipo});

Entidad.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        nombre = snapshot['nombre'] ?? '',
        renglon = snapshot['renglon'] ?? '',
        status = Utils.toInt(snapshot['status']) ?? 0,
        idTipo = Utils.toInt(snapshot['idTipo']) ?? 0,
        idMoneda = Utils.toInt(snapshot['idMoneda']) ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null,
        moneda = snapshot['moneda'] != null ? Moneda.fromMap(Utils.parsedToJsonOrNot(snapshot['moneda'])) : null,
        tipo = snapshot['tipo'] != null ? Tipo.fromMap(Utils.parsedToJsonOrNot(snapshot['tipo'])) : null
        ;

  toJson() {
    return {
      "id": id,
      "nombre": nombre,
      "renglon": renglon,
      "status": status,
      "idTipo": idTipo,
      "idMoneda": idMoneda,
      "created_at": created_at.toString(),
      "moneda": moneda != null ? moneda.toJson() : null,
      "tipo": tipo != null ? tipo.toJson() : null,
    };
  }

  static List entidadToJson(List<Entidad> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build