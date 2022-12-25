part of 'get_single_other_user_cubit.dart';

abstract class GetSingleOtherUserState extends Equatable {
  const GetSingleOtherUserState();

  @override
  List<Object> get props => [];
}

class GetSingleOtherUserInitial extends GetSingleOtherUserState {}

class GetSingleOtherUserLoading extends GetSingleOtherUserState {}

class GetSingleOtherUserLoaded extends GetSingleOtherUserState {
  final UserEntity otherUser;

  const GetSingleOtherUserLoaded({required this.otherUser});

  @override
  List<Object> get props => [otherUser];
}

class GetSingleOtherUserFailure extends GetSingleOtherUserState {}
