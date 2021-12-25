import 'package:flash_chat/app/data/model/user.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/contact_controller.dart';

class ContactView extends GetView<ContactController> {
  const ContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Contact'),
            GetBuilder<ContactController>(
              init: ContactController(),
              initState: (_) {},
              builder: (_) {
                return Text(
                  controller.data.length.toString() + ' contact',
                  style: const TextStyle(fontSize: 12),
                );
              },
            )
          ],
        ),
      ),
      body: GetBuilder<ContactController>(
        init: ContactController(),
        initState: (_) {},
        builder: (_) {
          return ListView.builder(
            itemCount: controller.data.length,
            itemBuilder: (context, index) {
              UserModel data = controller.data.getAt(index);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: ListTile(
                  onTap: () {
                    controller.toChatroom(data);
                  },
                  title: Text(data.name!),
                  leading: (data.profileUrl != '')
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(data.profileUrl!),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                  trailing: IconButton(
                      onPressed: () {
                        controller.delete(index);
                      },
                      icon: const Icon(Icons.delete)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
