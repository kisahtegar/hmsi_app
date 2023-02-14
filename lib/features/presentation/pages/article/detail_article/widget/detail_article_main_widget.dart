import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../../const.dart';
import '../../../../../../injection_container.dart' as di;
import '../../../../../domain/entities/app_entity.dart';
import '../../../../../domain/entities/article/article_entity.dart';
import '../../../../../domain/usecases/user/get_current_uid_usecase.dart';
import '../../../../cubits/article/article_cubit.dart';
import '../../../../cubits/article/get_single_article/get_single_article_cubit.dart';
import '../../../../cubits/comment/comment_cubit.dart';
import '../../../../cubits/reply/reply_cubit.dart';
import '../../../../cubits/user/get_single_user/get_single_user_cubit.dart';
import '../../../../widgets/image_box_widget.dart';
import '../../../../widgets/more_menu_button_widget.dart';
import '../comment/widget/comment_bottom_sheet_widget.dart';

class DetailArticleMainWidget extends StatefulWidget {
  final String articleId;
  const DetailArticleMainWidget({super.key, required this.articleId});

  @override
  State<DetailArticleMainWidget> createState() =>
      _DetailArticleMainWidgetState();
}

class _DetailArticleMainWidgetState extends State<DetailArticleMainWidget> {
  String _currentUid = "";

  @override
  void initState() {
    BlocProvider.of<GetSingleArticleCubit>(context)
        .getSingleAricle(articleId: widget.articleId);
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      if (mounted) {
        setState(() {
          _currentUid = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("DetailArticlePage[build]: Building!!");
    Size size = MediaQuery.of(context).size;
    BuildContext mainContext = context;
    return BlocBuilder<GetSingleArticleCubit, GetSingleArticleState>(
      builder: (context, singleArticleState) {
        if (singleArticleState is GetSingleArticleLoaded) {
          final singleArticle = singleArticleState.article;
          return _bodyWidget(mainContext, singleArticle, size);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _bodyWidget(
      BuildContext mainContext, ArticleEntity singleArticle, Size size) {
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
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: (_) {
                            return MultiBlocProvider(
                              providers: [
                                BlocProvider<ReplyCubit>(
                                  create: (context) => di.sl<ReplyCubit>(),
                                ),
                                BlocProvider<CommentCubit>(
                                  create: (context) => di.sl<CommentCubit>(),
                                ),
                                BlocProvider<GetSingleUserCubit>(
                                  create: (context) =>
                                      di.sl<GetSingleUserCubit>(),
                                ),
                              ],
                              child: CommentBottomSheet(
                                context: mainContext,
                                appEntity: AppEntity(
                                  uid: _currentUid,
                                  articleId: singleArticle.articleId,
                                ),
                              ),
                            );
                          },
                        );
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
                                  // SizedBox(
                                  //   width: 30,
                                  //   height: 30,
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(15),
                                  //     child: profileWidget(
                                  //       imageUrl: widget.articleId
                                  //     ),
                                  //   ),
                                  // ),
                                  // AppSize.sizeHor(10),
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white54,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 10,
                                        ),
                                        child: Text(
                                          "Add comments",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: AppColor.primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
                onTap: () {
                  _deleteArticle(articleEntity: article);
                },
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

  _deleteArticle({required ArticleEntity articleEntity}) {
    Navigator.pop(context);
    BlocProvider.of<ArticleCubit>(context)
        .deleteArticle(
          articleEntity: ArticleEntity(
            articleId: widget.articleId,
            creatorUid: articleEntity.creatorUid,
          ),
        )
        .then((_) => Navigator.pop(context));
  }
}
