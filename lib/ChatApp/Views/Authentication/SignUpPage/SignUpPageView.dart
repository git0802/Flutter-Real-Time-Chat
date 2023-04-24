import 'package:chat_me/ChatApp/Views/Authentication/LoginPage/LoginPageView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/Authentication/SignUpController.dart';
import '../../../Utils/RouteName.dart';
import '../../../Utils/TextStyleConstant.dart';
import 'SignUpPageTextFiledButton.dart';

class SignUpPageView extends StatefulWidget {
  const SignUpPageView({Key? key}) : super(key: key);

  @override
  State<SignUpPageView> createState() => _SignUpPageViewState();
}

class _SignUpPageViewState extends State<SignUpPageView> {
  final signupController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(
                    'Assets/photo1.png',
                  ),
                  height: Get.height * 0.30,
                  width: Get.width,
                ),
                SizedBox(
                  height: Get.height / 50,
                ),
                Text(
                  "Welcome to ChatMe App",
                  style: TextStyleConstant.fontStyle1,
                ),
                SizedBox(
                  height: Get.height / 50,
                ),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SignUpPageTextFiledButton(
                          userController: signupController.userName,
                          iconPic: CupertinoIcons.person_alt_circle_fill,
                          hintText: 'Enter Your Name',
                        ),
                        SignUpPageTextFiledButton(
                          userController: signupController.userEmail,
                          iconPic: CupertinoIcons.person_alt,
                          hintText: 'Enter Your Email',
                        ),
                        SignUpPageTextFiledButton(
                          userController: signupController.userMobile,
                          iconPic: CupertinoIcons.phone,
                          hintText: 'Enter Your Mobile No',
                        ),
                        SignUpPageTextFiledButton(
                          userController: signupController.userPassword,
                          iconPic: CupertinoIcons.lock_circle,
                          hintText: 'Enter Your Password',
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        signupController.registerUser(
                            signupController.userEmail.text,
                            signupController.userName.text,
                            signupController.userMobile.text,
                            signupController.userPassword.text);
                      }
                    },
                    child: Container(
                      width: Get.width / 4,
                      height: Get.height / 18,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                          child: Text(
                        "Sign UP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You have an account? "),
                    InkWell(
                      onTap: () {
                        Get.to(LoginPageView());
                      },
                      child: const Text("LogIn",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.pink)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                RichText(
                    text: const TextSpan(children: [
                  TextSpan(text: ("We will send you an ")),
                  TextSpan(
                      text: ("One Time Password "),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ("On this Email Id."))
                ])),
                Text(
                  "Also SignUp With",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: Get.height / 50,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(
                      flex: 5,
                    ),
                    InkWell(
                        onTap: () {},
                        child: SignUpWithIcon(
                          name: 'Assets/google.png',
                        )),
                    Spacer(
                      flex: 2,
                    ),
                    InkWell(
                        onTap: () {},
                        child: SignUpWithIcon(
                          name: 'Assets/facebook.png',
                        )),
                    Spacer(
                      flex: 2,
                    ),
                    InkWell(
                        onTap: () {},
                        child: SignUpWithIcon(
                          name: 'Assets/yahoo.png',
                        )),
                    Spacer(
                      flex: 5,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
