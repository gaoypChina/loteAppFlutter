

import 'package:loterias/core/classes/utils.dart';

class Dia{
   int id;
   String descripcion;
   int wday;
   DateTime created_at;
   DateTime horaApertura;
   DateTime horaCierre;

  Dia({this.id, this.descripcion, this.wday, this.created_at, this.horaApertura, this.horaCierre});

  Dia.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? Utils.toInt(snapshot['id']) : 0,
        descripcion = snapshot['descripcion'] ?? '',
        wday = snapshot['wday'] != null ? Utils.toInt(snapshot['wday']) : 0,
        horaApertura = (snapshot['horaApertura'] != null) ? DateTime.parse(Utils.dateTimeToDate(DateTime.now(), snapshot['horaApertura'])) : DateTime.parse("${DateTime.now().year}-${Utils.toDosDigitos(DateTime.now().month.toString())}-${Utils.toDosDigitos(DateTime.now().day.toString())} 01:00"),
        horaCierre = (snapshot['horaCierre'] != null) ? DateTime.parse(Utils.dateTimeToDate(DateTime.now(), snapshot['horaCierre'])) : DateTime.parse("${DateTime.now().year}-${Utils.toDosDigitos(DateTime.now().month.toString())}-${Utils.toDosDigitos(DateTime.now().day.toString())} 23:00"),
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null
        ;

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "wday": wday,
      "created_at": created_at.toString(),
      "horaApertura": horaApertura != null ? horaApertura.toString() : null,
      "horaCierre": horaCierre != null ? horaCierre.toString() : null,
    };
  }

  static List diasToJson(List<Dia> lista) {
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