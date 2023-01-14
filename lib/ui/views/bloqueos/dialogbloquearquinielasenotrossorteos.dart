import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/jugadas.dart';

class DialogBloquearQuinielasEnOtrosSorteos extends StatefulWidget {
  final List<Jugada> jugadas;
  const DialogBloquearQuinielasEnOtrosSorteos({Key key, this.jugadas}) : super(key: key);

  @override
  State<DialogBloquearQuinielasEnOtrosSorteos> createState() => _DialogBloquearQuinielasEnOtrosSorteosState();
}

class _DialogBloquearQuinielasEnOtrosSorteosState extends State<DialogBloquearQuinielasEnOtrosSorteos> {
  Future<List<Draws>> _futureSorteos;
  List<Draws> _sorteosSeleccionados = [];

  @override
  void initState() {
    // TODO: implement initState
    _futureSorteos = Db.draws(["Directo", "Pale", "Tripleta", "Super pale"]);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Bloquear quinielas"),
      content: FutureBuilder(
        future: _futureSorteos,
        builder: (context, snapshot) {
          if(snapshot.hasError)
            return _errorWidget(snapshot.error);

          if(snapshot.hasData)
            return SingleChildScrollView(child: _seleccionarSorteoWidget(snapshot.data));

          return Center(child: CircularProgressIndicator());
        },
      ),
      actions: [
        TextButton(onPressed: () => _irAtras(context), child: Text("Cancelar")),
        TextButton(onPressed: () {_bloquearQuinielasEnSorteosSeleccionados();}, child: Text("Bloquear")),
      ]
    );
  }
  
  Widget _errorWidget(Object error) {
    return Text("${error}");
  }
  
  Widget _seleccionarSorteoWidget(List<Draws> sorteos) {
    return Column(
      children: sorteos.map((sorteo) => CheckboxListTile(title: Text(sorteo.descripcion), value: _estaSeleccionado(sorteo), onChanged: (value) => _seleccionarSorteo(value, sorteo))).toList()
    );
  }
  
  _estaSeleccionado(Draws sorteo) {
    Draws sorteoEncontrado = _sorteosSeleccionados.firstWhere((element) => element.id == sorteo.id, orElse: () => null);
    bool seleccionado = sorteoEncontrado != null;
    return seleccionado;
  }
  
  _seleccionarSorteo(bool seleccionar, Draws sorteo) {
    if(seleccionar)
      _agregarSorteo(sorteo);
    else
      _eliminarSorteo(sorteo);
  }
  
  void _agregarSorteo(Draws sorteo) {
    bool seleccionado = _sorteosSeleccionados.indexWhere((element) => element.id == sorteo.id) != -1;
    if(!seleccionado)
      setState(() => _sorteosSeleccionados.add(sorteo));
  }
  
  void _eliminarSorteo(Draws sorteo) {
    bool seleccionado = _sorteosSeleccionados.indexWhere((element) => element.id == sorteo.id) != -1;
    if(seleccionado)
      setState(() => _sorteosSeleccionados.removeWhere((element) => element.id == sorteo.id));
  }
  
  _irAtras(BuildContext context, {List<Jugada> jugadasARetornar}) {
    Navigator.pop(context, jugadasARetornar);
  }
  
  void _bloquearQuinielasEnSorteosSeleccionados() {
    
  }
}