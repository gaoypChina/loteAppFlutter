
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/jugadas.dart';

import 'loterias.dart';

class Venta {
  int id;
  Banca banca;
  String abreviatura;
  DateTime created_at;
  String fecha;
  String codigoBarra;
  BigInt idTicket;
  double total;
  double descuentoMonto;
  int status;
  List<Jugada> jugadas;
  List<Loteria> loterias;
  String codigoQr;
  int minutosExtras;

  Venta({this.id, this.banca, this.abreviatura, this.status, this.jugadas, this.codigoQr, this.minutosExtras, this.loterias});

  Venta.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        banca = (snapshot["banca"] != null) ? Banca.fromMap(Utils.parsedToJsonOrNot(snapshot['banca'])) : null,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null,
        abreviatura = snapshot['abreviatura'] ?? '',
        fecha = snapshot['fecha'] ?? '',
        codigoBarra = snapshot['codigoBarra'] ?? '',
        idTicket = (snapshot['idTicket'] != null) ? BigInt.from(snapshot['idTicket']) : BigInt.zero ,
        total = Utils.toDouble(snapshot['total'].toString()) ?? 0,
        descuentoMonto = Utils.toDouble(snapshot['descuentoMonto'].toString()) ?? 0,
        status = snapshot['status'] ?? 1,
        jugadas = jugadasToMap(snapshot['jugadas']) ?? List(),
        loterias = loteriasToMap(snapshot['loterias']) ?? List(),
        codigoQr= snapshot['codigoQr'] ?? '',
        minutosExtras = snapshot['minutosExtras'] ?? 0
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
      "id": id,
      "banca": (banca != null) ? banca.toJson() : banca,
      "created_at": created_at.toString(),
      "abreviatura": abreviatura,
      "status": status,
      "fecha": fecha,
      "codigoBarra": codigoBarra,
      "idTicket": (idTicket != null) ? idTicket.toInt() : 0,
      "total": total,
      "codigoQr": codigoQr,
      "minutosExtras": minutosExtras,
    };
  }
}