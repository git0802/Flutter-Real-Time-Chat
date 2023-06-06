import 'dart:developer';
import 'package:chat_me/ChatApp/Controller/Authentication/exceptions/SignUpWithEmailAndPasswordFailure.dart';
import 'package:chat_me/ChatApp/Views/Authentication/LoginPage/LoginPageView.dart';
import 'package:chat_me/ChatApp/Views/ChatMainScreen/ChatMainScreenView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/ChatUserData.dart';
import '../DataApi/DataApiCloudStore.dart';

class AuthenticationRepository extends GetxController {
  final auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId1 = ''.obs;


  static ChatUser me = ChatUser(
      image: '',
      about: '',
      name: '',
      createdAt: '',
      isOnline: false,
      id: '',
      lastActive: '',
      pushToken: '',
      phoneNo: '');

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    Firebase.initializeApp();
    verificationId1 = ''.obs;

  //  firebaseUser = Rx<User?>(_auth.currentUser);
  //  firebaseUser.bindStream(_auth.userChanges());
    //ever(firebaseUser, (callback) => _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.off(LoginPageView()) : Get.off(ChatMainScreenView());
  }

  verifyOtp(String otpNumber) async {
    Get.snackbar("Error", "OTP Verification Called",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green);
    PhoneAuthCredential userCredential = PhoneAuthProvider.credential(
        verificationId: verificationId1.value, smsCode: otpNumber);
    await FirebaseAuth.instance
        .signInWithCredential(userCredential)
        .then((value) async {
      final firebaseUser = value;
      if (firebaseUser.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("CUserID", firebaseUser.user!.uid);
      }
    }).catchError((e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green);
    });
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String Password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: Password);
      firebaseUser.value != null
          ? Get.off(LoginPageView())
          : Get.off(ChatMainScreenView());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('Firebase Auth Exception - ${ex.message}');
    } catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure();
      print('Firebase Auth Exception - ${ex.message}');
      throw ex;
    }
  }

  Future<void> loginUserWithEmailAndPassword(
      String email, String Password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: Password);

    } on FirebaseAuthException catch (e) {
    } catch (e) {}
  }

  Future<void> logout() async {
    await DataApiCloudStore.fireStore.collection('users').doc(DataApiCloudStore.user.uid).update({
      'push_token': '',
    });
    await FirebaseAuth.instance.signOut();


  }
}
