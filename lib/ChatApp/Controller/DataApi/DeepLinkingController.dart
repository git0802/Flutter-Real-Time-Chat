import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'DataApiCloudStore.dart';

class DeepLinkingController extends GetxController {
  static Future<String> createDynamicLink(bool short, String phoneNo) async {
    String linkMessage;
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://chatwithmejay.page.link" + "/${phoneNo}"),
      uriPrefix: "https://chatwithmejay.page.link",
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse(
            "https://drive.google.com/file/d/1CkmiMt_MZb0jKUgYmyraX05lNMsh-kce/view?usp=drive_link"),
        packageName: "com.example.chat_me",
        minimumVersion: 30,
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    linkMessage = dynamicLink.toString();
    return linkMessage;
  }

  Future<void> initDynamicLink1(BuildContext context) async {
    try {
      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
        final String deepLink = dynamicLinkData.link.toString();
        final String path = dynamicLinkData.link.path;

        if (deepLink.isNotEmpty) {
          handleDeepLink(path, context);
        }
      }).onError((error) {
        print(error.toString());
      });
    } catch (e) {
      log(e.toString());
    }
    initUniLinks(context);
  }

  Future<void> initUniLinks(BuildContext context) async {
    try {
      final initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
      if (initialLink == null) return;
      handleDeepLink(initialLink.link.path, context);
    } catch (e) {
      // Error
    }
  }

  void handleDeepLink(String path, BuildContext context) async {
    //  Get.offAll(ChatMainScreenView());
    await DataApiCloudStore.addChatUser(path.substring(4)).then((value) {
      if (!value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("User Does not exist..!!"),
            backgroundColor: Colors.blue.withOpacity(.8),
            behavior: SnackBarBehavior.floating));
      }
    });
  }
}
