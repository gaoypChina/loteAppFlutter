import 'dart:async';
// import 'dart:ffi';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:loterias/core/classes/cross_platform_firebase/cross_platform_firebase.dart';
import 'package:loterias/core/classes/cross_platform_sembas/cross_platform_sembas.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/classes/cross_platform_timezone/cross_platform_timezone.dart';

// import 'package:loterias/core/classes/mynotification.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/ui/router.dart';
import 'package:loterias/ui/widgets/mycolor.dart';
import 'package:loterias/ui/widgets/myscaffold.dart';
import 'package:loterias/ui/widgets/mysliver.dart';
import 'package:loterias/ui/widgets/mytabbar.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
// import 'package:sqlite3/open.dart';



import 'core/classes/databasesingleton.dart';
bool DRAWER_IS_OPEN = false;
bool PERMISSIONS_CHANGED = false;
bool SHOW_PAYMENT_APPBAR = false;

// void main() => runApp(Prueba2());
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

//Firebase
AndroidNotificationChannel channel;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("A message just showed up: ${message.messageId}");
}

Future<void> main() async {
  // var path = Directory.current.path;
  tz.initializeTimeZones();
  // setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  // await MyNotification.init();

  // if(Platform.isWindows)
  //   open.overrideFor(OperatingSystem.windows, _openOnWindows);

  //Firebase
  // await Firebase.initializeApp();
  await (CrossFirebase()).initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = AndroidNotificationChannel(
      "high_importance_channel", //id,
      "High importance notifications", //title
      description: "This channel is used for importance notifications", //description
      importance: Importance.high, //
      playSound: true,
      enableLights: true,
      enableVibration: true
    );
  }
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.createNotificationChannel(channel);
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  await (CrossFirebase()).setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  
// final appDocumentDirectory = await getApplicationDocumentsDirectory();

// await getApplicationSupportDirectory();
// Timer.periodic(Duration(seconds: 1), (Timer t) async => await Realtime.sincronizar());
  await Db.openConnection();
  DRAWER_IS_OPEN = await Utils.menuIsOpen();
  // //await DB.create();
  // var crossPlatform = CrossTimezone();
  //  var currentTimeZone = await crossPlatform.getCurrentTimezone();


  print("Main holaaaa: ${Intl.defaultLocale }");
  
  runApp(MyApp());

}

// DynamicLibrary _openOnWindows() {
//    return DynamicLibrary.open('assets\\windows\\sqlite3.dll');
// }

// DynamicLibrary _openOnLinux() {
//   final scriptDir = File(Platform.script.toFilePath()).parent;
//   final libraryNextToScript = File('${scriptDir.path}/sqlite3.so');
//   return DynamicLibrary.open(libraryNextToScript.path);
// }

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
            // headline1: TextStyle(fontSize: !kIsWeb ? 30 : 72.0, fontWeight: FontWeight.bold),
            // headline6: TextStyle(fontSize: !kIsWeb ? 22 : 36.0),
            headline1: TextStyle(fontSize: !kIsWeb ? 25 : 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: !kIsWeb ? 19 : 36.0),
            bodyText2: TextStyle(fontSize: 14.0),
          ),
          // backgroundColor: Colors.white,
          // primarySwatch: MyColors.lightBlue,
          // primaryColor: Utils.colorMaterialCustom,
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


