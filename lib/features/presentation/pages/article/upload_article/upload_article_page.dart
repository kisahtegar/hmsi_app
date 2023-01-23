import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../injection_container.dart' as di;
import '../../../../domain/entities/user/user_entity.dart';
import '../../../cubits/article/article_cubit.dart';
import 'widget/upload_article_main_widget.dart';

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
