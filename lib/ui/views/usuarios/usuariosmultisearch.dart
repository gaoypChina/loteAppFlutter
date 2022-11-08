import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/services/bancaservice.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';

class UsuariosMultiSearch extends SearchDelegate <List<Usuario>>{
  final List<Usuario> data;
  List<Usuario> usuariosSeleccionados;
  UsuariosMultiSearch(this.data, this.usuariosSeleccionados);

  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];

  _estaSeleccionado(Usuario usuario){
    return usuariosSeleccionados.firstWhere((element) => element.id == usuario.id, orElse: () => null) != null;
  }

  _seleccionarBanca(Usuario usuario, value, setState){
    if(value){
      if(usuariosSeleccionados.firstWhere((element) => element.id == usuario.id, orElse: () => null) == null)
        setState(() => usuariosSeleccionados.add(usuario));
    }else
      setState(() => usuariosSeleccionados.remove(usuario));
  }

  _hayCoincidencias(List<Usuario> listData){
    bool hay = true;
    if(listData == null)
      hay = false;
    if(listData.length == 0)
      hay = false;

    return hay;
  }

  _todasLasBancasEstanSeleccionadas(){
    if(usuariosSeleccionados.length == 0)
      return false;

    return usuariosSeleccionados.length == data.length;
  }

  _seleccionarTodaslasBancas(bool value, setState){
    if(value)
      setState(() => usuariosSeleccionados = data);
    else
      setState(() => usuariosSeleccionados = []);
  }

  _todasWidget(setState){
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: InkWell(
          onTap: () => _seleccionarTodaslasBancas(!_todasLasBancasEstanSeleccionadas(), setState),
          child: MyResizedContainer(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              decoration: BoxDecoration(
                border: _todasLasBancasEstanSeleccionadas() ? null : Border.all(color: Colors.grey, width: 0.2),
                color: _todasLasBancasEstanSeleccionadas() ? Colors.blue[100] : null,
                borderRadius: BorderRadius.circular(5.0)
              ),
              child: Center(child: Text("Seleccionar todos", style: TextStyle(fontWeight: FontWeight.bold, color: _todasLasBancasEstanSeleccionadas() ? Colors.blue[700] : null),)),
            ),
          ),
        )
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Text("Todas", style: TextStyle(fontWeight: FontWeight.bold),),
        //     Checkbox(value: _todasLasBancasEstanSeleccionadas(), onChanged: (value) => _seleccionarTodaslasBancas(value, setState),),
        //   ],
        // ),
      ),
    );
  }

  _bancaItemWidget(Usuario usuario, setState){
    return ListTile(
      leading: Icon(Icons.account_balance_outlined),
      title: Text("${usuario.usuario}"),
      trailing: Checkbox(value: _estaSeleccionado(usuario), onChanged: (value) => _seleccionarBanca(usuario, value, setState),),
      onTap: (){
        _seleccionarBanca(usuario, !_estaSeleccionado(usuario), setState);
      },
    );
  }

  Widget _listView(List<Usuario> listData){
    if(!_hayCoincidencias(listData))
      return Center(child: MyEmpty(title: "No hay resultados que coincida", titleButton: "No hay coincidencias", icon: Icons.search_off,));
    
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            _todasWidget(setState),
            Expanded(
              child: ListView.builder(
                itemCount: listData.length,
                itemBuilder: (context, index){
                  return _bancaItemWidget(listData[index], setState);
                },
              ),
            ),
          ],
        );
      }
    );
  }
  
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [IconButton(onPressed: (){}, icon: Icon(Icons.clear))];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return BackButton(
      onPressed: (){close(context, usuariosSeleccionados);},
    );
  }

  List<Usuario> _buscar(){
    if(query.isEmpty)
      return data;
    var regExp = new RegExp(r"" + query.toLowerCase());
    return data.where((element) => regExp.hasMatch(element.usuario.toLowerCase()) || regExp.hasMatch(element.nombres)).toList();;
  }

  @override
  Widget buildResults(BuildContext context) {
    return _listView(_buscar());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return _listView(_buscar());
  }
  
}