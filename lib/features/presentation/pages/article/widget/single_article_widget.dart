import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../const.dart';
import '../../../../../injection_container.dart' as di;
import '../../../../domain/entities/app_entity.dart';
import '../../../../domain/entities/article/article_entity.dart';
import '../../../../domain/usecases/user/get_current_uid_usecase.dart';
import '../../../cubits/article/article_cubit.dart';
import '../../../widgets/image_box_widget.dart';
import '../../../widgets/profile_widget.dart';

class SingleArticleWidget extends StatefulWidget {
  final ArticleEntity articleEntity;

  const SingleArticleWidget({
    Key? key,
    required this.articleEntity,
  }) : super(key: key);

  @override
  State<SingleArticleWidget> createState() => _SingleArticleWidgetState();
}

class _SingleArticleWidgetState extends State<SingleArticleWidget> {
  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((uid) {
      setState(() {
        _currentUid = uid;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(5, 10),
              blurRadius: 10,
              color: AppColor.gradientSecond.withOpacity(0.3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // [TopSection]: Image and title
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      PageConst.detailArticlePage,
                      arguments: AppEntity(
                        uid: _currentUid,
                        articleId: widget.articleEntity.articleId,
                        creatorUid: widget.articleEntity.creatorUid,
                      ),
                    );
                  },
                  child: Ink(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        Container(
                          width: double.infinity,
                          height: size.height * 0.25,
                          decoration: BoxDecoration(
                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: imageBoxWidget(
                              imageUrl: widget.articleEntity.articleImageUrl),
                        ),
                        AppSize.sizeVer(10),
                        // Title
                        Text(
                          widget.articleEntity.title!.length > 63
                              ? "${widget.articleEntity.title!.substring(0, 63)}..."
                              : widget.articleEntity.title!,
                          style: AppTextStyle.kTitleTextStyle
                              .copyWith(fontSize: 19),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AppSize.sizeVer(10),
              // User Tag

              // [BottomSection]: Include Usertag, like button, total like.
              Row(
                children: [
                  // [Container]: User tag
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7.0,
                        vertical: 3.0,
                      ),
                      child: FittedBox(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: profileWidget(
                                    imageUrl:
                                        widget.articleEntity.userProfileUrl),
                              ),
                            ),
                            AppSize.sizeHor(8),
                            Text(
                              widget.articleEntity.username!,
                              style: AppTextStyle.kTitleTextStyle.copyWith(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // [Text]: Total Likes.
                  Text(
                    '${widget.articleEntity.totalLikes} likes',
                    style: TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSize.sizeHor(5),
                  // [Button]: Like Button.
                  InkWell(
                    onTap: _likeArticle,
                    child: Icon(
                      widget.articleEntity.likes!.contains(_currentUid)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: widget.articleEntity.likes!.contains(_currentUid)
                          ? Colors.red
                          : AppColor.primaryColor,
                    ),
                  )
                ],
              ),
              AppSize.sizeVer(10),
            ],
          ),
        ),
      ),
    );
  }

  void _likeArticle() {
    BlocProvider.of<ArticleCubit>(context).likeArticle(
      articleEntity: ArticleEntity(
        articleId: widget.articleEntity.articleId,
      ),
    );
  }
}
