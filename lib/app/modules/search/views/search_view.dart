import 'package:flash_chat/app/data/model/user.dart';
import 'package:flash_chat/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: yelo),
        titleSpacing: 0,
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: TextField(
          autofocus: true,
          onChanged: (value) => controller.searchUser(),
          maxLines: 1,
          controller: controller.seacrh,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search "name"',
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
                onTap: () {
                  controller.searchUser();
                },
                child: const Icon(Icons.search, color: yelo)),
          ),
        ],
      ),
      body: GetX<SearchController>(
        init: SearchController(),
        builder: (_) {
          if (_.listdata.isEmpty) {
            return _.seacrh.text != ''
                ? Center(
                    child: Text('" tidak menemukan user ${_.seacrh.text} "'),
                  )
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(Icons.search),
                        Text('Seacrh user by "name"'),
                      ],
                    ),
                  );
          }
          return ListView.builder(
              itemCount: _.listdata.length,
              itemBuilder: (context, index) => searchCard(_.listdata[index]));
        },
      ),
    );
  }

  Widget searchCard(
    UserModel model,
  ) {
    List user = [];
    user.add(model.username);
    return ListTile(
      onTap: () {
        Get.toNamed(Routes.PROFILE, arguments: model);
      },
      leading: (model.profileUrl != '')
          ? CircleAvatar(
              backgroundImage: NetworkImage(model.profileUrl!),
            )
          : const CircleAvatar(
              child: Icon(Icons.person),
            ),
      title: Text(model.name!),
      subtitle: Text(model.email!),
      trailing: GestureDetector(
        onTap: () async {
          controller.toChatroom(
            model,
          );
        },
        child: const Icon(
          Icons.chat,
          color: yelo,
        ),
      ),
    );
  }
}
