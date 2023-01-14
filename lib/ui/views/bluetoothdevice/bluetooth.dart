import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/cmd.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/services/bluetoothchannel.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:rxdart/rxdart.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<bool> _streamControllerEscaneados;
  StreamController<Map<String, dynamic>> _streamControllerGuardado;
  StreamSubscription _subscription;
  List<Map<String, dynamic>> _listaEscaneados;
  List<Map<String, dynamic>> _listaEmparejados;
  bool _existeImpresora = false;
  Map<String, dynamic> _printer;
 
                  

  @override
  void initState() {
    _listaEscaneados = [];
    _listaEmparejados = [];
    _streamControllerEscaneados = BehaviorSubject();
    _streamControllerGuardado = BehaviorSubject();
    _getPrinter();
    
    super.initState();
  }

  _initSearch() async {
    if(_subscription == null){
      _subscription = BluetoothChannel.scan().listen(_updateListaEscaneados);
    }else{
      await _stopScan();
      _subscription = BluetoothChannel.scan().listen(_updateListaEscaneados);
    }
  }

  _stopScan() async {
    if(_subscription != null)
      await _subscription.cancel();
  }

  _updateStreamGuardado(Map<String, dynamic> printer){
    _streamControllerGuardado.add(printer);
  }

  _updateListaEscaneados(map){
    if(map != null){
      var _map = Map<String, dynamic>.from(map);
      // print('_updateDevice: ${_map.toString()}');
      addTolistaEscaneados(_map);
      _streamControllerEscaneados.add(true);
    }
  }

  addTolistaEscaneados(Map<String, dynamic> map){
    if(_listaEscaneados.isEmpty){
      _listaEscaneados.add(map);
    }
    else{
      int idx = _listaEscaneados.indexWhere((l) => l["address"] == map["address"]);
      if(idx == -1){
        _listaEscaneados.add(map);
      }
    }
  }

  addToListaEmparejados(Map<String, dynamic> map){
    if(_listaEmparejados.isEmpty){
      if(map["escaneado"] == false)
        _listaEmparejados.add(map);
    }
    else{
      if(map["escaneado"] == false){
        int idx = _listaEmparejados.indexWhere((l) => l["id"] == map["id"]);
      }
    }
  }

  savePrinter(Map<String, dynamic> _printer) async {
    var c = await DB.create();
    await c.add("printer", _printer);
    var printer = await c.getValue("printer");
    _printer = printer;
    if(printer != null)
      _updateStreamGuardado(Map<String, dynamic>.from(printer));
  }

  deletePrinter() async {
    var c = await DB.create();
    await c.delete("printer");
    _getPrinter();
    // Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: 'Se ha eliminado correctamente');
    Utils.showFlushbar(context, "Se ha eliminado correctamente");

  }

  Future<Map<String, dynamic>> _getPrinter() async {
    var c = await DB.create();
    var printer = await c.getValue("printer");
    if(printer != null){
      _streamControllerGuardado.add(Map<String, dynamic>.from(printer));
    }else
      _streamControllerGuardado.add(null);

    _printer = printer;
  }

  deleteItemFromListaEscaneados(int index){
    _listaEscaneados.removeAt(index);
    _streamControllerEscaneados.add(true);
  }

  existeImpresora() async{
    var existe = await Utils.exiseImpresora();
    setState(() => _existeImpresora = existe);
  }

  _connect(normalOPrueba) async {
    BluetoothChannel.printText(content: "**PRUEBA EXISTOSA**\n\n\n", normalOPrueba: normalOPrueba);
    // BluetoothChannel.printText(content: "TE AMOOOO\n**MI REINA**\n\n\n", normalOPrueba: normalOPrueba);
  }

  _negrita(){
    // BluetoothChannel.printTextCmd(content: "**Negrita**\n\n\n", cmd: CMD.textBoldOn);
    // BluetoothChannel.printTextCmd(content: "**Negrita**\n\n\n", cmd: CMD.h2);
    Map<int, dynamic> map = Map<int, dynamic>();
    map[map.length] = {"text" : "TP JUGADA MONTO\n", "cmd" : CMD.textBoldOn};
    map[map.length] = {"text" : "TP JUGADA MONTO\n", "cmd" : CMD.h1};
    map[map.length] = {"text" : "QU 09     1.00 \n\n\n", "cmd" : CMD.h1};
    BluetoothChannel.printTextCmdMap(content: "TP JUGADA MONTO\n", map: map);
  }
  _normal(){
    BluetoothChannel.printTextCmd(content: "**Normal**\n\n\n", cmd: CMD.textBoldOff);
    BluetoothChannel.printTextCmd(content: "**Normal**\n\n\n", cmd: CMD.h2);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _stopScan();
    super.dispose();
  }


  _build(Map<String, dynamic> printer){
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.devices, size: 30,),
          title: Text(printer["name"], style: TextStyle(fontSize: 18)),
          subtitle: Text(printer["address"], style: TextStyle(fontSize: 15)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Utils.fromHex("#e4e6e8"),),
                        child: Text('Probar', style: TextStyle(color: Utils.colorPrimary, fontWeight: FontWeight.bold)),
                        onPressed: (){
                          _connect(true);
                        },
                    ),
                  ),
                ),
              )
            ),
              Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Utils.fromHex("#e4e6e8"),),
                        child: Text('Eliminar', style: TextStyle(color: Utils.colorPrimary, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          await deletePrinter();
                        },
                    ),
                  ),
                ),
              )
            )
          ],
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: SizedBox(
        //     width: double.infinity,
        //     child: ClipRRect(
        //         borderRadius: BorderRadius.circular(5),
        //         child: RaisedButton(
        //           elevation: 0,
        //           color: Utils.fromHex("#e4e6e8"),
        //           child: Text('Probar quick print', style: TextStyle(color: Utils.colorPrimary, fontWeight: FontWeight.bold)),
        //           onPressed: () async {
        //             await _connect(false);
        //           },
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Bluetooth device', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.clear, color: Utils.colorPrimary, size: 25,),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          // actions: [
          //   IconButton(icon: Icon(Icons.offline_bolt, color: Utils.colorPrimary,), onPressed: _negrita),
          //   IconButton(icon: Icon(Icons.offline_bolt_outlined, color: Utils.colorPrimary), onPressed: _normal),
          // ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                StreamBuilder(
                  stream: _streamControllerGuardado.stream,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data != null)
                        return _build(snapshot.data);
                      else
                        return Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text('No hay impresoras', style: TextStyle(fontSize: 25)),
                        );
                    }

                    return Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('No hay impresoras', style: TextStyle(fontSize: 25)),
                    );
                  },
                ),
                // RaisedButton(
                //   child: Text("Quickprint"),
                //   onPressed: (){
                //     BluetoothChannel.quickPrint();
                //   },
                // ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Utils.fromHex("#e4e6e8"),),
                            child: Text('Agregar', style: TextStyle(color: Utils.colorPrimary, fontWeight: FontWeight.bold)),
                            onPressed: (){
                              _initSearch();
                              _showDialog(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }

  _isSavedPrinter(String address){
    if(_printer == null)
      return false;
    
    return _printer["address"] == address;
  }

  _showDialog(context){
    showDialog(
      context: context,
      builder: (context){
        _scan(){
          _initSearch();
        }

        return MyAlertDialog(
          title: "Dispositivos", 
          content: StreamBuilder(
                  stream: _streamControllerEscaneados.stream,
                  builder: (BuildContext context, snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _listaEscaneados.length,
                        itemBuilder: (context, index){
                          return ListTile(
                            title: Text('${_listaEscaneados[index]["name"]}'),
                            subtitle: Text('${_listaEscaneados[index]["address"]}'),
                            dense: true,
                            trailing: IconButton(
                              icon: _isSavedPrinter(_listaEscaneados[index]["address"]) ? Icon(Icons.check) : Icon(Icons.save),
                              onPressed: () async {
                                await savePrinter(_listaEscaneados[index]);
                                Navigator.pop(context);
                                // Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: 'Se ha guardado correctamente');
                                Utils.showFlushbar(context, "Se ha guardado correctamente");
                                // deleteItemFromListaEscaneados(index);
                              },
                            ),
                          );
                        },
                      );
                    }
                    return Text('No hay datos');
                  },
                ), 
          okDescription: "Escanear",
          okFunction: _scan
        );

        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
            Text('Dispositivos'),
            // RaisedButton(
            //     child: Text('Buscar'),
            //     color: Utils.colorPrimary,
            //     onPressed: () async {
            //       _initSearch();
            //       // flutterBlue.startScan(timeout: Duration(seconds: 4));
            //       // BluetoothDevice device;

            //         // Listen to scan results
                    
            //         // flutterBlue.scan(timeout: Duration(seconds: 4)).listen((result){
            //         //   print('resultado busqueda: ${result.device}');
            //         // });
                    

            //     },
            //   ),
            ],
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Escaneados', style: TextStyle(fontSize: 18)),
              ),
              Expanded(
                flex: 1,
                child: StreamBuilder(
                  stream: _streamControllerEscaneados.stream,
                  builder: (BuildContext context, snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _listaEscaneados.length,
                        itemBuilder: (context, index){
                          return ListTile(
                            title: Text('${_listaEscaneados[index]["name"]}'),
                            subtitle: Text('${_listaEscaneados[index]["address"]}'),
                            dense: true,
                            trailing: IconButton(
                              icon: Icon(Icons.save),
                              onPressed: () async {
                                await savePrinter(_listaEscaneados[index]);
                                Navigator.pop(context);
                                Utils.showSnackBar(scaffoldKey: _scaffoldKey, content: 'Se ha guardado correctamente');
                                // deleteItemFromListaEscaneados(index);
                              },
                            ),
                          );
                        },
                      );
                    }
                    return Text('No hay datos');
                  },
                ),

                
                // child: ListView(children: <Widget>[
                //   ListTile(
                //     title: Text('Pos200'),
                //     subtitle: Text('12:21:12:B1:A2'),
                //     dense: true,
                //   ),
                //   ListTile(
                //     title: Text('Pos200'),
                //     subtitle: Text('12:21:12:B1:A2'),
                //     dense: true,
                //   ),
                //   ListTile(
                //     title: Text('Pos200'),
                //     subtitle: Text('12:21:12:B1:A2'),
                //     dense: true,
                //   ),
                // ],
                // ),
              ),
              
              
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Guardados', style: TextStyle(fontSize: 18)),
              ),

              StreamBuilder(
                  stream: _streamControllerGuardado.stream,
                  builder: (BuildContext context, snapshot){
                    if(snapshot.hasData){
                      Map<String, dynamic> map = snapshot.data;
                      return ListTile(
                        title: Text('${map["name"]}'),
                        subtitle: Text('${map["address"]}'),
                        dense: true,
                        trailing: Icon(Icons.check),
                      );
                    }

                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text('No hay printer guardados',),
                    );
                  },
                )
              
            ],
          ),
          actions: <Widget>[
            // FlatButton(
            //   onPressed: () => Navigator.pop(context), 
            //   child: Text('Cancel')
            // ),
            // FlatButton(
            //   onPressed: () => Navigator.pop(context), 
            //   child: Text('Ok')
            // )
          ],
        );
      }
    );
  }
}