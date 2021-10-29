import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/servidores.dart';

class ServidoresSearch extends SearchDelegate <Servidor>{
  final List<Servidor> data;
  ServidoresSearch(this.data);

  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
   _avatarScreen(Servidor data){

     int daysDifference = MyDate.daysDifference(data.fechaProximoPago);
     Color backgroundColor;
     Color iconColor;
     IconData iconData;

     if(daysDifference == null || daysDifference > 0){
       backgroundColor =  Colors.green;
       iconColor = Colors.green[100];
       iconData = Icons.done;
     }
     else if(daysDifference == 0){
       backgroundColor =  Colors.orange;
       iconColor = Colors.orange[100];
       iconData = Icons.warning;
     }
     else if(daysDifference < 0){
       backgroundColor =  Colors.pink;
       iconColor = Colors.pink[100];
       iconData = Icons.unpublished;
     }

    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: Icon(iconData, color: iconColor,),
    );
  }

  _listView(List<Servidor> listData){
    return ListView.builder(
      itemCount: listData.length,
      itemBuilder: (context, index){
        return ListTile(
            leading: _avatarScreen(listData[index]),
            title: Text("${listData[index].cliente}"),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${listData[index].descripcion}"),
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

    return _listView(data.where((element) => element.descripcion.toLowerCase().indexOf(query.toLowerCase()) != -1 || element.cliente.toLowerCase().indexOf(query.toLowerCase()) != -1).toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return _listView(data);
  }
  
}