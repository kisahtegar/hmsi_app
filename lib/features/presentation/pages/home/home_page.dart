import 'package:flutter/material.dart';
import 'package:hmsi_app/const.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("HomePage[build]: Building!!");
    return const Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: Text(
          "Home Page",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
