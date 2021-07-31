import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CrossDeviceInfo {
  static getUIID() async {
    //uuid is an unique number that help to identify each device
    var uuid;
    var deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (kIsWeb) {
        // uuid = (await deviceInfoPlugin.webBrowserInfo).;
        throw UnimplementedError("Web CrossDeviceInfo Uninplemented getUIID");
      } else {
        if (Platform.isAndroid) {
            uuid = (await deviceInfoPlugin.androidInfo).androidId;
        } else if (Platform.isIOS) {
          uuid = (await deviceInfoPlugin.iosInfo).identifierForVendor;
        } else if (Platform.isLinux) {
          uuid = (await deviceInfoPlugin.linuxInfo).machineId;
        } else if (Platform.isMacOS) {
          // deviceData = (await deviceInfoPlugin.macOsInfo).;
          throw UnimplementedError("MacOS CrossDeviceInfo Uninplemented getUIID");
        } else if (Platform.isWindows) {
          // deviceData =(await deviceInfoPlugin.windowsInfo).computerName;
          throw UnimplementedError("Windows CrossDeviceInfo Uninplemented getUIID");
        }
      }
    } on PlatformException {
      throw UnimplementedError("UnimplementedError CrossDeviceInfo in this device");
    }
    return uuid;
  }
}