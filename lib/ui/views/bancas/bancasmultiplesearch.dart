import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/bancaservice.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilterv2.dart';

class BancasMultipleSearch extends SearchDelegate <List<Banca>>{
  final List<Banca> data;
  // List<Banca> bancasFiltradas = [];
  List<Banca> bancasSeleccionadas;
  List<Grupo> grupos;
  List<Moneda> monedas;
  Grupo _grupo;
  Moneda _moneda;
  BancasMultipleSearch(this.data, this.bancasSeleccionadas, [this.grupos = const [], this.monedas = const []]);

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
    if(value){
      List<Banca> bancasFiltradas = _buscar();
      setState(() => bancasSeleccionadas = bancasFiltradas);
    }
    else
      setState(() => bancasSeleccionadas = []);
  }

  _filtroYSeleccionarTodasWidget(setState){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _myFilterWidget(setState),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Todas", style: TextStyle(fontWeight: FontWeight.bold),),
              Checkbox(value: _todasLasBancasEstanSeleccionadas(), onChanged: (value) => _seleccionarTodaslasBancas(value, setState),),
            ],
          ),
        
        ],
      ),
    );
  }

  _myFilterWidget(setState){
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        height: 50,
        child: MyFilterV2(
                        item: [
                          // MyFilterItem(
                          //   // color: Colors.blue[800],
                          //   enabled: _tienePermisoJugarComoCualquierBanca,
                          //   visible: _tienePermisoJugarComoCualquierBanca,
                          //   hint: "${_banca != null ? 'Banca:  ' + _banca.descripcion: 'Banca...'}", 
                          //   data: listaBanca.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                          //   onChanged: (value){
                          //     _bancaChanged(value);
                          //   }
                          // ),
                          MyFilterItem(
                            // color: Colors.green[700],
                            hint: "${_grupo != null ? 'Grupo:  ' + _grupo.descripcion: 'Grupo...'}", 
                            data: grupos.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                            onChanged: (value){
                              _grupoChanged(value, setState);
                            }
                          ),
                          MyFilterItem(
                            // color: Colors.green[700],
                            visible: monedas.length > 0,
                            hint: "${_moneda != null ? 'Moneda:  ' + _moneda.descripcion: 'Moneda...'}", 
                            data: monedas.map((e) => MyFilterSubItem(child: e.descripcion, value: e)).toList(),
                            onChanged: (value){
                              _monedaChanged(value, setState);
                            }
                          ),
                          // MyFilterItem(
                          //   // color: Colors.orange[700],
                          //   hint: "${_tipoTicket != null ? 'Estado:  ' + _tipoTicket[1] : 'Estados...'}", 
                          //   data: listaTipoTicket.map((e) => MyFilterSubItem(child: e[1], value: e)).toList(),
                          //   onChanged: (value){
                          //     _tipoTicketChanged(value);
                          //   }
                          // ),
                        ],
                      ),
      ),
    );
  }

  _grupoChanged(Grupo grupo, setState){
    setState((){ 
      print("BancasmultipleSearch _grupoChanged");
      _grupo = grupo.id != Grupo.getGrupoNinguno.id ? grupo : null; 
    });
  }

  _monedaChanged(Moneda moneda, setState){
    setState((){ 
      print("BancasmultipleSearch _monedaChanged");
      _moneda = moneda.id != Moneda.getMonedaNinguna.id ? moneda : null; 
      // bancasFiltradas = bancasFiltradas.where((element) => element.idGrupo == _grupo.id).toList();
    });
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

  Widget _listView(setState, List<Banca> listData){
    // if(!_hayCoincidencias(listData))
    //   return ;
    
    // return StatefulBuilder(
    //   builder: (context, setState) {
        return Column(
          children: [
            _filtroYSeleccionarTodasWidget(setState),
            Expanded(
              child: 
              !_hayCoincidencias(listData)
              ?
              Center(child: MyEmpty(title: "No hay resultados que coincida", titleButton: "No hay coincidencias", icon: Icons.search_off,))
              :
              ListView.builder(
                itemCount: listData.length,
                itemBuilder: (context, index){
                  return _bancaItemWidget(listData[index], setState);
                },
              ),
            ),
          ],
        );
    //   }
    // );
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
    if(query.isEmpty)
      return data;
    var regExp = new RegExp(r"" + query.toLowerCase());
    return data.where((element) => regExp.hasMatch(element.descripcion.toLowerCase()) || regExp.hasMatch(element.codigo)).toList();
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

  _hayGrupoSeleccionado(){
    return _grupo != null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return _listView(setState, _buscar());
      }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return StatefulBuilder(
      builder: (context, setState) {
        return _listView(setState, _buscar());
      }
    );
  }
  
}