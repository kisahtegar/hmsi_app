import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmsi_app/const.dart';
import 'package:hmsi_app/features/domain/entities/user/user_entity.dart';
import 'package:hmsi_app/features/presentation/widgets/profile_widget.dart';

import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/credential/credential_cubit.dart';
import 'widget/menu_button_container_widget.dart';

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
    var sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: AppColor.primaryColor,
            fontSize: sizeWidth * 0.075,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColor.gradientFirst.withOpacity(0.8),
                      AppColor.gradientSecond.withOpacity(0.9)
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(5, 10),
                      blurRadius: 20,
                      color: AppColor.gradientSecond.withOpacity(0.3),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Row(
                    children: [
                      // Picture
                      SizedBox(
                        width: sizeWidth * 0.15,
                        height: sizeWidth * 0.15,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: profileWidget(
                            imageUrl: "${widget.currentUser.profileUrl}",
                          ),
                        ),
                      ),
                      AppSize.sizeHor(10),

                      // Nama, NPM,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // "Kisah_Tegar_Putra_Abdi_ba",
                              "${widget.currentUser.name == "" ? widget.currentUser.username : widget.currentUser.name}",
                              style: AppTextStyle.kTitleTextStyleLight.copyWith(
                                fontSize: sizeWidth * 0.05,
                              ),
                            ),
                            AppSize.sizeVer(3),
                            Text(
                              "${widget.currentUser.npm}",
                              // "${widget.currentUser.npm}",
                              style: AppTextStyle.kSubTextStyleLight.copyWith(
                                fontSize: sizeWidth * 0.036,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Settings Button
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            PageConst.editProfilePage,
                            arguments: widget.currentUser,
                          );
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // [BUTTON]: Help, Contact
              AppSize.sizeVer(30),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(5, 10),
                      blurRadius: 20,
                      color: AppColor.gradientSecond.withOpacity(0.3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // help
                    MenuButtonContainerWidget(
                      onTap: () {},
                      text: "Help",
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),

                    const Divider(height: 0, indent: 0, thickness: 0.4),
                    // Contact
                    MenuButtonContainerWidget(
                      onTap: () {},
                      text: "Contact",
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),

              // [BUTTON]: Exit/Logout.
              AppSize.sizeVer(30),
              InkWell(
                onTap: () {
                  BlocProvider.of<AuthCubit>(context).loggedOut();
                  BlocProvider.of<CredentialCubit>(context).initialCredential();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    PageConst.welcomePage,
                    (route) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    // color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: const Center(
                    child: Text(
                      "EXIT",
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
