import 'package:flutter/material.dart';

import '../../../../const.dart';
import 'widget/single_article_widget.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("ArticlePage[build]: Building!!");
    Size size = MediaQuery.of(context).size;
    String name =
        "Title Lorem ipsum dolor sit amet, consectetur adipiscing elits wkwkwk";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Article",
          style: TextStyle(color: AppColor.primaryColor, fontSize: 25),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {},
              child: Icon(Icons.create, color: AppColor.primaryColor),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              SingleArticleWidget(size: size, name: name),
              AppSize.sizeVer(20),
              SingleArticleWidget(size: size, name: name),
            ],
          ),
        ),
      ),
    );
  }
}
