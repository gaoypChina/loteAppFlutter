import 'package:flutter/services.dart';
import 'package:loterias/core/models/notificacion.dart';
import 'package:rxdart/rxdart.dart';

class MySocket{
  static const platform = const MethodChannel('flutter.loterias');
  
  static connect(String room) async {
    try {
      final String result = await platform.invokeMethod('mySocket', {"room" : room});
      print("mySocket connect correctly");
    } on PlatformException catch (e) {
      print("mySocket connect error: ${e.message}");
    }
  }
}