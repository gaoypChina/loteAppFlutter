

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/frecuencia.dart';
import 'package:loterias/core/models/loterias.dart';

class Gasto{
   int id;
   int idBanca;
   int idFrecuenca;
   Frecuencia frecuencia;
   Loteria loteria;
   int idDia;
   Dia dia;
   double monto;
   String descripcion;
   DateTime created_at;

  Gasto({this.id, this.idBanca, this.idFrecuenca, this.loteria, this.frecuencia, this.dia, this.idDia, this.monto, this.descripcion, this.created_at,});

Gasto.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        idBanca = Utils.toInt(snapshot['idBanca']) ?? 0,
        idFrecuenca = Utils.toInt(snapshot['idFrecuenca']) ?? 0,
        loteria = snapshot['loteria'] != null ? Loteria.fromMap(Utils.parsedToJsonOrNot(snapshot['loteria'])) : null,
        frecuencia = snapshot['frecuencia'] != null ? Frecuencia.fromMap(Utils.parsedToJsonOrNot(snapshot['frecuencia'])) : null,
        dia = snapshot['dia'] != null ? Dia.fromMap(Utils.parsedToJsonOrNot(snapshot['dia'])) : null,
        idDia = Utils.toInt(snapshot['idDia']) ?? 0,
        monto = Utils.toDouble(snapshot['monto'].toString()) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        created_at = DateTime.parse(snapshot['created_at']) ?? null
        ;

  toJson() {
    return {
      "id": id,
      "idBanca": idBanca,
      "idFrecuenca": idFrecuenca,
      "loteria": loteria != null ? loteria.toJson() : null,
      "frecuencia": frecuencia != null ? frecuencia.toJson() : null,
      "dia": dia != null ? dia.toJson() : null,
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