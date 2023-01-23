import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart' as di;
import '../../../cubits/article/article_cubit.dart';
import '../../../cubits/article/get_single_article/get_single_article_cubit.dart';
import 'widget/detail_article_main_widget.dart';

class DetailArticlePage extends StatelessWidget {
  final String articleId;
  const DetailArticlePage({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetSingleArticleCubit>(
          create: (context) => di.sl<GetSingleArticleCubit>(),
        ),
        BlocProvider<ArticleCubit>(
          create: (context) => di.sl<ArticleCubit>(),
        ),
        // BlocProvider<GetSingleArticleCubit>.value(
        //   value: di.sl<GetSingleArticleCubit>(),
        // ),
        // BlocProvider<ArticleCubit>.value(
        //   value: di.sl<ArticleCubit>(),
        // ),
      ],
      child: DetailArticleMainWidget(articleId: articleId),
    );
  }
}
