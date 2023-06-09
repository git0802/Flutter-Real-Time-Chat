import 'dart:developer';
import 'package:chat_me/ChatApp/Views/ChatMainScreen/Components/ChatCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import '../../Controller/Authentication/AuthenticationRepository.dart';
import '../../Controller/DataApi/DataApiCloudStore.dart';
import '../../Controller/DataApi/DeepLinkingController.dart';
import '../../Models/ChatUserData.dart';
import '../../Utils/ColorConstant.dart';
import '../ProfileScreenView/ProfileScreen/ProfileScreenView.dart';
import '../WelcomeScreen/WelcomeScreenView.dart';
import 'Components/addChatUser.dart';

class ChatMainScreenView extends StatefulWidget {
  const ChatMainScreenView({Key? key}) : super(key: key);

  @override
  State<ChatMainScreenView> createState() => _ChatMainScreenViewState();
}

class _ChatMainScreenViewState extends State<ChatMainScreenView> {
  List<ChatUser> userList = [];
  List<ChatUser> searchList = [];
  bool isSearch = false;
  final AuthenticationRepository1 = Get.put(AuthenticationRepository());
  final deepLinkingController = Get.put(DeepLinkingController());
  Set<int> selectedIndexes = {};
  Set<String> selectedPhone = {};

  bool isSelected = false;
  DateTime? _lastPressedAt;

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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    deepLinkingController.initDynamicLink1(context);
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
          } else if (selectedIndexes.isNotEmpty) {
            selectedIndexes.clear();
            setState(() {
              isSelected = false;
            });
            return Future.value(false);
          } else {
            final now = DateTime.now();
            if (_lastPressedAt == null ||
                now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
              _lastPressedAt = now;
              Get.rawSnackbar(
                messageText: const Text(
                  'Press back again to exit',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                icon: const Icon(CupertinoIcons.back),
                backgroundColor: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
              return Future.value(false);
            }
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: !isSelected
              ? AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  leading: isSearch
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              isSearch = !isSearch;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                          ))
                      : null,
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
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 0.5),
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
                    PopupMenuButton(
                      icon: Icon(Icons
                          .more_vert), //don't specify icon if you want 3 dot menu
                      color: Colors.white,
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.person_crop_circle_fill,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: Get.width * 0.01,
                              ),
                              Text(
                                "Account Setting",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: Get.width * 0.01,
                              ),
                              Text(
                                "Log out",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (item) => SelectedItem(context, item),
                    ),
                  ],
                )
              : AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  title: Text("Chats"),
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
                          DataApiCloudStore.deleteUser(selectedPhone.first);
                          print(selectedPhone.first);
                          selectedIndexes.clear();
                          setState(() {
                            isSelected = !isSelected;
                          });
                          selectedPhone = {};
                        },
                        icon: Icon(
                          CupertinoIcons.delete,
                          color: kContentColorDarkTheme,
                        )),
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
                            return ListView.separated(
                              padding: EdgeInsets.zero,

                              itemCount: isSearch
                                  ? searchList.length
                                  : userList.length,
                              // padding: EdgeInsets.only(top: Get.height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onLongPress: () {
                                   if(!isSearch){
                                     setState(() {
                                       if (selectedIndexes.contains(index)) {
                                         selectedIndexes.remove(index);
                                         selectedPhone
                                             .remove(userList[index].phoneNo);
                                       } else {
                                         selectedIndexes.add(index);
                                         selectedPhone
                                             .add(userList[index].phoneNo);
                                       }
                                       if (selectedIndexes.length != 1) {
                                         isSelected = false;
                                       } else {
                                         isSelected = true;
                                       }
                                     });
                                   }
                                  },
                                  onTap: () {
                                    if (selectedPhone.length >= 1) {
                                      setState(() {
                                        if (selectedIndexes.contains(index)) {
                                          selectedIndexes.remove(index);
                                          selectedPhone
                                              .remove(userList[index].phoneNo);
                                        } else {
                                          selectedIndexes.add(index);
                                          selectedPhone
                                              .add(userList[index].phoneNo);
                                        }
                                        if (selectedIndexes.length != 1) {
                                          isSelected = false;
                                        } else {
                                          isSelected = true;
                                        }
                                      });
                                    }
                                  },
                                  child: ChatCard(
                                      user: isSearch
                                          ? searchList[index]
                                          : userList[index],
                                      isSelected:
                                          selectedIndexes.contains(index)),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 0,
                                );
                              },
                            );
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
                                          .titleLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500)),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                addChatUser(),
                                SizedBox(
                                  height: 3,
                                ),
                                Center(
                                  child: Text("Button to Add New Contact",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
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
            onPressed: () {},
            backgroundColor: Colors.indigo,
            child: addChatUser(),
          ),
        ),
      ),
    );
  }

  void SelectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProfileScreenView(user: DataApiCloudStore.me)));

        break;
      case 1:
        DataApiCloudStore.updateActiveStatus(false);

        showDialog(
            context: context,
            builder: (_) => Center(
                  child: CircularProgressIndicator(),
                ));
        await DataApiCloudStore.fireStore
            .collection('users')
            .doc(DataApiCloudStore.user.uid)
            .update({
          'push_token': '',
        });
        DataApiCloudStore.auth.signOut().then((value) async {
          DataApiCloudStore.auth = FirebaseAuth.instance;
          await DefaultCacheManager().emptyCache();
          Get.back();
          Get.off(WelcomeScreenView());
        });
        break;
    }
  }
}
