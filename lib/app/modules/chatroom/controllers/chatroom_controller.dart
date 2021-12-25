import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/app/data/firebase/database_method.dart';
import 'package:flash_chat/app/data/getstoragedb/user_db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';

class ChatroomController extends GetxController {
  ScrollController scroll = ScrollController();

  // chatroom

  late String myName, myProfile, myUsername, myEmail, myId;

  String chatRoomId = '';
  String messageId = '';

  late String arg = Get.arguments;

  TextEditingController send = TextEditingController();
//
  getMyInfo() {
    myName = UserDb().loadDisplayName();
    myProfile = UserDb().loadPRofilePic();
    myUsername = UserDb().loadUserName();
    myEmail = UserDb().loadEmail();
    myId = UserDb().loadUserId();

    //

    chatRoomId = getChatRoomIdByUserName(myUsername, arg);
  }

//
  getChatRoomIdByUserName(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return b + '_' + a;
    } else {
      return a + '_' + b;
    }
  }

  addMassage(bool sendClicked) {
    if (send.text.isNotEmpty) {
      String message = send.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfo = {
        'message': message,
        'sendBy': myUsername,
        'ts': lastMessageTs,
        'imgUrl': myProfile
      };

      // messageId
      if (messageId == '') {
        messageId = randomAlphaNumeric(12);
      }

      DatabaseMethod()
          .addMasage(chatRoomId, messageId, messageInfo)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          'lastMessage': message,
          'lastMessageSendByTs': lastMessageTs,
          'lastMessageSendBy': myUsername
        };

        DatabaseMethod().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          send.text = '';
          messageId = '';
        }
      });
    }
  }

  // oper maps atau person
  var name = true.obs;

  nameOrMaps() {
    name.value = !name.value;
  }

  Stream<QuerySnapshot> getChatRoomMessage() async* {
    yield* FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chat')
        .orderBy('ts')
        .snapshots();
  }

  @override
  void onInit() {
    getMyInfo();
    super.onInit();
  }
}
