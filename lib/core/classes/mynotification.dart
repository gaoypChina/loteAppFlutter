import 'dart:io';

import 'package:flutter/services.dart';
import 'package:loterias/core/models/notificacion.dart';
import 'package:rxdart/rxdart.dart';

class MyNotification{
  static const platform = const MethodChannel('flutter.loterias');
  
  static init() async {
    if(!Platform.isAndroid)
      return null;
    try {
      final String result = await platform.invokeMethod('initChannelNotification');
      print("Notification init correctly");
    } on PlatformException catch (e) {
      print("Notification init error: ${e.message}");
    }
  }

  static show({String title, String subtitle, String content, String route}) async {
    if(!Platform.isAndroid)
      return null;

    try {
      final String result = await platform.invokeMethod('showNotification', {"title" : title, "subtitle" : subtitle, "content" : content, "route" : route});
      print("Notification init correctly: $result");
    } on PlatformException catch (e) {
      print("Notification init error: ${e.message}");
    }
  }

  static Future<Notificacion> getIntentDataNotification() async {
    if(!Platform.isAndroid)
      return null;
    try {
      final result = await platform.invokeMethod('getIntentDataNotification');
      if(result != null){
        return Notificacion.fromMap(result);
      }
      return null;
    } on PlatformException catch (e) {
      print("FlutterNotification getIntentData error: ${e.message}");
      return null;
    }
  }

}