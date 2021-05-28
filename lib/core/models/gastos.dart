

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/loterias.dart';

class Gasto{
   int id;
   int idBanca;
   int idFrecuenca;
   Loteria loteria;
   int idDia;
   double monto;
   double descripcion;
   DateTime created_at;

  Gasto(this.id, this.idBanca, this.idFrecuenca, this.loteria, this.idDia, this.monto, this.descripcion, this.created_at,);

Gasto.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        idBanca = snapshot['idBanca'] ?? 0,
        idFrecuenca = snapshot['idFrecuenca'] ?? 0,
        loteria = snapshot['loteria'] != null ? Loteria.fromMap(Utils.parsedToJsonOrNot(snapshot['loteria'])) : null,
        idDia = int.tryParse(snapshot['idDia'].toString()) ?? 0,
        monto = double.tryParse(snapshot['monto'].toString()) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        created_at = DateTime.parse(snapshot['created_at']) ?? null
        ;

  toJson() {
    return {
      "id": id,
      "idBanca": idBanca,
      "idFrecuenca": idFrecuenca,
      "loteria": loteria != null ? loteria.toJson() : null,
      "idDia": idDia,
      "monto": monto,
      "descripcion": descripcion,
      "created_at": created_at.toString(),
    };
  }

  static List gastosToJson(List<Gasto> lista) {
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