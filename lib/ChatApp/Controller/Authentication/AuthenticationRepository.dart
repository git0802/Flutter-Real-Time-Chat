import 'dart:developer';
import 'package:chat_me/ChatApp/Controller/Authentication/exceptions/SignUpWithEmailAndPasswordFailure.dart';
import 'package:chat_me/ChatApp/Views/Authentication/LoginPage/LoginPageView.dart';
import 'package:chat_me/ChatApp/Views/ChatMainScreen/ChatMainScreenView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository extends GetxController {
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId1 = ''.obs;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    Firebase.initializeApp();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, (callback) => _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.off(LoginPageView())
        : Get.off(ChatMainScreenView());
  }

  Future<void> phoneAuthnetication(String phoneNo) async {
    log(phoneNo);

    try {
        await _auth.verifyPhoneNumber(
            phoneNumber: phoneNo,
            verificationCompleted: (credential) async {
              await _auth.signInWithCredential(credential);
            },
            timeout: Duration(seconds: 20),
            verificationFailed: (FirebaseAuthException e) {
              log(e.message.toString());
              if (e.code == 'Invalid-Phone-Number') {
                Get.snackbar("Error", "The Provided phone number is not valid",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.withOpacity(0.1),
                    colorText: Colors.green);
              } else {
                Get.snackbar("Error", "Something is Wrong...! Please Try again",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.withOpacity(0.1),
                    colorText: Colors.green);
              }
            },
            codeSent: (verificationId, resendToken) async {
              this.verificationId1.value = verificationId;
            },
            codeAutoRetrievalTimeout: (verificationId) {
              this.verificationId1.value = verificationId;
            });

    } catch (e) {
      throw e;
    }
  }

  Future<bool> verifyOTP1(String otp) async {
    log(otp);
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: this.verificationId1.value, smsCode: otp));
    return credentials.user != null ? true : false;
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
      await _auth.createUserWithEmailAndPassword(
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
      await _auth.signInWithEmailAndPassword(email: email, password: Password);
    } on FirebaseAuthException catch (e) {
    } catch (e) {}
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
