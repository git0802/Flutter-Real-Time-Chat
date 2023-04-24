import 'package:chat_me/ChatApp/Utils/my_date_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/ChatUserData.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({Key? key, required this.user}) : super(key: key);
  final ChatUser user;
  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          //app bar
          appBar: AppBar(title: Text(widget.user.name)),
          floatingActionButton: //user about
              Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Joined On: ',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              Text(
                  myDateUtil
                      .getLastMessageTime(
                        context: context,
                        time: widget.user.createdAt,
                      )
                      .toString(),
                  style: const TextStyle(color: Colors.black54, fontSize: 15)),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for adding some space
                  SizedBox(width: Get.width, height: Get.height * .03),

                  //user profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Get.height * .1),
                    child: Image.network(
                      widget.user.image,
                      width: Get.height * .2,
                      height: Get.height * .2,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // for adding some space
                  SizedBox(height: Get.height * .03),

                  // user email label
                  Text(widget.user.phoneNo,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 16)),

                  // for adding some space
                  SizedBox(height: Get.height * .02),

                  //user about
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'About: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                      Text(widget.user.about,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
