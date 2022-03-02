
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:loterias/core/services/loginservice.dart';
import 'package:loterias/core/services/realtime.dart';
import 'package:loterias/ui/contacto/contactoscreen.dart';
import 'package:loterias/ui/widgets/mybutton.dart';
import 'package:loterias/ui/widgets/mycheckbox.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';


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
  Future<Ajuste> _futureAjuste;

  Future<Ajuste> _getAjuste() async {
    Ajuste ajuste=  await (await DB.create()).getAjuste();
    print("LoginScreen _getAjuste: ${ajuste != null ? ajuste.toJson() : 'null'}");
    return ajuste;
  }

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

  _navigateToContact() async{
    // Navigator.pushNamed(context, "/contacto", arguments: true);

    Ajuste ajuste = await (await DB.create()).getAjuste();
    if(ajuste == null)
      return;


    showModalBottomSheet(
      context: context, 
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context){
      return ContactoScreen(data: ajuste,);
    });
  }

  Future<void> _acceder() async {
    if(_formKey.currentState.validate()){
      try{
        setState(() => _cargando = true);
        var parsed = await LoginService.acceder(usuario: _txtUsuarioController.text.toString(), password: _txtPasswordController.text.toString(), context: context);
        var c = await DB.create();
        await c.add("recordarme", _recordarme);
        await c.add("apiKey", parsed["apiKey"]);
        await c.add("idUsuario", parsed["usuario"]["id"]);
        await c.add("administrador", parsed["administrador"]);
        await c.add("tipoUsuario", parsed["tipoUsuario"]);
        await c.add("usuario", _txtUsuarioController.text.toString());
        await c.add("password", _txtPasswordController.text.toString());
        // if(parsed["ajustes"] != null){
        //   if(parsed["ajustes"]["whatsapp"] != null && parsed["ajustes"]["whatsapp"] != '')
        //     await c.add("ajusteWhatsapp", parsed["ajustes"]["whatsapp"]);
        //   else
        //     await c.delete("ajusteWhatsapp");
        //   if(parsed["ajustes"]["email"] != null && parsed["ajustes"]["email"] != '')
        //     await c.add("ajusteEmail", parsed["ajustes"]["email"]);
        //   else
        //     await c.delete("ajusteEmail");
        // }



        await LoginService.guardarDatos(parsed);
        await Realtime.sincronizarTodosDataBatch(_scaffoldKey, parsed["realtime"]);
        setState(() => _cargando = false);

        _navigateToHome();
      }on dynamic catch(e){
        print("Error desde login: ${e.toString()}");
        Utils.showAlertDialog(content: e.toString(), title: "Error", context: context);

        setState(() => _cargando = false);
      }
    }
  }

  _contactoWidget([bool isSmallOrMedium = true]){
    return FutureBuilder<Ajuste>(
      future: _futureAjuste,
      builder: (context, snapshot) {
        if(snapshot.connectionState != ConnectionState.done || !snapshot.hasData)
          return SizedBox.shrink();

        if((snapshot.data.email == null && snapshot.data.whatsapp == null) || (snapshot.data.email == '' && snapshot.data.whatsapp == ''))
          return SizedBox.shrink();

        TextButton contactoTextButton = TextButton(onPressed: _navigateToContact, child: Text("Contacto"));

        return isSmallOrMedium ? Center(child: contactoTextButton) : contactoTextButton;
      }
    );
  }

  void _recordarmeChanged(value){
    setState(() => _recordarme = value);
  }

  Widget _largeScreen(){
    return Container(
        color: Colors.white,
        // decoration:  BoxDecoration(
        //   // color: const Color(0xff7c94b6),
        //   // color: Colors.grey,
        //   image: DecorationImage(
        //     // colorFilter: new ColorFilter.mode(Colors.red, BlendMode.dstATop),
        //       colorFilter: new ColorFilter.mode(Colors.grey.withOpacity(0.3), BlendMode.lighten),
        //       image: NetworkImage(
        //           // "https://miro.medium.com/max/1068/1*b2cuG4QxzilzCduG31Rlzw.png",
        //           "http://loteriasdo.gq/assets/img/login.jpg",
        //         ),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
          child: Column(
            children: [
              Stack(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: IconButton(icon: Icon(Icons.clear, color: Colors.grey, size: 25,), onPressed: (){}),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, right: 15.0),
                      child: MyButton(
                        xlarge: 9,
                        type: MyButtonType.roundedWithOnlyBorder,
                        title: "Registrar",
                        padding: EdgeInsets.all(15),
                        function: (){},
                      ),
                    ),
                  )
                ],
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child: MyResizedContainer(
                    medium: 1.5,
                    large: 2,
                    xlarge: 3.5,
                    child: Container(
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.all(Radius.circular(20))
                      // ),
                      child: Wrap(
                        children: [
                          // Align(
                          //   child: ,
                          // )
                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(top: 8.0, right: 20),
                          //     child: Container(
                          //       width: 60,
                          //       height: 60,
                          //       child:  ClipRRect(
                          //         borderRadius: BorderRadius.circular(20),
                          //         child: Container(
                          //           child: Align(
                          //             alignment: Alignment.topLeft,
                          //             widthFactor: 0.75,
                          //             heightFactor: 0.75,
                          //             child: Image(image: AssetImage('images/creditcard.png'), ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MySubtitle(title: "Acceder", fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 0,),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyTextFormField(
                              type: MyType.rounded,
                              isRequired: true,
                              controller: _txtUsuarioController,
                              hint: "Usuario",
                              title: "Usuario",
                              medium: 1,
                              large: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyTextFormField(
                              type: MyType.rounded,
                              isRequired: true,
                              hint: "Password",
                              isPassword: true,
                              controller: _txtPasswordController,
                              title: "Password",
                              medium: 1,
                              large: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                            child: MyCheckBox(
                              // isSideTitle: true,
                              title: "Mantener sesion",
                              helperText: "Desea mantener su sesion abierta?",
                              // titleSideCheckBox: "Desea mantener su sesion abierta?",
                              value: _recordarme,
                              onChanged: _recordarmeChanged,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyButton(
                            // cargandoNotify: _cargandoNotify,
                            cargando: _cargando,
                            type: MyButtonType.rounded,
                            medium: 1,
                            padding: EdgeInsets.all(15),
                            function: _acceder, 
                            title: "Acceder",
                            color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text("O", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey)),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                Text("Desea registrarse o ha olvidado la contrasena?", style: TextStyle(fontFamily: "GoogleSans")),
                                Text("Comuniquese con el administrador para reestablecerla.", style: TextStyle(fontFamily: "GoogleSans", fontWeight: FontWeight.w700)),
                                _contactoWidget(false)
                              ],
                            ),
                          ),
                          Center(child: Text("Version prueba 2.1.54", style: TextStyle(fontFamily: "GoogleSans", fontWeight: FontWeight.w700)),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
      );
      
  }
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _txtPasswordFocusNode = FocusNode();
    _futureAjuste = _getAjuste();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _txtPasswordFocusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
  ));

    bool isSmallOrMedium = Utils.isSmallOrMedium(MediaQuery.of(context).size.width);


    return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
          // For Android.
          // Use [light] for white status bar and [dark] for black status bar.
          statusBarIconBrightness: Brightness.light,
          // For iOS.
          // Use [dark] for white status bar and [light] for black status bar.
          statusBarBrightness: Brightness.light,
          // statusBarColor: Colors.transparent
          statusBarColor: Colors.transparent
        ),
        child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        // ),
        body: SafeArea(
          
          child: 
          !isSmallOrMedium
          ?
          _largeScreen()
          :
          Column(
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
                            onPressed: _acceder,
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
                      _contactoWidget(isSmallOrMedium)
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
      ),
    );
    

     
  }

 
}