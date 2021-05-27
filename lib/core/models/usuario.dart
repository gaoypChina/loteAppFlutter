// import 'package:loterias/core/models/permiso.dart';

// class Usuario {
//   int id;
//   String usuario;
//   String servidor;
//   int status;
//   List<Permiso> permisos;

//   Usuario({this.id, this.usuario, this.servidor, this.status});

//   Usuario.fromMap(Map snapshot) :
//         id = snapshot['id'] ?? 0,
//         usuario = snapshot['usuario'] ?? '',
//         servidor = snapshot['servidor'] ?? '',
//         status = snapshot['status'] ?? 1
//         // permisos = permisosToMap(snapshot['permisos']) ?? List()
//         ;

// // List permisosToJson() {

// //     List jsonList = List();
// //     permisos.map((u)=>
// //       jsonList.add(u.toJson())
// //     ).toList();
// //     return jsonList;
// //   }

// //   static List<Permiso> permisosToMap(List<dynamic> permisos){
// //     return permisos.map((data) => Permiso.fromMap(data)).toList();
// //   }

//   toJson() {
//     return {
//       "id": id,
//       "usuario": usuario,
//       "servidor": servidor,
//       "status": status,
//     };
//   }
// }


import 'dart:convert';
import 'dart:typed_data';

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/rol.dart';

class Usuario {
  int id;
  Uint8List foto;
  String nombreFoto;
  String usuario;
  String password;
  String confirmar;
  String nombres;
  String apellidos;
  String sexo;
  String email;
  String telefono;
  String celular;
  String servidor;
  int status;
  List<Permiso> permisos;
  Grupo grupo;
  TipoUsuario tipoUsuario;
  bool esUsuarioPrincipalDelCliente;

  Usuario({this.id, this.foto, this.nombreFoto, this.usuario, this.password, this.servidor, this.status = 1, this.nombres, this.apellidos, this.celular, this.telefono, this.email, this.permisos = const [], this.grupo, this.sexo, this.tipoUsuario, this.esUsuarioPrincipalDelCliente = false});

  Usuario.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        nombreFoto = snapshot['foto'] ?? '',
        usuario = snapshot['usuario'] ?? '',
        password = snapshot['password'] ?? '',
        servidor = snapshot['servidor'] ?? '',
        nombres = snapshot['nombres'] ?? '',
        apellidos = snapshot['apellidos'] ?? '',
        telefono = snapshot['telefono'] ?? '',
        celular = snapshot['celular'] ?? '',
        email = snapshot['email'] ?? '',
        sexo = snapshot['sexo'] ?? '',
        status = snapshot['status'] ?? 1,
        permisos = permisosToMap(snapshot['permisos']) ?? [],
        grupo = (snapshot['grupo'] != null) ? Grupo.fromMap(Utils.parsedToJsonOrNot(snapshot['grupo'])) : null,
        tipoUsuario = (snapshot['tipoUsuarioObject'] != null) ? TipoUsuario.fromMap(snapshot['tipoUsuarioObject']) : null,
        esUsuarioPrincipalDelCliente = (snapshot['esUsuarioPrincipalDelCliente'] == 1) ? true : false
        ;

    List permisosToJson() {

      List jsonList = [];
      if(permisos != null)
        permisos.map((u)=>
          jsonList.add(u.toJson())
        ).toList();
      return jsonList;
    }

    static List<Permiso> permisosToMap(List<dynamic> permisos){
      if(permisos != null)
        return permisos.map((data) => Permiso.fromMap(data)).toList();
      else
        return [];
    }

    static List<Grupo> gruposToMap(List<dynamic> grupos){
      if(grupos != null)
        return grupos.map((data) => Grupo.fromMap(data)).toList();
      else
        return [];
    }

// List permisosToJson() {

//     List jsonList = List();
//     permisos.map((u)=>
//       jsonList.add(u.toJson())
//     ).toList();
//     return jsonList;
//   }

//   static List<Permiso> permisosToMap(List<dynamic> permisos){
//     return permisos.map((data) => Permiso.fromMap(data)).toList();
//   }

    toJson() {
    return {
      "id": id,
      "usuario": usuario,
      "servidor": servidor,
      "status": status,
    };
  }

  toJsonLarge() {
    return {
      "id": id,
      "foto": (foto != null) ? base64Encode(foto) : null,
      "nombreFoto": (nombreFoto != null) ? nombreFoto : null,
      "usuario": usuario,
      "password": password,
      "confirmar": confirmar,
      "servidor": servidor,
      "status": status,
      "nombres": nombres,
      "apellidos": apellidos,
      "email": email,
      "telefono": telefono,
      "celular": celular,
      "sexo": sexo,
      "permisos": permisosToJson(),
      "grupo": (grupo != null) ? grupo.toJson() : null,
      "idTipoUsuario": (tipoUsuario != null) ? tipoUsuario.id : null,
      "tipoUsuario": (tipoUsuario != null) ? tipoUsuario.toJson() : null,
    };
  }
}