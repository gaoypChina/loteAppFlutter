
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/ticket.dart';
import 'package:loterias/core/models/usuario.dart';

import 'loterias.dart';

class Sale {
  BigInt id;
  int compartido;
  int idUsuario;

  int idBanca;
  double total;
  double subTotal;
  int descuentoMonto;
  int hayDescuento;

  BigInt idTicket;
  DateTime created_at;
  DateTime updated_at;

  int status;
  int subido;
  List<Jugada> jugadas;
  List<Loteria> loterias;

  Banca banca;
  Usuario usuario;
  Ticket ticket;
  

  Sale({this.id, this.compartido, this.idUsuario, this.idBanca, this.total, this.subTotal, this.descuentoMonto, this.hayDescuento, this.idTicket, this.created_at, this.updated_at, this.status, this.loterias, this.jugadas, this.banca, this.usuario, this.ticket, this.subido});

  Sale.fromMap(Map snapshot) :
        id = BigInt.from(snapshot['id']) ?? BigInt.zero,
        compartido = snapshot['compartido'] ?? 0,
        idUsuario = snapshot['idUsuario'] ?? 0,
        idBanca = snapshot['idBanca'] ?? 0,
        total = Utils.toDouble(snapshot['total'].toString()) ?? 0,
        subTotal = Utils.toDouble(snapshot['subTotal'].toString()) ?? 0,
        descuentoMonto = Utils.toInt(snapshot['descuentoMonto'].toString()) ?? 0,
        hayDescuento = Utils.toInt(snapshot['hayDescuento'].toString()) ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null,
        idTicket = (snapshot['idTicket'] != null) ? BigInt.from(snapshot['idTicket']) : BigInt.zero ,
        status = snapshot['status'] ?? 1,
        jugadas = jugadasToMap(snapshot['jugadas']) ?? [],
        loterias = loteriasToMap(snapshot['loterias']) ?? [],
        banca = (snapshot["banca"] != null) ? Banca.fromMap(Utils.parsedToJsonOrNot(snapshot['banca'])) : null,
        usuario = (snapshot["usuario"] != null) ? Usuario.fromMap(Utils.parsedToJsonOrNot(snapshot['usuario'])) : null,
        ticket = (snapshot["ticket"] != null) ? Ticket.fromMap(Utils.parsedToJsonOrNot(snapshot['ticket'])) : null,
        subido = snapshot['subido'] ?? 0
        ;

List jugadasToJson() {

    List jsonList = [];
    jugadas.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

  static List<Jugada> jugadasToMap(List<dynamic> jugadas){
    if(jugadas != null)
      return jugadas.map((data) => Jugada.fromMap(data)).toList();
    else
      return [];
  }

  static List<Loteria> loteriasToMap(List<dynamic> loterias){
    if(loterias != null)
      return loterias.map((data) => Loteria.fromMap(data)).toList();
    else
      return [];
  }

  toJson() {
    return {
      "id": id != null ? id.toInt() : null,
      "compartido": compartido,
      "idUsuario": idUsuario,
      "idBanca": idBanca,
      "total": total,
      "subTotal": subTotal,
      "descuentoMonto": descuentoMonto,
      "hayDescuento": hayDescuento,
      "idTicket": (idTicket != null) ? idTicket.toInt() : 0,
      "created_at": created_at != null ? created_at.toString() : null,
      "updated_at": updated_at != null ? updated_at.toString() : null,
      "status": status,
      "subido": subido != null ? subido : 0,
    };
  }
  toJsonFull() {
    return {
       "id": id != null ? id.toInt() : null,
      "compartido": compartido,
      "idUsuario": idUsuario,
      "idBanca": idBanca,
      "total": total,
      "subTotal": subTotal,
      "descuentoMonto": descuentoMonto,
      "hayDescuento": hayDescuento,
      "idTicket": (idTicket != null) ? idTicket.toInt() : 0,
      "created_at": created_at != null ? created_at.toString() : null,
      "updated_at": updated_at != null ? updated_at.toString() : null,
      "status": status,
      "subido": subido != null ? subido : 0,
      "ticket": ticket != null ? ticket.toJson() : null,
      "banca": banca != null ? banca.toJson() : null,
      "usuario": usuario != null ? usuario.toJson() : null,
    };
  }
}