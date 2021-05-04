import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:http/http.dart' as http;


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
}