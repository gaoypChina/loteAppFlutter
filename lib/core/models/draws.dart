

import 'package:loterias/core/classes/utils.dart';

class Draws{
   int id;
   String descripcion;
   int bolos;
   int cantidadNumeros;
   int status;
   DateTime created_at;
   double monto;

  Draws(this.id, this.descripcion, this.bolos, this.cantidadNumeros, this.status, this.created_at);

Draws.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? Utils.toInt(snapshot['id']) : 0,
        descripcion = snapshot['descripcion'] ?? '',
        bolos = snapshot['bolos'] != null ? Utils.toInt(snapshot['bolos']) : 0,
        cantidadNumeros = snapshot['cantidadNumeros'] != null ? Utils.toInt(snapshot['cantidadNumeros']) : 0,
        status = snapshot['status'] != null ? Utils.toInt(snapshot['status']) : 0,
        created_at = (snapshot['created_at'] != null && snapshot['created_at'] != 'null') ? snapshot["created_at"] is int ? DateTime.fromMillisecondsSinceEpoch(snapshot["created_at"]) : DateTime.parse(snapshot['created_at'].toString()) : null,
        monto = snapshot['monto'] != null ? Utils.toDouble(snapshot['monto']) : null
        ;

  static String get superPale => 'Super pale';
  static String get directo => 'Directo';
  static String get pale => 'Pale';
  static String get tripleta => 'Pale';
  static int get idSorteoPale => 2;
  static int get idSorteoTripleta => 3;
  static int get idSorteoSuperpale => 4;
  static int get tamanoDirecto => 2;
  static int get tamanoPale => 4;
  static int get tamanoTripleta => 6;
  static int get tamanoPick3Straight => 3;
  static int get tamanoPick3BoxConSigno => 4;
  static int get tamanoPick4StraightConSigno => 5;
  static int get tamanoPick4BoxConSigno => 5;

  static bool esDirecto(String sorteo){
    return sorteo != null ? sorteo == directo : false;
  }

  static bool esIdPale(int id){
    return id == idSorteoPale;
  }

  static bool esIdTripleta(int id){
    return id == idSorteoTripleta;
  }

  static bool esIdSuperpale(int id){
    return id == idSorteoSuperpale;
  }

  static bool esIdPaleOSuperpale(int id){
    return esIdPale(id) || esIdSuperpale(id);
  }

  static bool esIdPaleTripletaOSuperpale(int id){
    return (esIdPale(id) || esIdTripleta(id) || esIdSuperpale(id));
  }

  static bool esJugadaDirecto(String jugada){
    return esEntero(jugada) && jugada.length == Draws.tamanoDirecto;
  }

  static bool esJugadaPale(String jugada){
    return esEntero(jugada) && jugada.length == Draws.tamanoPale;
  }

  static bool esJugadaTripleta(String jugada){
    return esEntero(jugada) && jugada.length == Draws.tamanoTripleta;
  }

  static bool esJugadaSuperPale(String jugada){
    bool esTamanoSuperPale = jugada.length == 5;
    bool ultimoCaracterEsUnaS = jugada.substring(jugada.length - 1).toLowerCase() == "s";
    return esEntero(Utils.quitarUltimoCaracter(jugada)) && esTamanoSuperPale && ultimoCaracterEsUnaS;
  }

  static bool esJugadaPick3Straight(String jugada){
    return esEntero(jugada) && jugada.length == Draws.tamanoPick3Straight;
  }

  static bool esJugadaPick3Box(String jugada){
    bool esTamanoPick3Box = jugada.length == Draws.tamanoPick3BoxConSigno;
    bool ultimoCaracterEsSignoMas = jugada.substring(jugada.length - 1).toLowerCase() == "+";
    return esEntero(Utils.quitarUltimoCaracter(jugada)) && esTamanoPick3Box && ultimoCaracterEsSignoMas;
  }

  static bool esJugadaPick4Straight(String jugada){
    bool esTamanoPick4Straight = jugada.length == Draws.tamanoPick4StraightConSigno;
    bool ultimoCaracterEsSignoMenos = jugada.substring(jugada.length - 1).toLowerCase() == "-";
    return esEntero(Utils.quitarUltimoCaracter(jugada)) && esTamanoPick4Straight && ultimoCaracterEsSignoMenos;
  }

  static bool esJugadaPick4Box(String jugada){
    bool esTamanoPick4Box = jugada.length == Draws.tamanoPick4BoxConSigno;
    bool ultimoCaracterEsSignoMas = jugada.substring(jugada.length - 1).toLowerCase() == "+";
    return esEntero(Utils.quitarUltimoCaracter(jugada)) && esTamanoPick4Box && ultimoCaracterEsSignoMas;
  }

  static bool esEntero(String jugada){
    int numero = Utils.toInt(jugada, returnNullIfNotInt: true);
    return numero != null && numero >= 0;
  }

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "bolos": bolos,
      "cantidadNumeros": cantidadNumeros,
      "status": status,
      "created_at": created_at.toString(),
    };
  }

  toJsonFull() {
    return {
      "id": id,
      "descripcion": descripcion,
      "bolos": bolos,
      "cantidadNumeros": cantidadNumeros,
      "status": status,
      "created_at": created_at.toString(),
      "monto": monto,
    };
  }

  static List drawsToJson(List<Draws> lista, [var toJsonFull = false]) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(toJsonFull ? u.toJsonFull() : u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build