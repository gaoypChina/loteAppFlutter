import 'package:flutter/material.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/services/loginservice.dart';
import 'package:loterias/ui/login/login.dart';
import 'package:loterias/ui/views/principal/principal.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class _SplashScreenState extends State<SplashScreen> {
  Color _colorPrimary = HexColor.fromHex("#38B6FF");

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
        var parsed = await LoginService.acceder(await c.getValue("usuario"), await c.getValue("password"));
        await LoginService.guardarDatos(parsed);
        return true;
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