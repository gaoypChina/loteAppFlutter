
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/draws.dart';

import 'dia.dart';

class Loteria {
  int id;
  String descripcion;
  String abreviatura;
  String primera;
  String segunda;
  String tercera;
  String pick3;
  String pick4;
  int status;
  List<Draws> sorteos;
  List<Loteria> loteriaSuperpale;
  List<Dia> dias;
  String horaApertura;
  String horaCierre;
  int minutosExtras;
  String color;

  Loteria({this.id, this.descripcion, this.abreviatura, this.status, this.sorteos, this.horaApertura, this.horaCierre, this.minutosExtras, this.loteriaSuperpale, this.color});

  Loteria.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        abreviatura = snapshot['abreviatura'] ?? '',
        primera = snapshot['primera'] ?? '',
        segunda = snapshot['segunda'] ?? '',
        tercera = snapshot['tercera'] ?? '',
        pick3 = snapshot['pick3'] ?? '',
        pick4 = snapshot['pick4'] ?? '',
        status = Utils.toInt(snapshot['status']) ?? 0,
        sorteos = sorteosToMap(Utils.parsedToJsonOrNot(snapshot['sorteos'])) ?? [],
        loteriaSuperpale = loteriaSuperpaleToMap(snapshot['loteriaSuperpale']) ?? [],
        horaApertura= snapshot['horaApertura'] ?? '',
        horaCierre= snapshot['horaCierre'] ?? '',
        minutosExtras = Utils.toInt(snapshot['minutosExtras']) ?? 0,
        dias = diasToMap(Utils.parsedToJsonOrNot(snapshot['dias'])) ?? [],
        color = snapshot['color'] ?? null
        ;

List sorteosToJson() {
    if(sorteos == null)
      return [];

    List jsonList = [];
    sorteos.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

  static List<Draws> sorteosToMap(List<dynamic> sorteos){
    if(sorteos != null)
      return sorteos.map((data) => Draws.fromMap(data)).toList();
    else
      return [];
  }

  static List<Loteria> loteriaSuperpaleToMap(List<dynamic> loterias){
    if(loterias != null)
      return loterias.map((data) => Loteria.fromMap(data)).toList();
    else
      return [];
  }

  List loteriaSuperpaleToJson() {

    List jsonList = [];
    if(loteriaSuperpale == null)
      return [];

    loteriaSuperpale.map((u){
      //el servidor solo guarda las loterias seleccionadas que tiene el parametro 'seleccionado == true',
      //asi que agregamos este parametro para que el servidor lo guarde
      return jsonList.add({"id" : u.id, 'descripcion' : u.descripcion, 'seleccionado' : true});
    }).toList();
    return jsonList;
  }

  static List loteriasToJson(List<Loteria> lista) {
    List jsonList = [];
    if(lista == null)
      return jsonList;
      
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

  List diasToJson() {
    if(dias == null)
      return [];

    List jsonList = [];
    dias.map((u)=>
      jsonList.add(u.toFullJson())
    ).toList();
    return jsonList;
  }

  static List<Dia> diasToMap(List<dynamic> dias){
    if(dias != null)
      return dias.map((data) => Dia.fromMap(data)).toList();
    else
      return [];
  }

  static String getDescripcion(Loteria loteria, {Loteria loteriaSuperpale = null, bool returnAbreviatura = true}){
    String descripcion;
    if(returnAbreviatura)
      descripcion = "${loteriaSuperpale != null ? loteria.abreviatura + '/' + loteriaSuperpale.abreviatura : loteria.descripcion}";
    else
      descripcion = "${loteriaSuperpale != null ? loteria.abreviatura + '/' + loteriaSuperpale.abreviatura : loteria.descripcion}";

    return descripcion;
  }

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "abreviatura": abreviatura,
      "status": status,
      "primera": primera,
      "segunda": segunda,
      "tercera": tercera,
      "pick3": pick3,
      "pick4": pick4,
      "horaApertura": horaApertura,
      "horaCierre": horaCierre,
      "minutosExtras": minutosExtras,
      "sorteos" : sorteosToJson(),
      "loterias" : loteriaSuperpaleToJson(),
      "dias" : diasToJson(),
      "color" : color
    };
  }
}