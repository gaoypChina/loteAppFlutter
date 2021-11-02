import 'package:loterias/core/classes/utils.dart';

class Servidor{
   int id;
   String descripcion;
   String cliente;
   int pordefecto;
   int diaPago;
   DateTime fechaProximoPago;

  Servidor({this.id, this.descripcion, this.pordefecto, this.cliente, this.fechaProximoPago});

Servidor.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        pordefecto = Utils.toInt(snapshot['pordefecto']) ?? 0,
        cliente = snapshot['cliente'] ?? '',
        fechaProximoPago = snapshot['fechaProximoPago'] != null ? DateTime.parse(snapshot['fechaProximoPago']) : null,
        diaPago = Utils.toInt(snapshot['id'], returnNullIfNotInt: true)
        ;

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "pordefecto": pordefecto,
    };
  }

  toJsonFull() {
    return {
      "id": id,
      "descripcion": descripcion,
      "pordefecto": pordefecto,
      "cliente": cliente,
      "fechaProximoPago": fechaProximoPago != null ? fechaProximoPago.toString() : null,
      "diaPago": diaPago,
    };
  }

  static List servidorToJson(List<Servidor> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}