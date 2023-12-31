import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/stocks.dart';

import 'loterias.dart';

class Jugada {
  BigInt id;
  BigInt idVenta;
  String jugada;
  int idBanca;
  int idLoteria;
  int idLoteriaSuperpale;
  int idSorteo;
  double monto;
  double premio;
  double pagado;
  String sorteo;
  String pagadoPor;
  String descripcion;
  String descripcionSuperpale;
  String abreviatura;
  String abreviaturaSuperpale;
  int status;
  int cantidadVecesQueSeHaJugado;
  int cantidadVecesQueHaSalido;
  Loteria loteria;
  Loteria loteriaSuperPale;
  Stock stock;
  bool stockEliminado;
  bool esCombinada;

  Jugada({this.id, 
        this.idVenta, 
        this.jugada, 
        this.idBanca, 
        this.idLoteria, 
        this.idLoteriaSuperpale = 0, 
        this.idSorteo, 
        this.monto, 
        this.premio, 
        this.pagado, 
        this.sorteo, 
        this.pagadoPor, 
        this.descripcion, 
        this.descripcionSuperpale, 
        this.abreviatura, 
        this.abreviaturaSuperpale, 
        this.status,
        this.cantidadVecesQueSeHaJugado,
        this.cantidadVecesQueHaSalido,
        this.loteria,
        this.loteriaSuperPale,
        this.stock,
        this.stockEliminado = false,
        this.esCombinada = false
      });

  Jugada.fromMap(Map snapshot) :
        id = (snapshot['id'] != null) ? BigInt.from(snapshot['id']) : BigInt.from(0),
        idVenta = (snapshot['idVenta'] != null) ? BigInt.from(snapshot['idVenta']) : BigInt.from(0),
        jugada = snapshot['jugada'] ?? '',
        idBanca = Utils.toInt(snapshot['idBanca']) ?? 0,
        idLoteria = Utils.toInt(snapshot['idLoteria']) ?? 0,
        idLoteriaSuperpale = Utils.toInt(snapshot['idLoteriaSuperpale']) ?? 0,
        idSorteo = Utils.toInt(snapshot['idSorteo']) ?? 0,
        monto = Utils.toDouble(snapshot['monto'].toString()) ?? 0,
        premio = Utils.toDouble(snapshot['premio'].toString()) ?? 0,
        pagado = Utils.toDouble(snapshot['pagado'].toString()) ?? 0,
        sorteo = snapshot['sorteo'] ?? '',
        pagadoPor = snapshot['pagadoPor'] ?? '',
        descripcion = snapshot['descripcion'] ?? '',
        descripcionSuperpale = snapshot['descripcionSuperpale'] ?? '',
        abreviatura = snapshot['abreviatura'] ?? '',
        abreviaturaSuperpale = snapshot['abreviaturaSuperpale'] ?? '',
        status = Utils.toInt(snapshot['status']) ?? 1,
        cantidadVecesQueSeHaJugado = Utils.toInt(snapshot['cantidadVecesQueSeHaJugado']) ?? null,
        cantidadVecesQueHaSalido = Utils.toInt(snapshot['cantidadVecesQueHaSalido']) ?? null;

  Jugada.clone(Jugada origen) :
        id = origen.id,
        idVenta = origen.idVenta,
        jugada = origen.jugada,
        idBanca = origen.idBanca,
        idLoteria = origen.idLoteria,
        idLoteriaSuperpale = origen.idLoteriaSuperpale,
        idSorteo = origen.idSorteo,
        monto = origen.monto,
        premio = origen.premio,
        pagado = origen.pagado,
        sorteo = origen.sorteo,
        pagadoPor = origen.pagadoPor,
        descripcion = origen.descripcion,
        descripcionSuperpale = origen.descripcionSuperpale,
        abreviatura = origen.abreviatura,
        abreviaturaSuperpale = origen.abreviaturaSuperpale,
        status = origen.status,
        cantidadVecesQueSeHaJugado = origen.cantidadVecesQueSeHaJugado,
        cantidadVecesQueHaSalido = origen.cantidadVecesQueHaSalido,
        loteria = origen.loteria,
        loteriaSuperPale = origen.loteriaSuperPale,
        stock = origen.stock,
        stockEliminado = origen.stockEliminado,
        esCombinada = origen.esCombinada;

      
  static List jugadasToJson(List<Jugada> lista) {
    List jsonList = [];
    if(lista == null)
      return jsonList;
      
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

  toJson() {
    return {
      "id": id,
      "idVenta": idVenta,
      "jugada": jugada,
      "idBanca": idBanca,
      "idLoteria": idLoteria,
      "idLoteriaSuperpale": idLoteriaSuperpale,
      "idSorteo": idSorteo,
      "monto": monto,
      "premio": premio,
      "pagado": pagado,
      "sorteo": sorteo,
      "pagadoPor": pagadoPor,
      "descripcion": descripcion,
      "descripcionSuperpale": descripcionSuperpale,
      "status": status,
      "cantidadVecesQueSeHaJugado": cantidadVecesQueSeHaJugado,
      "cantidadVecesQueHaSalido": cantidadVecesQueHaSalido,
      "esCombinada": esCombinada ? 1 : 0,
    };
  }
}