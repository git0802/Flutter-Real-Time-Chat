import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_me/ChatApp/Models/ChatMessageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import '../../Models/ChatUserData.dart';
import '../../Utils/NotificationService/NotiicationService.dart';

class DataApiCloudStore {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static FirebaseMessaging FirebaseMessaging1 = FirebaseMessaging.instance;

  static User get user => auth.currentUser!;

  static String verificationId1 = '';

  static ChatUser me = ChatUser(
      image: '',
      about: '',
      name: '',
      createdAt: '',
      isOnline: false,
      id: '',
      lastActive: '',
      pushToken: '',
      phoneNo: '');

  //for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await fireStore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> phoneAuthnetication(String phoneNo) async {
    log(phoneNo);
    log('phoneAuthentication');
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNo,
          verificationCompleted: (credential) async {
            await auth.signInWithCredential(credential);
          },
          timeout: Duration(seconds: 10),
          verificationFailed: (FirebaseAuthException e) {
            log(e.message.toString());
            if (e.code == 'Invalid-Phone-Number') {
              Get.snackbar("Error", "The Provided phone number is not valid",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green.withOpacity(0.1),
                  colorText: Colors.green);
            } else {
              Get.snackbar("Error", "Something is Wrong...! Please Try again",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green.withOpacity(0.1),
                  colorText: Colors.green);
            }
          },
          codeSent: (verificationId, resendToken) async {
            verificationId1 = verificationId;
          },
          codeAutoRetrievalTimeout: (verificationId) {
            verificationId1 = verificationId;
          });
    } catch (e) {
      throw e;
    }
  }

  static Future<bool> verifyOTP1(String otp, BuildContext context) async {
    log(otp);
    try {
      var credentials = await auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId1, smsCode: otp));
      return credentials.user != null ? true : false;
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Oops, OTP is not matched.\nPlease Retry or ReEnter Your Number'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return false;
    }
  }

  //firebase fcm token
  static Future<void> getFirebaseMessagingToken() async {
    await FirebaseMessaging1.requestPermission();
    Stream<String> fcmStream = FirebaseMessaging1.onTokenRefresh;

    await FirebaseMessaging1.getToken().then((value) => {
          if (value != null) {me.pushToken = value, log(value)}
        });
/*    fcmStream.listen((event) {
      if (event != null) {me.pushToken = event ; log(event);}

    });*/
  }

  //send Notification API
  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": chatUser.name, //our name should be send
          "body": msg,
          "android_channel_id": "ChatWithMe",
        },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAIgJ2Soc:APA91bEYPYkyizkxBLEKT_T1GwZgGSg21Asm3OEtRsxB9YMyzgpmJFsz2UKCIhcybR891Aam5vvKxfxPDScpqMI4oEJ4QfugbmJn19jtIzRpUBrQeMusSbBtfRV_SBJFwZw7t93lr-fu'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  //for user create a new user
  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: user.uid,
      name: auth.currentUser!.displayName.toString(),
      image:
          'https://www.pinclipart.com/picdir/big/18-181421_png-transparent-download-person-svg-png-icon-person.png',
      about: "Hey, I'm using Chat me App",
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
      phoneNo: user.phoneNumber!,
    );
    return await fireStore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  //get all User Data from firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserData(
      List<String> userIds) {
    if (userIds.isNotEmpty) {
      return DataApiCloudStore.fireStore
          .collection('users')
          .where(
            'id',
            whereIn: userIds,
          )
          .snapshots();
    } else {
      return DataApiCloudStore.fireStore
          .collection('users')
          .where('id', isEqualTo: '123')
          .snapshots();
    }
  }

  //get all User Data from firebase
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUserId() {
    return DataApiCloudStore.fireStore
        .collection('users')
        .doc(user.uid)
        .collection('myUser')
        .snapshots();
  }

  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await fireStore
        .collection('users')
        .doc(chatUser.id)
        .collection('myUser')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  //get self Data from firebase
  static Future<void> getSelfInfo() async {
    user.reload();
    log(user.phoneNumber.toString());
    // me.clear();
    await fireStore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        getFirebaseMessagingToken();
        LocalNotificationService.initialize();
        log(me.phoneNo.toString());
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  //Starting Page GetSelfInfo()

  static ChatUser GetSelfInfo() {
    log(user.phoneNumber.toString());

    fireStore.collection('users').doc(user.uid).get().then((value) {
      log(value.data().toString());
      print(value.exists);
      if (value.exists) {
        me = ChatUser.fromJson(value.data()!);
        return me;
      } else {
        return me;
      }
    });
    return me;
  }

  //update Data
  static Future<void> updateUseInfo() async {
    await fireStore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }
  //update Profile Picture

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref =
        firebaseStorage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    me.image = await ref.getDownloadURL();
    await fireStore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    log(fireStore
        .collection('users')
        .where('id', isNotEqualTo: chatUser.id)
        .snapshots()
        .toString());
    return fireStore
        .collection('users')
        .where('id', isNotEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    return fireStore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> userStatusStream(
      String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }

  //delete message
  static Future<void> deleteMessage(
      ChatMessageModel chatMessageModel, ChatUser user) async {
    await fireStore
        .collection('chat/${getConversionId(user.id)}/messages/')
        .doc(chatMessageModel.send)
        .delete();

    if (chatMessageModel.type == Type.image) {
      await firebaseStorage.refFromURL(chatMessageModel.msg).delete();
    }
  }

  //update message
  static Future<void> updateMessage(ChatMessageModel chatMessageModel,
      String updatedMsg, ChatUser user) async {
    await fireStore
        .collection('chat/${getConversionId(user.id)}/messages/')
        .doc(chatMessageModel.send)
        .update({'msg': updatedMsg});
  }

  ///CHAT DATA
  ///
  static String getConversionId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return DataApiCloudStore.fireStore
        .collection('chat/${getConversionId(user.id)}/messages/')
        .orderBy('send', descending: true)
        .snapshots();
  }

  //for sending Message
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final ChatMessageModel chatMessageModel = ChatMessageModel(
        toId: user.uid,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        send: time);
    final ref =
        fireStore.collection('chat/${getConversionId(chatUser.id)}/messages/');
    await ref.doc(time).set(chatMessageModel.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'Image'));
  }
//update when user read message

  static Future<void> updateMessageReadStatus(
      ChatMessageModel chatMessageModel) async {
    try {
      fireStore
          .collection(
              'chat/${getConversionId(chatMessageModel.fromId)}/messages/')
          .doc(chatMessageModel.send)
          .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
    } catch (e) {
      print('Error updating read status: $e');
    }
  }

  //getLastMessage
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return DataApiCloudStore.fireStore
        .collection('chat/${getConversionId(user.id)}/messages/')
        .orderBy('send', descending: true)
        .limit(1)
        .snapshots();
  }

  //send Message as Image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = firebaseStorage.ref().child(
        'images/${getConversionId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  static Future<bool> addChatUser(String phoneNo) async {
    print('+91${phoneNo}');
    final userData = await fireStore
        .collection('users')
        .where('phoneNo', isEqualTo: '+91${phoneNo}')
        .get();

    if (userData.docs.isNotEmpty && userData.docs.first.id != user.uid) {
      fireStore
          .collection('users')
          .doc(user.uid)
          .collection('myUser')
          .doc(userData.docs.first.id)
          .set({});
      return true;
    } else {
      return false;
    }
  }

  //Clear Chat
  static Future<void> clearChat(ChatUser chatUser) async {
    CollectionReference messagesCollection = FirebaseFirestore.instance
        .collection('chat/${getConversionId(chatUser.id)}/messages/');

    QuerySnapshot querySnapshot = await messagesCollection.get();

    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await documentSnapshot.reference.delete();
    }
  }

  static Future<void> deleteUser(String phoneNo) async {
    final userData = await fireStore
        .collection('users')
        .where('phoneNo', isEqualTo: phoneNo)
        .get();

    if (userData.docs.isNotEmpty || userData != user.uid) {
      fireStore
          .collection('users')
          .doc(user.uid)
          .collection('myUser')
          .doc(userData.docs.first.id)
          .delete();
      print('delete');
    } else {}
  }
}
