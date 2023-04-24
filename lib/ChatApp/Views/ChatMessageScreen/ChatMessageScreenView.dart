import 'dart:developer';
import 'dart:io';
import 'package:chat_me/ChatApp/Models/ChatMessageModel.dart';
import 'package:chat_me/ChatApp/Utils/my_date_util.dart';
import 'package:chat_me/ChatApp/Views/ChatMessageScreen/components/MessageCard.dart';
import 'package:chat_me/ChatApp/Views/ViewProfileScreen/ViewProfileScreen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../Controller/DataApi/DataApiCloudStore.dart';
import '../../Models/ChatUserData.dart';

class ChatMessageScreenView extends StatefulWidget {
  final ChatUser user;
  const ChatMessageScreenView({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatMessageScreenView> createState() => _ChatMessageScreenViewState();
}

class _ChatMessageScreenViewState extends State<ChatMessageScreenView> {
  List<ChatMessageModel> messageList = [];
  TextEditingController messageSend = TextEditingController();
  bool showEmoji = false;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (showEmoji) {
            setState(() {
              showEmoji = !showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Color.fromARGB(255, 234, 248, 255),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: DataApiCloudStore.getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.active:
                          case ConnectionState.none:
                          /* return const Center(
                              child: CircularProgressIndicator(),
                            );*/
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;

                            messageList = data
                                    ?.map((e) =>
                                        ChatMessageModel.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (messageList.isNotEmpty) {
                              return ListView.builder(
                                reverse: true,
                                physics: BouncingScrollPhysics(),
                                padding:
                                    EdgeInsets.only(top: Get.height * 0.01),
                                itemCount: messageList.length,
                                itemBuilder: (context, index) {
                                  //messageList = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

                                  return MessageCard(
                                    messageModel: messageList[index],
                                    user: widget.user,
                                  );
                                },
                              );
                            } else {
                              return Center(
                                  child: Text(
                                "Say Hii! 👋",
                                style: TextStyle(fontSize: 20),
                              ));
                            }
                        }
                      }),
                ),
                if (isUploading)
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )),
                ChatInput(),
                if (showEmoji)
                  SizedBox(
                    height: Get.height * 0.35,
                    child: EmojiPicker(
                        textEditingController: messageSend,
                        config: Config(
                          bgColor: Color.fromARGB(255, 234, 248, 255),
                          columns: 8,
                          emojiSizeMax: 32 *
                              (Platform.isIOS == TargetPlatform.iOS
                                  ? 1.30
                                  : 1.0),
                        )),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewProfileScreen(
                        user: widget.user,
                      )));
          //  Get.to(() => ProfileScreenView(user: widget.user));
        },
        child: StreamBuilder(
          stream: DataApiCloudStore.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
            log(list[0].lastActive);
            return Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Get.height * .03),
                  child: Image(
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                          child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!.toInt()
                            : null,
                      ));
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      );
                    },
                    image: NetworkImage(
                      list.isNotEmpty ? list[0].image : widget.user.image,
                    ),
                    width: Get.height * .055,
                    height: Get.height * .055,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? 'Online'
                              : myDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive)
                          : myDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive),
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                )
              ],
            );
          },
        ));
  }

  Widget ChatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Get.height * 0.01, horizontal: Get.width * 0.025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          showEmoji = !showEmoji;
                        });
                      },
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                        size: 25,
                      )),
                  Expanded(
                    child: TextField(
                      controller: messageSend,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (showEmoji) {
                          setState(() {
                            showEmoji = !showEmoji;
                          });
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Type Something...!",
                          hintStyle: TextStyle(color: Colors.blueAccent),
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final List<XFile>? images =
                            await picker.pickMultiImage(imageQuality: 70);
                        for (var i in images!) {
                          log("Image Path ${i.path}");
                          setState(() {
                            isUploading = true;
                          });
                          await DataApiCloudStore.sendChatImage(
                              widget.user, File(i.path));
                          setState(() {
                            isUploading = false;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                        size: 26,
                      )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          log("Image Path ${image.path}");
                          setState(() {
                            isUploading = true;
                          });
                          await DataApiCloudStore.sendChatImage(
                              widget.user, File(image.path));
                          setState(() {
                            isUploading = false;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.blueAccent,
                        size: 26,
                      )),
                  SizedBox(
                    width: Get.width * 0.02,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
              shape: CircleBorder(),
              minWidth: 0,
              padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
              color: Colors.green,
              onPressed: () {
                if (messageSend.text.isNotEmpty) {
                  if (messageList.isEmpty) {
                    DataApiCloudStore.sendFirstMessage(
                        widget.user,  messageSend.text, Type.text);
                  } else {
                    DataApiCloudStore.sendMessage(
                        widget.user, messageSend.text, Type.text);
                    messageSend.clear();
                  }
                }
              },
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 28,
              )),
        ],
      ),
    );
  }
}
