import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/event/event_entity.dart';
import '../../../domain/usecases/event/create_event_usecase.dart';
import '../../../domain/usecases/event/delete_event_usecase.dart';
import '../../../domain/usecases/event/read_events_usecase.dart';
import '../../../domain/usecases/event/update_event_usecase.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final CreateEventUseCase createEventUseCase;
  final ReadEventsUseCase readEventsUseCase;
  final UpdateEventUseCase updateEventUseCase;
  final DeleteEventUseCase deleteEventUseCase;

  StreamSubscription<List<EventEntity>>? sub;

  EventCubit({
    required this.createEventUseCase,
    required this.readEventsUseCase,
    required this.updateEventUseCase,
    required this.deleteEventUseCase,
  }) : super(EventInitial());

  Future<void> createEvent({required EventEntity eventEntity}) async {
    try {
      await createEventUseCase.call(eventEntity);
    } on SocketException catch (_) {
      emit(EventFailure());
    } catch (_) {
      emit(EventFailure());
    }
  }

  Future<void> getEvents({required EventEntity eventEntity}) async {
    emit(EventLoading());
    try {
      final streamResponse = readEventsUseCase.call(eventEntity);
      await sub?.cancel();
      sub = streamResponse.listen((events) async {
        debugPrint("EventCubit[getEvents]: emit(EventLoaded())");
        await Future.delayed(const Duration(milliseconds: 1));
        if (isClosed) return;
        emit(EventLoaded(events: events));
      });
    } on SocketException catch (_) {
      emit(EventFailure());
    } catch (_) {
      emit(EventFailure());
    }
  }

  Future<void> updateEvent({required EventEntity eventEntity}) async {
    try {
      await updateEventUseCase.call(eventEntity);
    } on SocketException catch (_) {
      emit(EventFailure());
    } catch (_) {
      emit(EventFailure());
    }
  }

  Future<void> deleteEvent({required EventEntity eventEntity}) async {
    try {
      await deleteEventUseCase.call(eventEntity);
    } on SocketException catch (_) {
      emit(EventFailure());
    } catch (_) {
      emit(EventFailure());
    }
  }

  @override
  Future<void> close() async {
    await sub?.cancel();
    return super.close();
  }
}
