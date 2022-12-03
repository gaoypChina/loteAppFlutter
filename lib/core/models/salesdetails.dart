
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/loterias.dart';

class Salesdetails {
  BigInt id;
  BigInt idVenta;
  BigInt idTicket;
  int idLoteria;

  int idSorteo;
  String sorteoDescripcion;
  String jugada;
  double monto;
  double premio;
  double comision;
  int idStock;
  int idLoteriaSuperpale;

  DateTime created_at;
  DateTime updated_at;

  int status;

  Loteria loteria;
  Loteria loteriaSuperPale;
  Draws sorteo;


  Salesdetails({this.id, this.idVenta, this.idTicket, this.idLoteria, this.idSorteo, this.jugada, this.monto, this.premio, this.comision, this.idStock, this.created_at, this.updated_at, this.idLoteriaSuperpale, this.status, this.loteria, this.loteriaSuperPale, this.sorteo, this.sorteoDescripcion});

  Salesdetails.fromMap(Map snapshot) :
        id = BigInt.from(snapshot['id']) ?? BigInt.zero,
        idVenta = snapshot['idVenta'] != null ? BigInt.from(snapshot['idVenta']) : BigInt.zero,
        idTicket = snapshot['idTicket'] != null ? BigInt.from(snapshot['idTicket']) : BigInt.zero,
        idLoteria = Utils.toInt(snapshot['idLoteria']) ?? 0,
        idSorteo = Utils.toInt(snapshot['idSorteo']) ?? 0,
        jugada = snapshot['jugada'] ?? '',
        monto = Utils.toDouble(snapshot['monto'].toString()) ?? 0,
        premio = Utils.toDouble(snapshot['premio'].toString()) ?? 0,
        comision = Utils.toDouble(snapshot['comision'].toString()) ?? 0,
        idStock = Utils.toInt(snapshot['idStock']) ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null,
        idLoteriaSuperpale = Utils.toInt(snapshot['idLoteriaSuperpale']) ?? 0,
        status = Utils.toInt(snapshot['status']) ?? 0,
        loteria = (snapshot["loteria"] != null) ? Loteria.fromMap(Utils.parsedToJsonOrNot(snapshot['loteria'])) : null,
        loteriaSuperPale = (snapshot["loteriaSuperpale"] != null) ? Loteria.fromMap(Utils.parsedToJsonOrNot(snapshot['loteriaSuperpale'])) : null,
        sorteo = (snapshot["sorteo"] != null) ? Draws.fromMap(Utils.parsedToJsonOrNot(snapshot['sorteo'])) : null,
        sorteoDescripcion = snapshot['sorteoDescripcion'] ?? ''
        ;

  static List salesdetailsToJson(List<Salesdetails> lista) {
    List jsonList = [];
    if(lista == null)
      return jsonList;
      
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

  static List<Salesdetails> fromMapList(parsed){
    return parsed != null ? parsed.map<Salesdetails>((json) => Salesdetails.fromMap(json)).toList() : [];
  }

  toJson() {
    return {
      // "id": id != null ? id.toInt() : null,
      // "idVenta": idVenta != null ? idVenta.toInt() : null,
      // "idTicket": idTicket != null ? idTicket.toInt() : null,
      "idLoteria": idLoteria,
      "idSorteo": idSorteo,
      "jugada": jugada,
      "monto": monto,
      "premio": premio != null ? premio : 0,
      // "comision": comision,
      // "idStock": idStock,
      // "created_at": created_at != null ? created_at.toString() : null,
      // "updated_at": updated_at != null ? updated_at.toString() : null,
      "idLoteriaSuperpale": idLoteriaSuperpale != null ? idLoteriaSuperpale : 0,
      "sorteoDescripcion": sorteoDescripcion,
    };
  }
  toJsonFull() {
    return {
      "id": id,
      "idVenta": idVenta != null ? idVenta.toInt() : null,
      "idTicket": idTicket != null ? idTicket.toInt() : null,
      "idLoteria": idLoteria,
      "idSorteo": idSorteo,
      "monto": monto,
      "premio": premio,
      "comision": comision,
      "idStock": idStock,
      "created_at": created_at != null ? created_at.toString() : null,
      "updated_at": updated_at != null ? updated_at.toString() : null,
      "idLoteriaSuperpale": idLoteriaSuperpale,
    };
  }
}