import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/services/bancaservice.dart';

class BalanceBancasSearch extends SearchDelegate <Banca>{
  final List<Banca> data;
  BalanceBancasSearch(this.data);

  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
    _avatarScreen(Loteria data){

    return CircleAvatar(
      backgroundColor: data.status == 1 ? Colors.green : Colors.pink,
      child: data.status == 1 ? Icon(Icons.done, color: Colors.green[100],) : Icon(Icons.unpublished, color: Colors.pink[100],),
    );
  }

  _listView(List<Banca> listData){
    return ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, index){
        return ListTile(
                      leading: Text("${index + 1}"),
                      title: Text("${listData[index].descripcion}"),
                      isThreeLine: true,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${listData[index].dueno}"),
                          Text("${listData[index].usuario != null ? listData[index].usuario.usuario : ''}"),
                        ],
                      ),
                      // onTap: (){_agregarOEditar(data: e);},
                      trailing: Text("${Utils.toCurrency(listData[index].balance)}"),
                    );
      },
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
      onPressed: (){close(context, null);},
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    print("BalanceBancosSearch buildResults: $query");

    return _listView(data.where((element) => element.descripcion.toLowerCase().indexOf(query.toLowerCase()) != -1).toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return _listView(data);
  }
  
}