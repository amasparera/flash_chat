import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/app/data/firebase/auth_user.dart';
import 'package:flash_chat/app/data/getstoragedb/user_db.dart';
import 'package:flash_chat/app/data/model/user.dart';
import 'package:get/get.dart';

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

  @override
  void onInit() {
    getMyUserModel();
    // signOut();

    super.onInit();
  }
}
