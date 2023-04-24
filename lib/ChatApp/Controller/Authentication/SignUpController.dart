import 'package:chat_me/ChatApp/Controller/Authentication/AuthenticationRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{

  static SignUpController get instance => Get.find();
  final AuthenticationRepository1 = Get.put(AuthenticationRepository());

  final userEmail = TextEditingController();
  final userName = TextEditingController();
  final userPassword = TextEditingController();
  final userMobile = TextEditingController();

  void registerUser(String email,String name,String mobile,String password){
    AuthenticationRepository1.createUserWithEmailAndPassword(email, password);
  }
}