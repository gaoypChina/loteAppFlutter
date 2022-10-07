
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MedioPorElCualMostrarTicketRecarga {
  String medio;
  Widget widget;

  MedioPorElCualMostrarTicketRecarga({this.medio, this.widget});

  static String IMPRIMIR = "Imprimir";
  static String WHATSAPP = "WhatsApp";
  static String COMPARTIR = "Compartir";

  static List<MedioPorElCualMostrarTicketRecarga> getAll(){
    List<MedioPorElCualMostrarTicketRecarga> list = [];
    list.add(MedioPorElCualMostrarTicketRecarga(medio: "Imprimir", widget: Icon(Icons.print)));
    list.add(MedioPorElCualMostrarTicketRecarga(medio: "WhatsApp", widget: FaIcon(FontAwesomeIcons.whatsapp, size: 22, color: Colors.black,)));
    list.add(MedioPorElCualMostrarTicketRecarga(medio: "Compartir", widget: Icon(Icons.share)));
    return list;
  }

}