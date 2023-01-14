import 'dart:io';

import 'package:hmsi_app/features/domain/entities/article/article_entity.dart';

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

  // Cloud Storage Features
  Future<String> uploadImageToStorage(
      File? file, bool isPost, String childName);

  // Article Features
  Future<void> createArticle(ArticleEntity articleEntity);
  Stream<List<ArticleEntity>> readArticles(ArticleEntity articleEntity);
  Future<void> updateArticle(ArticleEntity articleEntity);
  Future<void> deleteArticle(ArticleEntity articleEntity);
  Future<void> likeArticle(ArticleEntity articleEntity);
}
