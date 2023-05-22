
import 'package:loterias/core/classes/utils.dart';

class Branchreport {
  int idBanca;
  String descripcion;
  String codigo;
  double ventas;
  double descuentos;
  double comisiones;
  double premios;
  double balance;
  double balanceActual;
  double caidaAcumulada;
  double totalNeto;
  String usuario;
  int pendientes;
  int ganadores;
  int perdedores;
  int tickets;
  double totalNetoPorcentaje;
  int status;


  Branchreport({this.idBanca, this.ventas, this.descuentos, this.balance, this.codigo, this.usuario, this.descripcion, this.ganadores, this.perdedores, this.tickets, this.totalNetoPorcentaje});

  Branchreport.fromMap(Map snapshot) :
        idBanca = Utils.toInt(snapshot['idBanca']),
        descripcion = (snapshot['descripcion'] != null) ? snapshot['descripcion'] : '',
        codigo = snapshot['codigo'] ?? '',
        ventas = Utils.toDouble(snapshot['ventas']),
        descuentos = Utils.toDouble(snapshot['descuentos'].toString()),
        comisiones = Utils.toDouble(snapshot['comisiones'].toString()),
        premios = Utils.toDouble(snapshot['premios'].toString()),
        balance = Utils.toDouble(snapshot['balance'].toString()),
        balanceActual = Utils.toDouble(snapshot['balanceActual'].toString()),
        caidaAcumulada = Utils.toDouble(snapshot['caidaAcumulada'].toString()),
        totalNeto = Utils.toDouble(snapshot['totalNeto'].toString()),
        usuario = (snapshot['usuario'] != null) ? snapshot['usuario'] : null,
        pendientes = Utils.toInt(snapshot['pendientes']),
        ganadores = Utils.toInt(snapshot['ganadores']),
        perdedores = Utils.toInt(snapshot['perdedores']),
        tickets = Utils.toInt(snapshot['tickets']),
        totalNetoPorcentaje = Utils.toDouble(snapshot['totalNetoPorcentaje'].toString()),
        status = Utils.toInt(snapshot['status'])
        ;

  static Branchreport get getBranchreportNinguno => Branchreport(idBanca: 0, descripcion: 'Ninguno'); 

  static List<Branchreport> fromMapList(parsed){
    return parsed != null ? parsed.length > 0 ? parsed.map<Branchreport>((json) => Branchreport.fromMap(json)).toList() : [] : [];
  }

  toJson() {
    return {
      "idBanca": idBanca,
      "descripcion": descripcion,
      "codigo": codigo,
      "ventas": ventas,
      "descuentos": descuentos,
      "comisiones": comisiones,
      "premios": premios,
      "balance": balance,
      "balanceActual": balanceActual,
      "caidaAcumulada": (caidaAcumulada != null) ? caidaAcumulada.toString() : null,
      "totalNeto": totalNeto,
      "pendientes": pendientes,
      "ganadores": ganadores,
      "perdedores": perdedores,
      "tickets": tickets,
      "totalNetoPorcentaje": totalNetoPorcentaje,
    };
  }
}