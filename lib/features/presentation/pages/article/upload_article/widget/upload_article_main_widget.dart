import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../const.dart';
import '../../../../../../injection_container.dart' as di;
import '../../../../../domain/entities/article/article_entity.dart';
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../../domain/usecases/user/upload_image_to_storage_usecase.dart';
import '../../../../cubits/article/article_cubit.dart';
import '../../../../widgets/image_box_widget.dart';
import '../../../profile/widget/form_edit_widget.dart';

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
                    maxLength: 125,
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
                    autofocus: true,
                    focusNode: _focusNode,
                    title: "Description",
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
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
          .call(_image!, false, "articleImages")
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
        name: widget.currentUser.name,
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

  void handleKeyPress(event) {
    if (event is RawKeyUpEvent && event.data is RawKeyEventDataWeb) {
      var data = event.data as RawKeyEventDataWeb;
      if (data.code == "Enter" && !event.isShiftPressed) {
        final val = _descriptionController.value;
        final messageWithoutNewLine =
            _descriptionController.text.substring(0, val.selection.start - 1) +
                _descriptionController.text.substring(val.selection.start);
        _descriptionController.value = TextEditingValue(
          text: messageWithoutNewLine,
          selection: TextSelection.fromPosition(
            TextPosition(offset: messageWithoutNewLine.length),
          ),
        );
        // _onSend();
      }
    }
  }

  late final _focusNode = FocusNode(
    onKey: _handleKeyPress,
  );

  KeyEventResult _handleKeyPress(FocusNode focusNode, RawKeyEvent event) {
    // handles submit on enter
    if (event.isKeyPressed(LogicalKeyboardKey.enter) && !event.isShiftPressed) {
      _sendMessage();
      // handled means that the event will not propagate
      return KeyEventResult.handled;
    }
    // ignore every other keyboard event including SHIFT+ENTER
    return KeyEventResult.ignored;
  }

  void _sendMessage() {
    if (_descriptionController.text.trim().isNotEmpty) {
      // bring focus back to the input field
      Future.delayed(Duration.zero, () {
        _focusNode.requestFocus();
        _descriptionController.clear();
      });
    }
  }
}
