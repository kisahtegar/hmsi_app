import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../const.dart';
import '../../../../injection_container.dart' as di;
import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/usecases/user/upload_image_to_storage_usecase.dart';
import '../../cubits/user/user_cubit.dart';
import '../../widgets/profile_widget.dart';
import 'widget/form_edit_widget.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;
  const EditProfilePage({super.key, required this.currentUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  bool _isUpdating = false;
  TextEditingController? _nameController;
  TextEditingController? _npmController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.currentUser.name);
    _npmController = TextEditingController(text: widget.currentUser.npm);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: _isUpdating == false
                ? GestureDetector(
                    onTap: () {
                      _updateUserProfileData();
                    },
                    child: Icon(Icons.done,
                        color: AppColor.primaryColor, size: 32),
                  )
                : const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: [
            // [Container]: Profile Picture.
            AppSize.sizeVer(10),
            Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: profileWidget(
                            imageUrl: "${widget.currentUser.profileUrl}",
                            image: _image,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.blue,
                        child: Material(
                          shape: const CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: selectImage,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // [TextFormField]: Name Form.
            AppSize.sizeVer(30),
            FormEditWidget(
              controller: _nameController,
              title: "Name",
            ),

            // [TextFormField]: NPM Form.
            AppSize.sizeVer(20),
            FormEditWidget(
              controller: _npmController,
              title: "NPM",
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    try {
      final pickedFile =
          // ignore: invalid_use_of_visible_for_testing_member
          await ImagePicker.platform
              .getImageFromSource(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          debugPrint("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured");
    }
  }

  void _updateUserProfileData() {
    setState(() => _isUpdating = true);

    if (_image == null) {
      _updateUserProfile("");
    } else {
      di
          .sl<UploadImageToStorageUseCase>()
          .call(_image!, false, "profileImages")
          .then((profileUrl) {
        _updateUserProfile(profileUrl);
      });
    }
  }

  void _updateUserProfile(String profileUrl) {
    BlocProvider.of<UserCubit>(context)
        .updateUser(
      userEntity: UserEntity(
        uid: widget.currentUser.uid,
        name: _nameController!.text,
        npm: _npmController!.text,
        profileUrl: profileUrl,
      ),
    )
        .then(
      (_) {
        setState(() {
          _isUpdating = false;
          _nameController!.clear();
          _npmController!.clear();
        });
        Navigator.pop(context);
      },
    );
  }
}
