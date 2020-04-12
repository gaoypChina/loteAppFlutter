import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';

class HistoricoVentasScreen extends StatefulWidget {
  @override
  _HistoricoVentasScreenState createState() => _HistoricoVentasScreenState();
}

class _HistoricoVentasScreenState extends State<HistoricoVentasScreen> {
  var _fechaDesde = DateTime.now();
  var _fechaHasta = DateTime.now();
  String _selectedOption = "Con ventas";
  bool _cargando = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historico ventas", style: TextStyle(color: Colors.black),),
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
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 40),
            child: DropdownButton<String>(
              value: _selectedOption,
              items: [
                DropdownMenuItem(value: "Todos", child: Text("Todos"),),
                DropdownMenuItem(value: "Con ventas", child: Text("Con ventas"),),
                DropdownMenuItem(value: "Con premios", child: Text("Con premios"),),
                DropdownMenuItem(value: "Con tickets pendientes", child: Text("Con tickets pendientes"),),
              ],
              onChanged: (String data){
                setState(() => _selectedOption = data);
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Desde", style: TextStyle(fontSize: 20),),
                RaisedButton(
                  elevation: 0, 
                  color: Colors.transparent, 
                  shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
                  child: Text("${_fechaDesde.year}-${_fechaDesde.month}-${_fechaDesde.day}", style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    DateTime fecha = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                    setState(() => _fechaDesde = (fecha != null) ? fecha : _fechaDesde);
                  },
                ),
                Text("Hasta", style: TextStyle(fontSize: 20),),
                RaisedButton(
                  elevation: 0,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey, width: 1)),
                  child: Text("${_fechaHasta.year}-${_fechaHasta.month}-${_fechaHasta.day}", style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    DateTime fecha = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
                    setState(() => _fechaHasta = (fecha != null) ? fecha : _fechaHasta);
                  },
                ),
                RaisedButton(
                  elevation: 0,
                  color: Utils.fromHex("#e4e6e8"),
                  child: Text("Buscar", style: TextStyle(color: Utils.colorPrimary),),
                  onPressed: (){},
                ),
                
              ],
            )
          ],
        ),
      ),
    );
  }
}