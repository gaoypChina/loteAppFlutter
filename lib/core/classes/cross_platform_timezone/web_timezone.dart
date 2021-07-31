import 'cross_platform_timezone.dart';
import 'dart:js' as js;


class WebTimezone implements CrossTimezone{
  // @override
  // getMoorCrossConstructor() {
  //   // TODO: implement getMoorCrossConstructor
  //   return WebDatabase('app', logStatements: true);
  // }
  @override
  getCurrentTimezone() async {
    var dtf = js.context['Intl'].callMethod('DateTimeFormat');
    var ops = dtf.callMethod('resolvedOptions');
    print("Current timezone web: ${ops['timeZone']}");
    return ops['timeZone'];
  }

  @override
  String getPlatform() {
    // TODO: implement getPlatform
    return "Web";
  }

}

CrossTimezone getTimezone() => WebTimezone();

