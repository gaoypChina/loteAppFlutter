import 'dart:io';

import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'cross_platform_timezone.dart';

class LocalTimezone implements CrossTimezone{
  // @override
  // getMoorCrossConstructor() {
  //   // TODO: implement getMoorCrossConstructor
  //   return MobileDatabase('app', logStatements: true);
  // }
  @override
  getCurrentTimezone() async {
    if(Platform.isWindows)
      return DateTime.now().timeZoneName;
    return await FlutterNativeTimezone.getLocalTimezone();
  }

  @override
  String getPlatform() {
    // TODO: implement getPlatform
    return "Mobile";
  }

}

CrossTimezone getTimezone() => LocalTimezone();

