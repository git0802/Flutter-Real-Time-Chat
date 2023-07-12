import 'package:chat_me/ChatApp/Utils/TextStyleConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../Controller/Authentication/MobileNoVerificationController.dart';
import '../../../Controller/DataApi/DataApiCloudStore.dart';
import '../../../Utils/ColorConstant.dart';
import '../OTPVerification/OTPVerificationView.dart';

class MobileNoScreenView extends StatefulWidget {
  const MobileNoScreenView({Key? key}) : super(key: key);

  @override
  State<MobileNoScreenView> createState() => _MobileNoScreenViewState();
}

class _MobileNoScreenViewState extends State<MobileNoScreenView> {
  final mobileNoVerificationController =
      Get.put(MobileNoVerificationController());
  final formKey1 = GlobalKey<FormState>();
  String CountryCode = '+91';

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
                            .titleLarge
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
                        child: IntlPhoneField(
                          controller:
                              mobileNoVerificationController.phoneNumber,
                          decoration: InputDecoration(
                            focusColor: Colors.indigo,
                            hoverColor: Colors.indigo,
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          initialCountryCode: 'IN',
                          onCountryChanged: (CountryCode1) {
                            CountryCode = CountryCode1.dialCode;
                          },
                        )),
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
                  if(mobileNoVerificationController.phoneNumber.text != ''){
                    await DataApiCloudStore.phoneAuthnetication(
                        '+${CountryCode + mobileNoVerificationController.phoneNumber.text.trim()}');
                    Get.to(OTPVerificationView());
                  }
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
