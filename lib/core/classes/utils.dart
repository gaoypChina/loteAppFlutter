import 'dart:io';
import 'dart:ui';

// import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jose/jose.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'dart:convert';

import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/models/jugadas.dart';

class  Utils {
  // static final String URL = 'http://127.0.0.1:8000';
  static final String URL_SOCKET = 'http://127.0.0.1:3000';
  // static final String URL_SOCKET = 'http://192.168.43.63:3000';
  // static final String URL_SOCKET = 'http://148.255.160.175:3000';
  // static final String URL = 'https://pruebass.ml';
  static final String URL = 'http://127.0.0.1:8000';

  // static final String URL = 'https://loteriasdo.gq';
  // static final String URL_SOCKET = URL.replaceFirst("https", "http") + ":3000";
  
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
  static toInt(String caracter){
    try {
       return int.parse(caracter);
    } catch (e) {
      return 0;
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

  static double redondear(numero, [decimales = 2]){
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

  static Map<String, dynamic> parsedToJsonOrNot(dynamic responseBody) {
    return (responseBody is String) ? json.decode(responseBody).cast<String, dynamic>() : responseBody;
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

  static bool esSuperpale(String jugada){
    print("Utils esSuperpale length: ${jugada.length}");
    print("Utils esSuperpale substring: ${jugada.substring(jugada.length - 1)}");
    print("Utils esSuperpale isNumber: ${Utils.isNumber(jugada.substring(0, jugada.length - 1))}");
    return (jugada.length == 5 && jugada.substring(jugada.length - 1) == "s" && Utils.isNumber(jugada.substring(0, jugada.length - 1)));
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

  static Future<String> esSorteoPickOSuperpaleAgregarUltimoSigno(String jugada, String sorteo, [int idSorteo]) async {
    if(idSorteo != null){
      var query = await Db.database.query('Draws', columns: ['descripcion'], where:'"id" = ?', whereArgs: [idSorteo]);
      sorteo = (query.isEmpty != true) ? query.first['descripcion'] : '';
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
    switch(sorteo){
      case "Pale":
      if(quitarGuionPaleTripleta)
          return jugada;
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
        if(quitarGuionPaleTripleta)
          return jugada;
        return jugada.substring(0, 2) + '-' + jugada.substring(2, 4) + '-' + jugada.substring(4, 6);
        break;
      default:
        return jugada;
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

  static removeDuplicateJugadasFromList(List<Jugada> lista){
  // print("BEFORE DELETE");
  for(var l in lista)
     print(l);
  final ids = lista.map((e) => e.jugada).toSet();
  lista.retainWhere((x) => ids.remove(x.jugada));
  // print("AFTER DELETE");
  return lista;
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
  print('jws compact serialization: ${jws.toCompactSerialization()}');

  // output the json serialization
  print('jws json serialization: ${jws.toJson()}');
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
  print('jws compact serialization: ${jws.toCompactSerialization()}');

  // output the json serialization
  print('jws json serialization: ${jws.toJson()}');
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
  print('jws compact serialization: ${jws.toCompactSerialization()}');

  // output the json serialization
  print('jws json serialization: ${jws.toJson()}');
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

  static toCurrency(var number, [quitarSignoDolar = false]){
    final formatCurrency = new NumberFormat.simpleCurrency();
    number = Utils.toDouble(number.toString());
    var data = formatCurrency.format(number).replaceFirst(".00", "");
    return (quitarSignoDolar) ? data.replaceFirst("\$", "") : data;
  }

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
  
}