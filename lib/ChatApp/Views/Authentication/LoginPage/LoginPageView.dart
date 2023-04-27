import 'package:chat_me/ChatApp/Views/Authentication/SignUpPage/SignUpPageView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Utils/TextStyleConstant.dart';
import 'LoginPageTextFiledButton.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {

  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  TextEditingController userMobile = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                    'Assets/photo2.png',
                  ),
                  height: Get.height * 0.40,
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
                    child: Column(
                      children: [
                        LoginPageTextFiledButton(
                          userController: userEmail,
                          iconPic: CupertinoIcons.person_alt,
                          hintText: 'Enter Your Email',
                        ),
                        LoginPageTextFiledButton(
                          userController: userMobile,
                          iconPic: CupertinoIcons.phone,
                          hintText: 'Enter Your Mobile No',
                        ),
                        LoginPageTextFiledButton(
                          userController: userPassword,
                          iconPic: CupertinoIcons.lock_circle,
                          hintText: 'Enter Your Password',
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 0, right: 20.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            /*  Navigator.of(context)
                                .pushNamed(Routes_Name.ResetPasswordEmail);*/
                          },
                          child: const Text(
                            "Reset Password",
                            style: TextStyle(color: Colors.indigo),
                          ))
                    ],
                  ),
                ),
                Container(
                  width: Get.width / 4,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                      child: Text(
                        "Login",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You have an account? "),
                    InkWell(
                      onTap: () {
                        Get.to(  SignUpPageView());

                      },
                      child: const Text("SignUp",
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
                  "Also Login With",
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
                        child: LoginWithIcon(
                          name: 'Assets/google.png',
                        )),
                    Spacer(
                      flex: 2,
                    ),
                    InkWell(
                        onTap: () {},
                        child: LoginWithIcon(
                          name: 'Assets/facebook.png',
                        )),
                    Spacer(
                      flex: 2,
                    ),
                    InkWell(
                        onTap: () {},
                        child: LoginWithIcon(
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
