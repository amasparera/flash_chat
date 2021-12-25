import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/app/data/getstoragedb/user_db.dart';
import 'package:flash_chat/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'database_method.dart';

class AuthUser {
  void signInWithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result = await _auth.signInWithCredential(authCredential);

    User? user = result.user;

    if (user != null) {
      UserDb().saveUserEmail(user.email);
      UserDb().saveUserId(user.uid);
      UserDb().saveDisplayName(user.displayName);
      UserDb().saveUserProfile(user.photoURL);
      UserDb().saveUserName(user.email!.replaceAll('@gmail.com', ''));

      Map<String, dynamic> userData = {
        'email': user.email,
        'name': user.displayName,
        'userid': user.uid,
        'profileUrl': user.photoURL,
        'username': user.email!.replaceAll('@gmail.com', '')
      };

      DatabaseMethod().addUserInfoToDb(user.uid, userData);
    } else {
      return null;
    }
  }

  signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    GetStorage box = GetStorage();

    box.erase();
    await _auth.signOut().then((value) => Get.offAllNamed(Routes.LOGIN));
  }
}
