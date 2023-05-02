

import 'package:loterias/core/classes/utils.dart';

class TipoBloqueo {
  const TipoBloqueo._(this.index);

  /// The encoded integer value of this font weight.
  final int index;

  /// Thin, the least thick
  static const TipoBloqueo general = TipoBloqueo._(0);

  /// Extra-light
  static const TipoBloqueo porBancas = TipoBloqueo._(1);

  /// Light
  static const TipoBloqueo jugadas = TipoBloqueo._(2);

  static const TipoBloqueo jugadasPorBanca = TipoBloqueo._(3);

  /// A list of all the font weights.
  static const List<TipoBloqueo> values = <TipoBloqueo>[
    general, porBancas, jugadas, jugadasPorBanca
  ];

  toString(){
    String data = '';
    switch (this) {
      case jugadasPorBanca:
        data = 'Jugadas por bancas';
        break;
      case porBancas:
        data = 'Por bancas';
        break;
      case jugadas:
        data = 'Jugadas';
        break;
      default:
        data = 'General';
    }
    return data;
  }
}

class Bloqueo{
   String ids;
   String abreviaturaDias;
   String descripcionDias;
   String descripcionLoterias;
   int idSorteo;
   double monto;
   DateTime created_at;
   int idMoneda;
   String descripcionLoteriaSuperpales;
   int cantidadDias;
   String descripcionBancas;
   String codigoBancas;
   String jugadas;
   DateTime fechaHasta;

  Bloqueo({this.ids, this.abreviaturaDias, this.descripcionDias, this.descripcionLoterias, this.descripcionLoteriaSuperpales, this.idSorteo, this.monto, this.created_at, this.idMoneda, this.cantidadDias, this.descripcionBancas, this.codigoBancas, this.jugadas, this.fechaHasta});

Bloqueo.fromMap(Map snapshot) :
        ids = snapshot['ids'] ?? '',
        abreviaturaDias = snapshot['abreviaturaDias'] ?? '',
        descripcionDias = snapshot['descripcionDias'] ?? '',
        descripcionLoterias = snapshot['descripcionLoterias'] ?? '',
        descripcionLoteriaSuperpales = snapshot['descripcionLoteriaSuperpales'] ?? '',
        idSorteo = snapshot['idSorteo'] != null ? Utils.toInt(snapshot['idSorteo']) : 0,
        monto = Utils.toDouble(snapshot['monto'].toString()) ?? 0,
        created_at = snapshot['created_at'] != null ? DateTime.parse(snapshot['created_at']) : DateTime.now(),
        idMoneda = snapshot['idMoneda'] != null ? Utils.toInt(snapshot['idMoneda']) : 0,
        cantidadDias = snapshot['cantidadDias'] != null ? Utils.toInt(snapshot['cantidadDias']) : 0,
        descripcionBancas = snapshot['descripcionBancas'] ?? '',
        codigoBancas = snapshot['codigoBancas'] ?? '',
        jugadas = snapshot['jugadas'] ?? '',
        fechaHasta = snapshot['fechaHasta'] != null ? DateTime.parse(snapshot['fechaHasta']) : null
        ;

  static List<Bloqueo> fromMapList(var parsed) => parsed != null ? parsed.map<Bloqueo>((json) => Bloqueo.fromMap(json)).toList() : [];

  toJson() {
    return {
      "ids": ids,
      "abreviaturaDias": abreviaturaDias,
      "descripcionDias": descripcionDias,
      "descripcionLoterias": descripcionLoterias,
      "descripcionLoteriaSuperpales": descripcionLoteriaSuperpales,
      "idSorteo": idSorteo,
      "monto": monto,
      "created_at": created_at.toString(),
      "idMoneda": idMoneda,
      "cantidadDias": cantidadDias,
      "descripcionBancas": descripcionBancas,
      "codigoBancas": codigoBancas,
      "jugadas": jugadas,
    };
  }

  static List BloqueoToJson(List<Bloqueo> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build