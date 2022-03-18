import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'dart:convert';

import 'package:loterias/core/models/tipos.dart';

class TransaccionService{
  static Future<Map<String, dynamic>> transacciones({BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["servidor"] = await Db.servidor();
    map["idGrupo"] = await Db.idGrupo();
    var jwt = await Utils.createJwt(map);
    var response = await http.get(Uri.parse(Utils.URL + "/api/transacciones/v2?token=$jwt"), headers: Utils.header);
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
      print("transaccionservice transacciones parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error transaccionservice transacciones: ${parsed["mensaje"]}");
    }

    return parsed;
  }
  static Future<Map<String, dynamic>> buscarTransacciones({BuildContext context, scaffoldKey, DateTime fechaDesde, DateTime fechaHasta, int idUsuario, int idTipoEntidad, int idEntidad, int idTipo}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    // var fechaDesdeString = fechaDesde.year.toString() + "-" + Utils.toDosDigitos(fechaDesde.month.toString()) + "-" + Utils.toDosDigitos(fechaDesde.day.toString());
    // var fechaHastaString = fechaHasta.year.toString() + "-" + Utils.toDosDigitos(fechaHasta.month.toString()) + "-" + Utils.toDosDigitos(fechaHasta.day.toString());
    map["fechaDesde"] = fechaDesde.toString();
    map["fechaHasta"] = fechaHasta.toString();
    map["idTipoEntidad"] = idTipoEntidad != null ? idTipoEntidad : 0;
    map["idEntidad"] = idEntidad != null ? idEntidad : 0;
    map["idTipo"] = idTipo != null ? idTipo : 0;
    map["idUsuario"] = idUsuario != null ? idUsuario : 0;
    // mapDatos["datos"] = map;
    map["idGrupo"] = await Db.idGrupo();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Uri.parse(Utils.URL + "/api/transacciones/buscarTransaccion"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("transaccionservice buscarTransacciones: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor transaccionservice buscarTransacciones", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor transaccionservice buscarTransacciones", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor transaccionservice buscarTransacciones");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("transaccioneservice buscarTransacciones parsed: $parsed");
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error transaccionservice buscarTransacciones: ${parsed["mensaje"]}");
    }

    return parsed;
  }
  static Future<Map<String, dynamic>> grupo({BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["servidor"] = await Db.servidor();
    map["idUsuario"] = await Db.idUsuario();
    map["idGrupo"] = await Db.idGrupo();
    var jwt = await Utils.createJwt(map);
    var response = await http.get(Uri.parse(Utils.URL + "/api/transacciones/v2/grupo?token=$jwt"), headers: Utils.header);
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
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Uri.parse(Utils.URL + "/api/transacciones/saldo"), body: json.encode(mapDatos), headers: Utils.header);
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
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Uri.parse(Utils.URL + "/api/transacciones/v2/guardar"), body: json.encode(mapDatos), headers: Utils.header);
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