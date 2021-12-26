import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/app/data/firebase/auth_user.dart';
import 'package:flash_chat/app/data/firebase/database_method.dart';
import 'package:flash_chat/app/data/getstoragedb/instalansi.dart';
import 'package:flash_chat/app/data/getstoragedb/user_db.dart';
import 'package:flash_chat/app/data/model/user.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';

class HomeController extends GetxController {
  signOut() {
    AuthUser().signOut();
  }

  var myUserName = UserDb().loadUserName();
  // listcontac
  Stream<QuerySnapshot<Map>> getChatRoomList() async* {
    yield* FirebaseFirestore.instance
        .collection('chatroom')
        .where('users', arrayContains: myUserName)
        .snapshots();
  }

  late UserModel myUserModel;

  getMyUserModel() async {
    var id = UserDb().loadUserId();
    DocumentSnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    myUserModel = UserModel.fromJson(data.data()!);
  }

// get chat to developer

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
    this.chatRoomId = chatRoomId;
    Map<String, dynamic> chatRoomInfoMap = {
      myUsername + 'name': myName,
      user.username! + 'name': user.name,
      myUsername: myProfile,
      user.username!: user.profileUrl,
      'lastMessageSendByTs': lastMessageTs,
      'users': <String>[myUsername, user.username!]
    };
    DatabaseMethod().createChatRoom(chatRoomId, chatRoomInfoMap);
  }

  addMassage(UserModel model) {
    String message =
        'Selamat datang\nsaya selaku developer mengucapkan terimakasih sudah mengistal aplikasi FlashChat.\nbila ada yang perlu ditanyakan silahkan silahkan chat langsung disini.';

    var lastMessageTs = DateTime.now();

    Map<String, dynamic> messageInfo = {
      'message': message,
      'sendBy': model.username,
      'ts': lastMessageTs,
      'imgUrl': model.username
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
    });
  }

  getChatByDeveloper() async {
    var install = Instalasi().membacaInstall();
    if (install == null) {
      DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('users')
          .doc('pAWt7JpX8yNnoaCUoXWPasXUQXr2')
          .get();
      UserModel developer = UserModel.fromJson(data.data()!);
      toChatroom(developer);
      addMassage(developer);
      Instalasi().baruInstall();
    }
  }

  @override
  void onInit() {
    getMyInfo();
    getMyUserModel();
    Future.delayed(const Duration(seconds: 3), () => getChatByDeveloper());
    // signOut();

    super.onInit();
  }
}
