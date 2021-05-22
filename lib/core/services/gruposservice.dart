import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/grupo.dart';
import 'dart:convert';

class GrupoService{
  static Future<Map<String, dynamic>> index({@required BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    var response = await http.get(Uri.parse(Utils.URL + "/api/grupos?token=$jwt"), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("GrupoService index: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor GrupoService index", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor GrupoService index", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor GrupoService index");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      print("GrupoService index parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error GrupoService index: ${parsed["mensaje"]}");
    }

    return parsed;
  }
 
  static Future<Map<String, dynamic>> guardar({@required BuildContext context, scaffoldKey, @required Grupo grupo}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["grupo"] = grupo.toJson();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response = await http.post(Uri.parse(Utils.URL + "/api/grupos/guardar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("GrupoService guardar: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor GrupoService guardar", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor GrupoService guardar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor GrupoService guardar");
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
      print("GrupoService guardar: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor GrupoService guardar", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor GrupoService guardar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor GrupoService guardar");
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