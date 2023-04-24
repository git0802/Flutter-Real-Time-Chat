import 'dart:developer';
import 'package:chat_me/ChatApp/Views/ChatMainScreen/ChatCard.dart';
import 'package:chat_me/ChatApp/Views/ProfileScreen/ProfileScreenView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../Controller/DataApi/DataApiCloudStore.dart';
import '../../Models/ChatUserData.dart';
import '../../Utils/ColorConstant.dart';

class ChatMainScreenView extends StatefulWidget {
  const ChatMainScreenView({Key? key}) : super(key: key);

  @override
  State<ChatMainScreenView> createState() => _ChatMainScreenViewState();
}

class _ChatMainScreenViewState extends State<ChatMainScreenView> {
  List<ChatUser> userList = [];
  List<ChatUser> searchList = [];
  bool isSearch = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DataApiCloudStore.getSelfInfo();
    DataApiCloudStore.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      log(message!);

      if (DataApiCloudStore.auth.currentUser != null) {
        if (message.toString().contains('AppLifecycleState.inactive')) {
          DataApiCloudStore.updateActiveStatus(false);
        }
        if (message.toString().contains('AppLifecycleState.resumed')) {
          DataApiCloudStore.updateActiveStatus(true);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (isSearch) {
            setState(() {
              isSearch = !isSearch;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: isSearch
                ? TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Name,Phone Number",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 0.5),
                    ),
                    autofocus: true,
                    style: TextStyle(
                        fontSize: 16, color: Colors.white, letterSpacing: 0.5),
                    onChanged: (val) {
                      searchList.clear();
                      for (var i in userList) {
                        if (i.name.toLowerCase().contains(val) ||
                            i.phoneNo.toLowerCase().contains(val)) {
                          searchList.add(i);
                        }
                        setState(() {
                          searchList;
                        });
                      }
                    },
                  )
                : Text("Chats"),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      isSearch = !isSearch;
                    });
                  },
                  icon: Icon(
                    isSearch
                        ? CupertinoIcons.clear_circled_solid
                        : CupertinoIcons.search,
                    color: kContentColorDarkTheme,
                  )),
              IconButton(
                  onPressed: () {
                    Get.to(ProfileScreenView(user: DataApiCloudStore.me));
                  },
                  icon: Icon(
                    CupertinoIcons.person_crop_circle_fill,
                    color: kContentColorDarkTheme,
                  ))
            ],
          ),
          body: StreamBuilder(
            stream: DataApiCloudStore.getMyUserId(),

            //get id of only known users
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(
                    child: Text("No Any User Connect with You..."),
                  );

                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: DataApiCloudStore.getUserData(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                    //get only those user, who's ids are provided
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return Center(
                            child: Text("No Any User Connect with You..."),
                          );

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          userList = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (userList.isNotEmpty) {
                            return ListView.builder(
                                itemCount: isSearch
                                    ? searchList.length
                                    : userList.length,
                                padding: EdgeInsets.only(top: Get.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ChatCard(
                                      user: isSearch
                                          ? searchList[index]
                                          : userList[index]);
                                });
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                      'No Any User Connect with You... \n Please Tap on ',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500)),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                InkWell(
                                  onTap: () {
                                    addChatUser();
                                  },
                                  child: Center(
                                    child: CircleAvatar(
                                        radius: 25,
                                        child: Image.network(
                                          'https://fontawesomeicons.com/images/png/black/add_comment/outline-4x.png',
                                          height: 30,
                                          width: 30,
                                          color: Colors.white,
                                        ),
                                        backgroundColor: Color(0xFF00BF6D)),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Center(
                                  child: Text("Button to Add New Contact",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500)),
                                ),
                              ],
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              addChatUser();
            },
            backgroundColor: kPrimaryColor,
            child: Icon(
              Icons.add_comment_rounded,
              color: Colors.white,
            ),
          ),
          //bottomNavigationBar: buildBottomNavigationBar(),
        ),
      ),
    );
  }

  void addChatUser() {
    String phone = '';

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
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('   Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => phone = value,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.blue,
                    ),
                    hintText: "Ex:-+919988774455     ",
                    labelText: 'Enter User Mobile Number',
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
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (phone.isNotEmpty) {
                        await DataApiCloudStore.addChatUser(phone)
                            .then((value) {
                          if (!value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("User Does not exist..!!"),
                                backgroundColor: Colors.blue.withOpacity(.8),
                                behavior: SnackBarBehavior.floating));
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
