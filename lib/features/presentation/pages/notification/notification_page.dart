import 'package:flutter/material.dart';

import '../../../../const.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
  }

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
      body: _noNotificationWidget(),
    );
  }

  Widget _noNotificationWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off,
              color: Colors.black,
              size: 150,
            ),
          ),
          AppSize.sizeVer(25),
          const Text(
            "No Notification Yet!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              // color: ,
            ),
          ),
          AppSize.sizeVer(15),
          const Text(
            "There is no notification at this time, \nplease come back later.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
