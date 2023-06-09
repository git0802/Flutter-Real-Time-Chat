import 'dart:developer';
import 'dart:io';
import 'package:chat_me/ChatApp/Models/ChatUserData.dart';
import 'package:chat_me/ChatApp/Views/ChatMainScreen/ChatMainScreenView.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../Controller/DataApi/DataApiCloudStore.dart';
import '../../Utils/NotificationService/NotiicationService.dart';
import '../../Utils/TextStyleConstant.dart';

class NamePhotoAddScreen extends StatefulWidget {
  const NamePhotoAddScreen({Key? key /*,required this.user*/})
      : super(key: key);
/*
final ChatUser user;
*/
  @override
  State<NamePhotoAddScreen> createState() => _NamePhotoAddScreenState();
}

class _NamePhotoAddScreenState extends State<NamePhotoAddScreen> {
  final formKey = GlobalKey<FormState>();
  String? customImage;
  TextEditingController name = TextEditingController();

  /* setData(){
    setState(() {
      DataApiCloudStore.me;
      name.text = widget.user.name;
      log(name.text);
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {}
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        if (message.notification != null) {}
      },
    );

    // 2. This method only call when App in foreground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        // print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    //setData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Enter Your Details"),
          actions: [],
        ),
        body: StreamBuilder(
            stream: DataApiCloudStore.getUserInfo(DataApiCloudStore.me),
            builder: (context, snapshot) {
              return Form(
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
                                      DataApiCloudStore.me.image,
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
                          DataApiCloudStore.me.phoneNo,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        TextFormField(
                          initialValue: DataApiCloudStore.me.name,
                          onSaved: (val) =>
                              DataApiCloudStore.me.name = val ?? '',
                          validator: (val) =>
                              val != null && val.isNotEmpty && val != 'null'
                                  ? null
                                  : "Required Field",
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
                          initialValue: DataApiCloudStore.me.about,
                          onSaved: (val) =>
                              DataApiCloudStore.me.about = val ?? '',
                          validator: (val) => val != null && val.isNotEmpty
                              ? null
                              : "Required Field",
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
                                  Get.snackbar(
                                      "Data Update Successfully....!!!", "",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor:
                                          Colors.green.withOpacity(0.1),
                                      colorText: Colors.black));
                              Get.offAll(ChatMainScreenView());
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
              );
            }),
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
