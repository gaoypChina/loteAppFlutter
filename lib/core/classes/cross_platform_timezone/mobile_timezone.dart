import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'cross_platform_timezone.dart';

class MobileTimezone implements CrossTimezone{
  // @override
  // getMoorCrossConstructor() {
  //   // TODO: implement getMoorCrossConstructor
  //   return MobileDatabase('app', logStatements: true);
  // }
  @override
  getCurrentTimezone() async {
    return await FlutterNativeTimezone.getLocalTimezone();
  }

  @override
  String getPlatform() {
    // TODO: implement getPlatform
    return "Mobile";
  }

}

CrossTimezone getTimezone() => MobileTimezone();

