import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? name;
  String? name2;
  String? profile1;
  String? profile2;
  String? lastMessage;
  String? lastMessageSendBy;
  Timestamp? lastMessageSendByTs;
  List? users;

  ChatRoomModel(this.name2, {this.name});

  ChatRoomModel.fromJson(
      Map<dynamic, dynamic> json, String username, String myUserName) {
    name = json[myUserName + 'name'];
    name2 = json[username + 'name'];
    profile1 = json[myUserName];
    profile2 = json[username];
    lastMessage = json['lastMessage'];
    lastMessageSendBy = json['lastMessageSendBy'];
    lastMessageSendByTs = json['lastMessageSendByTs'];
    users = json['users'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
