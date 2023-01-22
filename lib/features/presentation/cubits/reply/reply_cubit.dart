import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/reply/reply_entity.dart';
import '../../../domain/usecases/reply/create_reply_usecase.dart';
import '../../../domain/usecases/reply/delete_reply_usecase.dart';
import '../../../domain/usecases/reply/like_reply_usecase.dart';
import '../../../domain/usecases/reply/read_replys_usecase.dart';
import '../../../domain/usecases/reply/update_reply_usecase.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  final CreateReplyUseCase createReplyUseCase;
  final ReadReplysUseCase readReplysUseCase;
  final UpdateReplyUseCase updateReplyUseCase;
  final DeleteReplyUseCase deleteReplyUseCase;
  final LikeReplyUseCase likeReplyUseCase;

  ReplyCubit({
    required this.createReplyUseCase,
    required this.readReplysUseCase,
    required this.updateReplyUseCase,
    required this.deleteReplyUseCase,
    required this.likeReplyUseCase,
  }) : super(ReplyInitial());

  Future<void> createReply({required ReplyEntity replyEntity}) async {
    try {
      await createReplyUseCase.call(replyEntity);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> getReplys({required ReplyEntity replyEntity}) async {
    emit(ReplyLoading());
    await Future.delayed(const Duration(microseconds: 1));
    try {
      final streamResponse = readReplysUseCase.call(replyEntity);
      streamResponse.listen((replys) async {
        debugPrint("ReplyCubit[getReplys]: emit(ReplyLoaded())");
        await Future.delayed(const Duration(milliseconds: 1));
        if (isClosed) return;
        emit(ReplyLoaded(replys: replys));
      });
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> updateReply({required ReplyEntity replyEntity}) async {
    try {
      await updateReplyUseCase.call(replyEntity);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> deleteReply({required ReplyEntity replyEntity}) async {
    try {
      await deleteReplyUseCase.call(replyEntity);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> likeReply({required ReplyEntity replyEntity}) async {
    try {
      await likeReplyUseCase.call(replyEntity);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }
}
