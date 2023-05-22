
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loterias/core/classes/databasesingleton.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/ajuste.dart';
import 'package:loterias/core/models/blocksplays.dart';
import 'package:loterias/core/services/loginservice.dart';
import 'package:loterias/core/services/realtime.dart';
import 'package:loterias/ui/contacto/contactoscreen.dart';
import 'package:loterias/ui/widgets/mybutton.dart';
import 'package:loterias/ui/widgets/myresizedcheckbox.dart';
import 'package:loterias/ui/widgets/myresizecontainer.dart';
import 'package:loterias/ui/widgets/mysubtitle.dart';
import 'package:loterias/ui/widgets/myswitch.dart';
import 'package:loterias/ui/widgets/mytextformfield.dart';

import '../../core/models/blocksplaysgenerals.dart';


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

// _showSnackBar(String content){
//       _scaffoldKey.currentState.showSnackBar(SnackBar(
//           content: Text(content),
//           action: SnackBarAction(label: 'CERRAR', onPressed: () => _scaffoldKey.currentState.hideCurrentSnackBar(),),
//         ));
//     }

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

  void _navigateToReporteGeneral(){
    Navigator.pushReplacementNamed(context, "/general", arguments: true);
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
    // probarBloqueo();
    // probarBloqueoPaleSuperpaleYTripletasDeUnSoloNumero();
    // probarBloqueoPaleSuperpaleYTripletasDeUnSoloNumeroPorBanca();
    // return;
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

        if(await Db.existePermiso("Ver reporte general"))
          Utils.navigateToReporteGeneral(true);
        else
          _navigateToHome();

      } catch(e){
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

  probarBloqueo() async {
    // await Db.insertOrDeleteBlocksplays([Blocksplays(1288, 1, 1, 1, ',00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36', 10, 5, null, null, null, 0, 1, 1, 1)], false);
    // await Db.insertOrDeleteBlocksplays([Blocksplays(1298, 1, 1, 1, '10', 10, 5, null, null, null, 0, 1, 1, 1)], false);
    
    String jugada = ",00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,";
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1288, 1, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1289, 2, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1290, 3, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1291, 4, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1292, 5, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1293, 6, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1294, 7, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1295, 8, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1296, 9, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1297, 10, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1298, 11, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1299, 12, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1300, 13, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1301, 14, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1302, 15, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1303, 16, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1304, 17, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1305, 18, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1306, 19, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1307, 20, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1308, 21, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1309, 22, 1, jugada, 10, 5, null, null, null, 0, 1, 1)], false);
    var data = await Db.obtenerMontoDeTablaBlocksplaysgenerals(idLoteria: 15, idSorteo: 1, jugada: ',06,', idMoneda: 1);
    print("LoginScreen probarBloqueo tamano: ${data.length}");
    print("LoginScreen probarBloqueo: $data");
  }

  probarBloqueoPaleSuperpaleYTripletasDeUnSoloNumero() async {
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1288, 1, 3, ",29,30,31,32,", 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1289, 1, 3, ",01,", 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1290, 1, 3, ",011229,", 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1291, 1, 3, ",12,", 10, 5, null, null, null, 0, 1, 1)], false);
    await Db.insertOrDeleteBlocksplaysgenerals([Blocksplaysgenerals(1292, 1, 2, ",12,", 2, 2, null, null, null, 0, 1, 1)], false);
    var data = await Db.obtenerMontoDeTablaBlocksplaysgenerals(idLoteria: 1, idSorteo: 3, jugada: '011229', idMoneda: 1);
    print("LoginScreen probarBloqueo tamano: ${data.length}");
    print("LoginScreen probarBloqueo: $data");
  }

  probarBloqueoPaleSuperpaleYTripletasDeUnSoloNumeroPorBanca() async {
    await Db.insertOrDeleteBlocksplays([Blocksplays(1288, 1, 1, 1, ",29,30,31,32,33,", 10, 5, null, null, null, 0, 1, 1, 1)], false);
    await Db.insertOrDeleteBlocksplays([Blocksplays(1289, 1, 1, 1, ",01,", 10, 5, null, null, null, 0, 1, 1, 1)], false);
    await Db.insertOrDeleteBlocksplays([Blocksplays(1290, 1, 1, 3, ",012932,", 10, 5, null, null, null, 0, 1, 1, 1)], false);
    await Db.insertOrDeleteBlocksplays([Blocksplays(1291, 1, 1, 1, ",12,", 10, 5, null, null, null, 0, 1, 1, 1)], false);
    await Db.insertOrDeleteBlocksplays([Blocksplays(1292,  1, 1, 1, ",12,", 2, 2, null, null, null, 0, 1, 1, 1)], false);
    await Db.insertOrDeleteBlocksplays([Blocksplays(1293,  1, 1, 2, ",1129,", 2, 2, null, null, null, 0, 1, 1, 1)], false);
    var data = await Db.obtenerMontoDeTablaBlocksplays(idBanca: 1, idLoteria: 1, idSorteo: 1, jugada: '12', idMoneda: 1);
    print("LoginScreen probarBloqueo tamano: ${data.length}");
    print("LoginScreen probarBloqueo: $data");
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
                    child: IconButton(icon: Icon(Icons.clear, color: Colors.grey, size: 25,), onPressed: (){probarBloqueo();}),
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
                            child: MyResizedCheckBox(
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
                          Center(child: Text("Version prueba 2.4.6", style: TextStyle(fontFamily: "GoogleSans", fontWeight: FontWeight.w700)),)
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
                                // MyResizedCheckBox(
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
                           child: TextButton(
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
                              Text('Acceder', style: TextStyle(color: Colors.black),),
                            style: TextButton.styleFrom(backgroundColor: _colorPrimary,),
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