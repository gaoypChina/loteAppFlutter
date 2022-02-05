import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("Dentro didChangeDependendies splashScreen");
  }

  @override
  void initState(){
    super.initState();
    print("Dentro init splashscreen");
    
    // _mockCheckForSession().then((status){
    // print("Splash screen _mockCheckForSession route: ${ModalRoute.of(context).settings.name}");

    //   if(status){
    //     _navigateToHome();
    //   }else{
    //     _navigateToLogin();
    //   }
    // });
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
          // await Realtime.sincronizarTodosData(_scaffoldKey, parsed["realtime"]);
          await Realtime.sincronizarTodosDataBatch(_scaffoldKey, parsed["realtime"]);
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
        backgroundColor: kIsWeb ? null : _colorPrimary,
        body: SafeArea(
          child: 
          kIsWeb
          ?
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        height: Utils.isSmallOrMedium(MediaQuery.of(context).size.width) ? 30 : 35,
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
                  child:  Text("LoteriApp", style: TextStyle(fontSize: 22, color: Colors.black.withOpacity(.8), fontWeight: FontWeight.bold))
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 4.0),
                child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator()),
              )
              ],
            ),
          )
          :
          Column(
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
                      child: new CircularProgressIndicator(color: Colors.white,),
                    ),
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}