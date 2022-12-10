

import 'package:loterias/core/classes/utils.dart';

class Draws{
   int id;
   String descripcion;
   int bolos;
   int cantidadNumeros;
   int status;
   DateTime created_at;
   double monto;

  Draws(this.id, this.descripcion, this.bolos, this.cantidadNumeros, this.status, this.created_at);

Draws.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? Utils.toInt(snapshot['id']) : 0,
        descripcion = snapshot['descripcion'] ?? '',
        bolos = snapshot['bolos'] != null ? Utils.toInt(snapshot['bolos']) : 0,
        cantidadNumeros = snapshot['cantidadNumeros'] != null ? Utils.toInt(snapshot['cantidadNumeros']) : 0,
        status = snapshot['status'] != null ? Utils.toInt(snapshot['status']) : 0,
        created_at = (snapshot['created_at'] != null && snapshot['created_at'] != 'null') ? snapshot["created_at"] is int ? DateTime.fromMillisecondsSinceEpoch(snapshot["created_at"]) : DateTime.parse(snapshot['created_at'].toString()) : null,
        monto = snapshot['monto'] != null ? Utils.toDouble(snapshot['monto']) : null
        ;

  static String get superPale => 'Super pale';
  static int get idSorteoSuperpale => 4;

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "bolos": bolos,
      "cantidadNumeros": cantidadNumeros,
      "status": status,
      "created_at": created_at.toString(),
    };
  }

  toJsonFull() {
    return {
      "id": id,
      "descripcion": descripcion,
      "bolos": bolos,
      "cantidadNumeros": cantidadNumeros,
      "status": status,
      "created_at": created_at.toString(),
      "monto": monto,
    };
  }

  static List drawsToJson(List<Draws> lista, [var toJsonFull = false]) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(toJsonFull ? u.toJsonFull() : u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build