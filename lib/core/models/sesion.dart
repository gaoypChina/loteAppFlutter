
import 'package:loterias/core/classes/utils.dart';

class Sesion {
  String usuario;
  String banca;
  String usuarioCancelacion;
  DateTime primerInicioSesionPC;
  DateTime ultimoInicioSesionPC;
  DateTime primerInicioSesionCelular;
  DateTime ultimoInicioSesionCelular;
  String versionApp;


  Sesion({this.usuario, this.banca, this.primerInicioSesionPC, this.ultimoInicioSesionPC, this.primerInicioSesionCelular, this.ultimoInicioSesionCelular, this.versionApp});

  Sesion.fromMap(Map snapshot) :
        usuario = snapshot['usuario'] ?? '',
        banca = snapshot['banca'] ?? '',
        usuarioCancelacion = (snapshot['usuarioCancelacion'] != null) ? snapshot['usuarioCancelacion'] : null,
        primerInicioSesionPC = (snapshot['primerInicioSesionPC'] != null && snapshot['primerInicioSesionPC'] != "-") ? DateTime.parse(snapshot['primerInicioSesionPC']) : null,
        ultimoInicioSesionPC = (snapshot['ultimoInicioSesionPC'] != null && snapshot['ultimoInicioSesionPC'] != "-") ? DateTime.parse(snapshot['ultimoInicioSesionPC']) : null,
        primerInicioSesionCelular = (snapshot['primerInicioSesionCelular'] != null  && snapshot['primerInicioSesionCelular'] != "-") ? DateTime.parse(snapshot['primerInicioSesionCelular']) : null,
        ultimoInicioSesionCelular = (snapshot['ultimoInicioSesionCelular'] != null && snapshot['ultimoInicioSesionCelular'] != "-") ? DateTime.parse(snapshot['ultimoInicioSesionCelular']) : null,
        versionApp = snapshot['versionapp'] ?? ''
        ;

  toJson() {
    return {
      "usuario": usuario,
      "banca": banca,
      "primerInicioSesionPC": (primerInicioSesionPC != null) ? primerInicioSesionPC.toString() : null,
      "ultimoInicioSesionPC": (ultimoInicioSesionPC != null) ? ultimoInicioSesionPC.toString() : null,
      "primerInicioSesionCelular": (primerInicioSesionCelular != null) ? primerInicioSesionCelular.toString() : null,
      "ultimoInicioSesionCelular": (ultimoInicioSesionCelular != null) ? ultimoInicioSesionCelular.toString() : null,
      "versionApp": versionApp ?? '',
    };
  }
}