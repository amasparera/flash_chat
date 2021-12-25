import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/app/data/getstoragedb/user_db.dart';
import 'package:flash_chat/app/data/model/user.dart';

class DatabaseMethod {
  Future addUserInfoToDb(String userid, Map<String, dynamic> userData) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .set(userData);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserByUid(
      String userid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .get();
  }

  Future<List<UserModel>> searchUser(String text, UserModel user) async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: text)
        .get();
    List<UserModel> map =
        data.docs.map((e) => UserModel.fromJson(e.data())).toList();

    return map
        .where((element) =>
            element.name!.contains(text) && element.userid != user.userid)
        .toList();
  }

  Future addMasage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfo) async {
    return FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chat')
        .doc(messageId)
        .set(messageInfo);
  }

  Future updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) async {
    return FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  Future createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .get();

    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection('chatroom')
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessage(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chat')
        .orderBy('ts', descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRoomList() async {
    String myName = UserDb().loadUserName();
    return FirebaseFirestore.instance
        .collection('chatroom')
        .orderBy('lastMessageSendByTs')
        .where('users', arrayContains: myName)
        .snapshots();
  }
}
