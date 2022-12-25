import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmsi_app/const.dart';

import '../../cubits/auth/auth_cubit.dart';

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
              onTap: () {
                _openModalBottomSheet(context);
              },
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

  Future<dynamic> _openModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 125,
          decoration: const BoxDecoration(
            color: backGroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              children: [
                const Text(
                  "More Options",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                sizeHor(15),
                const Divider(thickness: 1, color: Colors.black),
                ListTile(
                  onTap: () {
                    BlocProvider.of<AuthCubit>(context).loggedOut();
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
