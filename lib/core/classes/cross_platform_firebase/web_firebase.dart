

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loterias/core/classes/cross_platform_firebase/cross_platform_firebase.dart';


class WebFirebse implements CrossFirebase{
  @override
  Future initializeApp() async {
    // TODO: implement initializeApp
      await Firebase.initializeApp();
  }

  @override
  Future setForegroundNotificationPresentationOptions({bool alert, bool badge, bool sound}) async {
    // TODO: implement setForegroundNotificationPresentationOptions
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: alert, badge: badge, sound: sound);
  }

  @override
  Future subscribeToTopic() {
    // TODO: implement subscribeToTopic
    print("Web_firebase subscribeToTopic not supported on Windows");
    // throw UnimplementedError();
  }

  @override
  Future unSubscribeFromTopic() {
    // TODO: implement unSubscribeFromTopic
    print("Web_firebase unSubscribeFromTopic not supported on Windows");

    // throw UnimplementedError();
  }

}

CrossFirebase getFirebase() => WebFirebse();

