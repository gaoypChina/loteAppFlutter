import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class BancaService{
  static Future<List<Banca>> all({BuildContext context, GlobalKey<ScaffoldState> scaffoldKey}) async {
    var map = Map<String, dynamic>();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    var response = await http.get(Uri.parse(Utils.URL + "/api/bancas?token=$jwt"), headers: Utils.header);
    int statusCode =response.statusCode;

    

    if(statusCode < 200 || statusCode > 400){
      print("Servidor BancaService all: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(content: "Error BancaService all", title: "Error", context: context);
      else
        Utils.showSnackBar(content: "Error BancaService all", scaffoldKey: scaffoldKey);
      throw Exception("Error Servidor BancaService all");
    }

    var parsed = await compute(Utils.parseDatos, response.body);

    if(parsed["errores"] == 1){
      print("BancaService error all: ${parsed["mensaje"]}");
      if(context != null)
        Utils.showAlertDialog(content: parsed["mensaje"], title: "Error", context: context);
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error BancaService all");
    }

    print("Dentro bancas service all: ${parsed["bancas"]}");

    return (parsed["bancas"] != null) ? parsed["bancas"].map<Banca>((json) => Banca.fromMap(json)).toList() : List<Banca>();
  }

  static Future<Map<String, dynamic>> index({@required BuildContext context, scaffoldKey, retornarBancas = false, retornarUsuarios = false, retornarMonedas = false, retornarLoterias = false, retornarFrecuencias = false, retornarDias = false, retornarGrupos = false, Banca data}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    // map["servidor"] = "valentin";
    // var jwt = await Utils.createJwtForTest(map);
    map = {
      "retornarBancas" : retornarBancas,
      "retornarLoterias" : retornarLoterias,
      "retornarUsuarios" : retornarUsuarios,
      "retornarMonedas" : retornarMonedas,
      "retornarFrecuencias" : retornarFrecuencias,
      "retornarDias" : retornarDias,
      "retornarGrupos" : retornarGrupos,
      "servidor" : await Db.servidor(),
      "data" : data != null ? data.toJsonSave() : null,
    };
    var jwt = await Utils.createJwt(map);
    

    
    var response = await http.get(Uri.parse(Utils.URL + "/api/v2/bancas?token=$jwt"), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BancaService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor BancaService index: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error BancaService index: ${parsed["mensaje"]}");
    }

    return parsed;
  }
 
  static Future<Map<String, dynamic>> indexTest({@required BuildContext context, scaffoldKey, retornarBancas = false, retornarUsuarios = false, retornarMonedas = false, retornarLoterias = false, retornarFrecuencias = false, retornarDias = false, retornarGrupos = false, Banca data}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    // map["servidor"] = "valentin";
    // var jwt = await Utils.createJwtForTest(map);
    map = {
      "retornarBancas" : retornarBancas,
      "retornarLoterias" : retornarLoterias,
      "retornarUsuarios" : retornarUsuarios,
      "retornarMonedas" : retornarMonedas,
      "retornarFrecuencias" : retornarFrecuencias,
      "retornarDias" : retornarDias,
      "retornarGrupos" : retornarGrupos,
      "servidor" : "valentin",
      "data" : {"id" : 1},
    };
    var jwt = await Utils.createJwtForTest(map);
    

    
    var response = await http.get(Uri.parse(Utils.URL + "/api/v2/bancas?token=$jwt"), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BancaService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor BancaService index: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error BancaService index: ${parsed["mensaje"]}");
    }

    return parsed;
  }
 
  static Future<Map<String, dynamic>> guardar({@required BuildContext context, scaffoldKey, @required Banca data}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map = data.toJsonSave();
    map["usuarioData"] = await Db.getUsuario();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response = await http.post(Uri.parse(Utils.URL + "/api/bancas/v2/guardar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BancaService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor BancaService guardar ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error BancaService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }


  static Future<Map<String, dynamic>> eliminar({@required BuildContext context, scaffoldKey, @required Banca data}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map = data.toJson();
    map["usuario"] = await Db.getUsuario();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Uri.parse(Utils.URL + "/api/bancas/eliminar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BancaService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor BancaService guardar ${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor BancaService guardar: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error BancaService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }
}