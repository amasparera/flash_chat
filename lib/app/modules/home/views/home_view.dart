import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/app/data/getstoragedb/user_db.dart';
import 'package:flash_chat/app/data/model/chat_room.dart';
import 'package:flash_chat/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'FlashChat',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        elevation: 1,
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () {
                Get.toNamed(Routes.SEARCH);
              },
              icon: const Icon(
                Icons.search,
                color: yelo,
              )),
          IconButton(
              splashRadius: 20,
              onPressed: () {
                Get.toNamed(Routes.PROFILE, arguments: controller.myUserModel);
              },
              icon: const Icon(
                Icons.person,
                color: yelo,
              )),
          IconButton(
              splashRadius: 20,
              onPressed: () {
                controller.signOut();
              },
              icon: const Icon(
                Icons.exit_to_app_rounded,
                color: yelo,
              ))
        ],
      ),
      floatingActionButton: floatingButton(),
      body: StreamBuilder<QuerySnapshot<Map>>(
          stream: controller.getChatRoomList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var myUserName = UserDb().loadUserName();
                  List<ChatRoomModel> doc = snapshot.data!.docs.map((e) {
                    String username = snapshot.data!.docs[index].id
                        .replaceAll(myUserName, '')
                        .replaceAll('_', '');
                    return ChatRoomModel.fromJson(
                        snapshot.data!.docs[index].data(),
                        username,
                        myUserName);
                  }).toList();
                  doc.sort((a, b) =>
                      a.lastMessageSendByTs!.compareTo(b.lastMessageSendByTs!));

                  var data = doc[index];
                  if (snapshot.data!.docs.isNotEmpty) {
                    return textTile(data);
                  } else {
                    return const Center(child: Text('Tidak ada Pesan'));
                  }
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  FloatingActionButton floatingButton() {
    return FloatingActionButton(
      child: const Icon(Icons.chat),
      onPressed: () {
        Get.toNamed(Routes.CONTACT);
      },
    );
  }

  Widget textTile(ChatRoomModel doc) {
    List? list = doc.users;
    list!.remove(UserDb().loadUserName());
    String myUsername = UserDb().loadUserName();
    DateTime waktu =
        DateTime.parse(doc.lastMessageSendByTs!.toDate().toString());
    return ListTile(
      onTap: () async {
        Get.toNamed(Routes.CHATROOM, arguments: list[0]);
      },
      leading: (doc.profile2 != '')
          ? CircleAvatar(
              backgroundImage: NetworkImage(doc.profile2!),
            )
          : const CircleAvatar(
              child: Icon(Icons.person),
            ),
      title: Text(doc.name2!),
      subtitle: Text(doc.lastMessage ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
              color: (doc.lastMessageSendBy == myUsername)
                  ? Colors.grey
                  : Colors.blue)),
      trailing: Text(
        DateFormat.jm().format(waktu),
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
}
