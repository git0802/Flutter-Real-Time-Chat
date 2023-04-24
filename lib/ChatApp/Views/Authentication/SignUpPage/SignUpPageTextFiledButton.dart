import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utils/ColorConstant.dart';


class SignUpPageTextFiledButton extends StatelessWidget {
  const SignUpPageTextFiledButton({Key? key,required this.userController,required this.iconPic,required this.hintText}) : super(key: key);
  final TextEditingController userController;
  final iconPic;
  final String hintText;


  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: Get.height / 18,
        width: Get.width / 1.05,
        child: TextField(
          controller: userController,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            prefixIcon: Icon(
             iconPic,
              color: ColorConstant.blackColor,
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey,),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorConstant.blackColor)
            ),
          ),
        ),
      ),
    );
  }
}


class SignUpWithIcon extends StatelessWidget {
  const SignUpWithIcon({Key? key,required this.name}) : super(key: key);

  final String name;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 23,
      backgroundColor:  ColorConstant.blackColor,
      child: Image(
        image: AssetImage(name),
        height: Get.height/20,
        width: Get.width/20,
      ),
    );
  }
}

