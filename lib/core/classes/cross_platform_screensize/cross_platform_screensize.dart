
// import 'cross_platform_db_stub.dart'
    import 'package:loterias/core/classes/cross_platform_screensize/cross_platform_screensize_stub.dart'

if (dart.library.io) 'mobile_screensize.dart'
    if (dart.library.js) 'web_screensize.dart';

abstract class CrossScreenSize {
  // QueryExecutor getMoorCrossConstructor();
  double getSmSize();
  double getMdSize();
  double getLgSize();
  double getXlgSize();
  factory CrossScreenSize() => getScreenSize();
}