import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/services/monedasservice.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myrich.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:rxdart/rxdart.dart';

class MonedasScreen extends StatefulWidget {
  const MonedasScreen({ Key key }) : super(key: key);

  @override
  _MonedasScreenState createState() => _MonedasScreenState();
}

class _MonedasScreenState extends State<MonedasScreen> {
  StreamController<List<Moneda>> _streamController;
  List<Moneda> listaData = [];
  var _txtSearch = TextEditingController();

  _init() async {
    var parsed = await MonedasService.index(context: context);
    listaData = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList() : [];
    _streamController.add(listaData);
    print("MonedasScreen _init: $parsed");
    // listaLoteria = (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
    // listaDia = (parsed["dias"] != null) ? parsed["dias"].map<Dia>((json) => Dia.fromMap(json)).toList() : [];
    // selectedLoteria = listaLoteria != null ? listaLoteria.length > 0 ? listaLoteria[0] : null : null;
    // _dias = selectedLoteria != null ? selectedLoteria.dias.length > 0 ? List<Dia>.from(selectedLoteria.dias) : [] : [];
  }

  _agregarOEditar({Moneda data}) async {
    var data2 = await Navigator.pushNamed(context, "/monedas/agregar", arguments: data);
    if(data2 == null)
      return;

    _addDataToList(data2);
  }

  _addDataToList(Moneda data){
    if(data != null){
      int idx = listaData.indexWhere((element) => element.id == data.id);
      if(idx != -1){
        print("BancasSCreen _addDataToList If: ${data.toJson()}");
        listaData[idx] = data;
      }else{
        print("BancasSCreen _addDataToList Else: ${data.toJson()}");
        listaData.add(data);
      }
      _streamController.add(listaData);
    }
  }

  _removeDataFromList(Moneda data){
    if(data != null){
      int idx = listaData.indexWhere((element) => element.id == data.id);
      if(idx != -1){
       print("_deletedataFromList _showDialogEliminar: ${data.toJson()} idx: $idx");
        listaData.removeAt(idx);
      _streamController.add(listaData);
      }
    }
  }

  
  _showDialogEliminar({Moneda data}){
    bool cargando = false;
    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return MyAlertDialog(
              title: "Eliminar", content: MyRichText(text: "Seguro que desea eliminar la moneda ", boldText: "${data.descripcion}",), 
              isDeleteDialog: true,
              cargando: cargando,
              okFunction: () async {
                try {
                  setState(() => cargando = true);
                  var parsed = await MonedasService.eliminar(context: context, data: data);
                  if(parsed["data"] != null)
                    _removeDataFromList(Moneda.fromMap(parsed["data"]));
                  setState(() => cargando = false);
                  Navigator.pop(context);
                } on Exception catch (e) {
                  print("_showDialogEliminar error: $e");
                  setState(() => cargando = false);
                }
              }
            );
          }
        );
      }
    );
  }

  _avatarScreen(Moneda data){

    return CircleAvatar(
      backgroundColor: Utils.fromHex(data.color),
      child: Text("${data.abreviatura}"),
    );
  }


   _dataScreen(AsyncSnapshot<List<Moneda>> snapshot, bool isSmallOrMedium){
    if(isSmallOrMedium){
      return SingleChildScrollView(
        child: Column(
          children: snapshot.data.map((e) => ListTile(
            leading: _avatarScreen(e),
            title: Text("${e.descripcion}"),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${e.abreviatura}"),
                // Text("${e.sorteos}"),
              ],
            ),
            onTap: (){_agregarOEditar(data: e);},
            trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){_showDialogEliminar(data: e);}),
          )).toList(),
        ),
      );
    }
    return MyTable(
      columns: ["Moneda", "Abreviatura", "Equivalencia USD", "Por defecto"], 
      rows: snapshot.data.map((e) => [e, Text("${e.pordefecto}", style: TextStyle(color: Utils.fromHex(e.color), fontWeight: FontWeight.w700),), "${e.abreviatura}", "${e.equivalenciaDeUnDolar}", "${e.pordefecto}"]).toList(),
      isScrolled: false,
      onTap: (data){
        // _showDialogGuardar(data: data);
      },
      delete: (data){
        // _showDialogEliminar(data: data);
      },
    );
  }

  // _filtrar(data){
  //   List<Moneda> listTmp = [];
  //   if(data == "Activos")
  //     listTmp = listaData.where((e) => e.status == 1).toList();
  //   else if(data == "Desactivados")
  //     listTmp = listaData.where((e) => e.status == 0).toList();
  //   else 
  //     listTmp = listaData;

  //   _streamController.add(listTmp);
  // }

  _search(String data){
    print("SucursalesSCreen _search: $data");
    if(data.isEmpty)
      _streamController.add(listaData);
    else
      {
        var element = listaData.where((element) => element.descripcion.toLowerCase().indexOf(data) != -1).toList();
        print("RolesScreen _serach length: ${element.length}");
        _streamController.add(listaData.where((element) => element.descripcion.toLowerCase().indexOf(data) != -1).toList());
      }
  }


  // _mydropdown(){
  //   return MyDropdown(
  //     title: "Filtrar por",
  //     hint: "Todos",
  //     elements: [
  //       ["Todos", "Todos"],
  //       ["Activos", "Activos"],
  //       ["Desactivados", "Desactivados"],
  //     ],
  //     onTap: _filtrar,
  //     showOnlyOnLarge: true,
  //   );
  // }


  @override
  void initState() {
    // TODO: implement initState
    _streamController = BehaviorSubject();
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);

    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      floatingActionButton: isSmallOrMedium ? FloatingActionButton(backgroundColor: Theme.of(context).primaryColor, child: Icon(Icons.add), onPressed: _agregarOEditar,) : null,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Monedas",
        ), 
        sliver: StreamBuilder<List<Moneda>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator(),));

            return SliverList(delegate: SliverChildListDelegate([
               MySubtitle(title: "${listaData.length} Loterias", showOnlyOnLarge: true,),
              Stack(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // _mydropdown(),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0, top: 18.0),
                      child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar banca...", xlarge: 2.6, showOnlyOnLarge: true,),
                    ))
                ],
              ),
               _dataScreen(snapshot, isSmallOrMedium),
              SizedBox(height: snapshot.data.length > 6 ? 70 : 0),
            ]));
          }
        )
      )
    );
  }
}