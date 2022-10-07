
import 'dart:convert';

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/ajuste.dart';

import 'package:loterias/core/models/anulacionrecarga.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/dia.dart';
import 'package:loterias/core/models/gastos.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/models/pagoscombinacion.dart';
import 'package:loterias/core/models/proveedor.dart';
import 'package:loterias/core/models/usuario.dart';

class Recarga {
  int id;
  String codigoTransaccionApiKey;
  String codigoDeAutorizacion;
  String numero;
  double monto;
  String codigoRespuestaApi;
  String mensajeRespuestaApi;
  String ticketGeneradoApi;
  int idBalanceRecarga;
  int idUsuario;
  Usuario usuario;
  int idProveedor;
  Proveedor proveedor;
  int idBanca;
  Banca banca;
  AnulacionRecarga anulacionRecarga;
  DateTime created_at;

  Recarga({this.id, this.codigoTransaccionApiKey, this.codigoDeAutorizacion, this.numero, this.codigoRespuestaApi, this.mensajeRespuestaApi, this.ticketGeneradoApi, this.monto, this.idBalanceRecarga, this.idUsuario, this.usuario, this.idProveedor, this.proveedor, this.idBanca, this.banca, this.anulacionRecarga});

  Recarga.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? Utils.toInt(snapshot['id']) : 0,
        codigoTransaccionApiKey = snapshot['codigoTransaccionApiKey'] ?? '',
        codigoDeAutorizacion = snapshot['codigoDeAutorizacion'] ?? '',
        numero = snapshot['numero'] ?? '',
        codigoRespuestaApi = snapshot['codigoRespuestaApi'] ?? '',
        idUsuario = Utils.toInt(snapshot['idUsuario'].toString()) ?? null,
        usuario = snapshot['usuario'] != null ? Usuario.fromMap(Utils.parsedToJsonOrNot(snapshot['usuario'])) : null,
        idProveedor = Utils.toInt(snapshot['idProveedor'].toString()) ?? null,
        proveedor = snapshot['proveedor'] != null ? Proveedor.fromMap(Utils.parsedToJsonOrNot(snapshot['proveedor'])) : null,
        mensajeRespuestaApi = snapshot['mensajeRespuestaApi'] ?? '',
        ticketGeneradoApi = snapshot['ticketGeneradoApi'] ?? '',
        monto = Utils.toDouble(snapshot['monto']) ?? 0.0,
        idBalanceRecarga = snapshot['idBalanceRecarga'] != null ? Utils.toDouble(snapshot['idBalanceRecarga'].toString()).toInt() : 0,
        idBanca = Utils.toInt(snapshot['idBanca'].toString()) ?? null,
        banca = snapshot["banca"] != null ? Banca.fromMap(snapshot["banca"]) : null,
        anulacionRecarga = snapshot["anulacionRecarga"] != null ? AnulacionRecarga.fromMap(snapshot["anulacionRecarga"]) : null,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null
        ;

  static List<Recarga> fromMapList(parsed){
    return parsed != null ? parsed.map<Recarga>((json) => Recarga.fromMap(json)).toList() : [];
  }
        
  static Recarga get getRecargaTodas => Recarga(id: 0, codigoTransaccionApiKey: 'Todas'); 

  static Future<String> cambiarDatosDelTicketDeMidas(Recarga recarga) async {

    String ticketGeneradoPorMidasQuitandoleJeanContreras = recarga.ticketGeneradoApi != null ? recarga.ticketGeneradoApi.replaceFirst("[33508] JEAN CONTRERAS     \n", "") : "";
    
    Ajuste ajuste = await Ajuste.obtenerAjuste();

    String ticketConReemplazoDeDatosDeMidasPorNombreConsorcio = ticketGeneradoPorMidasQuitandoleJeanContreras.replaceFirst("        MIDASRED S.R.L         ", Ajuste.obtenerNombreConsorcio(ajuste).toUpperCase());
    
    String ticketConReemplazoDeNumeroDeMidasConNombreBanca = ticketConReemplazoDeDatosDeMidasPorNombreConsorcio.replaceFirst("         809-489-4100          ", ajuste.imprimirNombreBanca == 1 ? recarga.banca.descripcion.toUpperCase() : "");
    
    String ticketConReemplazoDeEnlaceDeMidas = ticketConReemplazoDeNumeroDeMidasConNombreBanca.replaceFirst("www.midasred.do", "");

    return ticketConReemplazoDeEnlaceDeMidas;
  }


  toJson() {
    return {
      "id": id,
      "codigoTransaccionApiKey": codigoTransaccionApiKey,
      "numero": numero,
      "codigoRespuestaApi": codigoRespuestaApi,
      "mensajeRespuestaApi": mensajeRespuestaApi,
      "ticketGeneradoApi": ticketGeneradoApi,
      "monto": monto,
      "idBalanceRecarga": idBalanceRecarga,
      "idUsuario": idUsuario,
      "usuario": usuario != null ? usuario.toJson() : null,
      "idBanca": idBanca,
      "banca" : banca != null ? banca.toJson() : null,
      "idProveedor": idProveedor,
      "proveedor" : proveedor != null ? proveedor.toJson() : null,
      "anulacionRecarga" : anulacionRecarga != null ? anulacionRecarga : null,
      "created_at": created_at != null ? created_at.toString() : null,
    };
  }
}