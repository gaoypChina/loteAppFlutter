import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/draws.dart';
import 'dart:convert';

import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/models/ventaporfecha.dart';


class ReporteService{

   static Future<Map<String, dynamic>> jugadas({BuildContext context, scaffoldKey, Loteria loteria, Draws sorteo, Moneda moneda, DateTime fechaInicial, DateTime fechaFinal, String jugada, bool retornarLoterias = false, bool retornarSorteos = false, bool retornarMonedas = false, int limite = 20}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
   

    map["retornarLoterias"] = retornarLoterias;
    map["retornarSorteos"] = retornarSorteos;
    map["retornarMonedas"] = retornarMonedas;
    map["fechaInicial"] = fechaInicial.toString();
    map["fechaFinal"] = fechaFinal.toString();
    map["sorteo"] = (sorteo != null) ? sorteo.toJson() : null;
    map["loteria"] = (loteria != null) ? loteria.toJson() : null;
    map["jugada"] = (jugada != null) ? jugada : null;
    map["moneda"] = (moneda != null) ? moneda.toJson() : null;
    map["limite"] = limite;
    map["idUsuario"] = await Db.idUsuario();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    print("ReporteService historico: ${mapDatos.toString()}");
    // return listaBanca;

    var response = await http.post(Uri.parse(Utils.URL + "/api/reportes/reporteJugadas"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ReporteService historico: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Reporte jugadas", title: "Error");
      else
        Utils.showSnackBar(content: "Reporte jugadas", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor ReporteService Reporte jugadas");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error ReporteService historico: ${parsed["mensaje"]}");
    }

    return parsed;
  }
  

  static Future<Map<String, dynamic>> historico({BuildContext context, scaffoldKey, DateTime fechaDesde, DateTime fechaHasta, String opcion, Moneda moneda, int limite = 20}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
   

    map["fechaDesde"] = fechaDesde.toString();
    map["fechaHasta"] = fechaHasta.toString();
    map["moneda"] = (moneda != null) ? moneda.toJson() : null;
    map["opcion"] = opcion;
    map["limite"] = limite;
    map["idUsuario"] = await Db.idUsuario();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    print("ReporteService historico: ${mapDatos.toString()}");
    // return listaBanca;

    var response = await http.post(Uri.parse(Utils.URL + "/api/reportes/v2/historico"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ReporteService historico: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor ReporteService historico:  ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error ReporteService historico: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> ventas({BuildContext context, scaffoldKey, DateTime fecha, DateTime fechaFinal, int idBanca}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
   

    map["fecha"] = fecha.toString();
    map["fechaFinal"] = fechaFinal.toString();
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = idBanca;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    print("ReporteService ventas: ${mapDatos.toString()}");
    // return listaBanca;

    var response = await http.post(Uri.parse(Utils.URL + "/api/reportes/ventas"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ReporteService ventas: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("${parsed["message"]}");
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
  static Future<List<VentaPorFecha>> ventasPorFecha({BuildContext context, scaffoldKey, DateTimeRange date, List<Banca> bancas, Moneda moneda, bool retornarMonedas = false, bool retornarBancas = false}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
   

    map["fechaDesde"] = date.start.toString();
    map["fechaHasta"] = date.end.toString();
    map["idUsuario"] = await Db.idUsuario();
    map["bancas"] = bancas != null ? Banca.bancasToJson(bancas) : [];
    map["moneda"] = moneda != null ? moneda.toJson() : null;
    map["retornarBancas"] = retornarBancas;
    map["retornarMonedas"] = retornarMonedas;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    print("ReporteService ventas: ${mapDatos.toString()}");
    // return listaBanca;

    var response = await http.post(Uri.parse(Utils.URL + "/api/reportes/v2/ventasPorFecha"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ReporteService ventas: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("${parsed["message"]}");
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

    return parsed["data"].map<VentaPorFecha>((e) => VentaPorFecha.fromMap(e)).toList();
  }

  static Future<Map<String, dynamic>> ticketsPendientesPago({BuildContext context, scaffoldKey, String fechaString, int idBanca}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["fecha"] = fechaString;
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = idBanca;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Uri.parse(Utils.URL + "/api/reportes/ticketsPendientesDePagoIndex"), body: json.encode(mapDatos), headers: Utils.header);
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