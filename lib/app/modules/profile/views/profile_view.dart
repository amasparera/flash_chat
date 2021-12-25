import 'package:flash_chat/app/data/getstoragedb/user_db.dart';
import 'package:flash_chat/app/data/hivedb/user_hive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: yelo),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        elevation: 0,
        title: Text(
          '@${controller.argumen.username!}',
          style: const TextStyle(color: yelo),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            child: Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    (controller.argumen.profileUrl == '')
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 120,
                          )
                        : Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        controller.argumen.profileUrl!),
                                    fit: BoxFit.cover)),
                          ),
                    (controller.argumen.userid == UserDb().loadUserId())
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: GestureDetector(
                                onTap: () {},
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ),
          textTile(Icons.person, controller.argumen.name!, 'Nama'),
          textTile(Icons.credit_card, controller.argumen.userid!, 'User Id'),
          textTile(Icons.email, controller.argumen.email, 'Email'),
          const SizedBox(
            height: 30,
          ),
          controller.bukanSaya ? buttonAction() : const SizedBox(),
          const SizedBox(height: 30),
          controller.bukanSaya == false
              ? Center(
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.red)),
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'Maaf fitur setting akun dan mengganti\n fotoprofile, sedang dikerjakan oleh\n developer',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget buttonAction() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            IconButton(
                onPressed: () {
                  UserHive().adddata(controller.argumen);
                },
                icon: const Icon(Icons.person_add)),
            const Text('Berteman')
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          children: [
            IconButton(
                onPressed: () {
                  controller.toChatroom();
                },
                icon: const Icon(Icons.chat)),
            const Text('Chat')
          ],
        )
      ],
    );
  }

  Widget textTile(icon, text, judul) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(
              width: Get.width * 0.15,
              child: Icon(
                icon,
                color: Colors.grey,
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(judul, style: const TextStyle(color: Colors.grey)),
                Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18),
                )
              ],
            )),
            const Icon(
              Icons.edit,
              color: Colors.blue,
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}
