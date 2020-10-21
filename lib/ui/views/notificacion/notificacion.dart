import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/notificacion.dart';
import 'package:loterias/core/services/notificationservice.dart';
import 'package:rxdart/rxdart.dart';

class NotificacionScreen extends StatefulWidget {
  @override
  _NotificacionScreenState createState() => _NotificacionScreenState();
}

class _NotificacionScreenState extends State<NotificacionScreen> {
  StreamController<List<Notificacion>> _streamController;
  bool _cargando = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Notificacion> listaNotificacion = List();

  _init() async {
    try{
      setState(() => _cargando = true);
      var parsed = await NotificationService.index(scaffoldKey: _scaffoldKey);
      print("NotificacionScreen parsed: $parsed");
      listaNotificacion = (parsed["notificaciones"].toString().isNotEmpty) ? parsed["notificaciones"].map<Notificacion>((json) => Notificacion.fromMap(json)).toList() : List();
      setState(() => _cargando = false);
      _streamController.add(listaNotificacion);
    } on Exception catch(e){
      print("NotificacionScreen error: ${e.toString()}");

      setState(() => _cargando = false);
    }
  }


@override
  void initState() {
    // TODO: implement initState
    _streamController = BehaviorSubject();
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificaciones", style: TextStyle(color: Colors.black),),
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
          IconButton(icon: Icon(Icons.edit), onPressed: (){Navigator.of(context).pushNamed('/verNotificaciones');})
        ],
      ),
      body: Container(
        child: StreamBuilder<List<Notificacion>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if(snapshot.hasData)
              return ListView.builder(
              itemCount: listaNotificacion.length,
              itemBuilder: (context, index){
                return ListTile(
                  trailing: Text("${Jiffy(listaNotificacion[index].created_at).fromNow()}"),
                  //Column(
                  //   children: [
                  //     Text("${Jiffy(listaNotificacion[index].created_at).fromNow()}"),
                  //     FlatButton(child: Text("Ver"), onPressed: null,)
                  //     // Text("${Utils.toDosDigitos(listaNotificacion[index].created_at.day.toString())}-${Utils.toDosDigitos(listaNotificacion[index].created_at.month.toString())}-${listaNotificacion[index].created_at.year}"),
                  //     // Text("${Utils.toDosDigitos(listaNotificacion[index].created_at.hour.toString())}:${Utils.toDosDigitos(listaNotificacion[index].created_at.second.toString())}")
                  //   ],
                  // ),
                  title: Text(listaNotificacion[index].titulo, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(listaNotificacion[index].subtitulo),
                  isThreeLine: true,
                  onTap: (){
                    Navigator.pushNamed(context, "/verNotificaciones", arguments: listaNotificacion[index]);
                  },
                  // isThreeLine: true,
                );
              },
            );

            return Text("No hay datos");
          }
        ),
      ),
    );
  }
}