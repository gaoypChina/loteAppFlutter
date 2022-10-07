import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/databasesingleton.dart';
import 'dart:convert';

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/proveedor.dart';
import 'package:loterias/core/models/recarga.dart';

class RecargaService{
  static Future<Map<String, dynamic>> index({BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = (await Db.idUsuario()).toString();
    map["idBanca"] = await Db.idBanca();
    map["idGrupo"] = await Db.idGrupo();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);

    var response = await http.get(Uri.parse(Utils.URL + "/api/recargas?token=" + jwt), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("RecargaService dashboard: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${response.body}", title: "Error");
      else
        Utils.showSnackBar(content: "${response.body}", scaffoldKey: scaffoldKey);
      throw Exception("${response.body}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("${parsed["mensaje"]}");
    }

    return parsed;
  }

 static Future<Map<String, dynamic>> search({BuildContext context, scaffoldKey, int idBanca, int idGrupo, int idProveedor, DateTime fechaDesde, DateTime fechaHasta}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = (await Db.idUsuario()).toString();
    map["idBanca"] = idBanca;
    map["idGrupo"] = idGrupo;
    map["idProveedor"] = idProveedor;
    map["fechaDesde"] = fechaDesde != null ? fechaDesde.toString() : null;
    map["fechaHasta"] = fechaHasta != null ? fechaHasta.toString() : null;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);

    var response = await http.get(Uri.parse(Utils.URL + "/api/recargas/search?token=" + jwt), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("RecargaService dashboard: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${response.body}", title: "Error");
      else
        Utils.showSnackBar(content: "${response.body}", scaffoldKey: scaffoldKey);
      throw Exception("${response.body}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("${parsed["mensaje"]}");
    }

    return parsed;
  }


  static Future<Map<String, dynamic>> crear({BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();

    map["idUsuario"] = (await Db.idUsuario()).toString();
    map["servidor"] = await Db.servidor();

    var jwt = await Utils.createJwt(map);

    var response = await http.get(Uri.parse(Utils.URL + "/api/recargas/create?token=" + jwt), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("RecargaService dashboard: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${response.body}", title: "Error");
      else
        Utils.showSnackBar(content: "${response.body}", scaffoldKey: scaffoldKey);
      throw Exception("${response.body}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("${parsed["mensaje"]}");
    }

    return parsed;
  }

 
  static Future<Recarga> guardar({@required BuildContext context, scaffoldKey, @required Recarga recarga}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map = recarga.toJson();
    map["idUsuario"] = await Db.idUsuario();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos = {
      "datos" : jwt
    };

    var response = await http.post(Uri.parse(Utils.URL + "/api/recargas"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("GrupoService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor GrupoService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error GrupoService guardar: ${parsed["mensaje"]}");
    }

    return Recarga.fromMap(parsed["recarga"]);
  }

  static Future<Map<String, dynamic>> anular({@required BuildContext context, scaffoldKey, @required Recarga recarga}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map = recarga.toJson();
    map["idUsuario"] = await Db.idUsuario();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos = {
      "datos" : jwt
    };

    var response = await http.delete(Uri.parse(Utils.URL + "/api/recargas"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("GrupoService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor GrupoService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error GrupoService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }



}