import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  Connectivity connectivity = Connectivity();

  void check() async {
    // ignore: avoid_print
    print('object');
    connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
      } else {
        // ignore: avoid_print
        print('check');
        Get.back();
      }
    });
  }
}
