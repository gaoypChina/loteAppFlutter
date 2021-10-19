

import 'cross_platform_screensize.dart';

class WebTimezone implements CrossScreenSize{
  // @override
  // getMoorCrossConstructor() {
  //   // TODO: implement getMoorCrossConstructor
  //   return WebDatabase('app', logStatements: true);
  // }
  static final double _sm = 450;
  static final double _md = 750;
  static final double _lg = 1000;
  static final double _xlg = 1300;

  @override
  String getPlatform() {
    // TODO: implement getPlatform
    return "Mobile";
  }

  @override
  double getLgSize() {
    // TODO: implement getLgSize
    return _lg;
  }

  @override
  double getMdSize() {
    // TODO: implement getMdSize
    return _md;
  }

  @override
  double getSmSize() {
    // TODO: implement getSmSize
    return _sm;
  }

  @override
  double getXlgSize() {
    // TODO: implement getXlgSize
    return _xlg;
  }

}

CrossScreenSize getScreenSize() => WebTimezone();

