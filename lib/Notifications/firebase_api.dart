import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  //Message resultMessage = Message.fromFirebaseJson(message.data);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var firebaseToken = prefs.getString("firebaseToken");
    if (firebaseToken != null) {
      if (firebaseToken != fCMToken) {
        prefs.setString("firebaseToken", fCMToken!);
      }
    } else {
      prefs.setString("firebaseToken", fCMToken!);
    }

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
