import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mynotification.dart';

class Prueba2 extends StatefulWidget {
  @override
  _Prueba2State createState() => _Prueba2State();
}

class _Prueba2State extends State<Prueba2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Prueba2"),),
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(8),
            child: GestureDetector(child: Icon(Icons.notifications, size: 30), onTap: (){
              // Navigator.of(context).pushNamed('/notificaciones');
              MyNotification.show(title: "Hola", subtitle: "Esta baina esta fea", content: "Es para probar que las notificaciones se ejecutan bien", route: "/bluetooth");
            }),
          ),
      ),
    );
  }
}