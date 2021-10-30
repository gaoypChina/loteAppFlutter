import 'package:flutter/material.dart';
import 'package:loterias/core/classes/mydate.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/services/servidorservice.dart';
import 'package:loterias/ui/views/pagos/servidoressearch.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';

class ServidoresScreen extends StatefulWidget {
  const ServidoresScreen({ Key key }) : super(key: key);

  @override
  _ServidoresScreenState createState() => _ServidoresScreenState();
}

class _ServidoresScreenState extends State<ServidoresScreen> {
  Future<List<Servidor>> _future;
  TextEditingController _txtSearch = TextEditingController();
  List<Servidor> listData = [];

  Future<List<Servidor>> _init() async {
    List<Servidor> data = [];
    var parsed = await ServidorService.index(context: context);
    if(parsed == null)
      return data;

    if(parsed["data"] == null)
      return data;

    listData = parsed["data"] != null ? parsed["data"].map<Servidor>((json) => Servidor.fromMap(json)).toList() : [];
    return listData;
  }

  Widget _mysearch(){
    return GestureDetector(
      onTap: () async {
        Servidor data = await showSearch(context: context, delegate: ServidoresSearch(listData));
        if(data == null)
          return;
  
        // _showDialogGuardar(data: data);
      },
      child: MySearchField(
        controller: _txtSearch, 
        enabled: false, 
        hint: "", 
        xlarge: 2.6, 
        padding: EdgeInsets.all(0),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

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

  _listTile(List<Servidor> listData, int index){
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
        // close(context, listData[index]);
      },
    );
    // return ListView.builder(
    //   itemCount: listData.length,
    //   itemBuilder: (context, index){
    //     return ListTile(
    //         leading: _avatarScreen(listData[index]),
    //         title: Text("${listData[index].cliente}"),
    //         isThreeLine: true,
    //         subtitle: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text("${listData[index].descripcion}"),
    //             // Text("${e.sorteos}"),
    //           ],
    //         ),
    //         onTap: (){
    //           // close(context, listData[index]);
    //         },
    //       );
    //   },
    // );
  }

  _subtitle(bool isSmallOrMedium){
         return isSmallOrMedium 
           ?
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20),
             child: _mysearch(),
           )
           :
           "Administre y realize pagos para los servidores";
  }

  @override
  void initState() {
    // TODO: implement initState
    _future = _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context,
      isSliverAppBar: true,
      cargando: false,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Servidores",
          subtitle: _subtitle(isSmallOrMedium),
          expandedHeight: isSmallOrMedium ? 105 : 0,
        ), 
        sliver: FutureBuilder<List<Servidor>>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()),);

            if(snapshot.data.length == 0)
              return SliverFillRemaining(child: Center(child: MyEmpty(title: "No hay servidores", titleButton: "No hay servidores registrados", icon: Icons.computer,)),);

            

            return SliverList(delegate: SliverChildBuilderDelegate(
              (context, index){
                return _listTile(snapshot.data, index);
              },
              childCount: snapshot.data.length
            ));
          }
        )
      )
    );
  }
}

