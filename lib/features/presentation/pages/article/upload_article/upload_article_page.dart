import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hmsi_app/features/presentation/cubits/article/article_cubit.dart';
import 'package:hmsi_app/features/presentation/pages/article/upload_article/widget/upload_article_main_widget.dart';

import '../../../../domain/entities/user/user_entity.dart';
import 'package:hmsi_app/injection_container.dart' as di;

class UploadArticlePage extends StatelessWidget {
  final UserEntity currentUser;
  const UploadArticlePage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArticleCubit>(
      create: (context) => di.sl<ArticleCubit>(),
      child: UploadArticleMainWidget(currentUser: currentUser),
    );
  }
}
