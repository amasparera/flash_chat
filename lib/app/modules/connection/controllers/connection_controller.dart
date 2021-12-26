import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  void check() {
    Connectivity().onConnectivityChanged.listen((event) {
      if (event != ConnectivityResult.ethernet) {
        return Get.back();
      }
    });
  }
}
