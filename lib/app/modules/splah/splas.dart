import 'package:flutter/material.dart';

class SplasScreeen extends StatelessWidget {
  const SplasScreeen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
            'FlashChat',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
