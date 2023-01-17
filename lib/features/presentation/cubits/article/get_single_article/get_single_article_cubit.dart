import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hmsi_app/features/domain/entities/article/article_entity.dart';
import 'package:hmsi_app/features/domain/usecases/article/read_single_article_usecase.dart';

part 'get_single_article_state.dart';

class GetSingleArticleCubit extends Cubit<GetSingleArticleState> {
  final ReadSingleArticleUseCase readSingleArticleUseCase;

  GetSingleArticleCubit({required this.readSingleArticleUseCase})
      : super(GetSingleArticleInitial());

  Future<void> getSingleAricle({required String articleId}) async {
    emit(GetSingleArticleLoading());
    try {
      final streamResponse = readSingleArticleUseCase.call(articleId);
      streamResponse.listen(
        (articles) {
          emit(GetSingleArticleLoaded(article: articles.first));
        },
        onError: (e, s) {
          debugPrint(
              "ArticleCubit[getArticles]: Error while listen to streamResponse");
          return;
        },
      );
    } on SocketException catch (_) {
      emit(GetSingleArticleFailure());
    } catch (_) {
      emit(GetSingleArticleFailure());
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
