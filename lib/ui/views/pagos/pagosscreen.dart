import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/servidores.dart';
import 'package:loterias/core/services/servidorservice.dart';
import 'package:loterias/ui/views/pagos/servidoressearch.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';

class ServidoresScreen extends StatefulWidget {
  const ServidoresScreen({ Key key }) : super(key: key);

  @override
  _ServidoresScreenState createState() => _ServidoresScreenState();
}

class _ServidoresScreenState extends State<ServidoresScreen> {
  Future _future;
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

  _subtitle(bool isSmallOrMedium){
         return isSmallOrMedium 
           ?
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20),
             child: _mysearch(),
           )
           :
           "Agrega grupos para que agrupes, dividas y separes tus bancas y usuarios.";
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
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Servidores"
        ), 
        sliver: FutureBuilder<Object>(
          future: _future,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()),);

            return SliverList(delegate: SliverChildListDelegate([
              Text("Hola")
            ]));
          }
        )
      )
    );
  }
}