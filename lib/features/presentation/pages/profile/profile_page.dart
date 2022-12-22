import 'package:flutter/material.dart';
import 'package:hmsi_app/const.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("ProfilePage[build]: Building!!");
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          "Profile",
          style: TextStyle(color: primaryColor, fontSize: 25),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {},
              child: const Icon(
                Icons.menu,
                color: primaryColor,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Pic and Username
            Center(
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.16,
                    width: size.width * 0.5,
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  sizeVer(10),
                  Text(
                    "Username",
                    style: kTitleTextStyle.copyWith(fontSize: 25),
                  ),
                ],
              ),
            ),
            sizeVer(20),

            // Biodata
            Column(
              children: const [
                Text(
                  "Details",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
