import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';

class TransaccionesScreen extends StatefulWidget {
  @override
  _TransaccionesScreenState createState() => _TransaccionesScreenState();
}

class _TransaccionesScreenState extends State<TransaccionesScreen> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  bool _cargando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
            color: Utils.colorPrimary,
          ),
          title: Text("Transacciones", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0,
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.pushNamed(context, "/addTransacciones");
          },
        ),
    );
  }
}