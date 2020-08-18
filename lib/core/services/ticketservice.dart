import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/ventas.dart';


class TicketService{
  

  static Future<Map<String, dynamic>> cancelar({String codigoBarra, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["razon"] = "Cancelado desde movil";
    map["codigoBarra"] = codigoBarra;
   map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Utils.URL + "/api/principal/cancelarMovil", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ticketService cancelar: ${response.body}");
      Utils.showSnackBar(content: "Error del servidor ticketService cancelar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor ticketService cancelar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("ticketservice duplicar: $parsed");
    if(parsed["errores"] == 1){
      Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error ticketService cancelar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> duplicar({String codigoBarra, String codigoQr, scaffoldKey, BuildContext context}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    
    map["codigoBarra"] = codigoBarra;
    map["codigoQr"] = codigoQr;
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Utils.URL + "/api/principal/duplicar", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ticketService duplicar: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor ticketService duplicar", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor ticketService duplicar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor ticketService duplicar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("ticketservice duplicar: $parsed");
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error ticketService duplicar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> buscarTicketAPagar({String codigoBarra, String codigoQr, BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    
    map["codigoBarra"] = codigoBarra;
    map["codigoQr"] = codigoQr;
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Utils.URL + "/api/principal/buscarTicketAPagar", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ticketService buscarTicketAPagar: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor ticketService buscarTicketAPagar", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor ticketService buscarTicketAPagar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor ticketService buscarTicketAPagar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error ticketService buscarTicketAPagar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> buscarTicket({String codigoBarra = "", String codigoQr = "", BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    
    map["codigoBarra"] = codigoBarra;
    map["codigoQr"] = codigoQr;
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Utils.URL + "/api/principal/buscarTicket", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ticketService buscarTicket: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor ticketService buscarTicket", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor ticketService buscarTicket", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor ticketService buscarTicket");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error ticketService buscarTicket: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> ticket({BigInt idTicket, BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    
    map["idTicket"] = idTicket.toInt();
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Utils.URL + "/api/reportes/getTicketById", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ticketService ticketById: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor ticketService ticketById", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor ticketService ticketById", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor ticketService ticketById");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("ticketservice getTicketById: ${parsed["ticket"]["testImage"]}");
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error ticketService ticketById: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<Map<String, dynamic>> pagar({String codigoBarra = "", String codigoQr = "", BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    
    map["codigoBarra"] = codigoBarra;
    map["codigoQr"] = codigoQr;
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Utils.URL + "/api/principal/pagar", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ticketService pagar: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor ticketService pagar", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor ticketService pagar", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor ticketService pagar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error ticketService pagar: ${parsed["mensaje"]}");
    }

    return parsed;
  }

  static Future<List<Venta>> monitoreo({String fecha = "", int idBanca, BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = idBanca;
    map["fecha"] = fecha;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Utils.URL + "/api/reportes/monitoreoMovil", body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ticketService monitoreo: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor ticketService monitoreo", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor ticketService monitoreo", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor ticketService monitoreo");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error ticketService monitoreo: ${parsed["mensaje"]}");
    }

    return parsed["monitoreo"].map<Venta>((json) => Venta.fromMap(json)).toList();
  }

  static showDialogAceptaCancelar({BuildContext context, String ticket}) async{
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          title: Text("Desea cancelar"),
          content: Text("Desea cancelar ticket $ticket"),
          actions: <Widget>[
            FlatButton(onPressed: (){Navigator.of(context).pop(false);}, child: Text("No")),
            FlatButton(onPressed: (){Navigator.of(context).pop(true);}, child: Text("Si"))
          ],
        );
      }
    );
  }

  static showDialogDeseaImprimir({BuildContext context}) async{
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          title: Text("Desea imprimir"),
          content: Text("Desea imprimir?"),
          actions: <Widget>[
            FlatButton(onPressed: (){Navigator.of(context).pop(false);}, child: Text("No")),
            FlatButton(onPressed: (){Navigator.of(context).pop(true);}, child: Text("Si"))
          ],
        );
      }
    );
  }

  static Future<Map<String, dynamic>> guardar({String idVenta, bool compartido, int descuentomonto, bool hayDescuento, double total, List<dynamic> loterias, List<dynamic> jugadas, int idUsuario, int idBanca, GlobalKey<ScaffoldState> scaffoldKey}) async {
    var map = new Map<String, dynamic>();
    var map2 = new Map<String, dynamic>();
    map["idVenta"] = idVenta;
    map["compartido"] = (compartido) ? 1 : 0;
    map["descuentoMonto"] = descuentomonto;
    map["hayDescuento"] = hayDescuento;
    map["total"] = total;
    map["subTotal"] = 0;
    map["loterias"] = loterias;
    map["jugadas"] = jugadas;
    map["idUsuario"] = idUsuario;
    map["idBanca"] = idBanca;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    map2["datos"] =jwt;

    var response = await http.post(Utils.URL +"/api/principal/guardar", body: json.encode(map2), headers: Utils.header);
    int statusCode = response.statusCode;
    if(statusCode < 200 || statusCode > 400){
      print("Error servidor ticketService guardar: ${response.body}");
      Utils.showSnackBar(scaffoldKey: scaffoldKey, content: "Error servidor ticketservice guardar");
      throw Exception("Error servidor ticketService guardar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);

     if(parsed["errores"] == 1){
      print("Principal parsedDatos: ${parsed["mensaje"]}");
      Utils.showSnackBar(scaffoldKey: scaffoldKey, content: parsed["mensaje"]);
      throw Exception("Error Principal parsedDatos: ${parsed["mensaje"]}");
    }

    var mapDatos = Map<String, dynamic>();
    mapDatos["bancas"] = parsed['bancas'].map<Banca>((json) => Banca.fromMap(json)).toList();
    mapDatos["loterias"] = parsed['loterias'].map<Loteria>((json) => Loteria.fromMap(json)).toList();
    mapDatos["ventas"] = parsed['ventas'].map<Venta>((json) => Venta.fromMap(json)).toList();
    mapDatos["idVenta"] = parsed['idVenta'];
    mapDatos["errores"] = parsed['errores'];
    mapDatos["mensaje"] = parsed['mensaje'];
    mapDatos["venta"] = parsed['venta'];
    mapDatos["img"] = parsed['img'];
    print(parsed['ventas']);
    // map["bancas"] = "jean";
    return mapDatos;
  }
  static Future<Map<String, dynamic>> indexPost({int idUsuario, int idBanca, GlobalKey<ScaffoldState> scaffoldKey}) async {
    var map = new Map<String, dynamic>();
    var map2 = new Map<String, dynamic>();
   
    map["idUsuario"] = idUsuario;
    map["idBanca"] = idBanca;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    map2["datos"] =jwt;
    var response = await http.post(Utils.URL +"/api/principal/indexPost", body: json.encode(map2), headers: Utils.header);
    int statusCode = response.statusCode;
    if(statusCode < 200 || statusCode > 400){
      print("Error servidor ticketService indexPost: ${response.body}");
      Utils.showSnackBar(scaffoldKey: scaffoldKey, content: "Error servidor ticketservice indexPost");
      // scaffoldKey.currentState.showSnackBar(
      // SnackBar(
      //   content: Text("Vuelva a cargar"),
      //   elevation: 25,
      //   action: SnackBarAction(label: 'CERRAR', onPressed: () => scaffoldKey.currentState.hideCurrentSnackBar(),),
      // ));
      throw Exception("Error servidor ticketService indexPost");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("tickerservice indexPost: ${parsed.toString()}");

     if(parsed["errores"] == 1){
      print("Principal parsedDatos: ${parsed["mensaje"]}");
      Utils.showSnackBar(scaffoldKey: scaffoldKey, content: parsed["mensaje"]);
      throw Exception("Error Principal parsedDatos: ${parsed["mensaje"]}");
    }

    var mapDatos = Map<String, dynamic>();
    mapDatos["bancas"] = parsed['bancas'].map<Banca>((json) => Banca.fromMap(json)).toList();
    mapDatos["loterias"] = parsed['loterias'].map<Loteria>((json) => Loteria.fromMap(json)).toList();
    mapDatos["ventas"] = parsed['ventas'].map<Venta>((json) => Venta.fromMap(json)).toList();
    mapDatos["idVenta"] = parsed['idVenta'];
    mapDatos["errores"] = parsed['errores'];
    mapDatos["mensaje"] = parsed['mensaje'];
    mapDatos["venta"] = parsed['venta'];
    mapDatos["img"] = parsed['img'];
    print(parsed['ventas']);
    // map["bancas"] = "jean";
    return mapDatos;
  }

}