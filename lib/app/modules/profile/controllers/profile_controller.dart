import 'package:flash_chat/app/data/firebase/database_method.dart';
import 'package:flash_chat/app/data/getstoragedb/user_db.dart';
import 'package:flash_chat/app/data/hivedb/user_hive.dart';
import 'package:flash_chat/app/data/model/user.dart';
import 'package:flash_chat/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var user = UserDb().loadUserId();
  UserModel argumen = Get.arguments;

  UserModel? berteman;
  var bukanSaya = true;

  void add() {
    UserHive().adddata(argumen);
    berteman = UserHive().getdataKey(argumen.userid!);
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

  toChatroom() async {
    var lastMessageTs = DateTime.now();
    var chatRoomId = getChatRoomIdByUserName(myUsername, argumen.username!);
    Map<String, dynamic> chatRoomInfoMap = {
      myUsername + 'name': myName,
      argumen.username! + 'name': argumen.name,
      myUsername: myProfile,
      argumen.username!: argumen.profileUrl,
      'lastMessageSendByTs': lastMessageTs,
      'users': <String>[myUsername, argumen.username!]
    };
    DatabaseMethod().createChatRoom(chatRoomId, chatRoomInfoMap);
    Get.offAndToNamed(Routes.CHATROOM, arguments: argumen.username);
  }

  @override
  void onInit() {
    if (argumen.userid == user) {
      bukanSaya = false;
    }
    berteman = UserHive().getdataKey(argumen.userid!);
    // ignore: avoid_print
    print(berteman);
    getMyInfo();
    super.onInit();
  }
}
