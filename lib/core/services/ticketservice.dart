import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/utils.dart';


class TicketService{
  static Future<Map<String, dynamic>> ticket({BigInt idTicket, scaffoldKey}) async {
    Map<String, dynamic> map = Map<String, dynamic>(); 
    Map<String, dynamic> mapDatos = Map<String, dynamic>(); 
    map["idUsuario"] = await Db.idUsuario();
    map["idTicket"] = idTicket.toInt();
    mapDatos["datos"] = map;

    print("ticketservice ticket: ${mapDatos.toString()}");

    var response = await http.post(Utils.URL + "/api/reportes/getTicketById", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;
    if(statusCode < 200 || statusCode > 400){
      print("ticketService error ticket: ${response.body}");
      Utils.showSnackBar(content: "Error del servidor ticketServiceTicket");
      throw Exception("Error response http TicketService ticket");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      print("ticketService error ticket: ${parsed["mensaje"]}");
      Utils.showSnackBar(content: "Error ${parsed["mensaje"]}");
      throw Exception("Error response http TicketService ticket");
    }

    print("ticketservice ticket: ${parsed.toString()}");

    return parsed;
  }

  static Future<Map<String, dynamic>> cancelar({String codigoBarra, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["razon"] = "Cancelado desde movil";
    map["codigoBarra"] = codigoBarra;
    mapDatos["datos"] = map;

    var response = await http.post(Utils.URL + "/api/principal/cancelarMovil", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ticketService cancelar: ${response.body}");
      Utils.showSnackBar(content: "Error del servidor ticketService cancelar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor ticketService cancelar");
    }

    var parsed = Utils.parseDatos(response.body);
    if(parsed["errores"] == 1){
      Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error ticketService cancelar: ${parsed["mensaje"]}");
    }

    return parsed;
  }
}