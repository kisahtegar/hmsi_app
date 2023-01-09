import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmsi_app/const.dart';
import 'package:hmsi_app/features/domain/entities/user/user_entity.dart';

import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/credential/credential_cubit.dart';

class ProfilePage extends StatefulWidget {
  final UserEntity currentUser;
  const ProfilePage({super.key, required this.currentUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    debugPrint("ProfilePage[build]: Building!!");
    debugPrint("ProfilePage[build]: currentUser(${widget.currentUser})");
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Profile",
          style: TextStyle(color: AppColor.primaryColor, fontSize: 25),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                _openModalBottomSheet(context);
              },
              child: Icon(
                Icons.menu,
                color: AppColor.primaryColor,
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
                    decoration: BoxDecoration(
                      color: AppColor.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  AppSize.sizeVer(10),
                  Text(
                    "Kisah Tegar Putra Abdi",
                    style: AppTextStyle.kTitleTextStyle.copyWith(fontSize: 23),
                  ),
                  AppSize.sizeVer(5),
                  SizedBox(
                    width: 200,
                    height: 65,
                    child: Text(
                      "Title Lorem ipsum dolor sit amet, consectetur adipiscing elits wkwkwk wdawd wsadxmlw manda wddpsamiiii",
                      style: AppTextStyle.kDescTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _openModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppColor.backGroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              children: [
                // Title
                Text(
                  "More Options",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                ),
                AppSize.sizeHor(15),
                const Divider(thickness: 1, color: Colors.black),
                // EditProfilePage Button
                ListTile(
                  onTap: () {
                    Navigator.popAndPushNamed(
                      context,
                      PageConst.editProfilePage,
                      arguments: widget.currentUser,
                    );
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: const Icon(
                    Icons.mode_edit,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
                // SignOut Button
                ListTile(
                  onTap: () {
                    BlocProvider.of<AuthCubit>(context).loggedOut();
                    BlocProvider.of<CredentialCubit>(context)
                        .initialCredential();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      PageConst.welcomePage,
                      (route) => false,
                    );
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
