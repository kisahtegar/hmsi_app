import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/comment/comment_entity.dart';
import '../../../domain/usecases/comment/create_comment_usecase.dart';
import '../../../domain/usecases/comment/delete_comment_usecase.dart';
import '../../../domain/usecases/comment/like_comment_usecase.dart';
import '../../../domain/usecases/comment/read_comments_usecase.dart';
import '../../../domain/usecases/comment/update_comment_usecase.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CreateCommentUseCase createCommentUseCase;
  final ReadCommentsUseCase readCommentsUseCase;
  final UpdateCommentUseCase updateCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;
  final LikeCommentUseCase likeCommentUseCase;

  CommentCubit({
    required this.createCommentUseCase,
    required this.readCommentsUseCase,
    required this.updateCommentUseCase,
    required this.deleteCommentUseCase,
    required this.likeCommentUseCase,
  }) : super(CommentInitial());

  Future<void> createComment({required CommentEntity commentEntity}) async {
    try {
      await createCommentUseCase.call(commentEntity);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> getComments({required String articleId}) async {
    emit(CommentLoading());
    try {
      final streamResponse = readCommentsUseCase.call(articleId);
      streamResponse.listen((comments) {
        emit(CommentLoaded(comments: comments));
      });
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> updateComment({required CommentEntity commentEntity}) async {
    try {
      await updateCommentUseCase.call(commentEntity);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> deleteComment({required CommentEntity commentEntity}) async {
    try {
      await deleteCommentUseCase.call(commentEntity);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> likeComment({required CommentEntity commentEntity}) async {
    try {
      await likeCommentUseCase.call(commentEntity);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }
}
