import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmsi_app/features/domain/entities/article/article_entity.dart';
import 'package:hmsi_app/features/domain/entities/user/user_entity.dart';
import 'package:hmsi_app/features/presentation/cubits/article/article_cubit.dart';

import '../../../../const.dart';
import 'widget/single_article_widget.dart';
import 'package:hmsi_app/injection_container.dart' as di;

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
          Padding(
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
          ),
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
                  ? _noPostsWidget()
                  : ListView.builder(
                      itemCount: articleState.articles.length,
                      itemBuilder: (context, index) {
                        final article = articleState.articles[index];
                        return BlocProvider(
                          create: (context) => di.sl<ArticleCubit>(),
                          child: SingleArticleWidget(articleEntity: article),
                        );
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

  Center _noPostsWidget() {
    return Center(
      child: Text(
        "No Posts",
        style: TextStyle(
          color: AppColor.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}