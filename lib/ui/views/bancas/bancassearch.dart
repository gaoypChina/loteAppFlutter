import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/services/bancaservice.dart';
import 'package:loterias/ui/widgets/myempty.dart';

class BancasSearch extends SearchDelegate <Banca>{
  final List<Banca> data;
  final int idGrupo;
  BancasSearch(this.data, this.idGrupo);

  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
    _avatarScreen(Banca data){

    return CircleAvatar(
      backgroundColor: data.status == 1 ? Colors.green : Colors.pink,
      child: data.status == 1 ? Icon(Icons.done, color: Colors.green[100],) : Icon(Icons.unpublished, color: Colors.pink[100],),
    );
  }

  _listView(List<Banca> listData){
    if(listData == null)
      return Center(child: MyEmpty(title: "No hay resultados que coincida", titleButton: "No hay coincidencias", icon: Icons.search_off,));
    if(listData.length == 0)
      return Center(child: MyEmpty(title: "No hay resultados que coincida", titleButton: "No hay coincidencias", icon: Icons.search_off,));
      
    return ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, index){
        return ListTile(
            leading: _avatarScreen(listData[index]),
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
      future: BancaService.search(context: context, search: query, idGrupo: idGrupo),
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