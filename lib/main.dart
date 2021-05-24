import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/cross_platform_sembas/cross_platform_sembas.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/cross_platform_timezone/cross_platform_timezone.dart';

// import 'package:loterias/core/classes/mynotification.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/router.dart';
import 'package:loterias/ui/widgets/mycolor.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;



import 'core/classes/databasesingleton.dart';

// void main() => runApp(Prueba2());

Future<void> main() async {
  // var path = Directory.current.path;
  tz.initializeTimeZones();
  // setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  // await MyNotification.init();
  
// final appDocumentDirectory = await getApplicationDocumentsDirectory();

// await getApplicationSupportDirectory();
// Timer.periodic(Duration(seconds: 1), (Timer t) async => await Realtime.sincronizar());
  await Db.openConnection();
  // //await DB.create();
  // var crossPlatform = CrossTimezone();
  //  var currentTimeZone = await crossPlatform.getCurrentTimezone();

  
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
          applyElevationOverlayColor: true,
          fontFamily: 'GoogleSans',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0),
            bodyText2: TextStyle(fontSize: 14.0),
          ),
          // backgroundColor: Colors.white,
          primarySwatch: MyColors.lightBlue,
          accentColor: Colors.pink,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor)
          ),
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
