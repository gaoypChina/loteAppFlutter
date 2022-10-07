

import 'package:loterias/core/classes/utils.dart';

class Proveedor{
   int id;
   String idApiKey;
   String nombre;
   String colorDeFondo;
   String enlaceDelLogo;

  Proveedor({this.id, this.idApiKey, this.nombre, this.colorDeFondo, this.enlaceDelLogo});

Proveedor.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        idApiKey = snapshot['idApiKey'] ?? '',
        nombre = snapshot['nombre'] ?? '',
        colorDeFondo = snapshot['colorDeFondo'] ?? '',
        enlaceDelLogo = snapshot['enlaceDelLogo'] ?? ''
        ;

  static List<Proveedor> fromMapList(parsed){
    return parsed != null ? parsed.map<Proveedor>((json) => Proveedor.fromMap(json)).toList() : [];
  }

  static Proveedor get getProveedorTodos => Proveedor(id: 0, nombre: 'Todos'); 
  

  toJson() {
    return {
      "id": id,
      "idApiKey": idApiKey,
      "nombre": nombre,
      "colorDeFondo": colorDeFondo,
      "enlaceDelLogo": enlaceDelLogo,
    };
  }

  static List ProveedorToJson(List<Proveedor> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build