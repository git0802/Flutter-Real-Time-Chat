import 'package:chat_me/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'ChatApp/ChatApp.dart';

Future<void> backgroundHandler(RemoteMessage message) async {}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  analytics.logEvent(name: 'chat_app');
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'Your channel description',
    id: 'ChatWithMe',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chat Me',
  );

  if (DefaultFirebaseOptions.currentPlatform == DefaultFirebaseOptions.web) {
  } else {}
  runApp(const ChatApp());
}
