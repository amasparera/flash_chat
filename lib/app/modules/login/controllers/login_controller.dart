import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/app/data/firebase/auth_user.dart';
import 'package:flash_chat/app/data/firebase/database_method.dart';
import 'package:flash_chat/app/data/getstoragedb/user_db.dart';
import 'package:flash_chat/app/data/model/user.dart';
import 'package:flash_chat/app/modules/splah/dialog.dart';
import 'package:flash_chat/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
// view
  var signIn = true.obs;
  void operSignIn() {
    signIn.value = !signIn.value;
  }

  var visibiliti = true.obs;

  void openVisibiliti() {
    visibiliti.value = !visibiliti.value;
    update();
  }

// function button

  Future loginGoogle() async {
    AuthUser().signInWithGoogle();
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  Future<void> signInButton() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      if (credential.user != null) {
        var data = await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .get();
        UserModel model = UserModel.fromJson(data.data()!);

        UserDb().saveUserEmail(email.text);
        UserDb().saveUserId(model.userid);
        UserDb().saveDisplayName(model.name);
        UserDb().saveUserProfile(model.profileUrl);
        UserDb().saveUserName(email.text.replaceAll('@gmail.com', ''));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        shodialog('Sign In Failed',
            'Email yang anda masukan salah\nmasukan email dengan benar.');
      } else if (e.code == 'wrong-password') {
        shodialog('Sign In Failed',
            'Passord yang anda masukan salah\nmasukan password dengan benar.');
      }
    }
  }

  void signUp() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);

      if (credential.user != null) {
        UserDb().saveUserEmail(email.text);
        UserDb().saveUserId(credential.user?.uid);
        UserDb().saveDisplayName(name.text);
        UserDb().saveUserProfile('');
        UserDb().saveUserName(email.text.replaceAll('@gmail.com', ''));

        Map<String, dynamic> userData = {
          'email': email.text,
          'name': name.text,
          'userid': credential.user?.uid,
          'profileUrl': '',
          'username': email.text.replaceAll('@gmail.com', '')
        };

        DatabaseMethod().addUserInfoToDb(credential.user!.uid, userData);
      } else {
        return;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        shodialog('Sign Up Failed', 'Kata sandi yang diberikan terlalu lemah.');
      } else if (e.code == 'email-already-in-use') {
        shodialog('Sign Up Failed', 'Akun sudah ada untuk email itu.');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

// cek connection

  @override
  void onReady() {
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        Get.toNamed(Routes.CONNECTION);
      }
    });
    //
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // ignore: avoid_print
        print('User is currently signed out!');
      } else {
        Get.offAndToNamed(Routes.HOME);
      }
    });

    super.onReady();
  }
}
