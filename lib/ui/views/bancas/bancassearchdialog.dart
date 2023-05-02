import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/ui/widgets/myfilterv2.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:rxdart/rxdart.dart';

class BancasSearchDialog extends StatefulWidget {
  final List<Banca> bancas;
  // List<Banca> bancasFiltradas = [];
  final List<Banca> bancasSeleccionadas;
  final List<Grupo> grupos;
  final List<Moneda> monedas;
  const BancasSearchDialog({Key key, @required this.bancas, @required this.bancasSeleccionadas, @required this.grupos, @required this.monedas}) : super(key: key);

  @override
  State<BancasSearchDialog> createState() => _BancasSearchDialogState();
}

class _BancasSearchDialogState extends State<BancasSearchDialog> {
  var _txtBuscarController = TextEditingController();
  StreamController _streamControllerBancas;
  List<Banca> _bancasSeleccionadas = [];
  Grupo _grupo;
  Moneda _moneda;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamControllerBancas = BehaviorSubject();
    _asignarBancasSeleccionadas();
    _inicializarBancas();
  }

  _asignarBancasSeleccionadas(){
    _bancasSeleccionadas = List.from(widget.bancasSeleccionadas);
  }

  

  _inicializarBancas(){
    
  }

  List<Banca> _buscar(){
    // if(query.isEmpty && !_hayGrupoSeleccionado())
    //   return data;
    // if(query.isEmpty && _hayGrupoSeleccionado())
    //   return _filtrarPorGrupo(data);
    
    // var regExp = new RegExp(r"" + query.toLowerCase());
    // List<Banca> bancasFiltradas = data.where((element) => regExp.hasMatch(element.descripcion.toLowerCase()) || regExp.hasMatch(element.codigo)).toList();;
    // if(_hayGrupoSeleccionado())
    //   bancasFiltradas = _filtrarPorGrupo(bancasFiltradas);
    
    // return bancasFiltradas;

    List<Banca> bancasFiltradas = _filtrarPorTexto();
    bancasFiltradas = _filtrarPorGrupo(bancasFiltradas);
    bancasFiltradas = _filtrarPorMoneda(bancasFiltradas);
    return bancasFiltradas;
  }

  List<Banca> _filtrarPorTexto(){
    if(_txtBuscarController.text.isEmpty)
      return widget.bancas;
    var regExp = new RegExp(r"" + _txtBuscarController.text.toLowerCase());
    return widget.bancas.where((element) => regExp.hasMatch(element.descripcion.toLowerCase()) || regExp.hasMatch(element.codigo)).toList();
  }

  List<Banca> _filtrarPorGrupo(List<Banca> bancas){
    if(_grupo == null)
      return bancas;
    return bancas.where((element) => element.idGrupo == _grupo.id).toList();
  }

  List<Banca> _filtrarPorMoneda(List<Banca> bancas){
    if(_moneda == null)
      return bancas;
    return bancas.where((element) => element.idMoneda == _moneda.id).toList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _txtBuscarController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: 
      // Text("Seleccionar bancas...", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text("Seleccionar bancas...", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
          ),
          Container(
            width: 250,
            height: 30,
            child: MyTextFormField(
              controller: _txtBuscarController,
              type: MyType.noBorder,
              hint: "Buscar banca...",
            ),
          ),
          _myFilterWidget()

        ],
      ),
      content: Container(
        // height: 400,
        width: 300,
        child: StreamBuilder<List<Banca>>(
          stream: _streamControllerBancas.stream,
          builder: (context, snapshot) {
            if(snapshot.hasData)
              return SizedBox.shrink();
            if(snapshot.data.length == 0)
              return Center(child: Text("No hay datos"));
            return ListView.builder(
              shrinkWrap: true,
              itemCount: widget.bancas.length,
              itemBuilder: (context, index) => _bancaWidget(widget.bancas[index]),
            );
          }
        ),
      ),
    );
  }

  _myFilterWidget(){
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        height: 40,
        width: 150,
        child: MyFilterV2(
          textFontSize: 12,
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                        item: [
                          MyFilterItem(
                            // color: Colors.green[700],
                            hint: "${_grupo != null ? 'Grupo:  ' + _grupo.descripcion: 'Grupo...'}", 
                            data: widget.grupos.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                            onChanged: (value){
                              _cambiarGrupo(value);
                            }
                          ),
                          MyFilterItem(
                            // color: Colors.green[700],
                            visible: widget.monedas.length > 0,
                            hint: "${_moneda != null ? 'Moneda:  ' + _moneda.descripcion: 'Moneda...'}", 
                            data: widget.monedas.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                            onChanged: (value){
                              _cambiarMoneda(value);
                            }
                          ),
                          
                        ],
                      ),
      ),
    );
  }

  _cambiarGrupo(Grupo grupo){
    setState(() => _grupo = grupo);
  }

  _cambiarMoneda(Moneda moneda){

  }
  
  _bancaWidget(Banca banca) {
    return ListTile(
      leading: _checkboxWidget(banca),
      title: Text(banca.descripcion),
    );
  }
  
  Widget _checkboxWidget(Banca banca) {
    return Checkbox(
      side: MaterialStateBorderSide.resolveWith(
      (states){
        if(states.contains(MaterialState.selected))
          return BorderSide(width: 0.001);
        return BorderSide(width: 1.0, color: Colors.black);
      },
  ),
  value: _seleccionada(banca), onChanged: (bool seleccionar) => _seleccionarOQuitarBanca(seleccionar, banca));
  }

  _seleccionarOQuitarBanca(bool seleccionar, Banca banca){
    if(seleccionar){
      if(!_seleccionada(banca))
        setState(() => _bancasSeleccionadas.add(banca));
    }
    else
      setState(() => _bancasSeleccionadas.removeWhere((element) => element.id == banca.id));
  }

  bool _seleccionada(Banca banca){
    return _bancasSeleccionadas.firstWhere((element) => element.id == banca.id, orElse: () => null) != null;
  }
}