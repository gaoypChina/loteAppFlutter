import 'cross_platform_keypress.dart';
import 'mykeyboardevent.dart';

class MobileKeypress implements CrossKeyPress{
  @override
  void listen(Function(MyKeyboardEvent e) function) {
    
    // TODO: implement listen
  }
 

}

CrossKeyPress getCrossKeyPress() => MobileKeypress();