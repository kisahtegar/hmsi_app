import 'package:flutter/material.dart';
import 'package:hmsi_app/const.dart';
import 'package:hmsi_app/features/presentation/pages/home/widget/icon_menu_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/user/user_entity.dart';

class HomePage extends StatelessWidget {
  final UserEntity currentUser;
  const HomePage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    debugPrint("HomePage[build]: Building!!");
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Home",
          style: TextStyle(color: AppColor.primaryColor, fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Wrap(
                // runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  IconMenuWidget(
                    backgroundColor: Colors.orange.withOpacity(0.5),
                    image: "assets/images/pendaftaran.png",
                    imageSize: 45,
                    description: "Daftar",
                    onTapListener: () async {
                      openUrl("https://www.instagram.com/hmsi.ipem/");
                    },
                  ),
                  IconMenuWidget(
                    backgroundColor: Colors.red.withOpacity(0.5),
                    image: "assets/images/chat.png",
                    imageSize: 50,
                    description: "Chat",
                    onTapListener: () {},
                  ),
                  IconMenuWidget(
                    backgroundColor: Colors.blue.withOpacity(0.5),
                    image: "assets/images/absensi.png",
                    imageSize: 48,
                    description: "Event",
                    onTapListener: () {},
                  ),
                  IconMenuWidget(
                    backgroundColor: Colors.blue.withOpacity(0.5),
                    image: "assets/images/about.png",
                    imageSize: 50,
                    description: "About",
                    onTapListener: () {},
                  ),
                  // Container(width: 80) // FakeContainer
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openUrl(String url) async {
    final Uri urll = Uri.parse(url);
    if (!await launchUrl(urll, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
