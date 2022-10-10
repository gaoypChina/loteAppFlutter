
import 'package:loterias/core/classes/utils.dart';


class Historico {
  int idBanca;
  int idMoneda;
  String descripcion;
  String codigo;
  double ventas;
  double recargas;
  double descuentos;
  double comisiones;

  double premios;
  double balanceActual;
  double caidaAcumulada;
  double totalNeto;
  double balance;
  int tickets;
  int pendientes;
  int ganadores;
  int perdedores;

  Historico({this.idBanca, this.codigo, this.ventas, this.recargas, this.descuentos, this.comisiones, this.premios, this.balanceActual, this.caidaAcumulada, this.totalNeto, this.balance, this.tickets, this.pendientes, this.ganadores, this.perdedores});

  Historico.fromMap(Map snapshot) :
        idBanca = Utils.toInt(snapshot['idBanca']) ?? 0,
        idMoneda = Utils.toInt(snapshot['idMoneda']) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        codigo = snapshot['codigo'] ?? '',
        ventas = Utils.toDouble(snapshot['ventas'].toString()) ?? 0,
        recargas = Utils.toDouble(snapshot['recargas'].toString()) ?? 0,
        descuentos = Utils.toDouble(snapshot['descuentos'].toString()) ?? 0,
        comisiones = Utils.toDouble(snapshot['comisiones'].toString()) ?? 0,
        premios = Utils.toDouble(snapshot['premios'].toString()) ?? 0,
        balanceActual = Utils.toDouble(snapshot['balanceActual'].toString()) ?? 0,
        caidaAcumulada = Utils.toDouble(snapshot['caidaAcumulada'].toString()) ?? 0,
        totalNeto = Utils.toDouble(snapshot['totalNeto'].toString()) ?? 0,
        balance = Utils.toDouble(snapshot['balance'].toString()) ?? 0,
        tickets = Utils.toInt(snapshot['tickets']) ?? 0,
        pendientes = Utils.toInt(snapshot['pendientes']) ?? 0,
        ganadores = Utils.toInt(snapshot['ganadores']) ?? 0,
        perdedores = Utils.toInt(snapshot['perdedores']) ?? 0
        ;



  toJson() {
    return {
      "idBanca": idBanca,
      "idMoneda": idMoneda,
      "descripcion": descripcion,
      "codigo": codigo,
      "ventas": ventas,
      "recargas": recargas,
      "descuentos": descuentos,
      "comisiones": comisiones,
    };
  }
}