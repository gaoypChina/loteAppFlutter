

import 'package:loterias/core/classes/utils.dart';

class Moneda{
   int id;
   String descripcion;
   String abreviatura;
   String color;
   int pordefecto;
   int permiteDecimales;
   DateTime created_at;
   double equivalenciaDeUnDolar;

  Moneda({this.id, this.descripcion, this.abreviatura, this.color, this.pordefecto, this.created_at, this.equivalenciaDeUnDolar, this.permiteDecimales});

Moneda.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        abreviatura = snapshot['abreviatura'] ?? '',
        color = snapshot['color'] ?? '',
        pordefecto = Utils.toInt(snapshot['pordefecto']) ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null,
        equivalenciaDeUnDolar = Utils.toDouble(snapshot['equivalenciaDeUnDolar'], returnNullIfNotDouble: true),
        permiteDecimales = Utils.toInt(snapshot['permiteDecimales'], returnNullIfNotInt: true)
        ;

  static List<Moneda> fromMapList(parsed){
    return parsed != null ? parsed.map<Moneda>((json) => Moneda.fromMap(json)).toList() : [];
  }

  static Moneda get getMonedaNinguna => Moneda(id: 0, descripcion: 'Ninguna'); 

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "abreviatura": abreviatura,
      "color": color,
      "pordefecto": pordefecto,
      "created_at": created_at.toString(),
      "equivalenciaDeUnDolar": equivalenciaDeUnDolar,
      "permiteDecimales": permiteDecimales,
    };
  }

  static List monedaToJson(List<Moneda> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build