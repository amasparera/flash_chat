import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

void shodialog(String title, String isi) {
  Get.defaultDialog(
      title: title,
      content: Text(
        isi,
        textAlign: TextAlign.center,
      ));
}
