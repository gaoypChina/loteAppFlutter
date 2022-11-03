import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/drift_database.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/sesion.dart';
import 'package:loterias/core/models/usuario.dart';
import 'dart:convert';


class UsuarioService{
  static Future<Map<String, dynamic>> index({@required BuildContext context, scaffoldKey, int idGrupo, bool retornarUsuarios = false, bool retornarRoles = false, bool retornarPermisos = false, bool retornarGrupos = false, Usuario usuario}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["servidor"] = await Db.servidor();
    map["idUsuario"] = await Db.idUsuario();
    map["usuario"] = usuario != null ? usuario.toJson() : null;
    map["idGrupo"] = idGrupo;
    map["retornarUsuarios"] = retornarUsuarios;
    map["retornarRoles"] = retornarRoles;
    map["retornarPermisos"] = retornarPermisos;
    map["retornarGrupos"] = retornarGrupos;

    var jwt = await Utils.createJwt(map);
    var response = await http.get(Uri.parse(Utils.URL + "/api/usuarios/v2?token=$jwt"), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("UsuarioService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor UsuarioService index", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor UsuarioService index");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      print("UsuarioService index parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error UsuarioService index: ${parsed["mensaje"]}");
    }

    return parsed;
  }
 
  static Future<Map<String, dynamic>> guardar({@required BuildContext context, scaffoldKey, @required Usuario usuario}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map = usuario.toJsonLarge();

    map["idUsuario"] = await Db.idUsuario();
    // map["usuario"] = usuario.toJson();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Uri.parse(Utils.URL + "/api/usuarios/guardar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("UsuarioService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor UsuarioService guardar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor UsuarioService guardar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error UsuarioService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }


  static Future<Map<String, dynamic>> eliminar({@required BuildContext context, scaffoldKey, @required Usuario usuario}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map = usuario.toJson();
    map["idUsuario"] = await Db.idUsuario();
    // map["usuario"] = usuario.toJson();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Uri.parse(Utils.URL + "/api/usuarios/eliminar"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("UsuarioService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["mensaje"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["mensaje"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor UsuarioService guardar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error UsuarioService guardar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<List<Usuario>> search({@required BuildContext context, scaffoldKey, String search, int idGrupo}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    // var jwt = await Utils.createJwtForTest(map);
    map = {
      "servidor" : await Db.servidor(),
      "search" : search,
      "idGrupo" : idGrupo,
    };
    var jwt = await Utils.createJwt(map);
    
    var map2 = {
      "datos" : jwt
    };
    
    var response = await http.post(Uri.parse(Utils.URL + "/api/usuarios/search"), body: json.encode(map2), headers: Utils.header);
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

    return parsed["data"].map<Usuario>((e) => Usuario.fromMap(e)).toList();
;
  }
 
  static Future<List<Sesion>> sesiones({@required BuildContext context, scaffoldKey, DateTimeRange fecha, int idGrupo}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    // var jwt = await Utils.createJwtForTest(map);
    map = {
      "servidor" : await Db.servidor(),
      "fecha" : fecha.start.toString(),
      "idGrupo" : idGrupo,
    };
    var jwt = await Utils.createJwt(map);
    
    var map2 = {
      "datos" : jwt
    };
    
    var response = await http.post(Uri.parse(Utils.URL + "/api/v2/usuarios/sesiones"), body: json.encode(map2), headers: Utils.header);
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

    return parsed["sesiones"].map<Sesion>((e) => Sesion.fromMap(e)).toList();
;
  }
 
  static Future<Map<String, dynamic>> searchTest({@required BuildContext context, scaffoldKey, String search}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    // map["servidor"] = "valentin";
    // var jwt = await Utils.createJwtForTest(map);
    map = {
      "servidor" : "valentin",
      "search" : search,
    };
    var jwt = await Utils.createJwtForTest(map);
    
    var map2 = {
      "datos" : jwt
    };
    
    var response = await http.post(Uri.parse(Utils.URL + "/api/usuarios/search"), body: json.encode(map2), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("BancaService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      // if(context != null)
      //   Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      // else
      //   Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
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

  static Future<String> obtenerContrasenas({@required BuildContext context, scaffoldKey, @required List<int> idUsuarios, int idGrupo}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["idUsuario"] = await Db.idUsuario();
    map["idUsuarios"] = idUsuarios;
    map["servidor"] = await Db.servidor();
    map["idGrupo"] = idGrupo;
    var jwt = await Utils.createJwt(map);
    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response = await http.post(Uri.parse(Utils.URL + "/api/usuarios/obtener/contrasenas"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("UsuarioService guardar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      // if(context != null)
      //   Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      // else
      //   Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      // if(context != null)
      //   Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      // else
      //   Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("${parsed["mensaje"]}");
    }

    return parsed["data"];
  }
 

}