import 'package:flutter/material.dart';

import '../../../../const.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("NotificationPage[build]: Building!!");
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Notifications",
          style: TextStyle(color: AppColor.primaryColor, fontSize: 25),
        ),
      ),
      body: const Center(
        child: Text(
          "Notifications Page",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
