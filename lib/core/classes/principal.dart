import 'dart:convert';

import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/ventas.dart';

class Principal{
  static Map<String, dynamic> parseDatos(String responseBody, ) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    print('parsed: ${parsed['errores']}');
    Map<String, dynamic> map = Map<String, dynamic>();
    
    print('principal parsedDatos loterias: ${parsed['loterias']}');
    map["bancas"] = parsed['bancas'].map<Banca>((json) => Banca.fromMap(json)).toList();
    map["loterias"] = parsed['loterias'].map<Loteria>((json) => Loteria.fromMap(json)).toList();
    map["ventas"] = parsed['ventas'].map<Venta>((json) => Venta.fromMap(json)).toList();
    map["idVenta"] = parsed['idVenta'];
    map["errores"] = parsed['errores'];
    map["mensaje"] = parsed['mensaje'];
    map["venta"] = parsed['venta'];
    print(parsed['ventas']);
    // map["bancas"] = "jean";
    return map;
    // parsed['bancas'].map<Banca>((json) => Banca.fromMap(json)).toList();
    // return parsed.map<Banca>((json) => Banca.fromMap(json)).toList();
    // return true;
  }

  static loteriasSeleccionadasToString(List<Loteria> loteriasSeleccionadas){
    if(loteriasSeleccionadas == null)
      return 'Seleccionar loterias';
    else{
      String loterias = "";
      if(loteriasSeleccionadas.isEmpty)
        return 'Seleccionar loterias';
        int c = 0;
      for(Loteria l in loteriasSeleccionadas){
        loterias += (c + 1 < loteriasSeleccionadas.length) ? l.descripcion + ', ' : l.descripcion;
        c++;
      }
      return loterias;
    }
  }

  static List loteriaToJson(List<Loteria> loterias) {
    List jsonList = List();
    loterias.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

  static List jugadaToJson(List<Jugada> jugadas) {
    List jsonList = List();
    jugadas.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }
}