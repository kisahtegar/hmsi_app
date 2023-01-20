import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../const.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/credential/credential_cubit.dart';
import '../../widgets/button_container_widget.dart';
import '../../widgets/form_container_widget.dart';
import '../../widgets/loading_button_container_widget.dart';
import '../main_screen/main_screen.dart';
import 'widgets/custom_clip_path_cred_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("SignUpPage[build]: Building!!");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            debugPrint("SignUpPage[CredentialState]: CredentialSuccess");
            BlocProvider.of<AuthCubit>(context).loggedIn();
          }
          if (credentialState is CredentialFailure) {
            debugPrint("SignUpPage[CredentialState]: CredentialFailure");
            toast("Invalid E-Mail or password");
          }
        },
        builder: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  debugPrint("SignUpPage[authState]: Authenticated");
                  return MainScreen(uid: authState.uid);
                } else {
                  debugPrint("SignUpPage[authState]: UnAuthenticated");
                  return _bodyWidget(size, context);
                }
              },
            );
          }
          debugPrint("SignUpPage[builder_CredentialCubit]: $credentialState");
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
          AppSize.sizeVer(size.height * 0.02),

          // Column of text, box, button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              children: [
                // Welcome Text
                Text.rich(
                  TextSpan(
                    text: "Register",
                    style: AppTextStyle.kTitleTextStyle.copyWith(
                      fontSize: size.height * 0.05,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "\nCreate your account",
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

                // Username
                FormContainerWidget(
                  controller: _usernameController,
                  iconsField: Icons.person,
                  hintText: "Username",
                  maxLength: 25,
                ),
                AppSize.sizeVer(size.height * 0.01),

                // E-mail
                FormContainerWidget(
                  controller: _emailController,
                  iconsField: Icons.email,
                  hintText: "E-Mail",
                  inputType: TextInputType.emailAddress,
                ),
                AppSize.sizeVer(size.height * 0.01),

                // Password
                FormContainerWidget(
                  controller: _passwordController,
                  iconsField: Icons.password,
                  hintText: "Password",
                  isPasswordField: true,
                ),
                AppSize.sizeVer(size.height * 0.19),

                // Register Button
                _loading == true
                    ? const LoadingButtonContainerWidget(
                        boxColor: Colors.black,
                      )
                    : ButtonContainerWidget(
                        text: "REGISTER",
                        textColor: Colors.white,
                        btnColor: Colors.black,
                        onTapListener: () {
                          _signUpUser();
                        },
                      ),

                AppSize.sizeVer(size.height * 0.02),

                // Navigator to SignInPage
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have an account? ",
                      style: TextStyle(color: AppColor.primaryColor),
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
    );
  }

  void _signUpUser() {
    setState(() {
      _loading = true;
    });

    BlocProvider.of<CredentialCubit>(context)
        .signUpUser(
            userEntity: UserEntity(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      name: "",
      npm: "",
      bio: "",
      profileUrl: "",
      role: "guest",
    ))
        .then((value) {
      setState(() {
        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _loading = false;
      });
    });
  }
}
