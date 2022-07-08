import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/draws.dart';
import 'package:loterias/core/models/loterias.dart';
import 'package:loterias/core/services/bancaservice.dart';
import 'package:loterias/core/services/loteriaservice.dart';
import 'package:loterias/ui/views/bancas/bancassearch.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mybottomsheet.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
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

class BancasScreen extends StatefulWidget {
  @override
  _BancasScreenState createState() => _BancasScreenState();
}

class _BancasScreenState extends State<BancasScreen> {
  var _formKey = GlobalKey<FormState>();
  StreamController<List<Banca>> _streamController;
  var _txtDescripcion = TextEditingController();
  var _txtCodigo = TextEditingController();
  var _txtSearch = TextEditingController();
  List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
  List<Banca> listaData = [];
  List<String> opciones = ["Todos", "Activas", "Desactivadas"];
  String _selectedOpcion;
  int _idGrupoDeEsteUsuario;

  _init() async {
    _idGrupoDeEsteUsuario = await Db.idGrupo();
    var parsed = await BancaService.index(context: context, retornarBancas: true, idGrupo: _idGrupoDeEsteUsuario);
    listaData = (parsed["bancas"] != null) ? parsed["bancas"].map<Banca>((json) => Banca.fromMap(json)).toList() : [];
    _streamController.add(listaData);
    print("BancasScreen _init: $parsed");
  }

  _guardar(){

  }

  _addDataToList(Banca data){
    if(data != null){
      int idx = listaData.indexWhere((element) => element.id == data.id);
      if(idx != -1){
        print("BancasSCreen _addDataToList If: ${data.toJsonSave()}");
        listaData[idx] = data;
      }else{
        print("BancasSCreen _addDataToList Else: ${data.toJson()}");
        listaData.add(data);
      }
      _streamController.add(listaData);
    }
  }

  _showTest(){
    showDialog(context: context, builder: (context){
      return MyAlertDialog(title: "Jean", content: Text("Klk"), okFunction: (){});
    });
  }

  _removeDataFromList(Banca data){
    if(data != null){
      int idx = listaData.indexWhere((element) => element.id == data.id);
      if(idx != -1){
       print("_deletedataFromList _showDialogEliminar: ${data.toJson()} idx: $idx");
        listaData.removeAt(idx);
      _streamController.add(listaData);
      }
    }
  }

  _showDialogGuardar({Banca data}) async {
    var data2 = await Navigator.pushNamed(context, "/bancas/agregar", arguments: data.id);
    if(data2 == null)
      return;

    _addDataToList(data2);
  }


  _showDialogEliminar({Banca data}){
    bool cargando = false;
    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return MyAlertDialog(
              title: "Eliminar", content: MyRichText(text: "Seguro que desea eliminar la banca ", boldText: "${data.descripcion}",), 
              isDeleteDialog: true,
              cargando: cargando,
              okFunction: () async {
                try {
                  setState(() => cargando = true);
                  var parsed = await BancaService.eliminar(context: context, data: data);
                  if(parsed["data"] != null)
                    _removeDataFromList(Banca.fromMap(parsed["data"]));
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
    List<Banca> listTmp = [];
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

  _avatarScreen(Banca banca){

    return CircleAvatar(
      backgroundColor: banca.status == 1 ? Colors.green : Colors.pink,
      child: banca.status == 1 ? Icon(Icons.done, color: Colors.green[100],) : Icon(Icons.unpublished, color: Colors.pink[100],),
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

  _dataScreen(AsyncSnapshot<List<Banca>> snapshot, bool isSmallOrMedium){
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
                Text("${e.codigo}"),
                // Text("${e.sorteos}"),
              ],
            ),
            onTap: (){_showDialogGuardar(data: e);},
            trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){_showDialogEliminar(data: e);}),
          )).toList(),
        ),
      );
    }
    return MyTable(
      columns: ["Banca", "Codigo", "Usuario", "Moneda", "Activo"], 
      rows: snapshot.data.map((e) => [e, "${e.descripcion}", "${e.codigo}", "${e.usuario != null ? e.usuario.usuario : ''}", Text("${e.monedaObject != null ? e.monedaObject.descripcion : ''}", style: TextStyle(color: e.monedaObject != null ? Utils.fromHex(e.monedaObject.color) : null, fontWeight: FontWeight.w700),), "${e.status == 1 ? 'Si' : 'No'}"]).toList(),
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
    return GestureDetector(
      onTap: () async {
        var data = await showSearch(context: context, delegate: BancasSearch(listaData, _idGrupoDeEsteUsuario));
        if(data == null)
          return;

        _showDialogGuardar(data: data);
      }, 
      child: MySearchField(enabled: false, controller: _txtSearch, hint: "", medium: 1, xlarge: 2.6, padding: EdgeInsets.all(0), contentPadding: const EdgeInsets.symmetric(vertical: 12),));
  }

  _subtitle(bool isSmallOrMedium){
         return isSmallOrMedium 
           ?
           MyCollapseChanged(
             actionWhenCollapse: MyCollapseAction.hide,
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: _mysearch(),
             ),
           )
           :
           "Agrega grupos para que agrupes, dividas y separes tus bancas y usuarios.";
  }

_opcionChanged(String opcion){
  _selectedOpcion = opcion;
  if(opcion == "Activas")
    _streamController.add(listaData.where((element) => element.status == 1).toList());
  else if(opcion == "Desactivadas")
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
      bancas: true,
      floatingActionButton: isSmallOrMedium ? FloatingActionButton(backgroundColor: Theme.of(context).primaryColor, child: Icon(Icons.add), onPressed: _showDialogGuardar,) : null,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          floating: isSmallOrMedium ? true : false,
          expandedHeight: isSmallOrMedium ? 105 : 85,
          title: "Bancas",
          subtitle: _subtitle(isSmallOrMedium),
          actions: [
            MySliverButton(title: "Crear", iconWhenSmallScreen: Icons.save, onTap: _showDialogGuardar, showOnlyOnLarge: true,),
            MySliverButton(title: "Crear", iconWhenSmallScreen: Icons.filter_alt_sharp, onTap: _filterScreen, showOnlyOnSmall: true,),

          ],
        ),
        sliver: StreamBuilder<List<Banca>>(
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
                    child: MyEmpty(title: "No hay loterias; registre nuevas loterias", icon: Icons.account_balance, titleButton: "Crear nuevo grupo", onTap: _showDialogGuardar,)
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
                      child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar banca...", xlarge: 2.6, showOnlyOnLarge: true,),
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