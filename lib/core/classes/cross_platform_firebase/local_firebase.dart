

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loterias/core/classes/cross_platform_firebase/cross_platform_firebase.dart';
import 'dart:io';

import '../databasesingleton.dart';
import '../singleton.dart';


class LocalFirebse implements CrossFirebase{
  @override
  Future initializeApp() async {
    // TODO: implement initializeApp
    if(!Platform.isWindows)
      await Firebase.initializeApp();
    
      print("Local_firebase initializeApp not supported on Windows");
  }

  @override
  Future setForegroundNotificationPresentationOptions({bool alert, bool badge, bool sound}) async {
    // TODO: implement setForegroundNotificationPresentationOptions
    if(!Platform.isWindows)
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: alert, badge: badge, sound: sound);

      print("Local_firebase setForegroundNotificationPresentationOptions not supported on Windows");

    // throw UnimplementedError();
  }

  @override
  Future subscribeToTopic() async {
    // TODO: implement subscribeToTopic
    if(Platform.isWindows)
      return;

    var tipoUsuario = (await (await DB.create()).getValue("tipoUsuario"));
    if(tipoUsuario == "Programador"){
      await FirebaseMessaging.instance.subscribeToTopic("programador");
    }
    else if(tipoUsuario == "Administrador"){
      await FirebaseMessaging.instance.subscribeToTopic(await Db.servidor());
    }
    // throw UnimplementedError();
  }

  @override
  Future<void> unSubscribeFromTopic() async {
    // TODO: implement unSubscribeFromTopic
    if(Platform.isWindows)
      return;

    var tipoUsuario = (await (await DB.create()).getValue("tipoUsuario"));
    if(tipoUsuario == "Programador"){
      await FirebaseMessaging.instance.unsubscribeFromTopic("programador");
    }
    else if(tipoUsuario == "Administrador"){
      await FirebaseMessaging.instance.unsubscribeFromTopic(await Db.servidor());
    }
    // throw UnimplementedError();
  }

}

CrossFirebase getFirebase() => LocalFirebse();

