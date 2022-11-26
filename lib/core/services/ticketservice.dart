import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/myfilemanager.dart';
import 'package:loterias/core/classes/principal.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/sale.dart';
import 'package:loterias/core/models/salesdetails.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/models/ventas.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mydescripcion.dart';
import 'package:loterias/ui/widgets/mytable.dart';

import '../models/jugadas.dart';


class TicketService{

  static Future<Map<String, dynamic>> montoDisponible({@required BuildContext context, @required String jugada, @required int idBanca, @required int idLoteria, int idLoteriaSuperpale}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    map["idUsuario"] = await Db.idUsuario();
    map["jugada"] = jugada;
    map["idBanca"] = idBanca;
    map["idLoteria"] = idLoteria;
    map["idLoteriaSuperpale"] = idLoteriaSuperpale;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);


    mapDatos = {
      "datos" : jwt
    };


    var response = await http.post(Uri.parse(Utils.URL + "/api/principal/montodisponible"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("GrupoService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      // else
      //   Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor GrupoService index: ${parsed["message"]}");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
      print("GrupoService index parsed: ${parsed}");

    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      // else
      //   Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error GrupoService index: ${parsed["mensaje"]}");
    }

    return parsed;
  }
  

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

    var response = await http.post(Uri.parse(Utils.URL + "/api/principal/v3/cancelarMovil"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("ticketService cancelar: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
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

    var response = await http.post(Uri.parse(Utils.URL + "/api/principal/v2/duplicar"), body: json.encode(mapDatos), headers: Utils.header);
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

    var response = await http.post(Uri.parse(Utils.URL + "/api/principal/buscarTicketAPagar"), body: json.encode(mapDatos), headers: Utils.header);
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

    var response = await http.post(Uri.parse(Utils.URL + "/api/principal/buscarTicket"), body: json.encode(mapDatos), headers: Utils.header);
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

    var response = await http.post(Uri.parse(Utils.URL + "/api/reportes/getTicketById"), body: json.encode(mapDatos), headers: Utils.header);
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

  static Future<Map<String, dynamic>> ticketV2({BigInt idVenta, BuildContext context, scaffoldKey, bool compartirTicket = false}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    
    map["idVenta"] = idVenta.toInt();
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = await Db.idBanca();
    map["servidor"] = await Db.servidor();
    // map["compartirTicket"] = compartirTicket;
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Uri.parse(Utils.URL + "/api/reportes/v2/getTicketById"), body: json.encode(mapDatos), headers: Utils.header);
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
    // print("ticketservice getTicketById: ${parsed["ticket"]["testImage"]}");
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

    var response = await http.post(Uri.parse(Utils.URL + "/api/principal/pagar"), body: json.encode(mapDatos), headers: Utils.header);
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

  static Future<List<Venta>> monitoreo({DateTime fecha, DateTime fechaFinal, int idBanca, BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = idBanca;
    map["fecha"] = (fecha != null) ? fecha.toString() : DateTime.now().toString();
    map["fechaFinal"] = (fechaFinal != null) ? fechaFinal.toString() : DateTime.now().toString();
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Uri.parse(Utils.URL + "/api/reportes/monitoreoMovil"), body: json.encode(mapDatos), headers: Utils.header);
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

    print("ticketservice monitoreo: $parsed");

    return parsed["monitoreo"].map<Venta>((json) => Venta.fromMap(json)).toList();
  }

  static Future<Map<String, dynamic>> monitoreoV2({DateTime fecha, DateTime fechaFinal, int idBanca, BuildContext context, scaffoldKey, bool retornarBancas = false, int idGrupo, int idLoteria}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = idBanca;
    map["fecha"] = (fecha != null) ? fecha.toString() : DateTime.now().toString();
    map["fechaFinal"] = (fechaFinal != null) ? fechaFinal.toString() : DateTime.now().toString();
    map["servidor"] = await Db.servidor();
    map["retornarBancas"] = retornarBancas;
    map["grupo"] = idGrupo;
    map["idLoteria"] = idLoteria;
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Uri.parse(Utils.URL + "/api/reportes/v2/monitoreoMovil"), body: json.encode(mapDatos), headers: Utils.header);
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

    print("ticketservice monitoreo: $parsed");

    return parsed;
  }

  static Future<Map<String, dynamic>> monitoreoGzipV2({DateTime fecha, DateTime fechaFinal, int idBanca, BuildContext context, scaffoldKey, bool retornarBancas = false, int idGrupo, int idLoteria}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();
    
    map["idUsuario"] = await Db.idUsuario();
    map["idBanca"] = idBanca;
    map["fecha"] = (fecha != null) ? fecha.toString() : DateTime.now().toString();
    map["fechaFinal"] = (fechaFinal != null) ? fechaFinal.toString() : DateTime.now().toString();
    map["servidor"] = await Db.servidor();
    map["retornarBancas"] = retornarBancas;
    map["grupo"] = idGrupo;
    map["idLoteria"] = idLoteria;
    var jwt = await Utils.createJwt(map);
    mapDatos["datos"] = jwt;

    var response = await http.post(Uri.parse(Utils.URL + "/api/reportes/v2/monitoreoMovil/gzip"), body: json.encode(mapDatos), headers: Utils.header);
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

    print("ticketservice monitoreo: $parsed");

    return parsed;
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

  static Future<Map<String, dynamic>> guardar({context, String idVenta, bool compartido, int descuentomonto, bool hayDescuento, double total, List<dynamic> loterias, List<dynamic> jugadas, int idUsuario, int idBanca, GlobalKey<ScaffoldState> scaffoldKey}) async {
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


    var response = await http.post(Uri.parse(Utils.URL +"/api/principal/guardar"), body: json.encode(map2), headers: Utils.header);
    int statusCode = response.statusCode;
    if(statusCode < 200 || statusCode > 400){
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldKey);
      throw Exception("Error servidor ticketService guardar");
    }

    var parsed = await compute(Utils.parseDatos, response.body);

     if(parsed["errores"] == 1){
      print("Principal parsedDatos: ${parsed}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: (parsed["mensaje"] != null) ? parsed["mensaje"] : parsed["\@SQLMessage"] != null ? parsed["\@SQLMessage"] : "Error", title: "Error");
      else
        Utils.showSnackBar(scaffoldKey: scaffoldKey, content: (parsed["mensaje"] != null) ? parsed["mensaje"] : parsed["@SQLMessage"] != null ? parsed["@SQLMessage"] : "Error");
      throw Exception("Error ticketService guardar: ${parsed}");
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
    print("TicketService INdexPost servidor: ${map["servidor"]} ");
    var response = await http.post(Uri.parse(Utils.URL +"/api/principal/indexPost"), body: json.encode(map2), headers: Utils.header);
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

  


    static Future<Map<String, dynamic>> guardarV2({@required BuildContext context, Usuario usuario, Sale sale, List<Salesdetails> listSalesdetails, String codigoBarra, List<int> idLoterias, List<int> idLoteriasSuperpale, scaffoldKey,}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["usuario"] = await Db.idUsuario();
    map["sale"] = sale.toJson();
    map["salesdetails"] = Salesdetails.salesdetailsToJson(listSalesdetails);
    map["codigoBarra"] = codigoBarra;
    map["idLoterias"] = idLoterias;
    map["idLoteriasSuperpale"] = idLoteriasSuperpale;
    map["servidor"] = await Db.servidor();
    var jwt = await Utils.createJwt(map);
    print("TicketService guardarV2: ${map["idLoterias"]}");
    print("TicketService guardarV2 idLoteriasSuperpale: ${map["idLoteriasSuperpale"]}");

    // await MyFileManager().writeCounter(map);

    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : jwt
    };

    var response = await http.post(Uri.parse(Utils.URL + "/api/principal/storeMobileV4"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("GrupoService guardar: ${response.body}");
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

    return parsed;
  }

    static Future<Map<String, dynamic>> guardarV4Gzip({@required BuildContext context, Usuario usuario, Sale sale, List<Salesdetails> listSalesdetails, String codigoBarra, List<int> idLoterias, List<int> idLoteriasSuperpale, scaffoldKey,}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["usuario"] = await Db.idUsuario();
    map["sale"] = sale.toJson();
    map["salesdetails"] = Salesdetails.salesdetailsToJson(listSalesdetails);
    map["codigoBarra"] = codigoBarra;
    map["idLoterias"] = idLoterias;
    map["idLoteriasSuperpale"] = idLoteriasSuperpale;
    map["servidor"] = await Db.servidor();
    var jwt = kIsWeb ? await Utils.createJwt(map) : null;
    print("TicketService guardarV2: ${map["idLoterias"]}");
    print("TicketService guardarV2 idLoteriasSuperpale: ${map["idLoteriasSuperpale"]}");

    // await MyFileManager().writeCounter(map);

    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : kIsWeb ? jwt : MyFileManager.compress(json.encode(map)),
      "esGzip" : !kIsWeb
    };

    var response = await http.post(Uri.parse(Utils.URL + "/api/principal/storeMobileV4"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("GrupoService guardar: ${response.body}");
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

    return parsed;
  }

    static Future<Map<String, dynamic>> guardarGzipV2({@required BuildContext context, Usuario usuario, Sale sale, List<Salesdetails> listSalesdetails, String codigoBarra, List<int> idLoterias, List<int> idLoteriasSuperpale, scaffoldKey,}) async {
    var map = Map<String, dynamic>();
    var mapDatos = Map<String, dynamic>();

    map["usuario"] = await Db.idUsuario();
    map["sale"] = sale.toJson();
    map["salesdetails"] = Salesdetails.salesdetailsToJson(listSalesdetails);
    map["codigoBarra"] = codigoBarra;
    map["idLoterias"] = idLoterias;
    map["idLoteriasSuperpale"] = idLoteriasSuperpale;
    map["servidor"] = await Db.servidor();
    // var jwt = await Utils.createJwt(map);
    print("TicketService guardarV2: ${map["idLoterias"]}");
    print("TicketService guardarV2 idLoteriasSuperpale: ${map["idLoteriasSuperpale"]}");

    // await MyFileManager().writeCounter(map);

    // mapDatos["datos"] = jwt;
    mapDatos = {
      "datos" : MyFileManager.compress(json.encode(map))
    };

    var response = await http.post(Uri.parse(Utils.URL + "/api/principal/storeMobileGzipV3"), body: json.encode(mapDatos), headers: Utils.header);
    int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode > 400){
      print("GrupoService guardar: ${response.body}");
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
      print("TicketServidor guardarGzipV2: $parsed");
      throw Exception("${parsed["mensaje"]}");
    }

    return parsed;
  }


  static Future<void> showDialogJugadasSinMontoDisponible(BuildContext context, FutureOr<List<Jugada>> Function() function, {dynamic title = "Error monto", bool isDeleteDialog = false, Function okFuncion, Widget okButton}) async {
    Future<List<Jugada>> future;
    await showDialog(
      context: context, 
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {

            Widget _circularProgressIndicator(){
              return Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator()));
            }
            
            future = Future.delayed(Duration(milliseconds: 1), () => function());

            return MyAlertDialog(
              title: title, 
              isDeleteDialog: isDeleteDialog,
              deleteDescripcion: "Ok",
              xlarge: 6,
              large: 6,
              content: FutureBuilder<List<Jugada>>(
                future: future,
                builder: (context, snapshot) {
                  if(snapshot.connectionState != ConnectionState.done)
                    return _circularProgressIndicator();
                  else if(snapshot.data == null)
                    return _circularProgressIndicator();
                  else if(snapshot.data.length == 0)
                    return _circularProgressIndicator();

                  return Column(
                    children: [
                      // Text("No hay monto disponible para las siguientes jugadas: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey), softWrap: true,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: MyDescripcon(title: "No hay monto disponible para las siguientes jugadas: "),
                      ),
                      MyTable(
                        columns: ["Jugada", "Loteria"], 
                        rows: snapshot.data.map((e) => [e, Center(child: Principal.buildRichOrTextAndConvertJugadaToLegible(e.jugada)), "${Loteria.getDescripcion(e.loteria, loteriaSuperpale: e.loteriaSuperPale)}"]).toList()
                      ),
                      // Column(children: snapshot.data.map((e) => Row(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(right: 8.0),
                      //       child: Text("${Loteria.getDescripcion(e.loteria, loteriaSuperpale: e.loteriaSuperPale)}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      //     ),
                          
                      //   ]
                      // )).toList(),)
                    ]
                  );
                }
              ), 
              okFunction: okFuncion,
              okButton: okButton,
            );
          }
        );
      }
    );

  }

  static String agregarUrlActualALaRutaDelTicket(String rutaTicket){
    return "${Utils.URL}/$rutaTicket";
  }
}