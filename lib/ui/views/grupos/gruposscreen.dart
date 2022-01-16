import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/drift_database.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/services/gruposservice.dart';
import 'package:loterias/ui/views/grupos/grupossearch.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mydropdownbutton.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myrich.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/showmymodalbottomsheet.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class GrupoScreen extends StatefulWidget {
  @override
  _GrupoScreenState createState() => _GrupoScreenState();
}

class _GrupoScreenState extends State<GrupoScreen> {
  var _formKey = GlobalKey<FormState>();
  StreamController<List<Grupo>> _streamController;
  var _txtDescripcion = TextEditingController();
  var _txtCodigo = TextEditingController();
  var _txtSearch = TextEditingController();
  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
  List<Grupo> listaData = [];
  List<String> opciones = ["Todos", "Activos", "Desactivados"];
  String _selectedOpcion;
  
  _init() async {
    try {
      var parsed = await GrupoService.index(context: context, retornarGrupos: true);
      print("GruposService _init $parsed");
      listaData = (parsed["grupos"] != null) ? parsed["grupos"].map<Grupo>((json) => Grupo.fromMap(json)).toList() : [];
      _streamController.add(listaData);
      print("GrupoScreen _init: $parsed");
    } on Exception catch (e) {
      _streamController.add([]);
      // TODO
    }
  }

  _guardar(){

  }

  _addDataToList(Grupo data){
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

  _removeDataFromList(Grupo data){
    if(data != null){
      int idx = listaData.indexWhere((element) => element.id == data.id);
      if(idx != -1){
       print("_deletedataFromList _showDialogEliminar: ${data.toJson()} idx: $idx");
        listaData.removeAt(idx);
      _streamController.add(listaData);
      }
    }
  }

  _addOrUpdate({Grupo data}) async {
    var data2 = await Navigator.pushNamed(context, "/grupos/agregar", arguments: data);
    return;
    if(data == null)
      data = Grupo();

    _txtCodigo.text = (data.codigo != null) ? data.codigo : '';
    _txtDescripcion.text = (data.descripcion != null) ? data.descripcion : '';

    bool cargando = false;

    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return MyAlertDialog(
              title: "${data == null ? 'Guardar' : 'Editar'} grupo", 
              cargando: cargando,
              content: Form(
                key: _formKey,
                child: Wrap(
                  children: [
                    MyTextFormField(
                      controller: _txtDescripcion,
                      title: "Grupo",
                      medium: 1,
                      isRequired: true,
                      
                    ),
                    MyTextFormField(
                      controller: _txtCodigo,
                      title: "Codigo",
                      medium: 1.5,
                      isRequired: true,
                      
                    ),
                    MyDropdown(
                      title: "Estado",
                      medium: 1,
                      hint: "${data.status == 1 ? 'Activado' : 'Desactivado'}",
                      elements: [["Activado", "Activado"], ["Desactivado", "Desactivado"]],
                      onTap: (data){
                        setState(() => data.status = (data == 'Activado') ? 1 : 0);
                      },
                    )
                  ],
                ),
              ), 
              
              okFunction: () async {
                try {
                  if(!_formKey.currentState.validate())
                    return;

                  data.descripcion = _txtDescripcion.text;
                  data.codigo = _txtCodigo.text;
                  setState(() => cargando = true);
                  var parsed = await GrupoService.guardar(context: context, grupo: data);
                  print("_addOrUpdate parsed: $parsed");
                  if(parsed["grupo"] != null)
                    _addDataToList(Grupo.fromMap(parsed["grupo"]));
                  
                  setState(() => cargando = false);
                  Navigator.pop(context);

                } on Exception catch (e) {
                  print("_addOrUpdate _erroor: $e");
                  setState(() => cargando = false);
                }
              }
            );
          }
        );
      }
    );
  }


  _showDialogEliminar({Grupo data}){
    bool cargando = false;
    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return MyAlertDialog(
              title: "Eliminar", content: MyRichText(text: "Seguro que desea eliminar el grupo ", boldText: "${data.descripcion}",), 
              isDeleteDialog: true,
              cargando: cargando,
              okFunction: () async {
                try {
                  setState(() => cargando = true);
                  var parsed = await GrupoService.eliminar(context: context, grupo: data);
                  if(parsed["grupo"] != null)
                    _removeDataFromList(Grupo.fromMap(parsed["grupo"]));
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

  _filtrar(data){
    List<Grupo> listTmp = [];
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
      listaData.where((element) => element.status == 1).toList().forEach((element) {print("_opcionChanged loteria: ${element.descripcion} status: ${element.status}");});

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
        var element = listaData.where((element) => element.descripcion.toLowerCase().indexOf(data) != -1).toList();
        print("RolesScreen _serach length: ${element.length}");
        _streamController.add(listaData.where((element) => element.descripcion.toLowerCase().indexOf(data) != -1).toList());
      }
  }

  _avatarScreen(Grupo data){

    return CircleAvatar(
      backgroundColor: data.status == 1 ? Colors.green : Colors.pink,
      child: data.status == 1 ? Icon(Icons.done, color: Colors.green[100],) : Icon(Icons.unpublished, color: Colors.pink[100],),
    );
  }

  _bancas(Grupo data){
    String bancas = "-";
    if(data == null)
      return bancas;
    if(data.bancas.length == 0)
      return "-";

    bancas = data.bancas.map((e) => e.descripcion).toList().join(", ");
    return bancas.length <= 40 ? bancas : bancas.substring(0, 40);
  }

  _dataScreen(AsyncSnapshot<List<Grupo>> snapshot, bool isSmallOrMedium){
    if(isSmallOrMedium){
      return SingleChildScrollView(
        child: Column(
          children: snapshot.data.map((e) => ListTile(
            isThreeLine: true,
            leading: _avatarScreen(e),
            title: Text("${e.descripcion}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${e.codigo}"),
                Row(
                  children: [
                    Expanded(child: Text("${e.bancas != null ? e.bancas.length > 0 ? e.bancas.map((b) => b.descripcion).join(' • ') : '' : ''}", softWrap: true, overflow: TextOverflow.ellipsis,)),
                  ],
                )
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
            columns: ["Grupo", "Codigo", "Bancas", "Activo"], 
            rows: snapshot.data.map((e) => [e, "${e.descripcion}", "${e.codigo}", "${_bancas(e)}", "${e.status == 1 ? 'Si' : 'No'}"]).toList(),
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
        Grupo data = await showSearch(context: context, delegate: GruposSearch(listaData));
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
           "Agrega grupos para que agrupes, dividas y separes tus bancas y usuarios.";
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
          title: "Grupos",
          subtitle: _subtitle(isSmallOrMedium),
          actions: [
            // MySliverButton(title: "Guardar", iconWhenSmallScreen: Icons.save, onTap: _addOrUpdate),
            MySliverButton(title: "", iconWhenSmallScreen: Icons.filter_alt_sharp, onTap: _filterScreen, showOnlyOnSmall: true,),
            MySliverButton(title: "Crear", iconWhenSmallScreen: Icons.filter_alt_sharp, onTap: _addOrUpdate, showOnlyOnLarge: true,),

          ],
        ),
        sliver: StreamBuilder<List<Grupo>>(
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
                    child: MyEmpty(title: "No hay grupos; registre nuevos grupos", icon: Icons.group_work_outlined, titleButton: "Crear nuevo grupo", onTap: _addOrUpdate,)
                  ),
              );

            return SliverList(delegate: SliverChildListDelegate([
              MySubtitle(title: "${snapshot.data.length} Grupos", showOnlyOnLarge: true,),
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