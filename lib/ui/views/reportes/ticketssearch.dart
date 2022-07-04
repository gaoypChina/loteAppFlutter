import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';

class TicketsSearch extends SearchDelegate <dynamic>{
  final List data;
  TicketsSearch(this.data);

  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
    

  _listView(List listData){
    return ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, index){
        return ListTile(
            // leading: _avatarScreen(listData[index]),
            title: Text("${Utils.toSecuencia(listData[index]["primera"], BigInt.from(listData[index]["idTicket"]), false)}"),
            isThreeLine: true,
            subtitle: Text("${listData[index]['fecha']}"),
            trailing: Text("${listData[index]['montoAPagar']}", style: TextStyle(fontWeight: FontWeight.bold),),
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
    print("TicketsSearch buildResults: $query");

    return _listView(data.where((element) => element.descripcion.toLowerCase().indexOf(query.toLowerCase()) != -1 || element.abreviatura.toLowerCase().indexOf(query.toLowerCase()) != -1).toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return _listView(data);
  }
  
}