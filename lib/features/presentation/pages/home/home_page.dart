import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../const.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../widgets/profile_widget.dart';
import 'widget/icon_menu_widget.dart';

class HomePage extends StatelessWidget {
  final UserEntity currentUser;
  const HomePage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    debugPrint("HomePage[build]: Building!!");
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        titleSpacing: 1,
        leading: Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: profileWidget(imageUrl: currentUser.profileUrl),
          ),
        ),
        title: Text(
          "Hi, ${currentUser.name == "" ? currentUser.username : currentUser.name}",
          style: TextStyle(
            color: AppColor.primaryColor,
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
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
                    onTapListener: () {
                      Navigator.pushNamed(
                        context,
                        PageConst.eventPage,
                        arguments: currentUser,
                      );
                    },
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
