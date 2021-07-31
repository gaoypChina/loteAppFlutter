import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/databasesingleton.dart';
import 'dart:convert';

import 'package:loterias/core/classes/utils.dart';

class DashboardService{
  static Future<Map<String, dynamic>> dashboard({BuildContext context, scaffoldKey, DateTime fecha, int idMoneda = 0}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["fecha"] = fecha.toString();
    map["idUsuario"] = (await Db.idUsuario()).toString();
    map["idMoneda"] = idMoneda.toString();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);

    var response = await http.get(Uri.parse(Utils.URL + "/api/dashboard?token=" + jwt), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("dashboardservice dashboard: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor dashboardservice dashboard", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor dashboardservice dashboard", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor dashboardservice dashboard");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error dashboardservice dashboard: ${parsed["mensaje"]}");
    }

    return parsed;
  }
}