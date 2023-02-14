import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../const.dart';
import '../../../../../../injection_container.dart' as di;
import '../../../../../domain/entities/article/article_entity.dart';
import '../../../../../domain/usecases/user/upload_image_to_storage_usecase.dart';
import '../../../../cubits/article/article_cubit.dart';
import '../../../../widgets/image_box_widget.dart';
import '../../../profile/widget/form_edit_widget.dart';

class EditArticleMainWidget extends StatefulWidget {
  final ArticleEntity article;
  const EditArticleMainWidget({super.key, required this.article});

  @override
  State<EditArticleMainWidget> createState() => _EditArticleMainWidgetState();
}

class _EditArticleMainWidgetState extends State<EditArticleMainWidget> {
  bool _isUpdating = false;
  TextEditingController? _titleController;
  TextEditingController? _descriptionController;
  final _formKey = GlobalKey<FormState>();
  File? _image;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.article.title);
    _descriptionController =
        TextEditingController(text: widget.article.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.backGroundColor,
        title: Text(
          "Edit Article",
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
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        _updateArticle();
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
                            child: imageBoxWidget(
                              image: _image,
                              imageUrl: widget.article.articleImageUrl,
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
                  title: "Description",
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
    );
  }

  // Select Image method
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

  // Updating article method
  void _updateArticle() {
    setState(() => _isUpdating = true);

    if (_image == null) {
      _createUpdateArticle("");
    } else {
      di
          .sl<UploadImageToStorageUseCase>()
          .call(_image!, false, "articleImages")
          .then((imageUrl) {
        _createUpdateArticle(imageUrl);
      });
    }
  }

  // This will create update article.
  void _createUpdateArticle(String articleImageUrl) {
    BlocProvider.of<ArticleCubit>(context)
        .updateArticle(
      articleEntity: ArticleEntity(
        articleId: widget.article.articleId,
        articleImageUrl: articleImageUrl,
        title: _titleController!.text,
        description: _descriptionController!.text,
      ),
    )
        .then((_) {
      setState(() {
        _isUpdating = false;
        _titleController!.clear();
        _descriptionController!.clear();
        _image = null;
      });
      Navigator.pop(context);
    });
  }
}
