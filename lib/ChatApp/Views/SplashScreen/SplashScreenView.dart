import 'package:chat_me/ChatApp/Views/WelcomeScreen/WelcomeScreenView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  bool shouldFade = false;

  @override
  void initState() {
    super.initState();
    animation();
    navigation();
  }

  navigation(){
    Future.delayed(const Duration(seconds: 4), () {
      Get.to(WelcomeScreenView());
    });
  }

  animation() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        shouldFade = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: AnimatedOpacity(
                opacity: shouldFade ? 1 : 0,
                duration: const Duration(seconds: 1),
          child: Image(
              height: Get.height / 1.5,
              width: Get.width / 1.5,
              image: const AssetImage(
                'Assets/logo.png',
              ),),
              ),
            ),
            Center(
              child: AnimatedOpacity(
                opacity: shouldFade ? 1 : 0,
                duration: const Duration(seconds: 1),
                child: const Text(
                  "Chat With Me",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            Center(
              child: AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: shouldFade ? 1 : 0,
                child: SpinKitThreeBounce(
                  color: Colors.black,
                  size: Get.height / 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
