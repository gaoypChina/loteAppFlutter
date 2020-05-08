import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'dart:convert';

class TransaccionService{
  static Future<Map<String, dynamic>> transacciones({BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    var response = await http.get(Utils.URL + "/api/transacciones", headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("transaccionservice transacciones: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor transaccionservice transacciones", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor transaccionservice transacciones", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor transaccionservice transacciones");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error transaccionservice transacciones: ${parsed["mensaje"]}");
    }

    return parsed;
  }
  static Future<Map<String, dynamic>> grupo({BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    var response = await http.get(Utils.URL + "/api/transacciones/grupo", headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("transaccionservice grupo: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor transaccionservice grupo", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor transaccionservice grupo", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor transaccionservice grupo");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error transaccionservice grupo: ${parsed["mensaje"]}");
    }

    return parsed;
  }
  
  static Future<Map<String, dynamic>> saldo({BuildContext context, scaffoldKey, int id, bool esBanca = true}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["id"] = id;
    map["es_banca"] = esBanca;
    mapDatos["datos"] = map;

    var response = await http.post(Utils.URL + "/api/transacciones/saldo", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("transaccionservice saldo: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor transaccionservice saldo", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor transaccionservice saldo", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor transaccionservice saldo");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error transaccionservice saldo: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> guardar({BuildContext context, scaffoldKey, int idUsuario, List transacciones}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = idUsuario;
    map["addTransaccion"] = transacciones;
    mapDatos["datos"] = map;

    var response = await http.post(Utils.URL + "/api/transacciones/guardar", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("transaccionservice guardar: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor transaccionservice guardar", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor transaccionservice guardar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor transaccionservice guardar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error transaccionservice guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }
}