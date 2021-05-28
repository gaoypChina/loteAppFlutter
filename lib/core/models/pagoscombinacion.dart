

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
   double pick36Way;
   double pick4TodosEnSecuencia;
   double pick44Way;
   double pick46Way;
   double pick412Way;
   double pick424Way;

   DateTime created_at;

  Pagoscombinacion(this.id, this.idBanca, this.idLoteria, this.loteria, this.primera, this.segunda, this.tercera, this.primeraSegunda, this.primeraTercera, 
  this.segundaTercera, this.tresNumeros, this.dosNumeros, this.primerPago, this.pick3TodosEnSecuencia, this.pick36Way, this.pick4TodosEnSecuencia, this.pick44Way, this.pick46Way, this.pick412Way, this.pick424Way, this.created_at);

Pagoscombinacion.fromMap(Map snapshot) :
        id = snapshot['id'] ?? 0,
        idBanca = snapshot['idBanca'] ?? 0,
        idLoteria = snapshot['idLoteria'] ?? 0,
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
        pick36Way = double.tryParse(snapshot['pick36Way'].toString()) ?? 0,
        pick4TodosEnSecuencia = double.tryParse(snapshot['pick4TodosEnSecuencia'].toString()) ?? 0,
        pick44Way = double.tryParse(snapshot['pick44Way'].toString()) ?? 0,
        pick46Way = double.tryParse(snapshot['pick46Way'].toString()) ?? 0,
        pick412Way = double.tryParse(snapshot['pick412Way'].toString()) ?? 0,
        pick424Way = double.tryParse(snapshot['pick424Way'].toString()) ?? 0,
        created_at = DateTime.parse(snapshot['created_at']) ?? null
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