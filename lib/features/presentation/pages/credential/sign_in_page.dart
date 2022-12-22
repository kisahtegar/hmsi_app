import 'package:flutter/material.dart';
import 'package:hmsi_app/const.dart';
import 'package:hmsi_app/features/presentation/pages/credential/widgets/custom_clip_path_cred_widget.dart';
import 'package:hmsi_app/features/presentation/widgets/button_container_widget.dart';

import '../../widgets/form_container_widget.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Heading
            ClipPath(
              clipper: CustomClipPathCred(),
              child: Container(
                padding: const EdgeInsets.only(top: 47.0),
                width: double.infinity,
                height: size.height * 0.3,
                color: const Color.fromARGB(255, 140, 236, 236),
                child: Image.asset(
                  "assets/images/signin-pic.png",
                  // fit: BoxFit.fill,
                ),
              ),
            ),
            sizeVer(size.height * 0.02),

            // Column of text, box, button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                children: [
                  // Welcome Text
                  Text.rich(
                    TextSpan(
                      text: "Welcome Back",
                      style: kTitleTextStyle.copyWith(
                        fontSize: size.height * 0.05,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "\nLogin to your account",
                          style: kSubTextStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: size.height * 0.018,
                          ),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  sizeVer(size.height * 0.05),

                  // Username
                  const FormContainerWidget(
                    iconsField: Icons.person,
                    hintText: "Username",
                  ),
                  sizeVer(size.height * 0.01),

                  // Password
                  const FormContainerWidget(
                    iconsField: Icons.password,
                    hintText: "Password",
                    isPasswordField: true,
                  ),
                  sizeVer(size.height * 0.26),

                  // Login Button
                  const ButtonContainerWidget(
                    text: "LOGIN",
                    textColor: Colors.white,
                    btnColor: Colors.black,
                  ),
                  sizeVer(size.height * 0.02),

                  // Navigator to SignUpPage
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have and account? ",
                        style: TextStyle(color: primaryColor),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            PageConst.signUpPage,
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Sign Up.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
