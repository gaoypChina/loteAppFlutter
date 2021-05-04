import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'dart:convert';

class ServidorService{
  static Future<Map<String, dynamic>> servidorExiste({BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;
    var response = await http.post(Uri.parse(Utils.URL + "/api/servidor/servidorExiste"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("transaccionservice servidorExiste: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor transaccionservice servidorExiste", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor transaccionservice servidorExiste", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor transaccionservice servidorExiste");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      print("transaccionservice servidorExiste parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error transaccionservice servidorExiste: ${parsed["mensaje"]}");
    }

    return parsed;
  }

}