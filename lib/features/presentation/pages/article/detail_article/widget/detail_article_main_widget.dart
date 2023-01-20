import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../const.dart';
import '../../../../../domain/entities/app_entity.dart';
import '../../../../../domain/entities/article/article_entity.dart';
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../cubits/article/article_cubit.dart';
import '../../../../cubits/article/get_single_article/get_single_article_cubit.dart';
import '../../../../cubits/user/get_single_user/get_single_user_cubit.dart';
import '../../../../widgets/image_box_widget.dart';
import '../../../../widgets/more_menu_button_widget.dart';
import '../../../../widgets/profile_widget.dart';

class DetailArticleMainWidget extends StatefulWidget {
  final AppEntity appEntity;
  const DetailArticleMainWidget({super.key, required this.appEntity});

  @override
  State<DetailArticleMainWidget> createState() =>
      _DetailArticleMainWidgetState();
}

class _DetailArticleMainWidgetState extends State<DetailArticleMainWidget> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.appEntity.uid!);
    BlocProvider.of<GetSingleArticleCubit>(context)
        .getSingleAricle(articleId: widget.appEntity.articleId!);
    _commentController.addListener(changesOnField);
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("DetailArticlePage[build]: Building!!");
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, singleUserState) {
        if (singleUserState is GetSingleUserLoaded) {
          final singleUser = singleUserState.user;
          return BlocBuilder<GetSingleArticleCubit, GetSingleArticleState>(
            builder: (context, singleArticleState) {
              if (singleArticleState is GetSingleArticleLoaded) {
                final singleArticle = singleArticleState.article;
                return _bodyWidget(singleUser, singleArticle, size);
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _bodyWidget(
      UserEntity singleUser, ArticleEntity singleArticle, Size size) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, size: 32, color: AppColor.primaryColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () => _showModalBottomSheetOptions(context, singleArticle),
              child: Icon(
                Icons.more_vert,
                color: AppColor.primaryColor,
                size: 32,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // [Text]: Title.
              Text(
                // NOTE: Max String length 125
                "${singleArticle.title}",
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),

              // [Container]: Picture.
              AppSize.sizeVer(22),
              Container(
                width: double.infinity,
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(5, 10),
                      blurRadius: 10,
                      color: AppColor.gradientSecond.withOpacity(0.3),
                    ),
                  ],
                ),
                child: imageBoxWidget(imageUrl: singleArticle.articleImageUrl),
              ),

              // [Row]: Name, Date.
              AppSize.sizeVer(22),
              Row(
                children: [
                  // Name
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.amber, width: 2.0),
                      ),
                    ),
                    child: Text(
                      "${singleArticle.name}",
                      style: AppTextStyle.kTitleTextStyle.copyWith(
                        fontSize: 15,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Date
                  Text(
                    DateFormat("dd/MMM/yyy")
                        .format(singleArticle.createAt!.toDate()),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),

              // [Text]: Description
              AppSize.sizeVer(10),
              Text(
                "${singleArticle.description}",
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                  // fontStyle: FontStyle.italic,
                ),
              ),

              // [Container]: Comment.
              AppSize.sizeVer(30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(5, 10),
                      blurRadius: 10,
                      color: AppColor.gradientSecond.withOpacity(0.3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        _showModalBottomSheetComments(context);
                      },
                      child: Ink(
                        width: double.infinity,
                        color: Colors.amber,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Comment",
                                    style: TextStyle(
                                      color: AppColor.primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.redo_sharp,
                                  ),
                                ],
                              ),
                              AppSize.sizeVer(10),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: profileWidget(),
                                    ),
                                  ),
                                  AppSize.sizeHor(10),
                                  Flexible(
                                    child: Text(
                                      // TODO: Length max 90
                                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
                                      style: TextStyle(
                                        color: AppColor.primaryColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              AppSize.sizeVer(10),
                            ],
                          ),
                        ),
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

  changesOnField() {
    setState(() {}); // Will re-Trigger Build Method
  }

  void _showModalBottomSheetOptions(
      BuildContext context, ArticleEntity article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Wrap(children: [
          Column(
            children: [
              AppSize.sizeVer(15),
              Text(
                "More Options",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColor.primaryColor,
                ),
              ),
              AppSize.sizeVer(9),
              const Divider(thickness: 1),
              MoreMenuButtonWidget(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    PageConst.editArticlePage,
                    arguments: article,
                  );
                },
                icon: Icons.edit,
                text: "Edit Article",
                iconColor: AppColor.primaryColor,
                textColor: AppColor.primaryColor,
              ),
              MoreMenuButtonWidget(
                onTap: _deleteArticle,
                icon: Icons.delete,
                text: "Delete Article",
                iconColor: Colors.red,
                textColor: Colors.red,
              ),
            ],
          ),
        ]);
      },
    );
  }

  _deleteArticle() {
    Navigator.pop(context);
    BlocProvider.of<ArticleCubit>(context)
        .deleteArticle(
          articleEntity: ArticleEntity(
            articleId: widget.appEntity.articleId,
            creatorUid: widget.appEntity.creatorUid,
          ),
        )
        .then((_) => Navigator.pop(context));
  }

  void _showModalBottomSheetComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // [Row]: Comment title and close comment.
                AppSize.sizeVer(15),
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                AppSize.sizeVer(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Comment",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close,
                          size: 28,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSize.sizeVer(9),
                const Divider(thickness: 1),

                // [List]: Comment output.
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: profileWidget(),
                          ),
                        ),
                        AppSize.sizeHor(10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Username",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSize.sizeVer(2),
                              const Text(
                                // NOTE: Maximum comment length 500
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
                              ),
                              AppSize.sizeVer(8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.favorite_outline,
                                    color: Colors.grey,
                                  ),
                                  AppSize.sizeHor(5),
                                  const Text("0"),
                                  AppSize.sizeHor(20),
                                  const Icon(
                                    Icons.comment_outlined,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        AppSize.sizeHor(10),
                        const Icon(Icons.more_vert),
                      ],
                    ),
                  ),
                ),

                // [TextField]: Comment form.
                const Divider(thickness: 1, height: 0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 35,
                        height: 35,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: profileWidget(),
                        ),
                      ),
                      AppSize.sizeHor(15),
                      Expanded(
                        child: TextFormField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: "Add comments",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      _commentController.text.isNotEmpty
                          ? InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.send,
                                color: Colors.blue,
                              ),
                            )
                          : const SizedBox(),
                    ],
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
