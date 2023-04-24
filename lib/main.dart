
import 'package:chat_me/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'ChatApp/ChatApp.dart';
Future<void> backgroundHandler(RemoteMessage message) async {
  //print(message.data.toString());
  //print(message.notification!.title);
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => Get.put(AuthenticationRepository()));

  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'Your channel description',
    id: 'chats_with_me',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chat Me',
  );
  print(result);

  if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
  } else {
/*    final fcmToken = await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('fcmToken', fcmToken!);
    log(fcmToken!);*/
  }
  runApp(const ChatApp());
}
