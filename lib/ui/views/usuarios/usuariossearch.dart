import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/services/bancaservice.dart';
import 'package:loterias/core/services/usuarioservice.dart';
import 'package:loterias/ui/widgets/myempty.dart';

class UsuariosSearch extends SearchDelegate <Usuario>{
  final List<Usuario> data;
  final int idGrupo;
  UsuariosSearch(this.data, this.idGrupo);

  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
    _avatarScreen(Usuario data){

    return CircleAvatar(
      backgroundColor: data.status == 1 ? Colors.green : Colors.pink,
      child: data.status == 1 ? Icon(Icons.done, color: Colors.green[100],) : Icon(Icons.unpublished, color: Colors.pink[100],),
    );
  }

  _listView(List<Usuario> listData){
    if(listData == null)
      return Center(child: MyEmpty(title: "No hay resultados que coincida", titleButton: "No hay coincidencias", icon: Icons.search_off,));
    if(listData.length == 0)
      return Center(child: MyEmpty(title: "No hay resultados que coincida", titleButton: "No hay coincidencias", icon: Icons.search_off,));
      
    return ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, index){
        return ListTile(
            leading: _avatarScreen(listData[index]),
            title: Text("${listData[index].nombres}"),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${listData[index].usuario}"),
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
    print("UsuarioSearch buildResults: $query");
    return FutureBuilder(
      future: UsuarioService.search(context: context, search: query, idGrupo: idGrupo),
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