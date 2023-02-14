import 'package:flutter/material.dart';

import '../../../../const.dart';
import '../../widgets/no_page_widget.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("NotificationPage[build]: Building!!");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Notifications",
          style: TextStyle(color: AppColor.primaryColor, fontSize: 25),
        ),
      ),
      body: noPageWidget(
        icon: Icons.notifications_off,
        title: "No Notification Yet!",
        titleSize: 23,
        description:
            "There is no notification at this time, \nplease come back later.",
        descriptionSize: 15,
      ),
    );
  }
}
