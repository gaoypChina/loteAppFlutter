import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/drift_database.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/grupo.dart';
import 'package:loterias/core/models/grupopermiso.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/rol.dart';
import 'package:loterias/core/models/tipos.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/core/services/usuarioservice.dart';
import 'package:loterias/ui/views/usuarios/rolscreen.dart';
import 'package:loterias/ui/views/usuarios/usuariosaddscreen.dart';
import 'package:loterias/ui/views/usuarios/usuariosmultisearch.dart';
import 'package:loterias/ui/views/usuarios/usuariossearch.dart';
import 'package:loterias/ui/views/usuarios/vercontrasenasdialog.dart';
import 'package:loterias/ui/widgets/myalertdialog.dart';
import 'package:loterias/ui/widgets/mybottomsheet2.dart';
import 'package:loterias/ui/widgets/myresizedcheckbox.dart';
import 'package:loterias/ui/widgets/mycollapsechanged.dart';
import 'package:loterias/ui/widgets/mycolor.dart';
import 'package:loterias/ui/widgets/mydescripcion.dart';
import 'package:loterias/ui/widgets/mydropdown.dart';
import 'package:loterias/ui/widgets/myempty.dart';
import 'package:loterias/ui/widgets/mymultiselectdialog.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/myrich.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysearch.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytable.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';
import 'package:loterias/ui/widgets/showmymodalbottomsheet.dart';
import 'package:rxdart/rxdart.dart';

class UsuarioScreen extends StatefulWidget {
  @override
  _UsuarioScreenState createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  bool _cargando = false;
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
  TipoUsuario _tipoUsuario = TipoUsuario();
  Grupo _grupo = Grupo();
  var developerImage;
  List<String> opciones = ["Todos", "Activos", "Desactivados"];
  String _selectedOpcion;
  int _idGrupoDeEsteUsuario;
  static String _opcionObtenerContrasenas = "Obtener contrasenas";


  _init() async {
    _idGrupoDeEsteUsuario = await Db.idGrupo();
    var parsed = await UsuarioService.index(context: context, idGrupo: _idGrupoDeEsteUsuario, retornarUsuarios: true);
    print("UsuariosScreen _init parsed: $parsed");
    listaData = (parsed["usuarios"] != null) ? parsed["usuarios"].map<Usuario>((json) => Usuario.fromMap(json)).toList() : [];
    listaGrupo = (parsed["grupos"] != null) ? parsed["grupos"].map<Grupo>((json) => Grupo.fromMap(json)).toList() : [];
    listaTipoUsuario = (parsed["usuariosTipos"] != null) ? parsed["usuariosTipos"].map<TipoUsuario>((json) => TipoUsuario.fromMap(json)).toList() : [];
    listaPermiso = (parsed["permisos"] != null) ? parsed["permisos"].map<Permiso>((json) => Permiso.fromMap(json)).toList() : [];
    _streamController.add(listaData);
    _fillEntityList();
    developerImage = Image(image: AssetImage('assets/images/web-development.png'));
    // print("UsuarioScreen _init: ${parsed["usuariosTipos"]}");
  }

  

  _fillEntityList(){
    var grupoPermisoUsuario = Grupopermiso(id: 1, descripcion: "Usuarios", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 1).toList() : []);
    var grupoPermisoTickets = Grupopermiso(id: 1, descripcion: "Tickets", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 2).toList() : []);
    var grupoPermisoBancas = Grupopermiso(id: 1, descripcion: "Bancas", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 3).toList() : []);
    var grupoPermisoLoterias = Grupopermiso(id: 1, descripcion: "Loterias", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 4).toList() : []);
    var grupoPermisoJugar = Grupopermiso(id: 1, descripcion: "Jugar", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 5).toList() : []);
    var grupoPermisoVentas = Grupopermiso(id: 1, descripcion: "Ventas", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 6).toList() : []);
    var grupoPermisoAccesoALSistema = Grupopermiso(id: 1, descripcion: "Acceso al sistema", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 7).toList() : []);
    var grupoPermisoTransacciones = Grupopermiso(id: 1, descripcion: "Transacciones", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 8).toList() : []);
    var grupoPermisoBalances = Grupopermiso(id: 1, descripcion: "Balances", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 9).toList() : []);
    var grupoPermisoOtros = Grupopermiso(id: 1, descripcion: "Otros", permisos: (listaPermiso.length > 0) ? listaPermiso.where((element) => element.idTipo == 10).toList() : []);
    listaGrupoPermiso.addAll([grupoPermisoUsuario, grupoPermisoTickets, grupoPermisoBancas, grupoPermisoLoterias, grupoPermisoJugar, grupoPermisoVentas, grupoPermisoAccesoALSistema, grupoPermisoTransacciones, grupoPermisoBalances, grupoPermisoOtros]);
    // listaEntidad.forEach((element) {
    //   element.permisos.forEach((element2) {
    //     print("_fillEntityList: ${element2.descripcion}");
    //   });
    // });
  }
  
  _guardar(){

  }

   _addDataToList(Usuario usuario){
    if(usuario == null)
      return;

    print("_addDataToList: ${usuario.toJson()}");


    int idx = listaData.indexWhere((element) => element.id == usuario.id);
    if(idx != -1)
      listaData[idx] = usuario;
    else
      listaData.add(usuario);

    print("_addDataToList: ${usuario.toJson()}");

    _streamController.add(listaData);
  }

  _removeDataFromList(Usuario usuario){
    if(usuario == null)
      return;

    int idx = listaData.indexWhere((element) => element.id == usuario.id);
    if(idx != -1)
      listaData.removeAt(idx);

    _streamController.add(listaData);
  }

  _filtroChanged(dynamic data){
    if(data == "Activa")
      _streamController.add(listaData.where((element) => element.status == 1).toList());
    else if(data == "Desactivada")
      _streamController.add(listaData.where((element) => element.status == 0).toList());
    else
      _streamController.add(listaData);
  }


   _showDialogGuardar({Usuario data}) async {
     Usuario usuario = data;
     if(Utils.isSmallOrMedium(MediaQuery.of(context).size.width)){
       Usuario returnedUser = await Navigator.push(context, MaterialPageRoute(builder: (context){
         return UsuarioAddScreen(
           usuario: data, 
          //  listaGrupo: listaGrupo, 
          //  listaTipoUsuario: listaTipoUsuario, 
          //  listaPermiso: listaPermiso,
          );
       }));

       if(returnedUser == null)
        return;

        var idx = listaData.indexWhere((element) => element.id == returnedUser.id);
        if(idx == -1)
          listaData.add(returnedUser);
        else
          listaData[idx] = returnedUser;

        _streamController.add(listaData);

       return;
     }else{
      //  Usuario returnedUser = await Navigator.push(context, MaterialPageRoute(builder: (context){
      //    return UsuarioAddScreen(usuario: data, listaGrupo: listaGrupo, listaTipoUsuario: listaTipoUsuario, listaPermiso: listaPermiso,);
      //  }));

       await Navigator.push(
          context,
          PageRouteBuilder(
            barrierDismissible: true,
            opaque: false,
            pageBuilder: (_, anim1, anim2) =>
                FadeTransition(
              opacity: anim1,
              child: UsuarioAddScreen(
                usuario: data, 
                // listaGrupo: listaGrupo, 
                // listaTipoUsuario: listaTipoUsuario, 
                // listaPermiso: listaPermiso,
              ),
            ),

          ),
        );

        return;
     }
    if(usuario == null)
      usuario = Usuario();

    print("_showDialogGuardar id: ${usuario.id}");
    List<Permiso> permisos = (usuario.permisos != null) ? (usuario.permisos.length > 0) ? usuario.permisos : null : null;
    _streamControllerFoto.add(Utils.getWidgetUploadFoto(usuario, radius: 30));
    _txtNombres.text = (usuario.nombres != null) ? usuario.nombres : '';
    _txtPassword.text = '';
    _txtApellidos.text = (usuario.apellidos != null) ? usuario.apellidos : '';
    _txtUsuario.text = (usuario.usuario != null) ? usuario.usuario : '';
    _txtEmail.text = (usuario.email != null) ? (usuario.email != null) ? usuario.email : '' : '';
    _tipoUsuario = (usuario.tipoUsuario != null) ? listaTipoUsuario.firstWhere((element) => element.id == usuario.tipoUsuario.id) : (listaTipoUsuario != null) ? (listaTipoUsuario.length > 0) ? listaTipoUsuario[0] : null : null;
    _grupo = (usuario.grupo != null) ? (listaGrupo.length > 0) ? listaGrupo.firstWhere((element) => element.id == usuario.grupo.id, orElse: () => null) : null : null;

    print("_showDialogGuardar grupo: ${_grupo == null}");
    // _tipoUsuario.permisos.forEach((element) {print("_showDialogGuardar permiso rol: ${element.descripcion}");});
    // return;
    
    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {

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
              print("_seleccionarRolYPermisosAdicionales before: ${_tipoUsuario.permisos}");
              var tipoUsuario = await _showDialog(tipoUsuario: _tipoUsuario, permisos: permisos);
              // var tipoUsuario = await Navigator.push(context, MaterialPageRoute(builder: (context) => RolScreen(tipoUsuario: _tipoUsuario, permisos: permisos, listaGrupo: listaGrupoPermiso, listaTipoUsuario: listaTipoUsuario,)));
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
              try {
                usuario.nombres = _txtNombres.text;
                usuario.apellidos = _txtApellidos.text;
                usuario.usuario = _txtUsuario.text;
                if(_txtPassword.text.isNotEmpty)
                  usuario.password = _txtPassword.text;
                if(usuario.id == null)
                  usuario.confirmar = _txtConfirmarPassword.text;
                
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
                print("_guardar parsed: $parsed");
                setState(() => _cargando = false);
                if(parsed["usuario"] != null)
                  _addDataToList(Usuario.fromMap(parsed["usuario"]));
                Navigator.pop(context);
              } on Exception catch (e) {
                setState(() => _cargando = false);
              }
            }


            return MyAlertDialog(
              title: "${(usuario == null) ? 'Guardar' : 'Editar'}", 
              description: "Agrega todo tipo de usuarios como cajeros, cobradores, supervisores y administradores.",
              cargando: _cargando,
              content: Wrap(
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
                  
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Wrap(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyResizedContainer(medium: 1.5, child: MySubtitle(title: "Datos", fontSize: 17,)),
                          MyDropdown(
                            title: null,
                            isFlat: true,
                            medium: 3.8,
                            hint: "${(usuario.status == 1) ? 'Activo' : 'Desactivado'}",
                            elements: [["Activo", "Activo"], ["Desactivado", "Desactivado"]],
                            onTap: (data){
                              setState(() => usuario.status = (data == 'Activo') ? 1 : 0);
                            },
                          )
                          // FlatButton(onPressed: _seleccionarRolYPermisosAdicionales, child: Text("Permisos adicionales", style: TextStyle(color: Colors.blue[700], fontFamily: "GoogleSans", fontSize: 18, letterSpacing: 0.4)))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: MyTextFormField(
                        controller: _txtUsuario,
                        
                        title: "Usuario",
                        medium: usuario.id == null ? 3.1 : 2.1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: MyTextFormField(
                        controller: _txtPassword,
                        isPassword: true,
                        title: "Contraseña",
                        medium: usuario.id == null ? 3.1 : 2.1,
                      ),
                    ),
                    Visibility(
                      visible: usuario.id == null,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                        child: MyTextFormField(
                          controller: _txtConfirmarPassword,
                          isPassword: true,
                          title: "Confirmar contraseña",
                          medium: 3.1,
                          isRequired: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: MyTextFormField(
                        controller: _txtNombres,
                        
                        title: "Nombres",
                        medium: 2.1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: MyTextFormField(
                        controller: _txtApellidos,
                        title: "Apellidos",
                        medium: 2.1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: MyTextFormField(
                        controller: _txtTelefono,
                        title: "Telefono",
                        medium: 2.1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: MyTextFormField(
                        controller: _txtEmail,
                        title: "Correo",
                        medium: 2.1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: MyDropdown(
                        medium: 3.25,
                        title: "Grupos",
                        showOnlyOnLarge: true,
                        hint: "${_grupo != null ? _grupo.descripcion : 'Ninguno'}",
                        elements: listaGrupo.map((e) => [e, "${e.descripcion}"]).toList(),
                        onTap: (data){
                          setState(() => _grupo = data);
                        },
                        // onTap: _showMultiSelect,
                      )
                      // MyDropdownButton(
                      //   title: "Cajas",
                      //   medium: 3.25,
                      //   elements: (listaCaja.length > 0) ? listaCaja.map<String>((e) => e.descripcion).toList() : ["No hay datos"],
                      //   onChanged: (data){

                      //   }
                      // ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: MyDropdown(
                        medium: 3.25,
                        title: "Rol",
                        hint: "${_tipoUsuario != null ? _tipoUsuario.descripcion : 'Ninguno'}",
                        onTap: _seleccionarRolYPermisosAdicionales,
                      )
                    ),
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
              okFunction: _guardar
            );
          }
        );
      }
    );
  }

  Future<TipoUsuario> _showDialog({TipoUsuario tipoUsuario, List<Permiso> permisos}) async {

    bool cargando = false;
    permisos = (permisos != null) ? permisos : [];
    TipoUsuario _tipoUsuarioDialog = tipoUsuario;

    List<TipoUsuario> listaTipoUsuarioCopia = List.from(listaTipoUsuario);
    List<Grupopermiso> listaEntidadCopia = List.from(listaGrupoPermiso);

    print("_showDialog rol init: ${tipoUsuario.descripcion}");

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
              return MyResizedCheckBox(
                // color: (permiso.esPermisoRol) ? Colors.green : null,
                // disable: permiso.esPermisoRol,
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
                        //   MyResizedCheckBox(
                        //     medium: 3,
                        //     title: "Crear",
                        //     value: false,
                        //   ),
                        //   MyResizedCheckBox(
                        //     medium: 3,
                        //     title: "Actualizar",
                        //     value: false,
                        //   ),
                        //   MyResizedCheckBox(
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
              MyDescripcon(title: "Los check de color azul son los permisos adicionales que usted a agregado y los de color gris son los permisos por defecto que tiene el rol y no se pueden modificar", fontSize: 15,)
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
              description: "Si los permisos por defectos que tiene este Rol no cumplen con lo que deseas, añade permisos especiales a este usuario para que cumpla con todas las caracteristicas que usted desea.",
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

  _showDialogEliminar({Usuario data}){
    bool cargando = false;
    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {
            return MyAlertDialog(
              title: "Eliminar", content: MyRichText(text: "Seguro que desea eliminar el grupo ", boldText: "${data.usuario}",), 
              isDeleteDialog: true,
              cargando: cargando,
              okFunction: () async {
                try {
                  setState(() => cargando = true);
                  var parsed = await UsuarioService.eliminar(context: context, usuario: data);
                  if(parsed["data"] != null)
                    _removeDataFromList(Usuario.fromMap(parsed["data"]));
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
    List<Usuario> listTmp = [];
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
        _streamController.add(listaData.where((element) => element.usuario.toLowerCase().indexOf(data) != -1 || element.nombres.toLowerCase().indexOf(data) != -1).toList());
      }
  }

  _getPhoto(String namePhoto, {double size: 40.0, double radius: 20.0}){
    return Container(
          // color: Colors.blue,
          width: size,
          height: size,
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              // color: Colors.blue,
              child: FadeInImage(
                image: NetworkImage(
                    '${Utils.URL}/assets/perfil/$namePhoto'),
                placeholder: AssetImage('assets/images/newprofile.jpg'),
              )
            ),
          ),
        );
    
  }

   Widget _mysearch(){
    return GestureDetector(
      onTap: () async {
          Usuario usuario = await showSearch(context: context, delegate: UsuariosSearch(listaData, _idGrupoDeEsteUsuario));
          if(usuario == null)
            return;
    
          _showDialogGuardar(data: usuario);
      }, 
      child: MySearchField(
        controller: _txtSearch, 
        enabled: false, 
        hint: "", 
        medium: 1, 
        xlarge: 2.6,
        padding: EdgeInsets.all(0), 
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
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
    "Maneje todos sus usuarios con sus respectivos permisos";
  }

  // _avatarScreen(String data){
  //   // List<Color> listaColor = [Colors.red, Colors.pink, Colors.purpleAccent, Colors.green, Colors.greenAccent, Colors.blueGrey];
  //   Color color;
  //   IconData icon;
  //   if(data == "Programador"){
  //     color = Colors.lightGreenAccent;
  //     icon = Icons.build;
  //   }
  //   else if(data == "Banquero"){
  //     color = Colors.blueGrey;
  //     icon = Icons.attach_money;
  //   }
  //   else if(data == "Supervisor"){
  //     color = Colors.pink;
  //     // icon = Icons.
  //   }
  //   else
  //     color = MyColors.lightBlue;


  //   return CircleAvatar(
  //     backgroundColor: color,
  //     // child: data != null ? data == "Programador" ? developerImage : Text(data.substring(0, 1).toUpperCase()) : null,
  //     child: data != null ? Text(data.substring(0, 1).toUpperCase()) : null,
  //   );
  // }


_avatarScreen(Usuario data){

    return CircleAvatar(
      backgroundColor: data.status == 1 ? Colors.green : Colors.pink,
      child: data.status == 1 ? Icon(Icons.done, color: Colors.green[100],) : Icon(Icons.unpublished, color: Colors.pink[100],),
    );
  }



  _dataScreen(AsyncSnapshot<List<Usuario>> snapshot, bool isSmallOrMedium){
    if(isSmallOrMedium){
      return SingleChildScrollView(
        child: Column(
          children: snapshot.data.map((e) => ListTile(
            leading: _avatarScreen(e),
            title: Text("${e.nombres} • ${e.usuario}"),
            subtitle: Text("${e.tipoUsuario.descripcion}"),
            onTap: (){_showDialogGuardar(data: e);},
            trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){_showDialogEliminar(data: e);}),
          )).toList(),
        ),
      );
    }
    return  MyTable(
      type: MyTableType.custom,
      columns: ["Nombre", "Usuario", "Rol", "Activo"], 
      rows: snapshot.data.map((e) => [
        e, 
        Row(
          children: [
            _getPhoto(e.nombreFoto), 
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text("${e.nombres} ${e.apellidos}"),
            )
          ]
        ),
        "${e.usuario}", 
        "${e.tipoUsuario.descripcion}", 
        "${e.status == 1 ? 'Si' : 'No'}"]).toList(),
      isScrolled: false,
      onTap: (data){
        _showDialogGuardar(data: data);
      },
      delete: (data){
        _showDialogEliminar(data: data);
      },
      );
               
  }


  _opcionChanged(String opcion){
    _selectedOpcion = opcion;
    // print("_opcionChanged: $opcion activas: ${opcion == "Activas"}");
    if(opcion == "Activos"){
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

  _menuOpcionesChild(bool isSmallOrMedium){
    if(isSmallOrMedium)
      return Icon(Icons.more_vert);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Mas opciones", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),),
        Icon(Icons.arrow_drop_down, color: Colors.grey[600])
      ],
    );
  }

  List<PopupMenuItem<String>> _getMenuOpciones(){
     List<PopupMenuItem<String>> opciones = [
      PopupMenuItem<String>(
        value: _opcionObtenerContrasenas,
        child: Text("Ver contrasenas"),
      )
    ];

    return opciones;
  }

  _seleccionarUsuariosYVerContrasenas(bool isSmallOrMedium) async {
    List<Usuario> usuariosSeleccionados = [];
    if(isSmallOrMedium)
      usuariosSeleccionados = await showSearch(context: context, delegate: UsuariosMultiSearch(listaData, []));
      
    showDialog(context: context, builder: (context) => VerContrasenasDialog(idUsuarios: usuariosSeleccionados.map((e) => e.id).toList(),));
  }

  Widget _menuOpcionesWidget(bool isSmallOrMedium){

  return PopupMenuButton(
    child: Padding(
      padding: EdgeInsets.all(10.0),
      child: _menuOpcionesChild(isSmallOrMedium),
    ),
    onSelected: (String value)  async {
      if(value == _opcionObtenerContrasenas)
        _seleccionarUsuariosYVerContrasenas(isSmallOrMedium);
    },
    itemBuilder: (context) => _getMenuOpciones()
  );

}


  @override
  void initState() {
    // TODO: implement initState
    _streamController = BehaviorSubject();
    _streamControllerFoto = BehaviorSubject();

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
    bool isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);
    return myScaffold(
      context: context,
      cargando: false,
      isSliverAppBar: true,
      usuarios: true,
      floatingActionButton: isSmallOrMedium ? FloatingActionButton(child: Icon(Icons.add), onPressed: _showDialogGuardar) : null,
      sliverBody: MySliver(
        sliverAppBar: MySliverAppBar(
          title: "Usuarios",
          floating: true,
          subtitle: _subtitle(isSmallOrMedium),
          expandedHeight: isSmallOrMedium ? 105 : 85,
          actions: [
            MySliverButton(title: "Crear", iconWhenSmallScreen: Icons.filter_alt_sharp, onTap: _filterScreen, showOnlyOnSmall: true,),
            MySliverButton(
              title: "Agregar",
              // iconWhenSmallScreen: Icons.person_add,
              onTap: _showDialogGuardar,
              showOnlyOnLarge: true,
            ),
            MySliverButton(title: _menuOpcionesWidget(isSmallOrMedium),),
          ],
        ), 
        sliver: StreamBuilder<List<Usuario>>(
          stream: _streamController.stream,
          builder: (context, snapshot){
            if(snapshot.hasData && snapshot.data.length > 0)
              return SliverList(delegate: SliverChildListDelegate([
                MySubtitle(title: "${snapshot.data.length} Usuarios", showOnlyOnLarge: true,),
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
                        showOnlyOnLarge: true,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0, top: 18.0),
                          child: MySearchField(controller: _txtSearch, onChanged: _search, hint: "Buscar por nombre o usuario...", xlarge: 2.6, showOnlyOnLarge: true,),
                        ))
                    ],
                  ),
                 _dataScreen(snapshot, isSmallOrMedium),
                 SizedBox(height: snapshot.data.length > 6 ? 70 : 0),
               ]));
            else if(snapshot.hasData && snapshot.data.length == 0)
              return SliverFillRemaining(child: MyEmpty(title: "No hay usuarios; agrega nuevo usuario", icon: Icons.person_add, titleButton: "Agregar nuevo usuario", onTap: _showDialogGuardar,));
            else
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
          }
        ),
      )
    );
  }
}