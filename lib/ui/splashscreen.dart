import 'package:flutter/material.dart';
import 'package:loterias/core/classes/principal.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/services/loginservice.dart';
import 'package:loterias/core/services/realtime.dart';
import 'package:loterias/ui/login/login.dart';
import 'package:loterias/ui/views/principal/principal.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {
  var _colorPrimary = Utils.fromHex("#38B6FF");
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();

    _mockCheckForSession().then((status){
      if(status){
        _navigateToHome();
      }else{
        _navigateToLogin();
      }
    });
  }

  Future<bool> _mockCheckForSession() async{
    // await Future.delayed(Duration(milliseconds: 2000), (){});
    var c = await DB.create();
    var value = await c.getValue("recordarme");
    if(value != null){
      if(value == true){
       try{
          var parsed = await LoginService.acceder(usuario: await c.getValue("usuario"), password: await c.getValue("password"));
          await c.add("apiKey", parsed["apiKey"]);
          await c.add("tipoUsuario", parsed["tipoUsuario"]);
          await LoginService.guardarDatos(parsed);
          await Realtime.sincronizarTodosData(_scaffoldKey, parsed["realtime"]);
          return true;
       } catch(e){
         Principal.cerrarSesion(context);
         return false;
       }
      }else{
        await Future.delayed(Duration(milliseconds: 2000), (){});
        return false;
      }
        
    }else{
      await Future.delayed(Duration(milliseconds: 2000), (){});
    }

    return false;
  }

  void _navigateToHome(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => PrincipalApp())
    );
  }
  void _navigateToLogin(){
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => LoginScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _colorPrimary,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Center(child: Image(image: AssetImage('assets/images/loterias_dominicanas.png'), width: MediaQuery.of(context).size.width / 1.5,))
              )
            ),
            // Expanded(flex: 4, child: Image(image: AssetImage('assets/images/oterias_dominicanas.png'),)),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: SizedBox(
                  width: 35,
                  height: 35,
                  child: Theme(
                    data: Theme.of(context).copyWith(accentColor: Colors.white),
                    child: new CircularProgressIndicator(),
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}