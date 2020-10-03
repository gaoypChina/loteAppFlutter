import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/notificacion.dart';
import 'package:loterias/core/services/notificationservice.dart';
import 'package:rxdart/rxdart.dart';

class VerNotificacionScreen extends StatefulWidget {
  @override
  _VerNotificacionScreenState createState() => _VerNotificacionScreenState();
}

class _VerNotificacionScreenState extends State<VerNotificacionScreen> {
  
  StreamController<List<Notificacion>> _streamController;
  bool _cargando = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Notificacion> listaNotificacion = List();

  _init() async {
    try{
      setState(() => _cargando = true);
      var parsed = await NotificationService.index(scaffoldKey: _scaffoldKey);
      listaNotificacion = (parsed["notificaciones"].toString().isNotEmpty) ? List.from(parsed["notificaciones"]) : List();
      print("NotificacionScreen parsed: $parsed");
      setState(() => _cargando = false);
      _streamController.add(listaNotificacion);
    } on Exception catch(e){
      print("NotificacionScreen error: ${e.toString()}");

      setState(() => _cargando = false);
    }
  }


// @override
//   void initState() {
//     // TODO: implement initState
//     _streamController = BehaviorSubject();
//     _init();
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificacion", style: TextStyle(color: Colors.black),),
        leading: BackButton(
          color: Utils.colorPrimary,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Visibility(
                    visible: _cargando,
                    child: Theme(
                      data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
        ],
      ),
      body: Container(),
    );
  }
}