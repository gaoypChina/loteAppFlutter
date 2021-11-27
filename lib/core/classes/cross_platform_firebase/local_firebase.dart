

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loterias/core/classes/cross_platform_firebase/cross_platform_firebase.dart';
import 'dart:io';


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

}

CrossFirebase getFirebase() => LocalFirebse();

