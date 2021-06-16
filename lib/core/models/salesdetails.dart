
import 'package:loterias/core/classes/utils.dart';

class Salesdetails {
  BigInt id;
  BigInt idVenta;
  int idLoteria;

  int idSorteo;
  String jugada;
  double monto;
  double premio;
  double comision;
  int idStock;
  int idLoteriaSuperpale;

  DateTime created_at;
  DateTime updated_at;

  int status;


  Salesdetails({this.id, this.idVenta, this.idLoteria, this.idSorteo, this.jugada, this.monto, this.premio, this.comision, this.idStock, this.created_at, this.updated_at, this.idLoteriaSuperpale, this.status});

  Salesdetails.fromMap(Map snapshot) :
        id = BigInt.from(snapshot['id']) ?? BigInt.zero,
        idVenta = snapshot['idVenta'] ?? 0,
        idLoteria = snapshot['idLoteria'] ?? 0,
        idSorteo = snapshot['idSorteo'] ?? 0,
        jugada = snapshot['jugada'] ?? '',
        monto = Utils.toDouble(snapshot['monto'].toString()) ?? 0,
        premio = Utils.toDouble(snapshot['premio'].toString()) ?? 0,
        comision = Utils.toDouble(snapshot['comision'].toString()) ?? 0,
        idStock = Utils.toInt(snapshot['idStock'].toString()) ?? 0,
        created_at = (snapshot['created_at'] != null) ? DateTime.parse(snapshot['created_at']) : null,
        idLoteriaSuperpale = snapshot['idLoteriaSuperpale'] ?? 0,
        status = snapshot['status'] ?? 0
        ;

  

  toJson() {
    return {
      "id": id != null ? id.toInt() : null,
      "idVenta": idVenta != null ? idVenta.toInt() : null,
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
  toJsonFull() {
    return {
      "id": id,
      "idVenta": idVenta,
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