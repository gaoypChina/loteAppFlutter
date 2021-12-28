import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/cierreloteria.dart';
import 'package:loterias/core/models/pago.dart';
import 'dart:convert';

import 'package:loterias/core/models/servidores.dart';

class CierreloteriaService{

  static Future<Map<String, dynamic>> index({BuildContext context, scaffoldKey, DateTime date}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["servidor"] = await Db.servidor();
    map["idUsuario"] = await Db.idUsuario();
    map["date"] = Utils.dateTimeToDate(date, null);
    var jwt = await Utils.createJwt(map);
    var response = await http.get(Uri.parse(Utils.URL + "/api/lotteryclosing?token=$jwt"), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("CierreloteriaService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor CierreloteriaService index: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      print("CierreloteriaService index parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error CierreloteriaService index: ${parsed["mensaje"]}");
    }

    return parsed;
  }

 
  static Future<Map<String, dynamic>> guardar({BuildContext context, scaffoldKey, List<Cierreloteria> cierreLoterias, List<Servidor> servidores}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["servidor"] = await Db.servidor();
    map["idUsuario"] = await Db.idUsuario();
    map["idServidores"] = servidores != null ? servidores.map((e) => e.id).toList() : [];
    map["lotteryclosings"] = Cierreloteria.cierreloteriaToJson(cierreLoterias);
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;
    var response = await http.post(Uri.parse(Utils.URL + "/api/lotteryclosing/store"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    print("CerrarloteriasService guardar: ${response.body}");
    if(statusCode < 200 || statusCode > 400){
      print("CierreloteriaService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor CierreloteriaService fechaProximoPago: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      // print("cierrloteriaservice servidorExiste parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error CierreloteriaService fechaProximoPago: ${parsed["mensaje"]}");
    }

    return parsed;
  }

 
  static Future<Cierreloteria> eliminar({BuildContext context, scaffoldKey, Cierreloteria data, List<Servidor> servidores}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["servidor"] = await Db.servidor();
    map["idUsuario"] = await Db.idUsuario();
    map["idServidores"] = servidores != null ? servidores.map((e) => e.id).toList() : [];
    map["id"] = data != null ? data.id : null;
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;
    var response = await http.post(Uri.parse(Utils.URL + "/api/lotteryclosing/delete"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    print("CerrarloteriasService guardar: ${response.body}");
    if(statusCode < 200 || statusCode > 400){
      print("CierreloteriaService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor CierreloteriaService fechaProximoPago: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      // print("cierrloteriaservice servidorExiste parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error CierreloteriaService fechaProximoPago: ${parsed["mensaje"]}");
    }

    return parsed["data"] != null ? Cierreloteria.fromMap(parsed["data"]) : null;
  }

 

}