import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loterias/core/classes/database.dart';
import 'package:loterias/core/classes/singleton.dart';
import 'package:loterias/core/models/stocks.dart';
import 'package:loterias/core/services/realtime.dart';
import 'package:loterias/ui/router.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:timezone/data/latest.dart' as tz;



import 'locator.dart';

// void main() => runApp(Prueba2());

Future<void> main() async {
  // var path = Directory.current.path;
  tz.initializeTimeZones();
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
// final appDocumentDirectory = await getApplicationDocumentsDirectory();

// await getApplicationSupportDirectory();
// Timer.periodic(Duration(seconds: 1), (Timer t) async => await Realtime.sincronizar());
  await Db.create();
  await Db.open();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(builder: (_) => locator<CRUDModel>()),
        // ChangeNotifierProvider(builder: (_) => locator<UnidadCRUD>()),
        // ChangeNotifierProvider(builder: (_) => locator<CRUDArticulo>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        title: 'Product App',
        theme: ThemeData(),
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
