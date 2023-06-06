import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/ChatUserData.dart';
import '../../ImageView/ImageView.dart';
import '../ViewProfileScreen/ViewProfileScreen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: Get.width * .6,
        height: Get.height * .35,
        child: Stack(
          children: [
            // User profile picture
            Positioned(
              top: Get.height * .075,
              left: Get.width * .1,
              child: GestureDetector(
                onTap: () => Get.to(() => ImageView(ImagePath: user.image)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Get.height * .1),
                  child: Image.network(
                    user.image,
                    width: Get.height * .2,
                    height: Get.height * .2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // User name
            Positioned(
              left: Get.width * .04,
              top: Get.height * .02,
              width: Get.width * .55,
              child: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Info button
            Positioned(
              right: 8,
              top: 6,
              child: MaterialButton(
                onPressed: () {
                  // For hiding image dialog
                  Navigator.pop(context);

                  // Move to view profile screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewProfileScreen(user: user),
                    ),
                  );
                },
                minWidth: 0,
                padding: const EdgeInsets.all(0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
