import 'package:chat_me/ChatApp/Controller/DataApi/DataApiCloudStore.dart';
import 'package:chat_me/ChatApp/Utils/TextStyleConstant.dart';
import 'package:chat_me/ChatApp/Views/Authentication/OTPVerification/OTPVerificationView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/Authentication/MobileNoVerificationController.dart';
import '../../../Utils/ColorConstant.dart';

class MobileNoScreenView extends StatefulWidget {
  const MobileNoScreenView({Key? key}) : super(key: key);

  @override
  State<MobileNoScreenView> createState() => _MobileNoScreenViewState();
}

class _MobileNoScreenViewState extends State<MobileNoScreenView> {
  final mobileNoVerificationController =
      Get.put(MobileNoVerificationController());
  final formKey1 = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 15,
              ),
              Center(
                child: Image(
                  image: AssetImage(
                    'Assets/photo1.png',
                  ),
                  height: Get.height * 0.30,
                  width: Get.width,
                ),
              ),
              SizedBox(
                height: Get.height / 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Enter Mobile Number and login",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontWeight: FontWeight.bold))),
              ),
              SizedBox(
                height: Get.height / 40,
              ),
              GetBuilder<MobileNoVerificationController>(
                  builder: (mobileNoVerificationController) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: formKey1,
                    child: Card(
                      elevation: 2,
                      child: TextFormField(
                        onChanged: (value) {
                          mobileNoVerificationController.phoneString = value;
                          mobileNoVerificationController
                              .phoneNumberEmptyFunction();
                        },
                        controller: mobileNoVerificationController.phoneNumber,
                        style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color
                                    ?.withOpacity(0.64))
                            .copyWith(fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixIcon: mobileNoVerificationController
                                  .phoneNumberEmptyFunction()
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          mobileNoVerificationController
                                              .phoneNumber
                                              .clear();
                                        });
                                      },
                                      icon: Icon(
                                          CupertinoIcons.clear_thick_circled,
                                          color: MediaQuery.of(context)
                                                      .platformBrightness ==
                                                  Brightness.light
                                              ? Colors.indigo
                                              : Colors.white),
                                    ),
                                  ],
                                )
                              : Container(
                                  width: Get.width / 100,
                                ),
                          prefixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '+91',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color
                                            ?.withOpacity(0.64))
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          hintText: 'mobile number',
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                          fillColor: const Color(0xffF5F5F5),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xffCCCCCC)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Colors.transparent),
                            //color: Color(0xffF38E30)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length != 10) {
                            return 'Please enter a valid 10 digit phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(
                height: Get.height / 20,
              ),
              GestureDetector(
                onTap: () async {

                  if (formKey1.currentState!.validate()) {
                    formKey1.currentState!.save();
                    await DataApiCloudStore.phoneAuthnetication(
                        '+91${mobileNoVerificationController.phoneNumber.text.trim()}');
                    Get.to(OTPVerificationView());
                    // mobileNoVerificationController.phoneVerification();
                  }


                },
                child: Container(
                    width: Get.width / 1.2,
                    height: Get.height / 18,
                    decoration: BoxDecoration(
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? Colors.indigo
                            : kSecondaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: Text("NEXT",
                            style: TextStyleConstant.ButtonColor))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
