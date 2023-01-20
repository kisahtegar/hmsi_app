part of 'reply_cubit.dart';

abstract class ReplyState extends Equatable {
  const ReplyState();

  @override
  List<Object> get props => [];
}

class ReplyInitial extends ReplyState {
  @override
  List<Object> get props => [];
}

class ReplyLoading extends ReplyState {
  @override
  List<Object> get props => [];
}

class ReplyLoaded extends ReplyState {
  final List<ReplyEntity> replys;

  const ReplyLoaded({required this.replys});

  @override
  List<Object> get props => [replys];
}

class ReplyFailure extends ReplyState {
  @override
  List<Object> get props => [];
}
