import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/models/pago.dart';
import 'package:loterias/core/models/pagodetalle.dart';
import 'package:loterias/core/services/bancaservice.dart';

class PagoDetalleBancaSearch extends SearchDelegate <List<Pagodetalle>>{
  final List<Pagodetalle> data;
  final List<Pagodetalle> selectedData;
  PagoDetalleBancaSearch(this.data, this.selectedData);

  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
   _avatarScreen(Pagodetalle data){

    return CircleAvatar(
      backgroundColor: data.diasUsados > 0 ? Colors.green : Colors.pink,
      child: data.diasUsados > 0 ? Icon(Icons.done, color: Colors.green[100],) : Icon(Icons.unpublished, color: Colors.pink[100],),
    );
  }
  
  

  _exists(Pagodetalle detalle){
    if(selectedData == null)
      return false;

    return selectedData.indexWhere((element) => element.idBanca == detalle.idBanca) != -1;
  }

  _listView(List<Pagodetalle> listData){
    return StatefulBuilder(
      builder: (context, setState) {
        _addOrRemove(Pagodetalle detalle){
          if(selectedData.length == 0){
            selectedData.add(detalle);
            return;
          }

          if(selectedData.firstWhere((element) => element.idBanca == detalle.idBanca, orElse: () => null) == null)
            setState(() => selectedData.add(detalle));
          else
            setState(() => selectedData.remove(detalle));
        }

        return ListView.builder(
          itemCount: listData.length,
          itemBuilder: (context, index){
            return ListTile(
                leading: _avatarScreen(listData[index]),
                title: Text("${listData[index].descripcionBanca}"),
                isThreeLine: true,
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${listData[index].codigoBanca}"),
                    // Text("${e.sorteos}"),
                  ],
                ),
                onTap: (){
                  _addOrRemove(listData[index]);
                },
                trailing: Checkbox(
                  value: _exists(listData[index]), 
                  onChanged: (value){
                    _addOrRemove(listData[index]);
                  },
                ),
              );
          },
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
      onPressed: (){close(context, null);},
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    print("PagoDetalleBancaSearch buildResults: $query");

    return _listView(data.where((element) => element.descripcionBanca.toLowerCase().indexOf(query.toLowerCase()) != -1 || element.codigoBanca.toLowerCase().indexOf(query.toLowerCase()) != -1).toList());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return _listView(data);
  }
  
}