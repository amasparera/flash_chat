import 'package:get/get.dart';

import '../controllers/chatroom_controller.dart';

class ChatroomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatroomController>(
      () => ChatroomController(),
    );
  }
}
