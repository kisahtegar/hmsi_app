import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/usecases/user/get_users_usecase.dart';
import '../../../domain/usecases/user/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUsersUseCase getUsersUseCase;
  final UpdateUserUseCase updateUserUseCase;

  UserCubit({
    required this.getUsersUseCase,
    required this.updateUserUseCase,
  }) : super(UserInitial());

  Future<void> getUsers({required UserEntity userEntity}) async {
    emit(UserLoading());
    try {
      final streamResponse = getUsersUseCase.call(userEntity);
      streamResponse.listen((users) {
        emit(UserLoaded(users: users));
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> updateUser({required UserEntity userEntity}) async {
    try {
      await updateUserUseCase.call(userEntity);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}
