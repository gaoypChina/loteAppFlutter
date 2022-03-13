import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/cross_platform_firebase/cross_platform_firebase.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/BlocksgeneralsJugada.dart';
import 'package:loterias/core/models/BlockslotteriesJugada.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/blocksgenerals.dart';
import 'package:loterias/core/models/blockslotteries.dart';
import 'package:loterias/core/models/blocksplays.dart';
import 'package:loterias/core/models/blocksplaysgenerals.dart';
import 'package:loterias/core/models/blocksplaysgeneralsjugadas.dart';
import 'package:loterias/core/models/blocksplaysjugadas.dart';
import 'package:loterias/core/models/duplicar.dart';
import 'package:loterias/core/models/jugadas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/lotterycolor.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/models/stockjugada.dart';
import 'package:loterias/core/models/stocks.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/models/ventas.dart';
import 'package:loterias/core/services/bluetoothchannel.dart';
import 'package:loterias/core/services/loginservice.dart';
import 'package:loterias/core/services/realtime.dart';
import 'package:loterias/core/services/ticketservice.dart';
import 'package:loterias/main.dart';
import 'package:loterias/ui/login/login.dart';
import 'package:loterias/ui/views/actualizar/actualizar.dart';
import 'package:loterias/ui/views/principal/multiselectdialogitem.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mydescripcion.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mymultiselectdialog.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';

import 'cross_platform_database/cross_platform_db.dart';
import 'cross_platform_package_info/cross_platform_package_info.dart';

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

  static Widget loteriasSeleccionadasToString(List<Loteria> loteriasSeleccionadas, Color color, {bool isSmallOrMedium = true, List<Lotterycolor> listaLotteryColor = const []}){
    if(loteriasSeleccionadas == null)
      return Text('Seleccionar loterias'.toString().toUpperCase(), style: TextStyle(color: color));
    else{
      String loterias = "";
      if(loteriasSeleccionadas.isEmpty)
        return Text('Seleccionar loterias'.toString().toUpperCase(), style: TextStyle(color: color));
        int c = 0;

      List<TextSpan> listaOfTextSpan = [];
      for(Loteria l in loteriasSeleccionadas){
        // Loteria loteria = l;
        Color _textColor;

        if(l.color != null){
          var lotterycolor = listaLotteryColor.firstWhere((element) => element.toHex() == l.color, orElse:() => null,);
          if(lotterycolor != null)
            _textColor = lotterycolor.color;

          // print("PrincipalClass loteriasSeleccionadasToString _textColor: $_textColor lottery: ${l.descripcion} : ${l.color} : listLength${listaLotteryColor.length} data: ${listaLotteryColor.firstWhere((element) => element.toHex() == l.color, orElse:() => null,)}");
        }

        if(c > 0 && (c + 1 <= loteriasSeleccionadas.length))
          listaOfTextSpan.add(
            TextSpan(
              style: TextStyle(color: Colors.grey),
              text: ", "
            )
          );

        listaOfTextSpan.add(
          TextSpan(
            style: TextStyle(color: _textColor != null ? _textColor : Colors.black, fontWeight: isSmallOrMedium ? null : FontWeight.w600),
            text: l.descripcion
          )
        );

        // loterias += (c + 1 < loteriasSeleccionadas.length) ? l.descripcion + ', ' : l.descripcion;
        c++;
      }

      return RichText(text: TextSpan(children: listaOfTextSpan));

      if(loteriasSeleccionadas.length == 1 && !isSmallOrMedium){
        Loteria loteria = loteriasSeleccionadas[0];
        Color _textColor;
        if(loteria.color != null && !isSmallOrMedium){
        var lotterycolor = listaLotteryColor.firstWhere((element) => element.toHex() == loteria.color, orElse:() => null,);
        if(lotterycolor != null)
          _textColor = lotterycolor.color;
        }

        return Text(loterias.toString().toUpperCase(), style: TextStyle(color: _textColor));
         
        // return Wrap(
        //   children: [
        //     Visibility(
        //       visible: _textColor != null,
        //       child: Padding(
        //         padding: const EdgeInsets.only(right: 8.0, top: 2),
        //         child: Container(
        //           width: 15, 
        //           height: 15, 
        //           decoration: BoxDecoration(
        //             color: _textColor != null ? _textColor : Colors.white,
        //             borderRadius: BorderRadius.circular(5)
        //           ),
        //         )
        //         // CircleAvatar(backgroundColor: _textColor != null ? _textColor : Colors.white, radius: 10,),
        //       ),
        //     ),
        //   ],
        // );
      }

      return Text(loterias.toString().toUpperCase(), style: TextStyle(color: color));
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

  static showDialogDuplicarFormulario({BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, bool isSmallOrMedium}) async {
    return await showDialog(
      context: context,
      builder: (context){
        var _formDuplicarKey = GlobalKey<FormState>();
        var _txtTicketDuplicar = TextEditingController();
        bool _cargando =false;

        

        return StatefulBuilder(
          builder: (context, setState) {

            _duplicar() async {
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
            }
            
            _widget(){
              return Form(
                key: _formDuplicarKey,
                child: TextFormField(
                  controller: _txtTicketDuplicar,
                  decoration: InputDecoration(
                    labelText: "Numero ticket"
                  ),
                  validator: (data){
                    if(data.isEmpty){
                      return 'No debe estar vacio';
                    }
                    return null;
                  },
                )
              );
            }

            return 
            true
            ?
            MyAlertDialog(
              title: "Duplicar ticket", 
              content: _widget(), 
              okFunction: _duplicar,
              xlarge: 4,
              cargando: _cargando,
              isFlat: isSmallOrMedium,
              okDescription: "Duplicar",
            )
            :
            AlertDialog(
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
              content: _widget(),
              actions: <Widget>[
                TextButton(child: Text("Cancelar"), onPressed: (){
                Navigator.of(context).pop(null);
                },),
                TextButton(child: Text("Ok"), onPressed: _duplicar,
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
              content: SingleChildScrollView(
                child: Column(
                  children: 
                    _loteriasAduplicar.map((l) => 
                    Column(
                      children: [
                        Visibility(
                          visible: mapVenta["jugadas"].indexWhere((e) => e["idSorteo"] != 4) != -1,
                          child: Row(
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
                        ),
                        Column(
                          children: l["loteriaSuperpale"].length == 0 ? [SizedBox.shrink()] : l["loteriaSuperpale"].map<Row>((e) { 
                            
                          
                          print("duplicarLlenarSuperpale: ${l["duplicarSuperpale"]}");
                          return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("SP(${l["abreviatura"]}/${e["abreviatura"]})", style: TextStyle(fontSize: 15),),
                            Flexible(
                              child: InkWell(
                                onTap: () async{
                                  print("Dentro superpaleeeeeee");
                                  
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
                                  var selectedValues = await showDialog<Set<int>>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        
                                        
                                        
                                        if(loterias.isEmpty)
                                          loterias = [];
              
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
                                    if(selectedValues == null){
                                      if(initialSelectedValues != null)
                                        selectedValues = initialSelectedValues;
                                    }
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
              ),
              actions: <Widget>[
                FlatButton(child: Text("Cancelar"), onPressed: (){
                Navigator.of(context).pop([]);
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

    static showDialogDuplicarV2({BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, Map<String, dynamic> mapVenta, List<Loteria> loterias, bool esCopiarJugadasSeleccionadas = false}) async {
    
    return await showDialog(
      context: context,
      builder: (context){
        List<Duplicar> listDuplicar = [];
        var _loteriasAduplicar = List.from(mapVenta["loterias"]);
        loterias.insert(0, Loteria(descripcion: "- NO COPIAR -", id: 0));
        loterias.insert(0, Loteria(descripcion: "- NO MOVER -", id: -1));

        for(Map<String, dynamic> l in _loteriasAduplicar){
          // l["duplicar"] = "- NO MOVER -";
          // l["duplicarId"] = 0;
          // l["duplicarSuperpale"] = "- NO MOVER -";
          // l["duplicarIdSuperpale"] = -1;
          var listaLoteriasSuperPale = List.from(l["loteriaSuperpale"]);
          if(listaLoteriasSuperPale.length > 0){
            //Insertamos solamente la loteria principal por si acaso tiene jugadas
            // listDuplicar.add(Duplicar(loteria: Loteria.fromMap(l), loteriasADuplicar: [loterias[0]]));

            //Ahora insertamos la loteria principal con sus respectivas loteriasSuperpale
            for (var item in listaLoteriasSuperPale) {
              listDuplicar.add(Duplicar(loteria: Loteria.fromMap(l), loteriaSuperpale: Loteria.fromMap(item), loteriasADuplicar: [esCopiarJugadasSeleccionadas ? loterias[1] : loterias[0]]));
            }
          }else
            listDuplicar.add(Duplicar(loteria: Loteria.fromMap(l), loteriasADuplicar: [esCopiarJugadasSeleccionadas ? loterias[1] : loterias[0]]));
        }
        
        return StatefulBuilder(
          builder: (context, setState){
            return MyAlertDialog(
              xlarge: 6,
              large: 6,
              title: "${esCopiarJugadasSeleccionadas ? 'Copiar' : 'Duplicar'}", 
              content: Wrap(
                children: listDuplicar.map((l) => 
                    Visibility(
                          // visible: mapVenta["jugadas"].indexWhere((e) => e["idSorteo"] != 4) != -1,
                          visible: true,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Wrap(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                MyDescripcon(title: "${l.loteriaSuperpale != null ? l.loteria.descripcion + '/' + l.loteriaSuperpale.descripcion : l.loteria.descripcion}", fontSize: 16,),
                                MyDropdown(
                                        title: null,
                                        leading: SizedBox.shrink(),
                                        color: esCopiarJugadasSeleccionadas ? Colors.grey[200] : null,
                                        textColor: esCopiarJugadasSeleccionadas ? Colors.black : null,
                                        hint: "${l.loteriasADuplicar.map((e) => e.descripcion).join(l.loteriaSuperpale != null ? "/" : ", ")}",
                                        onTap: () async {
                                          List<Loteria> selectedLoterias = await showDialog(
                                            context: context,
                                            builder: (context) => MyMultiSelectDialog<Loteria>(
                                              // initialSelectedValues: l.loteriasADuplicar.length > 0 ? l.,
                                              onItemTap: (data){
                                                if(data.id == 0 || data.id == -1){
                                                  Navigator.pop(context, [data]);
                                                }
                                              },
                                              initialSelectedValues: l.loteriasADuplicar.map<Loteria>((e) => e).toList(),
                                              items: loterias.length > 0 ? loterias.map<MyMultiSelectDialogItem<Loteria>>((e) => MyMultiSelectDialogItem(e, e.descripcion)).toList() : [],
                                            )
                                          );

                                
                                          if(loterias == null)
                                            setState(() => l.loteriasADuplicar = [loterias[0]]);
                                          else if(loterias.length == 0)
                                            setState(() => l.loteriasADuplicar = [loterias[0]]);
                                          else{
                                            if(selectedLoterias.length < 2 && l.loteriaSuperpale != null)
                                              setState(() => l.loteriasADuplicar = [loterias[0]]);
                                            else
                                              setState(() => l.loteriasADuplicar = selectedLoterias);
                                          }
                                        }
                                      ),
                                    
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: DropdownButton(
                                //     value: l["duplicar"].toString(),
                                //     items: loterias.map((lo) => DropdownMenuItem<String>(
                                //       value: lo.descripcion,
                                //       child: Text("${lo.descripcion}"),
                                //     )).toList(),
                                //     onChanged: (String value){
                                //       setState(() {
                                //          l["duplicar"] = value;
                                //          Loteria loteria = loterias.firstWhere((lote) => lote.descripcion == value);
                                //          l["duplicarId"] = (loteria != null) ? loteria.id : 0;
                                //       });
                                //     },
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                    ).toList()
                 ,
              ), 
              okFunction: (){
                //Vaciamos la lista loteriasADuplicar cuando tengan
                for (var item in listDuplicar) {
                  if(item.loteriasADuplicar.length == 1){
                    //Si el valor es = "- NO COPIAR -", entonces limpiamos la variable loteriasADuplicar para que no se copia ninguna loteria
                    if(item.loteriasADuplicar[0].id == 0)
                      item.loteriasADuplicar = [];
                    //Si el valor es = "- NO MOVER -", entonces le asignamos las mismas loterias 
                    else if(item.loteriasADuplicar[0].id == -1)
                       item.loteriasADuplicar = item.loteriaSuperpale != null ? [item.loteria, item.loteriaSuperpale] : [item.loteria]; 
                  }
                }
                Navigator.pop(context, listDuplicar);
              }
            );
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              title: Text('Duplicar ticket'),
              content: SingleChildScrollView(
                child: Column(
                  children: 
                    listDuplicar.map((l) => 
                    Column(
                      children: [
                        Visibility(
                          visible: mapVenta["jugadas"].indexWhere((e) => e["idSorteo"] != 4) != -1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("${l.loteria.descripcion}"),
                              Flexible(
                                child: MyResizedContainer(
                                  builder: (context, width) {
                                    return Container(
                                      width: 1,
                                      child: MyDropdown(
                                        title: null,
                                        hint: "",
                                        onTap: () async {
                                          List<Loteria> loterias = await showDialog(
                                            builder: (context) => MyMultiSelectDialog<List<Loteria>>(
                                              // initialSelectedValues: l.loteriasADuplicar.length > 0 ? l.,
                                              items: l.loteriasADuplicar.length > 0 ? l.loteriasADuplicar.map<MyMultiSelectDialogItem<Loteria>>((e) => MyMultiSelectDialogItem(e, e.descripcion)).toList() : [],
                                            )
                                          );
                              
                                          // if(loterias == null)
                                          //   l.loteriasADuplicar = [];
                                          // else if(loterias.length == 0)
                                          //   l.loteriasADuplicar = [];
                                          // else{
                              
                                          // }
                                        }
                                      ),
                                    );
                                  }
                                ),
                              )
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: DropdownButton(
                              //     value: l["duplicar"].toString(),
                              //     items: loterias.map((lo) => DropdownMenuItem<String>(
                              //       value: lo.descripcion,
                              //       child: Text("${lo.descripcion}"),
                              //     )).toList(),
                              //     onChanged: (String value){
                              //       setState(() {
                              //          l["duplicar"] = value;
                              //          Loteria loteria = loterias.firstWhere((lote) => lote.descripcion == value);
                              //          l["duplicarId"] = (loteria != null) ? loteria.id : 0;
                              //       });
                              //     },
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        // Column(
                        //   children: l["loteriaSuperpale"].length == 0 ? [SizedBox.shrink()] : l["loteriaSuperpale"].map<Row>((e) { 
                            
                          
                        //   print("duplicarLlenarSuperpale: ${l["duplicarSuperpale"]}");
                        //   return Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: <Widget>[
                        //     Text("SP(${l["abreviatura"]}/${e["abreviatura"]})", style: TextStyle(fontSize: 15),),
                        //     Flexible(
                        //       child: InkWell(
                        //         onTap: () async{
                        //           print("Dentro superpaleeeeeee");
                                  
                        //           Set<int> initialSelectedValues = Set();
                        //           if(l["duplicarIdSuperpale"] is int){
                        //             // print("initialSelectedValue int: ${l["duplicarIdSuperpale"]}");
                        //             initialSelectedValues.add(l["duplicarIdSuperpale"]);
                        //           }
                        //           else{
                        //             for(int e in l["duplicarIdSuperpale"]){
                        //               // print("initialSelectedValue array: $e");
                        //               initialSelectedValues.add(e);
                        //             }
                        //           }
                        //           var selectedValues = await showDialog<Set<int>>(
                        //               context: context,
                        //               builder: (BuildContext context) {
                                        
                                        
                                        
                        //                 if(loterias.isEmpty)
                        //                   loterias = [];
              
                        //                 var items = loterias.map((l){
                        //                   return MultiSelectDialogItem(l.id, l.descripcion, unSelectOthersItems: (l.id == 0 || l.id == -1));
                        //                 }).toList();
                        //               return MultiSelectDialog(
                        //                   items: items,
                        //                   // initialSelectedValues: [1, 3].toSet(),
                        //                   initialSelectedValues: initialSelectedValues,
                        //                 );
              
                                        
                        //               },
                        //             );
              
                        //             print("Datos seleccionados: ${selectedValues.toString()}");
                        //             if(selectedValues == null){
                        //               if(initialSelectedValues != null)
                        //                 selectedValues = initialSelectedValues;
                        //             }
                        //             if(selectedValues.length == 0)
                        //               setState(() { 
                        //                 l["duplicarSuperpale"] = "- NO COPIAR -";
                        //               });
                        //             else if(selectedValues.length == 1){
                        //               // print("selectedValues.length == 1: ${selectedValues.toList()[0]}");
                        //               Loteria loteria = loterias.firstWhere((element) => element.id == selectedValues.toList()[0]);
                        //               if(loteria == null){
                        //                 setState((){
                        //                   l["duplicarSuperpale"] = "- NO MOVER -";
                        //                   l["duplicarIdSuperpale"] = 0;
                        //                 });
                        //               }
                        //               else if(loteria.descripcion != "- NO COPIAR -" && loteria.descripcion != "- NO MOVER -"){
                        //                 setState((){
                        //                   l["duplicarSuperpale"] = "- NO MOVER -";
                        //                   l["duplicarIdSuperpale"] = 0;
                        //                 });
                        //                 Utils.showAlertDialog(context: context, content: "Debe seleccionar solamente 2 loterias", title: "Error");
                        //               }else{
                        //                 setState(() {
                        //                   l["duplicarSuperpale"] = loteria.descripcion ;
                        //                   l["duplicarIdSuperpale"] = loteria.id;
                        //                 });
                        //               }
                        //             }
                        //             else if(selectedValues.length > 2){
                        //               setState((){
                        //                 l["duplicarSuperpale"] = "- NO MOVER -";
                        //                 l["duplicarIdSuperpale"] = 0;
                        //               });
                        //               Utils.showAlertDialog(context: context, content: "Debe seleccionar solamente 2 loterias", title: "Error");
                        //             }
                        //             else{
                        //                 Loteria loteria = loterias.firstWhere((element) => element.id == selectedValues.toList()[0]);
                        //                 Loteria loteriaSuperpale = loterias.firstWhere((element) => element.id == selectedValues.toList()[1]);
                        //               setState(() {
                        //                 l["duplicarSuperpale"] = "${loteria.abreviatura} / ${loteriaSuperpale.abreviatura}";
                        //                 l["duplicarIdSuperpale"] = selectedValues.toList();
                        //               });
              
                        //               // print("dentro condicion correcta: ${loteria.descripcion} / ${loteriaSuperpale.descripcion}");
                        //             }
              
                                    
                        //         },
                        //         child: Container(
                        //           padding: EdgeInsets.all(10),
                        //           decoration: BoxDecoration(
                        //             border: Border.all(color: Colors.grey, width: 1.0),
                        //             borderRadius: BorderRadius.all(Radius.circular(5))
                        //           ),
                        //           child: Text(l["duplicarSuperpale"], style: TextStyle(fontSize: 14)),
                        //         ),
                        //       ),
                        //     )
                        //   ],
                        // );
                        // },
                        // ).toList(),
                        // )
                      
                      ],
                    )
                    
                    ).toList()
                  ,
                ),
              ),
              actions: <Widget>[
                FlatButton(child: Text("Cancelar"), onPressed: (){
                Navigator.of(context).pop([]);
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


  static showDialogPagarFormulario({BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, bool isSmallOrMedium}) async {
    return await showDialog(
      context: context,
      builder: (context){
        var _formDuplicarKey = GlobalKey<FormState>();
        var _txtTicketDuplicar = TextEditingController();
        bool _cargando = false;
        return StatefulBuilder(
          builder:(context, setState){
          
          _pagar() async {
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
          }

          _widget(){
            return Form(
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
            );
          }

           return 
           true
           ?
           MyAlertDialog(
             title: "Pagar ticket", 
             content: _widget(), 
             okFunction: _pagar,
             cargando: _cargando,
             xlarge: 4,
             isFlat: isSmallOrMedium,
              okDescription: "Pagar",
            )
            :
           AlertDialog(
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
            content: _widget(),
            actions: <Widget>[
             
              TextButton(child: Text("Cancelar"), onPressed: (){
              Navigator.of(context).pop(null);
              },),
              TextButton(child: Text("Buscar"), onPressed: _pagar,
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
        bool _showListo = false;

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
              content: SingleChildScrollView(
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
                          
                    // Flexible(
                    //   flex: 1,
                    //   child: ListView(
                    //     children: <Widget>[
                    //       Center(
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(2),
                    //           child: RichText(
                    //             text: TextSpan(
                    //               style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                    //               children: [
                    //                 TextSpan(text: "Monto:"),
                    //                 TextSpan(text: ' ${Utils.toCurrency(mapVenta["total"])}', style: TextStyle(color: Utils.colorInfo))
                    //               ]
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Center(
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(2),
                    //           child: RichText(
                    //             text: TextSpan(
                    //               style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                    //               children: [
                    //                 TextSpan(text: "Pendiente de pago:"),
                    //                 TextSpan(text: ' ${Utils.toCurrency(mapVenta["montoAPagar"])}', style: TextStyle(color: (Utils.toDouble(mapVenta["montoAPagar"].toString()) > 0) ? Colors.pink : Utils.colorInfo))
                    //               ]
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Center(
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(2),
                    //           child: RichText(
                    //             text: TextSpan(
                    //               style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                    //               children: [
                    //                 TextSpan(text: "Premio total:"),
                    //                 TextSpan(text: ' ${Utils.toCurrency(mapVenta["premio"])}', style: TextStyle(color: Utils.colorInfo))
                    //               ]
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(height: 10,),
                    //       Column(
                    //         children: _loterias.map<Widget>((l) { 
                    //           var jugadas = _getJugadasPertenecientesALoteria(l.id, _jugadas);
                              
                    //           return Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: <Widget>[
                    //             (jugadas.length > 0)
                    //             ?
                    //             Column(children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Text(l.descripcion, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    //               ),
                    //               _buildTable(jugadas)
                    //             ],)
                    //             :
                    //             SizedBox()
                    //             ,
                    //             Column(
                    //               children: l.loteriaSuperpale.map<Widget>((element) { 
                    //                 var jugadas = _getJugadasSuperpalePertenecientesALoteria(l.id, element.id, _jugadas);
                    //               if(jugadas.length > 0 )
                    //                 return Column(children:[
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0),
                    //                     child: Text("SP (${l.descripcion}/${element.descripcion})", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    //                   ),
                    //                   _buildTable(jugadas)
                    //                 ]);

                    //                 return SizedBox();
                                  
                    //               }
                    //               ).toList(),
                    //             ),
                                
                    //           ],
                    //         );}
                    //         ).toList(),
                    //       )
                    //       // _buildTable(_jugadas)
                    //     ],
                    //   ),
                    // )
                    
                  ],

                ),
              ),
              actions: <Widget>[
                Container(
                  
                ),
                FlatButton(child: Text("Cancelar"), onPressed: (){
                Navigator.of(context).pop(List());
                },),
                
                AnimatedCrossFade(
                  firstChild: FlatButton(child: Text("Pagar"), onPressed: () async {
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
                        setState((){_cargando = false;  _showListo = true; });
                        await Future.delayed(Duration(milliseconds: 1300));
                        Navigator.pop(context);
                      } on Exception catch(e){
                        setState(() => _cargando = false);
                      }

                      },
                    )
                  , 
                  secondChild: InkWell(
                    onTap: (){

                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text("Listo", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                    ),
                  ), 
                  crossFadeState: (!_showListo) ? CrossFadeState.showFirst : CrossFadeState.showSecond, 
                  duration: Duration(milliseconds: 200)
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
  //  PackageInfo packageInfo = await PackageInfo.fromPlatform();
   PackageInfo packageInfo = await CrossPlatformPackageInfo().fromPlatform();
   print("appName: ${packageInfo.appName} \npackageName: ${packageInfo.packageName} \nversion: ${packageInfo.version} \nbuildNumber: ${packageInfo.buildNumber}");
  if(version["urgente"] != 1)
    return;
    print("Principal.version: ${version}");
  if(packageInfo.buildNumber == version["version"])
    return;
  if(packageInfo.buildNumber == version["version2"])
    return;
  if(packageInfo.buildNumber == version["version3"])
    return;
     
  // if(packageInfo.buildNumber != version["version"]){
  //    Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (BuildContext context) => ActualizarScreen(version["enlace"]))
  //   );
  //   // Navigator.pushReplacementNamed(context, "actualizar", arguments: version["enlace"]);
  // }

  navigatorKey.currentState.pushAndRemoveUntil(
    MaterialPageRoute(builder: (BuildContext context) => ActualizarScreen(version["enlace"])),
    (route) => false
  );
  // Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (BuildContext context) => ActualizarScreen(version["enlace"]))
  //   );
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
   print("Principal.cerrarSesion");
   try {
      // await Utils.unSubscribeFromTopic();
      await (CrossFirebase()).unSubscribeFromTopic();
      await Db.deleteDB();
   } catch (e) {
   }

   if(c != null){
     await c.delete("administrador");
      await c.delete("apiKey");
      await c.delete("tipoUsuario");
      await c.delete("banca");
      await c.removePagoPendiente();
      // await Db.deleteDB();
      if(salir){
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

 static List<Jugada> updateMontoStockFromJugadas(StockJugada stockJugada){
   if(stockJugada.jugadas == null)
    return [];

   if(stockJugada.jugadas.length == 0)
    return [];
  
   List<Jugada> jugadasActualizadasARetornar = [];
   List<Jugada> loteriasFromJugadas = Utils.removeDuplicateLoteriasFromList(List<Jugada>.from(stockJugada.jugadas));
   List<Stock> loteriasFromStock = [];
   for (var loteriaJugada in loteriasFromJugadas) {
     List<Stock> stocks = stockJugada.stocks.where((element) => element.idLoteria == loteriaJugada.loteria.id).toList();
     if(stocks.length > 0)
      loteriasFromStock.addAll(stocks);
   }

   if(loteriasFromStock.length == 0)
    return [];

   for (var stock in loteriasFromStock) {
     if(stock.idSorteo != 4){
       print("PrincipalClasses for stock: ${stock.toJson()}");
       if(stock.esGeneral == 1 && stock.ignorarDemasBloqueos == 1){
        print("PrincipalClasses esGeneral == 1 && ignorarDemasBloqueos == 1: ${stock.toJson()}");
        int idx = stockJugada.jugadas.indexWhere((element) => element.loteria.id == stock.idLoteria && element.stock.jugada == stock.jugada && element.stock.idSorteo == stock.idSorteo && element.stock.idMoneda == stock.idMoneda);
        if(idx == -1)
          continue;

          stockJugada.jugadas[idx].stock.monto = stock.monto;
          stockJugada.jugadas[idx].stock.esGeneral = 1;
          stockJugada.jugadas[idx].stock.ignorarDemasBloqueos = 1;
          jugadasActualizadasARetornar.add(stockJugada.jugadas[idx]);
      }
      else if(stock.esGeneral == 1){
        print("PrincipalClasses esGeneral == 1: ${stock.toJson()}");
        int idx = stockJugada.jugadas.indexWhere((element) => (element.stock.esGeneral == 1 || element.stock.descontarDelBloqueoGeneral == 1) && element.stock.ignorarDemasBloqueos == 0 && element.loteria.id == stock.idLoteria && element.stock.jugada == stock.jugada && element.stock.idSorteo == stock.idSorteo && element.stock.idMoneda == stock.idMoneda);
        if(idx == -1)
          continue;

        double montoDisponible;
        if(stock.monto < stockJugada.jugadas[idx].stock.monto && stockJugada.jugadas[idx].stock.descontarDelBloqueoGeneral == 1)
          montoDisponible = stock.monto;
        else if(stockJugada.jugadas[idx].stock.descontarDelBloqueoGeneral == 1)
          montoDisponible = stockJugada.jugadas[idx].stock.monto;
        else
          montoDisponible = stock.monto;

          stockJugada.jugadas[idx].stock.monto = montoDisponible;
          jugadasActualizadasARetornar.add(stockJugada.jugadas[idx]);
        print("PrincipalClasses esGeneral == 1 index: ${stockJugada.jugadas[idx].stock.monto}");
      }
      else{
        print("PrincipalClasses esGeneral == 0: ${stock.toJson()}");
        int idx = stockJugada.jugadas.indexWhere((element) => element.stock.idBanca == stock.idBanca && element.stock.ignorarDemasBloqueos != 1 && element.loteria.id == stock.idLoteria && element.stock.jugada == stock.jugada && element.stock.idSorteo == stock.idSorteo && element.stock.idMoneda == stock.idMoneda);
        if(idx == -1)
          continue;

          stockJugada.jugadas[idx].stock.monto = stock.monto;
          stockJugada.jugadas[idx].stock.esGeneral = 0;
          jugadasActualizadasARetornar.add(stockJugada.jugadas[idx]);
      }
     }
     else{
       if(stock.esGeneral == 1 && stock.ignorarDemasBloqueos == 1){
          print("PrincipalClasses esGeneral == 1 && ignorarDemasBloqueos == 1: ${stock.toJson()}");
          int idx = stockJugada.jugadas.indexWhere((element) => element.loteria.id == stock.idLoteria && element.loteriaSuperPale.id == stock.idLoteriaSuperpale && element.stock.jugada == stock.jugada && element.stock.idSorteo == stock.idSorteo && element.stock.idMoneda == stock.idMoneda);
          if(idx == -1)
            continue;

            stockJugada.jugadas[idx].stock.monto = stock.monto;
            stockJugada.jugadas[idx].stock.esGeneral = 1;
            stockJugada.jugadas[idx].stock.ignorarDemasBloqueos = 1;
            jugadasActualizadasARetornar.add(stockJugada.jugadas[idx]);
        }
        else if(stock.esGeneral == 1){
          print("PrincipalClasses esGeneral == 1: ${stock.toJson()}");
          int idx = stockJugada.jugadas.indexWhere((element) => (element.stock.esGeneral == 1 || element.stock.descontarDelBloqueoGeneral == 1) && element.stock.ignorarDemasBloqueos == 0 && element.loteria.id == stock.idLoteria && element.loteriaSuperPale.id == stock.idLoteriaSuperpale && element.stock.jugada == stock.jugada && element.stock.idSorteo == stock.idSorteo && element.stock.idMoneda == stock.idMoneda);
          if(idx == -1)
            continue;

          double montoDisponible;
          if(stock.monto < stockJugada.jugadas[idx].stock.monto && stockJugada.jugadas[idx].stock.descontarDelBloqueoGeneral == 1)
            montoDisponible = stock.monto;
          else if(stockJugada.jugadas[idx].stock.descontarDelBloqueoGeneral == 1)
            montoDisponible = stockJugada.jugadas[idx].stock.monto;
          else
            montoDisponible = stock.monto;

            stockJugada.jugadas[idx].stock.monto = montoDisponible;
            jugadasActualizadasARetornar.add(stockJugada.jugadas[idx]);
          print("PrincipalClasses esGeneral == 1 index: ${stockJugada.jugadas[idx].stock.monto}");
        }
        else{
          print("PrincipalClasses esGeneral == 0: ${stock.toJson()}");
          int idx = stockJugada.jugadas.indexWhere((element) => element.stock.idBanca == stock.idBanca && element.stock.ignorarDemasBloqueos != 1 && element.loteria.id == stock.idLoteria && element.loteriaSuperPale.id == stock.idLoteriaSuperpale && element.stock.jugada == stock.jugada && element.stock.idSorteo == stock.idSorteo && element.stock.idMoneda == stock.idMoneda);
          if(idx == -1)
            continue;

            stockJugada.jugadas[idx].stock.monto = stock.monto;
            stockJugada.jugadas[idx].stock.esGeneral = 0;
            jugadasActualizadasARetornar.add(stockJugada.jugadas[idx]);
        }
     }
   }
   return jugadasActualizadasARetornar;
 }

 static List<Jugada> updateMontoBlocksgeneralsFromJugadas(BlocksgeneralsJugada blocksgeneralsJugada){
   if(blocksgeneralsJugada.jugadas == null)
    return [];

   if(blocksgeneralsJugada.jugadas.length == 0)
    return [];
  
   List<Jugada> jugadasActualizadasARetornar = [];
   int idDia = Utils.getIdDia();
   List<Jugada> loteriasFromJugadas = Utils.removeDuplicateLoteriasFromList(List<Jugada>.from(blocksgeneralsJugada.jugadas));
   List<Blocksgenerals> loteriasFromBlocksgenerals = [];
   for (var loteriaJugada in loteriasFromJugadas) {
     List<Blocksgenerals> stocks = blocksgeneralsJugada.blocksgenerals.where((element) => element.idLoteria == loteriaJugada.loteria.id && element.idDia == idDia).toList();
     if(stocks.length > 0)
      loteriasFromBlocksgenerals.addAll(stocks);
   }

   if(loteriasFromBlocksgenerals.length == 0)
    return [];

   for (var stock in loteriasFromBlocksgenerals) {
     List<Jugada> jugadas = blocksgeneralsJugada.jugadas.where((element) => (element.stock.esGeneral == 1 || element.stock.descontarDelBloqueoGeneral == 1) && element.stock.ignorarDemasBloqueos != 1 && element.stock.esBloqueoJugada != 1 && element.loteria.id == stock.idLoteria && element.idSorteo == stock.idSorteo && element.stock.idMoneda == stock.idMoneda).toList();
     for (var jugada in jugadas) {
       if(stock.monto != jugada.stock.monto || blocksgeneralsJugada.eliminar){
         print("PrincipalClass updateMontoBlocksgeneralsFromJugadas: ${stock.monto}");

         double montoDisponible;
         if(stock.monto < jugada.stock.monto && jugada.stock.descontarDelBloqueoGeneral == 1)
           montoDisponible = stock.monto;
         else if(jugada.stock.descontarDelBloqueoGeneral == 1)
           montoDisponible = jugada.stock.monto;
         else
           montoDisponible = stock.monto;

        jugada.stock.monto = montoDisponible;
        jugada.stockEliminado = blocksgeneralsJugada.eliminar;
        jugadasActualizadasARetornar.add(jugada);
      }
     }
   }
   return jugadasActualizadasARetornar;
 }

 static List<Jugada> updateMontoBlockslotteriesFromJugadas(BlockslotteriesJugada blockslotteriesJugada){
   if(blockslotteriesJugada.jugadas == null)
    return [];

   if(blockslotteriesJugada.jugadas.length == 0)
    return [];
  
   List<Jugada> jugadasActualizadasARetornar = [];
   int idDia = Utils.getIdDia();
   List<Jugada> loteriasFromJugadas = Utils.removeDuplicateLoteriasFromList(List<Jugada>.from(blockslotteriesJugada.jugadas));
   List<Blockslotteries> loteriasFromBlockslotteries = [];
   for (var loteriaJugada in loteriasFromJugadas) {
     List<Blockslotteries> stocks = blockslotteriesJugada.blockslotteries.where((element) => element.idLoteria == loteriaJugada.loteria.id && element.idDia == idDia).toList();
     if(stocks.length > 0)
      loteriasFromBlockslotteries.addAll(stocks);
   }

   if(loteriasFromBlockslotteries.length == 0)
    return [];

   for (var stock in loteriasFromBlockslotteries) {
         print("PrincipalClass updateMontoBlockslotteriesFromJugadas before findJugadas: ${stock.monto}");
     List<Jugada> jugadas = blockslotteriesJugada.jugadas.where((element) => element.stock.idBanca == stock.idBanca && element.stock.esBloqueoJugada != 1 && element.stock.ignorarDemasBloqueos != 1 && element.loteria.id == stock.idLoteria && element.idSorteo == stock.idSorteo && element.stock.idMoneda == stock.idMoneda).toList();
     for (var jugada in jugadas) {
       if(stock.monto != jugada.stock.monto || blockslotteriesJugada.eliminar){
         print("PrincipalClass updateMontoBlockslotteriesFromJugadas: ${stock.monto}");
        jugada.stock.monto = stock.monto;
        jugada.stock.esGeneral= 0;
        jugada.stockEliminado = blockslotteriesJugada.eliminar;
        jugadasActualizadasARetornar.add(jugada);
      }
     }
   }

   return jugadasActualizadasARetornar;
 }

 static List<Jugada> updateMontoBlocksplaysgeneralsFromJugadas(BlocksplaysgeneralsJugada blocksplaysgeneralsJugada){
   if(blocksplaysgeneralsJugada.jugadas == null)
    return [];

   if(blocksplaysgeneralsJugada.jugadas.length == 0)
    return [];
  
   List<Jugada> jugadasActualizadasARetornar = [];
   List<Jugada> loteriasFromJugadas = Utils.removeDuplicateLoteriasFromList(List<Jugada>.from(blocksplaysgeneralsJugada.jugadas));
   List<Blocksplaysgenerals> loteriasFromBlocksplaysgenerals = [];
   for (var loteriaJugada in loteriasFromJugadas) {
     List<Blocksplaysgenerals> stocks = blocksplaysgeneralsJugada.blocksplaysgenerals.where((element) => element.idLoteria == loteriaJugada.loteria.id).toList();
     if(stocks.length > 0)
      loteriasFromBlocksplaysgenerals.addAll(stocks);
   }

   if(loteriasFromBlocksplaysgenerals.length == 0)
    return [];

   for (var stock in loteriasFromBlocksplaysgenerals) {
     if(stock.ignorarDemasBloqueos == 0){
        int idx = blocksplaysgeneralsJugada.jugadas.indexWhere((element) => (element.stock.esGeneral == 1 || element.stock.descontarDelBloqueoGeneral == 1) && element.stock.ignorarDemasBloqueos == 0 && element.loteria.id == stock.idLoteria && element.idSorteo == stock.idSorteo && element.stock.jugada == stock.jugada && element.stock.idMoneda == stock.idMoneda);
        if(idx == -1)
          continue;
        if(stock.monto != blocksplaysgeneralsJugada.jugadas[idx].stock.monto || blocksplaysgeneralsJugada.eliminar){
          print("PrincipalClass updateMontoBlocksplaysgeneralsFromJugadas: ${stock.monto}");

          double montoDisponible;
          if(stock.monto < blocksplaysgeneralsJugada.jugadas[idx].stock.monto && blocksplaysgeneralsJugada.jugadas[idx].stock.descontarDelBloqueoGeneral == 1)
            montoDisponible = stock.monto;
          else if(blocksplaysgeneralsJugada.jugadas[idx].stock.descontarDelBloqueoGeneral == 1)
            montoDisponible = blocksplaysgeneralsJugada.jugadas[idx].stock.monto;
          else
            montoDisponible = stock.monto;

          blocksplaysgeneralsJugada.jugadas[idx].stock.monto = montoDisponible;
          blocksplaysgeneralsJugada.jugadas[idx].stock.esBloqueoJugada = 1; 
          blocksplaysgeneralsJugada.jugadas[idx].stockEliminado = blocksplaysgeneralsJugada.eliminar;
          jugadasActualizadasARetornar.add(blocksplaysgeneralsJugada.jugadas[idx]);
        }
     }
     else if(stock.ignorarDemasBloqueos == 1){
        int idx = blocksplaysgeneralsJugada.jugadas.indexWhere((element) => element.loteria.id == stock.idLoteria && element.idSorteo == stock.idSorteo && element.stock.jugada == stock.jugada && element.stock.idMoneda == stock.idMoneda);
        if(idx == -1)
          continue;
        if(stock.monto != blocksplaysgeneralsJugada.jugadas[idx].stock.monto || blocksplaysgeneralsJugada.eliminar){
          print("PrincipalClass updateMontoBlocksplaysgeneralsFromJugadas: ${stock.monto}");
          blocksplaysgeneralsJugada.jugadas[idx].stock.monto = stock.monto;
          blocksplaysgeneralsJugada.jugadas[idx].stock.esGeneral = 1; 
          blocksplaysgeneralsJugada.jugadas[idx].stock.esBloqueoJugada = 1; 
          blocksplaysgeneralsJugada.jugadas[idx].stock.ignorarDemasBloqueos = 1; 
          blocksplaysgeneralsJugada.jugadas[idx].stockEliminado = blocksplaysgeneralsJugada.eliminar;
          jugadasActualizadasARetornar.add(blocksplaysgeneralsJugada.jugadas[idx]);
        }
     }
   }
   return jugadasActualizadasARetornar;
 }

 static List<Jugada> updateMontoBlocksplaysFromJugadas(BlocksplaysJugada blocksplaysJugada){
   if(blocksplaysJugada.jugadas == null)
    return [];

   if(blocksplaysJugada.jugadas.length == 0)
    return [];
  
   List<Jugada> jugadasActualizadasARetornar = [];
   List<Jugada> loteriasFromJugadas = Utils.removeDuplicateLoteriasFromList(List<Jugada>.from(blocksplaysJugada.jugadas));
   List<Blocksplays> loteriasFromBlocksplays = [];
   for (var loteriaJugada in loteriasFromJugadas) {
     List<Blocksplays> stocks = blocksplaysJugada.blocksplays.where((element) => element.idLoteria == loteriaJugada.loteria.id).toList();
     if(stocks.length > 0)
      loteriasFromBlocksplays.addAll(stocks);
   }

   if(loteriasFromBlocksplays.length == 0)
    return [];

   for (var stock in loteriasFromBlocksplays) {
        int idx = blocksplaysJugada.jugadas.indexWhere((element) => element.stock.idBanca == stock.idBanca && element.stock.ignorarDemasBloqueos != 1 && element.loteria.id == stock.idLoteria && element.idSorteo == stock.idSorteo && element.stock.jugada == stock.jugada && element.stock.idMoneda == stock.idMoneda);
        if(idx == -1)
          continue;
        if(stock.monto != blocksplaysJugada.jugadas[idx].stock.monto || blocksplaysJugada.eliminar){
          print("PrincipalClass updateMontoBlocksplaysFromJugadas: ${stock.monto}");
          blocksplaysJugada.jugadas[idx].stock.monto = stock.monto;
          blocksplaysJugada.jugadas[idx].stock.esGeneral = 0; 
          blocksplaysJugada.jugadas[idx].stock.esBloqueoJugada = 1; 
          blocksplaysJugada.jugadas[idx].stockEliminado = blocksplaysJugada.eliminar;
          jugadasActualizadasARetornar.add(blocksplaysJugada.jugadas[idx]);
        }
   }
   return jugadasActualizadasARetornar;
 }


 static Widget buildRichOrTextAndConvertJugadaToLegible(String jugada, {bool isSmallOrMedium = true}){
   if(jugada.length == 4 && jugada.indexOf('+') == -1 && jugada.indexOf('-') == -1){
     return Text(jugada.substring(0, 2) + '-' + jugada.substring(2, 4), style: TextStyle(fontSize: 16));
   }
   else if(jugada.length == 3){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.substring(0, 3)),
           TextSpan(text: 'S', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
   else if(jugada.length == 4 && jugada.indexOf('+') != -1){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 16, color: Colors.black),
         children: [
           TextSpan(text: jugada.substring(0, 3)),
           TextSpan(text: 'B', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
   else if(jugada.length == 5 && jugada.indexOf('+') != -1){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 15, color: Colors.black),
         children: [
           TextSpan(text: jugada.substring(0, 4)),
           TextSpan(text: 'B', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold,)),
         ]
       ),
      );
   }
   else if(jugada.length == 5 && jugada.indexOf('-') != -1){
     return RichText(
       text: TextSpan(
         style: TextStyle(fontSize: 15, color: Colors.black),
         children: [
           TextSpan(text: jugada.substring(0, 4)),
           TextSpan(text: 'S', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
         ]
       ),
      );
   }
  else if(jugada.length == 6){
    //  return Text(jugada.substring(0, 2) + '-' + jugada.substring(2, 4) + '-' + jugada.substring(4, 6), style: TextStyle(fontSize: _isLargeAndWeb() ? 11.5 : 16));
    //  return Text(jugada.substring(0, 2) + '-' + jugada.substring(2, 4) + '-' + jugada.substring(4, 6), style: TextStyle(fontSize: !isSmallOrMedium ? 12.5 : 15, letterSpacing: -1.5));
     return Text(jugada.substring(0, 2) + '-' + jugada.substring(2, 4) + '-' + jugada.substring(4, 6), style: TextStyle(fontSize: 15),);
  }

   return Text(jugada, style: TextStyle(fontSize: 15));
 }



}