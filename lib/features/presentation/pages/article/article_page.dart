import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../const.dart';
import '../../../../injection_container.dart' as di;
import '../../../domain/entities/article/article_entity.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../cubits/article/article_cubit.dart';
import 'widget/single_article_widget.dart';

class ArticlePage extends StatelessWidget {
  final UserEntity currentUser;

  const ArticlePage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    debugPrint("ArticlePage[build]: Building!!");

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
          currentUser.role == "admin"
              ? Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PageConst.uploadArticlePage,
                        arguments: currentUser,
                      );
                    },
                    child: Icon(Icons.create, color: AppColor.primaryColor),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      body: BlocProvider<ArticleCubit>(
        create: (context) => di.sl<ArticleCubit>()
          ..getArticles(articleEntity: const ArticleEntity()),
        child: BlocBuilder<ArticleCubit, ArticleState>(
          builder: (context, articleState) {
            if (articleState is ArticleLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ));
            }
            if (articleState is ArticleFailure) {
              toast("Some failure occured while creating the article");
            }
            if (articleState is ArticleLoaded) {
              return articleState.articles.isEmpty
                  ? _noPostWidget()
                  : ListView.builder(
                      itemCount: articleState.articles.length,
                      itemBuilder: (context, index) {
                        final article = articleState.articles[index];
                        return SingleArticleWidget(articleEntity: article);
                        // return BlocProvider(
                        //   create: (context) => di.sl<ArticleCubit>(),
                        //   child: SingleArticleWidget(articleEntity: article),
                        // );
                      },
                    );
            }
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          },
        ),
      ),
    );
  }

  Widget _noPostWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.yellow.shade200,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FontAwesomeIcons.newspaper,
              color: Colors.black,
              size: 150,
            ),
          ),
          AppSize.sizeVer(25),
          const Text(
            "No Article Yet!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              // color: ,
            ),
          ),
          AppSize.sizeVer(15),
          const Text(
            "There is no article at this time, \nplease come back later.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
