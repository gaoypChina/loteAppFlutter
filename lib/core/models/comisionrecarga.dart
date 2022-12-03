

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/proveedor.dart';

class ComisionRecarga{
   int id;
   int idBanca;
   int idProveedor;
   double porcentajeComision;
   Proveedor proveedor;

  ComisionRecarga({this.id, this.idBanca, this.idProveedor, this.porcentajeComision, this.proveedor});

  ComisionRecarga.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? Utils.toInt(snapshot['id']) : 0,
        idBanca = snapshot['idBanca'] != null ? Utils.toInt(snapshot['idBanca']) : 0,
        idProveedor = snapshot['idProveedor'] != null ? Utils.toInt(snapshot['idProveedor']) : 0,
        proveedor = snapshot['proveedor'] != null ? Proveedor.fromMap(Utils.parsedToJsonOrNot(snapshot['proveedor'])) : null,
        porcentajeComision = double.tryParse(snapshot['porcentajeComision'].toString()) ?? 0
        ;

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }

  static List<ComisionRecarga> fromMapList(parsed){
    return parsed != null ? parsed.map<ComisionRecarga>((json) => ComisionRecarga.fromMap(json)).toList() : [];
  }


  toJson() {
    return {
      "id": id,
      "idBanca": idBanca,
      "idProveedor": idProveedor,
      "porcentajeComision": porcentajeComision,
    };
  }

  static List listToJson(List<ComisionRecarga> lista) {
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