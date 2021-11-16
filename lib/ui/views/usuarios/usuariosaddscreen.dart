import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/grupopermiso.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/rol.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/services/usuarioservice.dart';
import 'package:loterias/ui/views/usuarios/rolscreen.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mycheckbox.dart';
import 'package:loterias/ui/widgets/mycontainerbutton.dart';
import 'package:loterias/ui/widgets/mydescripcion.dart';
import 'package:loterias/ui/widgets/mydivider.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/mymultiselectdialog.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioAddScreen extends StatefulWidget {
  final List<Grupo> listaGrupo;
  final List<TipoUsuario> listaTipoUsuario;
  final List<Permiso> listaPermiso;
  final Usuario usuario;
  UsuarioAddScreen({Key key, this.usuario, this.listaGrupo, this.listaTipoUsuario, this.listaPermiso}) : super(key: key);
  @override
  _UsuarioAddScreenState createState() => _UsuarioAddScreenState();
}

class _UsuarioAddScreenState extends State<UsuarioAddScreen> {
var _formKey = GlobalKey<FormState>();
StreamController<List<Usuario>> _streamController;
  StreamController<Widget> _streamControllerFoto;
  TextEditingController _txtSearch = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();
  TextEditingController _txtConfirmarPassword = TextEditingController();
  TextEditingController _txtUsuario = TextEditingController();
  TextEditingController _txtNombres = TextEditingController();
  TextEditingController _txtApellidos = TextEditingController();
  TextEditingController _txtTelefono = TextEditingController();
  TextEditingController _txtEmail = TextEditingController();
  List<Permiso> listaPermiso = [];
  List<Grupopermiso> listaGrupoPermiso = [];
  List<Usuario> listaData = [];
  List<TipoUsuario> listaTipoUsuario = [];
  List<Grupo> listaGrupo = [];
  List<Grupo> _grupos = [];
  TipoUsuario _tipoUsuario;
  Grupo _grupo;
  List<Permiso> permisos;
  Usuario usuario;
  bool _cargando = false;
  bool _status = true;
  bool _showConfirmarPassword = false;



  _init() async {
    // _streamControllerFoto.add(Utils.getWidgetUploadFoto(usuario != null ? usuario : Usuario(), size: 80.0));
    _streamControllerFoto.add(Utils.getWidgetUploadFoto(usuario != null ? usuario : Usuario(), size: 100.0));
    usuario = widget.usuario;
    listaGrupo = widget.listaGrupo;
    if(listaGrupo.length > 0)
      listaGrupo.insert(0, Grupo(id: 0, descripcion: "Ninguno"));

    listaTipoUsuario = widget.listaTipoUsuario;
    listaPermiso = widget.listaPermiso;
    _setAllFields();
    _fillEntityList();

    _txtPassword.addListener(() {
      print("_init _txtPassword.text.isNotEmpty: ${_txtPassword.text}");
      setState(() => _showConfirmarPassword = _txtPassword.text.isNotEmpty && _txtPassword.text != "");
    });

    // print("UsuarioScreen _init: ${parsed["usuariosTipos"]}");
  }

  _setAllFields(){
    _txtUsuario.text = usuario != null ? usuario.usuario : '';
    _txtNombres.text = usuario != null ? usuario.nombres : '';
    _txtTelefono.text = usuario != null ? usuario.telefono : '';
    _txtEmail.text = usuario != null ? usuario.email : '';
    _grupo = usuario != null ? usuario.grupo != null ? listaGrupo.length > 0 ? listaGrupo.firstWhere((element) => element.id == usuario.grupo.id, orElse: () => null) : null : null : null;
    _tipoUsuario = usuario != null ? usuario.tipoUsuario != null ? listaTipoUsuario.length > 0 ? listaTipoUsuario.firstWhere((element) => element.id == usuario.tipoUsuario.id, orElse: () => null) : null : null : null;
    _status = usuario != null ? usuario.status == 1 ? true : false : true;
    
  }

  

  _fillEntityList(){
    if(usuario == null)
      usuario = Usuario();


    listaPermiso.where((element) => element.idTipo == 4).toList().forEach((element) {print("UsuariosAddScreen _fillEntityList: ${element.descripcion}");});

    var grupoPermisoUsuario = Grupopermiso(id: 1, descripcion: "Usuarios", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 1).toList() : []);
    var grupoPermisoTickets = Grupopermiso(id: 2, descripcion: "Tickets", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 2).toList() : []);
    var grupoPermisoBancas = Grupopermiso(id: 3, descripcion: "Bancas", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 3).toList() : []);
    var grupoPermisoLoterias = Grupopermiso(id: 4, descripcion: "Loterias", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.descripcion == "Manejar horarios de loterias" || element.descripcion == "Manejar loterias").toList() : []);
    var grupoPermisoJugar = Grupopermiso(id: 5, descripcion: "Jugar", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 4).toList() : []);
    var grupoPermisoVentas = Grupopermiso(id: 6, descripcion: "Ventas", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 5).toList() : []);
    var grupoPermisoAccesoALSistema = Grupopermiso(id: 7, descripcion: "Acceso al sistema", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 6).toList() : []);
    var grupoPermisoTransacciones = Grupopermiso(id: 8, descripcion: "Transacciones", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 7).toList() : []);
    var grupoPermisoBalances = Grupopermiso(id: 9, descripcion: "Balances", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 8).toList() : []);
    var grupoPermisoOtros = Grupopermiso(id: 10, descripcion: "Otros", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 9).toList() : []);
    listaGrupoPermiso.addAll([grupoPermisoUsuario, grupoPermisoTickets, grupoPermisoBancas, grupoPermisoLoterias, grupoPermisoJugar, grupoPermisoVentas, grupoPermisoAccesoALSistema, grupoPermisoTransacciones, grupoPermisoBalances, grupoPermisoOtros]);
    permisos = (usuario.permisos != null) ? (usuario.permisos.length > 0) ? usuario.permisos : null : null;
    // listaEntidad.forEach((element) {
    //   element.permisos.forEach((element2) {
    //     print("_fillEntityList: ${element2.descripcion}");
    //   });
    // });
  }

  Future<TipoUsuario> _showDialog({TipoUsuario tipoUsuario, List<Permiso> permisos}) async {

    bool cargando = false;
    permisos = (permisos != null) ? permisos : [];
    TipoUsuario _tipoUsuarioDialog = tipoUsuario;

    List<TipoUsuario> listaTipoUsuarioCopia = List.from(listaTipoUsuario);
    List<Grupopermiso> listaEntidadCopia = List.from(listaGrupoPermiso);

    // print("_showDialog rol init: ${tipoUsuario.descripcion}");

    listaEntidadCopia.forEach((element) {
      element.permisos.forEach((e) {
        e.seleccionado = false;
      });
    });

    if(tipoUsuario != null && permisos.length == 0){
      listaEntidadCopia.forEach((entidad) {
        entidad.permisos.forEach((permiso) {
          bool esPermisoRol = _tipoUsuarioDialog.permisos.indexWhere((permisoRol) => permisoRol.id == permiso.id) != -1;
          permiso.seleccionado = (tipoUsuario.permisos.indexWhere((permisoRol) => permisoRol.id == permiso.id) != -1) ? true : false;
          permiso.esPermisoRol = esPermisoRol;
        });
      });

    }
    else if(tipoUsuario != null && permisos.length > 0){
      listaEntidadCopia.forEach((entidad) {
        entidad.permisos.forEach((permiso) {
          bool esPermisoRol = _tipoUsuarioDialog.permisos.indexWhere((permisoRol) => permisoRol.id == permiso.id) != -1;
          print("_showDialog esPermisoRol: $esPermisoRol}");
          permiso.seleccionado = ( esPermisoRol || permisos.indexWhere((permisoUsuario) => permiso.id ==  permisoUsuario.id) != -1) ? true : false;
          permiso.esPermisoRol = esPermisoRol;
        });
      });
    }

    List<Widget> listaWidget = [];

    return await showDialog(context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {

            Widget _myPermissionCheckbox(Permiso permiso){
              return MyCheckBox(
                // color: (permiso.esPermisoRol) ? Colors.green : null,
                disable: permiso.esPermisoRol,
                medium: 3,
                title: "${permiso.descripcion}",
                value: permiso.seleccionado,
                onChanged: (bool value){
                  print("RolesScreen _myPermissionCheckbox: $value");                                 
                  setState(() => permiso.seleccionado = value);
                },
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
                      medium: 1.2,
                      child: Wrap(
                        children: grupopermiso.permisos.map((e) => _myPermissionCheckbox(e)).toList(),
                        // children: [
                        //   MyCheckBox(
                        //     medium: 3,
                        //     title: "Crear",
                        //     value: false,
                        //   ),
                        //   MyCheckBox(
                        //     medium: 3,
                        //     title: "Actualizar",
                        //     value: false,
                        //   ),
                        //   MyCheckBox(
                        //     medium: 3,
                        //     title: "Eliminar",
                        //     value: false,
                        //   ),
                        // ],
                      ),
                    ),
                  )
                ],
              );
                        
            }

            _permisosChanged(dynamic data){
              setState((){ 
                      // for(Entidad entidad in listaEntidadCopia){
                      // for(Permiso p in entidad.permisos){
                      //   p.esPermisoRol = true;
                      // }
                      // _permisosChanged();
                      _tipoUsuarioDialog = data;
                      print("setState rol: ");
                      for(Grupopermiso element in listaEntidadCopia) {
                        for(Permiso e in element.permisos) {
                          e.seleccionado = false;
                          e.esPermisoRol = false;
                        }
                      }

                      // if(rol != null && permisos.length == 0){
                        // print(set)
                        for(Grupopermiso entidad in listaEntidadCopia) {
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

                      // }
                      // else if(rol != null && permisos.length > 0){
                      //   for(Entidad entidad in listaEntidadCopia) {
                      //     for(Permiso permiso in entidad.permisos) {
                      //       bool esPermisoRol = rol.permisos.indexWhere((permisoRol) => permisoRol.id == permiso.id) != -1;
                      //       print("_showDialog esPermisoRol: ${rol.permisos.length}");
                      //       // if (init) {
                      //         permiso.seleccionado = ( esPermisoRol || permisos.indexWhere((permisoUsuario) => permiso.id ==  permisoUsuario.id) != -1) ? true : false;
                      //         permiso.esPermisoRol = esPermisoRol;
                      //       // }else{
                      //       //   setState(() {
                      //       //     permiso.seleccionado = ( esPermisoRol || permisos.indexWhere((permisoUsuario) => permiso.id ==  permisoUsuario.id) != -1) ? true : false;
                      //       //     permiso.esPermisoRol = esPermisoRol;
                      //       //   });
                      //       // }
                      //     }
                      //   }
                      // }
                    });
                  
            }

            

            

            listaWidget = listaEntidadCopia.map<Widget>((e) => _permissionScreen(e)).toList();
            listaWidget.insert(0, Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: MyDropdown(
                  title: "Rol",
                  hint: (_tipoUsuarioDialog != null) ? _tipoUsuarioDialog.descripcion : null,
                  medium: 1.0,
                  elements: listaTipoUsuarioCopia.map((e) => [e, e.descripcion]).toList(),
                  onTap: _permisosChanged
                ),
              ),
              MySubtitle(title: "Permisos", fontSize: 16,),
              // MyDescripcon(title: "Los check de color azul son los permisos adicionales que usted a agregado y los de color gris son los permisos por defecto que tiene el rol y no se pueden modificar", fontSize: 15,)
            ],));

                _back({TipoUsuario tipoUsuario}){
                  Navigator.pop(context, tipoUsuario);
                }

                _guardar() async {
                  // if(_formKey.currentState.validate()){
                    setState(() => cargando = true);
                    List<Permiso> permisosToReturn = [];
                    
                    for(Grupopermiso element in listaEntidadCopia) {
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

            return MyAlertDialog(
              title: "Permisos adicionales", 
              // description: "Si los permisos por defectos que tiene este Rol no cumplen con lo que deseas, añade permisos especiales a este usuario para que cumpla con todas las caracteristicas que usted desea.",
              content: Wrap(children: listaWidget),
              // content: Wrap(children: [
              //   StreamBuilder(
              //     stream: _streamControllerPermiso.stream,
              //     builder: (context, snapshot){
              //       if(snapshot.hasData == false)
              //         return SizedBox();

              //       return Column(
              //         children: listaWidget = listaEntidadCopia.map<Widget>((e) => _permissionScreen(e)).toList(),
              //       );                 
              //     }
              //   )
              // ]),
              // Wrap(children: [
              //   LayoutBuilder(
              //     builder: (context, boxconstraint) {
              //       return Container(
              //         height: boxconstraint.maxHeight,
              //         color: Colors.red,
              //         child: Text("Hola")
              //         // MyScrollbar(
              //         //   child: Wrap(children: listaWidget,)
              //         // ),
              //       );
              //     }
              //   )
              // ],), 
              cargando: cargando,
              okFunction: () async {
                print("OkFunction");
                await _guardar();
              }
            );
          }
        );
      }
    );
  }

  _back([Usuario data]){
    Navigator.pop(context, data);
  }


  _showMultiSelect() async {
    var data = await showDialog(
      context: context,
      builder: (context){
        return MyMultiSelectDialog(
          items: listaGrupo.map<MyMultiSelectDialogItem>((e) => MyMultiSelectDialogItem(e.id, e.descripcion)).toList(),
        );
      }
    );

    if(data == null) {
      setState(() => _grupos = []);
      return;
    }

    if(data.length > 0){
      for(int id in data){
        Grupo grupo = listaGrupo.firstWhere((element) => element.id == id, orElse: null);
        if(grupo == null)
          continue;

        if(_grupos.indexWhere((element) => element.id == grupo.id) == -1)
          setState(() => _grupos.add(grupo));
      }
    }
  }

            
  _seleccionarRolYPermisosAdicionales() async {
    // var tipoUsuario = await _showDialog(tipoUsuario: _tipoUsuario, permisos: permisos);
    var tipoUsuario = await Navigator.push(context, MaterialPageRoute(builder: (context) => RolScreen(tipoUsuario: _tipoUsuario, permisos: permisos, listaGrupo: listaGrupoPermiso, listaTipoUsuario: listaTipoUsuario,)));
    print("_seleccionarRolYPermisosAdicionales: ${tipoUsuario}");
    if(tipoUsuario == null)
      return;

    permisos = tipoUsuario.permisos;
    int idx = listaTipoUsuario.indexWhere((element) => element.id == tipoUsuario.id);
    if(idx != -1)
      setState(() => _tipoUsuario = listaTipoUsuario[idx]);

      _tipoUsuario.permisos.forEach((element) {print("_seleccionarRolYPermisosAdicionales json: ${element.toJson()}");});

    
  }

  _guardar() async {
    if(!_formKey.currentState.validate())
      return;

    try {
      usuario.nombres = _txtNombres.text;
      usuario.apellidos = _txtApellidos.text;
      usuario.usuario = _txtUsuario.text;
      usuario.status = _status ? 1 : 0;
      if(_txtPassword.text.isNotEmpty){
        usuario.password = _txtPassword.text;
        usuario.confirmar = _txtConfirmarPassword.text;
      }
      
      if(_txtEmail.text.isEmpty)
        usuario.email = "";
      else
      usuario.email = _txtEmail.text;
      
      
      
      
      usuario.tipoUsuario = _tipoUsuario;
      
      print("Guardar before permisos: ${permisos}");
      
      if(permisos == null)
        permisos = _tipoUsuario.permisos;
      
      if(permisos.length == 0){
        Utils.showAlertDialog(context: context, title: "Error", content: "Debe asignarle por lo menos un permiso");
        return;
      }
      print("Guardar permisos: ${permisos}");
      
      usuario.grupo = _grupo;
      usuario.permisos = permisos;
      
      setState(() => _cargando = true);
      var parsed = await UsuarioService.guardar(context: context, usuario: usuario);
      print("UsuariosAddScreen _guardar parsed: $parsed");
      setState(() => _cargando = false);
      if(parsed["data"] != null)
        _back(Usuario.fromMap(parsed["data"]));
      else
        Navigator.pop(context);
    } on Exception catch (e) {
      setState(() => _cargando = false);
    }
  }

  _grupoChanged(grupo){
    setState(() => _grupo = grupo);
  }

  _showGrupos() async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            _back(){
              Navigator.pop(context);
            }
            grupoChanged(grupo){
                setState(() => _grupo = grupo.id == 0 ? null : grupo);
              _grupoChanged(grupo.id == 0 ? null : grupo);
              _back();
            }
            return Container(
              height: listaGrupo.length == 1 ? 100 : listaGrupo.length == 2 ? 150 : 200,
              child: Column(
                children: [
                  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Container(height: 5, width: 40, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(5)),)),
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaGrupo.length,
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,

                          value: _grupo == listaGrupo[index],
                          onChanged: (data){
                            grupoChanged(listaGrupo[index]);
                          },
                          title: Text("${listaGrupo[index].descripcion}"),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    _streamControllerFoto = BehaviorSubject();
    _init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bool isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context, 
      cargando: false, 
      cargandoNotify: null,
      isSliverAppBar: true,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Agregar usuario",
          actions: [
            MySliverButton(title: "Guardar", onTap: _guardar)
          ],
        ),
        sliver: SliverList(delegate: SliverChildListDelegate([
          Form(
            key: _formKey,
                  child: Wrap(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                            onTap: () async {
                              // File file = await FilePicker.getFile();
                              
                              // // usuario.foto = await Utils.blobfileToUint(file); 
                              // _streamControllerFoto.add(Utils.getWidgetUploadFoto(usuario));
                              
                              // _futureFoto = Utils.getClienteFoto(_cliente);
                              // _streamControllerFotoCliente.add(file);
                              // IO.File(file.relativePath);
                              // // base64.decode(file);
                              // setState(() {
                              //   _image = file;
                              // });
                              // _startFilePicker();
                              // print("Archivo: ${file.name}");
                              // Blo
                              // print("ArchivoType: ${file.}");

                              FilePickerResult result = await FilePicker.platform.pickFiles();

                                if(result != null) {
                                  Uint8List uploadfile = result.files.single.bytes;
                                  // File file = File(result.files.single.path);
                                  usuario.foto = uploadfile; 
                                  _streamControllerFoto.add(Utils.getWidgetUploadFoto(usuario));
                                } else {
                                  // User canceled the picker
                                }
                            },
                            child: 
                            StreamBuilder<Widget>(
                              stream: _streamControllerFoto.stream,
                              builder: (context, snapshot) {
                                if(snapshot.hasData)
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: snapshot.data,
                                  );
                                
                                return SizedBox();
                              }
                            )
                            // StreamBuilder<File>(
                            //   stream: _streamControllerFotoCliente.stream,
                            //   builder: (context, snapshot) {
                            //     if(snapshot.hasData)
                            //       _cliente.foto = snapshot.data; 
                            //     return Container(
                            //       // color: ,
                            //       width: 130,
                            //       height: 130,
                            //       child:  ClipRRect(
                            //         borderRadius: BorderRadius.circular(10),
                            //         child: Container(
                            //           child: Utils.getClienteFoto(_cliente),
                            //         ),
                            //       ),
                            //     );
                            //   }
                            // ),
                      ),
                          ],
                        ),

                        
                        MyDivider(showOnlyOnSmall: true,),
                        MyTextFormField(
                          controller: _txtUsuario,
                          leading: Icon(Icons.person),
                          type: MyType.noBorder,
                          title: "Usuario",
                          hint: "Usuario",
                          medium: 1,
                          // medium: usuario.id == null ? 3.1 : 2.1,
                        ),
                        MyDivider(showOnlyOnSmall: true,),
                        MyTextFormField(
                          controller: _txtPassword,
                          leading: Icon(Icons.lock),
                          type: MyType.noBorder,
                          isPassword: true,
                          hint: "Contraseña",
                          title: "Contraseña",
                          medium: 1,
                        ),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: 
                          _showConfirmarPassword == false
                          ?
                          SizedBox.shrink()
                          :
                          Wrap(
                              children: [
                                MyDivider(showOnlyOnSmall: true,),
                                MyTextFormField(
                                  controller: _txtConfirmarPassword,
                                  leading: Icon(Icons.lock_clock),
                                  type: MyType.noBorder,
                                  isPassword: true,
                                  hint: "Confirmar contraseña",
                                  title: "Confirmar contraseña",
                                  medium: 1,
                                  isRequired: true,
                                ),
                              ],
                            ),
                        ),
                        MyDivider(showOnlyOnSmall: true,),
                        MyTextFormField(
                          controller: _txtNombres,
                          leading: Icon(Icons.perm_identity),
                          type: MyType.noBorder,
                          hint: "Nombres",
                          medium: 1,
                        ),
                        MyDivider(showOnlyOnSmall: true,),
                        MyTextFormField(
                          controller: _txtTelefono,
                          leading: Icon(Icons.phone),
                          type: MyType.noBorder,
                          hint: "Telefono",
                          medium: 1,
                        ),
                        MyDivider(showOnlyOnSmall: true,),
                        MyTextFormField(
                          controller: _txtEmail,
                          leading: Icon(Icons.email),
                          type: MyType.noBorder,
                          hint: "Correo",
                          medium: 1,
                        ),
                        MyDivider(showOnlyOnSmall: true,),
                        ListTile(
                          leading: Icon(Icons.rowing_outlined),
                          title: Align(alignment: Alignment.centerLeft, child: MyContainerButton(textColor: Colors.pink, iconColor: Colors.pink, borderColor: Colors.grey, data: [_grupo, "${_tipoUsuario != null ? _tipoUsuario.descripcion : 'Agregar rol'}"], onTap: (data){_seleccionarRolYPermisosAdicionales();}))
                        ),
                        MyDivider(showOnlyOnSmall: true,),
                        ListTile(
                          leading: Icon(Icons.group_work),
                          title:  Align(alignment: Alignment.centerLeft, child: MyContainerButton(borderColor: Colors.grey, data: [_grupo, "${_grupo != null ? _grupo.descripcion : 'Agregar grupo'}"], onTap: (data){_showGrupos();}))
                        ),
                        MyDivider(showOnlyOnSmall: true,),
                        MySwitch( 
                          leading: Icon(Icons.check_box),
                          title: "Activo", 
                          medium: 1,
                          value: _status, 
                          onChanged: (value){setState(() => _status = value);}
                        )
                        // MyDropdown(
                        //   medium: 3.25,
                        //   title: "Grupos",
                        //   showOnlyOnLarge: true,
                        //   hint: "${_grupo != null ? _grupo.descripcion : 'Ninguno'}",
                        //   elements: listaGrupo.map((e) => [e, "${e.descripcion}"]).toList(),
                        //   onTap: (data){
                        //     setState(() => _grupo = data);
                        //   },
                        //   // onTap: _showMultiSelect,
                        // ),
                        
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                        //   child: MyDropdown(
                        //     medium: 3.25,
                        //     title: "Rol",
                        //     hint: "${_tipoUsuario != null ? _tipoUsuario.descripcion : 'Ninguno'}",
                        //     onTap: _seleccionarRolYPermisosAdicionales,
                        //   )
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                        //   child: MyDropdownButton(
                        //     initialValue: (initialValueRol != null) ? initialValueRol : null,
                        //     title: "Rol",
                        //     medium: 3.25,
                        //     elements: (listaTipoUsuario.length > 0) ? listaTipoUsuario.map<String>((e) => e.descripcion).toList() : ["No hay datos"],
                        //     onChanged: (data){
                        //       int idx = listaTipoUsuario.indexWhere((element) => element.descripcion == data);
                        //       if(idx != -1)
                        //         setState(() => _tipoUsuario = listaTipoUsuario[idx]);
                        //     }
                        //   ),
                        // ),
                       
                    ],
                  ),
          ), 
                
        ])),
      )
    );
  }
}