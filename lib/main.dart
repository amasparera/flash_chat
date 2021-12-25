import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/data/model/user.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'app/modules/splah/splas.dart';
import 'app/routes/app_pages.dart';

// main dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  var document = await path.getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter<UserModel>(UserModelAdapter());
  await Hive.openBox('userhive');
  await GetStorage.init();
  runApp(
    FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplasScreeen();
          } else {
            return const MainApp();
          }
        }),
  );
}

// main app
class MainApp extends StatelessWidget {
  const MainApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FlashChat",
      initialRoute: AppPages.INITIAL(),
      getPages: AppPages.routes,
    );
  }
}

const Color yelo = Colors.blue;
