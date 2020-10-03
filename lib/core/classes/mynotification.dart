import 'package:flutter/services.dart';

class MyNotification{
  static const platform = const MethodChannel('flutter.loterias');
  
  static init() async {
    try {
      final String result = await platform.invokeMethod('initChannelNotification');
      print("Notification init correctly");
    } on PlatformException catch (e) {
      print("Notification init error: ${e.message}");
    }
  }

  static show({String title, String content, String route}) async {
    try {
      final String result = await platform.invokeMethod('showNotification', {"title" : title, "content" : content, "route" : route});
      print("Notification init correctly");
    } on PlatformException catch (e) {
      print("Notification init error: ${e.message}");
    }
  }
}