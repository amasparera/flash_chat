// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'FlashChat',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          )),
      body: Obx(() {
        return ListView(
          children: [
            SizedBox(
              height: 220,
              child: Image.asset('assets/Frame 1 (1).png'),
            ),
            controller.signIn.value
                ? const SizedBox()
                : textFielUmum('name', Icons.person, cont: controller.name),

            textFielUmum('email', Icons.email_rounded, cont: controller.email),
            textFielPassword(controller.password),
            buttonLogin(controller.signIn.value ? 'Sign In' : 'Sign Up',
                () async {
              controller.signIn.value
                  ? controller.signInButton()
                  : controller.signUp();
            }, yelo),

            //
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              child: Row(
                children: const [
                  Flexible(
                      child: Divider(
                    thickness: 2,
                  )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Text('Or'),
                  ),
                  Flexible(
                      child: Divider(
                    thickness: 2,
                  ))
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            buttonLogin('Sign In With Goolge', () {
              controller.loginGoogle();
            }, Colors.red),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Do you ready to account? ',
                  style: TextStyle(color: Colors.black)),
              GestureDetector(
                onTap: () {
                  controller.operSignIn();
                },
                child: const Text(
                  'Register',
                  style: TextStyle(color: yelo),
                ),
              )
            ]),
            const SizedBox(
              height: 100,
            )
          ],
        );
      }),
    );
  }

  Padding textFielUmum(String hintText, IconData icon,
      {required TextEditingController cont}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: TextField(
        onChanged: (value) {
          print(value);
        },
        controller: cont,
        decoration: InputDecoration(icon: Icon(icon), hintText: hintText),
      ),
    );
  }

  Padding textFielPassword(TextEditingController conc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: TextField(
        controller: conc,
        onChanged: (value) {
          print(value);
        },
        obscureText: controller.visibiliti.value,
        decoration: InputDecoration(
            icon: const Icon(Icons.lock),
            suffixIcon: Obx(() => IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    controller.openVisibiliti();
                  },
                  icon: Icon(
                    controller.visibiliti.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                )),
            hintText: 'password'),
      ),
    );
  }

  Container buttonLogin(String text, VoidCallback onPressed, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
