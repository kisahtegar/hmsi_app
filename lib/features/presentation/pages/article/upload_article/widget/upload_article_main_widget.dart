import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmsi_app/features/domain/entities/article/article_entity.dart';
import 'package:hmsi_app/features/domain/entities/user/user_entity.dart';
import 'package:hmsi_app/features/presentation/cubits/article/article_cubit.dart';
import 'package:hmsi_app/features/presentation/pages/profile/widget/form_edit_widget.dart';
import 'package:hmsi_app/features/presentation/widgets/image_box_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../const.dart';
import 'package:hmsi_app/injection_container.dart' as di;

import '../../../../../domain/usecases/user/upload_image_to_storage_usecase.dart';

class UploadArticleMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadArticleMainWidget({super.key, required this.currentUser});

  @override
  State<UploadArticleMainWidget> createState() =>
      _UploadArticleMainWidgetState();
}

class _UploadArticleMainWidgetState extends State<UploadArticleMainWidget> {
  File? _image;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isUploading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("UploadArticlePage[build]: Building!!");
    return BlocProvider<ArticleCubit>(
      create: (context) => di.sl<ArticleCubit>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.backGroundColor,
          title: Text(
            "Upload Article",
            style: TextStyle(color: AppColor.primaryColor),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.close, size: 32, color: AppColor.primaryColor),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: _isUploading == false
                  ? GestureDetector(
                      onTap: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          _submitArticle();
                        }
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
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // [Container]: Picture Article.
                  AppSize.sizeVer(10),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: double.infinity,
                              height: 200,
                              // color: Colors.blue,
                              child: imageBoxWidget(image: _image),
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

                  // [Text]: Title Article.
                  AppSize.sizeVer(30),
                  FormEditWidget(
                    controller: _titleController,
                    title: "Title",
                    maxLength: 80,
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),

                  // [Text]: Description Article.
                  AppSize.sizeVer(10),
                  FormEditWidget(
                    controller: _descriptionController,
                    title: "Description",
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    try {
      final pickedFile =
          // ignore: invalid_use_of_visible_for_testing_member
          await ImagePicker.platform.getImage(source: ImageSource.gallery);

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

  void _submitArticle() {
    if (_image == null) {
      toast("Image cannot be empty");
      // return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait...')),
      );
      setState(() => _isUploading = true);
      di
          .sl<UploadImageToStorageUseCase>()
          .call(_image!, false, "profileImages")
          .then((imageUrl) {
        _createSubmitArticle(image: imageUrl);
      });
    }
  }

  void _createSubmitArticle({required String image}) {
    BlocProvider.of<ArticleCubit>(context)
        .createArticle(
      articleEntity: ArticleEntity(
        articleId: const Uuid().v1(),
        creatorUid: widget.currentUser.uid,
        username: widget.currentUser.username,
        title: _titleController.text,
        description: _descriptionController.text,
        articleImageUrl: image,
        userProfileUrl: widget.currentUser.profileUrl,
        likes: const [],
        totalLikes: 0,
        totalComments: 0,
        createAt: Timestamp.now(),
      ),
    )
        .then((_) {
      setState(() {
        _isUploading = false;
        _titleController.clear();
        _descriptionController.clear();
        _image = null;
      });
      Navigator.pop(context);
    });
  }
}
