import 'package:flutter/material.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/principal.dart';
import 'package:loterias/core/classes/singleton.dart';

class ProbarNullSafety extends StatefulWidget {
  @override
  _ProbarNullSafetyState createState() => _ProbarNullSafetyState();
}

class _ProbarNullSafetyState extends State<ProbarNullSafety> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  _probarNull() async {
    // bool data = await Principal.mockCheckForSession(scaffoldKey: _scaffoldKey);
    var c = await DB.create();
    await c.delete("administrador");
    await c.delete("apiKey");
    await c.delete("tipoUsuario");
    await Db.deleteDB();
    print("Dale teteo");
    Principal.cerrarSesion(context);
    // print("Todo funciono bien: ${value}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Center(
          child: FlatButton(
            child: Text("Clickear"),
            onPressed: _probarNull,
          ),
        ),
      ),
    );
  }
}