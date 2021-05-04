import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/bancas.dart';
import 'package:loterias/core/models/permiso.dart';
import 'package:loterias/core/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:loterias/core/services/loginservice.dart';
import 'package:loterias/core/services/realtime.dart';
import 'package:loterias/ui/contacto/contactoscreen.dart';
import 'dart:convert';

import 'package:loterias/ui/views/principal/principal.dart';
import 'package:loterias/ui/views/principal/prueba2.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {
  Color _colorPrimary = Utils.fromHex("#38B6FF");
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _txtUsuarioController = TextEditingController();
  var _txtPasswordController = TextEditingController();
  var _recordarme = false;
  bool _cargando = false;
  FocusNode _txtPasswordFocusNode;


_showSnackBar(String content){
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(content),
          action: SnackBarAction(label: 'CERRAR', onPressed: () => _scaffoldKey.currentState.hideCurrentSnackBar(),),
        ));
    }

  //   Future<Map<String, dynamic>> fetchUsuario() async{
  //   var map = Map<String, dynamic>();
  //   var map2 = Map<String, dynamic>();

  //   map["usuario"] = _txtUsuarioController.text;
  //   map["password"] = _txtPasswordController.text;
  //   map2["datos"] = map;
  //   final response = await http.post(Utils.URL + '/api/acceder', body: json.encode(map2), headers: Utils.header);
    
  //   if(response.statusCode < 200 || response.statusCode > 400){
  //     print('parsed ${response.body}');
  //      throw Exception('Failed to load album');
  //   }
   
  //     var parsed = Utils.parseDatos(response.body);
  //     if(parsed["errores"] == 1){
  //       _showSnackBar(parsed["mensaje"]);
  //       throw Exception('Failed to load usuario datos incorrectos');
  //     }
  //     // print('parsed ${parsed['usuario']}');
  //     // _usuario = Usuario.fromMap(parsed['usuario']);
  //     // _banca = Banca.fromMap(parsed['bancaObject']);
  //     // return parsed['usuario'].map<Usuario>((json) => Usuario.fromMap(json)).toList();
  //     return parsed;
  // }

  void _navigateToHome(){
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => Prueba2()
    //   )
    //   // MaterialPageRoute(
    //   //   builder: (BuildContext context) => PrincipalApp(callThisScreenFromLogin: true,)
    //   // )
    // );
    Navigator.pushReplacementNamed(context, "/principal", arguments: true);
  }

  _navigateToContact(){
    // Navigator.pushNamed(context, "/contacto", arguments: true);
    showModalBottomSheet(
      context: context, 
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context){
      return ContactoScreen();
    });
  }
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _txtPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _txtPasswordFocusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        
        child: Column(
          children: <Widget>[

            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 20),
                child: Container(
                  width: 60,
                  height: 60,
                  child:  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        widthFactor: 0.75,
                        heightFactor: 0.75,
                        child: Image(image: AssetImage('assets/images/loterias_dominicanas_sin_letras.png'), ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(child: Text('Acceder', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: _txtUsuarioController,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (data){
                        _txtPasswordFocusNode.requestFocus();
                      },
                      decoration: InputDecoration(labelText: 'Usuario'),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Debe introducir un usuario';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: _txtPasswordController,
                      obscureText: true,
                      focusNode: _txtPasswordFocusNode,
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Debe introducir una contrasena';
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: 
                              // MyCheckbox(
                              //   value: _recordarme, 
                              //   onChanged: (value){
                              //     setState(() => _recordarme = value);
                              //   }
                              // ),
                              Checkbox(
                                value: _recordarme, 
                                onChanged: (value){
                                  setState(() => _recordarme = value);
                                }
                              ),
                            ),
                            Text('Recordarme'),
                          ],
                        ),
                      ),
                       Padding(
                         padding: const EdgeInsets.only(right: 20),
                         child: RaisedButton(
                          child: 
                            (_cargando) 
                            ? 
                            SizedBox(
                              width: 27,
                              height: 27,
                              child: Visibility(
                                visible: _cargando,
                                child: Theme(
                                  data: Theme.of(context).copyWith(accentColor: Colors.white),
                                  child: new CircularProgressIndicator(),
                                ),
                              ),
                            ) 
                            : 
                            Text('Acceder'),
                          color: _colorPrimary,
                          onPressed: () async {
                            if(_formKey.currentState.validate()){
                              try{
                                setState(() => _cargando = true);
                                var parsed = await LoginService.acceder(usuario: _txtUsuarioController.text.toString(), password: _txtPasswordController.text.toString(), scaffoldkey: _scaffoldKey);
                                var c = await DB.create();
                                await c.add("recordarme", _recordarme);
                                await c.add("apiKey", parsed["apiKey"]);
                                await c.add("idUsuario", parsed["usuario"]["id"]);
                                await c.add("administrador", parsed["administrador"]);
                                await c.add("tipoUsuario", parsed["tipoUsuario"]);
                                await c.add("usuario", _txtUsuarioController.text.toString());
                                await c.add("password", _txtPasswordController.text.toString());
                                

                                await LoginService.guardarDatos(parsed);
                                await Realtime.sincronizarTodosDataBatch(_scaffoldKey, parsed["realtime"]);
                                setState(() => _cargando = false);

                                _navigateToHome();
                              }on Exception catch(e){
                                print("Error desde login: ${e.toString()}");

                                setState(() => _cargando = false);
                              }
                            }
                          },
                      ),
                       ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: Wrap(
                  children: [
                    Text(
                      'Desea registrarse o ha olvidado la contrasena?. Comuniquese con el administrador para reestablecerla.', 
                      style: TextStyle(color: Colors.grey, ),
                      textAlign: TextAlign.center,
                    ),
                    Center(child: TextButton(onPressed: _navigateToContact, child: Text("Contacto")))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'condiciones de uso', 
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
    

     
  }

 
}