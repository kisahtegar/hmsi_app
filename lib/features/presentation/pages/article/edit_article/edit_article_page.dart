import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmsi_app/features/presentation/cubits/article/article_cubit.dart';
import 'package:hmsi_app/features/presentation/pages/article/edit_article/widget/edit_article_main_widget.dart';

import 'package:hmsi_app/injection_container.dart' as di;
import '../../../../domain/entities/article/article_entity.dart';

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
