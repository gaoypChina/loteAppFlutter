import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/database.dart';
import 'dart:convert';

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/notificacion.dart';

class NotificationService{
  static Future<Map<String, dynamic>> index({BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = (await Db.idUsuario()).toString();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);

    var response = await http.get(Utils.URL + "/api/notifications?token=" + jwt, headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("NotificationService index: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor NotificationService index", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor NotificationService index", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor NotificationService index");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error NotificationService index: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static guardar({BuildContext context, scaffoldKey, Notificacion notificacion}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["notificacion"] = notificacion.toJson();
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    print("notificationservice guardar: ${map["notificacion"]}");
    // return listaLoteria;

    var response = await http.post(Utils.URL + "/api/notifications/guardar", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("notificationservice guardar: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor notificationservice guardar", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor notificationservice guardar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor notificationservice guardar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("notificationservice guardar parsed: ${parsed}");
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error notificationservice guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

}