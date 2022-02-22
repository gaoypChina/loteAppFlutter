
// import 'cross_platform_db_stub.dart'
    import 'package:loterias/core/classes/cross_platform_keypress/cross_platform_keypress_stub.dart'

if (dart.library.io) 'mobile_keypress.dart'
    if (dart.library.js) 'web_keypress.dart';
import 'package:loterias/core/classes/cross_platform_keypress/mykeyboardevent.dart';

abstract class CrossKeyPress {
  // QueryExecutor getMoorCrossConstructor();
  void listen(Function(MyKeyboardEvent e) function);
  factory CrossKeyPress() => getCrossKeyPress();
}