import 'package:flutter/material.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myfilterv2.dart';

class LoteriasMultipleSearch extends SearchDelegate <List<Loteria>>{
  final List<Loteria> data;
  // List<Banca> bancasFiltradas = [];
  List<Loteria> loteriasSeleccionadas;
  List<Grupo> grupos;
  List<Moneda> monedas;
  Grupo _grupo;
  Moneda _moneda;
  LoteriasMultipleSearch(this.data, this.loteriasSeleccionadas);

  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
    _avatarScreen(Loteria data){

    return CircleAvatar(
      backgroundColor: data.status == 1 ? Colors.green : Colors.pink,
      child: data.status == 1 ? Icon(Icons.done, color: Colors.green[100],) : Icon(Icons.unpublished, color: Colors.pink[100],),
    );
  }

  _estaSeleccionado(Loteria loteria){
    return loteriasSeleccionadas.firstWhere((element) => element.id == loteria.id, orElse: () => null) != null;
  }

  _seleccionarLoteria(Loteria loteria, value, setState){
    if(value){
      if(loteriasSeleccionadas.firstWhere((element) => element.id == loteria.id, orElse: () => null) == null)
        setState(() => loteriasSeleccionadas.add(loteria));
    }else
      setState(() => loteriasSeleccionadas.remove(loteria));
  }

  _hayCoincidencias(List<Loteria> listData){
    bool hay = true;
    if(listData == null)
      hay = false;
    if(listData.length == 0)
      hay = false;

    return hay;
  }

  _todasLasBancasEstanSeleccionadas(){
    if(loteriasSeleccionadas.length == 0)
      return false;

    return loteriasSeleccionadas.length == data.length;
  }

  _seleccionarTodaslasBancas(bool value, setState){
    if(value){
      List<Loteria> bancasFiltradas = _buscar();
      setState(() => loteriasSeleccionadas = bancasFiltradas);
    }
    else
      setState(() => loteriasSeleccionadas = []);
  }

  _filtroYSeleccionarTodasWidget(setState){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
      print("LoteriasmultipleSearch _grupoChanged");
      _grupo = grupo.id != Grupo.getGrupoNinguno.id ? grupo : null; 
    });
  }

  _monedaChanged(Moneda moneda, setState){
    setState((){ 
      print("LoteriasmultipleSearch _monedaChanged");
      _moneda = moneda.id != Moneda.getMonedaNinguna.id ? moneda : null; 
      // bancasFiltradas = bancasFiltradas.where((element) => element.idGrupo == _grupo.id).toList();
    });
  }

  _loteriaItemWidget(Loteria banca, setState){
    return ListTile(
      leading: Icon(Icons.group_work_outlined),
      title: Text("${banca.descripcion}"),
      trailing: Checkbox(value: _estaSeleccionado(banca), onChanged: (value) => _seleccionarLoteria(banca, value, setState),),
      onTap: (){
        _seleccionarLoteria(banca, !_estaSeleccionado(banca), setState);
      },
    );
  }

  Widget _listView(setState, List<Loteria> listData){
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
                  return _loteriaItemWidget(listData[index], setState);
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
      onPressed: (){close(context, loteriasSeleccionadas);},
    );
  }

  List<Loteria> _buscar(){
    return _filtrarPorTexto();
  }

  List<Loteria> _filtrarPorTexto(){
    if(query.isEmpty)
      return data;
    var regExp = new RegExp(r"" + query.toLowerCase());
    return data.where((element) => regExp.hasMatch(element.descripcion.toLowerCase()) || regExp.hasMatch(element.descripcion)).toList();
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