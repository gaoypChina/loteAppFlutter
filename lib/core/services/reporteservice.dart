import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'dart:convert';


class ReporteService{
  

  static Future<List<Banca>> historico({BuildContext context, scaffoldKey, DateTime fechaDesde, DateTime fechaHasta}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
   

    map["fechaDesde"] = fechaDesde;
    map["fechaHasta"] = fechaHasta;
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

    return (parsed["Bancas"] != null) ? parsed["Bancas"].map<Banca>((json) => Banca.fromMap(json)).toList() : List<Banca>();
  }

}