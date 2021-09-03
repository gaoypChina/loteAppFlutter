import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/tipos.dart';

class Ajuste {
  int id;
  String consorcio;
  int idTipoFormatoTicket;
  int imprimirNombreConsorcio;
  Tipo tipoFormatoTicket;
  String descripcionTipoFormatoTicket;
  int cancelarTicketWhatsapp;
  int imprimirNombreBanca;
  int pagarTicketEnCualquierBanca;

  Ajuste({this.id, this.consorcio, this.imprimirNombreConsorcio, this.tipoFormatoTicket, this.descripcionTipoFormatoTicket, this.pagarTicketEnCualquierBanca});

  Ajuste.fromMap(Map snapshot) :
        id = snapshot['id'] != null ? Utils.toInt(snapshot['id']) : 0,
        consorcio = snapshot['consorcio'] ?? '',
        imprimirNombreConsorcio = snapshot['imprimirNombreConsorcio'] != null ? Utils.toInt(snapshot['imprimirNombreConsorcio']) : 1,
        idTipoFormatoTicket = snapshot['idTipoFormatoTicket'] != null ? Utils.toInt(snapshot['idTipoFormatoTicket'], returnNullIfNotInt: true) : null,
        tipoFormatoTicket = (snapshot['tipoFormatoTicket'] != null) ? Tipo.fromMap(Utils.parsedToJsonOrNot(snapshot['tipoFormatoTicket'])) : null,
        descripcionTipoFormatoTicket = (snapshot['descripcionTipoFormatoTicket'] != null) ? snapshot["descripcionTipoFormatoTicket"] : '',
        cancelarTicketWhatsapp = snapshot['cancelarTicketWhatsapp'] != null ? Utils.toInt(snapshot['cancelarTicketWhatsapp']) : 1,
        imprimirNombreBanca = snapshot['imprimirNombreBanca'] != null ? Utils.toInt(snapshot['imprimirNombreBanca']) : 1,
        pagarTicketEnCualquierBanca = snapshot['pagarTicketEnCualquierBanca'] != null ? Utils.toInt(snapshot['pagarTicketEnCualquierBanca']) : 1
        // permisos = permisosToMap(snapshot['permisos']) ?? List()
        ;



  toJson() {
    return {
      "id": id,
      "consorcio": consorcio,
      "imprimirNombreConsorcio": imprimirNombreConsorcio,
      "idTipoFormatoTicket": idTipoFormatoTicket,
      "tipoFormatoTicket": (tipoFormatoTicket != null) ? tipoFormatoTicket.toJson() : null,
      "descripcionTipoFormatoTicket" : descripcionTipoFormatoTicket,
      "cancelarTicketWhatsapp": cancelarTicketWhatsapp,
      "imprimirNombreBanca": imprimirNombreBanca,
      "pagarTicketEnCualquierBanca": pagarTicketEnCualquierBanca,
    };
  }
}