import 'package:flutter/material.dart';

import '../../../../../const.dart';

class SingleArticleWidget extends StatelessWidget {
  const SingleArticleWidget({
    Key? key,
    required this.size,
    required this.name,
  }) : super(key: key);

  final Size size;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(28, 158, 158, 158),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: double.infinity,
              height: size.height * 0.25,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            AppSize.sizeVer(10),
            // Title
            Text(
              name.length > 63 ? "${name.substring(0, 63)}..." : name,
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
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      AppSize.sizeHor(8),
                      Text(
                        "username",
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
    );
  }
}
