import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/version.dart';
import 'package:loterias/core/services/versionesservice.dart';
import 'package:loterias/ui/views/actualizar/versionsearch.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myrich.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/showmymodalbottomsheet.dart';
import 'package:rxdart/rxdart.dart';

class VersionesScreen extends StatefulWidget {
  @override
  VersionesScreenState createState() => VersionesScreenState();
}

class VersionesScreenState extends State<VersionesScreen> {
  var _formKey = GlobalKey<FormState>();
  StreamController<List<Version>> _streamController;
  var _txtDescripcion = TextEditingController();
  var _txtCodigo = TextEditingController();
  var _txtSearch = TextEditingController();
  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
  List<Version> listaData = [];
  List<String> opciones = ["Todos", "Activos", "Desactivados"];
  String _selectedOpcion;
  
  _init() async {
    try {
      var parsed = await VersionService.index(context: context);
      print("VersionesScreen _init $parsed");
      listaData = (parsed["versiones"] != null) ? parsed["versiones"].map<Version>((json) => Version.fromMap(json)).toList() : [];
      _streamController.add(listaData);
      print("VersionesScreen _init: $parsed");
    } on Exception catch (e) {
      _streamController.add([]);
      // TODO
    }
  }

  _guardar(){

  }

  _addDataToList(Version data){
    if(data != null){
      int idx = listaData.indexWhere((element) => element.id == data.id);
      if(idx != -1)
        listaData[idx] = data;
      else
        listaData.add(data);

      _streamController.add(listaData);
    }
  }

  _showTest(){
    showDialog(context: context, builder: (context){
      return MyAlertDialog(title: "Jean", content: Text("Klk"), okFunction: (){});
    });
  }

  _removeDataFromList(Version data){
    if(data != null){
      int idx = listaData.indexWhere((element) => element.id == data.id);
      if(idx != -1){
       print("_deletedataFromList _showDialogEliminar: ${data.toJson()} idx: $idx");
        listaData.removeAt(idx);
      _streamController.add(listaData);
      }
    }
  }

  _addOrUpdate({Version data}) async {
    var data2 = await Navigator.pushNamed(context, "/versiones/agregar", arguments: data);
    _addDataToList(data2);
   
  }


  _showDialogEliminar({Version data}){
    bool cargando = false;
    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return MyAlertDialog(
              title: "Eliminar", content: MyRichText(text: "Seguro que desea eliminar la version ", boldText: "${data.version}",), 
              isDeleteDialog: true,
              cargando: cargando,
              okFunction: () async {
                // try {
                //   setState(() => cargando = true);
                //   var parsed = await VersionService.eliminar(context: context, data: data);
                //   if(parsed["grupo"] != null)
                //     _removeDataFromList(Grupo.fromMap(parsed["grupo"]));
                //   setState(() => cargando = false);
                //   Navigator.pop(context);
                // } on Exception catch (e) {
                //   print("_showDialogEliminar error: $e");
                //   setState(() => cargando = false);
                // }
              }
            );
          }
        );
      }
    );
  }


  _filtrar(data){
    List<Version> listTmp = [];
    if(data == "Activos")
      listTmp = listaData.where((e) => e.status == 1).toList();
    else if(data == "Desactivados")
      listTmp = listaData.where((e) => e.status == 0).toList();
    else 
      listTmp = listaData;

    _streamController.add(listTmp);
  }

  _opcionChanged(String opcion){
    _selectedOpcion = opcion;
    // print("_opcionChanged: $opcion activas: ${opcion == "Activas"}");
    if(opcion == "Activos"){
      listaData.where((element) => element.status == 1).toList().forEach((element) {print("_opcionChanged loteria: ${element.version} status: ${element.status}");});

      _streamController.add(listaData.where((element) => element.status == 1).toList());
    }
    else if(opcion == "Desactivados")
      _streamController.add(listaData.where((element) => element.status == 0).toList());
    else
      _streamController.add(listaData);

  }

  _filterScreen(){
    if(_selectedOpcion == null)
      _selectedOpcion = opciones[0];

      opcionChanged(String opcion){
        setState(() => _selectedOpcion = opcion);
        _opcionChanged(opcion);
        Navigator.pop(context);
      }

    showMyModalBottomSheet(
      context: context,
      myBottomSheet2: MyBottomSheet2(
        child: Column(children: opciones.map((e) => CheckboxListTile(title: Text("$e"), value: _selectedOpcion == e, controlAffinity: ListTileControlAffinity.leading, onChanged: (value){opcionChanged(e);})).toList(),),
      )
    );
  }

  _search(String data){
    print("SucursalesSCreen _search: $data");
    if(data.isEmpty)
      _streamController.add(listaData);
    else
      {
        var element = listaData.where((element) => element.version.toLowerCase().indexOf(data) != -1).toList();
        print("RolesScreen _serach length: ${element.length}");
        _streamController.add(listaData.where((element) => element.version.toLowerCase().indexOf(data) != -1).toList());
      }
  }

  _avatarScreen(Version data){

    return CircleAvatar(
      backgroundColor: data.status == 3 ? Colors.green : data.status == 1 ? Colors.grey : Colors.pink,
      child: data.status == 3 ? Icon(Icons.done, color: Colors.green[100],) : Icon(Icons.unpublished, color: data.status == 1 ? Colors.grey[100] : Colors.pink[100],),
    );
  }



  Text _getVersion2and3(Version data){
    String text = data.version2 != null ? '${data.version2}' : null;
    
    if(text != null && data.version3 != null)
      text += "  •  ${data.version3}";
    
    return Text("${text != null ? text : ''}");
  }

  _dataScreen(AsyncSnapshot<List<Version>> snapshot, bool isSmallOrMedium){
    if(isSmallOrMedium){
      return SingleChildScrollView(
        child: Column(
          children: snapshot.data.map((e) => ListTile(
            isThreeLine: true,
            leading: _avatarScreen(e),
            title: Text("${e.version}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getVersion2and3(e),
                Text("Urgente: ${e.urgente ? 'Si' : 'No'}")
              ],
            ),
            onTap: (){_addOrUpdate(data: e);},
            trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){_showDialogEliminar(data: e);}),
          )).toList(),
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: MyTable(
            columns: ["Version1", "Version2", "Version3", "Urgente"], 
            rows: snapshot.data.map((e) => [e, "${e.version}", "${e.version2}", "${e.version3}", "${e.urgente == 1 ? 'Si' : 'No'}"]).toList(),
            isScrolled: false,
            
            onTap: (data){
              _addOrUpdate(data: data);
            },
            delete: (data){
              _showDialogEliminar(data: data);
            },
          ),
        ),
      ],
    );
  }

  _mydropdown(){
    return MyDropdown(
      title: "Filtrar por",
      hint: "Todos",
      elements: [
        ["Todos", "Todos"],
        ["Activos", "Activos"],
        ["Desactivados", "Desactivados"],
      ],
      onTap: _filtrar,
      showOnlyOnLarge: true,
    );
  }

  Widget _mysearch(){
    return GestureDetector(
      onTap: () async {
        Version data = await showSearch(context: context, delegate: VersionSearch(listaData));
        if(data == null)
          return;
  
        _addOrUpdate(data: data);
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
           "Maneja y actualiza las versiones de tus aplicaciones";
  }

  @override
  void initState() {
    // TODO: implement initState
    _streamController = BehaviorSubject();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    _init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context,
      cargando: false,
      isSliverAppBar: true,
      cargandoNotify: null,
      inicio: true,
      floatingActionButton: isSmallOrMedium ? FloatingActionButton(backgroundColor: Theme.of(context).primaryColor, child: Icon(Icons.add), onPressed: _addOrUpdate,) : null,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          expandedHeight: isSmallOrMedium ? 105 : 85,
          title: "Versiones",
          subtitle: _subtitle(isSmallOrMedium),
          actions: [
            // MySliverButton(title: "Guardar", iconWhenSmallScreen: Icons.save, onTap: _addOrUpdate),
            MySliverButton(title: "", iconWhenSmallScreen: Icons.filter_alt_sharp, onTap: _filterScreen, showOnlyOnSmall: true,),
            MySliverButton(title: "Crear", iconWhenSmallScreen: Icons.filter_alt_sharp, onTap: _addOrUpdate, showOnlyOnLarge: true,),

          ],
        ),
        sliver: StreamBuilder<List<Version>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if(snapshot.hasData == false)
              return SliverFillRemaining(
              child: Center(
                  child: CircularProgressIndicator()
                ),
            );

            if(snapshot.data.length == 0 && listaData.length == 0)
              return SliverFillRemaining(
                child: Center(
                    child: MyEmpty(title: "No hay versiones; registre nuevas versiones", icon: Icons.group_work_outlined, titleButton: "Crear nueva versiones", onTap: _addOrUpdate,)
                  ),
              );

            return SliverList(delegate: SliverChildListDelegate([
              MySubtitle(title: "${snapshot.data.length} Versiones", showOnlyOnLarge: true,),
              Stack(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _mydropdown(),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0, top: 18.0),
                      child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar loteria...", xlarge: 2.6, showOnlyOnLarge: true,),
                    ))
                ],
              ),
              _dataScreen(snapshot, isSmallOrMedium)
            ]));
          }
        ), 
        
      )
    );
  }
}