import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/moor_database.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/services/gruposservice.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
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

  List<Grupo> listaData = [];
  _init() async {
    var parsed = await GrupoService.index(context: context);
    listaData = (parsed["grupos"] != null) ? parsed["grupos"].map<Grupo>((json) => Grupo.fromMap(json)).toList() : [];
    _streamController.add(listaData);
    print("GrupoScreen _init: $parsed");
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

  _showDialogGuardar({Grupo data}) async {
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
                  print("_showDialogGuardar parsed: $parsed");
                  if(parsed["grupo"] != null)
                    _addDataToList(Grupo.fromMap(parsed["grupo"]));
                  
                  setState(() => cargando = false);
                  Navigator.pop(context);

                } on Exception catch (e) {
                  print("_showDialogGuardar _erroor: $e");
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
    return myScaffold(
      context: context,
      cargando: false,
      isSliverAppBar: true,
      cargandoNotify: null,
      inicio: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Grupos",
          subtitle: "Agrega grupos para que agrupes, dividas y separes tus bancas y usuarios.",
          actions: [
            MySliverButton(title: "Guardar", iconWhenSmallScreen: Icons.save, onTap: _showDialogGuardar),

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
                    child: MyEmpty(title: "No hay grupos; registre nuevos grupos", icon: Icons.group_work_outlined, titleButton: "Crear nuevo grupo", onTap: _showDialogGuardar,)
                  ),
              );

            return SliverList(delegate: SliverChildListDelegate([
              MySubtitle(title: "${snapshot.data.length} Grupos"),
              Stack(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyDropdown(
                    title: "Filtrar por",
                    hint: "Todos",
                    elements: [
                      ["Todos", "Todos"],
                      ["Activos", "Activos"],
                      ["Desactivados", "Desactivados"],
                    ],
                    onTap: _filtrar,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0, top: 18.0),
                      child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar loteria...", xlarge: 2.6,),
                    ))
                ],
              ),
              MyTable(
              columns: ["Grupo", "Codigo", "Activo"], 
              rows: snapshot.data.map((e) => [e, "${e.descripcion}", "${e.codigo}", "${e.status == 1 ? 'Si' : 'No'}"]).toList(),
              isScrolled: false,
              onTap: (data){
                _showDialogGuardar(data: data);
              },
              delete: (data){
                _showDialogEliminar(data: data);
              },
            )
            ]));
          }
        ), 
        
      )
    );
  }
}