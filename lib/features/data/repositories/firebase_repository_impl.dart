import 'dart:io';

import '../../domain/entities/article/article_entity.dart';
import '../../domain/entities/comment/comment_entity.dart';
import '../../domain/entities/reply/reply_entity.dart';
import '../../domain/entities/user/user_entity.dart';
import '../../domain/repositories/firebase_repository.dart';
import '../data_sources/remote_data_source/firebase_remote_data_source.dart';

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

  @override
  Future<void> createComment(CommentEntity commentEntity) async =>
      firebaseRemoteDataSource.createComment(commentEntity);

  @override
  Future<void> deleteComment(CommentEntity commentEntity) async =>
      firebaseRemoteDataSource.deleteComment(commentEntity);

  @override
  Future<void> likeComment(CommentEntity commentEntity) async =>
      firebaseRemoteDataSource.likeComment(commentEntity);

  @override
  Stream<List<CommentEntity>> readComments(String articleId) =>
      firebaseRemoteDataSource.readComments(articleId);

  @override
  Future<void> updateComment(CommentEntity commentEntity) async =>
      firebaseRemoteDataSource.updateComment(commentEntity);

  @override
  Future<void> createReply(ReplyEntity replyEntity) async =>
      firebaseRemoteDataSource.createReply(replyEntity);

  @override
  Future<void> deleteReply(ReplyEntity replyEntity) async =>
      firebaseRemoteDataSource.deleteReply(replyEntity);

  @override
  Future<void> likeReply(ReplyEntity replyEntity) async =>
      firebaseRemoteDataSource.likeReply(replyEntity);

  @override
  Stream<List<ReplyEntity>> readReplys(ReplyEntity replyEntity) =>
      firebaseRemoteDataSource.readReplys(replyEntity);

  @override
  Future<void> updateReply(ReplyEntity replyEntity) async =>
      firebaseRemoteDataSource.updateReply(replyEntity);
}
