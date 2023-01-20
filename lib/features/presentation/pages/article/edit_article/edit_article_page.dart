import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart' as di;
import '../../../../domain/entities/article/article_entity.dart';
import '../../../cubits/article/article_cubit.dart';
import 'widget/edit_article_main_widget.dart';

class EditArticlePage extends StatelessWidget {
  final ArticleEntity article;
  const EditArticlePage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArticleCubit>.value(
      value: di.sl<ArticleCubit>(),
      child: EditArticleMainWidget(article: article),
    );
    // return BlocProvider<ArticleCubit>(
    //   create: (context) => di.sl<ArticleCubit>(),
    //   child: EditArticleMainWidget(article: article),
    // );
  }
}
