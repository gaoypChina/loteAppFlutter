import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/entidades.dart';
import 'package:loterias/core/models/monedas.dart';
import 'package:loterias/core/models/tipos.dart';
import 'package:loterias/core/services/entidadesservice.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/myrich.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:rxdart/rxdart.dart';

class EntidadesScreen extends StatefulWidget {
  const EntidadesScreen({ Key key }) : super(key: key);

  @override
  _EntidadesScreenState createState() => _EntidadesScreenState();
}

class _EntidadesScreenState extends State<EntidadesScreen> {
  StreamController<List<Entidad>> _streamController;
  List<Entidad> listaData = [];
  List<Moneda> listaMoneda = [];
  List<Tipo> listaTipo = [];
  var _txtSearch = TextEditingController();

  _init() async {
    var parsed = await EntidadesService.index(context: context);
    listaData = (parsed["data"] != null) ? parsed["data"].map<Entidad>((json) => Entidad.fromMap(json)).toList() : [];
    listaMoneda = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList() : [];
    listaTipo = (parsed["tipo"] != null) ? parsed["tipo"].map<Tipo>((json) => Tipo.fromMap(json)).toList() : [];
    _streamController.add(listaData);
    print("MonedasScreen _init: $parsed");
    // listaLoteria = (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
    // listaDia = (parsed["dias"] != null) ? parsed["dias"].map<Dia>((json) => Dia.fromMap(json)).toList() : [];
    // selectedLoteria = listaLoteria != null ? listaLoteria.length > 0 ? listaLoteria[0] : null : null;
    // _dias = selectedLoteria != null ? selectedLoteria.dias.length > 0 ? List<Dia>.from(selectedLoteria.dias) : [] : [];
  }

  _agregarOEditar({Entidad data}) async {
    var data2 = await Navigator.pushNamed(context, "/monedas/agregar", arguments: data);
    if(data2 == null)
      return;

    _addDataToList(data2);
  }

  _addDataToList(Entidad data){
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

  _removeDataFromList(Entidad data){
    if(data != null){
      int idx = listaData.indexWhere((element) => element.id == data.id);
      if(idx != -1){
       print("_deletedataFromList _showDialogEliminar: ${data.toJson()} idx: $idx");
        listaData.removeAt(idx);
      _streamController.add(listaData);
      }
    }
  }

  
  _showDialogEliminar({Entidad data}){
    bool cargando = false;
    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return MyAlertDialog(
              title: "Eliminar", content: MyRichText(text: "Seguro que desea eliminar la moneda ", boldText: "${data.nombre}",), 
              isDeleteDialog: true,
              cargando: cargando,
              okFunction: () async {
                try {
                  setState(() => cargando = true);
                  var parsed = await EntidadesService.eliminar(context: context, data: data);
                  if(parsed["data"] != null)
                    _removeDataFromList(Entidad.fromMap(parsed["data"]));
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

 _avatarScreen(Entidad data){

    return CircleAvatar(
      backgroundColor: data.status == 1 ? Colors.green : Colors.pink,
      child: data.status == 1 ? Icon(Icons.done, color: Colors.green[100],) : Icon(Icons.unpublished, color: Colors.pink[100],),
    );
  }


   _dataScreen(AsyncSnapshot<List<Entidad>> snapshot, bool isSmallOrMedium){
    if(isSmallOrMedium){
      return SingleChildScrollView(
        child: Column(
          children: 
          snapshot.data.asMap().map((key, e){
            var valueNotify = ValueNotifier<bool>(false);
            return MapEntry(
              key,
              ListTile(
            leading: _avatarScreen(e),
            title: Text("${e.nombre}"),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${e.moneda.descripcion}"),
                // Text("${e.sorteos}"),
              ],
            ),
            onTap: (){_agregarOEditar(data: e);},
            trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){_showDialogEliminar(data: e);}),
          )
            );
          }).values.toList()
          // snapshot.data.map((e) => ListTile(
          //   leading: _avatarScreen(e),
          //   title: Text("${e.descripcion}"),
          //   isThreeLine: true,
          //   subtitle: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text("${e.abreviatura}"),
          //       // Text("${e.sorteos}"),
          //     ],
          //   ),
          //   onTap: (){_agregarOEditar(data: e);},
          //   trailing: Row(
          //     children: [
          //       ValueListenableBuilder<bool>(
          //         valueListenable: valueNotify,
          //         builder: (context, value, __) {
          //           return Row(
          //             children: [
          //               Checkbox(value: e.pordefecto == 1, onChanged: (value) async {
          //                 try {
          //                   valueNotify.value = !valueNotify.value;
          //                   var parsed = await MonedasService.pordefecto(context: context, data: e);
          //                   listaData = (parsed["monedas"] != null) ? parsed["monedas"].map<Moneda>((json) => Moneda.fromMap(json)).toList() : [];
          //                   valueNotify.value = false;
          //                   _streamController.add(listaData);
          //                 } on Exception catch (e) {
          //                   valueNotify.value = false;
          //                 }
          //               }),
          //               Visibility(visible: value, child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator()))
          //             ],
          //           );
          //         }
          //       ),
          //       IconButton(icon: Icon(Icons.delete), onPressed: (){_showDialogEliminar(data: e);}),
          //     ],
          //   ),
          // )).toList(),
        ),
      );
    }
    return MyTable(
      columns: ["#", "Entidad", "Tipo", "Moneda"], 
      rows: 
      // snapshot.data.map((e) => [
      //   e, 
      //   Text("${e.descripcion}", style: TextStyle(color: Utils.fromHex(e.color), fontWeight: FontWeight.w700),), 
      //   "${e.abreviatura}", 
      //   "${e.equivalenciaDeUnDolar}", 
      //   ValueListenableBuilder<Object>(
      //     stream: null,
      //     builder: (context, snapshot) {
      //       return Checkbox(value: e.pordefecto == 1, onChanged: (value){});
      //     }
      //   )
      // ]).toList(),
      snapshot.data.asMap().map((key, e) {
        var valueNotify = ValueNotifier<bool>(false);
        return MapEntry(
          key, 
          [
            e, 
            key + 1,
            "${e.nombre}",
            "${e.tipo != null ? e.tipo.descripcion : ''}", 
            "${e.moneda != null ? e.moneda.descripcion : ''}", 
          ]
        );
      }).values.toList(),
      isScrolled: false,
      onTap: (data){
        _agregarOEditar(data: data);
      },
      delete: (data){
        _showDialogEliminar(data: data);
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
        var element = listaData.where((element) => element.nombre.toLowerCase().indexOf(data) != -1).toList();
        print("RolesScreen _serach length: ${element.length}");
        _streamController.add(listaData.where((element) => element.nombre.toLowerCase().indexOf(data) != -1).toList());
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
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
            title: "Entidades",
            subtitle: isSmallOrMedium ? '' :  "Con las monedas puede dividir y agrupar cada una de sus bancas.",
            actions: [
              MySliverButton(title: "Crear", onTap: _agregarOEditar, showOnlyOnLarge: true,)
            ],
        ), 
        sliver: StreamBuilder<List<Entidad>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator(),));

            return SliverList(delegate: SliverChildListDelegate([
               MySubtitle(title: "${listaData.length} Entidades", showOnlyOnLarge: true,),
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