import 'package:flutter/material.dart';
import 'package:hmsi_app/const.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("NewsPage[build]: Building!!");
    return const Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: Text(
          "News Page",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
