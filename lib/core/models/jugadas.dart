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
        id = snapshot['id'] ?? 0,
        idVenta = snapshot['idVenta'] ?? 0,
        jugada = snapshot['jugada'] ?? '',
        idBanca = snapshot['idBanca'] ?? 0,
        idLoteria = snapshot['idLoteria'] ?? 0,
        idSorteo = snapshot['idSorteo'] ?? 0,
        monto = snapshot['monto'] ?? 0,
        premio = snapshot['premio'] ?? 0,
        pagado = snapshot['pagado'] ?? 0,
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