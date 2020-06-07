import 'dart:io';
import 'dart:ui';

import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/database.dart';
import 'dart:convert';

import 'package:loterias/core/classes/singleton.dart';

class  Utils {
  // static final String URL = 'http://127.0.0.1:8000';
  // static final String URL_SOCKET = 'http://192.168.43.63:3000';
  // static final String URL = 'https://pruebass.ml';
  // static final String SOCKET_ROOM = "pruebass";


  static final String URL = 'https://loteriasdo.tk/';
  static final String SOCKET_ROOM = "valentin";
  static final String URL_SOCKET = "http://pruebass.ml:3000";

  // static final String URL = 'https://loteriasdo.ga';
  // static final String SOCKET_ROOM = "emilio";
  // static final String URL_SOCKET = "http://pruebass.ml:3000";

  // static final String URL_SOCKET = URL.replaceFirst("https", "http") + ":3000";
  // static final String URL_SOCKET = "http://pruebass.ml:3000";
  static const Map<String, String> header = {
      // 'Content-type': 'application/json',
    HttpHeaders.contentTypeHeader: 'application/json',
    'Accept': 'application/json',
  };

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Map<int, Color> color =
  {
    50:Color.fromRGBO(9,144,208, .1),
    100:Color.fromRGBO(9,144,208, .2),
    200:Color.fromRGBO(9,144,208, .3),
    300:Color.fromRGBO(9,144,208, .4),
    400:Color.fromRGBO(9,144,208, .5),
    500:Color.fromRGBO(9,144,208, .6),
    600:Color.fromRGBO(9,144,208, .7),
    700:Color.fromRGBO(9,144,208, .8),
    800:Color.fromRGBO(9,144,208, .9),
    900:Color.fromRGBO(9,144,208, 1),
  };

  static MaterialColor colorMaterialCustom = MaterialColor(0xFF0990D0, Utils.color);
  static Color colorPrimary = fromHex("#38B6FF");
  static Color colorInfo = fromHex("#00bcd4");
  static Color colorInfoClaro = fromHex("4D00BCD4");
  static Color colorRosa = fromHex("#ffcccc");
  static Color colorGris = fromHex("#eae9e9");

  //Este color es el elegido por Mi fanola
  // static Color colorPrimary = fromHex("#68D5D8");
  // static MaterialColor colorMaterialCustom = MaterialColor(0xFF68D5D8, Utils.color);

  
  static esDouble(String caracter){
    try {
       double.parse(caracter);
       return true;
    } catch (e) {
      return false;
    }
  }

  static toDouble(String caracter){
    try {
       return double.parse(caracter);
    } catch (e) {
      return 0.0;
    }
  }

  static isNumber(String caracter){
    try {
      double.parse(caracter);
      return true;
    } catch (e) {
      return false;
    }
  }

  static double redondear(numero, decimales){
    return double.parse((numero).toStringAsFixed(decimales));
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
  }

  static String toBase64(var string){
    return base64.encode(utf8.encode(string)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    // String encoded = base64.encode(utf8.encode(string)); // dXNlcm5hbWU6cGFzc3dvcmQ=
    // String decoded = utf8.decode(base64.decode(encoded));   
  }

  static List<int> toUtf8(String string){
    return utf8.encode(string); 
  }

  static Map<String, dynamic> parseDatos(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    // print('utils.parseDatos: $responseBody');
    return parsed;
    // parsed['bancas'].map<Banca>((json) => Banca.fromMap(json)).toList();
    // return parsed.map<Banca>((json) => Banca.fromMap(json)).toList();
    // return true;
  }

  static Map<String, dynamic> parseDatosDynamic(dynamic responseBodyDynamic) {
    final parsed = responseBodyDynamic.cast<String, dynamic>();
    return parsed;
  }

  static Future<bool> exiseImpresora() async{
    var c = await DB.create();
    var impresora = await c.getValue('printer');
    if(impresora != null){
      return true;
    }

    return false;
  }

  static String toSecuencia(String codigoBanca, BigInt idTicket, [bool mostrarCodigoBanca = true]){
    String pad = "000000000";
    if(mostrarCodigoBanca)
      return codigoBanca + "-" + pad.substring(0, pad.length - idTicket.toString().length) + idTicket.toString();
    else
      return pad.substring(0, pad.length - idTicket.toString().length) + idTicket.toString();
  }

  static String toDosDigitos(String value){
    String pad = "00";
    
    return pad.substring(0, pad.length - value.toString().length) + value.toString();
  }

  static Future<String> esSorteoPickQuitarUltimoCaracter(String jugada, idSorteo) async {
    var query = await Db.database.query('Draws', columns: ['descripcion'], where:'"id" = ?', whereArgs: [idSorteo]);
    String sorteo = (query.isEmpty != true) ? query.first['descripcion'] : '';
    if(sorteo == 'Pick 3 Box' || sorteo == 'Pick 4 Straight' || sorteo == 'Pick 4 Box')
      jugada = jugada.substring(0, jugada.length - 1);
    
    return jugada;
  }

  static Future<String> esSorteoPickAgregarUltimoCaracter(String jugada, String sorteo, [int idSorteo]) async {
    if(idSorteo != null){
      var query = await Db.database.query('Draws', columns: ['descripcion'], where:'"id" = ?', whereArgs: [idSorteo]);
      sorteo = (query.isEmpty != true) ? query.first['descripcion'] : '';
    }
    
    if(sorteo == 'Pick 3 Box' || sorteo == 'Pick 4 Box')
      jugada = jugada + "B";
    else if(sorteo == 'Pick 3 Straight' || sorteo == 'Pick 4 Straight')
      jugada = jugada + "S";
    
    return jugada;
  }

  static Future<String> esSorteoPickAgregarUltimoSigno(String jugada, String sorteo, [int idSorteo]) async {
    if(idSorteo != null){
      var query = await Db.database.query('Draws', columns: ['descripcion'], where:'"id" = ?', whereArgs: [idSorteo]);
      sorteo = (query.isEmpty != true) ? query.first['descripcion'] : '';
    }
    
    if(sorteo == 'Pick 3 Box' || sorteo == 'Pick 4 Box')
      jugada = jugada + "+";
    else if(sorteo == 'Pick 4 Straight')
      jugada = jugada + "-";
    
    return jugada;
  }

  static String agregarSignoYletrasParaImprimir(String jugada, String sorteo){
    switch(sorteo){
      case "Pale":
        return jugada.substring(0, 2) + '-' + jugada.substring(2, 4);
        break;
      case "Pick 3 Box":
        return jugada + "B";
        break;
      case "Pick 4 Box":
        return jugada + "B";
        break;
      case "Pick 3 Straight":
        return jugada + "S";
        break;
      case "Pick 4 Straight":
        return jugada + "S";
        break;
      case "Tripleta":
        return jugada.substring(0, 2) + '-' + jugada.substring(2, 4) + '-' + jugada.substring(4, 6);
        break;
      default:
        return jugada;
        break;
    }
  }


 static showSnackBar({String content, scaffoldKey}){
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(content),
        elevation: 25,
        action: SnackBarAction(label: 'CERRAR', onPressed: () => scaffoldKey.currentState.hideCurrentSnackBar(),),
      ));
  }

  static showAlertDialog({String content, String title, BuildContext context}){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  static Color colorGanadorPerdedorPendiente(int status, double premio){
    if(status == 1 && premio <= 0)
      return Utils.colorRosa;
    else if(status == 1 && premio > 0)
      return Utils.colorInfo;
    else
      return Colors.grey;
  }

  static Color colorGreyFromPairIndex({int idx}){
    if(idx % 2 != 0)
      return colorGris;
    else
      return Colors.transparent;
  }

  static String createJwt(Map<String, dynamic> data){
    var builder = new JWTBuilder();
    var token = builder
      // ..issuer = 'https://api.foobar.com'
      // ..expiresAt = new DateTime.now().add(new Duration(minutes: 1))
      ..setClaim('data', 
      // {'id': 836, 'username' : "john.doe"}
      data
      )
      ..getToken(); // returns token without signature

    var signer = new JWTHmacSha256Signer('culo');
    var signedToken = builder.getSignedToken(signer);
    print(signedToken); // prints encoded JWT
    var stringToken = signedToken.toString();

    return stringToken;
  }

  static String ordenarMenorAMayor(String jugada){
    if(jugada.length != 4)
      return jugada;

    if(!Utils.isNumber(jugada))
      return jugada;

    String primerParNumeros = jugada.substring(0, 2);
    String segundoParNumeros = jugada.substring(2, 4);

    if(Utils.toDouble(primerParNumeros) < Utils.toDouble(segundoParNumeros))
      return jugada;
    else{
      jugada = segundoParNumeros + primerParNumeros;
      return jugada;
    }
  }
  
}