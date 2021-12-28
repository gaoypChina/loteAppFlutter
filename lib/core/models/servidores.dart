import 'package:flutter/material.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/widgets/mymultiselect.dart';

class Servidor{
   int id;
   String descripcion;
   String cliente;
   int pordefecto;
   int diaPago;
   int diasGracia;
   double precioPorBanca;
   DateTime fechaProximoPago;

  Servidor({this.id, this.descripcion, this.pordefecto, this.cliente, this.precioPorBanca, this.fechaProximoPago, this.diaPago, this.diasGracia});

Servidor.fromMap(Map snapshot) :
        id = Utils.toInt(snapshot['id']) ?? 0,
        descripcion = snapshot['descripcion'] ?? '',
        pordefecto = Utils.toInt(snapshot['pordefecto']) ?? 0,
        cliente = snapshot['cliente'] ?? '',
        fechaProximoPago = snapshot['fechaProximoPago'] != null ? DateTime.parse(snapshot['fechaProximoPago']) : null,
        diaPago = Utils.toInt(snapshot['diaPago'], returnNullIfNotInt: true),
        diasGracia = Utils.toInt(snapshot['diasGracia'], returnNullIfNotInt: true),
        precioPorBanca = Utils.toDouble(snapshot['precioPorBanca'],)
        ;

  toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "pordefecto": pordefecto,
    };
  }

  toJsonFull() {
    return {
      "id": id,
      "descripcion": descripcion,
      "pordefecto": pordefecto,
      "cliente": cliente,
      "fechaProximoPago": fechaProximoPago != null ? fechaProximoPago.toString() : null,
      "diaPago": diaPago,
      "diasGracia": diasGracia,
      "precioPorBanca": precioPorBanca,
    };
  }

  static List servidorToJson(List<Servidor> lista) {
    List jsonList = [];
    lista.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

  static Future<List<Servidor>> all(BuildContext context) async {
    var datosServidor = await Db.query("Servers");
    if(datosServidor == null)
      return [];

    List<Servidor> listaServidor = datosServidor.map<Servidor>((json) => Servidor.fromMap(json)).toList();

    var dataRetornada = await showDialog(
      context: context, 
      builder: (context){
        return MyMultiselect(
          title: "Selecc. servidores",
          items: listaServidor.map((e) => MyValue(value: e, child: "${e.descripcion}")).toList(),
          initialSelectedItems: []
        );
      }
    );

    if(dataRetornada != null)
      return List<Servidor>.from(dataRetornada);
    else
      return [];
  }

}