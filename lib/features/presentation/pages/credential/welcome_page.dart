import 'package:flutter/material.dart';
import 'package:hmsi_app/const.dart';

import '../../widgets/button_container_widget.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
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
              AppSize.sizeVer(30),
              Text(
                "Welcome to HMSI",
                style: AppTextStyle.kTitleTextStyle,
              ),
              AppSize.sizeVer(15),
              Text(
                "Selamat Datang di HMSI Apps\ntempat dimana Informasi, event,\n acara dan lain-lain disini.",
                style: AppTextStyle.kSubTextStyle,
                textAlign: TextAlign.center,
              ),
              AppSize.sizeVer(20),
              ButtonContainerWidget(
                text: "Sign In",
                btnColor: Colors.black,
                textColor: Colors.white,
                onTapListener: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    PageConst.signInPage,
                    (route) => false,
                  );
                },
              ),
              AppSize.sizeVer(8),
              ButtonContainerWidget(
                text: "Sign Up",
                btnColor: Colors.white,
                textColor: Colors.black,
                onTapListener: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    PageConst.signUpPage,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
