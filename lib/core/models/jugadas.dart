import 'package:loterias/core/classes/utils.dart';

class Jugada {
  BigInt id;
  BigInt idVenta;
  String jugada;
  int idBanca;
  int idLoteria;
  int idSorteo;
  double monto;
  double premio;
  double pagado;
  String sorteo;
  String pagadoPor;
  String descripcion;
  int status;

  Jugada({this.id, 
        this.idVenta, 
        this.jugada, 
        this.idBanca, 
        this.idLoteria, 
        this.idSorteo, 
        this.monto, 
        this.premio, 
        this.pagado, 
        this.sorteo, 
        this.pagadoPor, 
        this.descripcion, 
        this.status
      });

  Jugada.fromMap(Map snapshot) :
        id = BigInt.from(snapshot['id']) ?? BigInt.from(0),
        idVenta = BigInt.from(snapshot['idVenta']) ?? BigInt.from(0),
        jugada = snapshot['jugada'] ?? '',
        idBanca = snapshot['idBanca'] ?? 0,
        idLoteria = snapshot['idLoteria'] ?? 0,
        idSorteo = snapshot['idSorteo'] ?? 0,
        monto = Utils.toDouble(snapshot['monto'].toString()) ?? 0,
        premio = Utils.toDouble(snapshot['premio'].toString()) ?? 0,
        pagado = Utils.toDouble(snapshot['pagado'].toString()) ?? 0,
        sorteo = snapshot['sorteo'] ?? '',
        pagadoPor = snapshot['pagadoPor'] ?? '',
        descripcion = snapshot['descripcion'] ?? '',
        status = snapshot['status'] ?? 1;

  toJson() {
    return {
      "id": id,
      "idVenta": idVenta,
      "jugada": jugada,
      "idBanca": idBanca,
      "idLoteria": idLoteria,
      "idSorteo": idSorteo,
      "monto": monto,
      "premio": premio,
      "pagado": pagado,
      "sorteo": sorteo,
      "pagadoPor": pagadoPor,
      "descripcion": descripcion,
      "status": status,
    };
  }
}