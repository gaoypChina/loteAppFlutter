import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/models/ventas.dart';
import 'package:loterias/core/services/bluetoothchannel.dart';
import 'package:loterias/core/services/loginservice.dart';
import 'package:loterias/core/services/realtime.dart';
import 'package:loterias/core/services/ticketservice.dart';
import 'package:loterias/ui/login/login.dart';
import 'package:loterias/ui/views/actualizar/actualizar.dart';
import 'package:loterias/ui/views/principal/multiselectdialogitem.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';

class Principal{
  static Future<bool> mockCheckForSession({BuildContext context, scaffoldKey}) async{
    // await Future.delayed(Duration(milliseconds: 2000), (){});
    // return false;
    var c = await DB.create();
    var value = await c.getValue("recordarme");
    if(value != null){
      if(value == true){
       try{
          var parsed = await LoginService.acceder(usuario: await c.getValue("usuario"), password: await c.getValue("password"));
          await c.add("apiKey", parsed["apiKey"]);
          await c.add("tipoUsuario", parsed["tipoUsuario"]);
          await LoginService.guardarDatos(parsed);
          // await Realtime.sincronizarTodosData(_scaffoldKey, parsed["realtime"]);
          await Realtime.sincronizarTodosDataBatch(scaffoldKey, parsed["realtime"]);
          return true;
       } catch(e){
         Principal.cerrarSesion(context);
         return false;
       }
      }else{
        await Future.delayed(Duration(milliseconds: 2000), (){});
        return false;
      }
        
    }else{
      await Future.delayed(Duration(milliseconds: 2000), (){});
    }

    return false;
  }

  static Map<String, dynamic> parseDatos(String responseBody, ) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    print('parsed: ${parsed['errores']}');
    Map<String, dynamic> map = Map<String, dynamic>();
    
    print('principal parsedDatos loterias: ${parsed}');
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
        bool _cargando =false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Duplicar ticket'),
                     Visibility(
                      visible: _cargando,
                      child: CircularProgressIndicator()
                    ),
                  ],
                ),
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
                Navigator.of(context).pop(Map<String, dynamic>());
                },),
                FlatButton(child: Text("Ok"), onPressed: () async {
                   if(_formDuplicarKey.currentState.validate()){
                     try{
                       setState(() => _cargando = true);
                      Map<String, dynamic> ticket = await TicketService.duplicar(codigoBarra: _txtTicketDuplicar.text, context: context);
                       setState(() => _cargando = false);
                      Navigator.of(context).pop(ticket);
                     }on Exception catch(e){
                       setState(() => _cargando = false);
                      //  Navigator.of(context).pop(Map<String, dynamic>());
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
    );
  }

   static showDialogDuplicar({BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, Map<String, dynamic> mapVenta, List<Loteria> loterias}) async {
    return await showDialog(
      context: context,
      builder: (context){
        var _loteriasAduplicar = List.from(mapVenta["loterias"]);
        for(Map<String, dynamic> l in _loteriasAduplicar){
          l["duplicar"] = "- NO MOVER -";
          l["duplicarId"] = 0;
          l["duplicarSuperpale"] = "- NO MOVER -";
          l["duplicarIdSuperpale"] = -1;
        }
        loterias.insert(0, Loteria(descripcion: "- NO COPIAR -", id: 0));
        loterias.insert(0, Loteria(descripcion: "- NO MOVER -", id: -1));
        return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              title: Text('Duplicar ticket'),
              content: ListView(
                children: 
                  _loteriasAduplicar.map((l) => 
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("${l["descripcion"]}"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton(
                              value: l["duplicar"].toString(),
                              items: loterias.map((lo) => DropdownMenuItem<String>(
                                value: lo.descripcion,
                                child: Text("${lo.descripcion}"),
                              )).toList(),
                              onChanged: (String value){
                                setState(() {
                                   l["duplicar"] = value;
                                   Loteria loteria = loterias.firstWhere((lote) => lote.descripcion == value);
                                   l["duplicarId"] = (loteria != null) ? loteria.id : 0;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: l["loteriaSuperpale"].map<Row>((e) { 
                          
                        
                        print("duplicarLlenarSuperpale: ${l["duplicarSuperpale"]}");
                        return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("SP(${l["abreviatura"]}/${e["abreviatura"]})", style: TextStyle(fontSize: 15),),
                          Flexible(
                            child: InkWell(
                              onTap: () async{
                                print("Dentro superpaleeeeeee");
                                

                                final selectedValues = await showDialog<Set<int>>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      
                                      Set<int> initialSelectedValues = Set();
                                      if(l["duplicarIdSuperpale"] is int){
                                        // print("initialSelectedValue int: ${l["duplicarIdSuperpale"]}");
                                        initialSelectedValues.add(l["duplicarIdSuperpale"]);
                                      }
                                      else{
                                        for(int e in l["duplicarIdSuperpale"]){
                                          // print("initialSelectedValue array: $e");
                                          initialSelectedValues.add(e);
                                        }
                                      }
                                      if(loterias.isEmpty)
                                        loterias = List();

                                      var items = loterias.map((l){
                                        return MultiSelectDialogItem(l.id, l.descripcion, unSelectOthersItems: (l.id == 0 || l.id == -1));
                                      }).toList();
                                    return MultiSelectDialog(
                                        items: items,
                                        // initialSelectedValues: [1, 3].toSet(),
                                        initialSelectedValues: initialSelectedValues,
                                      );

                                      
                                    },
                                  );

                                  print("Datos seleccionados: ${selectedValues.toString()}");
                                  if(selectedValues.length == 0)
                                    setState(() { 
                                      l["duplicarSuperpale"] = "- NO COPIAR -";
                                    });
                                  else if(selectedValues.length == 1){
                                    // print("selectedValues.length == 1: ${selectedValues.toList()[0]}");
                                    Loteria loteria = loterias.firstWhere((element) => element.id == selectedValues.toList()[0]);
                                    if(loteria == null){
                                      setState((){
                                        l["duplicarSuperpale"] = "- NO MOVER -";
                                        l["duplicarIdSuperpale"] = 0;
                                      });
                                    }
                                    else if(loteria.descripcion != "- NO COPIAR -" && loteria.descripcion != "- NO MOVER -"){
                                      setState((){
                                        l["duplicarSuperpale"] = "- NO MOVER -";
                                        l["duplicarIdSuperpale"] = 0;
                                      });
                                      Utils.showAlertDialog(context: context, content: "Debe seleccionar solamente 2 loterias", title: "Error");
                                    }else{
                                      setState(() {
                                        l["duplicarSuperpale"] = loteria.descripcion ;
                                        l["duplicarIdSuperpale"] = loteria.id;
                                      });
                                    }
                                  }
                                  else if(selectedValues.length > 2){
                                    setState((){
                                      l["duplicarSuperpale"] = "- NO MOVER -";
                                      l["duplicarIdSuperpale"] = 0;
                                    });
                                    Utils.showAlertDialog(context: context, content: "Debe seleccionar solamente 2 loterias", title: "Error");
                                  }
                                  else{
                                      Loteria loteria = loterias.firstWhere((element) => element.id == selectedValues.toList()[0]);
                                      Loteria loteriaSuperpale = loterias.firstWhere((element) => element.id == selectedValues.toList()[1]);
                                    setState(() {
                                      l["duplicarSuperpale"] = "${loteria.abreviatura} / ${loteriaSuperpale.abreviatura}";
                                      l["duplicarIdSuperpale"] = selectedValues.toList();
                                    });

                                    // print("dentro condicion correcta: ${loteria.descripcion} / ${loteriaSuperpale.descripcion}");
                                  }

                                  
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                child: Text(l["duplicarSuperpale"], style: TextStyle(fontSize: 14)),
                              ),
                            ),
                          )
                        ],
                      );
                      },
                      ).toList(),
                      )
                    ],
                  )
                  
                  ).toList()
                ,
              ),
              actions: <Widget>[
                FlatButton(child: Text("Cancelar"), onPressed: (){
                Navigator.of(context).pop(List());
                },),
                FlatButton(child: Text("Agregar"), onPressed: () async {
                    print("${_loteriasAduplicar.toList()}");
                    Navigator.of(context).pop(_loteriasAduplicar);
                  },
                )
              ],
            );
          },
        );
      }
    );
  }


  static showDialogPagarFormulario({BuildContext context, GlobalKey<ScaffoldState> scaffoldKey}) async {
    return await showDialog(
      context: context,
      builder: (context){
        var _formDuplicarKey = GlobalKey<FormState>();
        var _txtTicketDuplicar = TextEditingController();
        bool _cargando = false;
        return StatefulBuilder(
          builder:(context, setState){
           return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Pagar ticket'),
                 Visibility(
                  visible: _cargando,
                  child: CircularProgressIndicator()
                ),
              ],
            ),
            content: Form(
              key: _formDuplicarKey,
              child: TextFormField(
                controller: _txtTicketDuplicar,
                decoration: InputDecoration(labelText: "Codigo"),
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
              Navigator.of(context).pop(Map<String, dynamic>());
              },),
              FlatButton(child: Text("Buscar"), onPressed: () async {
                 if(_formDuplicarKey.currentState.validate()){
                   try {
                      setState(() => _cargando = true);
                      Map<String, dynamic> ticket = await TicketService.buscarTicketAPagar(codigoBarra: _txtTicketDuplicar.text,context: context);
                      setState(() => _cargando = false);
                      Navigator.of(context).pop(ticket);
                   } on Exception catch (e) {
                     setState(() => _cargando = false);
                      // Utils.showAlertDialog(context: context, content: "Error");
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
    );
  }


  static showDialogPagar({BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, Map<String, dynamic> mapVenta, List<Loteria> loterias}) async {
    return await showDialog(
      context: context,
      builder: (context){
        var _loterias = mapVenta['loterias'].map<Loteria>((json) => Loteria.fromMap(json)).toList();
        List<Jugada> _jugadas = mapVenta['jugadas'].map<Jugada>((json) => Jugada.fromMap(json)).toList();
        bool tieneJugadasPendientes = (_jugadas.indexWhere((j) => j.status == 0) != -1);
        bool _cargando = false;

        _getJugadasPertenecientesALoteria(int idLoteria, List<Jugada> jugadas){
          return jugadas.where((element) => element.idLoteria == idLoteria && element.sorteo != "Super pale").toList();
        }

        _getJugadasSuperpalePertenecientesALoteria(int idLoteria, int idLoteriaSuperpale, List<Jugada> jugadas){
          return jugadas.where((element) => element.idLoteria == idLoteria && element.idLoteriaSuperpale == idLoteriaSuperpale && element.sorteo == "Super pale").toList();
        }

        print("Tiene pendientes: $tieneJugadasPendientes");
        return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Pagar ticket'),
                   Visibility(
                    visible: _cargando,
                    child: CircularProgressIndicator()
                  ),
                ],
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: (_jugadas.length < 18) ? 300 : MediaQuery.of(context).size.height - 100),
                child: Column(
                  children: <Widget>[
                    Text('Leyenda', style: TextStyle(fontSize: 25, color: Colors.grey[500])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Utils.colorInfo
                          ),
                          child: Center(child: Text('Ganador')),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Utils.colorRosa
                          ),
                          child: Center(child: Text('Perdedor')),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Utils.colorGris
                          ),
                          child: Center(child: Text('Pendiente')),
                        )
                      ],
                    ),
                    Flexible(
                      flex: 1,
                      child: ListView(
                        children: <Widget>[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                                  children: [
                                    TextSpan(text: "Monto:"),
                                    TextSpan(text: ' ${Utils.toCurrency(mapVenta["total"])}', style: TextStyle(color: Utils.colorInfo))
                                  ]
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                                  children: [
                                    TextSpan(text: "Pendiente de pago:"),
                                    TextSpan(text: ' ${Utils.toCurrency(mapVenta["montoAPagar"])}', style: TextStyle(color: (Utils.toDouble(mapVenta["montoAPagar"].toString()) > 0) ? Colors.pink : Utils.colorInfo))
                                  ]
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                                  children: [
                                    TextSpan(text: "Premio total:"),
                                    TextSpan(text: ' ${Utils.toCurrency(mapVenta["premio"])}', style: TextStyle(color: Utils.colorInfo))
                                  ]
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Column(
                            children: _loterias.map<Widget>((l) { 
                              var jugadas = _getJugadasPertenecientesALoteria(l.id, _jugadas);
                              
                              return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                (jugadas.length > 0)
                                ?
                                Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(l.descripcion, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                  ),
                                  _buildTable(jugadas)
                                ],)
                                :
                                SizedBox()
                                ,
                                Column(
                                  children: l.loteriaSuperpale.map<Widget>((element) { 
                                    var jugadas = _getJugadasSuperpalePertenecientesALoteria(l.id, element.id, _jugadas);
                                  if(jugadas.length > 0 )
                                    return Column(children:[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("SP (${l.descripcion}/${element.descripcion})", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      ),
                                      _buildTable(jugadas)
                                    ]);

                                    return SizedBox();
                                  
                                  }
                                  ).toList(),
                                ),
                                
                              ],
                            );}
                            ).toList(),
                          )
                          // _buildTable(_jugadas)
                        ],
                      ),
                    )
                    
                  ],

                ),
              ),
              actions: <Widget>[
                FlatButton(child: Text("Cancelar"), onPressed: (){
                Navigator.of(context).pop(List());
                },),
                FlatButton(child: Text("Pagar"), onPressed: () async {
                    if(tieneJugadasPendientes){
                        if(await Utils.exiseImpresora() == false){
                          Utils.showAlertDialog(title: "Alerta", content: "Debe registrar una impresora", context: context);
                          return;
                        }

                        if(!(await BluetoothChannel.turnOn())){
                          return;
                        }
                      }

                      try{
                        setState(() => _cargando = true);
                        Map<String, dynamic> datos = await TicketService.pagar(context: context, codigoBarra: mapVenta["codigoBarra"]);
                        if(datos.isNotEmpty){
                          if(tieneJugadasPendientes){
                            BluetoothChannel.printTicket(datos["venta"], BluetoothChannel.TYPE_PAGADO);
                          }
                        }
                        setState(() => _cargando = false);
                        Navigator.pop(context);
                      } on Exception catch(e){
                        setState(() => _cargando = false);
                      }

                  },
                )
              ],
            );
          },
        );
      }
    );
  }

  static Widget _buildTable(List<Jugada> jugadas){
   var tam = jugadas.length;
   List<TableRow> rows;
   if(tam == 0){
     rows = <TableRow>[
          
        ];
   }else{
     rows = jugadas.map((j)
          => TableRow(
            decoration: BoxDecoration(color: Utils.colorGanadorPerdedorPendiente(j.status, j.premio)),
            children: [
              Center(child: Text(j.jugada, style: TextStyle(fontSize: 13))),
              Center(child: Text(j.sorteo, style: TextStyle(fontSize: 13))),
              Center(child: Text(Utils.toCurrency(j.monto.toString()), style: TextStyle(fontSize: 13))),
              Center(child: Text(Utils.toCurrency(j.premio.toString()), style: TextStyle(fontSize: 13))),
              // Center(child: Text(j.monto.toString(), style: TextStyle(fontSize: 16))),
            ],
          )
        
        ).toList();
        
    rows.insert(0, 
              TableRow(
                children: [
                  // buildContainer(Colors.blue, 50.0),
                  // buildContainer(Colors.red, 50.0),
                  // buildContainer(Colors.blue, 50.0),
                  Center(child: Text('Jugada', style: TextStyle(fontSize: 18, color: Colors.grey))),
                  Center(child: Text('Sorteo', style: TextStyle(fontSize: 18, color: Colors.grey)),),
                  Center(child: Text('Monto', style: TextStyle(fontSize: 18, color: Colors.grey)),),
                  Center(child: Text('Premio', style: TextStyle(fontSize: 18, color: Colors.grey)),),
                  // Center(child: Text('Borrar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),),
                ]
              )
              );
        
   }


  return Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: <int, TableColumnWidth>{1 : FractionColumnWidth(.35)},
            children: rows,
           );

  return Flexible(
      child: ListView(
      children: <Widget>[
        Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: <int, TableColumnWidth>{0 : FractionColumnWidth(.35)},
            children: rows,
           ),
      ],
    ),
  );
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: 
     SingleChildScrollView(
       scrollDirection: Axis.vertical,
       child: Container(
         child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: <int, TableColumnWidth>{0 : FractionColumnWidth(.35)},
          children: rows,
         ),
       ),
     )
  //    DataTable(
  //      columnSpacing: 4,
  //      onSelectAll: null,
       
  //     columns: [
  //       DataColumn(label: Text('Loteria', style: TextStyle( fontWeight: FontWeight.bold),)),
  //       DataColumn(
  //         label: Text('Jugada', style: TextStyle( fontWeight: FontWeight.bold)), 
  //       ),
  //       DataColumn(
  //         label: Text('Monto', style: TextStyle( fontWeight: FontWeight.bold)), 
  //         // numeric: true
          
  //       ),
  //       DataColumn(
  //         label: Text('Eliminar', style: TextStyle( fontWeight: FontWeight.bold)), 
  //       ),
  //     ],
  //     rows: rows,
  // ),
   );
 }

 static version({Map<String, dynamic> version, BuildContext context}) async {
   PackageInfo packageInfo = await PackageInfo.fromPlatform();
   print("appName: ${packageInfo.appName} \npackageName: ${packageInfo.packageName} \nversion: ${packageInfo.version} \nbuildNumber: ${packageInfo.buildNumber}");
  if(version["urgente"] != 1)
    return;
    print("Principal.version: ${version}");
  if(packageInfo.buildNumber != version["version"]){
     Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => ActualizarScreen(version["enlace"]))
    );
    // Navigator.pushReplacementNamed(context, "actualizar", arguments: version["enlace"]);
  }
 }

 static showVersion({Map<String, dynamic> version, BuildContext context}) async {
   PackageInfo packageInfo = await PackageInfo.fromPlatform();
   print("appName: ${packageInfo.appName} \npackageName: ${packageInfo.packageName} \nversion: ${packageInfo.version} \nbuildNumber: ${packageInfo.buildNumber}");
  Utils.showAlertDialog(context: context, title: "Version", content: "Version ${packageInfo.version}+${packageInfo.buildNumber}");
  // if(packageInfo.buildNumber != version["version"]){
  //    Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (BuildContext context) => ActualizarScreen(version["enlace"]))
  //   );
  //   // Navigator.pushReplacementNamed(context, "actualizar", arguments: version["enlace"]);
  // }
 }

 

 static cerrarSesion(BuildContext context, [bool salir = true]) async {
   var c = await DB.create();
   if(c != null){
     await c.delete("administrador");
      await c.delete("apiKey");
      await c.delete("tipoUsuario");
      await Db.deleteDB();
      if(salir){
        await c.delete("banca");
        await c.add("recordarme", false);
        await c.delete("usuario");
        await c.delete("password");
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (BuildContext context) => LoginScreen())
        // );
        Navigator.pushReplacementNamed(context, "/login");
      }
   }
   else
    Navigator.pushReplacementNamed(context, "/login");
 }

 static seleccionarServidor(BuildContext context, List<Servidor> listaServidor, String servidorActual){
    bool _cargando = false;
   return showDialog(
     context: context,
     builder: (context){
       return StatefulBuilder(
            builder: (context, setState){
               return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Cambiar servidor'),
                     Visibility(
                      visible: _cargando,
                      child: CircularProgressIndicator()
                    ),
                  ],
                ),
                content: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: ListView.builder(
                    itemCount: listaServidor.length,
                    itemBuilder: (context, index){
                      return CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(listaServidor[index].descripcion),
                        onChanged: (bool value){
                          setState(() => servidorActual = listaServidor[index].descripcion);
                        },
                        value: servidorActual == listaServidor[index].descripcion,
                      );
                    },
                  ),
                ),
                actions: <Widget>[
                  FlatButton(onPressed: (){Navigator.pop(context, null);}, child: Text("Cancelar")),
                  FlatButton(onPressed: () async {
                   try {
                     setState(() => _cargando = true);
                    Usuario usuario = Usuario.fromMap(await Db.getUsuario());
                    var parsed = await LoginService.cambiarServidor(usuario: usuario.usuario, servidor: servidorActual, context: context);
                    print("Principal.dar drawer cambiar: ${parsed["apiKey"]}");
                    await Principal.cerrarSesion(context, false);
                    await Db.deleteDB();
                    var c = await DB.create();
                    await c.add("apiKey", parsed["apiKey"]);
                    await c.add("idUsuario", parsed["usuario"]["id"]);
                    await c.add("administrador", parsed["administrador"]);
                    await c.add("tipoUsuario", parsed["tipoUsuario"]);
                    await LoginService.guardarDatos(parsed);
                    print("Principal.dar drawer cambiar: ${await c.getValue("apiKey")}");
                    setState(() => _cargando = false);
                    Navigator.pop(context, servidorActual);
                   } catch (e) {
                     setState(() => _cargando = false);
                     print("Error: ${e.toString()}");
                   }
                  }, child: Text("Cambiar")),
                ],
              );
            },
       );
     }
   );
 }

}