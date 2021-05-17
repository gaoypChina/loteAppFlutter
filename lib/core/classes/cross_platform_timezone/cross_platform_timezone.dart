
// import 'cross_platform_db_stub.dart'
    import 'package:loterias/core/classes/cross_platform_timezone/cross_platform_timezone_stub.dart'

if (dart.library.io) 'mobile_timezone.dart'
    if (dart.library.js) 'web_timezone.dart';

abstract class CrossTimezone {
  // QueryExecutor getMoorCrossConstructor();
  Future<String> getCurrentTimezone();
  factory CrossTimezone() => getTimezone();
}