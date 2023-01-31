import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/event/event_entity.dart';
import '../../../../domain/usecases/event/read_single_event_usecase.dart';

part 'get_single_event_state.dart';

class GetSingleEventCubit extends Cubit<GetSingleEventState> {
  final ReadSingleEventUseCase readSingleEventUseCase;

  StreamSubscription<List<EventEntity>>? sub;

  GetSingleEventCubit({required this.readSingleEventUseCase})
      : super(GetSingleEventInitial());

  Future<void> getSingleEvent({required String eventId}) async {
    emit(GetSingleEventLoading());
    try {
      final streamResponse = readSingleEventUseCase.call(eventId);
      await sub?.cancel();
      sub = streamResponse.listen((events) async {
        debugPrint(
            "GetSingleEventCubit[getSingleEvent]: emit(GetSingleEventLoaded())");
        await Future.delayed(const Duration(milliseconds: 1));
        if (isClosed) return;
        emit(GetSingleEventLoaded(event: events.first));
      });
    } on SocketException catch (_) {
      emit(GetSingleEventFailure());
    } catch (_) {
      emit(GetSingleEventFailure());
    }
  }

  @override
  Future<void> close() async {
    await sub?.cancel();
    return super.close();
  }
}
