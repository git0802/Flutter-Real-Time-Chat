import 'package:chat_me/ChatApp/Controller/DataApi/DataApiCloudStore.dart';
import 'package:chat_me/ChatApp/Views/ChatMainScreen/ChatMainScreenView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controller/Authentication/AuthenticationRepository.dart';
import 'Utils/themeData.dart';
import 'Views/SplashScreen/SplashScreenView.dart';


class ChatApp extends StatefulWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
     home: SplashScreenView(),
    );
  }
}
