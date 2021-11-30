
// import 'cross_platform_db_stub.dart'

import 'cross_platform_firebase_stub.dart'
if (dart.library.io) 'local_firebase.dart'
    if (dart.library.js) 'web_firebase.dart';

// abstract class CrossFirebase {
//   // QueryExecutor getMoorCrossConstructor();
//   Future initializeApp();
//   factory CrossFirebase() = getFire;
// }

abstract class CrossFirebase{
  Future initializeApp();
  Future setForegroundNotificationPresentationOptions({bool alert, bool badge, bool sound});
  Future subscribeToTopic();
  Future unSubscribeFromTopic();
  factory CrossFirebase() => getFirebase();
}