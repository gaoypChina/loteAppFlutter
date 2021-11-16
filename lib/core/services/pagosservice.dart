import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/pago.dart';
import 'dart:convert';

import 'package:loterias/core/models/servidores.dart';

class PagosService{
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

  static Future<Map<String, dynamic>> index({BuildContext context, scaffoldKey, Servidor servidor, Pago pago}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["servidor"] = await Db.servidor();
    map["idUsuario"] = await Db.idUsuario();
    map["servidorObject"] = servidor.toJsonFull();
    map["idPago"] = pago != null ? pago.id : null;
    var jwt = await Utils.createJwt(map);
    var response = await http.get(Uri.parse(Utils.URL + "/api/pagos?token=$jwt"), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("PagosService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor PagosService index: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      print("PagosService index parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error PagosService index: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> fechaProximoPago({BuildContext context, scaffoldKey, Servidor servidor, DateTime fechaProximoPago}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["servidorObject"] = servidor.toJson();
    map["fechaProximoPago"] = fechaProximoPago.toString();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;
    var response = await http.post(Uri.parse(Utils.URL + "/api/pagos/fechaProximoPago"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("PagosService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor PagosService fechaProximoPago: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      print("transaccionservice servidorExiste parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error PagosService fechaProximoPago: ${parsed["mensaje"]}");
    }

    return parsed;
  }


  static Future<Map<String, dynamic>> getBancaDetallesPago({BuildContext context, scaffoldKey, Servidor servidor, DateTime fechaInicial, DateTime fechaFinal, double precioMensualPorBanca}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["servidor"] = servidor.descripcion;
    map["fechaInicial"] = fechaInicial.toString();
    map["fechaFinal"] = fechaFinal.toString();
    map["precioMensualPorBanca"] = precioMensualPorBanca;
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;
    var response = await http.post(Uri.parse(Utils.URL + "/api/pagos/getBancaDetallesPago"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("PagosService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor PagosService fechaProximoPago: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      print("transaccionservice servidorExiste parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error PagosService fechaProximoPago: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> guardar({BuildContext context, scaffoldKey, Servidor servidor, Pago pago, DateTime fechaProximoPago}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["servidor"] = await Db.servidor();
    map["usuario"] = await Db.getUsuario();
    map["servidorObject"] = servidor.toJson();
    map["pago"] = pago.toJson();
    map["fechaProximoPago"] = fechaProximoPago != null ? fechaProximoPago.toString() : null;
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;
    var response = await http.post(Uri.parse(Utils.URL + "/api/pagos/guardar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("PagosService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor PagosService fechaProximoPago: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      // print("transaccionservice servidorExiste parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error PagosService fechaProximoPago: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> getById({BuildContext context, scaffoldKey, @required int id}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["id"] = id;
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;
    var response = await http.post(Uri.parse(Utils.URL + "/api/pagos/getById"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("PagosService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor PagosService getById: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      print("transaccionservice servidorExiste parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error PagosService getById: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> pagar({@required BuildContext context, scaffoldKey, @required Pago data, DateTime fechaProximoPago}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["id"] = data.id;
    map["fechaProximoPago"] = fechaProximoPago != null ? fechaProximoPago.toString() : null;
    map["usuario"] = await Db.getUsuario();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;
    var response = await http.post(Uri.parse(Utils.URL + "/api/pagos/pagar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("PagosService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor PagosService pagar: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      print("transaccionservice servidorExiste parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error PagosService pagar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> reenviarNotificacion({@required BuildContext context, scaffoldKey, @required Pago data}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["id"] = data.id;
    map["usuario"] = await Db.getUsuario();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;
    var response = await http.post(Uri.parse(Utils.URL + "/api/pagos/reenviarNotification"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("PagosService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor PagosService pagar: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      print("transaccionservice servidorExiste parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error PagosService pagar: ${parsed["mensaje"]}");
    }

    return parsed;
  }


}