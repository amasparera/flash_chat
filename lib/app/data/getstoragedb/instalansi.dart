import 'package:get_storage/get_storage.dart';

class Instalasi {
  GetStorage box = GetStorage();

  void baruInstall() {
    box.write('baru', 'baru');
  }

  void contacKosong() {
    box.write('contact', 'baru');
  }

  String? membacaInstall() {
    return box.read('baru');
  }

  String? membacaContac() {
    return box.read('contact');
  }
}
