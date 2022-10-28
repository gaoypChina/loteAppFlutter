import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/services/bancaservice.dart';
import 'package:loterias/ui/widgets/myempty.dart';

class BancasMultipleSearch extends SearchDelegate <List<Banca>>{
  final List<Banca> data;
  List<Banca> bancasSeleccionadas;
  BancasMultipleSearch(this.data, this.bancasSeleccionadas);

  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
    _avatarScreen(Banca data){

    return CircleAvatar(
      backgroundColor: data.status == 1 ? Colors.green : Colors.pink,
      child: data.status == 1 ? Icon(Icons.done, color: Colors.green[100],) : Icon(Icons.unpublished, color: Colors.pink[100],),
    );
  }

  _estaSeleccionado(Banca banca){
    return bancasSeleccionadas.firstWhere((element) => element.id == banca.id, orElse: () => null) != null;
  }

  _seleccionarBanca(Banca banca, value, setState){
    if(value){
      if(bancasSeleccionadas.firstWhere((element) => element.id == banca.id, orElse: () => null) == null)
        setState(() => bancasSeleccionadas.add(banca));
    }else
      setState(() => bancasSeleccionadas.remove(banca));
  }

  _hayCoincidencias(List<Banca> listData){
    bool hay = true;
    if(listData == null)
      hay = false;
    if(listData.length == 0)
      hay = false;

    return hay;
  }

  _todasLasBancasEstanSeleccionadas(){
    if(bancasSeleccionadas.length == 0)
      return false;

    return bancasSeleccionadas.length == data.length;
  }

  _seleccionarTodaslasBancas(bool value, setState){
    if(value)
      setState(() => bancasSeleccionadas = data);
    else
      setState(() => bancasSeleccionadas = []);
  }

  _todasWidget(setState){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Todas", style: TextStyle(fontWeight: FontWeight.bold),),
          Checkbox(value: _todasLasBancasEstanSeleccionadas(), onChanged: (value) => _seleccionarTodaslasBancas(value, setState),),
        ],
      ),
    );
  }

  _bancaItemWidget(Banca banca, setState){
    return ListTile(
      leading: Icon(Icons.account_balance_outlined),
      title: Text("${banca.descripcion}"),
      trailing: Checkbox(value: _estaSeleccionado(banca), onChanged: (value) => _seleccionarBanca(banca, value, setState),),
      onTap: (){
        _seleccionarBanca(banca, !_estaSeleccionado(banca), setState);
      },
    );
  }

  Widget _listView(List<Banca> listData){
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
      onPressed: (){close(context, bancasSeleccionadas);},
    );
  }

  List<Banca> _buscar(){
    if(query.isEmpty)
      return data;
    var regExp = new RegExp(r"" + query.toLowerCase());
    return data.where((element) => regExp.hasMatch(element.descripcion.toLowerCase()) || regExp.hasMatch(element.codigo)).toList();;
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