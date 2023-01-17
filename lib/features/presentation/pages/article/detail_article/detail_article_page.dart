import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmsi_app/features/presentation/cubits/article/article_cubit.dart';
import 'package:hmsi_app/features/presentation/cubits/user/get_single_user/get_single_user_cubit.dart';
import 'package:hmsi_app/features/presentation/pages/article/detail_article/widget/detail_article_main_widget.dart';

import '../../../../domain/entities/app_entity.dart';
import 'package:hmsi_app/injection_container.dart' as di;

import '../../../cubits/article/get_single_article/get_single_article_cubit.dart';

class DetailArticlePage extends StatelessWidget {
  final AppEntity appEntity;
  const DetailArticlePage({super.key, required this.appEntity});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetSingleUserCubit>(
          create: (context) => di.sl<GetSingleUserCubit>(),
        ),
        BlocProvider<GetSingleArticleCubit>(
          create: (context) => di.sl<GetSingleArticleCubit>(),
        ),
        BlocProvider<ArticleCubit>(
          create: (context) => di.sl<ArticleCubit>(),
        ),
      ],
      child: DetailArticleMainWidget(appEntity: appEntity),
    );
  }
}
