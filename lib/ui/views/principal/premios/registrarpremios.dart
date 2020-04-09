import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/services/premiosservice.dart';
import 'package:rxdart/rxdart.dart';

class RegistrarPremiosScreen extends StatefulWidget {
  @override
  _RegistrarPremiosScreenState createState() => _RegistrarPremiosScreenState();
}

class _RegistrarPremiosScreenState extends State<RegistrarPremiosScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  StreamController<List<Loteria>> _streamControllerLoteria;
  List<Loteria> listaLoteria;
  int _indexLoteria = 0;
  @override
  void initState() {
    // TODO: implement initState
    _streamControllerLoteria = BehaviorSubject();
    _getLoterias();
    super.initState();
  }

  _getLoterias() async {
    listaLoteria = await PremiosService.getLoterias(scaffoldKey: _scaffoldKey);
    _streamControllerLoteria.add(listaLoteria);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Registrar premios", style: TextStyle(color: Colors.black)),
        leading: BackButton(
          color: Utils.colorPrimary,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<List<Loteria>>(
                stream: _streamControllerLoteria.stream,
                builder: (context, snapshot){
                  listaLoteria = snapshot.data;
                  if(snapshot.hasData){
                    return DropdownButton<Loteria>(
                      hint: Text("Seleccionar loteria"),
                      value: listaLoteria[_indexLoteria],
                      items: listaLoteria.map((l) => DropdownMenuItem(
                        value: l,
                        child: Text("${l.descripcion}"),
                      )).toList(),
                      onChanged: (Loteria loteria){
                        int idx = listaLoteria.indexWhere((lo) => lo.id == loteria.id);
                        if(idx != -1)
                          setState(() => _indexLoteria = idx);
                      },
                    );
                  }

                  return DropdownButton(
                    hint: Text("No hay loterias"),
                    value: "No hay loterias",
                    items: [
                      DropdownMenuItem(value: "No hay loterias", child: Text("No hay loterias"),)
                    ],
                    onChanged: (String data){

                    },
                  );
                },
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 20, left: 20),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Primera"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}