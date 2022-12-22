import '../entities/user/user_entity.dart';

abstract class FirebaseRepository {
  // Credential Features
  Future<void> signInUser(UserEntity userEntity);
  Future<void> signUpUser(UserEntity userEntity);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User Features
  Stream<List<UserEntity>> getUsers(UserEntity userEntity);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity userEntity);
  Future<void> updateUser(UserEntity userEntity);
}
