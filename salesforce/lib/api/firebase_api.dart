import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMSG(RemoteMessage msg) async {
  print('Title :${msg.notification!.title}');
  print('Body :${msg.notification!.body}');
  print('Payload :${msg.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print("Token dfgsdgsdfg: $fCMToken");
    FirebaseMessaging.onBackgroundMessage(
        (message) => handleBackgroundMSG(message));
  }
}
