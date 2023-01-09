import 'package:flutter/material.dart';
import 'package:hmsi_app/const.dart';
import 'package:hmsi_app/features/domain/entities/user/user_entity.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;
  const EditProfilePage({super.key, required this.currentUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    debugPrint("EditProfilePage[build]: Building!!");
    debugPrint("EditProfilePage[build]: currentUser(${widget.currentUser})");
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: AppColor.primaryColor),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close, size: 32, color: AppColor.primaryColor),
        ),
      ),
    );
  }
}
