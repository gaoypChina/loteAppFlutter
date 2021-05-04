import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/mynotification.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/stocks.dart';
import 'package:loterias/core/services/realtime.dart';
import 'package:loterias/ui/router.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:timezone/data/latest.dart' as tz;



import 'core/classes/databasesingleton.dart';
import 'locator.dart';

// void main() => runApp(Prueba2());

Future<void> main() async {
  // var path = Directory.current.path;
  tz.initializeTimeZones();
  // setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await MyNotification.init();
  
// final appDocumentDirectory = await getApplicationDocumentsDirectory();

// await getApplicationSupportDirectory();
// Timer.periodic(Duration(seconds: 1), (Timer t) async => await Realtime.sincronizar());
  await Db.openConnection();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  static Locale myLocale;
  
  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     // ChangeNotifierProvider(builder: (_) => locator<CRUDModel>()),
    //     // ChangeNotifierProvider(builder: (_) => locator<UnidadCRUD>()),
    //     // ChangeNotifierProvider(builder: (_) => locator<CRUDArticulo>()),
    //   ],
    //   child: 
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // backgroundColor: Colors.white,
          primarySwatch: Utils.colorMaterialCustom,
          accentColor: Colors.pink,
          // accentColor: Utils.fromHex("#F0807F")
        ),
        localeResolutionCallback: (deviceLocale, supportedLocales){
          myLocale = deviceLocale;
          print("myLanguaCode: ${myLocale.languageCode}");
        },
        initialRoute: '/',
        title: 'Product App',
        // theme: ThemeData(),
        onGenerateRoute: MyRouter.generateRoute,
      );
    // );
  }
}
