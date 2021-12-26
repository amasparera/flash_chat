import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:flash_chat/app/modules/connection/bindings/connection_binding.dart';
import 'package:flash_chat/app/modules/connection/views/connection_view.dart';

import '../modules/chatroom/bindings/chatroom_binding.dart';
import '../modules/chatroom/views/chatroom_view.dart';
import '../modules/contact/bindings/contact_binding.dart';
import '../modules/contact/views/contact_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: non_constant_identifier_names
  static String? INITIAL() {
    User? auth = FirebaseAuth.instance.currentUser;
    return (auth == null) ? Routes.LOGIN : Routes.HOME;
  }

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CHATROOM,
      page: () => const ChatroomView(),
      binding: ChatroomBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CONTACT,
      page: () => const ContactView(),
      binding: ContactBinding(),
    ),
    GetPage(
      name: _Paths.CONNECTION,
      page: () => const ConnectionView(),
      binding: ConnectionBinding(),
    ),
  ];
}
