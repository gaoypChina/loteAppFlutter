import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/bloqueo.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'dart:convert';

import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/monedas.dart';

class BloqueosService{
  static Future<Map<String, dynamic>> index({@required BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    var response = await http.get(Uri.parse(Utils.URL + "/api/bloqueos/v2?token=$jwt"), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BloqueosService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor BloqueosService index: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      print("BloqueosService index parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error BloqueosService index: ${parsed["mensaje"]}");
    }

    return parsed;
  }
 
  static Future<Map<String, dynamic>> guardar({@required BuildContext context, scaffoldKey, @required List<Banca> bancas, @required List<Dia> dias, @required List<Loteria> loterias, @required List<Draws> sorteos, @required bool descontarDelBloqueoGeneral, @required Moneda moneda}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["bancas"] = bancas != null ? Banca.bancasToJson(bancas) : [];
    map["loterias"] = loterias != null ? Loteria.loteriasToJson(loterias) : [];
    map["sorteos"] = sorteos != null ? Draws.drawsToJson(sorteos, true) : [];
    map["dias"] = dias != null ? Dia.diasToJson(dias) : [];
    map["descontarDelBloqueoGeneral"] = descontarDelBloqueoGeneral;
    map["idMoneda"] = moneda != null ? moneda.id : null;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/v3/loterias/guardar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BloqueosService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor BloqueosService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error BloqueosService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> guardarGeneral({@required BuildContext context, scaffoldKey, @required List<Dia> dias, @required List<Loteria> loterias, @required List<Draws> sorteos, @required Moneda moneda}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["loterias"] = loterias != null ? Loteria.loteriasToJson(loterias) : [];
    map["sorteos"] = sorteos != null ? Draws.drawsToJson(sorteos, true) : [];
    map["dias"] = dias != null ? Dia.diasToJson(dias) : [];
    map["idMoneda"] = moneda != null ? moneda.id : null;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/v3/general/loterias/guardar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BloqueosService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor BloqueosService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error BloqueosService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> guardarJugadas({@required BuildContext context, scaffoldKey, @required List<Banca> bancas, @required List<Loteria> loterias, @required List<Jugada> jugadas, @required Moneda moneda, @required bool ignorarDemasBloqueos, @required DateTimeRange date, @required descontarDelBloqueoGeneral}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["bancas"] = bancas != null ? Banca.bancasToJson(bancas) : [];
    map["loterias"] = loterias != null ? Loteria.loteriasToJson(loterias) : [];
    map["jugadas"] = jugadas != null ? Jugada.jugadasToJson(jugadas) : [];
    map["idMoneda"] = moneda != null ? moneda.id : null;
    map["ignorarDemasBloqueos"] = ignorarDemasBloqueos;
    map["descontarDelBloqueoGeneral"] = descontarDelBloqueoGeneral;
    map["servidor"] = await Db.servidor();
    map["fechaDesde"] = date.start.toString();
    map["fechaHasta"] = date.end.toString();
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/v3/jugadas/guardar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BloqueosService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor BloqueosService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error BloqueosService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> guardarJugadasGeneral({@required BuildContext context, scaffoldKey, @required List<Loteria> loterias, @required List<Jugada> jugadas, @required Moneda moneda, @required bool ignorarDemasBloqueos, @required DateTimeRange date}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["loterias"] = loterias != null ? Loteria.loteriasToJson(loterias) : [];
    map["jugadas"] = jugadas != null ? Jugada.jugadasToJson(jugadas) : [];
    map["idMoneda"] = moneda != null ? moneda.id : null;
    map["ignorarDemasBloqueos"] = ignorarDemasBloqueos;
    map["servidor"] = await Db.servidor();
    map["fechaDesde"] = date.start.toString();
    map["fechaHasta"] = date.end.toString();
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/v3/general/jugadas/guardar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BloqueosService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor BloqueosService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error BloqueosService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }


  static Future<Map<String, dynamic>> eliminar({@required BuildContext context, scaffoldKey, int idUsuario, @required Grupo grupo}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = idUsuario;
    map["grupo"] = grupo.toJson();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Uri.parse(Utils.URL + "/api/grupos/eliminar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BloqueosService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor BloqueosService guardar ${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor BloqueosService guardar: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error BloqueosService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> buscarIndex({@required BuildContext context}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/v2/buscar/index"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BloqueosService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      throw Exception("Error del servidor BloqueosService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      throw Exception("Error BloqueosService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> buscar({@required BuildContext context, @required Moneda moneda, @required Grupo grupo, bool ignorarDemasBloqueos = false, @required DateTimeRange date, TipoBloqueo tipoBloqueo}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["idMoneda"] = moneda != null ? moneda.id : null;
    map["idGrupo"] = grupo != null ? grupo.id : null;
    map["tipoBloqueo"] = tipoBloqueo != null ? tipoBloqueo.toString() : TipoBloqueo.general.toString();
    map["ignorarDemasBloqueos"] = ignorarDemasBloqueos;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/v2/buscar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BloqueosService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      throw Exception("Error del servidor BloqueosService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      throw Exception("Error BloqueosService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> mostrarLoterias({@required BuildContext context, String ids, @required Moneda moneda, TipoBloqueo tipoBloqueo}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["idMoneda"] = moneda != null ? moneda.id : null;
    map["tipoBloqueo"] = tipoBloqueo != null ? tipoBloqueo.toString() : TipoBloqueo.general.toString();
    map["ids"] = ids;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response;
      if(tipoBloqueo == TipoBloqueo.porBancas)
        response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/loterias/mostrar/loterias"), body: json.encode(mapDatos), headers: Utils.header);
      else if(tipoBloqueo == TipoBloqueo.jugadas)
        response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/general/jugadas/loterias"), body: json.encode(mapDatos), headers: Utils.header);
      else if(tipoBloqueo == TipoBloqueo.jugadasPorBanca)
        response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/jugadas/mostrar/loterias"), body: json.encode(mapDatos), headers: Utils.header);
      else
        response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/general/mostrar/loterias"), body: json.encode(mapDatos), headers: Utils.header);
    
    int statusCode = response.statusCode;

      String body = response.body;
    if(statusCode < 200 || statusCode > 400){
      print("BloqueosService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      throw Exception("Error del servidor BloqueosService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      throw Exception("Error BloqueosService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> mostrarDiasDeLoteria({@required BuildContext context, String ids, @required Moneda moneda, @required TipoBloqueo tipoBloqueo}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["idMoneda"] = moneda != null ? moneda.id : null;
    map["ids"] = ids;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response = 
    tipoBloqueo == TipoBloqueo.porBancas
    ?
      await http.post(Uri.parse(Utils.URL + "/api/bloqueos/loterias/mostrar/loterias/dias"), body: json.encode(mapDatos), headers: Utils.header)
      :
      await http.post(Uri.parse(Utils.URL + "/api/bloqueos/general/mostrar/loterias/dias"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BloqueosService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      throw Exception("Error del servidor BloqueosService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      throw Exception("Error BloqueosService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> mostrarJugadaDeLoteria({@required BuildContext context, String id, @required Moneda moneda, @required TipoBloqueo tipoBloqueo}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["idMoneda"] = moneda != null ? moneda.id : null;
    map["ids"] = id;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response = 
    tipoBloqueo == TipoBloqueo.jugadasPorBanca
    ?
      await http.post(Uri.parse(Utils.URL + "/api/bloqueos/jugadas/mostrar/jugadas"), body: json.encode(mapDatos), headers: Utils.header)
      :
      await http.post(Uri.parse(Utils.URL + "/api/bloqueos/general/jugadas/jugada"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BloqueosService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      throw Exception("Error del servidor BloqueosService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      throw Exception("Error BloqueosService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }


  static Future<Map<String, dynamic>> eliminarV2({@required BuildContext context, String ids, @required Moneda moneda, @required TipoBloqueo tipoBloqueo}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["idMoneda"] = moneda != null ? moneda.id : null;
    map["ids"] = ids;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response;
      if(tipoBloqueo == TipoBloqueo.porBancas)
        response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/v2/loterias/eliminar"), body: json.encode(mapDatos), headers: Utils.header);
      else if(tipoBloqueo == TipoBloqueo.jugadas)
        response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/v2/general/jugadas/eliminar"), body: json.encode(mapDatos), headers: Utils.header);
      else if(tipoBloqueo == TipoBloqueo.jugadasPorBanca)
        response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/v2/jugadas/eliminar"), body: json.encode(mapDatos), headers: Utils.header);
      else 
        response = await http.post(Uri.parse(Utils.URL + "/api/bloqueos/v2/general/eliminar"), body: json.encode(mapDatos), headers: Utils.header);

    int statusCode = response.statusCode;
    String body = response.body;

    if(statusCode < 200 || statusCode > 400){
      print("BloqueosService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      throw Exception("Error del servidor BloqueosService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      throw Exception("Error BloqueosService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<bool> mostrarDialogEliminarBloqueo(context, TipoBloqueo tipoBloqueo, Bloqueo bloqueo, Moneda moneda) async {
    bool cargando = false;
    bool eliminadoCorrectamente = false;
    return await showDialog(
      context: context, 
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            bool _estaCargando(){
              return cargando == true;
            }

            _irAtras(){
              Navigator.pop(context, eliminadoCorrectamente);
            }
            return AlertDialog(
              title: Text("Desea eliminar"),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              content: Text("Seguro desea eliminar bloqueo?"),
              actions: [
                TextButton(onPressed: _irAtras, child: Text("Cancelar", style: TextStyle(color: Colors.grey[600]),)),
                TextButton(onPressed: () async {
                  try {
                    setState(() => cargando = true);
                    await BloqueosService.eliminarV2(context: context, ids: bloqueo.ids, moneda: moneda, tipoBloqueo: tipoBloqueo);
                    setState(() => cargando = false);
                    eliminadoCorrectamente = true;
                    _irAtras();
                  } on Exception catch (e) {
                    setState(() => cargando = false);
                  }
                }, child: _estaCargando() ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator()) : Text("Eliminar", style: TextStyle(color: Colors.red[700], fontSize: 16),)),
              ],
            );
          }
        );
      }
    );
  }

  static Future<Map<String, dynamic>> porBancaMostrarBancas({@required BuildContext context, String ids, @required Moneda moneda, TipoBloqueo tipoBloqueo}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["idMoneda"] = moneda != null ? moneda.id : null;
    map["tipoBloqueo"] = tipoBloqueo != null ? tipoBloqueo.toString() : TipoBloqueo.general.toString();
    map["ids"] = ids;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response = 
    tipoBloqueo == TipoBloqueo.jugadasPorBanca
    ?
    await http.post(Uri.parse(Utils.URL + "/api/bloqueos/jugadas/mostrar/bancas"), body: json.encode(mapDatos), headers: Utils.header)
    :
    await http.post(Uri.parse(Utils.URL + "/api/bloqueos/loterias/mostrar/bancas"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BloqueosService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      throw Exception("Error del servidor BloqueosService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      throw Exception("Error BloqueosService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }
}