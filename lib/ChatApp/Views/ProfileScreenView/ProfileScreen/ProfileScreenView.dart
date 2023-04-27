import 'dart:developer';
import 'dart:io';

import 'package:chat_me/ChatApp/Controller/DataApi/DataApiCloudStore.dart';
import 'package:chat_me/ChatApp/Models/ChatUserData.dart';
import 'package:chat_me/ChatApp/Views/WelcomeScreen/WelcomeScreenView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Controller/Authentication/AuthenticationRepository.dart';
import '../../../Utils/TextStyleConstant.dart';


class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({Key? key, required this.user}) : super(key: key);
  final ChatUser user;

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  final AuthenticationRepository1 = Get.put(AuthenticationRepository());
  final formKey = GlobalKey<FormState>();
  String? customImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // backgroundColor: Colors.black,
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(
              CupertinoIcons.arrow_left,
              color: Colors.white,
            ),
          ),
          title: Text("Profile Screen"),
          actions: [],
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: Get.width,
                    height: Get.height * 0.03,
                  ),
                  Stack(
                    children: [
                      customImage != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(Get.height * .1),
                              child: Image.file(
                                File(customImage!),
                                width: Get.height * .2,
                                height: Get.height * .2,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(Get.height * .1),
                              child: Image.network(
                                widget.user.image,
                                width: Get.height * .2,
                                height: Get.height * .2,
                                fit: BoxFit.cover,
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            BottomSheet();
                          },
                          shape: CircleBorder(),
                          child: Icon(Icons.edit),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Text(
                    widget.user.phoneNo,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => DataApiCloudStore.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
                    decoration: InputDecoration(
                        hintText: "Enter your Name",
                        label: Text("Name"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.person)),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => DataApiCloudStore.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
                    decoration: InputDecoration(
                        hintText: "Eg.feeling Happy",
                        label: Text("About"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.info)),
                  ),
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        DataApiCloudStore.updateUseInfo().then((value) =>
                            Get.snackbar("Data Update Successfully....!!!", "",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green.withOpacity(0.1),
                                colorText: Colors.black));
                      } else {}
                    },
                    child: Container(
                        width: Get.width / 3,
                        height: Get.height / 18,
                        decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Text("Update",
                                style: TextStyleConstant.ButtonColor))),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.indigo,
            onPressed: () async {
              DataApiCloudStore.updateActiveStatus(false);

              showDialog(
                  context: context,
                  builder: (_) => Center(
                        child: CircularProgressIndicator(),
                      ));
              await AuthenticationRepository1.logout().then((value) {
                Get.back();
                Get.off(WelcomeScreenView());

                DataApiCloudStore.auth = FirebaseAuth.instance;
              });
            },
            label: Text(
              "Log out",
              style: TextStyle(color: Colors.white),
            ),
            icon: Icon(Icons.logout, color: Colors.white)),
      ),
    );
  }

  void BottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: Get.height * 0.03, bottom: Get.height * 0.05),
            children: [
              Text(
                "Pick Profile Picture",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          log("Image Path ${image.path}");
                          setState(() {
                            customImage = image.path;
                          });
                          DataApiCloudStore.updateProfilePicture(
                              File(customImage!));
                        }
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(Get.width * 0.3, Get.height * 0.20),
                          shape: CircleBorder()),
                      child: Image.asset('Assets/add_image.png')),
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          log("Image Path ${image.path}");
                          setState(() {
                            customImage = image.path;
                          });
                          DataApiCloudStore.updateProfilePicture(
                              File(customImage!));
                        }
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(Get.width * 0.3, Get.height * 0.20),
                          shape: CircleBorder()),
                      child: Image.asset('Assets/camera.png'))
                ],
              )
            ],
          );
        });
  }
}
