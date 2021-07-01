import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/services/bancaservice.dart';

class LoteriasSearch extends SearchDelegate <Loteria>{
  final List<Loteria> data;
  LoteriasSearch(this.data);

  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
   _avatarScreen(String data){

    return CircleAvatar(
      backgroundColor: listaColor[Utils.generateNumber(0, 5)],
      child: data != null ? Text(data.substring(0, 1).toUpperCase()) : null,
    );
  }

  _listView(List<Loteria> listData){
    return ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, index){
        return ListTile(
            leading: _avatarScreen(listData[index].descripcion),
            title: Text("${listData[index].descripcion}"),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${listData[index].abreviatura}"),
                // Text("${e.sorteos}"),
              ],
            ),
            onTap: (){
              close(context, listData[index]);
            },
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
    print("LoteriasSearch buildResults: $query");

    return _listView(data.where((element) => element.descripcion.toLowerCase().indexOf(query.toLowerCase()) != -1 || element.abreviatura.toLowerCase().indexOf(query.toLowerCase()) != -1).toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return _listView(data);
  }
  
}