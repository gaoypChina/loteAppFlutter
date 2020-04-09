import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/database.dart';
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
}