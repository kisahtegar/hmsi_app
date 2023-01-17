import 'dart:io';

import 'package:hmsi_app/features/data/data_sources/remote_data_source/firebase_remote_data_source.dart';
import 'package:hmsi_app/features/domain/entities/article/article_entity.dart';
import 'package:hmsi_app/features/domain/entities/user/user_entity.dart';
import 'package:hmsi_app/features/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource firebaseRemoteDataSource;

  FirebaseRepositoryImpl({required this.firebaseRemoteDataSource});

  @override
  Future<void> createUser(UserEntity userEntity) async =>
      firebaseRemoteDataSource.createUser(userEntity);

  @override
  Future<String> getCurrentUid() async =>
      firebaseRemoteDataSource.getCurrentUid();

  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid) =>
      firebaseRemoteDataSource.getSingleOtherUser(otherUid);

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) =>
      firebaseRemoteDataSource.getSingleUser(uid);

  @override
  Stream<List<UserEntity>> getUsers(UserEntity userEntity) =>
      firebaseRemoteDataSource.getUsers(userEntity);

  @override
  Future<bool> isSignIn() async => firebaseRemoteDataSource.isSignIn();

  @override
  Future<void> signInUser(UserEntity userEntity) async =>
      firebaseRemoteDataSource.signInUser(userEntity);

  @override
  Future<void> signOut() async => firebaseRemoteDataSource.signOut();

  @override
  Future<void> signUpUser(UserEntity userEntity) async =>
      firebaseRemoteDataSource.signUpUser(userEntity);

  @override
  Future<void> updateUser(UserEntity userEntity) async =>
      firebaseRemoteDataSource.updateUser(userEntity);

  @override
  Future<String> uploadImageToStorage(
          File? file, bool isPost, String childName) async =>
      firebaseRemoteDataSource.uploadImageToStorage(file, isPost, childName);

  @override
  Future<void> createArticle(ArticleEntity articleEntity) async =>
      firebaseRemoteDataSource.createArticle(articleEntity);

  @override
  Future<void> deleteArticle(ArticleEntity articleEntity) async =>
      firebaseRemoteDataSource.deleteArticle(articleEntity);

  @override
  Future<void> likeArticle(ArticleEntity articleEntity) async =>
      firebaseRemoteDataSource.likeArticle(articleEntity);

  @override
  Stream<List<ArticleEntity>> readArticles(ArticleEntity articleEntity) =>
      firebaseRemoteDataSource.readArticles(articleEntity);

  @override
  Future<void> updateArticle(ArticleEntity articleEntity) async =>
      firebaseRemoteDataSource.updateArticle(articleEntity);

  @override
  Stream<List<ArticleEntity>> readSingleArticle(String articleId) =>
      firebaseRemoteDataSource.readSingleArticle(articleId);
}
