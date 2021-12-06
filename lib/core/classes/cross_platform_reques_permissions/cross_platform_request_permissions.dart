import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';



class CrossPlatformRequesPermission {
  MethodChannel platform = const MethodChannel('flutter.loterias');
  static final CrossPlatformRequesPermission _crossPlatformRequesPermission = CrossPlatformRequesPermission._internal();

  factory CrossPlatformRequesPermission() {
    return _crossPlatformRequesPermission;
  }

  CrossPlatformRequesPermission._internal();

  Future<bool> requestNecesaryPermissions() async{
    if(Platform.isWindows || kIsWeb || Platform.isMacOS){
      return false;
    }

    bool batteryLevel;
    try {
      final bool result = await platform.invokeMethod('requestPermissions');
      batteryLevel = result;
    } on PlatformException catch (e) {
      throw Exception("Failed to get battery level: '${e.message}'.");
    }

    print('requestPermission channel: $batteryLevel');
    return batteryLevel;
  }
}