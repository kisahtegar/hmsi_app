import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../const.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/credential/credential_cubit.dart';
import '../../widgets/button_container_widget.dart';
import '../../widgets/form_container_widget.dart';
import '../../widgets/loading_button_container_widget.dart';
import '../main_screen/main_screen.dart';
import 'widgets/custom_clip_path_cred_widget.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("SignInPage[build]: Building!!");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            debugPrint("SignInPage[CredentialState]: CredentialSuccess");
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (credentialState is CredentialFailure) {
            debugPrint("SignInPage[CredentialState]: CredentialFailure");
            toast("Invalid E-Mail or Password");
          }
        },
        builder: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  debugPrint("SignInPage[authState]: Authenticated");
                  return MainScreen(uid: authState.uid);
                } else {
                  debugPrint("SignInPage[authState]: UnAuthenticated");
                  return _bodyWidget(size, context);
                }
              },
            );
          }
          debugPrint("SignInPage[builder_CredentialCubit]: $credentialState");
          return _bodyWidget(size, context);
        },
      ),
    );
  }

  SingleChildScrollView _bodyWidget(Size size, BuildContext context) {
    return SingleChildScrollView(
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
          AppSize.sizeVer(size.height * 0.02),

          // Column of text, box, button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              children: [
                // Welcome Text
                Text.rich(
                  TextSpan(
                    text: "Welcome Back",
                    style: AppTextStyle.kTitleTextStyle.copyWith(
                      fontSize: size.height * 0.05,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "\nLogin to your account",
                        style: AppTextStyle.kSubTextStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: size.height * 0.018,
                        ),
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSize.sizeVer(size.height * 0.05),

                // E-Mail
                FormContainerWidget(
                  controller: _emailController,
                  iconsField: Icons.person,
                  hintText: "Username / E-Mail",
                ),
                AppSize.sizeVer(size.height * 0.01),

                // Password
                FormContainerWidget(
                  controller: _passwordController,
                  iconsField: Icons.password,
                  hintText: "Password",
                  isPasswordField: true,
                ),
                AppSize.sizeVer(size.height * 0.26),

                // Login Button
                _loading == true
                    ? const LoadingButtonContainerWidget(
                        boxColor: Colors.black,
                      )
                    : ButtonContainerWidget(
                        text: "LOGIN",
                        textColor: Colors.white,
                        btnColor: Colors.black,
                        onTapListener: () {
                          _signInUser();
                        },
                      ),
                AppSize.sizeVer(size.height * 0.02),

                // Navigator to SignUpPage
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have and account? ",
                      style: TextStyle(color: AppColor.primaryColor),
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
    );
  }

  void _signInUser() {
    setState(() {
      _loading = true;
    });

    BlocProvider.of<CredentialCubit>(context)
        .signInUser(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .then((value) {
      setState(() {
        _emailController.clear();
        _passwordController.clear();
        _loading = false;
      });
    });
  }
}
