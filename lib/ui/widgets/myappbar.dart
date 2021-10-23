import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/principal.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:loterias/ui/widgets/showmyoverlayentry.dart';
import 'package:rxdart/rxdart.dart';

import 'myalertdialog.dart';
import 'mydropdown.dart';
import 'mymultiselectdialog.dart';
import 'myresizecontainer.dart';
import 'mysearch.dart';
import 'mysubtitle.dart';
import 'mytextformfield.dart';

myAppBar({bool cargando = false, BuildContext context, Function onTap}){
  var _txtSearch = TextEditingController();
  var _overlayEntry;
  var _cargandoNotify = ValueNotifier<bool>(false);
  _salir({OverlayEntry overlay}){
    Principal.cerrarSesion(context);
    overlay.remove();
  }

  _showDialogCambiarContrasena(Usuario usuario){
    
  }

   _showDialogGuardar({Usuario usuario}){
     bool cargando = false;
     var _txtNombres = TextEditingController();
     var _txtPassword = TextEditingController();
     var _txtApellidos = TextEditingController();
     var _txtUsuario = TextEditingController();
     var _txtTelefono = TextEditingController();
     var _txtCorreo = TextEditingController();
    //  List<Rol> listaRol = [];
    //  List<Sucursal> listaSucursal = [];
    //  List<Ruta> listaRuta = [];
    //  List<Caja> listaCaja = [];
    //  List<Caja> _cajas = [];
    //  Rol _rol;
    //  Sucursal _sucursal;
    //  Ruta _ruta;

    if(usuario == null)
      usuario = Usuario();
    
    print("_showDialogGuardar id: ${usuario.id}");
    List<Permiso> permisos = (usuario.permisos != null) ? (usuario.permisos.length > 0) ? usuario.permisos : null : null;
    StreamController<Widget> _streamControllerFoto = BehaviorSubject();
    // _streamControllerFoto.add(Utils.getWidgetUploadFoto(usuario, radius: 30));
    // _txtNombres.text = (usuario.nombres != null) ? usuario.nombres : '';
    // _txtPassword.text = '';
    // // _txtApellidos.text = (usuario.apellidos != null) ? usuario.apellidos : '';
    // // _txtUsuario.text = (usuario.usuario != null) ? usuario.usuario : '';
    // // _txtTelefono.text = (usuario.contacto != null) ? (usuario.contacto.telefono != null) ? usuario.contacto.telefono : '' : '';
    // // _txtCorreo.text = (usuario.contacto != null) ? (usuario.contacto.correo != null) ? usuario.contacto.correo : '' : '';
    // // _rol = (usuario.rol != null) ?  usuario.rol : null;
    // // String initialValueRol = (usuario.rol != null) ? usuario.rol.descripcion : null;
    // // String initialValueSucursal = (usuario.sucursal != null) ? usuario.sucursal.nombre : null;
    // _streamControllerFoto.add(Utils.getWidgetUploadFoto(usuario));
    
    showDialog(
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context, setState) {

            _showMultiSelect() async {
              var data = await showDialog<Set<int>>(
                context: context,
                builder: (context){
                  return MyMultiSelectDialog(
                    // items: listaCaja.map<MyMultiSelectDialogItem>((e) => MyMultiSelectDialogItem(e.id, e.descripcion)).toList(),
                  );
                }
              );

              if(data == null)
                return;

              if(data.length > 0){
                // for(int id in data){
                //   Caja caja = listaCaja.firstWhere((element) => element.id == id, orElse: null);
                //   if(caja == null)
                //     continue;

                //   if(_cajas.indexWhere((element) => element.id == caja.id) == -1)
                //     setState(() => _cajas.add(caja));
                // }
              }
            }

            
            _guardar() async {
              // usuario.nombres = _txtNombres.text;
              // usuario.apellidos = _txtApellidos.text;
              // usuario.usuario = _txtUsuario.text;
              // if(_txtPassword.text.isNotEmpty)
              //   usuario.password = _txtPassword.text;

              // if(usuario.contacto == null)
              //   usuario.contacto = Contacto();

              // usuario.contacto.telefono = _txtTelefono.text;
              // usuario.contacto.correo = _txtCorreo.text;
              // usuario.cajas = _cajas;
              // usuario.rol = _rol;
              // // usuario.empresa = Empresa(id: BigInt.one, nombre: "Empresa");
              // // usuario.sucursal = _sucursal;
              // // usuario.ruta = _ruta;

              // print("Guardar before permisos: ${permisos}");

              // // if(permisos == null)
              // //   permisos = _rol.permisos;

              // // if(permisos.length == 0){
              // //   Utils.showAlertDialog(context: context, title: "Error", content: "Debe asignarle por lo menos un permiso");
              // //   return;
              // // }
              // // print("Guardar permisos: ${permisos}");

              // // usuario.permisos = permisos;

              // // setState(() => cargando = true);
              // // var parsed = await UserService.storePerfil(context: context, usuario: usuario);
              // // print("_guardar parsed: $parsed");
              // // setState(() => cargando = false);
              // // // if(parsed["usuario"] != null)
              // // //   _addDataToList(Usuario.fromMap(parsed["usuario"]));
              // // Navigator.pop(context);
            }


            return MyAlertDialog(
              title: "Perfil", 
              description: "Editar tu perfil, cambia tus datos, inclusive tu contraseña.",
              cargando: cargando,
              content: Wrap(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                        onTap: () async {
                          // File file = await FilePicker.getFile();
                          // usuario.foto = await Utils.blobfileToUint(file); 
                          // _streamControllerFoto.add(Utils.getWidgetUploadFoto(usuario));

                          // FilePickerResult result = await FilePicker.platform.pickFiles();
                          // if(result != null) {
                          //   File file = File(result.files.single.path);
                          //   usuario.foto = file.readAsBytesSync(); 
                          //   _streamControllerFoto.add(Utils.getWidgetUploadFoto(usuario));
                          // } else {
                          //   // User canceled the picker
                          // }
                          
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
                          MyResizedContainer(medium: 1.58, child: MySubtitle(title: "Datos", fontSize: 17,)),
                          MyDropdown(
                            title: null,
                            isFlat: true,
                            medium: 2.8,
                            hint: "Cambiar contraseña",
                            onTap: (data){
                              _showDialogCambiarContrasena(usuario);
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
                        enabled: false,
                        title: "Usuario",
                        medium: 2.1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: MyTextFormField(
                        controller: _txtCorreo,
                        title: "Correo",
                        medium: 2.1,
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
                        medium: 3.25,
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                      child: AbsorbPointer(
                        absorbing: true,
                        child: MyDropdown(
                          enabled: false,
                          medium: 3.25,
                          title: "Cajas",
                          // hint: "${_cajas.length == 0 ? 'Ninguna' : _cajas.map((e) => e.descripcion).toList().join(", ")}",
                          onTap: _showMultiSelect,
                        ),
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
                      child: AbsorbPointer(
                        absorbing: true,
                        child: MyDropdown(
                          enabled: false,
                          medium: 3.25,
                          title: "Rol",
                          // hint: "${_rol != null ? _rol.descripcion : 'Ninguno'}",
                          // onTap: _seleccionarRolYPermisosAdicionales,
                        ),
                      )
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                    //   child: MyDropdownButton(
                    //     initialValue: (initialValueRol != null) ? initialValueRol : null,
                    //     title: "Rol",
                    //     medium: 3.25,
                    //     elements: (listaRol.length > 0) ? listaRol.map<String>((e) => e.descripcion).toList() : ["No hay datos"],
                    //     onChanged: (data){
                    //       int idx = listaRol.indexWhere((element) => element.descripcion == data);
                    //       if(idx != -1)
                    //         setState(() => _rol = listaRol[idx]);
                    //     }
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                    //   child: MyDropdownButton(
                    //     paddingBlue: EdgeInsets.only(left: 8.0, right: 8.0),
                    //     // type: MyDropdownType.blue,
                    //     medium: 3.25,
                    //     title: "Ruta",
                    //     initialValue: "${_ruta != null ? _ruta : null}",
                    //     items: listaRuta.map((e) => [e, e.descripcion]).toList(),
                    //     onChanged: (data){
                    //       _ruta = data;
                    //     },
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

  _removeOverlay(){
    if(_overlayEntry != null) _overlayEntry.remove();
  }


  OverlayEntry _createOverlayEntry(BuildContext context) {

    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    showMyOverlayEntry(
      context: context,
      right: 0,
      builder: (context, OverlayEntry overlay){
        return Container(
          width:370,
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            // border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                // spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 1.0), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.grey,)
                ),
                trailing:  ValueListenableBuilder(
                  valueListenable: _cargandoNotify, 
                  builder: (context, value, _){
                    return SizedBox(
                      width: 30,
                      height: 30,
                      child: Visibility(
                        visible: value,
                        child: new CircularProgressIndicator(),
                      ),
                    );
                  }
                ),
                // title: FutureBuilder<Map<String, dynamic>>(
                //   future: db.getUsuario(),
                //   builder: (context, snapshot) {
                //     if(snapshot.connectionState != ConnectionState.done)
                //       return SizedBox();

                //     var u = Usuario.fromMap(snapshot.data);
                //     return Text("${u.nombres} ${u.apellidos}");
                //   }
                // ),
                onTap: () async {
                  // _cargandoNotify.value = true;
                  // var parsed = await UserService.get(context: context, usuario: Usuario.fromMap(await db.getUsuario()));
                  // // print("MyAPpBar parsed: $parsed");
                  // _cargandoNotify.value = false;
                  // _removeOverlay();
                  // _showDialogGuardar(usuario: Usuario.fromMap(parsed["data"]));
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text("Ayuda"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                    child: TextButton(onPressed: (){_salir(overlay: overlay);}, child: Text("Salir")),
                  )
              ],)
            ],
          
          ),
        );
            
      }
    );


    return null;
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
                child: GestureDetector(
                  onTap: (){print("Todaa la pantallaaaaaaaaaaaaaaaaaaa"); _removeOverlay();},
                  child: Container(
                    color: Colors.transparent,
                  ),
                )
            ),
          Positioned(
            // left: offset.dx,
            right: 10,
            top: offset.dy + 60,
            width: 370,
            child:
            Material(
              elevation: 4,
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // border: Border.all(color: Colors.grey, width: 1, style: BorderStyle.solid),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      // spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 1.0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, color: Colors.grey,)
                      ),
                      trailing:  ValueListenableBuilder(
                        valueListenable: _cargandoNotify, 
                        builder: (context, value, _){
                          return SizedBox(
                            width: 30,
                            height: 30,
                            child: Visibility(
                              visible: value,
                              child: new CircularProgressIndicator(),
                            ),
                          );
                        }
                      ),
                      // title: FutureBuilder<Map<String, dynamic>>(
                      //   future: db.getUsuario(),
                      //   builder: (context, snapshot) {
                      //     if(snapshot.connectionState != ConnectionState.done)
                      //       return SizedBox();

                      //     var u = Usuario.fromMap(snapshot.data);
                      //     return Text("${u.nombres} ${u.apellidos}");
                      //   }
                      // ),
                      onTap: () async {
                        // _cargandoNotify.value = true;
                        // var parsed = await UserService.get(context: context, usuario: Usuario.fromMap(await db.getUsuario()));
                        // // print("MyAPpBar parsed: $parsed");
                        // _cargandoNotify.value = false;
                        // _removeOverlay();
                        // _showDialogGuardar(usuario: Usuario.fromMap(parsed["data"]));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.help),
                      title: Text("Ayuda"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                          child: TextButton(onPressed: _salir, child: Text("Salir")),
                        )
                    ],)
                  ],
                
                ),
              ),
            
            )
            //  Material(
            //   elevation: 4.0,
            //   child: ListView(
            //     padding: EdgeInsets.zero,
            //     shrinkWrap: true,
            //     children: <Widget>[
            //       ListTile(
            //         title: Text('Syria'),
            //       ),
            //       ListTile(
            //         title: Text('Lebanon'),
            //       )
            //     ],
            //   ),
            // ),
          ),
        ],
      )
    );
  }

  
  

  _showOptions(context){
    // _overlayEntry = _createOverlayEntry(context);
    // Overlay.of(context).insert(_overlayEntry);
    _createOverlayEntry(context);
  }

  

  return AppBar(
    automaticallyImplyLeading: Utils.isSmallOrMedium(MediaQuery.of(context).size.width) ? true : false,
    leadingWidth: 20,
        title: Row(children: [
          // IconButton(icon: Icon(Icons.menu, color: Colors.black), onPressed: (){},),
          Visibility(
            visible: !Utils.isSmallOrMedium(MediaQuery.of(context).size.width),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconButton(icon: Icon(Icons.menu), onPressed: onTap,),
            ),
          ),
          // Text("Prestamo", style: TextStyle(color: Colors.black),),
          Padding(
                padding: EdgeInsets.only(top: !Utils.isSmallOrMedium(MediaQuery.of(context).size.width) ? 8.0 : 0, left: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // BorderRadius.only(
                  //   topRight: Radius.circular(32),
                  //   bottomRight: Radius.circular(32),
                  // ),
                  child: Container(
                    // color: Colors.red,
                    // width: 150,
                    height: Utils.isSmallOrMedium(MediaQuery.of(context).size.width) ? 30 : 45,
                    child:  Container(
                      child: Image(image: AssetImage('assets/images/loterias_dominicanas_sin_letras.png'), ),
                    ),
                  ),
                ),
              ),
          Padding(
                padding: EdgeInsets.only(top: !Utils.isSmallOrMedium(MediaQuery.of(context).size.width) ? 8.0 : 2.0, left: 10.0),
                child: Container(
                  // color: Colors.red,
                  // width: 150,
                  // height: 45,
                  child:  Text("Loterias", style: TextStyle(fontSize: 22, color: Colors.black.withOpacity(.8), fontWeight: FontWeight.bold))
                ),
              ),
              Expanded(
                  child: Container(
                    // color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 90.0, top: 8),
                        child: MySearchField(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                          borderRadius: BorderRadius.circular(8),
                          iconPadding: EdgeInsets.only(left: 10, right: 16),
                          xlarge: 1.5,
                          large: 1.4,
                          medium: 1.7,
                          controller: _txtSearch,
                          hint: "Buscar clientes, bancas, loterias, entidades",
                        ),
                      ),
                    ),
                  ),
                )
        ],),
        // leading: Icon(
        //   Icons.menu,
        //   color: Colors.black
        // ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Visibility(
                    visible: cargando,
                    child: Theme(
                      data: Theme.of(context).copyWith(accentColor: Utils.colorPrimary),
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.info_outline, color: Colors.black, size: 26,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.help_outline, color: Colors.black, size: 26,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.notifications_none, color: Colors.black, size: 26,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Builder(
              builder: (context) {
                return InkWell(
                  onTap: (){_showOptions(context);},
                  child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, color: Colors.grey,)
                      ),
                );
              }
            ),
          )
        ],
      );
}