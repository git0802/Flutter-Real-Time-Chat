import 'dart:developer';
import 'package:chat_me/ChatApp/Models/ChatMessageModel.dart';
import 'package:chat_me/ChatApp/Models/ChatUserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import '../../../Controller/DataApi/DataApiCloudStore.dart';
import '../../../Utils/my_date_util.dart';
import '../../ImageView/ImageView.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.messageModel, required this.user})
      : super(key: key);
  final ChatMessageModel messageModel;
  final ChatUser user;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  void initState() {
    super.initState();
    bool isNot = DataApiCloudStore.user.uid != widget.messageModel.fromId;
    if (isNot) if (widget.messageModel.send.isNotEmpty) {
      DataApiCloudStore.updateMessageReadStatus(widget.messageModel);
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bool isNot = DataApiCloudStore.user.uid != widget.messageModel.fromId;
    if (isNot) if (widget.messageModel.send.isNotEmpty) {
      DataApiCloudStore.updateMessageReadStatus(widget.messageModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = DataApiCloudStore.user.uid == widget.messageModel.fromId;
    return InkWell(
        onTap: () {
          if (isMe == false) if (widget.messageModel.send.isNotEmpty) {
            DataApiCloudStore.updateMessageReadStatus(widget.messageModel);
          }
        },
        onLongPress: () {
          showBottomSheet(isMe);
        },
        child: isMe ? greenMessage() : blueMessage());
  }

  Widget blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(Get.width * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 221, 242, 255),
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: widget.messageModel.type == Type.text
                ? Text(
                    widget.messageModel.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : InkWell(
              onTap: ()=> Get.to(() => ImageView(ImagePath: widget.messageModel.msg,)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(Get.height * .010),
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
                          widget.messageModel.msg,
                        ),
                        width: Get.height / 3,
                        height: Get.height / 2.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: Get.width * 0.04),
          child: Text(
            myDateUtil
                .getFormattedTime(
                    context: context, time: widget.messageModel.send)
                .toString(),
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: Get.width * 0.04,
            ),
            if (widget.messageModel.read.isNotEmpty)
              Icon(
                Icons.done_all_rounded,
                color: Colors.indigo,
                size: 20,
              ),
            SizedBox(
              width: Get.width * 0.01,
            ),
            Text(
              myDateUtil
                  .getFormattedTime(
                      context: context, time: widget.messageModel.send)
                  .toString(),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.messageModel.type == Type.text
                ? Get.width * 0.04
                : Get.width * 0.00),
            margin: EdgeInsets.symmetric(
                horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 255, 176),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )),
            child: widget.messageModel.type == Type.text
                ? Text(
                    widget.messageModel.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                : InkWell(
              onTap: ()=> Get.to(() => ImageView(ImagePath: widget.messageModel.msg,)),
              child: ClipRRect(
                      borderRadius: BorderRadius.circular(Get.height * .010),
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
                          widget.messageModel.msg,
                        ),
                        width: Get.height / 3,
                        height: Get.height / 2.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                ),
          ),
        ),
      ],
    );
  }

  void showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: Get.height * .015, horizontal: Get.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              widget.messageModel.type == Type.text
                  ?
                  //copy option
                  _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.messageModel.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);

                          // Dialogs.showSnackbar(context, 'Text Copied!');
                        });
                      })
                  :
                  //save option
                  _OptionItem(
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          log('Image Url: ${widget.messageModel.msg}');
                          await GallerySaver.saveImage(widget.messageModel.msg,
                                  albumName: 'We Chat')
                              .then((success) {
                            //for hiding bottom sheet
                            Navigator.pop(context);
                            if (success != null && success) {
                              // Dialogs.showSnackbar(
                              //     context, 'Image Successfully Saved!');
                            }
                          });
                        } catch (e) {
                          log('ErrorWhileSavingImg: $e');
                        }
                      }),

              //separator or divider
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: Get.width * .04,
                  indent: Get.width * .04,
                ),

              //edit option
              if (widget.messageModel.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Edit Message',
                    onTap: () {
                      //for hiding bottom sheet
                      Navigator.pop(context);

                      showMessageUpdateDialog();
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      await DataApiCloudStore.deleteMessage(
                              widget.messageModel, widget.user)
                          .then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.black54,
                endIndent: Get.width * .04,
                indent: Get.width * .04,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  name:
                      'Sent At: ${myDateUtil.getMessageTime(context: context, time: widget.messageModel.send)}',
                  onTap: () {}),

              //read time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.messageModel.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${myDateUtil.getMessageTime(context: context, time: widget.messageModel.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  void showMessageUpdateDialog() {
    String updatedMsg = widget.messageModel.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: const [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Update Message')
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                      DataApiCloudStore.updateMessage(
                          widget.messageModel, updatedMsg, widget.user);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}

//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: Get.width * .05,
              top: Get.height * .015,
              bottom: Get.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}
