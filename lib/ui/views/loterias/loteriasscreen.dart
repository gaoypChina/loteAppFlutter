import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/services/gruposservice.dart';
import 'package:loterias/core/services/loteriaservice.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/myrich.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:rxdart/rxdart.dart';

class LoteriasScreen extends StatefulWidget {
  @override
  _LoteriasScreenState createState() => _LoteriasScreenState();
}

class _LoteriasScreenState extends State<LoteriasScreen> {
  var _formKey = GlobalKey<FormState>();
  StreamController<List<Loteria>> _streamController;
  var _txtDescripcion = TextEditingController();
  var _txtCodigo = TextEditingController();
  var _txtSearch = TextEditingController();
  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];

  List<Loteria> listaData = [];
  _init() async {
    var parsed = await LoteriaService.index(context: context);
    listaData = (parsed["loterias"] != null) ? parsed["loterias"].map<Loteria>((json) => Loteria.fromMap(json)).toList() : [];
    _streamController.add(listaData);
    print("GrupoScreen _init: $parsed");
  }

  _guardar(){

  }

  _addDataToList(Loteria data){
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

  _removeDataFromList(Loteria data){
    if(data != null){
      int idx = listaData.indexWhere((element) => element.id == data.id);
      if(idx != -1){
       print("_deletedataFromList _showDialogEliminar: ${data.toJson()} idx: $idx");
        listaData.removeAt(idx);
      _streamController.add(listaData);
      }
    }
  }

  _showDialogGuardar({Loteria data}) async {
    var data2 = await Navigator.pushNamed(context, "/loterias/agregar", arguments: data);
    if(data2 == null)
      return;

    _addDataToList(data2);

    return;
    if(data == null)
      data = Loteria();

    

    
  }


  _showDialogEliminar({Loteria data}){
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
                  var parsed = await LoteriaService.eliminar(context: context, data: data);
                  if(parsed["data"] != null)
                    _removeDataFromList(Loteria.fromMap(parsed["data"]));
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
    List<Loteria> listTmp = [];
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

  _avatarScreen(String data){

    return CircleAvatar(
      backgroundColor: listaColor[Utils.generateNumber(0, 5)],
      child: data != null ? Text(data.substring(0, 1).toUpperCase()) : null,
    );
  }

  _sorteosString(List<Draws> sorteos){
    if(sorteos == null)
      return '';

    if(sorteos.length == 0)
      return '';

    if(sorteos.length == 8)
      return 'Todos los sorteos';

    else
      return sorteos.map((e) => e.descripcion.length > 8 ? e.descripcion.substring(0, 6) : e.descripcion).join(' • ');
  }

  _dataScreen(AsyncSnapshot<List<Loteria>> snapshot, bool isSmallOrMedium){
    if(isSmallOrMedium){
      return SingleChildScrollView(
        child: Column(
          children: snapshot.data.map((e) => ListTile(
            leading: _avatarScreen(e.descripcion),
            title: Text("${e.descripcion}"),
            isThreeLine: true,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${e.abreviatura}"),
                Text("${_sorteosString(e.sorteos)}"),
              ],
            ),
            onTap: (){_showDialogGuardar(data: e);},
            trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){_showDialogEliminar(data: e);}),
          )).toList(),
        ),
      );
    }
    return MyTable(
      columns: ["Grupo", "Codigo", "Activo"], 
      rows: snapshot.data.map((e) => [e, "${e.descripcion}", "${e.abreviatura}", "${e.status == 1 ? 'Si' : 'No'}"]).toList(),
      isScrolled: false,
      onTap: (data){
        _showDialogGuardar(data: data);
      },
      delete: (data){
        _showDialogEliminar(data: data);
      },
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
    return MySearchField(controller: _txtSearch, onChanged: _search, hint: "", medium: 1, xlarge: 2.6, padding: EdgeInsets.all(0),);
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
      floatingActionButton: isSmallOrMedium ? FloatingActionButton(backgroundColor: Theme.of(context).primaryColor, child: Icon(Icons.add), onPressed: _showDialogGuardar,) : null,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          expandedHeight: isSmallOrMedium ? 105 : 85,
          title: "Loterias",
          subtitle: _subtitle(isSmallOrMedium),
          actions: [
            MySliverButton(title: "Crear", iconWhenSmallScreen: Icons.save, onTap: _showDialogGuardar, showOnlyOnLarge: true,),

          ],
        ),
        sliver: StreamBuilder<List<Loteria>>(
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
                    child: MyEmpty(title: "No hay loterias; registre nuevas loterias", icon: Icons.group_work_outlined, titleButton: "Crear nuevo grupo", onTap: _showDialogGuardar,)
                  ),
              );

            return SliverList(delegate: SliverChildListDelegate([
              MySubtitle(title: "${snapshot.data.length} Loterias", showOnlyOnLarge: true,),
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
              _dataScreen(snapshot, isSmallOrMedium),
              SizedBox(height: snapshot.data.length > 6 ? 70 : 0),

            ]));
          }
        ), 
        
      )
    );
  }
}