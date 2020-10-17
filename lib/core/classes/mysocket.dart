import 'package:flutter/services.dart';
import 'package:loterias/core/classes/utils.dart';
import 'package:loterias/core/models/notificacion.dart';
import 'package:rxdart/rxdart.dart';

class MySocket{
  static const platform = const MethodChannel('flutter.loterias');
  
  static connect(String room) async {
    try {
      final String result = await platform.invokeMethod('starService', {"room" : room, "url" : Utils.URL_SOCKET});
      print("mySocket connect correctly");
    } on PlatformException catch (e) {
      print("mySocket connect error: ${e.message}");
    }
  }
  static disconnect() async {
    try {
      final String result = await platform.invokeMethod('stopService');
      print("mySocket disconnect correctly");
    } on PlatformException catch (e) {
      print("mySocket disconnect error: ${e.message}");
    }
  }
}