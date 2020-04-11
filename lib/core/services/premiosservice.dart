import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/principal.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:loterias/core/models/loterias.dart';



class PremiosService{
  static Future<List<Loteria>> getLoterias({BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    var response = await http.get(Utils.URL + "/api/premios", headers: Utils.header);
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

    return (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : List<Loteria>();
  }
  
  static Future<List<Loteria>> guardar({BuildContext context, scaffoldKey, Loteria loteria}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    List<Loteria> listaLoteria = List<Loteria>();
    listaLoteria.add(loteria);

    map["loterias"] = [loteria.toJson()];
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["layout"] = "";
    mapDatos["datos"] = map;

    print("premiosservice guardar: ${mapDatos.toString()}");
    // return listaLoteria;

    var response = await http.post(Utils.URL + "/api/premios/guardar", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("premiosService guardar: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor premiosService guardar", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor premiosService guardar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor premiosService guardar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error premiosService guardar: ${parsed["mensaje"]}");
    }

    return (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : List<Loteria>();
  }

  static Future<List<Loteria>> borrar({BuildContext context, scaffoldKey, Loteria loteria}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    List<Loteria> listaLoteria = List<Loteria>();
    listaLoteria.add(loteria);

    map["idLoteria"] = loteria.id;
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["layout"] = "";
    map["fecha"] = "";
    mapDatos["datos"] = map;

    print("premiosservice borrar: ${mapDatos.toString()}");
    // return listaLoteria;

    var response = await http.post(Utils.URL + "/api/premios/erase", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("premiosService borrar: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor premiosService borrar", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor premiosService borrar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor premiosService borrar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
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