import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

class CrossPlatformPackageInfo {
  static final CrossPlatformPackageInfo _crossPlatformPackageInfo = CrossPlatformPackageInfo._internal();

  factory CrossPlatformPackageInfo() {
    return _crossPlatformPackageInfo;
  }

  CrossPlatformPackageInfo._internal();

  Future<PackageInfo> fromPlatform() async{
    if(Platform.isWindows || kIsWeb){
      return PackageInfo(appName: "Loterias", version: "4.0.3", buildNumber: "53", packageName: "loterias");
    }

    return await PackageInfo.fromPlatform();
  }
}