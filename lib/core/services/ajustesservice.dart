import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/principal.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/models/ajuste.dart';
import 'dart:convert';

import 'package:loterias/core/models/loterias.dart';



class AjustesService{
  static Future<Map<String, dynamic>> index({BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    

    // map["loterias"] = [loteria.toJson()];
    // map["idUsuario"] = await Db.idUsuario();
    // map["idBanca"] = await Db.idBanca();
    // map["layout"] = "";
    // map["servidor"] = await Db.servidor();
    
    map = {
      "servidor" : await Db.servidor(),
      "usuario" : await Db.getUsuario()
    };

    // map = {
    //   "servidor" : "valentin",
    //   "usuario" : {"id" : 1}
    // };

    var jwt = await Utils.createJwt(map);
    // var jwt = await Utils.createJwtForTest(map);
    mapDatos["datos"] = jwt;

    print("AjustesService guardar: ${mapDatos.toString()}");
    // return listaLoteria;

    var response = await http.post(Utils.URL + "/api/ajustes", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("AjustesService guardar: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor AjustesService guardar", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor AjustesService guardar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor AjustesService guardar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("AjustesService guardar parsed: ${parsed}");
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error AjustesService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  
  static Future<Ajuste> guardar({BuildContext context, scaffoldKey, Ajuste ajuste}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map = {
      "servidor" : await Db.servidor(),
      "usuario" : await Db.getUsuario(),
      "ajustes" : ajuste.toJson()
    };
    
    // map = {
    //  "servidor" : "valentin",
    //   "usuario" : {"id" : 1},
    //   "ajustes" : ajuste.toJson()
    // };

    var jwt = await Utils.createJwtForTest(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Utils.URL + "/api/ajustes/guardar", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("AjustesService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed['message']}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed['message']}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor AjustesService guardar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("AjustesService guardar parsed: ${parsed}");
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error AjustesService guardar: ${parsed["mensaje"]}");
    }

    return (parsed["data"] != null) ? Ajuste.fromMap(parsed["data"]) : Ajuste();
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
    map["fecha"] = null;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    print("AjustesService borrar: ${mapDatos.toString()}");
    // return listaLoteria;

    var response = await http.post(Utils.URL + "/api/premios/erase", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("AjustesService borrar: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor AjustesService borrar", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor AjustesService borrar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor AjustesService borrar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("AjustesService borrar parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error AjustesService borrar: ${parsed["mensaje"]}");
    }

    return (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : List<Loteria>();
  }
}