import 'package:flutter/material.dart';
import 'package:hmsi_app/const.dart';
import 'package:hmsi_app/features/presentation/pages/credential/widgets/custom_clip_path_cred_widget.dart';
import 'package:hmsi_app/features/presentation/widgets/button_container_widget.dart';

import '../../widgets/form_container_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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
                padding: const EdgeInsets.only(top: 19.0),
                width: double.infinity,
                height: size.height * 0.3,
                color: const Color.fromARGB(255, 140, 236, 236),
                child: Image.asset(
                  "assets/images/signup-pic.png",
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
                      text: "Register",
                      style: kTitleTextStyle.copyWith(
                        fontSize: size.height * 0.05,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "\nCreate your account",
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

                  // E-mail
                  const FormContainerWidget(
                    iconsField: Icons.email,
                    hintText: "E-Mail",
                    inputType: TextInputType.emailAddress,
                  ),
                  sizeVer(size.height * 0.01),

                  // Password
                  const FormContainerWidget(
                    iconsField: Icons.password,
                    hintText: "Password",
                    isPasswordField: true,
                  ),
                  sizeVer(size.height * 0.19),

                  // Login Button
                  const ButtonContainerWidget(
                    text: "REGISTER",
                    textColor: Colors.white,
                    btnColor: Colors.black,
                  ),
                  sizeVer(size.height * 0.02),

                  // Navigator to SignInPage
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Have an account? ",
                        style: TextStyle(color: primaryColor),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            PageConst.signInPage,
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Sign In.",
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
