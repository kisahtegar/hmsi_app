import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmsi_app/features/domain/entities/app_entity.dart';
import 'package:hmsi_app/features/domain/entities/article/article_entity.dart';
import 'package:hmsi_app/features/domain/entities/user/user_entity.dart';
import 'package:hmsi_app/features/presentation/cubits/article/article_cubit.dart';
import 'package:hmsi_app/features/presentation/cubits/article/get_single_article/get_single_article_cubit.dart';
import 'package:hmsi_app/features/presentation/cubits/user/get_single_user/get_single_user_cubit.dart';
import 'package:hmsi_app/features/presentation/widgets/more_menu_button_widget.dart';
import 'package:intl/intl.dart';

import '../../../../../../const.dart';
import '../../../../widgets/image_box_widget.dart';

class DetailArticleMainWidget extends StatefulWidget {
  final AppEntity appEntity;
  const DetailArticleMainWidget({super.key, required this.appEntity});

  @override
  State<DetailArticleMainWidget> createState() =>
      _DetailArticleMainWidgetState();
}

class _DetailArticleMainWidgetState extends State<DetailArticleMainWidget> {
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.appEntity.uid!);
    BlocProvider.of<GetSingleArticleCubit>(context)
        .getSingleAricle(articleId: widget.appEntity.articleId!);
    super.initState();
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
              onTap: () => _showModalBottomSheet(context, singleArticle),
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
              AppSize.sizeVer(20),
              Container(
                width: double.infinity,
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: imageBoxWidget(imageUrl: singleArticle.articleImageUrl),
              ),

              // [Row]: Name, Date.
              AppSize.sizeVer(20),
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
            ],
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context, ArticleEntity article) {
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
}
