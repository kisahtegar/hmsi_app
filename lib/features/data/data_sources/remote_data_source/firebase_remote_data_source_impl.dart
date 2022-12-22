import 'package:hmsi_app/features/data/data_sources/remote_data_source/firebase_remote_data_source.dart';
import 'package:hmsi_app/features/domain/entities/user/user_entity.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  @override
  Future<void> createUser(UserEntity userEntity) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<String> getCurrentUid() {
    // TODO: implement getCurrentUid
    throw UnimplementedError();
  }

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) {
    // TODO: implement getSingleOtherUser
    throw UnimplementedError();
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    // TODO: implement getSingleUser
    throw UnimplementedError();
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity userEntity) {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<bool> isSignIn() {
    // TODO: implement isSignIn
    throw UnimplementedError();
  }

  @override
  Future<void> signInUser(UserEntity userEntity) {
    // TODO: implement signInUser
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<void> signUpUser(UserEntity userEntity) {
    // TODO: implement signUpUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(UserEntity userEntity) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
