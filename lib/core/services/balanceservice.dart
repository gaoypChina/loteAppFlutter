import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class BalanceService{
  static Future<List> bancas({BuildContext context, scaffoldKey, DateTime fechaHasta}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
   

    map["fechaHasta"] = fechaHasta.toString();
    map["idUsuario"] = await Db.idUsuario();
    map["layout"] = "Principal";
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Utils.URL + "/api/balance/bancas", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BalanceService bancas: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor BalanceService bancas", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor BalanceService bancas", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor BalanceService bancas");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error BalanceService bancas: ${parsed["mensaje"]}");
    }

    return List.from(parsed["bancas"]);
  }
}