import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/grupopermiso.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/rol.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mycheckbox.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';

class RolScreen extends StatefulWidget {
  final TipoUsuario tipoUsuario;
  final List<Permiso> permisos;
  final List<TipoUsuario> listaTipoUsuario;
  final List<Grupopermiso> listaGrupo;
  RolScreen({Key key, @required this.tipoUsuario, @required this.permisos, @required this.listaTipoUsuario, @required this.listaGrupo}) : super(key: key);
  @override
  _RolScreenState createState() => _RolScreenState();
}

class _RolScreenState extends State<RolScreen> {
  ScrollController _scrollController;
  TipoUsuario tipoUsuario;
  bool cargando = false;
  TipoUsuario _tipoUsuarioDialog;
  List<Permiso> permisos;
  List<Widget> listaWidget = [];
  List<Grupopermiso> listaGrupo;
  List<TipoUsuario> listaTipoUsuario;


  _init(){
    tipoUsuario = widget.tipoUsuario != null ? widget.tipoUsuario : widget.listaTipoUsuario[0];
    _tipoUsuarioDialog = tipoUsuario;
    listaGrupo = List.from(widget.listaGrupo);
    listaTipoUsuario = List.from(widget.listaTipoUsuario);
    permisos = (widget.permisos != null) ? List.from(widget.permisos) : [];
    listaGrupo.forEach((element) {
      element.permisos.forEach((e) {
        e.seleccionado = false;
      });
    });

    if(tipoUsuario != null && permisos.length == 0){
      listaGrupo.forEach((entidad) {
        entidad.permisos.forEach((permiso) {
          bool esPermisoRol = _tipoUsuarioDialog.permisos.indexWhere((permisoRol) => permisoRol.id == permiso.id) != -1;
          permiso.seleccionado = (tipoUsuario.permisos.indexWhere((permisoRol) => permisoRol.id == permiso.id) != -1) ? true : false;
          permiso.esPermisoRol = esPermisoRol;
        });
      });

    }
    else if(tipoUsuario != null && permisos.length > 0){
      listaGrupo.forEach((entidad) {
        entidad.permisos.forEach((permiso) {
          bool esPermisoRol = _tipoUsuarioDialog.permisos.indexWhere((permisoRol) => permisoRol.id == permiso.id) != -1;
          print("_showDialog esPermisoRol: $esPermisoRol}");
          // permiso.seleccionado = ( esPermisoRol || permisos.indexWhere((permisoUsuario) => permiso.id ==  permisoUsuario.id) != -1) ? true : false;
          permiso.seleccionado = (permisos.indexWhere((permisoUsuario) => permiso.id ==  permisoUsuario.id) != -1) ? true : false;
          permiso.esPermisoRol = esPermisoRol;
        });
      });
    }

    // listaWidget = listaGrupo.map<Widget>((e) => _permissionScreen(e)).toList();
    //         listaWidget.insert(0, Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //           Padding(
    //             padding: const EdgeInsets.only(right: 8.0),
    //             child: MyDropdown(
    //               title: "Rol",
    //               hint: (_tipoUsuarioDialog != null) ? _tipoUsuarioDialog.descripcion : null,
    //               medium: 1.0,
    //               elements: listaTipoUsuario.map((e) => [e, e.descripcion]).toList(),
    //               onTap: _permisosChanged
    //             ),
    //           ),
    //         ],));
  }
    

    

    


         

            

            

  _back({TipoUsuario tipoUsuario}){
    Navigator.pop(context, tipoUsuario);
  }

  _guardar() async {
    // if(_formKey.currentState.validate()){
      setState(() => cargando = true);
      List<Permiso> permisosToReturn = [];
      
      for(Grupopermiso element in listaGrupo) {
        for(Permiso element2 in element.permisos) {
      print("_guardar for in permisosToReturn: ${element2.toJson()}");

          if(element2.seleccionado)
            permisosToReturn.add(element2);
        }
      };
      // var parsed = await RoleService.store(context: context, rol: rolToSave);
      setState(() => cargando = false);
      TipoUsuario _tipoUsuarioToReturn = TipoUsuario(id: _tipoUsuarioDialog.id, permisos: permisosToReturn);
      _back(tipoUsuario: _tipoUsuarioToReturn);
    // }
  }

  Widget _myPermissionCheckbox(Permiso permiso){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 6),
      child: MyCheckBox(
        // color: (permiso.esPermisoRol) ? Colors.green : null,
        // disable: permiso.esPermisoRol,
        medium: 3,
        title: "${permiso.descripcion}",
        value: permiso.seleccionado,
        onChanged: (bool value){
          print("RolesScreen _myPermissionCheckbox: $value");                                 
          setState(() => permiso.seleccionado = value);
        },
      ),
    );
  }


  Widget _myEntityCheckbox(Grupopermiso grupopermiso){
              bool todosLosPermisosDeEstaEntidadPertenencenAEsteRol = (grupopermiso.permisos.length == grupopermiso.permisos.where((element) => element.seleccionado == true).toList().length && grupopermiso.permisos.length == grupopermiso.permisos.where((element) => element.esPermisoRol == true).toList().length);
    return AbsorbPointer(
      absorbing: todosLosPermisosDeEstaEntidadPertenencenAEsteRol,
      child: Checkbox(
            onChanged: (data){ 
              setState(() {
              // _ckbExpansion = data;
                grupopermiso.permisos.forEach((element) => element.seleccionado = data);
            });
            }, 
          activeColor: todosLosPermisosDeEstaEntidadPertenencenAEsteRol ? Colors.grey : null,
          value: grupopermiso.permisos.length == grupopermiso.permisos.where((element) => element.seleccionado == true).toList().length
        ),
    );
  }

  ExpansionTile _permissionScreen(Grupopermiso grupopermiso){
      int permisosSeleccionados = grupopermiso.permisos.where((element) => element.seleccionado == true).toList().length;
    return ExpansionTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: _myEntityCheckbox(grupopermiso),
      ),
      title: Text("${grupopermiso.descripcion}", style: TextStyle(fontFamily: "GoogleSans"),),
      subtitle: Text("${permisosSeleccionados == grupopermiso.permisos.length ? 'Todos' : permisosSeleccionados} seleccionados", style: TextStyle(fontSize: 12, fontFamily: "GoogleSans"),),
      children: [
        Center(
          child: MyResizedContainer(
            // color: Colors.red,
            medium: 2,
            small: 1.5,
            child: Wrap(
              children: grupopermiso.permisos.map((e) => _myPermissionCheckbox(e)).toList(),
            ),
          ),
        )
      ],
    );
              
  }

  _permisosChanged(dynamic data){
    setState((){ 
            // for(Entidad entidad in listaGrupo){
            // for(Permiso p in entidad.permisos){
            //   p.esPermisoRol = true;
            // }
            // _permisosChanged();
            _tipoUsuarioDialog = data;
            print("setState rol: ");
            for(Grupopermiso element in listaGrupo) {
              for(Permiso e in element.permisos) {
                e.seleccionado = false;
                e.esPermisoRol = false;
              }
            }

            // if(rol != null && permisos.length == 0){
              // print(set)
              for(Grupopermiso entidad in listaGrupo) {
                for(Permiso permiso in entidad.permisos) {
                  // if(init)
                  
                    if (_tipoUsuarioDialog.id != tipoUsuario.id) {
                      bool esPermisoRol = _tipoUsuarioDialog.permisos.indexWhere((permisoRol) => permisoRol.id == permiso.id) != -1;
                      permiso.seleccionado = (_tipoUsuarioDialog.permisos.indexWhere((permisoRol) => permisoRol.id == permiso.id) != -1) ? true : false;
                      permiso.esPermisoRol = esPermisoRol;
                    }else{
                      bool esPermisoRol = _tipoUsuarioDialog.permisos.indexWhere((permisoRol) => permisoRol.id == permiso.id) != -1;
                      print("_showDialog esPermisoRol: ${_tipoUsuarioDialog.permisos.length}");
                      // if (init) {
                      permiso.seleccionado = ( esPermisoRol || permisos.indexWhere((permisoUsuario) => permiso.id ==  permisoUsuario.id) != -1) ? true : false;
                      permiso.esPermisoRol = esPermisoRol;
                    }
                  // else
                  //   setState(() => permiso.seleccionado = (rol.permisos.indexWhere((permisoRol) => permisoRol.id == permiso.id) != -1) ? true : false);
                }
              }

          });
        
  }


  Widget _screen(List<Widget> widgets){
    return Scrollbar(controller: _scrollController, isAlwaysShown: true, child: SingleChildScrollView(controller: _scrollController, child: Wrap(children: widgets)));
  }


  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    _init();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    
            
        listaWidget = listaGrupo.map<Widget>((e) => _permissionScreen(e)).toList();
            listaWidget.insert(0, Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: MyDropdown(
                  title: "Rol",
                  hint: (_tipoUsuarioDialog != null) ? _tipoUsuarioDialog.descripcion : null,
                  medium: 1.0,
                  elements: listaTipoUsuario.map((e) => [e, e.descripcion]).toList(),
                  onTap: _permisosChanged
                ),
              ),
            ],));

    if(!isSmallOrMedium)
      return MyAlertDialog(
        title: "Roles", 
        content: _screen(listaWidget), 
        okFunction: _guardar
      );

    return myScaffold(
      context: context, cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Seleccionar rol",
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar, color: Colors.green,)
          ],
        ), 
        sliver: 
        // SliverList(delegate: SliverChildListDelegate([
          SliverFillRemaining(child: SingleChildScrollView(child: Wrap(children: listaWidget))),
            
              
        // ]))
      )
    );
  }
}