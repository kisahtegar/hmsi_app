import 'package:flutter/material.dart';
import 'package:hmsi_app/const.dart';

import '../../widgets/button_container_widget.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/hmsi-logo.png',
                width: 250,
              ),
              sizeVer(30),
              const Text(
                "Welcome to HMSI",
                style: kTitleTextStyle,
              ),
              sizeVer(15),
              const Text(
                "Selamat Datang di HMSI Apps\ntempat dimana Informasi, event,\n acara dan lain-lain disini.",
                style: kSubTextStyle,
                textAlign: TextAlign.center,
              ),
              sizeVer(20),
              ButtonContainerWidget(
                text: "Sign In",
                btnColor: Colors.black,
                textColor: Colors.white,
                onTapListener: () {},
              ),
              sizeVer(8),
              ButtonContainerWidget(
                text: "Sign Up",
                btnColor: Colors.white,
                textColor: Colors.black,
                onTapListener: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
