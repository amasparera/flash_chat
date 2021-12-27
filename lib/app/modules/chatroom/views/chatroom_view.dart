import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/app/data/getstoragedb/user_db.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../controllers/chatroom_controller.dart';

class ChatroomView extends GetView<ChatroomController> {
  const ChatroomView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: yelo),
        title: Text(
          '@${controller.arg}',
          style: const TextStyle(color: yelo),
        ),
        // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.person))],
      ),
      body: Column(
        children: [bodyChat(), textFieldSend()],
      ),
    );
  }

  Widget textFieldSend() {
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, -4),
            color: Colors.black.withOpacity(.1))
      ]),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 18),
              child: TextField(
                minLines: 1,
                maxLines: 5,
                controller: controller.send,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'type a message',
                ),
              ),
            ),
          ),
          IconButton(
              splashRadius: 20,
              onPressed: () {
                controller.addMassage(true);
                // controller.lastpesan();
              },
              icon: const Icon(
                Icons.send,
                color: Colors.blue,
              ))
        ],
      ),
    );
  }

  Widget bodyChat() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: controller.getChatRoomMessage(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? listChat(snapshot)
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }

  Widget listChat(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView.builder(
        controller: controller.scroll,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          DocumentSnapshot doc = snapshot.data!.docs[index];
          return textTile(doc);
        });
  }

  Widget textTile(DocumentSnapshot doc) {
    String myUsername = UserDb().loadUserName();
    DateTime waktu = DateTime.parse(doc['ts'].toDate().toString());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Column(
        crossAxisAlignment: doc['sendBy'] == controller.myUsername
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                  borderRadius: (doc['sendBy'] == myUsername)
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8))
                      : const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                  color: (doc['sendBy'] == myUsername)
                      ? Colors.blue[50]
                      : Colors.blue[100]),
              child: Text(doc['message'])),
          Text(
            DateFormat.E().add_jm().format(waktu),
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
