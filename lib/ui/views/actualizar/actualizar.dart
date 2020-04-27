import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';

class ActualizarScreen extends StatefulWidget {
  @override
  _ActualizarScreenState createState() => _ActualizarScreenState();
}

class _ActualizarScreenState extends State<ActualizarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Actualizar app", style: TextStyle(color: Colors.black),),
        // leading: BackButton(
        //   color: Utils.colorPrimary,
        // ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
         
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Text("Debe actualizar la app"),
              RaisedButton(
                  elevation: 0,
                  color: Utils.colorInfo,
                  child: Text("Imprimir",),
                  onPressed: (){
                    
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}