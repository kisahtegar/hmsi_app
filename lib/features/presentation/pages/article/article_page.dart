import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hmsi_app/features/presentation/widgets/no_page_widget.dart';

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
              return loadingIndicator();
            }
            if (articleState is ArticleFailure) {
              toast("Some failure occured while creating the article");
            }
            if (articleState is ArticleLoaded) {
              return articleState.articles.isEmpty
                  ? noPageWidget(
                      icon: FontAwesomeIcons.newspaper,
                      title: "No Article Yet!",
                      titleSize: 23,
                      description:
                          "There is no article at this time,\nplease comeback later",
                      descriptionSize: 15,
                    )
                  : ListView.builder(
                      itemCount: articleState.articles.length,
                      itemBuilder: (context, index) {
                        final article = articleState.articles[index];
                        return SingleArticleWidget(articleEntity: article);
                      },
                    );
            }
            return loadingIndicator();
          },
        ),
      ),
    );
  }
}
