part of 'get_single_event_cubit.dart';

abstract class GetSingleEventState extends Equatable {
  const GetSingleEventState();

  @override
  List<Object> get props => [];
}

class GetSingleEventInitial extends GetSingleEventState {}

class GetSingleEventLoading extends GetSingleEventState {}

class GetSingleEventLoaded extends GetSingleEventState {
  final EventEntity event;
  const GetSingleEventLoaded({required this.event});

  @override
  List<Object> get props => [event];
}

class GetSingleEventFailure extends GetSingleEventState {}
