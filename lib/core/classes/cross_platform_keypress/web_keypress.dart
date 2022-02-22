import 'dart:html';

import 'package:loterias/core/classes/cross_platform_keypress/cross_platform_keypress.dart';
import 'package:loterias/core/classes/cross_platform_keypress/mykeyboardevent.dart';

class WebKeypress implements CrossKeyPress{
  @override
  void listen(Function(MyKeyboardEvent e) function) {
    window.onKeyPress.listen((KeyboardEvent e) {
      // print("PrincipalView initState Web: " + e.charCode.toString() + " " + new String.fromCharCode(e.charCode));
      function(MyKeyboardEvent(keyCode: new String.fromCharCode(e.charCode)));
    });
    // TODO: implement listen
  }
 

}

CrossKeyPress getCrossKeyPress() => WebKeypress();