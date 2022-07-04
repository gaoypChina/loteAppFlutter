import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

// import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jose/jose.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/screensize.dart';
import 'dart:convert';

import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/services/sorteoservice.dart';
import 'package:timezone/timezone.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class  Utils {
  // static final String URL = 'http://127.0.0.1:8000/';
  // static final String URL_SOCKET = 'http://127.0.0.1:3000';
  // static final String URL = 'http://192.168.1.37:8000';
  // static final String URL_SOCKET = 'http://192.168.1.37:3000';
  // static final String URL = 'http://sislote.test/';
  // static final String URL_SOCKET = 'http://sislote.test:3000';
  // static final String URL_SOCKET = 'http://192.168.43.63:3000';
  // static final String URL_SOCKET = 'http://148.255.160.175:3000';
  // static final String URL = 'https://pruebass.ml';
  // static final String URL = 'http://127.0.0.1:8000';

  // static final String URL = 'https://loteriasdo.gq';
  // static final String URL_SOCKET = URL.replaceFirst("https", "http") + ":3000";

  static final String URL = 'https://server.loteriasdo.gq';
  static final String URL_SOCKET = URL + ":8000";

  // static final String URL = 'https://lote-app.com';
  // static final String URL_SOCKET = URL + ":8000";
  
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

  static double toDouble(dynamic caracter, {bool returnNullIfNotDouble = false}){
    try {
      if(caracter == null){
        if(returnNullIfNotDouble)
          return null;
        else
          caracter = "0";
      }
      if(!(caracter is String) && caracter != null)
       return double.parse(caracter.toString().replaceAll(",", ''));
      

       return double.parse(caracter.replaceAll(",", ''));
    } catch (e) {

      return returnNullIfNotDouble ? null : 0.0;
    }
  }
  static toInt(dynamic caracter, {bool returnNullIfNotInt = false}){
    try {
      if(!(caracter is String) && caracter != null)
       return int.parse(caracter.toString());

      return int.parse(caracter);
    } catch (e) {
      return returnNullIfNotInt ? null : 0;
    }
  }

  static isNumber(dynamic caracter){
    try {
      if(caracter == null)
        return;

      double.parse(caracter.toString());
      return true;
    } catch (e) {
      print("Utils isNumber error: ${e.toString()}");
      return false;
    }
  }

  static double redondear(numero, [decimales = 2]){
    // print("Utils. redondear: $numero ${double.parse((numero).toStringAsFixed(decimales))}");
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
  

  static parsedToJsonOrNot(dynamic responseBody) {
    // return (responseBody is String) ? json.decode(responseBody).cast<String, dynamic>() : responseBody;
    return (responseBody is String) ? jsonDecode(responseBody) : responseBody;
  }

  static Map<String, dynamic> parseDatosDynamic(dynamic responseBodyDynamic) {
    final parsed = responseBodyDynamic.cast<String, dynamic>();
    return parsed;
  }

  static Future<bool> exiseImpresora() async{
    var c = await DB.create();
    var impresora = await c.getValue('printer');
    if(impresora == null)
      return false;

    if(impresora.isEmpty)
      return false;

    return true;
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

  static Future<String> esSorteoPickQuitarUltimoCaracter(String jugada, idSorteo, [var transaction]) async {
    var query;
    if(transaction == null)
      // query = await Db.database.query('Draws', columns: ['descripcion'], where:'"id" = ?', whereArgs: [idSorteo]);
      query = await Db.drawById(idSorteo);
    // else
    //   query = await transaction.query('Draws', columns: ['descripcion'], where:'"id" = ?', whereArgs: [idSorteo]);
    String sorteo = (query != null) ? query['descripcion'] : '';
    if(sorteo == 'Pick 3 Box' || sorteo == 'Pick 4 Straight' || sorteo == 'Pick 4 Box'  || sorteo == 'Super pale')
      jugada = jugada.substring(0, jugada.length - 1);
    
    return jugada;
  }

  static bool esSuperpale(String jugada){
    print("Utils esSuperpale length: ${jugada.length}");
    print("Utils esSuperpale substring: ${jugada.substring(jugada.length - 1)}");
    print("Utils esSuperpale isNumber: ${Utils.isNumber(jugada.substring(0, jugada.length - 1))}");
    return (jugada.length == 5 && jugada.substring(jugada.length - 1) == "s" && Utils.isNumber(jugada.substring(0, jugada.length - 1)));
  }

  static Future<String> esSorteoPickAgregarUltimoCaracter(String jugada, String sorteo, [int idSorteo]) async {
    if(idSorteo != null){
      // var query = await Db.database.query('Draws', columns: ['descripcion'], where:'"id" = ?', whereArgs: [idSorteo]);
      var query = await Db.drawById(idSorteo);
      sorteo = (query != null) ? query['descripcion'] : '';
    }
    
    if(sorteo == 'Pick 3 Box' || sorteo == 'Pick 4 Box')
      jugada = jugada + "B";
    else if(sorteo == 'Pick 3 Straight' || sorteo == 'Pick 4 Straight')
      jugada = jugada + "S";
    
    return jugada;
  }

  static Future<String> esSorteoPickOSuperpaleAgregarUltimoSigno(String jugada, String sorteo, [int idSorteo]) async {
    if(idSorteo != null){
      // var query = await Db.database.query('Draws', columns: ['descripcion'], where:'"id" = ?', whereArgs: [idSorteo]);
      var query = await Db.drawById(idSorteo);
      sorteo = (query != null) ? query['descripcion'] : '';
    }
    
    if(sorteo == 'Pick 3 Box' || sorteo == 'Pick 4 Box')
      jugada = jugada + "+";
    else if(sorteo == 'Pick 4 Straight')
      jugada = jugada + "-";
    else if(sorteo == 'Super pale')
      jugada = jugada + "s";
    
    return jugada;
  }

  static String sorteoToDosLetras(String sorteo){
    var arraySorteoSeparadoPorEspacios = sorteo.split(" ");
    String dosLetras = (arraySorteoSeparadoPorEspacios.length > 1) ? arraySorteoSeparadoPorEspacios[0].substring(0, 1) + arraySorteoSeparadoPorEspacios[1].substring(0, 1) : arraySorteoSeparadoPorEspacios[0].substring(0, 1) + arraySorteoSeparadoPorEspacios[0].substring(1, 2);
    dosLetras = dosLetras.toUpperCase();
    if(dosLetras == "DI")
      dosLetras = "QU";

    return dosLetras;
  }

  static String agregarSignoYletrasParaImprimir(String jugada, String sorteo, [bool quitarGuionPaleTripleta = false]){
    String jugadaTmp = jugada.replaceFirst("-", "");
    jugadaTmp = jugadaTmp.replaceFirst("+", "");
    jugadaTmp = jugadaTmp.toUpperCase().replaceFirst("s", "");

    switch(sorteo){
      case "Pale":
      if(quitarGuionPaleTripleta)
          return jugadaTmp;
        return jugadaTmp.substring(0, 2) + '-' + jugadaTmp.substring(2, 4);
        break;
      case "Pick 3 Box":
        return jugadaTmp + "B";
        break;
      case "Pick 4 Box":
        return jugadaTmp + "B";
        break;
      case "Pick 3 Straight":
        return jugadaTmp + "S";
        break;
      case "Pick 4 Straight":
        return jugadaTmp + "S";
        break;
      case "Tripleta":
        if(quitarGuionPaleTripleta)
          return jugadaTmp;
        return jugadaTmp.substring(0, 2) + '-' + jugadaTmp.substring(2, 4) + '-' + jugadaTmp.substring(4, 6);
        break;
      default:
        return jugadaTmp;
        break;
    }
  }


 static showSnackBar({String content, scaffoldKey}){
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${content != null ? content : ''}",),
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
          content: SingleChildScrollView(child: SelectableText(content)),
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

  static removeDuplicateJugadasFromList(List<Jugada> lista){
    // print("BEFORE DELETE");
    final ids = lista.map((e) => e.jugada).toSet();
    lista.retainWhere((x) => ids.remove(x.jugada));
    // print("AFTER DELETE");
    return lista;
  }

  static List removeDuplicateLoteriasFromList(List lista){
    // print("BEFORE DELETE");
    final ids = lista.map((e) => e.idLoteria).toSet();
    lista.retainWhere((x) => ids.remove(x.idLoteria));
    // print("AFTER DELETE");
    return lista;
  }

  static List removeDuplicateLoteriasSuperPaleFromList(List lista, [int idLoteria]){
    // print("BEFORE DELETE");
    // var listaSuperpale = lista.where((element) => element.idLoteriaSuperpale != 0 && element.idLoteriaSuperpale != null).toList();
    var listaSuperpale = idLoteria != null ? lista.where((element) => element.idSorteo == 4 && element.idLoteria == idLoteria).toList() : lista.where((element) => element.idSorteo == 4).toList();
    print("removeDuplicateLoteriasSuperPaleFromList listaSUperpale lenght: ${listaSuperpale.length}");
    if(listaSuperpale.length == 0)
      return [];

    //Convertimos el idLoteria y idLoteriaSuperPale en una lista dynamic y luego convertimos la lista en String,
    //para que asi la function toSet puede eliminar las listas dynamic repetidas
    final ids = listaSuperpale.map((e) => [e.idLoteria, e.idLoteriaSuperpale].toString()).toSet();

    //Entonces ahora eliminamos las listas dynamic de loterias que no esten en la variable 'ids'
    listaSuperpale.retainWhere((x) => ids.remove([x.idLoteria, x.idLoteriaSuperpale].toString()));
    // print("AFTER DELETE");
    return listaSuperpale;
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

  // static Future<String> createJwt(Map<String, dynamic> data) async {
  //   var builder = new JWTBuilder();
  //   var token = builder
  //     // ..issuer = 'https://api.foobar.com'
  //     // ..expiresAt = new DateTime.now().add(new Duration(minutes: 1))
  //     ..setClaim('datosMovil', 
  //     // {'id': 836, 'username' : "john.doe"}
  //     data
  //     )
  //     ..getToken(); // returns token without signature

  //   // var signer = new JWTHmacSha256Signer('culo');
  //   var c = await DB.create();
  //   var apiKey = await c.getValue("apiKey");
  //   print("Before error: $apiKey");
  //   var signer = new JWTHmacSha256Signer(await c.getValue("apiKey"));
  //   var signedToken = builder.getSignedToken(signer);
  //   //print(signedToken); // prints encoded JWT
  //   var stringToken = signedToken.toString();

  //   return stringToken;
  // }
  // 
  static Future<String> createJwt(Map<String, dynamic> data) async {
    
    
    // create a builder
  var builder = JsonWebSignatureBuilder();

  // set the content
  builder.stringContent = 'It is me';
  builder.jsonContent = {"datosMovil" : data};

  // set some protected header
  // builder.setProtectedHeader('createdAt', DateTime.now().toIso8601String());

  // add a key to sign, you can add multiple keys for different recipients
  var c = await DB.create();
  builder.addRecipient(
      JsonWebKey.fromJson({
        'kty': 'oct',
        'k': Utils.toBase64(await c.getValue("apiKey"))
      }),
      algorithm: 'HS256');

  // build the jws
  var jws = builder.build();

  // output the compact serialization
  // print('jws compact serialization: ${jws.toCompactSerialization()}');

  // output the json serialization
  // print('jws json serialization: ${jws.toJson()}');
  return jws.toCompactSerialization();
  }

 static String base64Urlencode(String secret) {
    var stringToBase64Url = utf8.fuse(base64Url);
    return stringToBase64Url.encode(secret);
  }

  static Future<String> createJwtForSocket({@required Map<String, dynamic> data, @required key}) async {
  
  
     // create a builder
  var builder = JsonWebSignatureBuilder();

  // set the content
  builder.stringContent = 'It is me';
  builder.jsonContent = {"data" : data};

  // set some protected header
  // builder.setProtectedHeader('createdAt', DateTime.now().toIso8601String());

  // add a key to sign, you can add multiple keys for different recipients
  if(key == null){
    var c = await DB.create();
    key = await c.getValue("apiKey");
  }
  

  builder.addRecipient(
    // JsonWebKey.fromPem(key),
      JsonWebKey.fromJson({
        'kty': 'oct',
        'k': base64Urlencode('$key')
      }),
      algorithm: 'HS256');

  // build the jws
  var jws = builder.build();

  // output the compact serialization
  // print('jws compact serialization: ${jws.toCompactSerialization()}');

  // output the json serialization
  // print('jws json serialization: ${jws.toJson()}');
  return jws.toCompactSerialization();
  }


  static Future<String> createJwtForTest(Map<String, dynamic> data) async {
    // var builder = new JWTBuilder();
    // var token = builder
    //   // ..issuer = 'https://api.foobar.com'
    //   // ..expiresAt = new DateTime.now().add(new Duration(minutes: 1))
    //   ..setClaim('datosMovil', 
    //   // {'id': 836, 'username' : "john.doe"}
    //   data
    //   )
    //   ..getToken(); // returns token without signature

    // // var signer = new JWTHmacSha256Signer('culo');
    // // var c = await DB.create();
    // // var apiKey = await c.getValue("apiKey");
    // // print("Before error: $apiKey");
    // // var signer = new JWTHmacSha256Signer(await c.getValue("apiKey"));
    // var signer = new JWTHmacSha256Signer("7g654GPrRCrZPbJTiuDtELvaY1WJlHz2");
    // var signedToken = builder.getSignedToken(signer);
    // //print(signedToken); // prints encoded JWT
    // var stringToken = signedToken.toString();

    // return stringToken;
    

    var builder = JsonWebSignatureBuilder();

  // set the content
  builder.stringContent = 'It is me';
  builder.jsonContent = {"datosMovil" : data};

  // set some protected header
  // builder.setProtectedHeader('createdAt', DateTime.now().toIso8601String());

  // add a key to sign, you can add multiple keys for different recipients
  // var c = await DB.create();
  builder.addRecipient(
      JsonWebKey.fromJson({
        'kty': 'oct',
        'k': Utils.toBase64("7g654GPrRCrZPbJTiuDtELvaY1WJlHz2")
      }),
      algorithm: 'HS256');

  // build the jws
  var jws = builder.build();

  // output the compact serialization
  // print('jws compact serialization: ${jws.toCompactSerialization()}');

  // output the json serialization
  // print('jws json serialization: ${jws.toJson()}');
  return jws.toCompactSerialization();
  }



  static String ordenarMenorAMayor(String jugada){
    if(jugada.length == 4){
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
    else if(jugada.length == 5 && jugada.substring(jugada.length - 1) == "s"){
      if(!Utils.isNumber(jugada.substring(0, jugada.length - 1)))
        return jugada;

      String ultimoCaracter = jugada.substring(jugada.length - 1);
      String primerParNumeros = jugada.substring(0, 2);
      String segundoParNumeros = jugada.substring(2, 4);

      if(Utils.toDouble(primerParNumeros) < Utils.toDouble(segundoParNumeros))
        return jugada;
      else{
        jugada = segundoParNumeros + primerParNumeros;
        return jugada + ultimoCaracter;
      }
    }
    else if(jugada.length == 6){
      if(!Utils.isNumber(jugada))
        return jugada;

      String primerParNumeros = jugada.substring(0, 2);
      String segundoParNumeros = jugada.substring(2, 4);
      String tercerParNumeros = jugada.substring(4, 6);

      List<String> list = [];
      list.addAll([primerParNumeros, segundoParNumeros, tercerParNumeros]);
      for(int i=0; i < list.length ; i++){
        for(int i2 = i + 1; i2 < list.length; i2++){
          if(double.parse(list[i]) > double.parse(list[i2])){
            var tmpMayor = list[i];
            list[i] = list[i2];
            list[i2] = tmpMayor;
          }
        }
      }
      return list.join("");
    }

    return jugada;
  }

  static List<String> generarCombinaciones(String jugada){
    List<String> listaJugada = List();
    
    //anadimos la primera jugada
    listaJugada.add(jugada);

    //generamos las combinaciones
    // print("utils generamos las combinaciones: ${jugada.length} - ${invertirJugada(jugada)}");
    switch (jugada.length) {
      case 2:
        listaJugada.add(invertirJugada(jugada));
    // print("utils generamos las combinaciones: ${jugada.length} - ${invertirJugada(jugada)}");

        break;
      case 4:
        //invertimos la primera jugada
        listaJugada.add(invertirJugada(jugada.substring(0, 2)) + jugada.substring(2, 4));
        //invertimos la segunda jugada
        listaJugada.add(jugada.substring(0, 2) + invertirJugada(jugada.substring(2, 4)));
        //invertimos las dos jugadas
        listaJugada.add(invertirJugada(jugada.substring(0, 2)) + invertirJugada(jugada.substring(2, 4)));
        break;
      case 6:
        //invertimos la primera jugada
        listaJugada.add(invertirJugada(jugada.substring(0, 2)) + jugada.substring(2, 4) + jugada.substring(4, 6));
        //invertimos la segunda jugada
        listaJugada.add(jugada.substring(0, 2) + invertirJugada(jugada.substring(2, 4)) + jugada.substring(4, 6));
        //invertimos la tercer jugada
        listaJugada.add(jugada.substring(0, 2) + jugada.substring(2, 4) + invertirJugada(jugada.substring(4, 6)));
        //invertimos todas las jugadas jugada
        listaJugada.add(invertirJugada(jugada.substring(0, 2)) + invertirJugada(jugada.substring(2, 4)) + invertirJugada(jugada.substring(4, 6)));
        //invertimos la primera y segunda jugada
        listaJugada.add(invertirJugada(jugada.substring(0, 2)) + invertirJugada(jugada.substring(2, 4)) + jugada.substring(4, 6));
        //invertimos la primera y tercer jugada
        listaJugada.add(invertirJugada(jugada.substring(0, 2)) + jugada.substring(2, 4) + invertirJugada(jugada.substring(4, 6)));
        //invertimos la segunda y tercer jugada
        listaJugada.add(jugada.substring(0, 2) + invertirJugada(jugada.substring(2, 4)) + invertirJugada(jugada.substring(4, 6)));
        break;
      default:
    }

    return listaJugada;
  }

  static String invertirJugada(String parDeNumeros){
    return parDeNumeros[1] + parDeNumeros[0];
  }

  static toCurrency(var number, [quitarSignoDolar = false, dejarCerosSoloSiElNumeroEsCero = false]){
    final formatCurrency = new NumberFormat.simpleCurrency();

    number = Utils.toDouble(number.toString());
    var data = formatCurrency.format(number);
    if(dejarCerosSoloSiElNumeroEsCero && data == '0.00')
      data = data.replaceFirst(".00", "");
    else
      data = data.replaceFirst(".00", "");


    return (quitarSignoDolar) ? data.replaceFirst("\$", "") : data;
  }

  // static toPrintCurrency(var number, [quitarSignoDolar = true, quitarDosCeros = true]){
  //   final formatCurrency = new NumberFormat.simpleCurrency();
  //   number = Utils.toDouble(number.toString());
  //   var data = formatCurrency.format(number);
  //   data = (quitarSignoDolar) ? data.replaceFirst("\$", "") : data;

  //   if(quitarDosCeros){
  //     // if(data.length == 6)
  //     //   data = data.replaceFirst(".00", ".0");
  //     // else if(data.length > 6)
  //       data = data.replaceFirst(".00", "");
  //   }
  //   // var data = formatCurrency.format(number);
  //   return data;
  // }

  static tieneDecimales(var number){
    return (number.toString().indexOf(".") != -1) ? true : false;
  }

  static quitarEspaciosAUnString({@required int tamanoString, @required int cantidadDeCaracteresAQuitar}){
        // print("tamano: $tamano - ${tamano.length} | jugadaOMonto: $jugadaOMonto - ${jugadaOMonto.length}");
        // print("tamanoFinal: ${tamano.substring(0, tamano.length - jugadaOMonto.length)} - ${tamano.substring(0, tamano.length - jugadaOMonto.length).length}");
   String string = "";
   //Creamos un string de espacios en blanco y su tamano sera igual a la variable tamanoString
   //Si la variable tamanoString = 3 entonces la variable string tendra como valor 3 espacios
   for(int i=0; i < tamanoString; i++)
    string += " ";
   return string.substring(0, tamanoString - cantidadDeCaracteresAQuitar);
  }

  static diasDelMes(DateTime fecha){
    return DateTime(fecha.year, fecha.month + 1, 0).day;
  }

  static bool isSmallOrMedium(double size){
    return (ScreenSize.isMedium(size) || ScreenSize.isSmall(size));
  }

  static int generateNumber(int min, int max){
    final _random = Random();
    return min + _random.nextInt(max - min);
  }

  static Container getWidgetUploadFoto(dynamic sucursal, {size: 130.0, radius: 10.0}) {
    if(sucursal.foto != null ){
      return Container(
          // color: Colors.blue,
          width: size,
          height: size,
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              // color: Colors.blue,
              child: Image.memory(sucursal.foto)
            ),
          ),
        );
      //  return Image.memory(await Utils.blobfileToUint(cliente.foto));
    }else if(sucursal.nombreFoto != null){
      return Container(
          // color: Colors.red,
          width: size,
          height: size,
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              child: FadeInImage(
                image: NetworkImage(
                    '${Utils.URL}/assets/perfil/${sucursal.nombreFoto}'),
                placeholder: AssetImage('assets/images/profile2.jpg'),
              )
            ),
          ),
        );
    }else{
      return Container(
          // color: Colors.red,
          width: size,
          height: size,
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              child: Image(image: AssetImage('assets/images/profile2.jpg'), )
            ),
          ),
        );
    }

    
    // return  Image(image: AssetImage('images/profile2.jpg'), );
  }

  static String dateTimeToDate(DateTime date, String hour){
    return (date == null) ? "" : "${date.year}-${Utils.toDosDigitos(date.month.toString())}-${Utils.toDosDigitos(date.day.toString())}${hour != null ? ' ' + hour : ''}";
  }

  static dateTimeToMilisenconds(DateTime date){
    return date.toUtc().millisecondsSinceEpoch;
  }

  static int getIdDiaActual(){
    DateTime fecha = DateTime.now();
    //para wday se usa este return (fecha.weekday == 7) ? 0 : fecha.weekday;
    //La propiedad weekday de la clase DateTime, empieza con el valor 1 que es lunes y termina con el valor 7 que es domingo
    //Entonces en la tabla Days en mi base de datos los dias empiezan desde el lunes id == 1 y terminan con el domingo id == 7
    //asi que La propiedad weekday es igual a los id de los dias de mi tabla Days, por eso cuando quiero el idDia de hoy pues simplemente
    //retorno La propiedad 
    return fecha.weekday;
  }

  static DateTime horaLoteriaToCurrentTimeZone(String hora, DateTime currentDateTime) {
    if(currentDateTime == null)
      return DateTime.now();
    var santoDomingo = getLocation('America/Santo_Domingo');
    var fechaActualRd = TZDateTime.from(currentDateTime, santoDomingo);
    var fechaLoteriaRD = DateTime.parse(fechaActualRd.year.toString() + "-" + Utils.toDosDigitos(fechaActualRd.month.toString())+ "-" + Utils.toDosDigitos(fechaActualRd.day.toString()) + " ${hora != null ? hora : '00:00'}");
    
    // Optenemos las diferencias en las horas, minutos y segundos de la fechaActualRD y de
    int horasASumar = (fechaLoteriaRD.hour - fechaActualRd.hour);
    int minutosASumar = (fechaLoteriaRD.minute - fechaActualRd.minute);
    int segundosARestar = fechaActualRd.second;
    
    TZDateTime fechaLoteriaConvertidaAFormatoRD;
    fechaLoteriaConvertidaAFormatoRD = fechaActualRd.add(Duration(hours: horasASumar, minutes: minutosASumar));
    fechaLoteriaConvertidaAFormatoRD = fechaLoteriaConvertidaAFormatoRD.subtract(Duration(seconds: segundosARestar));

    int horasASumarDeDiferenciaEntreLaHoraActualDeRDYCurrentDateTime = (currentDateTime.hour - fechaActualRd.hour);
    int minutosASumarDeDiferenciaEntreLaHoraActualDeRDYCurrentDateTime = (currentDateTime.minute - fechaActualRd.minute);
    segundosARestar = currentDateTime.second;
    var fechaLoteriaCurrentTimeZone = fechaLoteriaConvertidaAFormatoRD.add(Duration(hours: horasASumarDeDiferenciaEntreLaHoraActualDeRDYCurrentDateTime, minutes: minutosASumarDeDiferenciaEntreLaHoraActualDeRDYCurrentDateTime));
    fechaLoteriaCurrentTimeZone.subtract(Duration(seconds: segundosARestar));
    
    return fechaLoteriaCurrentTimeZone;
  }

  static DateTime dateTimeToCurrentTimeZoneExactDateTime(DateTime datetime, currentTimeZone) {
    if(currentTimeZone == null)
      return DateTime.now();
    var currentTimeZoneLocation = getLocation(currentTimeZone);

    var fechaActualCurrent = TZDateTime.now(currentTimeZoneLocation);

    return fechaActualCurrent;
  }

  static DateTime dateTimeToRD(DateTime fecha) {
    var santoDomingo = getLocation('America/Santo_Domingo');
    var fechaActualRd = TZDateTime.from(fecha, santoDomingo);
    
    return fechaActualRd;
  }


  static List<int> uint8ListToListIn(Uint8List uint8list){
    return new List.from(uint8list);
  }

  static jugadaFormatToJugada(String jugada){
   if(jugada.length == 4 && jugada.indexOf('+') == -1 && jugada.indexOf('-') == -1){
     return jugada.substring(0, 2) + '-' + jugada.substring(2, 4);
   }
   else if(jugada.length == 3){
     return "${jugada.substring(0, 3)}S";
   }
   else if(jugada.length == 4 && jugada.indexOf('+') != -1){
     return "${jugada.substring(0, 3)}B";
   }
   else if(jugada.length == 5 && jugada.indexOf('+') != -1){
     return "${jugada.substring(0, 4)}B";
   }
   else if(jugada.length == 5 && jugada.indexOf('-') != -1){
     return "${jugada.substring(0, 4)}S";
   }
  else if(jugada.length == 6){
     return jugada.substring(0, 2) + '-' + jugada.substring(2, 4) + '-' + jugada.substring(4, 6);
  }

   return jugada;
 }


 static toPrintCurrency(var number, [quitarSignoDolar = true, quitarDosCeros = true]){
    final formatCurrency = new NumberFormat.simpleCurrency();
    number = Utils.toDouble(number.toString());
    var data = formatCurrency.format(number);
    data = (quitarSignoDolar) ? data.replaceFirst("\$", "") : data;

    if(quitarDosCeros){
      // if(data.length == 6)
      //   data = data.replaceFirst(".00", ".0");
      // else if(data.length > 6)
        data = data.replaceFirst(".00", "");
    }
    // var data = formatCurrency.format(number);
    return data;
  }

  static isPar(int value){
    return (value % 2 != 0);
  }

  
  
 
 static DateTime getLastDayOfMonth(DateTime date){
    if(date == null)
    date = new DateTime.now();
    // Find the last day of the month.
    var lastDayDateTime = (date.month < 12) ? new DateTime(date.year, date.month + 1, 0) : new DateTime(date.year + 1, 1, 0);

    // print(lastDayDateTime.day); // 28 for February
    return lastDayDateTime;
  }

 static DateTime getNextMonth(DateTime date, {int dayOfTheMonth, int monthsToAdd = 1}){
    DateTime nextMonth;
    if(date.day > 28 && dayOfTheMonth == null){
      DateTime nextMonthFirstDay = new DateTime(date.year, date.month + monthsToAdd, 1);
      DateTime nextMonthLastDay = getLastDayOfMonth(nextMonthFirstDay);
      nextMonth = (date.day > nextMonthLastDay.day) ? nextMonthLastDay : new DateTime(date.year, date.month + monthsToAdd, date.day);
    }
    else if(date.day >= 28 && dayOfTheMonth != null){
      DateTime nextMonthFirstDay = new DateTime(date.year, date.month + monthsToAdd, 1);
      DateTime nextMonthLastDay = getLastDayOfMonth(nextMonthFirstDay);
      nextMonth = (dayOfTheMonth > nextMonthLastDay.day) ? nextMonthLastDay : new DateTime(date.year, date.month + monthsToAdd, dayOfTheMonth);
      print("Utils getNextMonth: ${nextMonth.day}");
    }
    else
      nextMonth = new DateTime(date.year, date.month + monthsToAdd, date.day);

    return nextMonth;
  }

  static DateTime getNextMonthV2(DateTime date, {int dayOfTheMonth, int monthsToAdd = 1}){
    DateTime nextMonth;
    if(date.day > 28 && dayOfTheMonth == null){
      DateTime nextMonthFirstDay = new DateTime(date.year, date.month + monthsToAdd, 1);
      DateTime nextMonthLastDay = getLastDayOfMonth(nextMonthFirstDay);
      nextMonth = (date.day > nextMonthLastDay.day) ? nextMonthLastDay : new DateTime(date.year, date.month + monthsToAdd, date.day);
    }
    else if(date.day >= 28 && dayOfTheMonth != null){
      DateTime nextMonthFirstDay = new DateTime(date.year, date.month + monthsToAdd, 1);
      DateTime nextMonthLastDay = getLastDayOfMonth(nextMonthFirstDay);
      nextMonth = (dayOfTheMonth > nextMonthLastDay.day) ? nextMonthLastDay : new DateTime(date.year, date.month + monthsToAdd, dayOfTheMonth);
      print("Utils getNextMonthV2: ${nextMonth.day}");
    }
    else
      nextMonth = new DateTime(date.year, date.month + monthsToAdd, dayOfTheMonth == null ? date.day : dayOfTheMonth);

    return nextMonth;
  }

  static DateTime getLastMonth(DateTime date, {int dayOfTheMonth, int monthsToSub = 1}){
    DateTime lastMonth;
    int subtractedMonth = date.month - monthsToSub;

    if(subtractedMonth <= 0)
      subtractedMonth = 12 - subtractedMonth.abs();

    if(date.day > 28 && dayOfTheMonth == null){
      DateTime lastMonthFirstDay = new DateTime(date.year, subtractedMonth, 1);
      DateTime lastMonthLastDay = getLastDayOfMonth(lastMonthFirstDay);
      lastMonth = (date.day > lastMonthLastDay.day) ? lastMonthLastDay : new DateTime(date.year, subtractedMonth, date.day);
    }
    else if(date.day >= 28 && dayOfTheMonth != null){
      DateTime lastMonthFirstDay = new DateTime(date.year, subtractedMonth, 1);
      DateTime lastMonthLastDay = getLastDayOfMonth(lastMonthFirstDay);
      lastMonth = (dayOfTheMonth > lastMonthLastDay.day) ? lastMonthLastDay : new DateTime(date.year, subtractedMonth, dayOfTheMonth);
      print("Utils getNextMonthV2: ${lastMonth.day}");
    }
    else if(dayOfTheMonth != null){
      DateTime lastMonthFirstDay = new DateTime(date.year, subtractedMonth, 1);
      DateTime lastMonthLastDay = getLastDayOfMonth(lastMonthFirstDay);
      lastMonth = (dayOfTheMonth > lastMonthLastDay.day) ? lastMonthLastDay : new DateTime(date.year, subtractedMonth, dayOfTheMonth);
      print("Utils getNextMonthV2: ${lastMonth.day}");
    }
    else
      lastMonth = new DateTime(date.year, subtractedMonth, dayOfTheMonth == null ? date.day : dayOfTheMonth);

    return lastMonth;
  }

  static int getIdDia(){
    DateTime fecha = DateTime.now();
    //para wday se usa este return (fecha.weekday == 7) ? 0 : fecha.weekday;
    //La propiedad weekday de la clase DateTime, empieza con el valor 1 que es lunes y termina con el valor 7 que es domingo
    //Entonces en la tabla Days en mi base de datos los dias empiezan desde el lunes id == 1 y terminan con el domingo id == 7
    //asi que La propiedad weekday es igual a los id de los dias de mi tabla Days, por eso cuando quiero el idDia de hoy pues simplemente
    //retorno La propiedad 
    return fecha.weekday;
  }



  static launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  static Future<bool> setMenuStatus({@required bool isOpen}) async{
    try {
      var c = await DB.create();
      await c.add('menu', isOpen);
      return true;
    } on Exception catch (e) {
      print("Utils.setMenuStatus: ${e.toString()}");
      return false;
    }
  }

  static Future<bool> menuIsOpen() async{
    var c = await DB.create();
    var menu = await c.getValue('menu');
    if(menu == null)
      return false;

    return true;
  }

  // static Future<void> subscribeToTopic() async{
  //   if(kIsWeb)
  //     return;
  //
  //   var tipoUsuario = (await (await DB.create()).getValue("tipoUsuario"));
  //   if(tipoUsuario == "Programador"){
  //     await FirebaseMessaging.instance.subscribeToTopic("programador");
  //   }
  //   else if(tipoUsuario == "Administrador"){
  //     await FirebaseMessaging.instance.subscribeToTopic(await Db.servidor());
  //   }
  // }

  // static Future<void> unSubscribeFromTopic() async{
  //   if(kIsWeb)
  //     return;
  //
  //   var tipoUsuario = (await (await DB.create()).getValue("tipoUsuario"));
  //   if(tipoUsuario == "Programador"){
  //     await FirebaseMessaging.instance.unsubscribeFromTopic("programador");
  //   }
  //   else if(tipoUsuario == "Administrador"){
  //     await FirebaseMessaging.instance.unsubscribeFromTopic(await Db.servidor());
  //   }
  // }
  

  static DateTimeRange getFechaProximoPago(Servidor servidor){
    DateTime _diaPago = servidor.diaPago != null ? MyDate.getDateFromDiaPago(servidor.diaPago) : null;
    // print("PagosScreen _agregarFechaProximoPago 2: ${_diaPago.day}");
    // _txtDiaPago.text = servidor.diaPago != null ? "${servidor.diaPago}" : null;
    DateTimeRange _fechaProximoPago = _diaPago != null ? DateTimeRange(start: _diaPago, end: Utils.getNextMonth(_diaPago)) : null;
    return _fechaProximoPago;
  }

  static showScaffoldMessanger(BuildContext context, String content,{ Color color = Colors.pink}){
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text("${content != null ? content : ''}", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        backgroundColor: color,
        // leading: const Icon(Icons.info),
        actions: [
          IconButton(onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(), 
          icon: Icon(Icons.clear, color: Colors.white))
        ]
      )
    );
  }

  static bool showLargeScreen(bool isSmallOrMedium){
    bool _showLargeScreen = false;
    if(isSmallOrMedium)
      _showLargeScreen = false;
    else {
      if(kIsWeb)
        return true;
        
      if(Platform.isWindows || kIsWeb)
        _showLargeScreen = true;
    }

    return _showLargeScreen;
  }

  static void makeRoutePage({BuildContext context, Widget pageRef}) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => pageRef),
        (Route<dynamic> route) => false);
  }

  static navigateToReporteGeneral(bool showDrawer){
    navigatorKey.currentState.pushReplacementNamed("/general", arguments: showDrawer);
  }
 
}