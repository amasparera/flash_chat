import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/connection_controller.dart';

class ConnectionView extends GetView<ConnectionController> {
  const ConnectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 40,
              ),
              TextButton(
                  onPressed: () {
                    controller.check();
                  },
                  child: const Text('Reload'))
            ],
          ),
        ),
      ),
    );
  }
}
