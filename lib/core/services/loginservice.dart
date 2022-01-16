import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:loterias/core/classes/cross_platform_firebase/cross_platform_firebase.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/drift_database.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService{
  static Future<Map<String, dynamic>> acceder({String usuario, String password, scaffoldkey, context}) async {
    var map = Map<String, dynamic>();
    var map2 = Map<String, dynamic>();

    map["usuario"] = usuario;
    map["password"] = password;
    map2["datos"] = map;
    final response = await http.post(Uri.parse(Utils.URL + '/api/acceder/v2'), body: json.encode(map2), headers: Utils.header);
    
    if(response.statusCode < 200 || response.statusCode > 400){
      print("GrupoService index: ${response.body}");
      var parsed = await compute(Utils.parseDatos, response.body);
      if(context != null)
        Utils.showAlertDialog(context: context, content: "${parsed["message"]}", title: "Error");
      else
        Utils.showSnackBar(content: "${parsed["message"]}", scaffoldKey: scaffoldkey);
      throw Exception("Error del servidor GrupoService index: ${parsed["message"]}");
    }
   
      var parsed = await compute(Utils.parseDatos, response.body);
      print("loginserviceAcceder parsed compute: $parsed");
      // if(parsed["errores"] == 1){
      //   if(scaffoldkey != null)
      //   print("loginservice acceder: $parsed");
      //   Utils.showSnackBar(scaffoldKey: scaffoldkey, content:parsed["mensaje"] );
      //   throw Exception('Failed to load usuario datos incorrectos');
      // }

      if(parsed["errores"] == 1){
        if(context != null)
          Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
        else
          Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldkey);
        throw Exception("Error GrupoService index: ${parsed["mensaje"]}");
      }
      
      // print('parsed ${parsed['usuario']}');
      // _usuario = Usuario.fromMap(parsed['usuario']);
      // _banca = Banca.fromMap(parsed['bancaObject']);
      // return parsed['usuario'].map<Usuario>((json) => Usuario.fromMap(json)).toList();
      return parsed;
  }

  static Future<Map<String, dynamic>> cambiarServidor({String usuario, String servidor, BuildContext context, scaffoldKey}) async {
    var map = Map<String, dynamic>();
    var map2 = Map<String, dynamic>();

    map["usuario"] = usuario;
    map["servidor"] = servidor;
    var jwt = await Utils.createJwt(map);
    map2["datos"] = jwt;
    final response = await http.post(Uri.parse(Utils.URL + '/api/cambiarServidorApi'), body: json.encode(map2), headers: Utils.header);
    int statusCode = response.statusCode;
    
    if(statusCode < 200 || statusCode > 400){
      print("loginservice cambiarServidor: ${response.body}");
      if(context != null)
        Utils.showAlertDialog(context: context, content: "Error del servidor loginservice cambiarServidor", title: "Error");
      else
        Utils.showSnackBar(content: "Error del servidor loginservice cambiarServidor", scaffoldKey: scaffoldKey);
      throw Exception("Error del servidor loginservice cambiarServidor");
    }

    var parsed = await compute(Utils.parseDatos, response.body);
    print("loginservice cambiarServidor: ${parsed}");
    if(parsed["errores"] == 1){
      if(context != null)
        Utils.showAlertDialog(context: context, content: parsed["mensaje"], title: "Error");
      else
        Utils.showSnackBar(content: parsed["mensaje"], scaffoldKey: scaffoldKey);
      throw Exception("Error loginservice cambiarServidor: ${parsed["mensaje"]}");
    }
      
      return parsed;
  }

  static guardarDatos(Map<String, dynamic> parsed) async {
    Usuario u = Usuario.fromMap(parsed['usuario']);
    Banca b = parsed['bancaObject2'] != null ? Banca.fromMap(parsed['bancaObject2']) : null;
    Ajuste a = (parsed['ajustes'] != null) ? Ajuste.fromMap(parsed['ajustes']) : null;
    List<Permiso> permisos = parsed['permisos'].map<Permiso>((json) => Permiso.fromMap(json)).toList();
    List<Servidor> servidores = parsed['servidores'].map<Servidor>((json) => Servidor.fromMap(json)).toList();

    
    await Db.deleteDB();
    // await Db.openConnection();

    await Db.insertUser(User(id: u.id, nombres: u.nombres, email: u.email, usuario: u.usuario, servidor: u.servidor, status: u.status, idGrupo: u.idGrupo));
    if(b != null){
      await Db.insertBranch(Branch(
        id: b.id, descripcion: b.descripcion, codigo: b.codigo, dueno: b.dueno, idUsuario: b.usuario != null ? b.usuario.id : 0, 
        limiteVenta: b.limiteVenta, descontar: b.descontar, deCada: b.deCada, minutosCancelarTicket: b.minutosCancelarTicket, 
        piepagina1: b.piepagina1, piepagina2: b.piepagina2, piepagina3: b.piepagina3, piepagina4: b.piepagina4, idMoneda: b.idMoneda, 
        moneda: b.moneda, monedaAbreviatura: b.monedaAbreviatura, monedaColor: b.monedaColor, status: b.status, ventasDelDia: b.ventasDelDia));
      // for(Loteria l in b.loterias){
      //   await Db.insert('Lotteries', {"id":l.id, "descripcion" : l.descripcion, "abreviatura" : l.abreviatura, "status" : l.status});
      // }
      // for(Dia d in b.dias){
      //   await Db.insert('Days', d.toJson());
      // }
      await Db.insertListLoteria(b.loterias);
      await Db.insertListDay(b.dias);
    }
    print("Loginservice guardarDatos: ${a.toJson()}");
    if(a != null)
      await Db.insertSetting(Setting(
        id : a.id, 
        consorcio : (a.consorcio != null) ? a.consorcio : '',
        idTipoFormatoTicket : a.tipoFormatoTicket.id,
        imprimirNombreConsorcio : a.imprimirNombreConsorcio,
        descripcionTipoFormatoTicket : a.tipoFormatoTicket.descripcion,
        imprimirNombreBanca : a.imprimirNombreBanca,
        cancelarTicketWhatsapp : a.cancelarTicketWhatsapp,
        pagarTicketEnCualquierBanca : a.pagarTicketEnCualquierBanca,
      ));

    
    // for(Permiso p in permisos){
    //   await Db.insert('Permissions', p.toJson());
    // }

    await Db.insertListPermission(permisos);

      print("LoginService guardarDatos after Permissions been saved");


    // for(Servidor s in servidores){
    //   await Db.insert('Servers', s.toJson());
    // }

    await (await DB.create()).addAjuste(a);
    await Db.insertListServer(servidores);

    // await Utils.subscribeToTopic();
    await (CrossFirebase()).unSubscribeFromTopic();

  }
  // static guardarDatosSQFlite(Map<String, dynamic> parsed) async {
  //   Usuario u = Usuario.fromMap(parsed['usuario']);
  //   Banca b = parsed['bancaObject2'] != null ? Banca.fromMap(parsed['bancaObject2']) : null;
  //   Ajuste a = (parsed['ajustes'] != null) ? Ajuste.fromMap(parsed['ajustes']) : null;
  //   List<Permiso> permisos = parsed['permisos'].map<Permiso>((json) => Permiso.fromMap(json)).toList();
  //   List<Servidor> servidores = parsed['servidores'].map<Servidor>((json) => Servidor.fromMap(json)).toList();

    
  //   await Db.deleteDB();
  //   // await Db.openConnection();

  //   await Db.insert('Users', u.toJson());
  //   if(b != null){
  //     await Db.insert('Branches', b.toJson());
  //     for(Loteria l in b.loterias){
  //       await Db.insert('Lotteries', {"id":l.id, "descripcion" : l.descripcion, "abreviatura" : l.abreviatura, "status" : l.status});
  //     }
  //     for(Dia d in b.dias){
  //       await Db.insert('Days', d.toJson());
  //     }
  //   }
  //   print("Loginservice guardarDatos: ${a.toJson()}");
  //   if(a != null)
  //     await Db.insert("Settings", {
  //       "id" : a.id, 
  //       "consorcio" : (a.consorcio != null) ? a.consorcio : '',
  //       "idTipoFormatoTicket" : a.tipoFormatoTicket.id,
  //       "imprimirNombreConsorcio" : a.imprimirNombreConsorcio,
  //       "descripcionTipoFormatoTicket" : a.tipoFormatoTicket.descripcion,
  //       "imprimirNombreBanca" : a.imprimirNombreBanca,
  //       "cancelarTicketWhatsapp" : a.cancelarTicketWhatsapp,
  //       "pagarTicketEnCualquierBanca" : a.pagarTicketEnCualquierBanca,
  //     });

    
  //   for(Permiso p in permisos){
  //     await Db.insert('Permissions', p.toJson());
  //   }

  //     print("LoginService guardarDatos after Permissions been saved");


  //   for(Servidor s in servidores){
  //     await Db.insert('Servers', s.toJson());
  //   }

  //   await Utils.subscribeToTopic();


  // }
}