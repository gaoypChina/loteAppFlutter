

import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/loterias.dart';

class Pagoscombinacion{
   int id;
   int idBanca;
   int idLoteria;
   Loteria loteria;
   double primera;
   double segunda;
   double tercera;
   double primeraSegunda;
   double primeraTercera;
   double segundaTercera;
   double tresNumeros;
   double dosNumeros;

   double primerPago;
   double pick3TodosEnSecuencia;
   double pick33Way;
   double pick36Way;
   double pick4TodosEnSecuencia;
   double pick44Way;
   double pick46Way;
   double pick412Way;
   double pick424Way;

   DateTime created_at;

  Pagoscombinacion({this.id, this.idBanca, this.idLoteria, this.loteria, this.primera = 0, this.segunda = 0, this.tercera = 0, this.primeraSegunda = 0, this.primeraTercera = 0, 
  this.segundaTercera = 0, this.tresNumeros = 0, this.dosNumeros = 0, this.primerPago = 0, this.pick3TodosEnSecuencia = 0, this.pick33Way = 0, this.pick36Way = 0, this.pick4TodosEnSecuencia = 0, this.pick44Way = 0, this.pick46Way = 0, this.pick412Way = 0, this.pick424Way = 0, this.created_at});

Pagoscombinacion.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        idBanca = Utils.toInt(snapshot['idBanca']) ?? 0,
        idLoteria = Utils.toInt(snapshot['idLoteria']) ?? 0,
        loteria = snapshot['loteria'] != null ? Loteria.fromMap(Utils.parsedToJsonOrNot(snapshot['loteria'])) : null,
        primera = double.tryParse(snapshot['primera'].toString()) ?? 0,
        segunda = double.tryParse(snapshot['segunda'].toString()) ?? 0,
        tercera = double.tryParse(snapshot['tercera'].toString()) ?? 0,
        primeraSegunda = double.tryParse(snapshot['primeraSegunda'].toString()) ?? 0,
        primeraTercera = double.tryParse(snapshot['primeraTercera'].toString()) ?? 0,
        segundaTercera = double.tryParse(snapshot['segundaTercera'].toString()) ?? 0,
        tresNumeros = double.tryParse(snapshot['tresNumeros'].toString()) ?? 0,
        dosNumeros = double.tryParse(snapshot['dosNumeros'].toString()) ?? 0,
        primerPago = double.tryParse(snapshot['primerPago'].toString()) ?? 0,
        pick3TodosEnSecuencia = double.tryParse(snapshot['pick3TodosEnSecuencia'].toString()) ?? 0,
        pick33Way = double.tryParse(snapshot['pick33Way'].toString()) ?? 0,
        pick36Way = double.tryParse(snapshot['pick36Way'].toString()) ?? 0,
        pick4TodosEnSecuencia = double.tryParse(snapshot['pick4TodosEnSecuencia'].toString()) ?? 0,
        pick44Way = double.tryParse(snapshot['pick44Way'].toString()) ?? 0,
        pick46Way = double.tryParse(snapshot['pick46Way'].toString()) ?? 0,
        pick412Way = double.tryParse(snapshot['pick412Way'].toString()) ?? 0,
        pick424Way = double.tryParse(snapshot['pick424Way'].toString()) ?? 0,
        created_at = snapshot['created_at'] != null ? DateTime.parse(snapshot['created_at']) : null
        ;

  toJson() {
    return {
      "id": id,
      "idBanca": idBanca,
      "idLoteria": idLoteria,
      "loteria": loteria != null ? loteria.toJson() : null,
      "primera": primera,
      "segunda": segunda,
      "tercera": tercera,
      "primeraSegunda": primeraSegunda,
      "primeraTercera": primeraTercera,
      "segundaTercera": segundaTercera,
      "tresNumeros": tresNumeros,
      "dosNumeros": dosNumeros,
      "primerPago" : primerPago,
      "pick3TodosEnSecuencia" : pick3TodosEnSecuencia,
      "pick33Way" : pick33Way,
      "pick36Way" : pick36Way,
      "pick4TodosEnSecuencia" : pick4TodosEnSecuencia,
      "pick44Way" : pick44Way,
      "pick46Way" : pick46Way,
      "pick412Way" : pick412Way,
      "pick424Way" : pick424Way,
      "created_at": created_at.toString(),
    };
  }

  static List pagosCombinacionesToJson(List<Pagoscombinacion> lista) {
    List jsonList = [];
    if(lista == null)
      return jsonList;

    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

}

// flutter packages pub run build_runner build