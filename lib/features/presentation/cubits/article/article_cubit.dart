import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hmsi_app/features/domain/entities/article/article_entity.dart';
import 'package:hmsi_app/features/domain/usecases/article/create_article_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/article/delete_article_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/article/like_article_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/article/read_articles_usecase.dart';
import 'package:hmsi_app/features/domain/usecases/article/update_article_usecase.dart';

part 'article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  final CreateArticleUseCase createArticleUseCase;
  final ReadArticlesUseCase readArticlesUseCase;
  final UpdateArticleUseCase updateArticleUseCase;
  final DeleteArticleUseCase deleteArticleUseCase;
  final LikeArticleUseCase likeArticleUseCase;

  ArticleCubit({
    required this.createArticleUseCase,
    required this.readArticlesUseCase,
    required this.updateArticleUseCase,
    required this.deleteArticleUseCase,
    required this.likeArticleUseCase,
  }) : super(ArticleInitial());

  Future<void> createArticle({required ArticleEntity articleEntity}) async {
    try {
      await createArticleUseCase.call(articleEntity);
    } on SocketException catch (_) {
      emit(ArticleFailure());
    } catch (_) {
      emit(ArticleFailure());
    }
  }

  Future<void> getArticles({required ArticleEntity articleEntity}) async {
    emit(ArticleLoading());
    try {
      final streamResponse = readArticlesUseCase.call(articleEntity);
      streamResponse.listen((articles) {
        emit(ArticleLoaded(articles: articles));
      });
    } on SocketException catch (_) {
      emit(ArticleFailure());
    } catch (_) {
      emit(ArticleFailure());
    }
  }

  Future<void> updateArticle({required ArticleEntity articleEntity}) async {
    try {
      await updateArticleUseCase.call(articleEntity);
    } on SocketException catch (_) {
      emit(ArticleFailure());
    } catch (_) {
      emit(ArticleFailure());
    }
  }

  Future<void> deleteArticle({required ArticleEntity articleEntity}) async {
    try {
      await deleteArticleUseCase.call(articleEntity);
    } on SocketException catch (_) {
      emit(ArticleFailure());
    } catch (_) {
      emit(ArticleFailure());
    }
  }

  Future<void> likeArticle({required ArticleEntity articleEntity}) async {
    try {
      await likeArticleUseCase.call(articleEntity);
    } on SocketException catch (_) {
      emit(ArticleFailure());
    } catch (_) {
      emit(ArticleFailure());
    }
  }
}
