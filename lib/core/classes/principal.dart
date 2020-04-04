import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/ventas.dart';
import 'package:loterias/core/services/ticketservice.dart';

class Principal{
  static Map<String, dynamic> parseDatos(String responseBody, ) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    print('parsed: ${parsed['errores']}');
    Map<String, dynamic> map = Map<String, dynamic>();
    
    print('principal parsedDatos loterias: ${parsed['loterias']}');
    map["bancas"] = parsed['bancas'].map<Banca>((json) => Banca.fromMap(json)).toList();
    map["loterias"] = parsed['loterias'].map<Loteria>((json) => Loteria.fromMap(json)).toList();
    map["ventas"] = parsed['ventas'].map<Venta>((json) => Venta.fromMap(json)).toList();
    map["idVenta"] = parsed['idVenta'];
    map["errores"] = parsed['errores'];
    map["mensaje"] = parsed['mensaje'];
    map["venta"] = parsed['venta'];
    map["img"] = parsed['img'];
    print(parsed['ventas']);
    // map["bancas"] = "jean";
    return map;
    // parsed['bancas'].map<Banca>((json) => Banca.fromMap(json)).toList();
    // return parsed.map<Banca>((json) => Banca.fromMap(json)).toList();
    // return true;
  }

  static loteriasSeleccionadasToString(List<Loteria> loteriasSeleccionadas){
    if(loteriasSeleccionadas == null)
      return 'Seleccionar loterias';
    else{
      String loterias = "";
      if(loteriasSeleccionadas.isEmpty)
        return 'Seleccionar loterias';
        int c = 0;
      for(Loteria l in loteriasSeleccionadas){
        loterias += (c + 1 < loteriasSeleccionadas.length) ? l.descripcion + ', ' : l.descripcion;
        c++;
      }
      return loterias;
    }
  }

  static List loteriaToJson(List<Loteria> loterias) {
    List jsonList = List();
    loterias.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

  static List jugadaToJson(List<Jugada> jugadas) {
    List jsonList = List();
    jugadas.map((u)=>
      jsonList.add(u.toJson())
    ).toList();
    return jsonList;
  }

  static showDialogDuplicarFormulario({BuildContext context, GlobalKey<ScaffoldState> scaffoldKey}) async {
    return await showDialog(
      context: context,
      builder: (context){
        var _formDuplicarKey = GlobalKey<FormState>();
        var _txtTicketDuplicar = TextEditingController();
        return AlertDialog(
          title: Text('Duplicar ticket'),
          content: Form(
            key: _formDuplicarKey,
            child: TextFormField(
              controller: _txtTicketDuplicar,
              validator: (data){
                if(data.isEmpty){
                  return 'No debe estar vacio';
                }
                return null;
              },
            )
          ),
          actions: <Widget>[
            FlatButton(child: Text("Cancelar"), onPressed: (){
            Navigator.of(context).pop();
            },),
            FlatButton(child: Text("Agregar"), onPressed: () async {
               if(_formDuplicarKey.currentState.validate()){
                 Navigator.of(context).pop("El culo");
                 var ticket = await TicketService.duplicar(codigoBarra: _txtTicketDuplicar.text,scaffoldKey: scaffoldKey);
                 if(ticket != null){
                   print("ticket: $ticket");
                 }
               }
              // });
              },
            )
          ],
        );
      }
    );
  }

}