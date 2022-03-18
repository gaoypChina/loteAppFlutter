import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:loterias/core/models/loterias.dart';



class PremiosService{
  static Future<List<Loteria>> getLoterias({BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);

    var response = await http.get(Uri.parse(Utils.URL + "/api/premios?token=$jwt"), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("premiosService getLoterias: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor premiosService getLoterias", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor premiosService getLoterias", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor premiosService getLoterias");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error premiosService getLoterias: ${parsed["mensaje"]}");
    }

    return (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
  }
  
  static Future<List<Loteria>> guardar({BuildContext context, scaffoldKey, Loteria loteria, DateTime date, bool actualizarTransacciones}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    List<Loteria> listaLoteria =[];
    listaLoteria.add(loteria);

    map["loterias"] = [loteria.toJson()];
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["layout"] = "vistaSencilla";
    map["servidor"] = await Db.servidor();
    map["fecha"] = date != null ? date.toString() : DateTime.now();
    map["actualizarTransacciones"] = actualizarTransacciones;
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    print("premiosservice guardar: ${mapDatos.toString()}");
    // return listaLoteria;

    var response = await http.post(Uri.parse(Utils.URL + "/api/premios/guardar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("premiosService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor premiosService guardar: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("premiosservice guardar parsed: ${parsed}");
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error premiosService guardar: ${parsed["mensaje"]}");
    }

    return (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
  }

  static Future<List<Loteria>> buscar({BuildContext context, scaffoldKey, DateTime date}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    List<Loteria> listaLoteria =[];

    map["fecha"] = date != null ? date.toString() : null;
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    // map["layout"] = "";
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    print("premiosservice guardar: ${mapDatos.toString()}");
    // return listaLoteria;

    var response = await http.post(Uri.parse(Utils.URL + "/api/premios/buscarPorFecha"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("premiosService guardar: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor premiosService buscarPorFecha", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor premiosService buscarPorFecha", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor premiosService buscarPorFecha");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("premiosservice guardar parsed: ${parsed}");
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error premiosService guardar: ${parsed["mensaje"]}");
    }

    return (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
  }

  static Future<List<Loteria>> borrar({BuildContext context, scaffoldKey, Loteria loteria}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    List<Loteria> listaLoteria = [];
    listaLoteria.add(loteria);

    map["idLoteria"] = loteria.id;
    map["descripcionLoteria"] = loteria.descripcion;
    map["abreviaturaLoteria"] = loteria.abreviatura;
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["layout"] = "";
    map["fecha"] = null;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    print("premiosservice borrar: ${mapDatos.toString()}");
    // return listaLoteria;

    var response = await http.post(Uri.parse(Utils.URL + "/api/premios/erase"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
     var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor premiosService borrar: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("premiosservice borrar parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error premiosService borrar: ${parsed["mensaje"]}");
    }

    return (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : List<Loteria>();
  }
}