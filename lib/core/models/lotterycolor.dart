
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';

class Lotterycolor {
  int id;
  String name;
  Color color;
  Color color900;

  Lotterycolor({this.id, this.name, this.color, this.color900});

  Lotterycolor.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        name = snapshot['name'] ?? ''
        ;

  static List<Lotterycolor> getAll(){
    List<Lotterycolor> list = [];
    list.add(Lotterycolor(name: "Azul", color: Colors.blue, color900: Colors.blue[900]));
    list.add(Lotterycolor(name: "Verde", color: Colors.green, color900: Colors.green[900]));
    list.add(Lotterycolor(name: "Rojo", color: Colors.red, color900: Colors.red[900]));
    list.add(Lotterycolor(name: "Rosa", color: Colors.pink, color900: Colors.pink[900]));
    list.add(Lotterycolor(name: "Naranja", color: Colors.orange[600], color900: Colors.orange[900]));
    list.add(Lotterycolor(name: "Amarillo", color: Colors.yellow[700], color900: Colors.yellow[900]));
    list.add(Lotterycolor(name: "Marrón", color: Colors.brown, color900: Colors.brown[900]));
    list.add(Lotterycolor(name: "Morado", color: Colors.purple, color900: Colors.purple[900]));
    list.add(Lotterycolor(name: "Morado oscuro", color: Colors.deepPurple, color900: Colors.deepPurple[900]));
    list.add(Lotterycolor(name: "Cian", color: Colors.cyan[400], color900: Colors.cyan[900]));
    list.add(Lotterycolor(name: "Verde azulado", color: Colors.teal[700], color900: Colors.teal[900]));
    list.add(Lotterycolor(name: "Gris azulado", color: Colors.blueGrey, color900: Colors.blueGrey[900]));
    list.add(Lotterycolor(name: "Azul índigo", color: Colors.indigo, color900: Colors.indigo[900]));
    list.add(Lotterycolor(name: "Verde limon", color: Colors.lime, color900: Colors.lime[900]));
    list.add(Lotterycolor(name: "Verde claro", color: Colors.lightGreen, color900: Colors.lightGreen[900]));
    list.add(Lotterycolor(name: "Azul claro", color: Colors.lightBlue[600], color900: Colors.lightBlue[900]));
    list.add(Lotterycolor(name: "Cian oscuro", color: Colors.cyan[900], color900: Colors.cyanAccent[900]));
    list.add(Lotterycolor(name: "Negro", color: Colors.black, color900: Colors.amberAccent[900]));
    list.add(Lotterycolor(name: "Azul oscuro", color: Colors.blue[900], color900: Colors.amberAccent[900]));
    return list;
  }

  String toHex(){
    return color.value.toRadixString(16);
  }

  toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}