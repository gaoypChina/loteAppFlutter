import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/services/bancaservice.dart';

class BancasSearch extends SearchDelegate <Banca>{
  final List<Banca> data;
  BancasSearch(this.data);

  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
   _avatarScreen(String data){

    return CircleAvatar(
      backgroundColor: listaColor[Utils.generateNumber(0, 5)],
      child: data != null ? Text(data.substring(0, 1).toUpperCase()) : null,
    );
  }

  _listView(List<Banca> listData){
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
                Text("${listData[index].codigo}"),
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
    print("BancasSearch buildResults: $query");
    return FutureBuilder(
      future: BancaService.search(context: context, search: query),
      builder: (context, snapshot){
        if(snapshot.connectionState != ConnectionState.done)
          return Center(child: CircularProgressIndicator());
        else
          return _listView(snapshot.data);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return _listView(data);
  }
  
}