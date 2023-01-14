import 'package:flutter/material.dart';
import 'package:hmsi_app/features/domain/entities/article/article_entity.dart';
import 'package:hmsi_app/features/presentation/widgets/image_box_widget.dart';
import 'package:hmsi_app/features/presentation/widgets/profile_widget.dart';

import '../../../../../const.dart';

class SingleArticleWidget extends StatelessWidget {
  // final Size size;
  // final String name;
  final ArticleEntity articleEntity;

  const SingleArticleWidget({
    Key? key,
    required this.articleEntity,
  }) : super(key: key);

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
              // Image
              Container(
                width: double.infinity,
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: imageBoxWidget(imageUrl: articleEntity.articleImageUrl),
              ),
              AppSize.sizeVer(10),
              // Title
              Text(
                articleEntity.title!.length > 63
                    ? "${articleEntity.title!.substring(0, 63)}..."
                    : articleEntity.title!,
                style: AppTextStyle.kTitleTextStyle.copyWith(fontSize: 19),
              ),
              AppSize.sizeVer(10),
              // User Tag
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
                                imageUrl: articleEntity.userProfileUrl),
                          ),
                        ),
                        AppSize.sizeHor(8),
                        Text(
                          articleEntity.username!,
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
              AppSize.sizeVer(10),
            ],
          ),
        ),
      ),
    );
  }
}
