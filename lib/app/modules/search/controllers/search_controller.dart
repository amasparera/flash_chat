import 'package:flash_chat/app/data/firebase/database_method.dart';
import 'package:flash_chat/app/data/getstoragedb/user_db.dart';
import 'package:flash_chat/app/data/model/user.dart';
import 'package:flash_chat/app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  var seacrh = TextEditingController();

  var listdata = <UserModel>[].obs;
  late UserModel saya;

  void searchUser() async {
    if (seacrh.text != '') {
      listdata.value = await DatabaseMethod().searchUser(seacrh.text, saya);
    }
  }

// chatroom
  late String myName, myProfile, myUsername, myEmail, myId;

  String chatRoomId = '';
  String messageId = '';

//
  getMyInfo() {
    myName = UserDb().loadDisplayName();
    myProfile = UserDb().loadPRofilePic();
    myUsername = UserDb().loadUserName();
    myEmail = UserDb().loadEmail();
    myId = UserDb().loadUserId();
    saya = UserModel(
        email: myEmail,
        name: myName,
        profileUrl: myProfile,
        userid: myId,
        username: myUsername);
  }

//
  getChatRoomIdByUserName(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return b + '_' + a;
    } else {
      return a + '_' + b;
    }
  }

  toChatroom(UserModel user) async {
    var lastMessageTs = DateTime.now();
    var chatRoomId = getChatRoomIdByUserName(myUsername, user.username!);
    Map<String, dynamic> chatRoomInfoMap = {
      myUsername + 'name': myName,
      user.username! + 'name': user.name,
      myUsername: myProfile,
      user.username!: user.profileUrl,
      'lastMessageSendByTs': lastMessageTs,
      'users': <String>[myUsername, user.username!]
    };
    DatabaseMethod().createChatRoom(chatRoomId, chatRoomInfoMap);
    Get.offAndToNamed(Routes.CHATROOM, arguments: user.username);
  }

  // mencari nama

  @override
  void onInit() {
    getMyInfo();
    super.onInit();
  }
}
