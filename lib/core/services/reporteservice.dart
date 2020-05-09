import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'dart:convert';


class ReporteService{
  

  static Future<List> historico({BuildContext context, scaffoldKey, DateTime fechaDesde, DateTime fechaHasta}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
   

    map["fechaDesde"] = fechaDesde.toString();
    map["fechaHasta"] = fechaHasta.toString();
    map["idUsuario"] = await Db.idUsuario();
    mapDatos["datos"] = map;

    print("ReporteService historico: ${mapDatos.toString()}");
    // return listaBanca;

    var response = await http.post(Utils.URL + "/api/reportes/historico", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ReporteService historico: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor ReporteService historico", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor ReporteService historico", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor ReporteService historico");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error ReporteService historico: ${parsed["mensaje"]}");
    }

    return List.from(parsed["bancas"]);
  }

  static Future<Map<String, dynamic>> ventas({BuildContext context, scaffoldKey, DateTime fecha, int idBanca}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
   

    map["fecha"] = fecha.toString();
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = idBanca;
    mapDatos["datos"] = map;

    print("ReporteService ventas: ${mapDatos.toString()}");
    // return listaBanca;

    var response = await http.post(Utils.URL + "/api/reportes/ventas", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ReporteService ventas: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor ReporteService ventas", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor ReporteService ventas", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor ReporteService ventas");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("reporteservice ventas datos: ${parsed.toString()}");
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error ReporteService ventas: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> ticketsPendientesPago({BuildContext context, scaffoldKey, String fechaString, int idBanca}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["fecha"] = fechaString;
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = idBanca;
    mapDatos["datos"] = map;

    var response = await http.post(Utils.URL + "/api/reportes/ticketsPendientesDePagoIndex", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ReporteService ticketsPendientesPago: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor ReporteService ticketsPendientesPago", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor ReporteService ticketsPendientesPago", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor ReporteService ticketsPendientesPago");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error ReporteService ticketsPendientesPago: ${parsed["mensaje"]}");
    }

    return parsed;
  }

}