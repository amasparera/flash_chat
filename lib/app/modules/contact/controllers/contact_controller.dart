import 'package:flash_chat/app/data/firebase/database_method.dart';
import 'package:flash_chat/app/data/getstoragedb/user_db.dart';
import 'package:flash_chat/app/data/hivedb/user_hive.dart';
import 'package:flash_chat/app/data/model/user.dart';
import 'package:flash_chat/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ContactController extends GetxController {
  var data = Hive.box(UserHive.userHive);

  void delete(index) {
    UserHive().delete(index);
    update();
  }

  late String myName, myProfile, myUsername, myEmail, myId;

  String chatRoomId = '';
  String messageId = '';
  late UserModel saya;
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

  toChatroom(UserModel data) async {
    var lastMessageTs = DateTime.now();
    var chatRoomId = getChatRoomIdByUserName(myUsername, data.username!);
    Map<String, dynamic> chatRoomInfoMap = {
      myUsername + 'name': myName,
      data.username! + 'name': data.name,
      myUsername: myProfile,
      data.username!: data.profileUrl,
      'lastMessageSendByTs': lastMessageTs,
      'users': <String>[myUsername, data.username!]
    };
    DatabaseMethod().createChatRoom(chatRoomId, chatRoomInfoMap);
    Get.offAndToNamed(Routes.CHATROOM, arguments: data.username);
  }

  @override
  void onInit() {
    getMyInfo();
    super.onInit();
  }
}
