import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/article/article_entity.dart';
import '../../../../domain/usecases/article/read_single_article_usecase.dart';

part 'get_single_article_state.dart';

class GetSingleArticleCubit extends Cubit<GetSingleArticleState> {
  final ReadSingleArticleUseCase readSingleArticleUseCase;

  StreamSubscription<List<ArticleEntity>>? sub;

  GetSingleArticleCubit({required this.readSingleArticleUseCase})
      : super(GetSingleArticleInitial());

  Future<void> getSingleAricle({required String articleId}) async {
    emit(GetSingleArticleLoading());
    try {
      final streamResponse = readSingleArticleUseCase.call(articleId);
      // streamResponse.listen((articles) async {
      //   debugPrint(
      //       "GetSingleArticleCubit[getSingleAricle]: emit(GetSingleArticleLoaded())");
      //   await Future.delayed(const Duration(milliseconds: 1));
      //   if (isClosed) return;
      //   emit(GetSingleArticleLoaded(article: articles.first));
      // });

      await sub?.cancel();
      sub = streamResponse.listen((articles) async {
        debugPrint(
            "GetSingleArticleCubit[getSingleAricle]: emit(GetSingleArticleLoaded())");
        await Future.delayed(const Duration(milliseconds: 1));
        if (isClosed) return;
        emit(GetSingleArticleLoaded(article: articles.first));
      });
    } on SocketException catch (_) {
      emit(GetSingleArticleFailure());
    } catch (_) {
      emit(GetSingleArticleFailure());
    }
  }

  @override
  Future<void> close() async {
    await sub?.cancel();
    return super.close();
  }
}
