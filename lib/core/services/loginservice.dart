import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/ui/widgets/showsnackbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService{
  static Future<Map<String, dynamic>> acceder({String usuario, String password, scaffoldkey}) async {
    var map = Map<String, dynamic>();
    var map2 = Map<String, dynamic>();

    map["usuario"] = usuario;
    map["password"] = password;
    map2["datos"] = map;
    final response = await http.post(Utils.URL + '/api/acceder', body: json.encode(map2), headers: Utils.header);
    
    if(response.statusCode < 200 || response.statusCode > 400){
      print('parsed ${response.body}');
      Utils.showSnackBar(scaffoldKey: scaffoldkey, content:"Verifique conexion");
       throw Exception('Failed to load album');
    }
   
      var parsed = Utils.parseDatos(response.body);
      if(parsed["errores"] == 1){
        if(scaffoldkey != null)
        Utils.showSnackBar(scaffoldKey: scaffoldkey, content:parsed["mensaje"] );
        throw Exception('Failed to load usuario datos incorrectos');
      }
      // print('parsed ${parsed['usuario']}');
      // _usuario = Usuario.fromMap(parsed['usuario']);
      // _banca = Banca.fromMap(parsed['bancaObject']);
      // return parsed['usuario'].map<Usuario>((json) => Usuario.fromMap(json)).toList();
      return parsed;
  }

  static guardarDatos(Map<String, dynamic> parsed) async {
    Usuario u = Usuario.fromMap(parsed['usuario']);
    Banca b = Banca.fromMap(parsed['bancaObject']);
    List<Permiso> permisos = parsed['permisos'].map<Permiso>((json) => Permiso.fromMap(json)).toList();

    
    await Db.deleteDB();
    await Db.create();
    await Db.open();

    await Db.insert('Users', u.toJson());
    await Db.insert('Branches', b.toJson());
    
    for(Permiso p in permisos){
      await Db.insert('Permissions', p.toJson());
    }
  }
}