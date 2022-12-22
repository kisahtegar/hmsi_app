import 'package:flutter/material.dart';
import 'package:hmsi_app/const.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("ChatPage[build]: Building!!");
    return const Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: Text(
          "Chat Page",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
